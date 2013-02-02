//
//  EventDetailsViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailsViewController : UIViewController{
    UILabel *typeLabel;
    UILabel *titleLabel;
    UILabel *LocationLabel;
    UILabel *dateLabel;
    UILabel *timeLabel;
    UITextView *descriptionView;
    UIImageView *iconView;
    UIButton *callBtn;
    UIButton *saveBtn;

}
@property (nonatomic, assign)  Event *event;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UITextView *descriptionView;
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UIButton *callBtn;
@property (nonatomic, strong) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) IBOutlet UIButton *saveBtnBig;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UILabel *notifLabel;
@property (nonatomic, strong) IBOutlet UILabel *shareLabel;
@property (nonatomic, strong) IBOutlet UILabel *callLabel;

-(IBAction)callZoo:(id)sender;
-(IBAction)saveToDiary:(id)sender;
-(IBAction)shareEvent:(id)sender;
-(IBAction)dismiss:(id)sender;
@end
