//
//  VisitorsIMageUploadTableViewController.h
//  
//
//  Created by shani hajbi on 6/1/14.
//
//

#import <UIKit/UIKit.h>

@interface VisitorsImageUploadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLabel;
@property (nonatomic, strong) Animal *animal;
@property (nonatomic, strong) UIImage *userImage;

- (IBAction)sendImage:(id)sender;
@end
