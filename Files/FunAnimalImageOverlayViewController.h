//
//  FunAnimalImageOverlayViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/17/12.
//
//

#import <UIKit/UIKit.h>
#import "CapturedImageViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FunAnimalImageOverlayViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,PF_FBRequestDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIScrollView * overlayesScrollView;
@property (nonatomic, strong) NSArray *overlayImages;
@property NSInteger selectedOverLayIndex;

@property (nonatomic,strong) UIBarButtonItem *previewButton;
@property (nonatomic,strong) UIImage *selectedOverLay;
@property (nonatomic,strong) UIImageView *imagesContainer;
@property (nonatomic,strong) UIView *uniteImagesView ;
@property (nonatomic,strong) CapturedImageViewController * capturedImageViewController;
@property (nonatomic,strong) UIImage *photoImage;
@property (nonatomic,strong) UIToolbar *toolbar;
@property BOOL pickerVisible;
@property (nonatomic, strong) UIButton *closeButton;
@end
