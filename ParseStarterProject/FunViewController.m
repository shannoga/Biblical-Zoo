//
//  FunViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "FunViewController.h"
#import "SignForFreindViewController.h"
#import "AVCamViewController.h"
#import "AlbumViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FunViewController ()

@end

@implementation FunViewController
@synthesize signBtn;
@synthesize cameraBtn;
@synthesize facebookName;
@synthesize facebookImage;
@synthesize treesView;
@synthesize facebookView;
@synthesize animalisticCameraLabel;
@synthesize simpleCameraLabel;
@synthesize signLabel;

-(void)cloudScroll
{
    UIImage *cloudsImage = [UIImage imageNamed:@"cloudsTile.png"];
    UIColor *cloudPattern = [UIColor colorWithPatternImage:cloudsImage];
    cloud = [CALayer layer];
    cloud.backgroundColor = cloudPattern.CGColor;
    cloud.transform = CATransform3DMakeScale(1, -1, 1);
    cloud.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.view.bounds.size;
    cloud.frame = CGRectMake(0, 0, cloudsImage.size.width + viewSize.width, viewSize.height);
    [cloudsView.layer addSublayer:cloud];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-cloudsImage.size.width, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:startPoint];
    animation.toValue = [NSValue valueWithCGPoint:endPoint];
    animation.repeatCount = HUGE_VALF;
    animation.duration = 6.0;
    [cloud addAnimation:animation forKey:@"position"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Fun",nil); 
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone  target:self action:@selector(facebookLoginButtonTouchHandler:)];
        self.navigationItem.rightBarButtonItem = facebookButton;
      
    }
    return self;
}



-(IBAction)opsenSignGenerator:(id)sender{
    SignForFreindViewController *vc = [[SignForFreindViewController alloc] initWithNibName:@"SignForFreindViewController" bundle:nil];
    UINavigationController *nacController = [[UINavigationController alloc] initWithRootViewController:vc];
    nacController.navigationBar.tintColor = nil;
    [self.navigationController presentModalViewController:nacController animated:YES];
      return;
}

-(IBAction)openCamera:(id)sender{
    AVCamViewController *cameraContoller = [[AVCamViewController alloc] initWithNibName:@"AVCamViewController" bundle:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = nil;
    cameraContoller.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:cameraContoller animated:YES];
      return;
}


-(IBAction)opsenShareCaera:(id)sender{
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = nil;
    [self.navigationController pushViewController:vc  animated:YES];
    return;
}

-(void)requestUserData{
    NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture";
    // Send request to facebook
    [[PFFacebookUtils facebook] requestWithGraphPath:requestPath andDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //labels
    self.animalisticCameraLabel.text = NSLocalizedString(@"animalistic camera label",nil);
    self.simpleCameraLabel.text = NSLocalizedString(@"simple camera label",nil);
    self.signLabel.text = NSLocalizedString(@"sign maker label",nil);
    
    cloudsView = [[UIView alloc] initWithFrame:self.view.bounds];
    cloudsView.backgroundColor = [UIColor clearColor];
    [self.view  insertSubview:cloudsView belowSubview:self.treesView];
    
    [self cloudScroll];
    // Create request for user's facebook data
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [self requestUserData];
    }else{
        //set alert to connect to facebook
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self cloudScroll];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [cloud removeAllAnimations];
}

-(void)toggleFacebookButton{
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone  target:self action:@selector(logoutButtonTouchHandler:)];
        self.navigationItem.rightBarButtonItem = facebookButton;
    }else{
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone  target:self action:@selector(facebookLoginButtonTouchHandler:)];
        self.navigationItem.rightBarButtonItem = facebookButton;
    }
}
- (void)facebookLoginButtonTouchHandler:(UIBarButtonItem*)sender
{
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"publish_checkins",@"publish_stream",
                                 @"user_relationships",@"user_birthday",@"user_location",
                                 @"offline_access"];
    
    // Log in
    [PFFacebookUtils logInWithPermissions:permissionsArray
                                    block:^(PFUser *user, NSError *error) {
                                        if (!user) {
                                            if (!error) { // The user cancelled the login
                                                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                                            } else { // An error occurred
                                                NSLog(@"Uh oh. An error occurred: %@", error);
                                            }
                                        } else if (user.isNew) { // Success - a new user was created
                                            NSLog(@"User with facebook signed up and logged in!");
                                             [self requestUserData];
                                         
                                        } else { // Success - an existing user logged in
                                            NSLog(@"User with facebook logged in!");
                                            [self requestUserData];
                                   
                                        }
                                    }];
    
}

- (void)logoutButtonTouchHandler:(id)sender 
{
    [PFUser logOut]; // Log out    
    [UIView animateWithDuration:1 animations:^{
         self.facebookView.alpha = 0;
       
    } completion:^(BOOL finished) {
        [self.facebookView setHidden:YES];
        [self toggleFacebookButton];
    }];
    // Return to login page
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)request:(PF_FBRequest *)request didLoad:(id)result {
    
    [self toggleFacebookButton];
    [self cloudScroll];
    
    NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
    
    NSString *name = userData[@"name"];
    NSString *location = userData[@"location"][@"name"];
    
    
    NSLog(@"name = %@, location = %@",name,location);
    // Now add the data to the UI elements
    facebookName.text =  name;
    
    imageData = [[NSMutableData alloc] init]; // the image will be loaded in here
    // Create URLRequest
    NSString *pictureURL = userData[@"picture"];
    NSMutableURLRequest *urlRequest = 
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pictureURL] 
                            cachePolicy:NSURLRequestUseProtocolCachePolicy 
                        timeoutInterval:2];
    
    // Run request asynchronously
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    self.facebookView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
         [self.facebookView setHidden:NO];
        self.facebookView.alpha = 1;
    }];
   
   
    
}

-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    // OAuthException means our session is invalid
    if ([[error userInfo][@"error"][@"type"] 
         isEqualToString: @"OAuthException"]) {
        NSLog(@"The facebook token was invalidated");
        [self logoutButtonTouchHandler:nil]; // Log out user
    } else {
        NSLog(@"Some other error");
    }
}

// Called every time a chunk of the data is received
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    [facebookImage setImage:[UIImage imageWithData:imageData]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
