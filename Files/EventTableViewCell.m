//
//  EventTableViewCell.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import "EventTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#define D_DAY	86400
#define D_WEEK	604800

@implementation EventTableViewCell
@synthesize event;
@synthesize labelView;
@synthesize detailLableView;;
@synthesize timeLableView;
@synthesize cellImageView;
@synthesize locationBtnLayer;
@synthesize locationLableView;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        
		labelView = nil;
		
		
        UIFont *font =  [UIFont fontWithName:@"Avenir-Heavy" size:18];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=1;
        label.textColor = [UIColor blackColor];
		labelView = label;
		[self.contentView addSubview:labelView];

		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		font =  [UIFont fontWithName:@"Avenir-Book" size:14];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=2;
        label.textColor = [UIColor blackColor];
		detailLableView = label;
		[self.contentView addSubview:detailLableView];
		
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        font =  [UIFont fontWithName:@"Avenir-Book" size:14];
		label.font = font;
		label.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		label.numberOfLines=4;
		timeLableView = label;
		[self.contentView addSubview:timeLableView];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        font =  [UIFont fontWithName:@"Avenir-Book" size:12];
		label.font = font;
		label.backgroundColor =  [UIColor colorWithWhite:0 alpha:.1];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		label.numberOfLines=2;
		locationLableView = label;
		[self.contentView addSubview:locationLableView];
		
		
		UIImageView *img = [[UIImageView alloc] init];
       
		self.cellImageView=img;
		[self.contentView addSubview:cellImageView];
        
        CAShapeLayer * tempLayer = [[CAShapeLayer alloc] init];
        self.locationBtnLayer = tempLayer;
        self.locationBtnLayer.bounds =CGRectZero;
        [self.contentView.layer addSublayer: self.locationBtnLayer];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 70);
  
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0.749 green:0.737 blue:0.631 alpha:1];
        [self setSelectedBackgroundView:bgView];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}
/*
- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
 
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);    
    CGContextStrokePath(context);
}
*/
- (void)layoutSubviews {
	[super layoutSubviews];
	
	//if () {
    if ([Helper appLang] == kEnglish){
        self.cellImageView.frame =     CGRectMake(0, 15, 40,40);
        self.detailLableView.textAlignment = self.labelView.textAlignment = NSTextAlignmentLeft;
        self.labelView.frame =         CGRectMake(self.cellImageView.frame.size.width+5,15,190,25);
        self.detailLableView.frame =   CGRectMake(self.cellImageView.frame.size.width+5,25,190,45);;
        self.timeLableView.frame =     CGRectMake(CGRectGetWidth(self.bounds)-80,0,80,25);
        self.locationLableView.frame = CGRectMake(CGRectGetWidth(self.bounds)-80,25,80,45);
    }else{
        self.detailLableView.textAlignment = self.labelView.textAlignment = NSTextAlignmentRight;
        self.cellImageView.frame = CGRectMake(CGRectGetWidth(self.bounds)-50, 15, 50,50);
        self.labelView.frame =         CGRectMake(CGRectGetWidth(self.bounds)-210,8,160,25);
        self.detailLableView.frame =   CGRectMake(CGRectGetWidth(self.bounds)-210,25,160,45);;
        self.timeLableView.frame =     CGRectMake(0,0,80,25);
        self.locationLableView.frame = CGRectMake(0,25,80,45);
    }
	 

    
    /*
    rect = self.contentView.frame;
    self.locationBtnLayer.frame = CGRectMake(0, 0, CGRectGetHeight(rect)*0.6,CGRectGetHeight(rect)*0.6);
    self.locationBtnLayer.position = CGPointMake(CGRectGetMaxX(rect)-CGRectGetWidth( self.locationBtnLayer.frame), self.center.y);
    self.locationBtnLayer.cornerRadius =CGRectGetHeight(rect)*0.6/2;
    self.locationBtnLayer.backgroundColor= [UIColor whiteColor].CGColor;
    
    
    CAShapeLayer * innerLyer = [[CAShapeLayer alloc] init];
    
    innerLyer.bounds =CGRectMake(0, 0, CGRectGetHeight(rect)*0.3,CGRectGetHeight(rect)*0.3);
    innerLyer.borderWidth=2.0;
    innerLyer.position = self.locationBtnLayer.position;
    innerLyer.borderColor = [UIColor brownColor].CGColor;
    innerLyer.cornerRadius =CGRectGetHeight(rect)*0.3/2;
   // innerLyer.backgroundColor= [UIColor redColor].CGColor;
    [self.locationBtnLayer addSublayer: innerLyer];

    [innerLyer release];	
    
    */
	
}




// the animal setter
// we implement this because the table cell values need
// to be updated when this property changes, and this allows
// for the changes to be encapsulated
- (void)setAnEvent:(Event *)anEvent{
	if (self.event != anEvent) {
		self.event = anEvent;
	}
	
   //get the localized title from the string
    
    NSString * title = [Helper languageSelectedStringForKey:event.typeString];
    self.labelView.text = title;
    self.detailLableView.text = [event title];
    self.locationLableView.text = [event location];
    self.timeLableView.text =[event timeAsString];
    

    UIImage *cellImage= [event icon];
   
	[self.cellImageView setImage:cellImage];
    switch ([event.type intValue]) {
        case kEventTypeFeeding:
            cellImageView.tintColor = [UIColor colorWithRed:0.243 green:0.435 blue:0.478 alpha:1];
            break;
        case kEventTypeTalk:
            cellImageView.tintColor = [UIColor colorWithRed:0.463 green:0.365 blue:0.322 alpha:1];
            break;
            
        default:
            cellImageView.tintColor = [UIColor colorWithRed:0.925 green:0.282 blue:0.090 alpha:1];

            break;
    }
    
    self.cellImageView.image = [self.cellImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];


	[labelView setNeedsDisplay];
    [detailLableView setNeedsDisplay];
    [locationLableView setNeedsDisplay];
    [timeLableView setNeedsDisplay];
    [cellImageView setNeedsDisplay];
    [self setNeedsDisplay];
}




@end
