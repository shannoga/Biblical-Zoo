//
//  PhotoDetailViewController.h
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController
{
    IBOutlet UIImageView *photoImageView;
    UIImage *selectedImage;
    NSString *imageName;
}
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSString *imageName;

- (IBAction)close:(id)sender;
@end
