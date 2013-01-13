//
//  AnimalViewToolbar.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/3/12.
//
//

#import "AnimalViewToolbar.h"


#define kDataTable 0
#define kGeneralDescription 1
#define kZooDescription 2
#define kMap 3
#define kPosts 4
#define kAudioGuide 5


@implementation AnimalViewToolbar
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame withAudioGuide:(BOOL)hasAudioGuide withDisTributaionMap:(BOOL)hasMap withZooDescription:(BOOL)hasZooDescription isGeneralExhibitDescription:(BOOL)isGeneralExhibitDescription
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *buttonsArray = [NSMutableArray array];

        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [buttonsArray addObject:flexItem];
        UIBarButtonItem *btn;
         if (!isGeneralExhibitDescription) {
         btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"data"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
        btn.tag = kDataTable;
        [buttonsArray addObject:btn];
        [buttonsArray addObject:flexItem];
          }
       
            btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"description"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
            btn.tag = kGeneralDescription;
            [buttonsArray addObject:btn];
       
            [buttonsArray addObject:flexItem];
      
        
        
        
        
        if (hasZooDescription) {
            btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"zoodes"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
            btn.tag = kZooDescription;
            [buttonsArray addObject:btn];
          
            [buttonsArray addObject:flexItem];
        }
      
        if(hasMap){
            btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dis_map"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
            btn.tag = kMap;
            [buttonsArray addObject:btn];
       
            [buttonsArray addObject:flexItem];
        }
        
        btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
        btn.tag = kPosts;
        [buttonsArray addObject:btn];
   
        [buttonsArray addObject:flexItem];
        
        
        
        if(hasAudioGuide){
            btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"audioGuide"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
            btn.tag = kAudioGuide;
            [buttonsArray addObject:btn];
            [buttonsArray addObject:flexItem];
        }
        
        
        [self setItems:buttonsArray];
    }
    return self;
}


-(void)buttonTapped:(UIBarButtonItem*)sender{
    [[self delegate] userTappedOnbuttonWithIndex:sender.tag];
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
