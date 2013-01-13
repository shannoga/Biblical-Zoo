//
//  Animations.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 3/24/11.
//  Copyright 2011 shani hajbi. All rights reserved.
//

#import "Animations.h"
#import <QuartzCore/QuartzCore.h>

@implementation Animations


+(CABasicAnimation*)pulseAnimation:(float)toValue{
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = @(toValue);
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    return pulseAnimation; 
}

@end
