//
//  ZooInfoViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/7/13.
//
//

#import <UIKit/UIKit.h>

@interface ZooInfoViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *refreshHUD;
}

@end
