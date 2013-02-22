// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TileMapViewController.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"

@interface JerusalemBiblicalZooAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,SKPaymentTransactionObserver> {
    CLLocationManager *locationManager;
    BOOL subscribedAsVisitor;
    MBProgressHUD *HUD;
}
//core data


@property (nonatomic, strong)  UITabBarController *tabBarController;
@property (nonatomic,retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) TileMapViewController *mapController;
@property (nonatomic, retain) CLRegion *zooRegion;
-(void)buyFullApp:(BOOL)restore;
-(void)refreshViewControllersAfterLangChange;
@end
