//
//  OpeningScreenViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 01/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "OpeningScreenViewController.h"
#import <MapKit/MapKit.h>
#import "NSDate-Utilities.h"
@interface OpeningScreenViewController ()

@end

@implementation OpeningScreenViewController
@synthesize madad;
@synthesize imageview;
@synthesize enterBtn;
@synthesize directionsBtn;



- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
   
    NSInteger time = [dateInStringFormated intValue];
    if (time >= 9 && time < 18) {
        
        
        if ([Helper appLang]==kHebrew) {
            if (IS_IPHONE_5) {
                self.imageview.image = [UIImage imageNamed:@"opening_screen_day_he_5"];
            }else{
                self.imageview.image = [UIImage imageNamed:@"opening_screen_day_he"];
                
            }
        }else{
            if (IS_IPHONE_5) {
                self.imageview.image = [UIImage imageNamed:@"opening_screen_day_en_5"];
            }else{
                self.imageview.image = [UIImage imageNamed:@"opening_screen_day_en"];
                
            }
        }
   
    }else{
        if ([Helper appLang]==kHebrew) {
            if (IS_IPHONE_5) {
                self.imageview.image = [UIImage imageNamed:@"opening_screen_night_he_5"];
            }else{
                self.imageview.image = [UIImage imageNamed:@"opening_screen_night_he"];
                
            }
        }else{
            if (IS_IPHONE_5) {
                self.imageview.image = [UIImage imageNamed:@"opening_screen_night_en_5"];
            }else{
                self.imageview.image = [UIImage imageNamed:@"opening_screen_night_en"];
                
            }
        }
    }

    if (IS_IPHONE_5) {
        self.directionsBtn.frame = CGRectOffset(self.directionsBtn.frame, 0, 60);
        self.enterBtn.frame = CGRectOffset(self.enterBtn.frame, 0, 60);
    }
   // [self cloudScroll];
}


-(IBAction)showInfo:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        NSString *urlStr = @"waze://?ll=31.745636,35.177048&navigate=yes";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        if([Helper bugsenseOn]) [BugSenseController sendCustomEventWithTag:@"waze used"];
        if([Helper bugsenseOn]) [BugSenseController leaveBreadcrumb:@"waze used"];
    }else if ([MKMapItem class] && [[MKMapItem class]  respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"Biblical Zoo, Jerusalem, Israel"
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         
                         // Convert the CLPlacemark to an MKPlacemark
                         // Note: There's no error checking for a failed geocode
                         CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc]
                                                   initWithCoordinate:geocodedPlacemark.location.coordinate
                                                   addressDictionary:geocodedPlacemark.addressDictionary];
                         
                         // Create a map item for the geocoded address to pass to Maps app
                         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         [mapItem setName:geocodedPlacemark.name];
                         
                         // Set the directions mode to "Driving"
                         // Can use MKLaunchOptionsDirectionsModeWalking instead
                         NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                         
                         // Get the "Current User Location" MKMapItem
                         MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                         
                         // Pass the current location and destination map items to the Maps app
                         // Set the direction mode in the launchOptions dictionary
                         [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                         
                     }];
    }else{
        //ios 5
       NSString* address = @"https://maps.google.com/maps?f=q&q=31.745636,35.177048";
        NSURL* url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
       
    }
     
    
}
-(IBAction)showMadad:(id)sender{
    NSLog(@"maddad");
}
-(IBAction)enter:(id)sender{
    NSLog(@"enter");
    if([Helper bugsenseOn]) [BugSenseController leaveBreadcrumb:@"entered app"];
    [self dismissModalViewControllerAnimated:YES];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
