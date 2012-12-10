//
//  NewsCell.h
//  GData
//
//  Created by shani hajbi on 17/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Parse/Parse.h>

@interface NewsCell : PFTableViewCell{

    PFObject *newsObject;
    UILabel *labelView;
    UILabel *detailLableView;
    UIImageView *cellImageView;

}

@property (nonatomic,strong) PFObject *newsObject;
@property (nonatomic,strong) UILabel *labelView;
@property (nonatomic,strong) UILabel *detailLableView;
@property (nonatomic,strong) UIImageView *cellImageView;

- (void)setNews:(PFObject *)aNews atIndex:(NSInteger)cellIndex;

@end
