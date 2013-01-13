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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 700);
  
    UIBarButtonItem *previewBtn = [[UIBarButtonItem alloc] initWithTitle:@"Create sign" style:UIBarButtonItemStyleDone  target:self action:@selector(showSignPreview:)];
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
        NSDictionary *signDic = @{
        @"name":self.nameTF.text,
        @"binomialName":self.latinNameTF.text,
        @"habitat":self.habitatTV.text,
        @"diet":self.dietTV.text,
        @"social":self.socialStructureTV.text,
        @"description":self.descriptionTV.text};
        [self.view endEditing:YES];
        self.generatedImage = [self createImage:signDic];
        [self previewSign];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Fill all fields."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        [alert show];
    }
    
    
}

-(void)previewSign{
    UIImage *previewImage  = self.generatedImage;
    self.previewView = [[UIImageView alloc] initWithImage:previewImage];
    self.previewView.frame = CGRectMake(5,0,224,144.8);
    self.previewView.alpha =0;
    [self.view addSubview:self.previewView];
    [UIView animateWithDuration:1 animations:^{
       self.previewView.alpha =1;
    }];
    
    [self showSavingOptions];
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
            
            break;
        case 2:
            [self displayComposerSheet];
            break;
        case 3:
            
           // [self postWall];
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
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Unable to save image to Photo Album." ,nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil)
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
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
	NSString *emailBody = @"We are in the jerusalem biblical zoo";
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
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"O.K" ,nil)
                                 otherButtonTitles:nil];
        [alert show];
    }
    else if(result==MFMailComposeResultSent){
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success",nil)
                                           message:NSLocalizedString(@"Email sent.",nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"O.K",nil)
                                 otherButtonTitles:nil];
        [alert show];
    }
    
    
	[self dismissModalViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}



-(UIImage*)createImage:(NSDictionary*)dic
{
    SignForFriendView *signview = [[SignForFriendView alloc] initWithFrame:CGRectMake(0, 0, 2240, 1448) WithSignDic:dic];
    UIImage *image = [UIImage imageWithView:signview];
    signview=nil;
    return image;
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
    [self.scrollView adjustOffsetToIdealIfNeeded];
}



@end

