//
//  ExhibitTableViewCell.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 18/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exhibit.h"
@interface ExhibitTableViewCell : UITableViewCell{
    BOOL single;
}

@property (nonatomic, weak) Exhibit *exhibit;
@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UIImageView *iconImageView;
@property (nonatomic, retain)  UIImageView *auodioGuideIndicator;
@property (nonatomic, retain)  UIImageView *manyAnimalsIndicator;
-(void)setAnExhibit:(Exhibit*)anExhibit;

@end
