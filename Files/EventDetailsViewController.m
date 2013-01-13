//
//  EventDetailsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>
#import "NSDate-Utilities.h"
#import "Event.h"
@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController
@synthesize typeLabel = _typeLabel;
@synthesize titleLabel = _titleLabel;
@synthesize locationLabel = _LocationLabel;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
@synthesize descriptionView = _descriptionView;
@synthesize iconView = _iconView;
@synthesize callBtn = _callBtn;
@synthesize saveBtn = _saveBtn;
@synthesize event;



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
    
    
    self.typeLabel.text = NSLocalizedString([event typeString], nil) ;
     self.titleLabel.text =  [event title];
     self.locationLabel.text =  [event location];
     self.dateLabel.text =  [event dateAsString];
     self.timeLabel.text =  [event timeAsString];
     self.descriptionView.text =  [event eventDescription];
    [self.iconView setImage:[event icon]]; 
    
    NSArray *cellColors = [event colors];
    
 
    self.view.backgroundColor = [UIColor colorWithCGColor:(CGColorRef)cellColors[0]];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]]){
        self.callBtn.hidden = YES;
    }
  
}

-(IBAction)dissmis:(id)sender{
    NSLog(@"Dissmis");
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)callZoo:(id)sender{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:026750111"]];
}



-(IBAction)saveToDiary:(id)sender{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init]; //Create the localNotification object
    NSDate *newDate = [[event.startDate toLocalTime] dateByAddingTimeInterval:-60*1];
    [localNotification setFireDate:[[NSDate date] dateByAddingTimeInterval:10]];
    NSLog(@"fire date = %@",localNotification.fireDate);
    [localNotification setAlertAction:@"Launch"]; 
    [localNotification setAlertBody:@"local notif test"];
    [localNotification setSoundName:@"notification_sound"];
    [localNotification setHasAction: YES]; //Set that pushing the button will launch the application
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
    [localNotification setUserInfo:@{@"test":[self.event title]}];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; 

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
