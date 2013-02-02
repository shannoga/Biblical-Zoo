//
//  FunAnimalImageOverlayViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/17/12.
//
//

#import "FunAnimalImageOverlayViewController.h"
#import "UIImage+Helper.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>

#define kNext 0
#define kPrev 1
#define kPreview 2

@interface FunAnimalImageOverlayViewController ()

@end

@implementation FunAnimalImageOverlayViewController
@synthesize imagePicker,overlayesScrollView;
@synthesize overlayImages;
@synthesize selectedOverLayIndex;

@synthesize selectedOverLay;
@synthesize uniteImagesView;
@synthesize imagesContainer;
@synthesize capturedImageViewController;
@synthesize photoImage;
@synthesize previewButton;
@synthesize toolbar;
@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (![Helper isRightToLeft]) {
            overlayImages = @[[UIImage imageNamed:@"lion_overlay_en"],[UIImage imageNamed:@"zoo_overlay_en"]];
        }else{
            overlayImages = @[[UIImage imageNamed:@"lion_overlay_he"],[UIImage imageNamed:@"zoo_overlay_he"]];
        }
    }
    if(![Helper isLion]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(unlock) name:@"unlock-feature"  object: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uniteImagesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.imagesContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.imagesContainer.userInteractionEnabled = NO;

    self.previewButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Move and Scale",nil) style:UIBarButtonItemStyleDone target:self action:@selector(tooglePreviewEdit:)];
    self.previewButton.tag = kPreview;
    
    // Custom initialization
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSavingOptions)];
    UIBarButtonItem *takePhoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(toggleImagePicker)];
    share.tintColor = UIColorFromRGB(0xBDB38C);
    self.toolbar  = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
    [self.toolbar setItems:@[takePhoto,flexItem,previewButton,flexItem,share]];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 10, 30, 30)];
    [self.closeButton setImage:[UIImage imageNamed:@"277-MultiplyCircle"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
   // [self.navigationItem setTitleView:self.toolbar];
   // self.navigationItem.rightBarButtonItem = share;
    [self.view addSubview:self.toolbar];
    //show the image picker controller
    [self showImagePickerController];
}

-(void)showImagePickerController{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        
        UIView *cameraOverlayView = [[UIView alloc] initWithFrame:self.imagePicker.view.bounds];
        // creating overlayView
        // Do any additional setup after loading the view from its nib.
        self.overlayesScrollView = [[UIScrollView alloc] initWithFrame:self.imagePicker.view.bounds];
        self.overlayesScrollView.contentSize = CGSizeMake(960, 480);
        self.overlayesScrollView.userInteractionEnabled = NO;
        self.overlayesScrollView.alpha = .7;
        
        NSInteger counter = 0;
        for (UIImage *image in overlayImages) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setFrame:CGRectMake(counter*320, 0, 320, 480)];
            [self.overlayesScrollView addSubview:imageView];
            counter++;
        }
        [cameraOverlayView addSubview:self.overlayesScrollView];
        
        UIToolbar *pickerTollbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.imagePicker.view.bounds.size.height-44, 320, 44)];
        
        UIBarButtonItem *takePhoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture)];
        UIBarButtonItem *nextOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arr-right"] style:UIBarButtonItemStylePlain target:self action:@selector(switchPageOverlay:)];
        nextOverlay.tag = kNext;
        UIBarButtonItem *prevOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arr-left"] style:UIBarButtonItemStylePlain target:self action:@selector(switchPageOverlay:)];
        prevOverlay.tag = kPrev;
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
       
        
        prevOverlay.tag = kPrev;
        
        [pickerTollbar setItems:@[flexItem,prevOverlay,flexItem,takePhoto,flexItem,nextOverlay,flexItem]];
        [cameraOverlayView addSubview:pickerTollbar];
        
        
        imagePicker.allowsEditing=YES;
        imagePicker.showsCameraControls = NO;
        imagePicker.cameraOverlayView = cameraOverlayView;
        
        //[self presentModalViewController:imagePicker  animated:YES];
        
        [self.view addSubview:imagePicker.view];
        [self.view addSubview:closeButton];
        self.pickerVisible = YES;
    }
}

-(void)closeCamera{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)switchPageOverlay:(UIBarButtonItem*)barItem{
    switch (barItem.tag) {
        case kNext:
            selectedOverLayIndex=1;
            [self.overlayesScrollView scrollRectToVisible:CGRectMake(320, 0, 320, 460) animated:YES];
            break;
        case kPrev:
            selectedOverLayIndex=0;
            [self.overlayesScrollView scrollRectToVisible:CGRectMake(0, 0, 320, 460) animated:YES];
            break;
            
    }
}

- (void) takePicture
{
    [self.imagePicker takePicture];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedOverLay = overlayImages[selectedOverLayIndex];
    [self.imagesContainer setImage:self.selectedOverLay];
    
    self.photoImage = [info
                      objectForKey:UIImagePickerControllerOriginalImage];
    
    self.capturedImageViewController =  [[CapturedImageViewController alloc] initWithImage:self.photoImage];
    [self.uniteImagesView addSubview:self.capturedImageViewController.view];
    [self.uniteImagesView addSubview:self.imagesContainer];
    
    [self.view insertSubview:self.uniteImagesView belowSubview:self.toolbar];
    self.imagesContainer.alpha=1;
    self.imagesContainer.userInteractionEnabled = YES;
    [self toggleImagePicker];
}

-(void)toggleImagePicker{
    [UIView animateWithDuration:1 animations:^{
        if (self.pickerVisible) {
            self.imagePicker.view.transform = CGAffineTransformMakeTranslation(0, 480);
            
        }else{
            [self.view addSubview:self.imagePicker.view];
            [self.view addSubview:closeButton];
            self.imagePicker.view.transform = CGAffineTransformIdentity;
            self.capturedImageViewController = nil;
            [[self.uniteImagesView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
           
        }
    } completion:^(BOOL finished) {
        if (self.pickerVisible) {
            self.pickerVisible = NO;
            [self.imagePicker.view removeFromSuperview];
        }else{
            self.pickerVisible = YES; 
        }
    }];
}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tooglePreviewEdit:(UIBarButtonItem*)sender{
    
    if (self.imagesContainer.alpha < 1) {
        self.imagesContainer.alpha=1;
        self.imagesContainer.userInteractionEnabled = YES;
        previewButton.title = NSLocalizedString(@"Move and Scale",nil);
    }else{
        self.imagesContainer.alpha=.7;
        self.imagesContainer.userInteractionEnabled = NO;
        previewButton.title = NSLocalizedString(@"Done",nil);
    }
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

    UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    // Save the captured image to photo album
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [refreshHUD hide:YES];
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


-(void)showHud{
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    refreshHUD.delegate = self;
    [refreshHUD show:YES];
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
    [refreshHUD hide:YES];
    if ([MFMailComposeViewController canSendMail]){
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
    
	
        [self presentViewController:mailComposer animated:YES completion:^{[refreshHUD hide:YES];}];
   
    
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

#pragma mark -
#pragma mark FaceBook

-(void)postWall{
     UIImage *image = [UIImage imageWithView:self.uniteImagesView];
    
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
                        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                        
                        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                            if (result == SLComposeViewControllerResultCancelled) {
                                
                                NSLog(@"Cancelled");
                                
                            } else
                                
                            {
                                NSLog(@"Done");
                            }
                            
                            [controller dismissViewControllerAnimated:YES completion:Nil];
                        };
                        controller.completionHandler =myBlock;
                        
                        NSString *localizedText = NSLocalizedString(@"photo sharing text",nil);
                        [controller setInitialText:localizedText];
                        [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id591193554"]];
                        [controller addImage:image];
                        [self presentViewController:controller animated:YES completion:^{
                            [refreshHUD hide:YES];
                        }];
            
            
        }else{
            if ([PFUser currentUser] && // Check if a user is cached
                [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) // Check if user is linked to Facebook
            {
                
               
                
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
                                                               delegate:self cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:@"Login", nil];
                
                alert.tag = 1;
                [alert show];
            }
        }
}


-(void)showBuyFullAppAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Buy Full App", nil) message:NSLocalizedString(@"Buy full app description", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Later", nil) otherButtonTitles:NSLocalizedString(@"Buy Now", nil), nil];
    alert.tag = 2;
    [alert show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex==1) {
                 NSLog(@"connectToFacebook");
            }
            
            break;
        case 2:
            if (buttonIndex==1) {
                
                [[Helper appDelegate] buyFullApp];
            }
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
     [refreshHUD hide:YES];
    NSLog(@" [result objectForKey] = %@", result[@"post_id"]);
    NSLog(@"result class %@",[result class]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucsses"
                                                    message:@"Image posted on Facebook."
                                                   delegate:self cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
   
    
    
}
-(void)requestLoading:(PF_FBRequest *)request{
    NSLog(@"%@",request);
}
-(void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error{
     [refreshHUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                    message:@"Uploading to FaceBook Failed, Please try again."
                                                   delegate:self cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"%@",[error description]);
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
            
            [self postWall];
             [self showHud];
            break;
    }
   
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end
