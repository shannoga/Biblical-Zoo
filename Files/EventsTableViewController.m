//
//  EventsTableViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventTableViewCell.h"
#import "EventDetailsViewController.h"
#import "SectionHeaderView.h"

#import "MadadExplinationViewController.h"
#import "Reachability.h"
#import "CGICalendar.h"
#import "MXLCalendar.h"
#import "MXLCalendarManager.h"
#import "EventsController.h"

@interface EventsTableViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) BOOL hasHud;
@end

@implementation EventsTableViewController

- (void)awakeFromNib
{
        // Custom initialization
        
        self.title = [Helper languageSelectedStringForKey:@"Events"];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateCalendar)];
        self.navigationItem.rightBarButtonItem = barItem;
        self.tableView.sectionIndexMinimumDisplayRowCount = 99999999;
   
    
        updateLoopCounter=1;
        shouldUpdateUI=NO;

}



-(void)updateLastUpdateDate{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSDate date] forKey:@"lastCalendarUpdateDate"];
    [ud synchronize];
}

#pragma mark -
#pragma mark Google Calendar API

-(void)showHud{
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    refreshHUD.delegate = self;
    [refreshHUD show:YES];
    refreshHUD.labelText = @"Loading Events";
    [self.view addSubview:refreshHUD];
}
-(void)updateCalendar{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [self fetchAllCalendars];
    return;
    if([reach isReachable]){
        [self fetchAllCalendars];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[Helper languageSelectedStringForKey:@"No Internet Connection"]
                              message:[Helper languageSelectedStringForKey:@"No Internet alert body"]
                              delegate:nil
                              cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                              otherButtonTitles:nil];
		[alert show];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



//step 1



- (void)fetchAllCalendars {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.tableView.scrollEnabled =NO;
    [self.tableView scrollsToTop];
    [self showHud];
    
    [[EventsController sharedController] fetchEventsWithCompletionHandler:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.scrollEnabled =YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [refreshHUD hide:YES];

        });
    }];

}

#pragma mark -
#pragma mark Calendars



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    


   
    //segmentedController
    segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"event_special_small.png"] atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"event_music_small.png"] atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"event_talk_small.png"] atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"event_feeding_small.png"] atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithTitle:[Helper languageSelectedStringForKey:@"All"] atIndex:0 animated:NO];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self
                         action:@selector(reloadTableViewAfterSegmentedControllerChange:)
               forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.selectedSegmentIndex = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    
	self.tableView.rowHeight=70;

//    //update calendar if it is empty
//    if([[Event findAll] count]==0){
//        [self updateCalendar];
//    }
//    else
//    {
//        [[Event findAll] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"event = %@",((Event*)obj).title);
//        }];
//    }
//   
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tableView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if([[self.tableView visibleCells] count]==0 && segmentedControl.selectedSegmentIndex==0){
        
       // [self updateCalendar];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view methods



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[[self fetchedResultsController] sections] count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	
    if ([[[self fetchedResultsController] sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self fetchedResultsController] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[self fetchedResultsController] sectionForSectionIndexTitle:[title capitalizedString] atIndex:index];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo name];
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    
	SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 50)];
	headerView.dateLabelView.text =[sectionInfo name];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(madadExplination)];
    [headerView addGestureRecognizer:tapRecognizer];
    headerView.userInteractionEnabled = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[Helper appLang] == kEnglish?@"en":@"he"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    NSDate *date = [dateFormatter dateFromString:[sectionInfo name]];
    
    
    
    if (date) {
        
        [headerView setaMadad:[Madad madadForDate:date]];
    }else{
        [headerView setaMadad:[Madad madadForDate:nil]];
    }
    
    
	return headerView;
}

-(void)madadExplination{
    MadadExplinationViewController *madadExplination = [[MadadExplinationViewController alloc] initWithNibName:@"MadadExplinationViewController" bundle:nil];
    [self.navigationController pushViewController:madadExplination animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EventTableViewCell *lcell = (EventTableViewCell*)cell;
    [lcell setAnEvent:event];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    if (cell == nil) {	   
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"EventsCell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventDetailsViewController *detailViewController = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsViewController" bundle:[Helper localizationBundle]];
    detailViewController.event = [self.fetchedResultsController objectAtIndexPath:indexPath];
   // [self.navigationController pushViewController:detailViewController animated:YES];
   
    detailViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.navigationController presentModalViewController:detailViewController animated:YES];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController!= nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
    [fetchRequest setEntity:entity];
    
   NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"startDate >= %@",[NSDate date]];
    [fetchRequest setPredicate:newPredicate];
    // Set the batch size to a suitable number.
    //[fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:@"dateToStringForSectionTitels" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    



-(void)reloadTableViewAfterSegmentedControllerChange:(id)sender{
    
    
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    NSString *predicateString;
    switch (sc.selectedSegmentIndex) {
        case 1:
            predicateString=@"Feeding";
            break;
        case 2:
            predicateString=@"Talk";
            break;
        case 3:
            predicateString=@"Music";
            break;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[NSManagedObjectContext defaultContext]];
    [[[self fetchedResultsController] fetchRequest] setEntity:entity];
    
    if (sc.selectedSegmentIndex != 0 && sc.selectedSegmentIndex != 4  ) {
        NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"startDate > %@ AND typeString == %@",[NSDate date],predicateString];
        [[[self fetchedResultsController] fetchRequest] setPredicate:newPredicate];
    }else if (sc.selectedSegmentIndex == 4) {
        NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"startDate > %@ AND typeString == %@ OR typeString == %@ OR typeString== %@",[NSDate date],@"Exhibition",@"Show",@"Workshop"];
        [[[self fetchedResultsController] fetchRequest] setPredicate:newPredicate];
    }else{
         NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"startDate > %@",[NSDate date]];
        [[[self fetchedResultsController] fetchRequest] setPredicate:newPredicate];
    }
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } 
    
    
    
    
    [[self tableView]reloadData];
    
    if([[self.tableView visibleCells] count]==0 && segmentedControl.selectedSegmentIndex==0){
        
        
        // Do any additional setup after loading the view, typically from a nib.
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        headerView.backgroundColor = UIColorFromRGB(0x3A2E23);
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCalendar)];
        
        [headerView addGestureRecognizer:tapRecognizer];
        
        
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        if([Helper appLang]==kHebrew){
            [iconView setFrame:CGRectMake(170, 10, 40, 40)];
        }
        [iconView setImage:[UIImage imageNamed:@"156-Cycle"]];
        [headerView addSubview:iconView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 255, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        
        if([Helper appLang]==kHebrew){
            [label setFrame:CGRectMake(0, 10, 250, 40)];
            label.font= [UIFont fontWithName:@"ArialBold" size:18];
            label.textAlignment = UITextAlignmentRight;
        }else{
            label.font= [UIFont fontWithName:@"Futura" size:20];
        }
        label.text = [Helper languageSelectedStringForKey:@"Tap To Load Events"];
        [headerView addSubview:label];
        
        self.tableView.tableHeaderView = headerView;
    }
    
}

-(void)updateUI{
    shouldUpdateUI=YES;
    // In the simplest, most efficient, case, reload the table view.
    [[NSManagedObjectContext defaultContext] saveNestedContexts];
    updateLoopCounter = 0;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSDate date] forKey:@"lastCalendarUpdateDate"];
    self.tableView.scrollEnabled =YES;
     [refreshHUD hide:YES];
   
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"");
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
   // if (shouldUpdateUI) {
         [self.tableView reloadData];
  //  }

    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end







