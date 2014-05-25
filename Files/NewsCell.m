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

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
     self.imageView.image = [UIImage imageNamed:@"news_placeholder.png"];
    
    
}
return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
        if ([Helper appLang]==kEnglish) {
            CGRect rect = CGRectMake(10,(self.bounds.size.height-86)/2, 86, 86);
            self.imageView.frame = rect;
            rect = CGRectMake(rect.size.width+20,CGRectGetHeight(self.bounds)*0.1,CGRectGetWidth(self.bounds)*0.5,CGRectGetHeight(self.bounds)*0.4);	
            labelView.frame = rect;
            UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];

            labelView.font = font;
            rect.origin.y = rect.origin.y+ CGRectGetHeight(self.bounds)*0.36;
            rect.size.height =  CGRectGetHeight(self.bounds)*0.5;
            detailLableView.textAlignment= NSTextAlignmentLeft;
            labelView.textAlignment= NSTextAlignmentLeft;
            detailLableView.frame = rect;
          
        }else{
            
            CGRect rect = CGRectMake(self.bounds.size.width-96,(self.bounds.size.height-86)/2, 86, 86);
            self.imageView.frame = rect;
            rect = CGRectMake(5, 25, 210, 20);
            UIFont *font =  [UIFont fontWithName:@"ArialHebrew-Bold" size:16];
            
            labelView.font = font;
            labelView.frame = rect;
            labelView.textAlignment = NSTextAlignmentRight;
            rect.origin.y = rect.origin.y;
            rect.size.height =  CGRectGetHeight(self.bounds)*0.7;
            detailLableView.frame = rect;
            detailLableView.textAlignment= NSTextAlignmentRight;
        }

    self.imageView.layer.borderWidth = 3.0;
    self.imageView.layer.borderColor = [UIColor colorWithRed:0.463 green:0.365 blue:0.322 alpha:1].CGColor;
    self.imageView.layer.cornerRadius =43;
    self.imageView.clipsToBounds=YES;
    self.imageView.layer.shouldRasterize=YES;

}


- (void)setNews:(PFObject *)aNews atIndex:(NSInteger)cellIndex{
if (aNews != newsObject) {
    newsObject = aNews;
}

NSArray * cellColors = @[(id)[UIColorFromRGB(0xf8eddf) CGColor],
                        (id)[UIColorFromRGB(0xf8eddf) CGColor],
                        
                        (id)[UIColorFromRGB(0xBDB38C) CGColor],
                        (id)[UIColorFromRGB(0xBDB38C) CGColor]];

// Set the colors for the gradient layer.

NSInteger index = (cellIndex%2!=0)? 0:2;
CAGradientLayer *gradientLayer_ = (CAGradientLayer *)self.layer;
[gradientLayer_ setContentsScale:[[UIScreen mainScreen] scale]];
gradientLayer_.colors =@[cellColors[index],
                        cellColors[index++]];


    
    NSString *title = [Helper appLang] == kEnglish? newsObject[@"title"]:newsObject[@"title_he"];
    NSString *subtitle = [Helper appLang] == kEnglish? newsObject[@"subtitle"]:newsObject[@"subtitle_he"];
    
    self.labelView.text = title;
    self.detailLableView.text =subtitle;
    
    if(newsObject[@"main_image"]!= [NSNull null]){
        PFFile *thumbnail = newsObject[@"main_image"];
        self.imageView.file = thumbnail;
        [self.imageView loadInBackground];
    }
    
    [self.detailLableView setNeedsDisplay];
    [self.labelView setNeedsDisplay];
}



@end
