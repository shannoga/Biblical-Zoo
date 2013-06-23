//
//  EventsTableViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,MBProgressHUDDelegate>{

    UISegmentedControl *segmentedControl;
    NSString *calendarName;
    NSUInteger fetchCounter;
    MBProgressHUD *refreshHUD;
    NSInteger updateLoopCounter;
    BOOL shouldUpdateUI;
}


-(void)updateCalendar;
@end
