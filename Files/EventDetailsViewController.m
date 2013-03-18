//
//  EventDetailsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController
@synthesize typeLabel;
@synthesize titleLabel;
@synthesize locationLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize descriptionView;
@synthesize iconView;
@synthesize callBtn;
@synthesize saveBtn;
@synthesize shareButton;
@synthesize event;
@synthesize notifLabel;
@synthesize callLabel;
@synthesize shareLabel;
@synthesize saveBtnBig;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.typeLabel.text = [Helper languageSelectedStringForKey:[event typeString]];
     self.titleLabel.text =  [event title];
     self.locationLabel.text =  [event location];
     self.dateLabel.text =  [event dateAsString];
     self.timeLabel.text =  [event timeAsString];
    //hotfix
    NSString *description = event.eventDescription;
    description = [description stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    self.descriptionView.text =  description;
    [self.iconView setImage:[event icon]];
    
    NSArray *cellColors = [event colors];
    
 
    self.view.backgroundColor = [UIColor colorWithCGColor:(CGColorRef)cellColors[0]];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]]){
        self.callBtn.hidden = YES;
        [self.callBtn removeFromSuperview];
         self.callLabel.hidden = YES;
        [self.callLabel removeFromSuperview];
       // self.saveBtn.frame = CGRectOffset(self.saveBtn.frame, -90, 0);
       // self.saveBtnBig.frame = CGRectOffset(self.saveBtnBig.frame, -90, 0);
      //  self.notifLabel.frame = CGRectOffset(self.notifLabel.frame, -90, 0);
    }
#warning add in the future
    self.shareLabel.hidden = YES;
    self.shareButton.hidden =YES;
}

-(IBAction)dismiss:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)callZoo:(id)sender{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:026750111"]];
}



-(IBAction)saveToDiary:(id)sender{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
    NSDate *alertDate = [event.startDate dateByAddingTimeInterval:-1200];
    [localNotification setFireDate:alertDate];
    NSLog(@"fire date = %@",localNotification.fireDate);
    [localNotification setAlertAction:[Helper languageSelectedStringForKey:@"Launch"]];
    NSString * localString = [Helper languageSelectedStringForKey:@"Will start in 20 minutes"];
    NSString * str = [NSString stringWithFormat:@"%@ %@",event.title,localString];
    [localNotification setAlertBody:str];
    [localNotification setSoundName:@"notification_sound.aif"];
    [localNotification setHasAction: YES]; //Set that pushing the button will launch the application
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
    [localNotification setUserInfo:@{@"test":[self.event title]}];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; 
    [BugSenseController sendCustomEventWithTag:@"seted alert to event"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Great"]
                                                    message:[Helper languageSelectedStringForKey:@"Your notification had been set"] delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
}

-(IBAction)shareEvent:(id)sender{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
