//
//  CapturedImageViewController.h
//  MonkeyPinch
//
//  Created by Ray Wenderlich on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickleGestureRecognizer.h"

@interface CapturedImageViewController : UIViewController <UIGestureRecognizerDelegate>

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;

- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@property (strong, nonatomic)  UIPanGestureRecognizer *monkeyPan;
@property (strong, nonatomic)  UIPanGestureRecognizer *bananaPan;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) UIImageView *capturedImageView;
- (void)handleTickle:(TickleGestureRecognizer *)recognizer;
- (id)initWithImage:(UIImage*)image;
@end
