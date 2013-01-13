//
//  AnimalViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 17/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "AnimalViewController.h"
#import "AnimalsImagesScrollView.h"
#import "AnimalDataScrollView.h"
#import "ConservasionStatusIndicator.h"
#import "AnimalViewToolbar.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Exhibit.h"
#define kDataTable 0
#define kGeneralDescription 1
//#define kZooDescription 2
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
@synthesize animalDataScrollView;
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
        
    }
    return self;
}


- (void)toggleFullscreen {
     if(!IS_IPHONE_5){
        _fullscreen = !_fullscreen;
        if (_fullscreen) { 
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        } else {
          
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
     }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(toggleFullscreen) withObject:nil afterDelay:.5];
    //Once the view has loaded then we can register o begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
     [self.animalDataScrollView stop];
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
            [self.animalDataScrollView play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.animalDataScrollView pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self.animalDataScrollView togglePlayPause];
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

-(void)userTappedOnbuttonWithIndex:(NSUInteger)index{
    
    [self.animalDataScrollView setContentOffset:CGPointMake(320*index, 0) animated:YES];
    if(index==4){
        [self.animalDataScrollView getAnimalPosts];
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
     consInd = [[ConservasionStatusIndicator alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
    [consInd setAnimal:self.animal];
    [scroolKeyboardView addSubview:consInd];
    
    
    AnimalsImagesScrollView *imagesScrollView;
    if(IS_IPHONE_5){
        imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 28, 320, 190) withAnimal:self.animal];
    }else{
        imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 190) withAnimal:self.animal];
    }
    [scroolKeyboardView addSubview:imagesScrollView];
	
      if(IS_IPHONE_5){
          self.animalDataScrollView = [[AnimalDataScrollView alloc] initWithFrame:CGRectMake(0, 218, 320, 240) withAnimal:self.animal];
                                                    
      }else{
          self.animalDataScrollView = [[AnimalDataScrollView alloc] initWithFrame:CGRectMake(0, 210, 320, 220) withAnimal:self.animal];
      }
    self.animalDataScrollView.scrollsToTop = NO;
    self.animalDataScrollView.scrollEnabled =NO;
    self.animalDataScrollView.delegate = self;
    self.animalDataScrollView.parentController = self;
    [scroolKeyboardView addSubview:animalDataScrollView];
    
 
     if(!IS_IPHONE_5){
         toolbar = [[AnimalViewToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, 320, 30) withAudioGuide:[[self.animal audioGuide] boolValue] withDisTributaionMap:NO withZooDescription:NO isGeneralExhibitDescription:[[self.animal generalExhibitDescription] boolValue]];
     }else{
        toolbar = [[AnimalViewToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-88, 320, 44) withAudioGuide:[[self.animal audioGuide] boolValue] withDisTributaionMap:NO withZooDescription:NO isGeneralExhibitDescription:[[self.animal generalExhibitDescription] boolValue]];
     }
    toolbar.delegate = self;
    [toolbar becomeFirstResponder];
    [scroolKeyboardView addSubview:toolbar];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleFullscreenWithTimer)];
    tapRecognizer.delegate = self;
    [scroolKeyboardView addGestureRecognizer:tapRecognizer];
    
    if ([[self.animal generalExhibitDescription] boolValue]) {
        [self userTappedOnbuttonWithIndex:1];
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
    if ([[touch.view superclass] isSubclassOfClass:[UIControl class]] || !toolbarEnabeld) {
        return NO;
    }
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
