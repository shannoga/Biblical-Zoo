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
@synthesize postString;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =UIColorFromRGB(0xf8eddf);
        
        
        postLabel = [[UITextView alloc] init];
        postLabel.textColor = [UIColor brownColor];
        postLabel.textAlignment = [Helper isRightToLeft]?UITextAlignmentRight:UITextAlignmentLeft;
        postLabel.backgroundColor = [UIColor clearColor];
        postLabel.textColor = UIColorFromRGB(0x281502);
        if(![Helper isRightToLeft]) {
            postLabel.font = [UIFont fontWithName:@"ArialHebrew" size:16];
        }else{
            postLabel.font = [UIFont fontWithName:@"Futura" size:16];
        }
        postLabel.text =@"";
        [self addSubview:postLabel];
        postLabel.editable = NO;
  
        
       postString = [[NSMutableString alloc] init];

    }
    return self;
}


-(void)layoutSubviews{
    int inset = 30;
    postLabel.frame=  CGRectMake(inset/2, 5,CGRectGetWidth(self.bounds)-inset, 160);
}

-(void)switchToPost:(PFObject*)post{
    [UIView animateWithDuration:.5 animations:^{
                self.postLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [postString setString:@""];
        [postString appendString:post[@"text"]];
        [postString appendString:@"\n"];
        [postString appendString:post[@"user"]];
        self.postLabel.text = postString;
          [UIView animateWithDuration:.5 animations:^{
              self.postLabel.alpha = 1;
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
