//
//  OMPageControl.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 3/31/11.
//  Copyright 2011 shani hajbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMPageControl : UIPageControl {
    UIImage* mImageNormal;
    UIImage* mImageCurrent;
}

@property (nonatomic, readwrite, strong) UIImage* imageNormal;
@property (nonatomic, readwrite, strong) UIImage* imageCurrent;

@end