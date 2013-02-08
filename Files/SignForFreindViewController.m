//
//  SignForFreindViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "SignForFreindViewController.h"
#import "UIImage+Helper.h"
#import "SignForFriendView.h"
#import "SignForFriendView_HalfSize.h"
#import <Social/Social.h>
#import "Reachability.h"
@interface SignForFreindViewController ()

@end

@implementation SignForFreindViewController
@synthesize scrollView;
@synthesize nameTF;
@synthesize latinNameTF;
@synthesize habitatTV;
@synthesize dietTV;
@synthesize descriptionTV;
@synthesize showSignButton;
@synthesize thumbnailImageView;
@synthesize showCameraBtn;
@synthesize socialStructureTV;
@synthesize captureView;
@synthesize fullscreen = _fullscreen;
@synthesize generatedImage;
@synthesize habitatLBL;
@synthesize dietLBL;
@synthesize descriptionLBL;
@synthesize socialStructureLBL;
@synthesize previewView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        shouldGoUp = NO;
        self.view.backgroundColor =UIColorFromRGB(0x3D3227);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 700);
  
    if (IS_IPHONE_5) {
        self.scrollView.frame = CGRectMake(0, 0, 320, 510);
    }
    UIBarButtonItem *previewBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Generate Sign",nil) style:UIBarButtonItemStyleDone  target:self action:@selector(showSignPreview:)];
    self.navigationItem.rightBarButtonItem = previewBtn;
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)showSignPreview:(id)sender{
   
    if(self.nameTF.text.length>0 && self.latinNameTF.text.length>0 && self.habitatTV.text.length>0 && self.dietTV.text.length>0 && self.socialStructureTV.text.length>0 && self.descriptionTV.text.length>0){
    
                    NSDictionary * signDic = @{
                                               @"name":self.nameTF.text,
                                               @"binomialName":self.latinNameTF.text,
                                               @"habitat":self.habitatTV.text,
                                               @"diet":self.dietTV.text,
                                               @"social":self.socialStructureTV.text,
                                               @"description":self.descriptionTV.text};
        
                    [self.view endEditing:YES];
        
        __block UIImage *image;
        [self showHudWithText:NSLocalizedString(@"Generating your sign", nil)];
        [progressHUD showAnimated:YES whileExecutingBlock:^{
            image = [self createImageWithDic:signDic];
        } completionBlock:^{
            self.generatedImage = image;
            [self showSavingOptions];
            [self showPreviewView];
            
        }];
        
        
                 
               
                
        
       
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Fill all fields.",nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
        [alert show];
    }
    
}

-(IBAction)showCamera:(id)sender{
    //future feature
}

-(void)showPreviewView{
    if (!self.previewView) {
        self.previewView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    }
    [self.previewView setImage:self.generatedImage];
    [self.view addSubview:self.previewView];
    
   
}

- (void)showSavingOptions
{
    UIActionSheet *sheet;
    
    
    sheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:NSLocalizedString(@"Cancel",nil) otherButtonTitles:
            NSLocalizedString(@"Save to album", nil),
            NSLocalizedString(@"Send email", nil),
            NSLocalizedString(@"Save to FaceBook",nil),
            nil];
    
    
    [sheet showFromRect:CGRectMake(0, 0, 200, 200) inView:self.view animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
     [progressHUD hide:YES];
    switch (buttonIndex) {
        case 0:
            self.generatedImage = nil;
            [self.previewView removeFromSuperview];
            self.previewView = nil;
            [progressHUD hide:YES];
            break;
        case 1:
            [self showHudWithText:NSLocalizedString(@"Saving, please wate",nil)];
            [self saveToAlbum];
            break;
        case 2:
            [self displayComposerSheet];
            break;
        case 3:
            [self showHudWithText:NSLocalizedString(@"Posting, please wate",nil)];
            [self postOnFacebook];
            break;
    }
    if(self.previewView!=nil){
        [UIView animateWithDuration:1 animations:^{
            self.previewView.alpha =0;
        }completion:^(BOOL finished) {
            [self.previewView removeFromSuperview];
            self.previewView = nil;
        }];
    }
}



- (void)saveToAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.generatedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
   
    UIAlertView *alert;
    
    // Unable to save the image
    if (error){
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Unable to save image to Photo Album." ,nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
     [progressHUD hide:YES];
    }
    else{ // All is well
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil)
                                           message:NSLocalizedString(@"Image saved to Photo Album.",nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
    [alert show];
     [progressHUD hide:YES];
    }
}




#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
    if ([MFMailComposeViewController canSendMail]){
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	
	[mailComposer setSubject:@"Hello from the Jerusalem Biblical Zoo!"];
	UIImage *image = self.generatedImage;
    
    NSData *data = UIImageJPEGRepresentation(image, 100);

    [mailComposer addAttachmentData:data mimeType:@"image/jpg"
                           fileName:@"JerusalemBibilicalZoo.jpg"];
    
	// Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"We are in the Jerusalem Biblical Zoo - http://itunes.apple.com/app/id591193554",nil);
	[mailComposer setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:mailComposer animated:YES];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                                         message:NSLocalizedString(@"Your email is not configured.",nil)
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss" ,nil)
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
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Unable to send Email.",nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss" ,nil)
                                 otherButtonTitles:nil];
        [alert show];
    }
    else if(result==MFMailComposeResultSent){
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil)
                                           message:NSLocalizedString(@"Email sent.",nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
        [alert show];
    }
    
    
	[self dismissModalViewControllerAnimated:YES];
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}



-(UIImage*)createImageWithDic:(NSDictionary*)dic
{
    
   // if (![Helper isRetina]) {
        SignForFriendView_HalfSize *signview  = [[SignForFriendView_HalfSize alloc] initWithFrame:CGRectMake(0, 0, 1120, 724) WithSignDic:dic];
        UIImage *image = [UIImage imageWithView:signview];
        signview=nil;
        return image;
    /*
    }else{
        SignForFriendView *signview = [[SignForFriendView alloc] initWithFrame:CGRectMake(0, 0, 2240, 1448) WithSignDic:dic];
        UIImage *image = [UIImage imageWithView:signview];
        signview=nil;
        return image;
    }
     */
    return nil;
   
}

-(void)postOnFacebook{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"Cancelled");
                    [progressHUD hide:YES];

                } else{
                    NSLog(@"Done");
                    [progressHUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedString(@"Success",nil)
                                          message:NSLocalizedString(@"Posted to FaceBook",nil)
                                          delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                          otherButtonTitles:nil];
                    [alert show];
                }
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler =myBlock;
            
            NSString *localizedText = NSLocalizedString(@"Share sign text",nil);
            [controller setInitialText:localizedText];
            [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id591193554"]];
            [controller addImage:self.generatedImage];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
    }else{
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        if(![reach isReachable]){
            [progressHUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                                  message:NSLocalizedString(@"No Internet alert body",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
         if ([PFUser currentUser] && // Check if a user is cached
              [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
        {
            NSData *imageData = UIImageJPEGRepresentation(self.generatedImage, 100);
            
            
            NSString *massege = NSLocalizedString(@"facebbok sign title", nil);
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           massege, @"message",
                                           imageData, @"source",
                                           @"Get the app on - http://itunes.com/apps/id591193554", @"caption",
                                           NSLocalizedString(@"Jerusalem Biblical Zoo",nil), @"name",
                                           nil];
            
           
           
            
            [self performPublishAction:^{
                [PF_FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST"
                                         completionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
                                                [progressHUD hide:YES];
                                                 if (!error) {
                                                
                                                     
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil)
                                                                                                     message:NSLocalizedString(@"Image posted on Facebook.",nil)
                                                                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                                                                           otherButtonTitles:nil];
                                                     [alert show];
                                                 }else{
                                                     NSLog(@"Error = %@",[error debugDescription]);
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed",nil)
                                                                                                     message:NSLocalizedString(@"Please try again later",nil)
                                                                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                                                                           otherButtonTitles:nil];
                                                      [alert show];
                                                 }
                                             }];
            }];
            
        }else{
            [progressHUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EROR",nil)
                                                            message:NSLocalizedString(@"You are not loged in to Facebook",nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                                  otherButtonTitles:@"Login", nil];
            
            alert.tag = 1;
            [alert show];
        }
        
    }
    
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([PF_FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [PF_FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                                      defaultAudience:PF_FBSessionDefaultAudienceFriends completionHandler:^(PF_FBSession *session, NSError *error) {
                                                          if (!error) {
                                                              action();
                                                          }else{
                                                              NSLog(@"error = %@",[error debugDescription]);
                                                          }
                                                          //For this example, ignore errors (such as if user cancels).
                                                      }];
    } else {
        action();
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    shouldGoUp = NO;
    int maxLength = 60;
    if (textView == self.habitatTV) {
        if([text isEqualToString:@"\n"]){
            [self.dietTV becomeFirstResponder];
            shouldGoUp = YES;
            return YES;

        }
    }
    
    else if (textView == self.dietTV) {
        
        if([text isEqualToString:@"\n"]){
            
            [self.socialStructureTV becomeFirstResponder];
            shouldGoUp = YES;
            return YES;

        }
        
    }
    
    else if (textView == self.socialStructureTV) {
        
        if([text isEqualToString:@"\n"]){
            [self.descriptionTV becomeFirstResponder];
            shouldGoUp = YES;
            
            return YES;

        }
    }
    else if (textView == self.descriptionTV){
        maxLength = 260;
        if([text isEqualToString:@"\n"]){
            shouldGoUp = YES;
            [textView resignFirstResponder];
            
            return YES;

        }
    }
    shouldGoUp = YES;
    if (range.length > text.length) {
        return YES;
    } else if ([[textView text] length] + text.length > maxLength) {
        return NO;
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTF) {
        [self.latinNameTF becomeFirstResponder];
    }
    
    else if (textField == self.latinNameTF) {
        [self.habitatTV becomeFirstResponder];
    }

    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
      [self.scrollView adjustOffsetToIdealIfNeeded];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView adjustOffsetToIdealIfNeeded];
}

-(void)didReceiveMemoryWarning{
    self.generatedImage = nil;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

-(void)showHudWithText:(NSString*)str{
    if(progressHUD == nil){
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.delegate = self;
    }
    if (str!=nil) {
        progressHUD.labelText = str;
    }
    [self.view addSubview:progressHUD];
   
    [progressHUD show:YES];
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end

