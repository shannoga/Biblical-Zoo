//
//  AnimalDataNewViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/10/14.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"

typedef NS_ENUM(NSInteger, AnmialDataSections) {
    AnmialDataSectionImagesScroll,
    AnmialDataSectionData,
    AnmialDataSectionQuestions,
    AnmialDataSectionPhotos,
    AnmialDataSectionPosts,
};

typedef NS_ENUM(NSInteger, AnmialDataCells) {
    AnmialDataCellShorts,
    AnmialDataCellFullData,
};

typedef NS_ENUM(NSInteger, AnmialQuestionsCells) {
    AnmialQuestionsCellLastestQuestion,
    AnmialQuestionsCellSendQuestion,
};

typedef NS_ENUM(NSInteger, AnmialPostsCells) {
    AnmialPostsCellLastestPost,
    AnmialPostsCellSendPost,
};

typedef NS_ENUM(NSInteger, AnmialPhotosCells) {
    AnmialPhotosCellsLatestImage,
    AnmialPhotosCellsSendImage,
};

@interface AnimalDataNewViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) Animal *animal;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *conservationViews;


@property (weak, nonatomic) IBOutlet UIView *imagesScrollViewContainer;

@property (weak, nonatomic) IBOutlet UILabel *latestQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestQuestionUserNameLabel;

@property (weak, nonatomic) IBOutlet PFImageView *latestImageImageView;
@property (weak, nonatomic) IBOutlet UILabel *latestImageUserNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *latestPostUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestPostLabel;

- (IBAction)dissmisModalViewController:(id)sender;
@end
