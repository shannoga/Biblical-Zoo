//
//  AnimalTableViewCell.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/16/12.
//
//

#import <UIKit/UIKit.h>

@interface AnimalTableViewCell : UITableViewCell

@property (nonatomic, weak) Animal *animal;
@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UIImageView *iconImageView;
@property (nonatomic, retain)  UIImageView *auodioGuideIndicator;
@property (nonatomic, retain)  UIImageView *manyAnimalsIndicator;
-(void)setAnAnimal:(Animal*)anAnimal;

@end
