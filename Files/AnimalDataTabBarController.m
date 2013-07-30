//
//  AnimalDataTabBarController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDataTabBarController.h"
#import "Animal.h"
#import "AnimalDescriptionWebView.h"
#import "AnimalAudioGuideViewController.h"
#import "AnimalDataTableView.h"
#import "AnimalPostView.h"
#import "AnimalViewController.h"
#import "AnimalQuestionsTableView.h"
#import "Exhibit.h"
#import "AnimalSpecificQuestionsTableView.h"
#import "AnimalPostsTableViewController.h"
#import "ConservasionStatusIndicator.h"

@implementation AnimalDataTabBarController
@synthesize animal;
@synthesize audioGuide;
@synthesize parentController;
@synthesize postView;

- (id)initWithAnimal:(Animal*)anAnimal
{
    self = [super init];
    if (self) {
        
        
        self.view.backgroundColor = UIColorFromRGB(0xf8eddf);
        self.animal = anAnimal;
        //conservation sataus ind
        ConservasionStatusIndicator *consInd;
        if(IS_IPHONE_5){
            consInd = [[ConservasionStatusIndicator alloc] initWithFrame:CGRectMake(0, 2, 320, 26)];
        }else{
            consInd = [[ConservasionStatusIndicator alloc] initWithFrame:CGRectMake(0, 2, 320, 20)];
        }
        [consInd setAnimal:self.animal];
        [self.view addSubview:consInd];
        
        
        
        /*****************************************/
        /*data table view*/
        /*****************************************/
        if(![anAnimal.generalExhibitDescription boolValue]){
            AnimalDataTableView *dataTableView = [[AnimalDataTableView alloc] initWithStyle:UITableViewStylePlain withAnimal:anAnimal];
            [self addChildViewController:dataTableView];
        }
        
        /*****************************************/
        /* Description view*/
        /*****************************************/

        AnimalDescriptionWebView *descriptionViewController = [[AnimalDescriptionWebView alloc] initWithAnimal:anAnimal];
        [self addChildViewController:descriptionViewController];

        
        
        /*****************************************/
        /* map view*/
        /*****************************************/
        /*
        UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(960, 0, 320, self.contentSize.height)];
        mapView.backgroundColor = UIColorFromRGB(0xf8eddf);
        
        UIImage *image = [anAnimal distributaionMap];
        if(image){
             UIImageView *mapImageView = [[UIImageView alloc] initWithImage:image];
            [mapImageView setFrame:mapView.frame];
            [mapView addSubview:mapImageView];
        }
        */
        /*****************************************/
        /* post view*/
        /*****************************************/
        /*
        self.postView = [[AnimalPostView alloc] initWithFrame:CGRectMake(1280, 0, 320, self.contentSize.height) withAnimal:anAnimal];
        [self addSubview:self.postView];
         */
        AnimalPostsTableViewController *animalPostsTableViewController = [[AnimalPostsTableViewController alloc] initWithStyle:UITableViewStylePlain forAnimal:anAnimal];
        [self addChildViewController:animalPostsTableViewController];

        
        AnimalQuestionsTableView * animalQuestions = [[AnimalQuestionsTableView alloc] initWithStyle:UITableViewStylePlain forAnimal:anAnimal];
        [self addChildViewController:animalQuestions];

        
        /*****************************************/
        /* audioGuide view*/
        /*****************************************/
        if([anAnimal.audioGuide boolValue]){
            audioGuide = [[AnimalAudioGuideViewController alloc] initWithAniaml:anAnimal];
            [self addChildViewController:audioGuide];
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
