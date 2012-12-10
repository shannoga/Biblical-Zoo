//
//  SignForFreindViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "SignForFreindViewController.h"
#import "UIImage+Helper.h"
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

@synthesize habitatLBL;
@synthesize dietLBL;
@synthesize descriptionLBL;
@synthesize socialStructureLBL;

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
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*2);
  
    UIBarButtonItem *previewBtn = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStyleDone  target:self action:@selector(showSignPreview:)];
    self.navigationItem.rightBarButtonItem = previewBtn;
    //self.thumbnailImageView.image = [UIImage imageNamed:@"news_placeholder"];
    
    
    if ([Helper isRightToLeft]) {
        descriptionTV.text = @"התיאור של החבר";
       //
        descriptionTV.textAlignment = UITextAlignmentRight;
        
        habitatTV.text = @"אזור המחיה של החבר";
       // habitatTV.textAlignment= UITextAlignmentRight;
        
        socialStructureTV.text = @"המבנה החברתי של החבר";
       // socialStructureTV.textAlignment= UITextAlignmentRight;
        
        dietTV.text = @"התזונה של החבר";
       // dietTV.textAlignment= UITextAlignmentRight;
        
         habitatLBL.text = @"אזור מחיה";
        habitatLBL.textAlignment =  UITextAlignmentRight;
         dietLBL.text = @"תזונה";
        dietLBL.textAlignment =  UITextAlignmentRight;
         descriptionLBL.text = @"תיאור כללי";
        descriptionLBL.textAlignment =  UITextAlignmentRight;
         socialStructureLBL.text = @"מבנה חברתי";
        socialStructureLBL.textAlignment =  UITextAlignmentRight;
        
        nameTF.placeholder = @"שם לטיני";
        //nameTF.textAlignment =  UITextAlignmentRight;
        latinNameTF.placeholder = @"שם";
        //latinNameTF.textAlignment =  UITextAlignmentRight;
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)toggleFullscreen {
    
    _fullscreen = !_fullscreen;
    if (_fullscreen) { 
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
}

-(void)toggleFullscreenWithTimer{
    [self toggleFullscreen];
    if(!_fullscreen){
        [self performSelector:@selector(toggleFullscreen) withObject:nil afterDelay:2];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self toggleFullscreen];
}

-(IBAction)showSignPreview:(id)sender{
    [self captureScreen];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self toggleFullscreenWithTimer];
}



- (void)captureScreen
{
    
    NSThread *thread = [NSThread mainThread];
    [self performSelector:@selector(toggleFullscreen) onThread:thread withObject:nil waitUntilDone:YES];
    
    UIImage *image = [UIImage imageWithView:self.captureView];
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



-(void)lunchLibrary{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate: self];
    [picker allowsEditing];
    [picker setNavigationBarHidden: YES];
    [picker setWantsFullScreenLayout: YES];
    [self presentModalViewController:picker animated:YES];
}
-(void)lunchCamera{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType: UIImagePickerControllerSourceTypeCamera];
    [picker setDelegate: self];
    [picker allowsEditing];
    [picker setShowsCameraControls: YES];
    [picker setNavigationBarHidden: YES];
    [picker setWantsFullScreenLayout: YES];
    [self presentModalViewController:picker animated:YES];
}
-(IBAction)showCamera:(id)sender{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *cameraActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:@"Choose Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
        [cameraActionSheet showInView:self.view];
    }else{
        [self lunchLibrary];
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.thumbnailImageView.image = image;
     [[picker parentViewController] dismissModalViewControllerAnimated:YES]; 
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [[picker parentViewController] dismissModalViewControllerAnimated:YES];    // tell our delegate we are finished with the picker
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self lunchCamera];
            break;
        case 1:
            [self lunchLibrary];
            break;
   
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
    [self.scrollView adjustOffsetToIdealIfNeeded];
}



@end

