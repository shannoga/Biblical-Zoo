// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import "Parse/Parse.h"
#import "JerusalemBiblicalZooAppDelegate.h"
#import "EventsTableViewController.h"
#import "TileMapViewController.h"
#import "NewsListViewController.h"
#import "FunViewController.h"
#import "ExhibitsViewController.h"
#import "Animal.h"
#import "Exhibit.h"
#import "ParseHelper.h"
#import "NSManagedObject+Helper.h"
#import "OpeningScreenViewController.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation JerusalemBiblicalZooAppDelegate


@synthesize tabBarController =_tabBarController;
@synthesize window=_window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
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
    /*
    NSManagedObjectContext *context = [self managedObjectContext];
    NSLog(@"Context: %@",context);
    NSLog(@"PS Coord : %@",context.persistentStoreCoordinator);
    NSLog(@"MOM : %@", context.persistentStoreCoordinator.managedObjectModel);
    NSLog(@"Entities : %@",[[context.persistentStoreCoordinator.managedObjectModel entities] valueForKey:@"name"]);
    */
    
    //set the initial lang for the app as the user device lang

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"]==nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"completedAudioGuideEnFiles"];
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"completedAudioGuideHeFiles"];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"exhibitsNeedsUpdates"];
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"audioGuidesNeedsUpdates"];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"completedExhibitsFirstDownloadingForHe"];
        [[NSUserDefaults standardUserDefaults] setBool:NO   forKey:@"completedExhibitsFirstDownloadingForEn"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"audioGuideLocalUpdateIndex"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"exhibitLocalUpdateIndex"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Check for exhibits updates
    PFQuery *query = [PFQuery queryWithClassName:@"Updates"];
    PFObject *exhibitUpdatesCount = [query getObjectWithId:@"9DTc1QlpRg"];
    NSInteger exhibitsUpdatesNumberOnServer = [exhibitUpdatesCount[@"updateNumber"] intValue];
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

    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        //exclude the audio guide folder from backup
        [[NSFileManager defaultManager] applicationSupportDirectory:NO];
    }else{
       [[NSFileManager defaultManager] applicationTempDirectory];
    }
  
    
    
    //----- LIST ALL FILES -----

    int Count;
    NSArray * directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Helper audioGuideFilesPath] error:NULL];
    for (Count = 0; Count < (int)[directoryContent count]; Count++)
    {
        NSLog(@"File %d: %@", (Count + 1), directoryContent[Count]);
    }
    
    

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    

    
    // Create a tabbar controller and an array to contain the view controllers
    self.tabBarController = [[UITabBarController alloc] init];
	
    NSMutableArray *localViewControllersArray = [NSMutableArray array];
    
    ExhibitsViewController *exhibitsViewController = [[ExhibitsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:exhibitsViewController];
    nc.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
	[localViewControllersArray addObject:nc];
    
    NewsListViewController *news = [[NewsListViewController alloc] init];
    nc = [[UINavigationController alloc]initWithRootViewController:news];
     nc.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
	[localViewControllersArray addObject:nc];
    
    EventsTableViewController *eventsTableViewController = [[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    nc = [[UINavigationController alloc]initWithRootViewController:eventsTableViewController];
    nc.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
	[localViewControllersArray addObject:nc];
    
    TileMapViewController *mapViewController = [[TileMapViewController alloc] initWithNibName:@"TileMapViewController" bundle:nil];
    nc = [[UINavigationController alloc]initWithRootViewController:mapViewController];
    nc.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
	[localViewControllersArray addObject:nc];
    
    FunViewController * funViewController = [[FunViewController alloc] initWithNibName:@"FunViewController" bundle:nil];
    nc = [[UINavigationController alloc]initWithRootViewController:funViewController];
    nc.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
	[localViewControllersArray addObject:nc];
    
    // set the tab bar controller view controller array to the localViewControllersArray
    self.tabBarController.viewControllers = localViewControllersArray;

    
    // set the window subview as the tab bar controller
    [self.window setRootViewController:self.tabBarController];
    
    // make the window visible
    [self.window makeKeyAndVisible];

 
    
    /*
    //list all animals
    NSArray *animals = [Animal allObjects];
    for (Animal *animal in animals) {
        NSInteger count  = [[animal images] count];
        if (count>0) {
            NSLog(@"animal %@ has %i",animal.name,count);
        }else{
             NSLog(@"animal %@ has -----NO IMAGES---",animal.name);
        }
    }
     //list all
*/

    
    NSArray *animals = [Animal allObjects];
    for (Animal *animal in animals) {
        NSLog(@"animal %@ ",[animal.generalExhibitDescription boolValue]?@"----------------Genral":@"Not General");
    }
    
  /*
    NSArray *exhibits = [Exhibit allObjects];
    for (Exhibit *exhibit in exhibits) {
        
        NSArray * animals = [exhibit localAnimals];
        if(animals.count>0){
        NSMutableString *animalsNames = [[NSMutableString alloc] init];
        [animalsNames appendFormat:@"Animals for exhibit  %@ : ",exhibit.name];
        for (Animal *animal in animals) {
            [animalsNames appendFormat:@" | %@",animal.name];
        }
        //NSLog(@"%@",animalsNames);
        }else{
            NSLog(@"Exhibit %@  ---- HAS NO ANIMALS -----",exhibit.name);
        }

    }
    */
      
    return YES;
}


///////////////////////////////////////////////////////////
// Uncomment these two methods if you are using Facebook
///////////////////////////////////////////////////////////
 
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}
 
// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
} 


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
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
    
    
    //Check for exhibits updates
    PFQuery *query = [PFQuery queryWithClassName:@"Updates"];
    PFObject *exhibitUpdatesCount = [query getObjectWithId:@"9DTc1QlpRg"];
    NSInteger exhibitsUpdatesNumberOnServer = [exhibitUpdatesCount[@"updateNumber"] intValue];
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
    
    
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    /*
     
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}




#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
