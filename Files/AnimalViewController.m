//
//  AnimalViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 17/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "AnimalViewController.h"
#import "AnimalsImagesScrollView.h"
#import "AnimalDataTabBarController.h"
#import "ConservasionStatusIndicator.h"
#import "AnimalViewToolbar.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Exhibit.h"
#import "AnimalQuestionsCell.h"
#import "AnimalPostView.h"

#define kDataTable 0
#define kGeneralDescription 1
#define kMap 2
#define kAudioGuide 3
#define kPosts 4




@interface AnimalViewController ()

@end

@implementation AnimalViewController
@synthesize imagesScroll;
@synthesize dataScroll;
@synthesize dataTableBtn;
@synthesize longDescriptionBtn;
@synthesize mapBtn;
@synthesize mediaBtn;
@synthesize animal;
@synthesize animalDataTabViewController;
@synthesize fullscreen = _fullscreen;
@synthesize scroolKeyboardView;
@synthesize previosView;
- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        toolbarEnabeld = YES;
        _fullscreen = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePostEditingNotification:) 
                                                     name:@"PostEditingStarted"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePostEditingNotification:) 
                                                     name:@"PostEditingEnded"
                                                   object:nil];
        
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"088-Map_white.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showOnMap)];
        
        self.navigationItem.rightBarButtonItem = mapButton;
        
    }
    return self;
}

-(void)showOnMap{
    [Helper setCurrentExhibit:self.animal.exhibit];
}

- (void)toggleFullscreen {
//     if(!IS_IPHONE_5){
//        _fullscreen = !_fullscreen;
//        if (_fullscreen) { 
//            
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//        } else {
//          
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//     }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!IS_IPHONE_5){
   // self.navigationController.navigationBar.translucent =YES;
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self performSelector:@selector(toggleFullscreen) withObject:nil afterDelay:.5];
    
    //Once the view has loaded then we can register o begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
     [self.animalDataTabViewController stop];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self.animalDataTabViewController play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.animalDataTabViewController pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self.animalDataTabViewController togglePlayPause];
        }
    }
}

-(void)toggleFullscreenWithTimer{
    if(!IS_IPHONE_5){
        [self toggleFullscreen];
        if(!_fullscreen){
            [self performSelector:@selector(toggleFullscreen) withObject:nil afterDelay:2];
        }else{
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.view.backgroundColor = UIColorFromRGB(0xf8eddf);
    
    scroolKeyboardView  = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroolKeyboardView];
    
    //conservation sataus ind
    ConservasionStatusIndicator *consInd;
    if(IS_IPHONE_5){
     consInd = [[ConservasionStatusIndicator alloc] initWithFrame:CGRectMake(0, 2, 320, 26)];
    }else{
     consInd = [[ConservasionStatusIndicator alloc] initWithFrame:CGRectMake(0, 2, 320, 20)];
    }
    [consInd setAnimal:self.animal];
    [scroolKeyboardView addSubview:consInd];
    
    
  
	

    self.animalDataTabViewController = [[AnimalDataTabBarController alloc] init];
    [self.view addSubview:self.animalDataTabViewController.view];

  
    if (!IS_IPHONE_5) {
        UIButton * mapButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 170, 30, 30)];
        [mapButton setImage:[UIImage imageNamed:@"088-Map_brown_bg@2x.png"]  forState:UIControlStateNormal];
        [mapButton addTarget:self action:@selector(showOnMap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:mapButton];
    }
    
}



- (void) receivePostEditingNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PostEditingStarted"]){
        [toolbar removeFromSuperview];
        scroolKeyboardView.scrollEnabled =NO;
    }else if([[notification name] isEqualToString:@"PostEditingEnded"]) {
        [self.view addSubview:toolbar];
        scroolKeyboardView.scrollEnabled =YES;
    }
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
  
    if ([[touch.view superclass] isSubclassOfClass:[UIControl class]] || !toolbarEnabeld || [touch.view.superview isKindOfClass:[AnimalQuestionsCell class]]) {
        
        return NO;
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
