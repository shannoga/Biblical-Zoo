//
//  FunViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "FunViewController.h"
#import "SignForFreindViewController.h"
#import "AlbumViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageOverLayHandleViewController.h"
#import "FunAnimalImageOverlayViewController.h"
#import "AnimalQuestionsTableView.h"
#define kNext 0
#define kPrev 1
#define kPreview 2

@interface FunViewController ()

@end

@implementation FunViewController
@synthesize signBtn;
@synthesize cameraBtn;
@synthesize questionsButton;
@synthesize facebookName;
@synthesize facebookImage;
@synthesize facebookView;
@synthesize animalisticCameraLabel;
@synthesize simpleCameraLabel;
@synthesize signLabel;
@synthesize imagePicker;
@synthesize scrollView;
@synthesize zooCamera;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Fun",nil); 
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone  target:self action:@selector(loginToFacebook)];
        self.navigationItem.rightBarButtonItem = facebookButton;
      
        if(![Helper isLion]){
            [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(unlock) name:@"unlock-feature"  object: nil];
        }
    }
    return self;
}

-(void)unlock{
    self.signBtn.alpha = 1;
    self.zooCamera.alpha = 1;
    self.questionsButton.alpha = 1;
}

-(IBAction)opsenSignGenerator:(id)sender{
    if([Helper isLion]){
    SignForFreindViewController *signController = [[SignForFreindViewController alloc] initWithNibName:@"SignForFreindViewController" bundle:nil];
    [self.navigationController pushViewController:signController animated:YES];
      return;
    
    }else{
       [self showBuyFullAppAlert];
    }
}

-(IBAction)openCamera:(id)sender{
     if([Helper isLion]){
         
     }else{
    [self showBuyFullAppAlert];
}
}

-(IBAction)openQuestions:(id)sender{
    if([Helper isLion]){
    AnimalQuestionsTableView * animalQuestions = [[AnimalQuestionsTableView alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:animalQuestions animated:YES];
    }else{
        [self showBuyFullAppAlert];
    }
}


-(IBAction)opsenShareCaera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        FunAnimalImageOverlayViewController *imageOverlayController = [[FunAnimalImageOverlayViewController alloc] init];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        [imageOverlayController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:imageOverlayController animated:YES];
    }
    return;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![Helper isLion]){
        self.signBtn.alpha = .5;
        self.zooCamera.alpha = .5;
        self.questionsButton.alpha = .5;
    }
    
    self.facebookView.transform = CGAffineTransformTranslate(self.facebookView.transform, 0, -self.facebookView.bounds.size.height);
    
    self.scrollView.contentSize = CGSizeMake(320, 500);
    //labels
    self.animalisticCameraLabel.text = NSLocalizedString(@"animalistic camera label",nil);
    self.simpleCameraLabel.text = NSLocalizedString(@"simple camera label",nil);
    self.signLabel.text = NSLocalizedString(@"sign maker label",nil);
    
    
 
    // Create request for user's facebook data
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        NSLog(@"[PFFacebookUtils session] = %@",[PFFacebookUtils session]);
      //  [self loginToFacebook];
        
        [PFFacebookUtils reauthorizeUser:[PFUser currentUser] withPublishPermissions:@[@"publish_stream"] audience:PF_FBSessionDefaultAudienceFriends block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self requestUserData];
                }else{
                    NSLog(@"Problem autorizing user");
                }
        }];

    }else{
        if([Helper isLion]){
        //set alert to connect to facebook
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"FaceBook connection",nil)
                              message:NSLocalizedString(@"facebook connection messege",nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Not now",nil)
                              otherButtonTitles:NSLocalizedString(@"Connect",nil), nil];
        alert.tag=1;
        [alert show];
        }
        
    }
    [self toggleFacebookButton];
}



-(void)showBuyFullAppAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Buy Full App", nil) message:NSLocalizedString(@"Buy full app description", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dissmis", nil) otherButtonTitles:NSLocalizedString(@"Buy Now", nil), nil];
    alert.tag=2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2){
        NSLog(@"%i",buttonIndex);
        if (buttonIndex==1) {
            [[Helper appDelegate] buyFullApp];
        }
    }else if (alertView.tag==1){
        if (buttonIndex==1) {
            [self loginToFacebook];
        }
    }
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    [[self navigationController] setNavigationBarHidden:NO animated:NO];
   // self.tabBarController.tabBar.hidden=NO;

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)toggleFacebookButton{
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone  target:self action:@selector(logoutFacebook)];
        self.navigationItem.rightBarButtonItem = facebookButton;
    }else{
        facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone  target:self action:@selector(loginToFacebook)];
        self.navigationItem.rightBarButtonItem = facebookButton;
    }
}
-(void)toggleFacebookView{
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        [UIView animateWithDuration:1 animations:^{
            [self.facebookView setHidden:NO];
            self.facebookView.transform = CGAffineTransformIdentity;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.facebookView.transform = CGAffineTransformTranslate(self.facebookView.transform, 0, -self.facebookView.bounds.size.height);
        }];
    }
}

- (void)loginToFacebook
{

    // The permissions requested from the user
    NSArray *permissionsArray = @[@"publish_stream"];
    
    
  
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
                                        [self toggleFacebookButton];
                                    }];
    

}

- (void)logoutFacebook
{
    [PFUser logOut]; // Log out    
    [self toggleFacebookView];
    [self toggleFacebookButton];
}

-(void)requestUserData{
    
    
    
    // Create request for user's Facebook data
    NSString *requestPath = @"me/?fields=name,location";
    
    // Send request to Facebook
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            
            NSString *facebookId = userData[@"id"];
            NSString *name = userData[@"name"];
            NSLog(@"location %@",userData[@"location"]);
            facebookName.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Connected as", nil),name];
          
            
            // Download the user's facebook profile picture
            imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            NSLog(@"%@",urlConnection);
           
        }else{
            NSLog(@"Error request = %@",[error description]);
        }
    }];
    
    
}

-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    // OAuthException means our session is invalid
    if ([[error userInfo][@"error"][@"type"] 
         isEqualToString: @"OAuthException"]) {
        NSLog(@"The facebook token was invalidated");
        [self logoutFacebook]; // Log out user
    } else {
        NSLog(@"Some other error");
    }
}

// Called every time a chunk of the data is received
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data]; // Build the image
    [self toggleFacebookView];
}

// Called when the entire image is finished downloading
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    [UIView animateWithDuration:1 animations:^{
        [facebookImage setImage:[UIImage imageWithData:imageData]];
    }];
    
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
