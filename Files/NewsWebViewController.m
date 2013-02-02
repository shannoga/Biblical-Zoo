//
//  NewsWebView.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import "NewsWebViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsWebViewController
@synthesize news;
@synthesize scrollView;
@synthesize controller;

- (id)initWithObject:(PFObject*)newsToSet{
    
    self = [super init];
    if (self) {
        
		news = (PFObject*)newsToSet;
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.scrollView.contentSize = CGSizeMake(320, fittingSize.height+300);
    aWebView.frame = frame;
    
    //NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}
- (void)viewDidLoad {	
	
	self.view.backgroundColor = UIColorFromRGB(0x3a2918);

	NSString *dir;
	NSString *langClass;

	if ([[Helper currentLang] isEqualToString:@"en"]) {
		dir = @"ltr";
		langClass = @"";
	}else{
        dir = @"rtl";
		langClass = @"dirrtl"; 
    }
    self.view.backgroundColor = UIColorFromRGB(0x3a2918);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 5, 0)];
    bgView.backgroundColor = UIColorFromRGB(0xf8eddf);
    [self.view addSubview:bgView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(320, 480);
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
    NSLog(@"news =%@",news[@"youTubeUrl"]);
    if (![news[@"youTubeUrl"] isEqualToString:@""] && news[@"youTubeUrl"]) {
        
        self.controller = [[LBYouTubePlayerController alloc] initWithYouTubeURL:[NSURL URLWithString:news[@"youTubeUrl"]] quality:LBYouTubeVideoQualityLarge];
        self.controller.delegate = self;
        self.controller.view.frame = CGRectMake(20.0f, 20.0f, 280.0f, 200.0f);
        self.controller.view.layer.borderColor = [UIColor whiteColor].CGColor;
        self.controller.view.layer.borderWidth = 5;
        [scrollView addSubview:self.controller.view];
        
        progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHud];
        progressHud.labelText = NSLocalizedString(@"Loading Video", nil);
        [progressHud show:YES];
        
       
    }else{
        PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
        imageView.image = [UIImage imageNamed:@"news_big_placeholder.png"]; // placeholder image
        imageView.file = (PFFile *)news[@"main_image"]; // remote image
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 5;
        [imageView loadInBackground];
        [scrollView addSubview:imageView];

    }
    
	UIWebView *descriptionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200,320 ,370)];
	//descriptionView.frame = CGRectInset(descriptionView.frame, CGRectGetWidth(self.view.frame)*.03 , CGRectGetHeight(self.view.frame)*.02);
	descriptionView.delegate=self;
    descriptionView.opaque =NO;
    descriptionView.backgroundColor =[UIColor clearColor];
	NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style-news" ofType:@"css"];
	//do base url for css
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	  
	NSDate *date =news.updatedAt;
	
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
   	NSString *title = [[Helper currentLang] isEqualToString:@"en"]? news[@"title"]:news[@"title_he"];
    NSString *subtitle = [[Helper currentLang] isEqualToString:@"en"]? news[@"subtitle"]:news[@"subtitle_he"];
    NSString *text = [[Helper currentLang] isEqualToString:@"en"]? news[@"text"]:news[@"text_he"];
    
	NSString *html =[NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"%@\" dir=\"%@\"><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><article class=\"%@\"><h1>%@</h1><h4>%@</h4><p class=\"%@\">%@</p></article><br><footer>Publishd:<time pubdate>%@</time></footer> </body></html>",
					 [Helper currentLang],dir,cssPath,langClass,title,subtitle,dir,text,formattedDateString];
	
	[descriptionView loadHTMLString:html baseURL:baseURL];  
	[scrollView addSubview:descriptionView];
    
	/*
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(share)];
    
   */
}

#pragma mark -
#pragma mark LBYouTubePlayerViewControllerDelegate

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL{
    [progressHud hide:YES];
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error{
    NSLog(@"Error extracting video error = %@",[error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attantion", nil)
                                                    message:NSLocalizedString(@"Problem Loading Video", nill) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
    [alert show];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end
