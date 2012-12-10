//
//  NewsWebView.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import "NewsWebViewController.h"
#import <Parse/Parse.h>
#import "NSData+Encoding.h"
#import <QuartzCore/QuartzCore.h>
#import "LBYouTubeView.h"

@implementation NewsWebViewController


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
    scrollView.contentSize = CGSizeMake(320, fittingSize.height+300);
    aWebView.frame = frame;
    
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 395)];
    bgView.backgroundColor = UIColorFromRGB(0xf8eddf);
    [self.view addSubview:bgView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(320, 480);
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    
    if (news[@"youTubeUrl"]) {
        LBYouTubeView* youTubeView = [[LBYouTubeView alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
        youTubeView.delegate = self;
        youTubeView.highQuality = YES;
        youTubeView.layer.borderColor = [UIColor whiteColor].CGColor;
        youTubeView.layer.borderWidth = 5;
        [scrollView addSubview:youTubeView];
        [youTubeView loadYouTubeURL:[NSURL URLWithString:news[@"youTubeUrl"]]];
        [youTubeView play];
    }else{
        PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
        imageView.image = [UIImage imageNamed:@"news_big_placeholder.png"]; // placeholder image
        imageView.file = (PFFile *)news[@"main_image"]; // remote image
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 5;
        [imageView loadInBackground];
        [scrollView addSubview:imageView];
        
        NSLog(@"rect = %@",NSStringFromCGRect(imageView.frame
                                              ));

        
    
    }
    
	UIWebView *descriptionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200,320 ,370)];
	descriptionView.frame = CGRectInset(descriptionView.frame, CGRectGetWidth(self.view.frame)*.03 , CGRectGetHeight(self.view.frame)*.02);
	descriptionView.opaque=NO;
	descriptionView.delegate=self;
	NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style-news" ofType:@"css"];
	//do base url for css
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	descriptionView.backgroundColor = [UIColor clearColor];
	
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
    
	
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self
                                                                                          action:@selector(share)];
}



@end
