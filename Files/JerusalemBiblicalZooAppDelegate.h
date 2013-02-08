// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TileMapViewController.h"

@interface JerusalemBiblicalZooAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate> {
    CLLocationManager *locationManager;
    BOOL subscribedAsVisitor;
}
//core data


@property (nonatomic, strong)  UITabBarController *tabBarController;
@property (nonatomic,retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) TileMapViewController *mapController;
@property (nonatomic, retain) CLRegion *zooRegion;
-(void)buyFullApp;
@end
