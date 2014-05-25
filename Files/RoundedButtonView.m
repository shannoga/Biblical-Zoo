//
//  RoundedButtonView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/24/14.
//
//

#import "RoundedButtonView.h"

@implementation RoundedButtonView

- (void)awakeFromNib
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
