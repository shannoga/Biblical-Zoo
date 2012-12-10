//
//  CapturedImageViewController.m
//  MonkeyPinch
//
//  Created by Ray Wenderlich on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CapturedImageViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation CapturedImageViewController
@synthesize bananaPan;
@synthesize monkeyPan;
@synthesize capturedImage;
@synthesize capturedImageView;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (id)initWithImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        self.capturedImage = image;
        self.capturedImageView  = [[UIImageView alloc] initWithImage:self.capturedImage];
       
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    
    self.capturedImageView.frame = CGRectMake(self.view.frame.size.width/2-self.capturedImage.size.width/4, self.view.frame.size.height/2-self.capturedImage.size.height/4, self.capturedImage.size.width/2, self.capturedImage.size.height/2);
    
    self.capturedImageView.userInteractionEnabled=YES;
       self.view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        UIPinchGestureRecognizer * pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        recognizer.delegate = pinchRecognizer.delegate =panRecognizer.delegate =  rotationRecognizer.delegate = self;
        [self.capturedImageView addGestureRecognizer:pinchRecognizer];
        [self.capturedImageView addGestureRecognizer:panRecognizer];
        [self.capturedImageView addGestureRecognizer:rotationRecognizer];
        [self.capturedImageView addGestureRecognizer:recognizer];
        //[recognizer requireGestureRecognizerToFail:monkeyPan];
        //[recognizer requireGestureRecognizerToFail:bananaPan];
        
        // TODO: Add a custom gesture recognizer too
        TickleGestureRecognizer * recognizer2 = [[TickleGestureRecognizer alloc] initWithTarget:self action:@selector(handleTickle:)];
        recognizer2.delegate = self;
        [self.capturedImageView addGestureRecognizer:recognizer2];
    
    [[self view] addSubview:self.capturedImageView];

}

- (void)viewDidUnload
{
    [self setBananaPan:nil];
    [self setMonkeyPan:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {

    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
      
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor), 
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
}

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {        
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {    
}

- (void)handleTickle:(TickleGestureRecognizer *)recognizer {
}

@end
