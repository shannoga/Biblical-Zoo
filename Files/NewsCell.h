//
//  NewsCell.h
//  GData
//
//  Created by shani hajbi on 17/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Parse/Parse.h>

@interface NewsCell : PFTableViewCell

@property (nonatomic,strong) PFObject *newsObject;
@property (nonatomic,strong) UILabel *labelView;
@property (nonatomic,strong) UILabel *detailLableView;

- (void)setNews:(PFObject *)aNews atIndex:(NSInteger)cellIndex;

@end
