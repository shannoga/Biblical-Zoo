//
//  SettingsViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 2/20/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (nonatomic,retain) IBOutlet UIButton *restoreButton;

@property (nonatomic,retain) IBOutlet UISegmentedControl *langSelector;

@property NSInteger openingLang;

-(IBAction)emailUs:(id)sender;
-(IBAction)rateApp:(id)sender;
-(IBAction)shareApp:(id)sender;
@end
