//
//  EventTableViewCell.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/28/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import "EventTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"
#define D_DAY	86400
#define D_WEEK	604800
#define D_MONTH 2419200

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
		
		
        UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=1;
        label.textColor = [UIColor blackColor];
		labelView = label;
		[self.contentView addSubview:labelView];

		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		font =  [UIFont fontWithName:@"Futura" size:14];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=2;
        label.textColor = [UIColor blackColor];
		detailLableView = label;
		[self.contentView addSubview:detailLableView];
		
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        font =  [UIFont fontWithName:@"Futura" size:14];
		label.font = font;
		label.backgroundColor = UIColorFromRGBA(0x00000, .1);
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		label.numberOfLines=4;
		timeLableView = label;
		[self.contentView addSubview:timeLableView];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        font =  [UIFont fontWithName:@"Futura" size:12];
		label.font = font;
		label.backgroundColor = UIColorFromRGBA(0x00000, .1);
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
    if ([[Helper currentLang] isEqualToString:@"en"]){
        self.cellImageView.frame =     CGRectMake(0, 15, 40,40);
        self.detailLableView.textAlignment = self.labelView.textAlignment = UITextAlignmentLeft;
        self.labelView.frame =         CGRectMake(self.cellImageView.frame.size.width+5,0,190,25);
        self.detailLableView.frame =   CGRectMake(self.cellImageView.frame.size.width+5,25,190,45);;
        self.timeLableView.frame =     CGRectMake(CGRectGetWidth(self.bounds)-80,0,80,25);
        self.locationLableView.frame = CGRectMake(CGRectGetWidth(self.bounds)-80,25,80,45);
    }else{
        self.detailLableView.textAlignment = self.labelView.textAlignment = UITextAlignmentRight;
        self.cellImageView.frame = CGRectMake(CGRectGetWidth(self.bounds)-50, 15, 50,50);
        self.labelView.frame =         CGRectMake(CGRectGetWidth(self.bounds)-210,0,160,25);
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
    
    NSString * title = NSLocalizedString(event.typeString,nil);
    
    self.labelView.text = title;
    self.detailLableView.text = [event title];
    self.locationLableView.text = [event location];
    self.timeLableView.text =[event timeAsString];
    

    UIImage *cellImage= [event icon];
   
	[self.cellImageView setImage:cellImage];
    
    // Set the colors for the gradient layer.
    CAGradientLayer *gradientLayer_ = (CAGradientLayer *)self.layer;
    [gradientLayer_ setContentsScale:[[UIScreen mainScreen] scale]];
    NSArray *cellColors = [event colors];
    gradientLayer_.colors =@[cellColors[0],
                            cellColors[1]];
	

	[labelView setNeedsDisplay];
    [detailLableView setNeedsDisplay];
    [locationLableView setNeedsDisplay];
    [timeLableView setNeedsDisplay];
    [cellImageView setNeedsDisplay];
    [self setNeedsDisplay];
}




@end
