//
//  VisitorsImagesViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/25/14.
//
//

#import "VisitorsImagesViewController.h"
#import "VisitorsImageCollectionViewCell.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "FSBasicImage.h"
#import "XHImageViewer.h"

@interface VisitorsImagesViewController ()<XHImageViewerDelegate>
@property (nonatomic,strong) NSMutableArray *images;
@end

@implementation VisitorsImagesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.images = [NSMutableArray array];
//    [self.collectionView registerClass:[VisitorsImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];

    // Do any additional setup after loading the view.
}

- (PFQuery *)queryForCollection
{
    PFQuery *query = [PFQuery queryWithClassName:@"VisitorsPhotos"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"animalNameEn" equalTo:self.animal.nameEn];
    return query;
}

# pragma mark - Collection View data source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    PFImageView *imageView = (PFImageView *) [cell viewWithTag:1];
    imageView.file = (PFFile *)object[@"image"];
    [imageView loadInBackground:^(UIImage *image, NSError *error) {
        if (error) {
            NSLog(@"error= %@",error.description);
        }
        else
        {
            FSBasicImage *photo = [[FSBasicImage alloc] initWithImage:image name:object[@"userName"]];
            [self.images addObject:photo];
            NSLog(@"loaded image %@", image);
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:self.images];
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)canRotate {
    NSLog(@"");
}




@end
