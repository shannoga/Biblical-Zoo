//
//  AnimalDataNewViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/10/14.
//
//

#import "AnimalDataNewViewController.h"
#import "AnimalsImagesScrollView.h"
#import "AnimalDescriptionWebViewController.h"
#import "SendPostOrQuestionViewController.h"
#import "ViewQuestionsOrPostsViewController.h"
#import "AnimalDataTableViewController.h"
#import "AnimalDataNewSectionHeaderView.h"
#import "AnimalAudioGuideViewController.h"
#import "VisitorsImagesViewController.h"

@interface AnimalDataNewViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic) BOOL isShowingHeaderView;
@property (nonatomic) BOOL didLoadPosts;
@property (nonatomic) BOOL didLoadQuestions;
@property (nonatomic) BOOL didLoadImages;
@end

@implementation AnimalDataNewViewController

- (void)awakeFromNib
{
    self.isShowingHeaderView = NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.animal.audioGuide.boolValue) {
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.frame.size.height) animated:NO];
    [[self tableView] setContentInset:UIEdgeInsetsMake(-self.tableView.tableHeaderView.frame.size.height, 0, 0, 0)];
  //  self.tableView.tableHeaderView.hidden = YES;
    self.latestPostLabel.textAlignment = self.latestQuestionLabel.textAlignment =[Helper appLang]==kHebrew ?NSTextAlignmentRight : NSTextAlignmentLeft;
    [self setUpConservationStatus];
    [self setUpScrollViewImages];
    self.uploadImageProgressView.hidden = YES;

}


- (UIBarButtonItem *)cancelBarButton
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"animalDescriptionSegue"]) {
        AnimalDescriptionWebViewController *webViewController = (AnimalDescriptionWebViewController *)segue.destinationViewController;
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
       
        postsViewer.pullToRefreshEnabled = NO;
        postsViewer.loadingViewEnabled = NO;
        postsViewer.paginationEnabled = YES;
        postsViewer.objectsPerPage = 15;
        postsViewer.animal = self.animal;
        if ([segue.identifier isEqualToString:@"ViewAnimalPosts"])
        {
             postsViewer.className = @"AnimalPost";
            postsViewer.postType = ViewerPostTypePost;
        }
        else
        {
             postsViewer.className = @"AnimalQuestions";
            postsViewer.postType = ViewerPostTypeQuestion;
        }
    }
    else if ([segue.identifier isEqualToString:@"DescriptionWebView"])
    {
         AnimalDescriptionWebViewController *webView = (AnimalDescriptionWebViewController *)segue.destinationViewController;
        webView.animal = self.animal;
    }
    else if ([segue.identifier isEqualToString:@"DataList"])
    {
        AnimalDataTableViewController *tableViewController = (AnimalDataTableViewController *)segue.destinationViewController;
        tableViewController.animal = self.animal;
    }
    else if ([segue.identifier isEqualToString:@"audioGuideSegue"])
    {
        AnimalAudioGuideViewController *audioViewController = (AnimalAudioGuideViewController *)segue.destinationViewController;
        audioViewController.animal = self.animal;
    }
    else if ([segue.identifier isEqualToString:@"AnimalImageGallery"])
    {
        VisitorsImagesViewController *imagesController = (VisitorsImagesViewController *)segue.destinationViewController;
        imagesController.animal = self.animal;
        imagesController.pullToRefreshEnabled = NO;
    }
  
}

- (void)setUpConservationStatus
{

    self.conservationIndicatorLabel.text = [Helper languageSelectedStringForKey:self.animal.conservationStatus];
    //NSLocalizedString(self.animal.conservationStatus,nil);
    for (UIView *conservationView in self.conservationViews)
    {
        conservationView.layer.cornerRadius = 20.0f;
        conservationView.layer.borderColor = [Helper colorForConservationStatus:conservationView.tag].CGColor;
        conservationView.layer.borderWidth = 1.0;
        for (UILabel *label in conservationView.subviews)
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                label.textColor = [Helper textColorForConservationStatus:conservationView.tag];
            }
            
            if ([self.animal.conservationStatus isEqualToString:label.text])
            {
                self.conservationIndicatorConstraint.constant = CGRectGetWidth(self.view.frame) - conservationView.center.x - CGRectGetWidth(self.conservationIndicatorImageView.frame)/2;
                if (IS_IOS7) {
                    self.conservationIndicatorImageView.image = [self.conservationIndicatorImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [self.conservationIndicatorImageView setTintColor:[Helper colorForConservationStatus:conservationView.tag]];
                }

                [UIView animateWithDuration:2 animations:^{
                    [self.conservationIndicatorImageView layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [self startBlinkAnimation];
                }];
            }
        }
    }
    
}

- (void)startBlinkAnimation {
    __weak AnimalDataNewViewController * weakSelf = self;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         weakSelf.conservationIndicatorImageView.alpha = (self.conservationIndicatorImageView.alpha < 1)? 1 : .2;
                     }completion:^(BOOL finished){
                         [weakSelf startBlinkAnimation];
                     }];
    
}

- (void)setUpLatestPost
{
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalPost"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];

    [query whereKey:@"animalNameEn" equalTo:self.animal.nameEn];
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
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query whereKey:@"animal_en_name" equalTo:self.animal.nameEn];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a question about %@",self.animal.name];
            self.latestQuestionLabel.text = placeHolderString;
            self.latestQuestionUserNameLabel.text = @"";
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            NSString *key = [Helper appLang]==kHebrew ?  @"question" : @"question_en" ;
            self.latestQuestionLabel.text = object[key];
            self.latestQuestionUserNameLabel.text = object[@"user_name"];
        }
    }];
    
    NSString *placeHolderString = [NSString stringWithFormat:@"Be the first to ask a question about %@",self.animal.name];
    self.latestQuestionLabel.text = placeHolderString;
    self.latestQuestionUserNameLabel.text = @"";
}

- (void)setUpLatestUserImage
{
    PFQuery *query = [PFQuery queryWithClassName:@"VisitorsPhotos"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"animalNameEn" equalTo:self.animal.nameEn];

    //[query whereKey:@"animalNameEn" equalTo:self.animal.nameEn];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            self.latestImageImageView.image = [UIImage imageNamed:@""]; // placeholder image
            self.latestImageImageView.file = (PFFile *)object[@"image"]; // remote image
            [self.latestImageImageView loadInBackground];
        }
    }];
}



- (void)setUpScrollViewImages
{
    AnimalsImagesScrollView *imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 190) withAnimal:self.animal];
    [self.imagesScrollViewContainer addSubview:imagesScrollView];
}

//[self.tableView beginUpdates];
//[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//[self.tableView endUpdates];

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.animal.generalExhibitDescription)
    {
        if(indexPath.section == 1)
        {
            if(indexPath.row < 3)
            {
                return 0;
            }
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.animal.generalExhibitDescription)
    {
        if(indexPath.section == 1)
        {
            if(indexPath.row < 3)
            {
                cell.hidden = YES;
            }
        }
    }
    if (IS_IOS7) {
        cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imageView setTintColor:[UIColor colorWithRed:0.000 green:0.392 blue:0.004 alpha:1]];
    }
    switch (indexPath.section) {
        case AnmialDataSectionQuestions:
            if (!self.didLoadQuestions)
            {
                [self setUpLatestQuestion];
                self.didLoadQuestions = YES;
            }
            break;
        case AnmialDataSectionPosts:
            if (!self.didLoadPosts)
            {
                [self setUpLatestPost];
                self.didLoadPosts = YES;
            }
            break;
        case AnmialDataSectionPhotos:
            if (!self.didLoadImages)
            {
                [self setUpLatestUserImage];
                self.didLoadImages = YES;
            }
            break;
            
        default:
            break;
    }
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section != 0) {
// 
//    AnimalDataNewSectionHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"AnimalDataNewSectionHeaderView" owner:self options:nil][0];
//    NSString *title = nil;
//    NSString *imageName = nil;
//    switch (section) {
//        case AnmialDataSectionData:
//        {
//            NSString *aboutString = NSLocalizedString(@"About the %@",nil);
//            title = [NSString stringWithFormat:aboutString,self.animal.name];
//        }
//            break;
//        case AnmialDataSectionQuestions:
//        {
//            title = NSLocalizedString(@"Ask Questions",nil);
//        }
//            break;
//        case AnmialDataSectionPhotos:
//        {
//            title = NSLocalizedString(@"Your Images",nil);
//        }
//            break;
//        case AnmialDataSectionPosts:
//        {
//            title = NSLocalizedString(@"Visitors Posts",nil);
//        }
//            break;
//            
//        default:
//            break;
//    }
//    headerView.titleLabel.text = title;
//    //headerView.titleLabel.text = title;
//    return headerView;
//    }
//    return nil;
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}

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
    UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(640, 380)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(scaledImage, 1);
    self.latestImageImageView.image = scaledImage;
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",self.animal.nameEn] data:dataForJPEGFile];
      self.uploadImageProgressView.hidden = NO;
    __weak AnimalDataNewViewController *weakSelf = self;

    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"uploaded");
      

        PFObject *userPhoto = [PFObject objectWithClassName:@"VisitorsPhotos"];
        //PFObject *animal = [PFObject objectWithoutDataWithClassName:animal objectId:<#(NSString *)#>
        userPhoto[@"animalNameEn"] = self.animal.nameEn;
        [userPhoto setObject:imageFile forKey:@"image"];
        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                weakSelf.uploadImageProgressView.hidden = YES;
                //[self refresh:nil];
            }
            else{
                weakSelf.uploadImageProgressView.hidden = YES;

                // Log details of the failure
            }
        }];
    } progressBlock:^(int percentDone) {
          NSLog(@"uploading %f",percentDone/100.0f);
        [weakSelf.uploadImageProgressView setProgress:percentDone/100.0f animated:YES];
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

- (IBAction)showAudioGuide:(id)sender
{
    if (!self.isShowingHeaderView)
    {
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
        //[[self tableView] setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

        self.isShowingHeaderView = YES;

    }
    else
    {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.frame.size.height-64) animated:YES];
//        [[self tableView] setContentInset:UIEdgeInsetsMake(-self.tableView.tableHeaderView.frame.size.height, 0, 0, 0)];

        self.isShowingHeaderView = NO;

    }
}










@end
