//
//  FunViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>

@interface FunViewController : UIViewController<PF_FBRequestDelegate,NSURLConnectionDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    UIBarButtonItem *facebookButton;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UIButton *signBtn;
@property (nonatomic, strong) IBOutlet UIButton *cameraBtn;
@property (nonatomic, strong) IBOutlet UIButton *zooCamera;
@property (nonatomic, strong) IBOutlet UIButton *questionsButton;
@property (nonatomic, strong) IBOutlet UILabel *facebookName;
@property (nonatomic, strong) IBOutlet UIView *facebookView;
@property (nonatomic, strong) IBOutlet UILabel *animalisticCameraLabel;
@property (nonatomic, strong) IBOutlet UILabel *simpleCameraLabel;
@property (nonatomic, strong) IBOutlet UILabel *signLabel;
-(IBAction)opsenSignGenerator:(id)sender;
-(IBAction)openZooPhotographerCamera:(id)sender;
-(IBAction)openShareCamera:(id)sender;
-(IBAction)openQuestions:(id)sender;
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@end
