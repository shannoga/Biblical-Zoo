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
#import "Exhibit.h"
#import "Animal.h"
#import "OpeningScreenViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ExhibitTableViewCell.h"
#import "UIView+i7Rotate360.h"
#import "SSZipArchive.h"
#import "Reachability.h"

@interface ExhibitsViewController ()

-(void)storeNewAnimalObjectsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update;
-(void)storeNewExhibitsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update;
-(void)updateExhibitsAndAnimalsImManagedContext:(NSManagedObjectContext*)moc updateExisting:(BOOL)update;

@end

@implementation ExhibitsViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize headerView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Exhibits",nil);
    }
    return self;
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
    
    
    
    BOOL exhibitsHasPendingUpdates =  [[NSUserDefaults standardUserDefaults] boolForKey:@"exhibitsNeedsUpdates"];
    NSString *key = [Helper isRightToLeft]?@"completedExhibitsFirstDownloadingForHe":@"completedExhibitsFirstDownloadingForEn";
    BOOL completedExhibitsFirstDownloading =  [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    
    
    
    CGRect labelRect;
    CGRect iconRect;
    UIFont * font;
    UITextAlignment textAlign;
    
    if ([Helper isRightToLeft]) {
        labelRect = CGRectMake(0, 0, 250, 45);
        iconRect = CGRectMake(170, 2.5, 40, 40);
        font = [UIFont fontWithName:@"ArialBold" size:18];
        textAlign = UITextAlignmentRight;
    }else{
        labelRect = CGRectMake(65, 0, 255, 45);
        iconRect = CGRectMake(10, 2.5, 40, 40);
        font = [UIFont fontWithName:@"Futura" size:20];
        textAlign = UITextAlignmentLeft;
    }
    //nearest exhibit
    
    if(completedExhibitsFirstDownloading){
        
        // Do any additional setup after loading the view, typically from a nib.
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(0, 0, 320, 45);
        refreshButton.backgroundColor = UIColorFromRGB(0x3A2E23);
        [refreshButton addTarget:self action:@selector(findNearestExhibit) forControlEvents:UIControlEventTouchUpInside];
        
        nearestExhibitIconView = [[UIImageView alloc] initWithFrame:iconRect];
        [nearestExhibitIconView setImage:[UIImage imageNamed:@"343-Wand"]];
        [refreshButton addSubview:nearestExhibitIconView];
        
        nearestExhibitLabel = [[UILabel alloc] initWithFrame:labelRect];
        nearestExhibitLabel.backgroundColor = [UIColor clearColor];
        nearestExhibitLabel.textColor = [UIColor whiteColor];
        nearestExhibitLabel.textAlignment = textAlign;
        nearestExhibitLabel.font= font;
        nearestExhibitLabel.text = NSLocalizedString(@"Show Nearest Exhibit",nil);
        [refreshButton addSubview:nearestExhibitLabel];
        [self.headerView addSubview:refreshButton];
        
    }
    if (!completedExhibitsFirstDownloading || exhibitsHasPendingUpdates) {
        
        if (completedExhibitsFirstDownloading) {
            [self.headerView setFrame:CGRectMake(0, 0, 320, 90)];
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(0, 0, 320, 45);
        refreshButton.backgroundColor =  UIColorFromRGB(0xa6d845);
        [refreshButton addTarget:self action:@selector(updateAnimalsData) forControlEvents:UIControlEventTouchUpInside];
        
        [refreshButton becomeFirstResponder];
        refreshAnimalsIconView = [[UIImageView alloc] initWithFrame:iconRect];
        [refreshAnimalsIconView setImage:[UIImage imageNamed:@"156-Cycle"]];
        [refreshButton addSubview:refreshAnimalsIconView];
        
        refreshAnimalsLabel = [[UILabel alloc] initWithFrame:labelRect];
        refreshAnimalsLabel.backgroundColor = [UIColor clearColor];
        refreshAnimalsLabel.textColor = [UIColor whiteColor];
        refreshAnimalsLabel.font= font;
        refreshAnimalsLabel.textAlignment = textAlign;
        if(exhibitsHasPendingUpdates && completedExhibitsFirstDownloading){
            refreshAnimalsLabel.text = NSLocalizedString(@"Update Zoo Exhibits",nil);
        }else{
            refreshAnimalsLabel.text = NSLocalizedString(@"Download Zoo Exhibits",nil);
        }
        
        [refreshButton addSubview:refreshAnimalsLabel];
        
        
        [self.headerView addSubview:refreshButton];
    }
    
    
    BOOL audioGuidesHasPendingUpdates =  [[NSUserDefaults standardUserDefaults] boolForKey:@"audioGuidesNeedsUpdates"];
    key = [Helper isRightToLeft]?@"completedExhibitsAudioGuideHeFiles":@"completedExhibitsAudioGuideEnFiles";
    BOOL completedaudioGuidesFirstDownloading =  [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    
    
    if (!completedaudioGuidesFirstDownloading || audioGuidesHasPendingUpdates) {
        
        
        [self.headerView setFrame:CGRectMake(0, 0, 320, 90)];
        // Do any additional setup after loading the view, typically from a nib.
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(0, 45, 320, 45);
        refreshButton.backgroundColor =  UIColorFromRGB(0xa6d845);
        refreshButton.tag = 999;
        [refreshButton addTarget:self action:@selector(dwonloadAudioGuide) forControlEvents:UIControlEventTouchUpInside];
        
        audioGuideIconView = [[UIImageView alloc] initWithFrame:iconRect];
        [audioGuideIconView setImage:[UIImage imageNamed:@"audioGuide"]];
        [refreshButton addSubview:audioGuideIconView];
        
        audioGuideLabel= [[UILabel alloc] initWithFrame:labelRect];
        audioGuideLabel.backgroundColor = [UIColor clearColor];
        audioGuideLabel.textColor = [UIColor whiteColor];
        audioGuideLabel.font= font;
        audioGuideLabel.textAlignment = textAlign;
        
        if(audioGuidesHasPendingUpdates && completedaudioGuidesFirstDownloading){
            audioGuideLabel.text = NSLocalizedString(@"Update Audio Guides",nil);
        }else{
            audioGuideLabel.text = NSLocalizedString(@"Download Audio Guides",nil);
        }
        
        [refreshButton addSubview:audioGuideLabel];
        
        [self.headerView addSubview:refreshButton];
    }else{
        [UIView animateWithDuration:1 animations:^{
            [self.headerView setFrame:CGRectMake(0, 0, 320, 45)];
            [[self.headerView viewWithTag:999] removeFromSuperview];
        }];
    }
    
    
}

-(void)updateAnimalsData{
    [self updateExhibitsAndAnimalsImManagedContext:[Helper appContext] updateExisting:YES];
    
}


-(void)dwonloadAudioGuide{
    
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
    refreshHUD.labelText = @"Getting Audio Guide Files";
    refreshHUD.mode  = MBProgressHUDModeDeterminate;
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    refreshHUD.labelText = @"Connecting to the server";
    PFQuery *query = [PFQuery queryWithClassName:@"AudioGuides"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects.", objects.count);
            refreshHUD.labelText = @"Downloading files";
            PFObject *AudioGuide = [objects lastObject];
            NSString *key = ![Helper isRightToLeft]?@"enFile":@"heFile";
            PFFile *localGuide = AudioGuide[key];
            
            //– getDataInBackgroundWithBlock:progressBlock:
            [localGuide getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                refreshHUD.labelText = @"Unziping Audio Guide Files";
                NSString *path = [[Helper tempFilesPath] stringByAppendingPathComponent:@"audioFiles.zip"];
                NSURL *fileUrl = [NSURL fileURLWithPath:path];
                
                
                if ([data writeToURL:fileUrl atomically:YES]) {
                    // Unzipping
                    NSString *zipPath = [fileUrl path];
                    NSString *destinationPath = [Helper audioGuideFilesPath];
                    if (![SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath]) {
                        NSLog(@"problen unzipping the file");
                    }else{
                        NSLog(@"file unzipped");
                        // Attempt to delete the file at filePath2
                        if ([[NSFileManager defaultManager] removeItemAtPath:zipPath error:&error] != YES){
                            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
                        }else {
                            refreshHUD.labelText = @"Cleaning";
                            NSLog(@"cleaned up zip file");
                            
                            [refreshHUD hide:YES];
                            
                            
                            [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"audioGuidesNeedsUpdates"];
                            NSInteger updateIndexToSave =  [[NSUserDefaults standardUserDefaults] integerForKey:@"audioGuidesPendingUpdateNumber"];
                            [[NSUserDefaults standardUserDefaults] setInteger:updateIndexToSave forKey:@"audioGuideLocalUpdateIndex"];
                            NSString *key = [Helper isRightToLeft]?@"completedAudioGuideHeFiles":@"completedAudioGuideEnFiles";
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self updateHeaderView];
                        }
                        
                    }
                    
                }else{
                    NSLog(@"File was not saved");
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"%d",percentDone);
                
                CGFloat f = (CGFloat)percentDone;
                
                refreshHUD.progress = f/100;
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (void)findNearestExhibit
{
    
    [nearestExhibitIconView rotate360WithDuration:.5 repeatCount:100 timingMode:i7Rotate360TimingModeLinear];
    
    nearestExhibitLabel.text = @"Finding your location";
    
    // locationManager update as location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent =NO;;
    self.tableView.backgroundColor = UIColorFromRGB(0x95bdc2);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OpeningScreenViewController *openingScreen = [[OpeningScreenViewController alloc] initWithNibName:@"OpeningScreenViewController" bundle:nil];
        [self.navigationController presentModalViewController:openingScreen animated:NO];
    });
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self updateHeaderView];
}

#pragma mark - Table View

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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //cell.backgroundColor = UIColorFromRGBA(0xffffff, .8);
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


- (void)showExhibit:(Exhibit*)exhibit;
{
    [nearestExhibitIconView.layer removeAllAnimations];
    nearestExhibitLabel.text = NSLocalizedString(@"Show Nearest Exhibit",nil);
    NSArray *animals = [exhibit localAnimals];
    
    if ([animals count]==1) {
        AnimalViewController *anialViewController = [[AnimalViewController alloc] init];
        //self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent =YES;
        anialViewController.animal = [animals lastObject];
        [self.navigationController pushViewController:anialViewController animated:YES];
        
    } else if([animals count]>1){
        ExhibitAnimalsViewController * exhibitAnimalsViewController = [[ExhibitAnimalsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        exhibitAnimalsViewController.exhibit = exhibit;
        [self.navigationController pushViewController:exhibitAnimalsViewController animated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"oops Error",nil)
                              message:NSLocalizedString(@"There is a problem with this exhibit we will fix it as soon as possible",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"okay",nil)
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
        refreshHUD.labelText = @"Finding closest exhibit";
        Exhibit *nearesrExhibit = nil;
        CLLocationDistance prevDistance;
        for (Exhibit *exhibit in [Exhibit allObjects]) {
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
    [refreshHUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",nil)
                                                    message:NSLocalizedString(@"Failed to find your location ",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"O.K",nil)
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
    NSLog(@"reach  = %@",[reach isReachable]? @"YES":@"NO");
    
    if([reach isReachable]){
        
        refreshAnimalsLabel.text= @"Downloading Exhibits";
        [refreshAnimalsIconView rotate360WithDuration:.5 repeatCount:HUGE_VALF timingMode:i7Rotate360TimingModeLinear];
        [self storeNewExhibitsLocallyInContext:moc updateOldEntities:update];
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                              message:NSLocalizedString(@"If you don't have intenrt services you can find an Internet acsses in the enternce to the zoo",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"okay",nil)
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)storeNewAnimalObjectsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update{
    [refreshAnimalsIconView rotate360WithDuration:.5 repeatCount:HUGE_VALF timingMode:i7Rotate360TimingModeLinear];
    NSString *localAnimalParseClass = ![Helper isRightToLeft]?@"AnimalEn":@"AnimalHe";
    PFQuery *query = [PFQuery queryWithClassName:localAnimalParseClass];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query.maxCacheAge = 60 * 60 * 24;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //The find succeeded.
        if (!error) {
            refreshAnimalsLabel.text= NSLocalizedString(@"Saving Animals Data",nil);
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
            refreshAnimalsLabel.text= NSLocalizedString(@"Completed",nil);
            [refreshAnimalsIconView.layer removeAllAnimations];
            
            
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
    
    
}

-(void)storeNewExhibitsLocallyInContext:(NSManagedObjectContext*)moc updateOldEntities:(BOOL)update{
    PFQuery *query = [PFQuery queryWithClassName:@"Exhibit"];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query.maxCacheAge = 60 * 60 * 24;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //The find succeeded.
            refreshAnimalsLabel.text= NSLocalizedString(@"Creating Exhibits",nil);
            for (PFObject *object in objects) {
                NSString *objectId = [object valueForKey:@"objectId"];
                if ([ParseHelper existOnLocalDBForEntityName:@"Exhibit" byObjectId:objectId inContext:moc]) {
                    if (update) {
                        [Exhibit updateFromParseExhibitObject:object inContext:moc];
                    }
                }else{
                    [Exhibit createFromParseExhibitObject:object inContext:moc];
                }
            }
            refreshAnimalsLabel.text= NSLocalizedString(@"Downloading Animals",nil);
            
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


