//
//  SettingsViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 2/20/13.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize langSelector,restoreButton,openingLang;

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
}

-(IBAction)restorePurchase:(id)sender{
    [[Helper appDelegate] buyFullApp:YES];
}

-(IBAction)changedLang:(UISegmentedControl*)sender{
    NSLog(@"sender lang = %i",sender.selectedSegmentIndex);
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"lang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
