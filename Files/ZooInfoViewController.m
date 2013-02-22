//
//  ZooInfoViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/7/13.
//
//

#import "ZooInfoViewController.h"

@interface ZooInfoViewController ()

@end

@implementation ZooInfoViewController


- (void)viewDidLoad
{
    self.view.backgroundColor = UIColorFromRGB(0xF8EDDF);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, 410)];
    if(IS_IPHONE_5){
        web.frame = CGRectMake(0, 70, 320, 508);
    }
    NSString * fileName = [Helper appLang]==kHebrew? @"info":@"info_en";
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                          pathForResource:fileName ofType:@"html"]isDirectory:NO]]];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
