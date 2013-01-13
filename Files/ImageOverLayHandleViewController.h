//
//  ImageOverLayHandleViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@class CapturedImageViewController;
@interface ImageOverLayHandleViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,PF_FBRequestDelegate,UIAlertViewDelegate>{
    UIImageView *photoImageView;
    UIImage *photoImage;
    UIBarButtonItem *previewButton;
    BOOL stopLoop;
}
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIImage *photoImage;
@property (nonatomic,strong) UIImage *selectedOverLay;
@property (nonatomic,strong) UIImageView *imagesContainer;
@property (nonatomic,strong) UIView *uniteImagesView ;
@property (nonatomic,strong) CapturedImageViewController * capturedImageViewController;
@property (nonatomic) BOOL fullscreen;
@end
