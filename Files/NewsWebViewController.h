//
//  NewsWebViewController.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LBYouTubePlayerController.h"

@interface NewsWebViewController : UIViewController<UIWebViewDelegate,LBYouTubePlayerControllerDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *progressHud;
}

@property (weak ,nonatomic) IBOutlet UIWebView *webView;
@property (weak ,nonatomic) IBOutlet PFImageView *imageView;
@property (weak ,nonatomic) IBOutlet UIButton *playVideoButton;

@property  (strong,nonatomic) PFObject *news;

@end
