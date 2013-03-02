//
//  FunViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "FunViewController.h"
#import "SignForFreindViewController.h"
#import "FunAnimalImageOverlayViewController.h"
#import "AnimalQuestionsTableView.h"
#import <Social/Social.h>
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
@synthesize facebookView;
@synthesize animalisticCameraLabel;
@synthesize simpleCameraLabel;
@synthesize signLabel;
@synthesize imagePicker;
@synthesize scrollView;
@synthesize zooCamera;
@synthesize accountStore;
@synthesize facebookAccount;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = [Helper languageSelectedStringForKey:@"More"];
        
        if(SYSTEM_VERSION_LESS_THAN(@"6.0")){
            facebookButton = [[UIBarButtonItem alloc] initWithTitle:@"Facebook" style:UIBarButtonItemStyleDone  target:self action:@selector(loginToFacebook)];
            self.navigationItem.rightBarButtonItem = facebookButton;
        }
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
    SignForFreindViewController *signController = [[SignForFreindViewController alloc] initWithNibName:@"SignForFreindViewController" bundle:[Helper localizationBundle]];
    [self.navigationController pushViewController:signController animated:YES];
      return;
    
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self showBuyFullAppAlert];
        });
    }
}



-(IBAction)openQuestions:(id)sender{
    if([Helper isLion]){
    AnimalQuestionsTableView * animalQuestions = [[AnimalQuestionsTableView alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:animalQuestions animated:YES];
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self showBuyFullAppAlert];
        });
    }
}


-(IBAction)openZooPhotographerCamera:(id)sender{
    
    if([Helper isLion]){
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:[Helper languageSelectedStringForKey:@"Cancel"] otherButtonTitles:
                                          [Helper languageSelectedStringForKey:@"From Camera"],
                                          [Helper languageSelectedStringForKey:@"From Album"],
                                          nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }else{
            [self openPhotographerCamera:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self showBuyFullAppAlert];
        });
    }
  
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self openPhotographerCamera:UIImagePickerControllerSourceTypeCamera];
            
            break;
        case 2:
            [self openPhotographerCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            break;
       
    }
}

-(void)openPhotographerCamera:(UIImagePickerControllerSourceType)type{
    if([Helper isLion]){
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        if (type == UIImagePickerControllerSourceTypeCamera) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing=YES;
            imagePicker.showsCameraControls = YES;
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.allowsEditing=YES;
        }
         [self presentModalViewController:self.imagePicker  animated:YES];
            
        
    
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
             [self showBuyFullAppAlert];
        });
       
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage  *editedImage;
   
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];


    [self dismissViewControllerAnimated:YES completion:^{
        [self mailToZooWithImage:editedImage];
    }];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)mailToZooWithImage:(UIImage *)image{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;

        [mailComposer setSubject:[Helper languageSelectedStringForKey:@"A graet image from [ENTER YOUR NAME HERE]!"]];
        [mailComposer setToRecipients:@[@"biblicalzoo@gmail.com"]];
        NSData *data = UIImageJPEGRepresentation(image, 100);

        //NSInteger mb = [data length] / (1024*1024);

        [mailComposer addAttachmentData:data mimeType:@"image/jpg"
                               fileName:@"JerusalemBibilicalZoo.jpg"];

        // Fill out the email body text
        NSString *emailBody = [Helper languageSelectedStringForKey:@"Zoo photographer email massege"];
        [mailComposer setMessageBody:emailBody isHTML:NO];

        [self.navigationController presentModalViewController:mailComposer animated:YES];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Error"]
                                           message:[Helper languageSelectedStringForKey:@"Your email is not configured."]
                                          delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                 otherButtonTitles:nil];
        [alert show];
    }
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView *alert;

    // Unable to save the image
    if (result==MFMailComposeResultFailed){
        alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Error"]
                                           message:[Helper languageSelectedStringForKey:@"Unable to send Email."]
                                          delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                 otherButtonTitles:nil];
        [alert show];
    }
    else if(result==MFMailComposeResultSent){
        alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Success"]
                                           message:[Helper languageSelectedStringForKey:@"Email sent."]
                                          delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                 otherButtonTitles:nil];
        [alert show];
    }

    [self dismissModalViewControllerAnimated:YES];
}



///share camera

-(IBAction)openShareCamera:(id)sender{
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
    
    if (IS_IPHONE_5) {
        self.scrollView.frame = CGRectMake(0, 44, 320, 410);
        self.scrollView.contentSize = CGSizeMake(320, 410);
    }else{
        self.scrollView.contentSize = CGSizeMake(320, 410);
    }
    //labels
 
    
 
    // Create request for user's facebook data
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
          [self toggleFacebookViewForIOS6];
    }else{
        if ([PFUser currentUser] && // Check if a user is cached
            [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
        {
            [self requestUserData];
            [self toggleFacebookView];
     
           
        }else{
            if([Helper isLion]){
            //set alert to connect to facebook
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:[Helper languageSelectedStringForKey:@"FaceBook connection"]
                                  message:[Helper languageSelectedStringForKey:@"facebook connection messege"]
                                  delegate:self
                                  cancelButtonTitle:[Helper languageSelectedStringForKey:@"Not now"]
                                  otherButtonTitles:[Helper languageSelectedStringForKey:@"Connect"], nil];
            alert.tag=1;
            [alert show];
            }
            
        }
        [self toggleFacebookButton];
    }
}



-(void)showBuyFullAppAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Buy Full App"] message:[Helper languageSelectedStringForKey:@"Buy full app description"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:[Helper languageSelectedStringForKey:@"Buy Now"], nil];
    alert.tag=2;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2){
        if (buttonIndex==1) {
            [[Helper appDelegate] buyFullApp:NO];
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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [self getMeButtonTapped];
    }
    
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

-(void)toggleFacebookViewForIOS6{
    [UIView animateWithDuration:1 animations:^{
        [self.facebookView setHidden:NO];
        self.facebookView.transform = CGAffineTransformIdentity;
    }];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        self.facebookName.text = [Helper languageSelectedStringForKey:@"Device connected to FaceBook"];
    }else{
        self.facebookName.text = [Helper languageSelectedStringForKey:@"Device dicconected from FaceBook"];
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
    
 
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            
            NSString *name = userData[@"name"];
            NSLog(@"location %@",userData[@"location"]);
            facebookName.text = [NSString stringWithFormat:@"%@ %@",[Helper languageSelectedStringForKey:@"Connected as"],name];
        } else if ([error.userInfo[PF_FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutFacebook];
        } else {
            NSLog(@"Some other error: %@", error);
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

- (void)getMeButtonTapped {
  
    
    if (self.accountStore == nil) {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    ACAccountType * facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary * dict = @{ACFacebookAppIdKey : @"312934405399723", ACFacebookAudienceKey : ACFacebookAudienceEveryone};
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:dict completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray * accounts = [self.accountStore accountsWithAccountType:facebookAccountType];
            self.facebookAccount = [accounts lastObject];
            //NSLog(@"account is: %@", self.facebookAccount);
            [self me];
        }
        else {
            NSLog(@"error is: %@", [error debugDescription]);
        }
    }];
}

- (void)me{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = self.facebookAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            NSLog(@"%@", [error debugDescription]);
        }else{
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:nil];
            if(dic!=nil){
            self.facebookName.text = [NSString stringWithFormat:@"%@ %@",[Helper languageSelectedStringForKey:@"Connected as "],dic[@"name"]];
            }
        }
        

        
        
    }];
    
 
}

@end
