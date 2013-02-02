//
//  SignForFreindViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface SignForFreindViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MBProgressHUDDelegate>{
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *latinNameTF;
    IBOutlet UITextView *habitatTV;
    IBOutlet UITextView *dietTV;
    IBOutlet UITextView *socialStructureTV;
    IBOutlet UITextView *descriptionTV;
    IBOutlet UIButton *showSignButton;
    IBOutlet UIImageView *thumbnailImageView;
    IBOutlet UIButton *showCameraBtn;
    IBOutlet UIView *captureView;
    
    IBOutlet UILabel *habitatLBL;
    IBOutlet UILabel *dietLBL;
    IBOutlet UILabel *descriptionLBL;
    IBOutlet UILabel *socialStructureLBL;
    
    BOOL shouldGoUp;
    BOOL fullscreen;
    
    MBProgressHUD * progressHUD;
}
@property (nonatomic,retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UITextField *nameTF;
@property (nonatomic,retain) IBOutlet UITextField *latinNameTF;
@property (nonatomic,retain) IBOutlet UITextView *habitatTV;
@property (nonatomic,retain) IBOutlet UITextView *dietTV;
@property (nonatomic,retain) IBOutlet UITextView *descriptionTV;
@property (nonatomic,retain) IBOutlet UIButton *showSignButton;

@property (nonatomic,retain) IBOutlet UILabel *habitatLBL;
@property (nonatomic,retain) IBOutlet UILabel *dietLBL;
@property (nonatomic,retain) IBOutlet UILabel *descriptionLBL;
@property (nonatomic,retain) IBOutlet UILabel *socialStructureLBL;

@property (nonatomic,retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic,retain) IBOutlet UIButton *showCameraBtn;
@property (nonatomic,retain) IBOutlet UITextView *socialStructureTV;

@property (nonatomic,retain)  UIImage *generatedImage;
@property (nonatomic,retain) IBOutlet UIView *captureView;

@property (nonatomic,retain) UIView * previewView;

@property (nonatomic) BOOL fullscreen;
-(IBAction)showSignPreview:(id)sender;
-(IBAction)showCamera:(id)sender;
@end


