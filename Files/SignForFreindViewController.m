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
#import <Social/Social.h>

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
            self.generatedImage = [self createImageWithDic:signDic];
            [self previewSignWithDic:signDic];
        
       
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Fill all fields."
                                          delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil];
        [alert show];
    }
    
}

-(IBAction)showCamera:(id)sender{
    //future feature
}

-(void)previewSignWithDic:dic{
  
    self.previewView = nil;
    
    
    self.previewView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.previewView.alpha= 0;
    self.previewView.backgroundColor = UIColorFromRGB(0x3D3227);
    [self showHud];
    UIView *imageView  = [[SignForFriendView alloc] initWithFrame:CGRectMake(0, 0, 2240, 1448) WithSignDic:dic];
    CGAffineTransform transform = CGAffineTransformScale(imageView.transform, .15, .15);
    imageView.transform = transform;
    imageView.frame = CGRectOffset(imageView.frame, -imageView.frame.origin.x, -imageView.frame.origin.y+10);
    [self.previewView addSubview:imageView];
    
    
    [self.view addSubview:self.previewView];
   
    [UIView animateWithDuration:2 animations:^{
       self.previewView.alpha =1;
    }];
    
    [self showSavingOptions];
    [progressHUD hide:YES];
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
    switch (buttonIndex) {
        case 1:
            [self saveToAlbum];
            [self showHud];
            break;
        case 2:
            [self displayComposerSheet];
            break;
        case 3:
            
            [self postOnFacebook];
            break;
    }
    [UIView animateWithDuration:1 animations:^{
        self.previewView.alpha =0;
    }completion:^(BOOL finished) {
        [self.previewView removeFromSuperview];
        self.previewView = nil;
    }];
}



- (void)saveToAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.generatedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [progressHUD hide:YES];
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Unable to save image to Photo Album." ,nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil];
    [alert show];
}




#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	
	[mailComposer setSubject:@"Hello from the Jerusalem Biblical Zoo!"];
	UIImage *image = self.generatedImage;
    
    NSData *data = UIImageJPEGRepresentation(image, 100);
    
    NSInteger mb = [data length] / (1024*1024);
    
    NSLog(@"data length %i",mb);
    
    
    [mailComposer addAttachmentData:data mimeType:@"image/jpg"
                           fileName:@"JerusalemBibilicalZoo.jpg"];
    
	// Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"We are in the Jerusalem Biblical Zoo",nil);
	[mailComposer setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:mailComposer animated:YES];
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
    SignForFriendView *signview = [[SignForFriendView alloc] initWithFrame:CGRectMake(0, 0, 2240, 1448) WithSignDic:dic];
    UIImage *image = [UIImage imageWithView:signview];
    signview=nil;
    return image;
}

-(void)postOnFacebook{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"Cancelled"); 
                } else{
                    NSLog(@"Done");
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
       //add parse facebook share
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
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"%@",shouldGoUp?@"yes":@"no");
    if(shouldGoUp) [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
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
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [self.scrollView adjustOffsetToIdealIfNeeded];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

-(void)showHud{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.delegate = self;
    [progressHUD show:YES];
}
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end

