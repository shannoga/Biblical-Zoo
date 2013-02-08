//
//  News.m
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NewsListViewController.h"
#import "NewsWebViewController.h"
#import "NewsCell.h"
#import "Reachability.h"

@implementation NewsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        self.title = NSLocalizedString(@"News",nil); 
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshObjects)];
        self.navigationItem.rightBarButtonItem = barItem;
        
        // The className to query on
        self.className = @"News";
        
        self.tableView.backgroundColor = UIColorFromRGB(0x8C817B);
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
    
        self.loadingViewEnabled = NO;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 6;
        
       
    }
    return self;
}

-(void)refreshObjects{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if([reach isReachable]){
        [self loadObjects];
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



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight=100;
    self.tableView.sectionIndexMinimumDisplayRowCount=200;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [refreshHUD hide:YES];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    refreshHUD.labelText = NSLocalizedString(@"Loading", nil);
    [refreshHUD show:YES];
    // This method is called before a PFQuery is fired to get more objects
}
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     PFQuery *query = [PFQuery queryWithClassName:self.className];
     
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 

- (void)configureCell:(NewsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *object = (self.objects)[indexPath.row];
    NewsCell *lcell = (NewsCell*)cell;
    [lcell setNews:object atIndex:indexPath.row];
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the first key in the object. 
- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
     static NSString *CellIdentifier = @"Cell";
     
     NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (!cell) {
         cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier];
     }
      
    [cell setNews:object atIndex:indexPath.row];
     
 
 return cell;
 }
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row < [self.objects count]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        PFObject *newsObject = (self.objects)[indexPath.row];

        NewsWebViewController *viewController = [[NewsWebViewController alloc] initWithObject:newsObject];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        NSLog(@"reach  = %@",[reach isReachable]? @"YES":@"NO");
        
        if(![reach isReachable]){
          
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                                  message:NSLocalizedString(@"No Internet alert body",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
	hud = nil;
}

@end



