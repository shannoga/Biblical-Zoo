//     File: TileMapViewController.m
// Abstract: 
//     View controller to display a raster tiled map overlay on an MKMapView.  Demonstrates how to use the TileOverlay and TileOverlayView classes with MKMapView.
//   
//  Version: 1.0
// 
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
// 
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
// 
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
// 
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 

#import "TileMapViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "MKMapView+ZoomLevel.h"
#import "Exhibit.h"
#import "ExhibitAnnotation.h"
#import "UIImage+Resize.h"
#import "UIImage+Helper.h"
#import "AnimalViewController.h"
#import "ExhibitAnimalsViewController.h"
#import "MapAnnotationView.h"
#import "ExhibitAnnotation.h"
@implementation TileMapViewController
@synthesize locationManager;
@synthesize  mapAnnotations;
@synthesize  services;
@synthesize map;

#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 30.0f;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title =  [Helper languageSelectedStringForKey:@"Map"];
     
       
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.map){
     self.map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.map.delegate = self;
    [self.view addSubview:self.map];
    }
    
    NSString *tileDirectory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Tiles"];
    
    CLLocationCoordinate2D coordsBg[5]={
		CLLocationCoordinate2DMake(31.751065,35.181082),
		CLLocationCoordinate2DMake(31.740531,35.181082),
		CLLocationCoordinate2DMake(31.740531,35.165652),
		CLLocationCoordinate2DMake(31.751065,35.165652),
        CLLocationCoordinate2DMake(31.751065,35.181082)
	};	   
    
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveNotif:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotif:) name:UIApplicationWillResignActiveNotification object:nil];

    
    
    bg=[MKPolygon polygonWithCoordinates:coordsBg count:5];
	[self.map addOverlay:bg];
    
    TileOverlay *overlay = [[TileOverlay alloc] initWithTileDirectory:tileDirectory];
    [self.map addOverlay:overlay];

    MKMapRect visibleRect = [self.map mapRectThatFits:bg.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width/1.5;
    visibleRect.origin.y += visibleRect.size.height/2.2;
    self.map.visibleMapRect = visibleRect;
    self.map.centerCoordinate = CLLocationCoordinate2DMake(31.740531,35.165652);
    if([CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    
    
    NSArray * allExhibits = [Exhibit findAll];
    NSUInteger i=0;
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:[allExhibits count]];

    for (Exhibit * exhibit in allExhibits) {
        ExhibitAnnotation *exhibitAnnotation = [[ExhibitAnnotation alloc] init];
		exhibitAnnotation.exhibit=exhibit;
		[self.mapAnnotations insertObject:exhibitAnnotation atIndex:i];
        i++;
    }
    [self addAllAnnotations:self];
    
}

-(void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [locationManager startUpdatingLocation];
}

-(void)appWillResignActiveNotif:(NSNotification*)notif
{
    [locationManager stopUpdatingLocation];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[Helper appDelegate] buyFullApp:NO];
    }
}

#pragma mark -
#pragma mark UIPinchGestureRecognizer


- (void)formatAnnotationView:(MapAnnotationView *)pinView forMapView:(MKMapView *)aMapView withExhibit:(Exhibit*)exhibit {
    if (pinView)
    {
        double zoomLevel = [aMapView zoomLevel];
        double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and
        if(scale < 0.45){
            scale = .25;
        }else if(scale >= 0.45 && scale < 0.47){
            scale = .3;
        }else if(scale >= 0.47 && scale < 0.49){
            scale = .35;
        }else if(scale >= 0.49 && scale < 0.51){
            scale = .4;
        }else if(scale >= 0.51 && scale < 0.53){
            scale = .45;
        }else if(scale >= 0.53 && scale < 0.55){
            scale = .5;
        }else if(scale >= 0.55){
            scale = .5;
        }
       
        pinView.scale = scale;
        pinView.exhibit = exhibit;
        [pinView setNeedsDisplay];
        
       // UIImage *pinImage = [exhibit.mapIcon normalize];
        //pinView.image = pinImage;
      //  pinView.transform = CGAffineTransformMakeScale(scale, scale);
       // [pinImage resizedImage:CGSizeMake(pinImage.size.width * scale, pinImage.size.height * scale) interpolationQuality:kCGInterpolationHigh];

    }
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.map setShowsUserLocation:YES];

    
    if([CLLocationManager locationServicesEnabled]){
        if (locationManager==nil) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        [locationManager startUpdatingLocation];
    }

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[TileOverlay class]]) {
        TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
        view.tileAlpha = 1;
        return view;
    }else if([overlay isKindOfClass:[MKPolygon class]]){
        UIColor *fillColor = UIColorFromRGBA(0x8C9544, 1);
        MKPolygonView *polyLineView = [[MKPolygonView alloc] initWithOverlay: overlay];
        polyLineView.fillColor = fillColor;
        return polyLineView;
    }
	return nil;
}



#pragma mark -
#pragma mark ButtonActions



- (void)ExhibitAction:(id)sender
{
    [self.map removeAnnotations:self.map.annotations];  // remove any annotations that exist
    [self.map addAnnotation:(self.mapAnnotations)[0]];
}

- (void)addAllAnnotations:(id)sender
{
    [self.map removeAnnotations:self.map.annotations];  // remove any annotations that exist
    [self.map addAnnotations:self.mapAnnotations];
    
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)showDetails:(id)sender
{
    
    MKAnnotationView *annotationView = (MKAnnotationView*) [[sender superview]superview];
    ExhibitAnnotation *anootation =  (ExhibitAnnotation*)annotationView.annotation;

    Exhibit *exhibit = anootation.exhibit;
    
   
        NSArray *animals = [exhibit localAnimals];
        [self.navigationController setToolbarHidden:YES animated:NO];
        if ([animals count]==1) {
            AnimalViewController *anialViewController = [[AnimalViewController alloc] init];
            if(!IS_IPHONE_5){
            self.navigationController.navigationBar.tintColor = nil;
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            }
            anialViewController.animal = [animals lastObject];
            [self.navigationController pushViewController:anialViewController animated:YES];
            
        } else if([animals count]>1){
            ExhibitAnimalsViewController * exhibitAnimalsViewController = [[ExhibitAnimalsViewController alloc] init];
            exhibitAnimalsViewController.exhibit = exhibit;
            [self.navigationController pushViewController:exhibitAnimalsViewController animated:YES];
            
        }else{
            NSLog(@"no animals in the exhibit");  
        }

     
}



- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
   
	
    if ([annotation isKindOfClass:[ExhibitAnnotation class]])
    {
		static NSString* exhibitAnnotationIdentifier = @"exhibitAnnotation"; 
		MapAnnotationView* annotationView =
		(MapAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:exhibitAnnotationIdentifier];
        if (!annotationView)
        {
            ExhibitAnnotation *exhibitAnnotation = (ExhibitAnnotation*)annotation;
            annotationView = [[MapAnnotationView alloc] initWithAnnotation:exhibitAnnotation
                                                                            reuseIdentifier:exhibitAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            annotationView.opaque = YES;
            Exhibit *exhibit = (Exhibit*)exhibitAnnotation.exhibit;
            annotationView.exhibit = exhibit;
            
            CGRect resizeRect;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [TileMapViewController annotationPadding],
                                         [TileMapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [TileMapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width){
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            }
            if (resizeRect.size.height > maxSize.height){
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            }
            
            
            [self formatAnnotationView:annotationView forMapView:theMapView withExhibit:exhibit];
           
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			
		
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            return annotationView;
        }
        else
        {
            ExhibitAnnotation *exhibitAnnotation = (ExhibitAnnotation*)annotation;
             Exhibit *exhibit = (Exhibit*)exhibitAnnotation.exhibit;
            [self formatAnnotationView:annotationView forMapView:theMapView withExhibit:exhibit];
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
  
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)ann
{
    if ([ann.annotation isKindOfClass:[MKUserLocation class]]){
        ann.enabled = NO;
    };
   
    
}

- (void)openAnnotation:(id)annotation;
{
    //mapView is the mapView
    [self.map selectAnnotation:annotation animated:YES];
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      //  mapView.centerCoordinate = userLocation.location.coordinate;
    });
} 

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    lastGoodMapRect = mapView.visibleMapRect;
    lastGoodRegion = mapView.region;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
 
    
    for (ExhibitAnnotation *annotation in mapView.annotations) {
      
        //
        if ([annotation isKindOfClass:[ExhibitAnnotation class]])
        {
            // try to retrieve an existing pin view first
            MapAnnotationView *pinView = (MapAnnotationView*)[mapView viewForAnnotation:annotation];
            //Format the pin view
            [self formatAnnotationView:pinView forMapView:mapView withExhibit:annotation.exhibit];
        }
    }
    
    if (manuallyChangingMapRect) {
        manuallyChangingMapRect=NO;
        return;
    }
    
    if( [mapView zoomLevel] > 17 )
    {
        [mapView setCenterCoordinate:lastGoodRegion.center zoomLevel:17 animated:YES];
    }
    MKMapRect visibleRect = mapView.visibleMapRect;
    MKMapRect OverlayRect = bg.boundingMapRect;
    MKMapRect intersectionRect = MKMapRectIntersection(visibleRect,OverlayRect);
    
    
    if(!MKMapRectEqualToRect(visibleRect,intersectionRect)){
        if( [mapView zoomLevel] < 15){
         
            [mapView setCenterCoordinate:lastGoodRegion.center zoomLevel:15 animated:YES];
        }else if( [mapView zoomLevel] > 17 )
        {
            [mapView setCenterCoordinate:lastGoodRegion.center zoomLevel:17 animated:YES];
        }else{
            manuallyChangingMapRect=YES;
            [mapView setVisibleMapRect:lastGoodMapRect animated:YES];
        }
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    CLLocation * mapCenterLocation = [[CLLocation alloc] initWithLatitude:31.746233 longitude:35.174095]; 
    if( [newLocation distanceFromLocation:mapCenterLocation]<1000){
        NSLog(@"user is in zoo");
        
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"You are out of the zoo"]
                                                            message:[Helper languageSelectedStringForKey:@"Come visit us soon"]
                                                           delegate:nil
                                                  cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                                  otherButtonTitles:nil];
            [alert show];
        });

    }
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"location services error title"]
                                                        message:[Helper languageSelectedStringForKey:@"location services error body"]
                                                       delegate:self
                                              cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)setCenterLocationAndShowMapForExhibit:(Exhibit *)exhibit{
    
    [self.navigationController.tabBarController setSelectedIndex:2];
   
    CLLocationCoordinate2D location =  CLLocationCoordinate2DMake([exhibit.latitude doubleValue], [exhibit.longitude doubleValue]);
    [self.map setCenterCoordinate:location zoomLevel:17 animated:YES];
  [self performSelector:@selector(showAnnotationForExhibit:) withObject:exhibit afterDelay:1];
    
    
    

}
-(void)showAnnotationForExhibit:(Exhibit*)exhibit{
   
    for (ExhibitAnnotation *annotation in self.map.annotations) {
        if (MKMapRectContainsPoint(self.map.visibleMapRect, MKMapPointForCoordinate(annotation.coordinate)))
        {
            if (annotation.exhibit == exhibit) {
                [self openAnnotation:annotation];
            }
        }
    }
    
   

   
}

@end
