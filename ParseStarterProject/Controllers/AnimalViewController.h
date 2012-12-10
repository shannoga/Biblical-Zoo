//
//  AnialViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Animal.h"
#import "AnimalDataScrollView.h"
#import "AnimalViewToolbar.h"
#import "TPKeyboardAvoidingScrollView.h"
@class AnimalViewToolbar;
@class AnimalDataScrollView;

@interface AnimalViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,AnimalViewToolbarDelegate>{
    AnimalViewToolbar *toolbar;
    BOOL toolbarEnabeld;
}

@property (nonatomic,retain)  TPKeyboardAvoidingScrollView *scroolKeyboardView;
@property (nonatomic,retain)  UIView *previosView;
@property (nonatomic, strong)  AnimalDataScrollView *animalDataScrollView;
@property (nonatomic,retain)   Animal * animal;
@property (nonatomic,retain)   UIScrollView * imagesScroll;

@property (nonatomic,retain)   UIScrollView * dataScroll;

@property (nonatomic,retain)   UIButton * dataTableBtn;
@property (nonatomic,retain)   UIButton * longDescriptionBtn;
@property (nonatomic,retain)   UIButton * mapBtn;
@property (nonatomic,retain)   UIButton * mediaBtn;
@property (nonatomic) BOOL fullscreen;

@end
