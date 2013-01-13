//
//  AnimalsImagesScrollView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import "OMPageControl.h"
#import "Animal.h"
@interface AnimalsImagesScrollView : UIView <UIScrollViewDelegate,UINavigationControllerDelegate>{

  UIPageControl *pageControl;
    UIScrollView *scrollView;
    BOOL pageControlUsed;
}
@property (nonatomic, weak) Animal *animal;
@property (nonatomic, strong) UIScrollView *scrollView;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;
@end
