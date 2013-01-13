//
//  OpeningScreenViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 01/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "OpeningScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSZipArchive.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface OpeningScreenViewController ()

@end

@implementation OpeningScreenViewController
@synthesize madad;
@synthesize imageview;
@synthesize enter;
@synthesize info;



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
   // [self cloudScroll];
}


-(IBAction)showInfo:(id)sender{
    
     // Check for iOS 6
     Class mapItemClass = [MKMapItem class];
     if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
     {
     // Create an MKMapItem to pass to the Maps app
     CLLocationCoordinate2D coordinate =
     CLLocationCoordinate2DMake(16.775, -3.009);
     MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
     addressDictionary:nil];
     MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
     [mapItem setName:@"My Place"];
     // Pass the map item to the Maps app
     [mapItem openInMapsWithLaunchOptions:nil];
     }
     
    
}
-(IBAction)showMadad:(id)sender{
    NSLog(@"maddad");
}
-(IBAction)enter:(id)sender{
    NSLog(@"enter");
    [self dismissModalViewControllerAnimated:YES];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
