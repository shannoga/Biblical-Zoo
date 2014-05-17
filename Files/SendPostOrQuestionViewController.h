//
//  sendPostOrQuestionViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/14/14.
//
//

typedef NS_ENUM(NSUInteger, PostType)
{
    PostTypePost,
    PostTypeQuestion
};

#import <UIKit/UIKit.h>

@interface SendPostOrQuestionViewController : UITableViewController
@property (nonatomic, strong) Animal *animal;
@property (nonatomic, weak) IBOutlet UITextView *contentTextView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *cityTextField;
@property (nonatomic) PostType postType;

@end
