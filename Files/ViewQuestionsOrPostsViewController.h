//
//  ViewQuestionsOrPostsViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/16/14.
//
//

#import <Parse/Parse.h>
typedef NS_ENUM(NSUInteger, ViewerPostType)
{
    ViewerPostTypePost,
    ViewerPostTypeQuestion
};

@interface ViewQuestionsOrPostsViewController : PFQueryTableViewController
@property (nonatomic, strong) Animal *animal;
@property (nonatomic) ViewerPostType postType;
@end
