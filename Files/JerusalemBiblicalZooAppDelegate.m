// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import "Parse/Parse.h"
#import "JerusalemBiblicalZooAppDelegate.h"
#import "EventsTableViewController.h"
#import "TileMapViewController.h"
#import "NewsListViewController.h"
#import "FunViewController.h"
#import "ExhibitsViewController.h"
#import "Reachability.h"

@implementation JerusalemBiblicalZooAppDelegate


@synthesize tabBarController;
@synthesize window;
@synthesize mapController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //set up core data
    [self setUpMagicalRecord];
    //set up parse
    [self setUpParse];
    //set the appearence of the app
    [self setUpAppearence];
    //start tracking user location
    [self startLocationServices];
    //check for updates
    [self checkForUpdates];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
   // NSLog(@"notifications = %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
 
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self setUpTabBarControllers];
    
    
    BOOL askedUser = [[NSUserDefaults standardUserDefaults] boolForKey:@"answeredBugsense"];
    BOOL agreed = [[NSUserDefaults standardUserDefaults] boolForKey:@"agreedBugsense"];
    
    if(!askedUser){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help us better this app" message:@"Do you agree to send us data abpult the app functionality" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No Thanks",@"O.K", nil];
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
        NSLog(@"user is in zoo");
        [self subscribeForVisitorNotification];
        
    }else{
        NSLog(@"user is not in the zoo");
       [self unsubscribeForVisitorNotification];
        [locationManager stopUpdatingLocation];
    }
   

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
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(31.746233, 35.174095);
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:center
                                                               radius:1000
                                                           identifier:@"zooRegion"];
    NSLog( @"trying to start monitoring for region %@", region );
    [locationManager startMonitoringForRegion:region desiredAccuracy:kCLLocationAccuracyBest];
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
    //add alert for bye bye
}

-(void)subscribeForVisitorNotification{
     
    [PFPush subscribeToChannelInBackground:[Helper visitoresChannelName] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the Visitors channel.");
        } else {
            NSLog(@"Failed to subscribe to the Visitors channel.");
        }
    }];
    
}
-(void)unsubscribeForVisitorNotification{
   
    [PFPush unsubscribeFromChannelInBackground:[Helper visitoresChannelName]  block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully Unsubscribed to the Visitors channel.");
        } else {
            NSLog(@"Failed to Unsubscribe to the Visitors channel.");
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"location services error title",nil)
                                                        message:NSLocalizedString(@"location services error body",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                              otherButtonTitles:nil, nil];
          [alert show];
    }else{
        [locationManager stopUpdatingLocation];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"location services error title",nil)
                                                        message:NSLocalizedString(@"location services error body",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusDenied) {
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



-(void)setUpAppearence{
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] ];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_tile"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x8C9544)];
    [[UIToolbar appearance] setTintColor:UIColorFromRGB(0xBDB38C)];
    [[UITabBar appearance] setSelectedImageTintColor:UIColorFromRGB(0xC95000)];
    [[UITableView appearance] setBackgroundColor:UIColorFromRGB(0xBDB38C)];
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
    
    // Use the product identifier from iTunes to register a handler.
    [PFPurchase addObserverForProduct:@"Pro" block:^(SKPaymentTransaction *transaction) {
        // Write business logic that should run once this product is purchased.
        if([Helper bugsenseOn]) [BugSenseController sendCustomEventWithTag:@"app purchesed"];
        if([Helper bugsenseOn]) [BugSenseController leaveBreadcrumb:@"app purchesed"];
    }];

}
-(void)setUpTabBarControllers{
    
    // Create a tabbar controller and an array to contain the view controllers
    self.tabBarController = [[UITabBarController alloc] init];
	
    NSMutableArray *localViewControllersArray = [NSMutableArray array];
    
    ExhibitsViewController *exhibitsViewController = [[ExhibitsViewController alloc] initWithStyle:UITableViewStylePlain];
    exhibitsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Exhibits", nil) image:[UIImage imageNamed:@"exhibits"] tag:0];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:exhibitsViewController];
	[localViewControllersArray addObject:nc];
    
  
    
    EventsTableViewController *eventsTableViewController = [[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    eventsTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Events", nil) image:[UIImage imageNamed:@"020-Appointment"] tag:1];
    nc = [[UINavigationController alloc]initWithRootViewController:eventsTableViewController];
	[localViewControllersArray addObject:nc];
    
    self.mapController = [[TileMapViewController alloc] initWithNibName:@"TileMapViewController" bundle:nil];
    self.mapController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Map", nil) image:[UIImage imageNamed:@"088-Map"] tag:2];
    nc = [[UINavigationController alloc]initWithRootViewController:self.mapController];
	[localViewControllersArray addObject:nc];
    
    NewsListViewController *news = [[NewsListViewController alloc] init];
    news.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"News", nil) image:[UIImage imageNamed:@"121-Mic"] tag:3];
    nc = [[UINavigationController alloc]initWithRootViewController:news];
	[localViewControllersArray addObject:nc];
    
    FunViewController * funViewController = [[FunViewController alloc] initWithNibName:@"FunViewController" bundle:nil];
    funViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"More", nil) image:[UIImage imageNamed:@"056-PlusCircle"] tag:4];
    nc = [[UINavigationController alloc]initWithRootViewController:funViewController];
	[localViewControllersArray addObject:nc];
    
    // set the tab bar controller view controller array to the localViewControllersArray
    self.tabBarController.viewControllers = localViewControllersArray;
    
    
    // set the window subview as the tab bar controller
    [self.window setRootViewController:self.tabBarController];
    
    // make the window visible
    [self.window makeKeyAndVisible];
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
  
   /*
    
    //Check for audio guide updates
    PFObject * audioGuidesUpdatesCount = [query getObjectWithId:@"HX306BH3sH"];
    NSInteger audioGuidesUpdatesNumberOnServer = [audioGuidesUpdatesCount[@"updateNumber"] intValue];
    NSInteger audioGuidesUpdatesNumberOnLocal =  [[NSUserDefaults standardUserDefaults] integerForKey:@"audioGuideLocalUpdateIndex"];
    
    NSLog(@"server = %i    |    local = %i",audioGuidesUpdatesNumberOnServer,audioGuidesUpdatesNumberOnLocal);
    if(audioGuidesUpdatesNumberOnServer > audioGuidesUpdatesNumberOnLocal){
        NSLog(@"Found updates for AudioGuides");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"audioGuidesNeedsUpdates"];
        [[NSUserDefaults standardUserDefaults] setInteger:audioGuidesUpdatesNumberOnServer forKey:@"audioGuidesPendingUpdateNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        NSLog(@"No updates for AudioGuides");
    }
    */
}

-(NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}


-(void)buyFullApp{
    [PFPurchase buyProduct:@"com.shannoga.biblicalzoo" block:^(NSError *error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Lion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"unlock-feature" object:nil]];
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank You", nil) message:NSLocalizedString(@"Buying Thanks", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"error = %@",[error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Perchase failed", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
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
    
    if(![Helper isRightToLeft]){
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
    //check for updates
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    if([reach isReachable]){
        [self checkForUpdates];
    }else{
        NSLog(@"Cannot check for updates");
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [locationManager stopMonitoringSignificantLocationChanges];
    NSString *visitorsCahnnel;
    if(![Helper isRightToLeft]){
        visitorsCahnnel = @"Visitors_En";
    }else{
        visitorsCahnnel = @"Visitors_He";
    }
    [PFPush unsubscribeFromChannelInBackground:visitorsCahnnel block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully Unsubscribed to the Visitors channel.");
        } else {
            NSLog(@"Failed to Unsubscribe to the Visitors channel.");
        }
    }];
    [MagicalRecord cleanUp];
}





@end