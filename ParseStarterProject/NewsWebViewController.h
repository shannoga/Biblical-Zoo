//
//  NewsWebViewController.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LBYouTubeView.h"
@interface NewsWebViewController : UIViewController<UIWebViewDelegate,LBYouTubeViewDelegate> {
	PFObject *news;
    UIScrollView *scrollView;
}

- (id)initWithObject:(PFObject*)newsToSet;

@end
