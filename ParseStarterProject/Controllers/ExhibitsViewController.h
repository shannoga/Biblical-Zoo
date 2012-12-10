//
//  ExhibitsViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
@interface ExhibitsViewController : UITableViewController <NSFetchedResultsControllerDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>{
    CLLocationManager *locationManager;
    MBProgressHUD *refreshHUD;
    UIImageView *audioGuideIconView;
    UIImageView *refreshAnimalsIconView;
    UIImageView *nearestExhibitIconView;
    UILabel *audioGuideLabel;
    UILabel *refreshAnimalsLabel;
    UILabel *nearestExhibitLabel;
    UIView * headerView;

}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIView * headerView;


@end
