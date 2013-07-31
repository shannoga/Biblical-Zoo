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
        self.tabBar.backgroundColor = UIColorFromRGB(0xf8eddf);
        self.animal = anAnimal;
       
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"088-Map_white.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showOnMap)];
        
        self.navigationItem.rightBarButtonItem = mapButton;
        
        
        
        /*****************************************/
        /*data table view*/
        /*****************************************/
        if(![anAnimal.generalExhibitDescription boolValue]){
            AnimalDataTableView *dataTableView = [[AnimalDataTableView alloc] initWithStyle:UITableViewStylePlain withAnimal:anAnimal];
            dataTableView.title = [Helper languageSelectedStringForKey:@"In Short"];
            dataTableView.tabBarItem.image =[UIImage imageNamed:@"data"];
            [self addChildViewController:dataTableView];
        }
        
        /*****************************************/
        /* Description view*/
        /*****************************************/

        AnimalDescriptionWebView *descriptionViewController = [[AnimalDescriptionWebView alloc] initWithAnimal:anAnimal];
        descriptionViewController.title = [Helper languageSelectedStringForKey:@"More"];
        descriptionViewController.tabBarItem.image =[UIImage imageNamed:@"description"];
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
        animalPostsTableViewController.title = [Helper languageSelectedStringForKey:@"Posts"];
        animalPostsTableViewController.tabBarItem.image =[UIImage imageNamed:@"post"];
        [self addChildViewController:animalPostsTableViewController];

        
        AnimalQuestionsTableView * animalQuestions = [[AnimalQuestionsTableView alloc] initWithStyle:UITableViewStylePlain forAnimal:anAnimal];
         animalQuestions.title = [Helper languageSelectedStringForKey:@"Q&A"];
        animalQuestions.tabBarItem.image =[UIImage imageNamed:@"248-QuestionCircleAlt"];
        [self addChildViewController:animalQuestions];

        
        /*****************************************/
        /* audioGuide view*/
        /*****************************************/
        if([anAnimal.audioGuide boolValue]){
            audioGuide = [[AnimalAudioGuideViewController alloc] initWithAniaml:anAnimal];
            audioGuide.title = [Helper languageSelectedStringForKey:@"Audio Guide"];
            audioGuide.tabBarItem.image =[UIImage imageNamed:@"audioGuide"];
            [self addChildViewController:audioGuide];
        }
        
   
        
    }
    return self;
}

-(void)showOnMap{
    [Helper setCurrentExhibit:self.animal.exhibit];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop];
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
