//
//  ExhibitsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ExhibitsViewController.h"
#import "AnimalViewController.h"
#import "ExhibitAnimalsViewController.h"
#import "OpeningScreenViewController.h"
#import "ExhibitTableViewCell.h"
#import "UIView+i7Rotate360.h"
#import "Reachability.h"
#import "ZooInfoViewController.h"

@interface ExhibitsViewController ()

-(void)storeNewAnimalObjectsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update;
-(void)storeNewExhibitsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update;
-(void)updateExhibitsAndAnimalsImManagedContext:(NSManagedObjectContext*)moc updateExisting:(BOOL)update;

@end

@implementation ExhibitsViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize headerView;
@synthesize headerButtonIconView;
@synthesize headerButtonLabel;
@synthesize headerButton;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Exhibits",nil);
        /*
        if (DEBUG) {
            UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateAnimalsData)];
            self.navigationItem.rightBarButtonItem = barItem;
        }
        */
        if(![Helper isLion]){
            [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(unlock) name:@"unlock-feature"  object: nil];
        }
        
        UIBarButtonItem *infoBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Info", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showInfoController)];
        self.navigationItem.leftBarButtonItem = infoBarItem;

    }
    return self;
}

-(void)unlock{

    self.fetchedResultsController = nil;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error in refetch: %@",[error localizedDescription]);
        abort();
    }
    
    [self.tableView reloadData];
    [self.tableView.tableFooterView removeFromSuperview];
    [self updateHeaderView];
}

-(void)showInfoController{
   ZooInfoViewController * zooInfo = [[ZooInfoViewController alloc] init];
    zooInfo.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.navigationController presentModalViewController:zooInfo animated:YES];
}

-(void)buyFullApp{
    [[Helper appDelegate] buyFullApp];
}

-(void)dismissWithChanges:(BOOL)changes{
    if (changes) {
        [self.tableView reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    CGRect labelRect;
    CGRect iconRect;
    UIFont * font;
    UITextAlignment textAlign;
    
    if ([Helper isRightToLeft]) {
        labelRect = CGRectMake(0, 7, 260, 60);
        iconRect = CGRectMake(275, 15, 30, 30);
        font = [UIFont fontWithName:@"ArialHebrew-Bold" size:20];
        textAlign = UITextAlignmentRight;
    }else{
        labelRect = CGRectMake(65, 0, 255, 60);
        iconRect = CGRectMake(10, 15, 30, 30);
        font = [UIFont fontWithName:@"Futura" size:20];
        textAlign = UITextAlignmentLeft;
    }
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerButton.frame = CGRectMake(0, 0, 320, 60);
    
    self.headerButtonIconView = [[UIImageView alloc] initWithFrame:iconRect];
    
    self.headerButtonLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.headerButtonLabel.backgroundColor = [UIColor clearColor];
    self.headerButtonLabel.textColor = [UIColor whiteColor];
    self.headerButtonLabel.font= font;
    self.headerButtonLabel.textAlignment = textAlign;
    
    [self.headerButton addSubview:self.headerButtonLabel];
    [self.headerButton addSubview:self.headerButtonIconView];
    [self.headerView addSubview:self.headerButton];
 
    self.tableView.tableHeaderView = self.headerView;
    
    [self updateHeaderView];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)updateHeaderView{
    [self.headerButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    exhibitsHasPendingUpdates =  [[NSUserDefaults standardUserDefaults] boolForKey:@"exhibitsNeedsUpdates"];

    if(![Helper isLion]){
        self.headerButton.backgroundColor = UIColorFromRGB(0xC95000);
        [self.headerButton addTarget:self action:@selector(buyFullApp) forControlEvents:UIControlEventTouchUpInside];
        [self.headerButtonIconView setImage:[UIImage imageNamed:@"302-Unlock.png"]];
        self.headerButtonLabel.text = NSLocalizedString(@"Buy Full App",nil);

    }else if (exhibitsHasPendingUpdates) {
        // Do any additional setup after loading the view, typically from a nib.
        self.headerButton.backgroundColor = UIColorFromRGB(0x3A2E23);
        [self.headerButton addTarget:self action:@selector(updateAnimalsData) forControlEvents:UIControlEventTouchUpInside];
        [self.headerButtonIconView setImage:[UIImage imageNamed:@"156-Cycle"]];
        if(exhibitsHasPendingUpdates)self.headerButtonLabel.text = NSLocalizedString(@"Update available for exhibits",nil);

    }else{
        //nearest exhibit        
        self.headerButton.backgroundColor = UIColorFromRGB(0x8C9544);
        [self.headerButton addTarget:self action:@selector(findNearestExhibit) forControlEvents:UIControlEventTouchUpInside];
        [self.headerButtonIconView setImage:[UIImage imageNamed:@"343-Wand"]];
        [self.headerButton addSubview:self.headerButtonIconView];
        self.headerButtonLabel.text = NSLocalizedString(@"Show Nearest Exhibit",nil);
  
    }
    
    
}

-(void)updateAnimalsData{
    [self updateExhibitsAndAnimalsImManagedContext:[NSManagedObjectContext defaultContext] updateExisting:YES];
    
}



- (void)findNearestExhibit
{
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed) {
   
    [self.headerButtonIconView rotate360WithDuration:.5 repeatCount:100 timingMode:i7Rotate360TimingModeLinear];
    self.headerButtonLabel.text = NSLocalizedString(@"Finding your location",nil);
    
    // locationManager update as location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"location services error title",nil)
                                                        message:NSLocalizedString(@"location services error body",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent =NO;;
    self.tableView.backgroundColor = UIColorFromRGB(0xBDB38C);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGBA(0xffffff, .2);
    self.tableView.rowHeight = 60;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OpeningScreenViewController *openingScreen = [[OpeningScreenViewController alloc] initWithNibName:@"OpeningScreenViewController" bundle:nil];
        [self.navigationController presentModalViewController:openingScreen animated:NO];
    });
    
   
}

#pragma mark - Table View
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Exhibit *exhibit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ExhibitTableViewCell *lcell = (ExhibitTableViewCell*)cell;
    
    [lcell setAnExhibit:exhibit];
    
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ExhibitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}




- (void)showExhibit:(Exhibit*)exhibit;
{
    [self.headerButtonIconView.layer removeAllAnimations];
    [self updateHeaderView];
    NSArray *animals = [exhibit localAnimals];
    if ([animals count]==1) {
        AnimalViewController *anialViewController = [[AnimalViewController alloc] init];
        if(!IS_IPHONE_5){
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            self.navigationController.navigationBar.translucent =YES;
        }
        anialViewController.animal = [animals lastObject];
        [self.navigationController pushViewController:anialViewController animated:YES];
        
    } else if([animals count]>1){
        ExhibitAnimalsViewController * exhibitAnimalsViewController = [[ExhibitAnimalsViewController alloc] initWithStyle:UITableViewStylePlain];
        exhibitAnimalsViewController.exhibit = exhibit;
        [self.navigationController pushViewController:exhibitAnimalsViewController animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"oops Error",nil)
                              message:NSLocalizedString(@"There is a problem with this exhibit we will fix it as soon as possible",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                              otherButtonTitles:nil];
        [alert show];
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Exhibit *exhibit = (Exhibit*) [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self showExhibit:exhibit];
}



- (CLLocationCoordinate2D)coordinateForExhibit:(Exhibit*)exhibit;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [exhibit.latitude doubleValue];
    theCoordinate.longitude = [exhibit.longitude doubleValue];
    return theCoordinate;
}

-(void) locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *) newLocation
           fromLocation: (CLLocation *) oldLocation{
    
    [locationManager stopUpdatingLocation];
    
    if(newLocation){
        refreshHUD.labelText = @"Locating nearest exhibit";
        Exhibit *nearesrExhibit = nil;
        CLLocationDistance prevDistance;
        for (Exhibit *exhibit in [Exhibit findAll]) {
            CLLocationCoordinate2D  coor= [self coordinateForExhibit:exhibit];
            CLLocation *exhibitLocation = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
            CLLocationDistance currentDistance = [newLocation distanceFromLocation:exhibitLocation];
            
            if(nearesrExhibit == nil){
                nearesrExhibit = exhibit;
                prevDistance = currentDistance;
            }else{
                if (prevDistance > currentDistance) {
                    nearesrExhibit = exhibit;
                    prevDistance = currentDistance;
                }
            }
        }
        if (nearesrExhibit!=nil) {
            [self showExhibit:nearesrExhibit];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.headerButtonIconView.layer removeAllAnimations];
    [self updateHeaderView];
    //Unable to determine your location
    //Please check your location settings in the iphone settings
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"location services error title",nil)
                                                    message:NSLocalizedString(@"location services error body",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exhibit" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
    [fetchRequest setEntity:entity];
    
    if (![Helper isLion]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"free = %@",@YES];
        [fetchRequest setPredicate:predicate];
    }
    
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    NSString *key = ![Helper isRightToLeft]?@"nameEn":@"name";
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [[self tableView] reloadData];
    [self updateHeaderView];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}


#pragma mark -
#pragma mark updating exhibits methods

-(void)updateExhibitsAndAnimalsImManagedContext:(NSManagedObjectContext*)moc updateExisting:(BOOL)update{
    
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if([reach isReachable]){
        
        self.headerButtonLabel.text= NSLocalizedString(@"Downloading Exhibits",nil);
        [self.headerButtonIconView rotate360WithDuration:.5 repeatCount:HUGE_VALF timingMode:i7Rotate360TimingModeLinear];
        [self storeNewExhibitsLocallyInContext:moc updateOldEntities:update];
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                              message:NSLocalizedString(@"No Internet alert body",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)storeNewAnimalObjectsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update{
    [self.headerButtonIconView rotate360WithDuration:.5 repeatCount:HUGE_VALF timingMode:i7Rotate360TimingModeLinear];
    NSString *localAnimalParseClass = ![Helper isRightToLeft]?@"AnimalEn":@"AnimalHe";
    PFQuery *query = [PFQuery queryWithClassName:localAnimalParseClass];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query.maxCacheAge = 60 * 60 * 24;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //The find succeeded.
        if (!error) {
            self.headerButtonLabel.text= NSLocalizedString(@"Saving Animals Data",nil);
            for (PFObject *object in objects) {
                NSString *objectId = [object valueForKey:@"objectId"];
                if ([ParseHelper existOnLocalDBForEntityName:@"Animal" byObjectId:objectId inContext:moc]) {
                    if (update) {
                        [Animal updateFromParseAnimalObject:object inContext:moc];
                    }
                }else{
                    NSString *local = [Helper isRightToLeft]?@"he":@"en";
                    [Animal createFromParseAnimalObject:object forLocal:local inContext:moc];
                }
                
            }
            self.headerButtonLabel.text= NSLocalizedString(@"Completed",nil);
            [self.headerButtonIconView.layer removeAllAnimations];
            
            
            NSString *key = [Helper isRightToLeft]?@"completedExhibitsFirstDownloadingForHe":@"completedExhibitsFirstDownloadingForEn";
            
            [[NSUserDefaults standardUserDefaults] setBool:YES   forKey:key];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"exhibitsNeedsUpdates"];
            //set the new update index
            NSInteger updateIndexToSave =  [[NSUserDefaults standardUserDefaults] integerForKey:@"exhibitPendingUpdateNumber"];
            [[NSUserDefaults standardUserDefaults] setInteger:updateIndexToSave forKey:@"exhibitLocalUpdateIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self updateHeaderView];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", [error description]);
            if ([error code] == kPFErrorObjectNotFound) {
                NSLog(@"Uh oh, we couldn't find the object!");
                // Now also check for connection errors:
            } else if ([error code] == kPFErrorConnectionFailed) {
                NSLog(@"Uh oh, we couldn't even connect to the Parse servers!");
            }
        }
    }];
    
    [[NSManagedObjectContext defaultContext] saveNestedContexts];
}

-(void)storeNewExhibitsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update{
    PFQuery *query = [PFQuery queryWithClassName:@"Exhibit"];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //The find succeeded.
            self.headerButtonLabel.text= NSLocalizedString(@"Creating Exhibits",nil);
            
            //check for exhibits to delete
            NSInteger localCount = [[Exhibit numberOfEntities] integerValue];
            NSInteger objectsCount = [objects count];
            BOOL deleteCheck = localCount>objectsCount;
        
            NSMutableArray *objectsIdForDeleteCheck = [NSMutableArray array];
            for (PFObject *object in objects) {
                NSString *objectId = [object valueForKey:@"objectId"];
                
                if(deleteCheck){
                [objectsIdForDeleteCheck addObject:objectId];
                }
                
                if ([ParseHelper existOnLocalDBForEntityName:@"Exhibit" byObjectId:objectId inContext:moc]) {
                    if (update) {
                        [Exhibit updateFromParseExhibitObject:object inContext:moc];
                    }
                }else{
                    [Exhibit createFromParseExhibitObject:object inContext:moc];
                }
            }
            
            if (deleteCheck) {
               // NSMutableArray *localObjectsId = [NSMutableArray array];
                for (Exhibit * localExhibit in [Exhibit findAll]) {
                    //[localObjectsId addObject:localExhibit.objectId];
                    if (![objectsIdForDeleteCheck containsObject:localExhibit.objectId]) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId = %@",localExhibit.objectId];
                        NSLog(@"Deleting %@",localExhibit.nameEn);
                        [Exhibit deleteAllMatchingPredicate:predicate];
                        
                    }
                }
                [[NSManagedObjectContext defaultContext] saveNestedContexts];
            }
            
            self.headerButtonLabel.text= NSLocalizedString(@"Downloading Animals",nil);
            [self storeNewAnimalObjectsLocallyInContext:moc updateOldEntities:update];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", [error description]);
            if ([error code] == kPFErrorObjectNotFound) {
                NSLog(@"Uh oh, we couldn't find the object!");
                // Now also check for connection errors:
            } else if ([error code] == kPFErrorConnectionFailed) {
                NSLog(@"Uh oh, we couldn't even connect to the Parse servers!");
            }
        }
        
    }];
    
    
}



@end


