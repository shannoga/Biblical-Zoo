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
@property (nonatomic,strong) UILabel *labelView;
@property (nonatomic,strong) UILabel *detailLableView;

- (void)setQuestion:(PFObject *)aQuestion atIndex:(NSInteger)cellIndex;

@end
