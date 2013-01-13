//
//  AnimalPostView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/3/12.
//
//

#import <UIKit/UIKit.h>
#import "AnimalAddPostView.h"
@class Animal,AnimalUserPostsViewer;



@interface AnimalPostView : UIView<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate>{
    
    NSInteger currentPostNumber;
    MBProgressHUD *refreshHUD;
    UIView *buttonsBackgroundView;
}
@property (nonatomic,strong) UITextView *beTheFirstLabel;
@property (nonatomic,strong) AnimalAddPostView *addPostView;
@property (nonatomic,strong) UIView *explinationView;
@property (nonatomic,strong) UIButton *loadPostsBtn;
@property (nonatomic,strong) UIButton *viewPosts;
@property (nonatomic,weak) Animal *animal;
@property (nonatomic,strong) AnimalUserPostsViewer *postViewer;
@property (nonatomic, strong) NSMutableArray * posts;
@property (nonatomic, strong) UIButton *prev;
@property (nonatomic, strong) UIButton *next;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;

-(void)getPosts:(BOOL)fromButton;

@end
