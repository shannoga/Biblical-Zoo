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
@synthesize  overlayesScrollView;
@synthesize fullscreen = _fullscreen;
@synthesize uniteImagesView;

// Define at top of implementation file
CGImageRef UIGetScreenImage(void);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSavingOptions)];
        [self.navigationItem setRightBarButtonItem:barItem];
        
        stopLoop = NO;
       
    }
    return self;
}


- (void)toggleFullscreen {
 
    _fullscreen = !_fullscreen;
    if (_fullscreen) { 
     
            [self.navigationController setNavigationBarHidden:YES animated:YES];
             self.overlayesScrollView.alpha = 1;
    } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.overlayesScrollView.alpha = .7;
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 320, 460)];

  
    self.uniteImagesView = [[UIView alloc] initWithFrame:self.view.frame];
    
    
    // Do any additional setup after loading the view from its nib.
    self.overlayesScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.overlayesScrollView.contentSize = CGSizeMake(640, 480);
    self.overlayesScrollView.userInteractionEnabled = NO;
    self.overlayesScrollView.alpha = .7;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lion-camera"]];
    [imageView setFrame:CGRectMake(0, 0, 320, 480)];
    [self.overlayesScrollView addSubview:imageView];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay_1"]];
    [imageView setFrame:CGRectMake(320, 0, 320, 480)];
    [self.overlayesScrollView addSubview:imageView];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay_1"]];
    [imageView setFrame:CGRectMake(640, 0, 320, 480)];
    [self.overlayesScrollView addSubview:imageView];
    
   
   
    
    NSLog(@"image size = %@",NSStringFromCGSize(photoImage.size));
    //2160 3840
    CGSize size= photoImage.size;
    UIImage *croppedImage = [photoImage crop:CGRectMake((size.height / 4), (size.width / 3),
                                                        (size.height / 4), (size.width /3))];
    
    CapturedImageViewController * cap =  [[CapturedImageViewController alloc] initWithImage:croppedImage];
    
    [self.uniteImagesView addSubview:cap.view];
     [self.uniteImagesView addSubview:self.overlayesScrollView];
    
     [self.view addSubview:uniteImagesView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    NSMutableArray *buttonsArray = [NSMutableArray array];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(pageOverlay:)];
    nextButton.tag = kNext;
    [buttonsArray addObject:nextButton];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttonsArray addObject:flexItem];
    
     previewButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStyleDone target:self action:@selector(tooglePreviewEdit:)];
    nextButton.tag = kPreview;
    [buttonsArray addObject:previewButton];
    
    flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttonsArray addObject:flexItem];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(pageOverlay:)];
    nextButton.tag = kPrev;
    [buttonsArray addObject:prevButton];
    
    
    [toolbar setItems:buttonsArray];
    [self.view addSubview:toolbar];
}
-(void)tooglePreviewEdit:(UIBarButtonItem*)sender{
    
    if (self.overlayesScrollView.alpha < 1) {
        self.overlayesScrollView.alpha=1;
        previewButton.title = @"Edit";
    }else{
        self.overlayesScrollView.alpha=.7;
        previewButton.title = @"Preview";
    }
}

-(void)pageOverlay:(UIBarButtonItem*)barItem{
    switch (barItem.tag) {
        case kNext:
                [self.overlayesScrollView scrollRectToVisible:CGRectMake(320, 0, 320, 460) animated:YES];
            break;
        case kPrev:
                [self.overlayesScrollView scrollRectToVisible:CGRectMake(0, 0, 320, 460) animated:YES];
            break;
            
            
    
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
    
  
           sheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:
                   NSLocalizedString(@"Album", nil),
                   NSLocalizedString(@"Email", nil),
                   NSLocalizedString(@"FaceBook",nil),
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
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
    [self toggleFullscreen];
}




#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet
{
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	
	[mailComposer setSubject:@"Hello from the Jerusalem Biblical Zoo!"];
	UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    
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
        case 0:
             [self saveToAlbum];
           
            break;
        case 1:
             [self displayComposerSheet];
            break;
        case 2:
          
             [self postWall];
            break;
    }
}


@end
