//
//  EventTableViewCell.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface EventTableViewCell : UITableViewCell {

	UILabel *labelView;
	UILabel *detailLableView;
	UILabel *timeLableView;
    UILabel *locationLableView;
	UIImageView *cellImageView;
    CALayer *locationBtnLayer;
    Event *event;
    
}
@property (nonatomic,strong) Event *event;
@property (nonatomic,strong) UILabel *labelView;
@property (nonatomic,strong) UILabel *detailLableView;
@property (nonatomic,strong) UILabel *timeLableView;
@property (nonatomic,strong) UILabel *locationLableView;
@property (nonatomic,strong) UIImageView *cellImageView;
@property (nonatomic,strong) CALayer *locationBtnLayer;

- (void)setAnEvent:(Event *)anEvent;


@end