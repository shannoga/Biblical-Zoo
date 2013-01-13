//
//  AnimalDataScrollView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"
#import "AnimalAudioGuideView.h"

#import "AnimalViewController.h"

@class AnimalViewController,AnimalPostView;

@interface AnimalDataScrollView : UIScrollView {
    NSArray *tableViewdata;
   
}
@property (nonatomic, retain) AnimalViewController *parentController;
@property (nonatomic, weak) Animal *animal;
@property (nonatomic, strong) AnimalAudioGuideView *audioGuide;
@property (nonatomic, retain)  AnimalPostView *postView;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;
-(void)play;
-(void)pause;
-(void)stop;
-(void)togglePlayPause;
-(void)getAnimalPosts;

@end
