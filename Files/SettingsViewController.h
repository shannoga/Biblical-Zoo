//
//  SettingsViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 2/20/13.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic,retain) IBOutlet UIButton *restoreButton;
@property (nonatomic,retain) IBOutlet UISegmentedControl *langSelector;
@property NSInteger openingLang;
@end
