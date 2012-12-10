//
//  UIImage+Helper.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/21/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
+ (UIImage *) imageWithView:(UIView *)view;
- (UIImage *)crop:(CGRect)rect;
- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect;
- (UIImage *) normalize;
@end
