//
//  AnimalDescriptionWebView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>

@interface AnimalDescriptionWebView : UIView<UIWebViewDelegate>
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;
@end
