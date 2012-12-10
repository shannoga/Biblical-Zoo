// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>


@interface JerusalemBiblicalZooAppDelegate : NSObject <UIApplicationDelegate> {

}
//core data


@property (nonatomic, strong)  UITabBarController *tabBarController;
@property (nonatomic,retain) IBOutlet UIWindow *window;


- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error;
@end
