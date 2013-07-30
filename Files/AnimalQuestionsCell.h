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

-(void)setObject:(PFObject *)anObject atIndex:(NSInteger)cellIndex isQuestion:(BOOL)isQuestion;

@end
