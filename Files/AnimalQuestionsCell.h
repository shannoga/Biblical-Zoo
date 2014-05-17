//
//  AnimalQuestionsCell.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/21/12.
//
//

#import <UIKit/UIKit.h>

@interface AnimalQuestionsCell : PFTableViewCell

@property (nonatomic,strong) PFObject *questionObject;
@property (nonatomic,strong) IBOutlet UILabel *labelView;
@property (nonatomic,strong) IBOutlet UILabel *detailLableView;
@property (nonatomic,strong) IBOutlet UIImageView *iconView;

@end
