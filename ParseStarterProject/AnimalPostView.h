//
//  AnimalPostView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/3/12.
//
//

#import <UIKit/UIKit.h>
@class Animal,AnimalUserPostsViewer;



@interface AnimalPostView : UIView<UITextFieldDelegate,UITextViewDelegate>{
    
    NSInteger currentPostNumber;
}
@property (nonatomic,retain) UITextView *postView;
@property (nonatomic,retain) UILabel *labelView;
@property (nonatomic, retain) UIView *addPostView;
@property (nonatomic,retain) UIButton *viewPosts;
@property (nonatomic,retain) UITextField *userName;
@property (nonatomic,retain) UITextField *cityField;
@property (nonatomic,unsafe_unretained) Animal *animal;
@property (nonatomic,retain) AnimalUserPostsViewer *postViewer;
@property (nonatomic, retain) NSArray * posts;
@property (nonatomic, retain) UIButton *prev;
@property (nonatomic, retain) UIButton *next;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;

-(void)getPosts;

@end
