//
//  AnimalDescriptionWebView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDescriptionWebViewController.h"
#import "Animal.h"
#import "ConservationStatusDataView.h"
#import "ConservasionStatusIndicator.h"
#import "AnimalsImagesScrollView.h"

@interface AnimalDescriptionWebViewController()
@end

@implementation AnimalDescriptionWebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    
    NSString *dir = @"ltr";
    NSString *langClass = @"";
    if ([Helper appLang] == kHebrew) {
        dir = @"rtl";
        langClass = @"dirrtl";
    }
  
    self.descriptionView.backgroundColor = UIColorFromRGB(0xf8eddf);
    self.descriptionView.opaque=YES;
    self.descriptionView.delegate=self;
    
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    //do base url for css
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html =[NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"%@\" dir=\"%@\"><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><section class=\"%@\">%@</section><br><br></body></html>",
                     [Helper appLang] == kEnglish?@"en":@"he",dir,cssPath,langClass,self.animal.generalDescription];
    NSString *new = [html stringByReplacingOccurrencesOfString:@"\\"  withString:@""];
    
    new = [new stringByReplacingOccurrencesOfString:@"u2013"  withString:@"-"];
    
    [self.descriptionView loadHTMLString:new baseURL:baseURL];
    
}

@end
