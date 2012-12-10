//
//  FunViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunViewController : UIViewController<PF_FBRequestDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>{
    IBOutlet UIButton *signBtn;
    IBOutlet UIButton *cameraBtn;
    IBOutlet UILabel *facebookName;
    IBOutlet UILabel *animalisticCameraLabel;
    IBOutlet UILabel *simpleCameraLabel;
    IBOutlet UILabel *signLabel;
    IBOutlet UIImageView *facebookImage;
    IBOutlet UIView *facebookView;
    NSMutableData *imageData;
    UIImageView *treesView;
    UIView *cloudsView ;
    CALayer *cloud;
    UIBarButtonItem *facebookButton;
}

@property (nonatomic, unsafe_unretained) IBOutlet UIButton *signBtn;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *cameraBtn;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *facebookName;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *facebookImage;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *treesView;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *facebookView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *animalisticCameraLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *simpleCameraLabel;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *signLabel;

-(IBAction)opsenSignGenerator:(id)sender;
-(IBAction)openCamera:(id)sender;
-(IBAction)opsenShareCaera:(id)sender;
@end
