//
//  conservasionStatusIndicator.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/26/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import "ConservasionStatusIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "Animal.h"
#import "Animations.h"

@implementation ConservasionStatusIndicator
@synthesize animal;




+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {
        isDetails=NO;
        animal=nil;
        
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self.layer setContentsScale:[[UIScreen mainScreen] scale]];
    
    
    // Set the colors for the gradient layer.
    NSArray *colors = @[(id)[[UIColor colorWithRed:0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:.95] CGColor],
                              (id)[[UIColor colorWithRed:204.0/255.0 green:153.0/255.0 blue:0/255.0 alpha:.95]CGColor],
                              (id)[ [UIColor colorWithRed:204.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:.95]CGColor],
                              (id)[ [UIColor colorWithRed:204.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:.95]CGColor],
                              (id)[ [UIColor blackColor]CGColor]];
    
    NSArray *locations = @[@0.10f,
                                 @0.35f,
                                 @0.50f,
                                 @0.65f,
                                 @0.90f];
    
    CATransform3D transform = CATransform3DMakeRotation(90/57.2958,0, 0, 1);
    CAGradientLayer* gradientLayer_ = [CAGradientLayer layer];
    gradientLayer_.backgroundColor = [[UIColor blackColor] CGColor];
    gradientLayer_.bounds = CGRectMake(0,0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame));
    gradientLayer_.position = self.center;
    [gradientLayer_ setContentsScale:[[UIScreen mainScreen] scale]];
    gradientLayer_.startPoint = CGPointZero;
    gradientLayer_.endPoint = CGPointMake(0., 1.);
    gradientLayer_.colors =colors;
    gradientLayer_.locations=locations;
    gradientLayer_.transform = transform;
    [self.layer addSublayer:gradientLayer_];
    
    CAShapeLayer* glossLayer = [CAShapeLayer layer];
    glossLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    glossLayer.opacity = .1;
    glossLayer.bounds = CGRectMake(0,0,CGRectGetWidth(gradientLayer_.bounds)/2,CGRectGetHeight(gradientLayer_.bounds));
    glossLayer.position = CGPointMake(CGRectGetWidth(gradientLayer_.bounds)/4,self.center.x) ;
    [glossLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [gradientLayer_ addSublayer:glossLayer];
    
    __block float consevationToFloat;
    NSArray *conservationStatusArray = @[@"LC",
                                        @"NT",
                                        @"VU",
                                        @"EN",
                                        @"CR",
                                        @"EW",
                                        @"EX"];
    NSArray *indicatorXpositions = @[@301,@257,@212,@166,@120,@75,@0];
    
    [conservationStatusArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:animal.conservationStatus]) {
            NSNumber *pos = indicatorXpositions[idx];
            consevationToFloat = [pos floatValue];
        }
    }];
    consevationToFloat=fabsf(consevationToFloat-6);
    //create indicator
    CAShapeLayer *indicator = [CAShapeLayer layer];
    indicator.bounds = CGRectMake(0, 0, CGRectGetHeight(self.bounds)*0.8,CGRectGetHeight(self.bounds)*0.8);
    indicator.position =CGPointMake(consevationToFloat, self.center.y);
    indicator.borderWidth=1.0f;
    indicator.borderColor=[UIColor whiteColor].CGColor;
    indicator.cornerRadius = (CGRectGetHeight(self.bounds)*0.8)*0.5;
    [self.layer insertSublayer:indicator above:gradientLayer_];
    [indicator addAnimation:[Animations pulseAnimation:1.1] forKey:@"nil"];
    
    CABasicAnimation *xAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    xAnimation.duration = 1.5;
    xAnimation.fromValue = @(CGRectGetMaxX(self.bounds));
    xAnimation.toValue =@(indicator.position.x);
    xAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
    [indicator addAnimation:xAnimation forKey:@"position.x"];
    
}
-(void)showDetails {
	
	if (!isDetails) {
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        scaleAnimation.duration = 1.5;
        scaleAnimation.fromValue =(id)@1.0f;
        scaleAnimation.toValue =@2.0f;
        scaleAnimation.removedOnCompletion=NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
        [self.layer addAnimation:scaleAnimation forKey:nil];
        
        // self.layer.transform  = CATransform3DMakeScale(1, 2, 0);
        
        
        
        NSArray *ex = @[@"EX",@"EW",@"CR",@"EN",@"VU",@"NT",@"LC"];
        for (int i = 0; i<[ex count]; i++) {
            CAShapeLayer *conservationCircle = [CAShapeLayer layer];
            [conservationCircle setContentsScale:[[UIScreen mainScreen] scale]];
            conservationCircle.bounds = CGRectMake(0, 0, CGRectGetHeight(self.bounds)*0.8,CGRectGetHeight(self.bounds)*0.8);
            conservationCircle.position =CGPointMake((i+1)* CGRectGetWidth(self.bounds)/8, self.center.y);
            conservationCircle.borderColor = [UIColor whiteColor].CGColor;
            conservationCircle.borderWidth = 1.0f;
            conservationCircle.cornerRadius = (CGRectGetHeight(self.bounds)*0.8)*0.5;
            [self.layer addSublayer:conservationCircle];
            
            UIFont *font = [UIFont fontWithName:@"Futura-Medium" size: (CGRectGetHeight(self.bounds)*0.4)];
            CATextLayer * conservationText = [CATextLayer layer];
            CGSize stringSize = [ex[i] sizeWithFont:font];
            [conservationText setContentsScale:[[UIScreen mainScreen] scale]];
            conservationText.bounds = CGRectMake(0,0,stringSize.width,stringSize.height);
            conservationText.position=CGPointMake(CGRectGetMidX(conservationCircle.bounds), CGRectGetMidY(self.bounds));
            conservationText.string = ex[i];
            //conservationText.font = font;
            conservationText.fontSize =font.pointSize;
            conservationText.alignmentMode = kCAAlignmentCenter;
            conservationText.anchorPoint = CGPointMake(.5, .5);
            [conservationCircle addSublayer:conservationText];
            
            CABasicAnimation *xAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
            xAnimation.duration = 1.5;
            xAnimation.fromValue = @(CGRectGetMaxX(self.bounds));
            xAnimation.toValue =@(conservationCircle.position.x);
            xAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];;
            [conservationCircle addAnimation:xAnimation forKey:@"position.x"];
        }
        
    }else{
        self.layer.transform  = CATransform3DMakeScale(1, 1, 0); 
    }
    isDetails=!isDetails;
}





@end
