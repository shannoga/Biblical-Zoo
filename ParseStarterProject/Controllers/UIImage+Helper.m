//
//  UIImage+Helper.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/21/12.
//
//

#import "UIImage+Helper.h"
#import <QuartzCore/QuartzCore.h>

#define SCREENSCALE  [UIScreen mainScreen].scale

@implementation UIImage (Helper)

+ (UIImage *) imageWithView:(UIView *)view
{

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, SCREENSCALE);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)crop:(CGRect)rect {
 
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
    
}

- (UIImage *) resizeToSize:(CGSize) newSize thenCropWithRect:(CGRect) cropRect {
    CGContextRef                context;
    CGImageRef                  imageRef;
    CGSize                      inputSize;
    UIImage                     *outputImage = nil;
    CGFloat                     scaleFactor, width;
    
    // resize, maintaining aspect ratio:
    
    inputSize = self.size;
    scaleFactor = newSize.height / inputSize.height;
    width = roundf( inputSize.width * scaleFactor );
    
    if ( width > newSize.width ) {
        scaleFactor = newSize.width / inputSize.width;
        newSize.height = roundf( inputSize.height * scaleFactor );
    } else {
        newSize.width = width;
    }
    
    UIGraphicsBeginImageContext( newSize );
    
    context = UIGraphicsGetCurrentContext();
    CGContextDrawImage( context, CGRectMake( 0, 0, newSize.width, newSize.height ), self.CGImage );
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    inputSize = newSize;
    
    // constrain crop rect to legitimate bounds
    if ( cropRect.origin.x >= inputSize.width || cropRect.origin.y >= inputSize.height ) return outputImage;
    if ( cropRect.origin.x + cropRect.size.width >= inputSize.width ) cropRect.size.width = inputSize.width - cropRect.origin.x;
    if ( cropRect.origin.y + cropRect.size.height >= inputSize.height ) cropRect.size.height = inputSize.height - cropRect.origin.y;
    
    // crop
    if ( ( imageRef = CGImageCreateWithImageInRect( outputImage.CGImage, cropRect ) ) ) {
        outputImage = [[UIImage alloc] initWithCGImage: imageRef];
        CGImageRelease( imageRef );
    }
    
    return outputImage;
}

- (UIImage *) normalize {
    
        
        CGSize size = CGSizeMake(round(self.size.width*SCREENSCALE), round(self.size.height*SCREENSCALE));
        CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL, 
                                                             size.width, 
                                                             size.height, 
                                                             8, (4 * size.width), 
                                                             genericColorSpace, 
                                                             kCGImageAlphaPremultipliedFirst);
        CGColorSpaceRelease(genericColorSpace);
        CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
        CGRect destRect = CGRectMake(0, 0, size.width, size.height);
        CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
        CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
        CGContextRelease(thumbBitmapCtxt);    
        UIImage *result = [UIImage imageWithCGImage:tmpThumbImage scale:SCREENSCALE orientation:UIImageOrientationUp];
        CGImageRelease(tmpThumbImage);
        
        return result;    
}

@end
