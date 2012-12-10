//
//  OpeningScreenViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 01/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "OpeningScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSZipArchive.h"
#import <Parse/Parse.h>
@interface OpeningScreenViewController ()

@end

@implementation OpeningScreenViewController
@synthesize madad;
@synthesize imageview;
@synthesize enter;
@synthesize langSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)cloudScroll
{
    UIImage *cloudsImage = [UIImage imageNamed:@"PagesBG_clouds.png"];
    UIColor *cloudPattern = [UIColor colorWithPatternImage:cloudsImage];
    CALayer *cloud = [CALayer layer];
    cloud.backgroundColor = cloudPattern.CGColor;
    cloud.transform = CATransform3DMakeScale(1, -1, 1);
    cloud.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.view.bounds.size;
    cloud.frame = CGRectMake(0, 0, cloudsImage.size.width + viewSize.width, viewSize.height);
    [self.view.layer addSublayer:cloud];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-cloudsImage.size.width, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:startPoint];
    animation.toValue = [NSValue valueWithCGPoint:endPoint];
    animation.repeatCount = HUGE_VALF;
    animation.duration = 5.0;
    [cloud addAnimation:animation forKey:@"position"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSString *startLang = [Helper currentLang];
    if ([startLang isEqualToString:@"en"]) {
        
        [self.langSwitch setSelectedSegmentIndex:1];
    }else{
        [self.langSwitch setSelectedSegmentIndex:0];
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self cloudScroll];
}

- (IBAction)downLoadFirstTimeAnimals
{
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
	
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD showWhileExecuting:@selector(downloadAnimals) onTarget:self withObject:nil animated:YES];
    
}

-(void)downloadAnimals{
    //chenk for new objects on parse
   // [ParseHelper updateExhibitsAndAnimalsImManagedContext:[Helper appContext] updateExisting:YES];
}
- (IBAction)downLoadAudioGuide{

    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
  refreshHUD.labelText = @"Getting Audio Guide Files";
    refreshHUD.mode  = MBProgressHUDModeDeterminate;
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    refreshHUD.labelText = @"Connecting to the server";
    PFQuery *query = [PFQuery queryWithClassName:@"AudioGuides"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects.", objects.count);
            refreshHUD.labelText = @"Downloading files";
            PFObject *AudioGuide = [objects lastObject];
            NSString *key = ![Helper isRightToLeft]?@"enFile":@"heFile";
            PFFile *localGuide = AudioGuide[key];
            
            //– getDataInBackgroundWithBlock:progressBlock:
            [localGuide getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                 refreshHUD.labelText = @"Unziping Audio Guide Files";
                NSString *path = [[Helper tempFilesPath] stringByAppendingPathComponent:@"audioFiles.zip"];
                NSURL *fileUrl = [NSURL fileURLWithPath:path];
                
              
                if ([data writeToURL:fileUrl atomically:YES]) {
                    // Unzipping
                    NSString *zipPath = [fileUrl path];
                    NSString *destinationPath = [Helper audioGuideFilesPath];
                    if (![SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath]) {
                        NSLog(@"problen unzipping the file");
                    }else{
                         NSLog(@"file unzipped");
                        // Attempt to delete the file at filePath2
                        if ([[NSFileManager defaultManager] removeItemAtPath:zipPath error:&error] != YES){
                            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
                        }else {
                            refreshHUD.labelText = @"Cleaning";
                            NSLog(@"cleaned up zip file");
                            
                            [refreshHUD hide:YES];
                        }
                      
                    }
                    
                }else{
                    NSLog(@"File was not saved");
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"%d",percentDone);
                
                CGFloat f = (CGFloat)percentDone;
                
                refreshHUD.progress = f/100;
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}
-(IBAction)showMadad:(id)sender{
    NSLog(@"maddad");
}
-(IBAction)enter:(id)sender{
    NSLog(@"enter");
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)changeLang:(id)sender{
    UISegmentedControl *sc = (UISegmentedControl*)sender;
    switch (sc.selectedSegmentIndex) {      
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"he" forKey:@"lang"];
            
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"lang"];
            break;
            
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
