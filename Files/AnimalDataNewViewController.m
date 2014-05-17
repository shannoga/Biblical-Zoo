//
//  AnimalDataNewViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/10/14.
//
//

#import "AnimalDataNewViewController.h"
#import "AnimalsImagesScrollView.h"
#import "AnimalDescriptionWebView.h"
#import "SendPostOrQuestionViewController.h"
#import "ViewQuestionsOrPostsViewController.h"

@interface AnimalDataNewViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation AnimalDataNewViewController

- (void)awakeFromNib
{
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView.hidden = YES;
    [self setUpConservationStatus];
    [self setUpScrollViewImages];
    [self setUpLatestPost];
     [self setUpLatestQuestion];
    [self setUpLatestUserImage];
}

- (UIBarButtonItem *)cancelBarButton
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"animalDescriptionSegue"]) {
        AnimalDescriptionWebView *webViewController = (AnimalDescriptionWebView *)segue.destinationViewController;
        webViewController.animal = self.animal;
    }
    else if ([segue.identifier isEqualToString:@"PostQuestion"] || [segue.identifier isEqualToString:@"PostPost"])
    {
        UINavigationController *navController = (UINavigationController *) segue.destinationViewController;
        SendPostOrQuestionViewController *destController = (SendPostOrQuestionViewController *) navController.viewControllers[0];
        destController.navigationItem.leftBarButtonItem = [self cancelBarButton];
        destController.animal = self.animal;
        if ([segue.identifier isEqualToString:@"PostQuestion"])
        {
            destController.postType = PostTypeQuestion;
        }
        else
        {
            destController.postType = PostTypePost;

        }
    }
    else if ([segue.identifier isEqualToString:@"ViewAnimalQuestions"] || [segue.identifier isEqualToString:@"ViewAnimalPosts"])
    {
         ViewQuestionsOrPostsViewController *postsViewer = (ViewQuestionsOrPostsViewController *)segue.destinationViewController;
        postsViewer.className = @"AnimalQuestions";
        postsViewer.pullToRefreshEnabled = NO;
        postsViewer.loadingViewEnabled = NO;
        postsViewer.paginationEnabled = YES;
        postsViewer.objectsPerPage = 15;
        postsViewer.animal = self.animal;
        if ([segue.identifier isEqualToString:@"ViewAnimalPosts"])
        {
            postsViewer.postType = ViewerPostTypePost;
        }
        else
        {
            postsViewer.postType = ViewerPostTypeQuestion;
        }
    }
  
}

- (void)setUpConservationStatus
{
    for (UIView *conservationView in self.conservationViews) {
        conservationView.layer.cornerRadius = 20.0f;
        conservationView.layer.borderColor = [Helper colorForConservationStatus:conservationView.tag].CGColor;
        conservationView.layer.borderWidth = 1.0;
        for (UILabel *label in conservationView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = [Helper textColorForConservationStatus:conservationView.tag];
            }
        }
    }
}

- (void)setUpLatestPost
{
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalPost"];
    //[query whereKey:@"objectId" equalTo:self.animal.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
             NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a post about %@",self.animal.name];
            self.latestPostLabel.text = placeHolderString;
            self.latestPostUserNameLabel.text = @"";
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            self.latestPostLabel.text = object[@"text"];
            self.latestPostUserNameLabel.text = object[@"user"];
        }
    }];
    NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a post about %@",self.animal.name];
    self.latestPostLabel.text = placeHolderString;
    self.latestPostUserNameLabel.text = @"";
}

- (void)setUpLatestQuestion
{
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalQuestions"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    //[query whereKey:@"objectId" equalTo:self.animal.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a question about %@",self.animal.name];
            self.latestQuestionLabel.text = placeHolderString;
            self.latestQuestionUserNameLabel.text = @"";
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            self.latestQuestionLabel.text = object[@"question_en"];
            self.latestQuestionUserNameLabel.text = object[@"user_name"];
        }
    }];
    
    NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a question about %@",self.animal.name];
    self.latestQuestionLabel.text = placeHolderString;
    self.latestQuestionUserNameLabel.text = @"";
}

- (void)setUpLatestUserImage
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    //[query whereKey:@"objectId" equalTo:self.animal.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            self.latestImageImageView.image = [UIImage imageNamed:@""]; // placeholder image
            self.latestImageImageView.file = (PFFile *)object[@"imageFile"]; // remote image
            [self.latestImageImageView loadInBackground];
        }
    }];
}



- (void)setUpScrollViewImages
{
    AnimalsImagesScrollView *imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 190) withAnimal:self.animal];
    [self.imagesScrollViewContainer addSubview:imagesScrollView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case AnmialDataSectionData:
            
            
            break;
        case AnmialDataSectionQuestions:
            if (indexPath.row == AnmialQuestionsCellSendQuestion)
            {
                [self sendQuestion];
            }
            break;
        case AnmialDataSectionPhotos:
            if (indexPath.row == AnmialPhotosCellsSendImage)
            {
                [self takeAnimalPicture];
            }
            break;
        case AnmialDataSectionPosts:
            if (indexPath.row == AnmialQuestionsCellSendQuestion)
            {
                [self sendQuestion];
            }
            break;
            break;
            
        default:
            break;
    }
}




#pragma mark take photo

- (void)takeAnimalPicture
{
    // does the device have a camera?
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        RIButtonItem *selectPhotoButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"Choose from library",nil) action:^{
            [self selectPhoto];
        }];
        RIButtonItem *takePhotoButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"Take a photo",nil) action:^{
            [self takePhoto];
        }];
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Image source",nil) cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel",nil)] destructiveButtonItem:nil otherButtonItems:takePhotoButton,selectPhotoButton, nil];
        [ac showInView:self.view];
    }
    else
    {
        [self selectPhoto];
    }
}

- (void)takePhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(320, 190)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(scaledImage, 0.6);
    self.latestImageImageView.image = scaledImage;
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",self.animal.nameEn] data:dataForJPEGFile];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"uploaded");
        
        PFObject *userPhoto = [PFObject objectWithClassName:@"VisitorsPhotos"];
        //PFObject *animal = [PFObject objectWithoutDataWithClassName:animal objectId:<#(NSString *)#>
       // userPhoto[@"animal"] = self.animal.objectId;
        [userPhoto setObject:imageFile forKey:@"image"];
        
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //[self refresh:nil];
            }
            else{
                // Log details of the failure
            }
        }];
    } progressBlock:^(int percentDone) {
          NSLog(@"uploading %i",percentDone);
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
- (void)sendPost
{
    NSLog(@"");
}

- (void)sendQuestion
{
    NSLog(@"");
}

- (IBAction)dissmisModalViewController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}





@end
