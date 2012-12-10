//
//  AnimalUserPostsViewer.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 04/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "AnimalUserPostsViewer.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimalUserPostsViewer
@synthesize postLabel;
@synthesize nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//UIColorFromRGB(0x21190c);
        
        postLabel = [[UITextView alloc] init];
        postLabel.textColor = [UIColor whiteColor];
        postLabel.textAlignment = [Helper isRightToLeft]?UITextAlignmentRight:UITextAlignmentLeft;
        postLabel.backgroundColor = [UIColor clearColor];
        postLabel.font = [UIFont fontWithName:@"Arial" size:14];
        postLabel.text =@"";
        [self addSubview:postLabel];
        postLabel.editable = NO;
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = [Helper isRightToLeft]?UITextAlignmentRight:UITextAlignmentLeft;
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
        nameLabel.text =@"";
        [self addSubview:nameLabel];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.shouldRasterize = YES;
        
        

    }
    return self;
}


-(void)layoutSubviews{
    int inset = 30;
    postLabel.frame=  CGRectMake(inset/2, 70,CGRectGetWidth(self.bounds)-inset, 120);
    nameLabel.frame = CGRectMake(inset/2, 195,CGRectGetWidth(self.bounds)-inset, 20);
}

-(void)switchToPost:(PFObject*)post{
    [UIView animateWithDuration:.5 animations:^{
                postLabel.alpha = 0;
    } completion:^(BOOL finished) {
                postLabel.text = post[@"text"];
                nameLabel.text = post[@"user"];
          [UIView animateWithDuration:.5 animations:^{
              postLabel.alpha = 1;
          }];
    }];
  
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
