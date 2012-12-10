//
//  NewsCell.m
//  GData
//
//  Created by shani hajbi on 17/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "NewsCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation NewsCell

@synthesize newsObject;
@synthesize labelView;
@synthesize detailLableView;
@synthesize cellImageView;

+ (Class)layerClass
{
return [CAGradientLayer class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    
    newsObject = nil;
    labelView = nil;
    
    UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines=2;
    labelView = label;
    [self.contentView addSubview:labelView];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    font =  [UIFont fontWithName:@"Futura" size:14];
    
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines=4;
    detailLableView = label;
    [self.contentView addSubview:detailLableView];
    
    
    UIImageView *img = [[UIImageView alloc] init];
    img.layer.borderWidth = 3.0;
    img.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    img.layer.cornerRadius =5;
    img.layer.shouldRasterize=YES;
    self.cellImageView=img;
    self.cellImageView.clipsToBounds=YES;
    [self.contentView addSubview:cellImageView];
    
}
return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
        if ([[Helper currentLang] isEqualToString:@"en"]) {
            CGRect rect = CGRectMake(10,(self.bounds.size.height-86)/2, 130, 86);
            self.imageView.frame = rect;
            rect = CGRectMake(rect.size.width+20,CGRectGetHeight(self.bounds)*0.1,CGRectGetWidth(self.bounds)*0.5,CGRectGetHeight(self.bounds)*0.4);	
            labelView.frame = rect;
            rect.origin.y = rect.origin.y+ CGRectGetHeight(self.bounds)*0.3;
            rect.size.height =  CGRectGetHeight(self.bounds)*0.5;
            detailLableView.textAlignment= UITextAlignmentLeft;
            labelView.textAlignment= UITextAlignmentLeft;
            detailLableView.frame = rect;
          
        }else{
            
            CGRect rect = CGRectMake(180,(self.bounds.size.height-86)/2, 130, 86);
            self.imageView.frame = rect;
            rect = CGRectMake(CGRectGetWidth(self.bounds)*0.05, CGRectGetHeight(self.bounds)*0.1, CGRectGetWidth(self.bounds)*0.5,  CGRectGetHeight(self.bounds)*0.4);	
            labelView.frame = rect;
            labelView.textAlignment = UITextAlignmentRight;
            rect.origin.y = rect.origin.y+ CGRectGetHeight(self.bounds)*0.3;
            rect.size.height =  CGRectGetHeight(self.bounds)*0.5;
            detailLableView.frame = rect;
            detailLableView.textAlignment= UITextAlignmentRight;
        }

    self.imageView.layer.borderWidth = 3.0;
    self.imageView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    self.imageView.layer.cornerRadius =5;
    self.imageView.clipsToBounds=YES;
    self.imageView.layer.shouldRasterize=YES;

}


- (void)setNews:(PFObject *)aNews atIndex:(NSInteger)cellIndex{
if (aNews != newsObject) {
    newsObject = aNews;
}

NSArray * cellColors = @[(id)[UIColorFromRGB(0xabc9cb) CGColor],
                        (id)[UIColorFromRGB(0xc4e9dd) CGColor],
                        
                        (id)[UIColorFromRGB(0xa7bd8f) CGColor],
                        (id)[UIColorFromRGB(0x7d9770) CGColor]];

// Set the colors for the gradient layer.

NSInteger index = (cellIndex%2!=0)? 0:2;
CAGradientLayer *gradientLayer_ = (CAGradientLayer *)self.layer;
[gradientLayer_ setContentsScale:[[UIScreen mainScreen] scale]];
gradientLayer_.colors =@[cellColors[index],
                        cellColors[index++]];


    
    NSString *title = [[Helper currentLang] isEqualToString:@"en"]? newsObject[@"title"]:newsObject[@"title_he"];
    NSString *subtitle = [[Helper currentLang] isEqualToString:@"en"]? newsObject[@"subtitle"]:newsObject[@"subtitle_he"];
    
    self.labelView.text = title;
    self.detailLableView.text =subtitle;
    PFFile *thumbnail = newsObject[@"thumbnail"];
    self.imageView.image = [UIImage imageNamed:@"news_placeholder.png"];
    self.imageView.file = thumbnail;
    
    [self.imageView setNeedsDisplay];
    [self.detailLableView setNeedsDisplay];
    [self.labelView setNeedsDisplay];
}



@end
