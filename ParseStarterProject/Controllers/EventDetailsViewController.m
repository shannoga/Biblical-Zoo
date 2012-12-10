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
    
    
    self.typeLabel.text = [event typeString] ;
     self.titleLabel.text =  [event title];
     self.locationLabel.text =  [event location];
     self.dateLabel.text =  [event dateAsString];
     self.timeLabel.text =  [event timeAsString];
     self.descriptionView.text =  [event eventDescription];
    [self.iconView setImage:[event icon]]; 
    
    NSArray *cellColors = [event colors];
    
 
    self.view.backgroundColor = [UIColor colorWithCGColor:(CGColorRef)cellColors[0]];
}

-(IBAction)callZoo:(id)sender{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:026750111"]];
}

-(IBAction)saveToDiary:(id)sender{
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
    
	myEvent.title     =event.title;
    myEvent.startDate = event.startDate;
    myEvent.endDate = event.startDate;
    myEvent.location = event.location;
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    NSError *err;
    
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; 
    
	if (err == noErr) {
		UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Event Created",nil)
                              message:NSLocalizedString(@"Yay!?",nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Okay",nil)
                              otherButtonTitles:nil];
		[alert show];
	
	}else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Problem Creating Event",nil)
                              message:[err localizedDescription]
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Dissmis",nil)
                              otherButtonTitles:nil];
		[alert show];
	
    }
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
