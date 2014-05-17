//
//  AnimalQuestionsCell.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/21/12.
//
//


#import "AnimalQuestionsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimalQuestionsCell

@synthesize labelView;
@synthesize detailLableView;

- (void)awakeFromNib
{
    self.labelView.textAlignment = self.detailLableView.textAlignment =  [Helper appLang]==kHebrew ?NSTextAlignmentRight : NSTextAlignmentLeft;
}

@end
