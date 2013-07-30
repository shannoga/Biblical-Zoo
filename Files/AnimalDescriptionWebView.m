//
//  AnimalDescriptionWebView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDescriptionWebView.h"
#import "Animal.h"
#import "ConservationStatusDataView.h"

@interface AnimalDescriptionWebView()
@property (nonatomic,strong) Animal* animal;
@end

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


- (id)initWithAnimal:(Animal*)anAnimal
{
    self = [super init];
    if (self) {
        self.animal = anAnimal;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Initialization code
    ConservationStatusDataView *conStatus = [[ConservationStatusDataView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80) withConservationStatus:self.animal.conservationStatus];
    [self.view addSubview:conStatus];
    
    //add UIWebView  for the animal main text
    
    NSString *dir = @"ltr";
    NSString *langClass = @"";
    if ([Helper appLang] == kHebrew) {
        dir = @"rtl";
        langClass = @"dirrtl";
    }
    CGRect webRect = self.view.bounds;
    webRect.origin.y = conStatus.frame.size.height;
    webRect.size.height = CGRectGetHeight(self.view.bounds)-conStatus.frame.size.height;
    UIWebView *descriptionView = [[UIWebView alloc] initWithFrame:webRect];
    
    descriptionView.backgroundColor = UIColorFromRGB(0xf8eddf);
    descriptionView.opaque=YES;
    descriptionView.delegate=self;
    
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    //do base url for css
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *html =[NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"%@\" dir=\"%@\"><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><section class=\"%@\">%@</section><br><br></body></html>",
                     [Helper appLang] == kEnglish?@"en":@"he",dir,cssPath,langClass,self.animal.generalDescription];
    NSString *new = [html stringByReplacingOccurrencesOfString:@"\\"  withString:@""];
    
    new = [new stringByReplacingOccurrencesOfString:@"u2013"  withString:@"-"];
    
    [descriptionView loadHTMLString:new baseURL:baseURL];
    
    [self.view addSubview:descriptionView];
    
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
