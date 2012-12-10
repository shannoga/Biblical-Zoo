//
//  AnimalDescriptionWebView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDescriptionWebView.h"
#import "Animal.h"

@implementation AnimalDescriptionWebView

/*

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
   // scrollView.contentSize = CGSizeMake(320, fittingSize.height+300);
    aWebView.frame = frame;
    aWebView.scrollView.contentSize =  CGSizeMake(320, fittingSize.height+300);
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}
 */

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //add UIWebView  for the animal main text
        
        NSString *dir = @"ltr";
        NSString *langClass = @"";
        if ([[Helper currentLang] isEqualToString:@"he"]) {
            dir = @"rtl";
            langClass = @"dirrtl";
        }
        UIWebView *descriptionView = [[UIWebView alloc] initWithFrame:self.bounds];
      
        descriptionView.backgroundColor = UIColorFromRGB(0xf8eddf);
        descriptionView.opaque=YES;
        descriptionView.delegate=self;
     
        
        NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
        //do base url for css
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString *html =[NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"%@\" dir=\"%@\"><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><section class=\"%@\">%@</section><br><br></body></html>",
                         [Helper currentLang],dir,cssPath,langClass,anAnimal.generalDescription];
         NSString *new = [html stringByReplacingOccurrencesOfString:@"\\"  withString:@""];  
        
        new = [new stringByReplacingOccurrencesOfString:@"u2013"  withString:@"-"];  
       
        [descriptionView loadHTMLString:new baseURL:baseURL];  
    
        [self addSubview:descriptionView];
        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
