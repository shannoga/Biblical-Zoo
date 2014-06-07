//
//  VisitorsIMageUploadTableViewController.m
//  
//
//  Created by shani hajbi on 6/1/14.
//
//

#import "VisitorsImageUploadViewController.h"

@interface VisitorsImageUploadViewController ()

@end

@implementation VisitorsImageUploadViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.previewImage.image = self.userImage;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)sendImage:(id)sender
{
    UIImage *scaledImage = [self imageWithImage:self.userImage scaledToSize:CGSizeMake(640, 380)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(scaledImage, 1);
    //self.latestImageImageView.image = scaledImage;
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",self.animal.nameEn] data:dataForJPEGFile];
    //self.uploadImageProgressView.hidden = NO;
    __weak VisitorsImageUploadViewController *weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
  
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"uploaded");
        
        PFObject *userPhoto = [PFObject objectWithClassName:@"VisitorsPhotos"];
        userPhoto[@"animalNameEn"] = self.animal.nameEn;
        userPhoto[@"userName"] = self.userNameLabel.text;
        userPhoto[@"userNote"] = self.noteLabel.text;
        [userPhoto setObject:imageFile forKey:@"image"];
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             [hud hide:YES];
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Error"]
                                                                 message:[Helper languageSelectedStringForKey:@"There was an error uploading your image, please try again later"] delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Great"]
                                                                message:[Helper languageSelectedStringForKey:@"We got your image, it will be publish in the app..."] delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
                [alert show];
                
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
               // weakSelf.uploadImageProgressView.hidden = YES;
                
                // Log details of the failure
            }
        }];
    } progressBlock:^(int percentDone) {
        NSLog(@"uploading %f",percentDone/100.0f);
         hud.progress = percentDone/100.0f;
    }];

}


- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
