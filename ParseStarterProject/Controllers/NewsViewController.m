//
//  NewsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "NewsViewController.h"
#import <Parse/Parse.h>
@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize newsObject = _newsObject;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize textView = _textView;

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
    
    self.titleLabel.text = (self.newsObject)[@"title"];
    self.subTitleLabel.text = (self.newsObject)[@"title"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    //Optionally for time zone converstions
    //[formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:newsObject.createdAt];
    self.dateLabel.text = stringFromDate;
    
    PFFile *mainImage = (self.newsObject)[@"main_image"];
    NSData *imageData = [mainImage getData];
    
    [self.imageView setImage:[UIImage imageWithData:imageData]];
    self.textView.text = (self.newsObject)[@"text"];
    // Do any additional setup after loading the view from its nib.
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
