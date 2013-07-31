//
//  ZooInfoViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/7/13.
//
//

#import "ZooInfoViewController.h"

@interface ZooInfoViewController ()
@property (nonatomic,strong)UIWebView *web;
@end

@implementation ZooInfoViewController


- (void)viewDidLoad
{
    self.view.backgroundColor = UIColorFromRGB(0xF8EDDF);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, 410)];
    self.web.backgroundColor = UIColorFromRGB(0xF8EDDF);
    self.web.delegate = self;
    if(IS_IPHONE_5){
        self.web.frame = CGRectMake(0, 70, 320, 508);
    }
    
   
    
    //Load the request in the UIWebView.
    [self.web loadRequest:[self request]];
    
    [self.view addSubview:self.web];
}

-(NSURLRequest*)request
{
    NSString *urlAddress = [NSString stringWithFormat:@"http://www.englishclubapp.com/zooInfo/%@.html",[Helper appLang]==kHebrew? @"info":@"info_en"];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    return request;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.web loadRequest:[self request]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    refreshHUD  =  [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:refreshHUD];
    refreshHUD.labelText = [Helper languageSelectedStringForKey:@"Loading"];

    refreshHUD.delegate = self;
    [refreshHUD show:YES];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   [refreshHUD hide:YES]; 
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [refreshHUD hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end
