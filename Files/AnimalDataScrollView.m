//
//  AnimalDataScrollView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDataScrollView.h"
#import "Animal.h"
#import "AnimalDescriptionWebView.h"
#import "AnimalAudioGuideView.h"
#import "AnimalDataTableView.h"
#import "AnimalPostView.h"
#import "AnimalViewController.h"
#import "AnimalQuestionsTableView.h"
#import "Exhibit.h"
@implementation AnimalDataScrollView
@synthesize animal;
@synthesize audioGuide;
@synthesize parentController;
@synthesize postView;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.contentSize =CGSizeMake(320*6, IS_IPHONE_5? 240 : 226);
        self.scrollEnabled=YES;
        self.scrollsToTop=NO;
        self.pagingEnabled=YES;
        self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = UIColorFromRGB(0xf8eddf);
     
        
        /*****************************************/
        /* table view*/
        /*****************************************/
       
        if(![anAnimal.generalExhibitDescription boolValue]){
            AnimalDataTableView *dataTableView = [[AnimalDataTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.contentSize.height) withAnimal:anAnimal];
            [self addSubview:dataTableView];
        }
        
        /*****************************************/
        /* Description view*/
        /*****************************************/
        
        AnimalDescriptionWebView *descriptionView = [[AnimalDescriptionWebView alloc] initWithFrame:CGRectMake(320, 0, 320, self.contentSize.height) withAnimal:anAnimal];
        [self addSubview:descriptionView];
        
        
       //future feature
        /*****************************************/
        /*Zoo Description view*/
        /*****************************************/
      
         AnimalDescriptionWebView *zooDescriptionView = [[AnimalDescriptionWebView alloc] initWithFrame:CGRectMake(640, 0, 320, self.contentSize.height) withAnimal:anAnimal];
        [self addSubview:zooDescriptionView];
          
        
        /*****************************************/
        /* map view*/
        /*****************************************/
        UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(960, 0, 320, self.contentSize.height)];
        mapView.backgroundColor = UIColorFromRGB(0xf8eddf);
        [self addSubview:mapView];
        
        UIImage *image = [anAnimal distributaionMap];
        if(image){
        UIImageView *mapImageView = [[UIImageView alloc] initWithImage:image];
        [mapImageView setFrame:mapView.frame];
        [mapView addSubview:mapImageView];
        }
        
        /*****************************************/
        /* post view*/
        /*****************************************/
        self.postView = [[AnimalPostView alloc] initWithFrame:CGRectMake(1280, 0, 320, self.contentSize.height) withAnimal:anAnimal];
        [self addSubview:self.postView];
        
        /*****************************************/
        /* audioGuide view*/
        /*****************************************/
        if([anAnimal.audioGuide boolValue]){
        audioGuide = [[AnimalAudioGuideView alloc] initWithFrame:CGRectMake(1600, 0, 320, self.contentSize.height) withAniaml:anAnimal];
        [self addSubview:audioGuide];
        }
        
      
        
    }
    return self;
}
-(void)getAnimalPosts{
    [self.postView getPosts:NO];
}

-(void)togglePlayPause{
     [self.audioGuide togglePlayPause];
}
-(void)play{
    [self.audioGuide play];
}
-(void)pause{
     [self.audioGuide pause];
}
-(void)stop{
     [self.audioGuide stop];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
