
#import "AnimalDataTableViewCell.h"
#import "Animal.h"

//#import "AnimalIndicatorView.h"
//#import "Jerusalem_Biblical_ZooAppDelegate.h"

#define  kLabelText 0
#define  kDetailedLabelText 1

@implementation AnimalDataTableViewCell

@synthesize data;
@synthesize labelView;
@synthesize detailLableView;
@synthesize conservationIcon;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
		data = nil;
		labelView = nil;
		
		UIFont *font =  [UIFont fontWithName:@"Futura" size:17];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
        label.textColor = [UIColor brownColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=1;
		labelView = label;
		[self.contentView addSubview:labelView];
		
		font =  [UIFont fontWithName:@"Futura" size:16];
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = font;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentLeft;
		label.numberOfLines=0;
        label.textColor = UIColorFromRGB(0x281502);
		detailLableView = label;
		[self.contentView addSubview:detailLableView];
		
	
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.conservationIcon = tempImageView;
        [self.contentView addSubview:self.conservationIcon];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGFloat dashArray[] = {2,2,2,2};
    CGContextSetLineDash(context, 3, dashArray, 4);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);    
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if ([Helper appLang] == kEnglish) {
        self.labelView.frame =         CGRectMake(10,6,CGRectGetWidth(self.frame)-10,CGRectGetHeight(self.frame)/4);
        self.detailLableView.frame =   CGRectMake(10,CGRectGetMaxY(self.labelView.frame),CGRectGetWidth(self.frame)-10,CGRectGetHeight(self.labelView.frame)*3);;
    }else{
        self.labelView.textAlignment = self.detailLableView.textAlignment =NSTextAlignmentRight;
        UIFont *font =  [UIFont fontWithName:@"ArialHebrew-Bold" size:14];
        self.labelView.font = font;
        font =  [UIFont fontWithName:@"ArialHebrew" size:16];
        self.detailLableView.font = font;
        self.labelView.frame =         CGRectMake(0,6,CGRectGetWidth(self.frame)-10,CGRectGetHeight(self.frame)/4);
        self.detailLableView.frame =   CGRectMake(0,CGRectGetMaxY(self.labelView.frame),CGRectGetWidth(self.frame)-10,CGRectGetHeight(self.labelView.frame)*3);;
    }
}




- (void)setAnimal:(NSArray *)aDataArray conservationAbviration:(NSString*)abviration atIndex:(NSInteger)cellIndex{
	if (aDataArray != data) {
		data = aDataArray;
	}
    
    NSString *label;
    NSString *content;
	
    if (![data count]) {
        label = @"data empty";
        content = @"data empty";
    }else{
        label = data[kLabelText];
        content = data[kDetailedLabelText];
    }
    
    self.labelView.text = label;
    self.detailLableView.text = content;
       
    if ([label isEqualToString:@"Conservation Status"]||[label isEqualToString:@"מצב שימור"]) {
        
        UIImage *consevertionImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",abviration]];
        self.conservationIcon.image = consevertionImage;
        
        if([Helper appLang] == kEnglish){
           self.conservationIcon.frame = CGRectMake(180,5,[consevertionImage size].width, [consevertionImage size].height);
        }else{
           self.conservationIcon.frame = CGRectMake(10,5,[consevertionImage size].width, [consevertionImage size].height);
        }
    }
    [self.conservationIcon setNeedsDisplay];
	[labelView setNeedsDisplay];
    [detailLableView setNeedsDisplay];
}

@end




