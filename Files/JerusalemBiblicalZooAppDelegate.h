// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JerusalemBiblicalZooAppDelegate : NSObject <UIApplicationDelegate,CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}
//core data


@property (nonatomic, strong)  UITabBarController *tabBarController;
@property (nonatomic,retain) IBOutlet UIWindow *window;


- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error;
-(void)buyFullApp;
@end
