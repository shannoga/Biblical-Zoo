// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import "Parse/Parse.h"
#import "JerusalemBiblicalZooAppDelegate.h"
#import "EventsTableViewController.h"
#import "TileMapViewController.h"
#import "NewsListViewController.h"
#import "FunViewController.h"
#import "ExhibitsViewController.h"
#import "Reachability.h"
#import "AnimalDataTabBarController.h"
@implementation JerusalemBiblicalZooAppDelegate


@synthesize tabBarController;
@synthesize window;
@synthesize mapController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    subscribedAsVisitor = NO;
    //set up core data
    [self setUpMagicalRecord];
    //set up parse
    [self setUpParse];
    //set the appearence of the app
    [self setUIAppearence];
    //start tracking user location
#warning check for next realese 
    //[self startLocationServices];
    //check for updates
  //  [self checkForUpdates];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    
  //  [self setUpTabBarControllers];
    
    
    BOOL askedUser = [[NSUserDefaults standardUserDefaults] boolForKey:@"answeredBugsense"];
    BOOL agreed = [[NSUserDefaults standardUserDefaults] boolForKey:@"agreedBugsense"];
    
    if(!askedUser){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please let us improve!" message:@"By tapping confirm below you permit the app to send us crash reports, log files and basic usage statistics. This data is completely anonymous and will be used only to improve this app." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Deny",@"Confirm", nil];
    [alert show];
    }else if(agreed){
        [BugSenseController sharedControllerWithBugSenseAPIKey:@"e12a5b10"];
    }
    if([Helper bugsenseOn]) [BugSenseController leaveBreadcrumb:@"app did launch"];
    
  
    
    return YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSUserDefaults standardUserDefaults] setBool:YES   forKey:@"answeredBugsense"];

    switch (buttonIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"agreedBugsense"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setBool:YES   forKey:@"agreedBugsense"];
            [BugSenseController sharedControllerWithBugSenseAPIKey:@"e12a5b10"];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)startLocationServices{
    
    if([CLLocationManager locationServicesEnabled]){
        if (locationManager==nil) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        [locationManager startUpdatingLocation];
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocation * mapCenterLocation = [[CLLocation alloc] initWithLatitude:31.746233 longitude:35.174095];
    if( [newLocation distanceFromLocation:mapCenterLocation]<1000){
        if (!subscribedAsVisitor) {
            [self subscribeForVisitorNotification];
        }
        
        [self startMonitoringZooRegion];
         [locationManager stopUpdatingLocation];
        
    }else{
        if (subscribedAsVisitor) {
            [self unsubscribeForVisitorNotification];
        }
        [self stopMonitoringZooRegion];
        [locationManager stopUpdatingLocation];
     
        
    }
   

}
-(CLRegion*)zooRegion{
    if(_zooRegion==nil){
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(31.746233, 35.174095);
    
    _zooRegion = [[CLRegion alloc] initCircularRegionWithCenter:center
                                                               radius:1000
                                                           identifier:@"zooRegion"];
    }
    return _zooRegion;
}
-(void)stopMonitoringZooRegion{
    [locationManager stopMonitoringForRegion:_zooRegion];

}
-(void)startMonitoringZooRegion
{
    BOOL monitoring = NO;
    if ( [CLLocationManager regionMonitoringAvailable] ) {
        if ( [CLLocationManager regionMonitoringEnabled] ) {
            if( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ) {
                monitoring = YES;
                if (locationManager==nil) {
                    locationManager = [[CLLocationManager alloc] init];
                    locationManager.delegate = self;
                }
            } else {
                NSLog( @"app is not authorized for location monitoring" );
            }
        } else {
            NSLog( @"region monitoring is not enabled" );
        }
    } else {
        NSLog( @"region monitoring is not available" );
    }
    if( !monitoring ) return;
  
    [locationManager startMonitoringForRegion:_zooRegion desiredAccuracy:kCLLocationAccuracyBest];
}

-(void)locationManager:(CLLocationManager*)manager didStartMonitoringForRegion:(CLRegion*)region
{
    NSLog( @"region monitoring started" );
}

- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    NSLog( @"region monitoring failed" );
    [locationManager stopMonitoringForRegion:region];
}

-(void) locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    NSLog( @"did enter region" );
}

-(void) locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog( @"did exit region" );
    [locationManager stopMonitoringForRegion:region];
    [locationManager stopUpdatingLocation];
    [self unsubscribeForVisitorNotification];
    //add alert for bye bye
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Bye Bye"]
                                                    message:[Helper languageSelectedStringForKey:@"We hope to see you back soon"]
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)subscribeForVisitorNotification{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    if([reach isReachable]){
    [PFPush subscribeToChannelInBackground:[Helper visitoresChannelName] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the Visitors channel.");
            subscribedAsVisitor = YES;
        } else {
            NSLog(@"Failed to subscribe to the Visitors channel.");
        }
    }];
    }
    
}
-(void)unsubscribeForVisitorNotification{
   
    [PFPush unsubscribeFromChannelInBackground:[Helper visitoresChannelName]  block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            subscribedAsVisitor = NO;
            NSLog(@"Successfully Unsubscribed to the Visitors channel.");
        } else {
            NSLog(@"Failed to Unsubscribe to the Visitors channel.");
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied) {
        [self stopMonitoringZooRegion];
        [locationManager stopUpdatingLocation];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"location services error title"]
                                                        message:[Helper languageSelectedStringForKey:@"location services error body"]
                                                       delegate:self
                                              cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                              otherButtonTitles:nil, nil];
          [alert show];
    }else{
        [self stopMonitoringZooRegion];
        [locationManager stopUpdatingLocation];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"location services error title"]
                                                        message:[Helper languageSelectedStringForKey:@"location services error body"]
                                                       delegate:self
                                              cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusDenied) {
        [self stopMonitoringZooRegion];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"location services error title"
                                                        message:@"location services error body"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        [locationManager startUpdatingLocation];
    }

}



-(void)setUIAppearence{
    
    self.window.tintColor = [UIColor colorWithRed:0.925 green:0.282 blue:0.090 alpha:1];
//    [[UITableViewCell appearance] setBackgroundColor:[UIColor colorWithRed:0.933 green:0.949 blue:0.902 alpha:1]];

   // [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] ];
  //  [[UITabBar appearance] setTintColor:UIColorFromRGB(0xD9593A)];
//    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UITabBar appearanceWhenContainedIn:[AnimalDataTabBarController class], nil] setBackgroundImage:[UIImage imageNamed:@"nav_pattern_baje"] ];
//    [[UITabBar appearanceWhenContainedIn:[AnimalDataTabBarController class], nil] setBackgroundColor:UIColorFromRGB(0xf8eddf)];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] forBarMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x8C9544)];
//    [[UIToolbar appearance] setTintColor:UIColorFromRGB(0xBDB38C)];
//    [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xEFF1E7)];
////    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x3B2F24)];
//    [[UITabBar appearanceWhenContainedIn:[AnimalDataTabBarController class], nil] setSelectedImageTintColor:UIColorFromRGB(0x69742C)];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:0.933 green:0.949 blue:0.902 alpha:1]];
}
-(void)setUpMagicalRecord{
    // [MagicalRecord setupCoreDataStack];
    
    
    BOOL firstLunch= NO;
    NSError *error = nil;
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"JerusalemBiblicalZooSeed.sqlite"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        firstLunch = YES;
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"JerusalemBiblicalZooSeed" ofType:@"sqlite"];
        if (defaultStorePath) {
            if(![fileManager copyItemAtPath:defaultStorePath toPath:storePath error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    }
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"JerusalemBiblicalZooSeed.sqlite"];
    
    if (firstLunch) {
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"agreedBugsense"];
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"answeredBugsense"];
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"exhibitsNeedsUpdates"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"exhibitLocalUpdateIndex"];
        [[NSUserDefaults standardUserDefaults] setInteger:kHebrew forKey:@"lang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

-(void)setUpParse{
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"eT0jBVvhDb7bCk277TaGsnFFTl2msWervtRf2aUF"
                  clientKey:@"P6NqppUhsQZkCdZnnxAOE5SuL95ET7NzIvhDxPMk"];
    [Parse offlineMessagesEnabled:NO];
    //
    // If you are using Facebook, uncomment and fill in with your Facebook App Id:
    [PFFacebookUtils initializeWithApplicationId:@"312934405399723"];
    // ****************************************************************************
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    // Optionally enable public read access by default.
    [defaultACL setPublicReadAccess:YES];
    //[PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    


}

-(void)setUpTabBarControllers{
    
    
    UITabBarController* tabBar = (UITabBarController *)self.window.rootViewController;
    
    // reload the storyboard in the selected language
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[Helper currentLang] ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
    // reload the view controllers
    UINavigationController *exhibitsController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"ExhibitsNavController"];
    UINavigationController *eventsNavController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"EventsNavController"];
    UINavigationController *mapNavController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"MapNavController"];
    UINavigationController *newsNavController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"NewsNavController"];
    UINavigationController *funNavController = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"FunNavController"];
    
    // set them
    NSArray *newViewControllers = @[exhibitsController, eventsNavController, mapNavController, newsNavController, funNavController];
    tabBar.viewControllers = newViewControllers;

    [eventsNavController.viewControllers[0] updateCalendar];
}

-(void)refreshViewControllersAfterLangChange{
    [self setUpTabBarControllers];
}
-(void)checkForUpdates{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    if([reach isReachable]){
        //Check for exhibits updates
        PFQuery *query = [PFQuery queryWithClassName:@"Updates"];
        [query getObjectInBackgroundWithId:@"9DTc1QlpRg" block:^(PFObject *object, NSError *error) {
            NSInteger exhibitsUpdatesNumberOnServer = [object[@"updateNumber"] intValue];
            NSInteger exhibitsUpdatesNumberOnLocal =  [[NSUserDefaults standardUserDefaults] integerForKey:@"exhibitLocalUpdateIndex"];
            
            NSLog(@"server = %i    |    local = %i",exhibitsUpdatesNumberOnServer,exhibitsUpdatesNumberOnLocal);
            if(exhibitsUpdatesNumberOnServer > exhibitsUpdatesNumberOnLocal){
                NSLog(@"Found updates for exhibits");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"exhibitsNeedsUpdates"];
                [[NSUserDefaults standardUserDefaults] setInteger:exhibitsUpdatesNumberOnServer forKey:@"exhibitPendingUpdateNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                NSLog(@"No updates for exhibits");
            }
        }];
    }else{
        NSLog(@"Cannot check for updates");
    }
  
  
}

-(NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}



///////////////////////////////////////////////////////////
// Uncomment these two methods if you are using Facebook
///////////////////////////////////////////////////////////
 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{

    [PFPush storeDeviceToken:newDeviceToken];
    
    NSString *allUsersCahnnel;
    
    if([Helper appLang]==kEnglish){
         allUsersCahnnel = @"All_Users_En";
    }else{
         allUsersCahnnel = @"All_Users_He";
    }
        [PFPush subscribeToChannelInBackground:allUsersCahnnel block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Successfully subscribed to the AllUsers channel.");
            } else {
                NSLog(@"Failed to subscribe to the AllUsers channel.");
            }
        }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ([error code] == 3010) {
        NSLog(@"Push notifications don't work in the simulator!");
    } else {
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // [self startLocationServices];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self stopMonitoringZooRegion];
    [locationManager stopUpdatingLocation];
     if (subscribedAsVisitor) {
         [self unsubscribeForVisitorNotification];
     }
    [MagicalRecord cleanUp];
}





@end
