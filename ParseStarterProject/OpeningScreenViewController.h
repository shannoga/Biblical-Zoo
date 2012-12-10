//
//  OpeningScreenViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 01/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningScreenViewController : UIViewController<MBProgressHUDDelegate>{
    IBOutlet UIImageView * imageview;
    IBOutlet UIButton * madad;
    IBOutlet UIButton * enter;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    IBOutlet UISegmentedControl *langSwitch;
    
}
@property (nonatomic,retain) IBOutlet UIImageView * imageview;
@property (nonatomic,retain) IBOutlet UIButton * madad;
@property (nonatomic,retain) IBOutlet UIButton * enter;
@property (nonatomic,retain) IBOutlet UISegmentedControl *langSwitch;
-(IBAction)showMadad:(id)sender;
-(IBAction)enter:(id)sender;
- (IBAction)downLoadFirstTimeAnimals;
- (IBAction)downLoadAudioGuide;
-(IBAction)changeLang:(id)sender;
@end
