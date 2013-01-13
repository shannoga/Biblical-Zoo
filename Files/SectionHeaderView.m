

#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"
#import "Madad.h"

@implementation SectionHeaderView
@synthesize dateLabelView;
@synthesize morning, afterNone;
@synthesize morningTitle,afterNoneTitle;



+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

-(UIColor*)colorForMadad:(MadadVal)madadval{
    
    switch (madadval) {
        case kMadadCalm:
            return UIColorFromRGB(0x6db472);
            break;
        case kMadadFlowing:
            return UIColorFromRGB(0xffd71c);
            break;
        case kMadadLively:
            return UIColorFromRGB(0xff8400);
            break;
        case kMadadBusy:
            return UIColorFromRGB(0xff2c1d);
            break;
        case kMadadNone:
            return [UIColor clearColor];
            break;
    }
       return [UIColor clearColor];
}

-(UIColor*)textColorForTitles:(MadadVal)madadval{
    
    if (madadval == kMadadNone) {
         return [UIColor clearColor];
    }
    return [UIColor whiteColor];
}
-(NSString*)textForMadad:(MadadVal)madadval{
    
    switch (madadval) {
        case kMadadCalm:
            return NSLocalizedString(@"Calm",nil);
            break;
        case kMadadFlowing:
            return NSLocalizedString(@"Flowing",nil);
            break;
        case kMadadLively:
            return NSLocalizedString(@"Lively",nil);
            break;
        case kMadadBusy:
            return NSLocalizedString(@"Busy",nil);
            break;
            case kMadadNone:
             return @"";
            break;
    }
       return @"";
}



-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = UIColorFromRGB(0x3A2E23);
		
        
		self.dateLabelView = nil;
		
        UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
		self.dateLabelView = label;
		[self addSubview:dateLabelView];
        
        font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:12]; 
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.textAlignment = UITextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
		self.afterNone = label;
		[self addSubview:afterNone];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.textAlignment = UITextAlignmentCenter;
        label.textColor =[UIColor whiteColor];
		self.morning = label;
		[self addSubview:morning];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor =[UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		self.morningTitle = label;
        self.morningTitle.text = NSLocalizedString(@"A.M", nil);
		[self addSubview:self.morningTitle];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor =[UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		self.afterNoneTitle = label;
        self.afterNoneTitle.text = NSLocalizedString(@"P.M", nil);
		[self addSubview:self.afterNoneTitle];
        
    }
    
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    UIFont *font = [Helper isRightToLeft]? [UIFont fontWithName:@"ArialHebrew-Bold" size:16] :[UIFont fontWithName:@"Futura" size:14] ;
    self.dateLabelView.font = font;
	self.dateLabelView.textAlignment = [Helper isRightToLeft]? UITextAlignmentRight : UITextAlignmentLeft;
    self.dateLabelView.frame = CGRectMake([Helper isRightToLeft]? 110 : 6 ,0,200,CGRectGetHeight(self.frame));
    
    self.morning.text = [self textForMadad:amVal];
    self.morning.backgroundColor =[self colorForMadad:amVal];
    self.morningTitle.textColor = [self textColorForTitles:amVal];
    
    self.afterNone.text = [self textForMadad:pmVal];
    self.afterNone.backgroundColor =[self colorForMadad:pmVal];
    self.afterNoneTitle.textColor = [self textColorForTitles:pmVal];
    
    CGFloat height = CGRectGetHeight(self.frame)-20;
    if([Helper isRightToLeft]){
        self.afterNone.frame = CGRectMake( 0 ,20,60,height);
         self.afterNoneTitle.frame = CGRectMake( 0 ,0,60,height);
        
        self.morning.frame = CGRectMake(60 ,20,60,height);
         self.morningTitle.frame = CGRectMake(60 ,0,60,height);
    }else{
        self.morning.frame = CGRectMake(200 ,20,60,height);
          self.afterNoneTitle.frame = CGRectMake( 200 ,0,60,height);
        self.afterNone.frame = CGRectMake(260 ,20,60,height);
           self.morningTitle.frame = CGRectMake(260 ,0,60,height);
    }
    
}

-(void)setaMadad:(Madad*)aMadad{
    if (aMadad != nil) {
        amVal = [aMadad.am intValue];
        pmVal = [aMadad.pm intValue];
    }else{
        amVal = kMadadNone;
        pmVal = kMadadNone;
    }
    
  //  NSLog(@"amVal = %i, pmVal = %i",amVal,pmVal);
    
    [self.afterNone setNeedsDisplay];
    [self.morning setNeedsDisplay];
    [self setNeedsDisplay];
   
}




@end
