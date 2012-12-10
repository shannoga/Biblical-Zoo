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

@interface ImageOverLayHandleViewController : UIViewController<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,PF_FBRequestDelegate,UIAlertViewDelegate>{
    IBOutlet UIImageView *photoImageView;
    UIImage *photoImage;
    UIBarButtonItem *previewButton;
    BOOL stopLoop;
}
   @property (nonatomic,unsafe_unretained) IBOutlet UIImageView *photoImageView;
   @property (nonatomic,strong) UIImage *photoImage;
    @property (nonatomic,strong) UIScrollView *overlayesScrollView;
@property (nonatomic,strong) UIView *uniteImagesView ;
@property (nonatomic) BOOL fullscreen;
   // @property (nonatomic,strong) UIScrollView *overlayesThumbsScrollView;
@end
