//
//  CapturedImageViewController.h

//

#import <UIKit/UIKit.h>

@interface CapturedImageViewController : UIViewController <UIGestureRecognizerDelegate>

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;

@property (strong, nonatomic)  UIPinchGestureRecognizer * pinchRecognizer;
@property (strong, nonatomic)  UIPanGestureRecognizer * panRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) UIImageView *capturedImageView;
- (id)initWithImage:(UIImage*)image;
@end
