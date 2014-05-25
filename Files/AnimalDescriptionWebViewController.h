//
//  AnimalDescriptionWebView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>

@interface AnimalDescriptionWebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *descriptionView;
@property (nonatomic,strong) Animal* animal;

@end
