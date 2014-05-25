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
//@synthesize youtubeController;

- (id)initWithObject:(PFObject*)newsToSet{
    
    self = [super init];
    if (self) {
       // MP_EXTERN NSString *const XCDYouTubeVideoErrorDomain;
       // MP_EXTERN NSString *const XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDomainError:) name:XCDYouTubeVideoErrorDomain object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishError:) name:XCDYouTubeVideoErrorDomain object:nil];
		news = (PFObject*)newsToSet;
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)playerDomainError:(NSNotification *)notif
{
    NSLog(@"");

}
- (void)playerDidFinishError:(NSNotification *)notif
{
    NSLog(@"");
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
}
- (void)viewDidLoad {	
	

	NSString *dir;
	NSString *langClass;

	if ([Helper appLang] == kEnglish) {
		dir = @"ltr";
		langClass = @"";
	}else{
        dir = @"rtl";
		langClass = @"dirrtl"; 
    }
    self.view.backgroundColor = UIColorFromRGB(0xEEF2E6);
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 5, 0)];
//    bgView.backgroundColor = UIColorFromRGB(0xf8eddf);
//    [self.view addSubview:bgView];
    
    
    NSLog(@"news =%@",news[@"youTubeUrl"]);
    
    self.imageView.image = [UIImage imageNamed:@"news_big_placeholder.png"]; // placeholder image
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 5;
    
    if(news[@"main_image"]!= [NSNull null]){
        PFFile *thumbnail = news[@"main_image"];
        self.imageView.file = thumbnail;
        [self.imageView loadInBackground];
    }
    self.playVideoButton.hidden = YES;

    if (![news[@"youTubeUrl"] isEqualToString:@""] && news[@"youTubeUrl"]) {
        
        self.playVideoButton.hidden = NO;
       
    }
    
	//descriptionView.frame = CGRectInset(descriptionView.frame, CGRectGetWidth(self.view.frame)*.03 , CGRectGetHeight(self.view.frame)*.02);
	self.webView.delegate= self;
    self.webView.opaque = NO;
    self.webView.backgroundColor =[UIColor clearColor];
	NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style-news" ofType:@"css"];
	//do base url for css
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	  
	NSDate *date =news.updatedAt;
	
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
   	NSString *title = [Helper appLang] == kEnglish? news[@"title"]:news[@"title_he"];
    NSString *subtitle = [Helper appLang] == kEnglish? news[@"subtitle"]:news[@"subtitle_he"];
    NSString *text = [Helper appLang] == kEnglish? news[@"text"]:news[@"text_he"];
    
	NSString *html =[NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"%@\" dir=\"%@\"><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><article class=\"%@\"><h1>%@</h1><h4>%@</h4><p class=\"%@\">%@</p></article><br><footer>Publishd:<time pubdate>%@</time></footer> </body></html>",
					 [Helper appLang] == kEnglish?@"en":@"he",dir,cssPath,langClass,title,subtitle,dir,text,formattedDateString];
	
	[self.webView loadHTMLString:html baseURL:baseURL];
    

}

- (IBAction)playVideo:(id)sender
{
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:news[@"youTubeUrl"]];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end
