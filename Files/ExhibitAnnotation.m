//
//  ExhibitAnnotation.m
//  ParseStarterProject
//
//  Created by shani hajbi on 15/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "ExhibitAnnotation.h"
#import "Exhibit.h"

@implementation ExhibitAnnotation 
@synthesize exhibit;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [exhibit.latitude doubleValue];
    theCoordinate.longitude = [exhibit.longitude doubleValue];
    return theCoordinate; 
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    if (![Helper isRightToLeft]) {
        return exhibit.nameEn;
    }
    return exhibit.name;
}



// optional
- (NSString *)subtitle
{
    return  NSLocalizedString(@"Tap to see animal", nil);
}


@end
