//
//  AnimalDataTabBarController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"
#import "AnimalAudioGuideViewController.h"

#import "AnimalViewController.h"

@class AnimalViewController,AnimalPostView;

@interface AnimalDataTabBarController : UITabBarController {
    NSArray *tableViewdata;
   
}
@property (nonatomic, retain) AnimalViewController *parentController;
@property (nonatomic, assign) __unsafe_unretained Animal *animal;
@property (nonatomic, strong) AnimalAudioGuideViewController *audioGuide;
@property (nonatomic, retain)  AnimalPostView *postView;
- (id)initWithAnimal:(Animal*)anAnimal;
-(void)play;
-(void)pause;
-(void)stop;
-(void)togglePlayPause;
-(void)getAnimalPosts;

@end
