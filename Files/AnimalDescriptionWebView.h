//
//  AnimalDescriptionWebView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>

@interface AnimalDescriptionWebView : UIViewController<UIWebViewDelegate>
- (id)initWithAnimal:(Animal*)anAnimal;
@end
