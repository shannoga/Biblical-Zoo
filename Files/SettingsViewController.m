//
//  SettingsViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 2/20/13.
//
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize langSelector,openingLang;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openingLang = [Helper appLang];
    self.langSelector.selectedSegmentIndex =self.openingLang;
    // Do any additional setup after loading the view from its nib.
    for (UIButton *button in self.view.subviews) {
        if([button isKindOfClass:[UIButton class]]){
            button.layer.cornerRadius = 10;
        }
    }
}

-(IBAction)changedLang:(UISegmentedControl*)sender{
    NSLog(@"sender lang = %i",sender.selectedSegmentIndex);
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"lang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}






//email us
-(IBAction)emailUs:(id)sender{
    
    if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[@"biblicalzoo@gmail.com"]];
        [controller setSubject:NSLocalizedStringFromTableInBundle(@"email subject", nil, [Helper localizationBundle], nil)];
        [controller setMessageBody:NSLocalizedStringFromTableInBundle(@"add your messege here", nil, [Helper localizationBundle], nil) isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Handle the error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Error", nil, [Helper localizationBundle], nil) message:NSLocalizedStringFromTableInBundle(@"Device can not send email's", nil, [Helper localizationBundle], nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Dismiss", nil, [Helper localizationBundle], nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Great", nil, [Helper localizationBundle], nil) message:NSLocalizedStringFromTableInBundle(@"We got your email", nil, [Helper localizationBundle], nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Dismiss", nil, [Helper localizationBundle], nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)rateApp:(id)sender{
    NSString* url = [NSString stringWithFormat:  @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", @"591193554"];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url ]];
}

-(IBAction)shareApp:(id)sender{

        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            NSString *text = NSLocalizedStringFromTableInBundle(@"Check out the Jerusalem Biblical Zoo iPhone and iPod App", nil, [Helper localizationBundle], nil);
            NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/app/id591193554"];
            NSArray *activityItems = @[text,url];
            
            
            UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
            [self presentViewController:activityController animated:YES completion:nil];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"iOS6 required", nil, [Helper localizationBundle], nil) message:NSLocalizedStringFromTableInBundle(@"This feature require iOS6", nil, [Helper localizationBundle], nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Dismiss", nil, [Helper localizationBundle], nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    
}

-(IBAction)close:(id)sender{
    if( self.langSelector.selectedSegmentIndex != self.openingLang){
        [[Helper appDelegate] refreshViewControllersAfterLangChange];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"lang-changed" object:nil]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
