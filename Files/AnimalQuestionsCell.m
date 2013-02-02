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

@synthesize questionObject;
@synthesize labelView;
@synthesize detailLableView;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        questionObject = nil;
        labelView = nil;
        
        UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines=0;
        labelView = label;
        [self.contentView addSubview:labelView];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        font =  [UIFont fontWithName:@"Futura" size:14];
        
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines=1;
        detailLableView = label;
        [self.contentView addSubview:detailLableView];
        
        self.imageView.image = [UIImage imageNamed:@"question.png"];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (![Helper isRightToLeft]) {
        CGRect rect = CGRectMake(10,(self.bounds.size.height-60)/2, 60, 60);
        self.imageView.frame = rect;
        rect = CGRectMake(rect.size.width+20,5,240,70);
        labelView.frame = rect;
        rect.origin.y = rect.origin.y+ 70;
        rect.size.height = 20;
        detailLableView.textAlignment= UITextAlignmentLeft;
        labelView.textAlignment= UITextAlignmentLeft;
        detailLableView.frame = rect;
        
    }else{
        
        CGRect rect = CGRectMake(self.bounds.size.width-65,25, 60, 60);
        self.imageView.frame = rect;
        rect = CGRectMake(5, 4, 240, 70);
        labelView.frame = rect;
        labelView.textAlignment = UITextAlignmentRight;
        rect.origin.y = rect.origin.y+ 70;
        rect.size.height = 20;
        detailLableView.frame = rect;
        detailLableView.textAlignment= NSTextAlignmentRight;
    }
    
    self.imageView.layer.borderWidth = 4.0;
    self.imageView.layer.borderColor = UIColorFromRGB(0x3A2E23).CGColor;
    self.imageView.layer.cornerRadius =30;
    self.imageView.clipsToBounds=YES;
    self.imageView.layer.shouldRasterize=YES;
    
}


-(void)setQuestion:(PFObject *)aQuestion atIndex:(NSInteger)cellIndex{
    if (aQuestion != questionObject) {
        questionObject = aQuestion;
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
   
    NSString *key = [Helper isRightToLeft]? @"question":@"question_en";
    NSString *title = questionObject[key];
    NSString *subtitle = questionObject[@"user_name"];

    self.labelView.text = title;
    self.detailLableView.text =subtitle;

    [self setNeedsDisplay];
}


@end
