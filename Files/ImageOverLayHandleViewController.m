//
//  ImageOverLayHandleViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ImageOverLayHandleViewController.h"
#import "CapturedImageViewController.h"
#import "UIImage+Helper.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define kNext 0
#define kPrev 1
#define kPreview 2
@interface ImageOverLayHandleViewController ()
- (void)showSavingOptions;
- (void)saveToAlbum;
-(void)displayComposerSheet;
-(void)postWall;
@end


@implementation ImageOverLayHandleViewController
@synthesize photoImageView;
@synthesize photoImage;
@synthesize selectedOverLay;
@synthesize imagesContainer;
@synthesize fullscreen = _fullscreen;
@synthesize uniteImagesView;
@synthesize capturedImageViewController;

// Define at top of implementation file
CGImageRef UIGetScreenImage(void);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        
       
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

  
    self.uniteImagesView = [[UIView alloc] initWithFrame:self.view.frame];
    
    
    // Do any additional setup after loading the view from its nib.
    self.imagesContainer = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imagesContainer.userInteractionEnabled = NO;
    self.imagesContainer.alpha = 1;
    
    [self.imagesContainer setImage:selectedOverLay];
   
    
    NSLog(@"image size = %@",NSStringFromCGSize(photoImage.size));
    //2160 3840
    //CGSize size= photoImage.size;
    //UIImage *croppedImage = [photoImage crop:CGRectMake((size.height / 4), (size.width / 3),
                                                     //   (size.height / 4), (size.width /3))];
    
    self.capturedImageViewController =  [[CapturedImageViewController alloc] initWithImage:photoImage];
    
    [self.uniteImagesView addSubview:self.capturedImageViewController.view];
    [self.uniteImagesView addSubview:self.imagesContainer];
    
    [self.view addSubview:uniteImagesView];
    
    /*
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
  
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
     previewButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Move and Scale",nil) style:UIBarButtonItemStyleDone target:self action:@selector(tooglePreviewEdit:)];
     previewButton.tag = kPreview;
    
    // Custom initialization
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSavingOptions)];
    
     UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(showSavingOptions)];
    
    flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
 
    
 
    [toolbar setItems:@[share,flexItem,previewButton,flexItem,close]];
    [self.view addSubview:toolbar];
     */
}
-(void)tooglePreviewEdit:(UIBarButtonItem*)sender{
    
    if (self.imagesContainer.alpha < 1) {
        self.imagesContainer.alpha=1;
        self.imagesContainer.userInteractionEnabled = NO;
        previewButton.title = NSLocalizedString(@"Move and Scale",nil);
    }else{
        self.imagesContainer.alpha=.7;
        self.imagesContainer.userInteractionEnabled = YES;
        previewButton.title = NSLocalizedString(@"Done",nil);
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

//////////////

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



-(void)emailImage:(UIImage*)image{
    
}


- (void)saveToAlbum
{
    
    NSThread *thread = [NSThread mainThread];
    [self performSelector:@selector(toggleFullscreen) onThread:thread withObject:nil waitUntilDone:YES];
    
    UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    // Save the captured image to photo album
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
    self.imagesContainer.alpha=1;
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	
	[mailComposer setSubject:NSLocalizedString(@"photo email subject",nil)];
	UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    
    NSData *data = UIImageJPEGRepresentation(image, 100);
        
    [mailComposer addAttachmentData:data mimeType:@"image/jpg" 
                           fileName:@"JerusalemBibilicalZoo.jpg"];
    
	// Fill out the email body text
	NSString *emailBody = NSLocalizedString(@"photo email body",nil);
	[mailComposer setMessageBody:emailBody isHTML:YES];
    
	
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

#pragma mark -
#pragma mark FaceBook

-(void)postWall{
    
    if ([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
    {
        
    UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 100);
    
    NSString *massege = NSLocalizedString(@"photo title", nil);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   massege, @"message", 
                                   imageData, @"picture",
                                   @"Get the app on - http://itunes.com/apps/jerusalemBiblicalZoo", @"caption",
                                   @"Jerusalem Biblical Zoo", @"name",
                                   nil];
    [[PFFacebookUtils facebook] requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EROR" 
                                                        message:@"You are not loged in to Facebook" 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:@"Login", nil];

        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            NSLog(@"connectToFacebook");
            break;

    }
}
-(void)request:(PF_FBRequest *)request didLoadRawResponse:(NSData *)data{
    //NSLog(@"data = %@",data);
}
-(void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
      //NSLog(@"response = %@",[response description]);
    
}
-(void)request:(PF_FBRequest *)request didLoad:(id)result{
    NSLog(@" [result objectForKey] = %@", result[@"post_id"]);
    NSLog(@"result class %@",[result class]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucsses" 
                                                    message:@"Image posted on Facebook." 
                                                   delegate:self cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    [alert show];
    

 
}
-(void)requestLoading:(PF_FBRequest *)request{
     NSLog(@"%@",request);
}
-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" 
                                       message:@"Uploading to FaceBook Failed, Please try again." 
                                      delegate:self cancelButtonTitle:@"Ok" 
                             otherButtonTitles:nil];
    [alert show];
     NSLog(@"%@",[error description]);
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
          
             [self postWall];
            break;
    }
}


@end
