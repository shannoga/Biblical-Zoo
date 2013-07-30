//
//  ConservationCircleImage.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 6/25/13.
//
//

#import "ConservationCircleImage.h"
#import <QuartzCore/QuartzCore.h>
@implementation ConservationCircleImage

- (id)initWithFrame:(CGRect)frame withConservationStatus:(ConservationStatus)status
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetHeight(frame)/2;
        self.backgroundColor = [self colorForConservationStatus:status];
        self.layer.borderColor = UIColorFromRGB(0xF8EDDF).CGColor;
        self.layer.borderWidth = 1;
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.backgroundColor =  [UIColor clearColor];
        textLabel.textColor = [self textColorForConservationStatus:status];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = [self textForConservationStatus:status];
        [self addSubview:textLabel];
        
        
        
    }
    return self;
}

- (UIColor*)colorForConservationStatus:(ConservationStatus)status
{
    switch (status) {
        case ConLC:
             return UIColorFromRGB(0x06968);
            break;
        case ConNT:
            return UIColorFromRGB(0x06968);
            break;
        case ConVU:
            return UIColorFromRGB(0xD59A00);
            break;
        case ConEN:
            return UIColorFromRGB(0xDC5D02);
            break;
        case ConCR:
            return UIColorFromRGB(0xDF0012);
            break;
        case ConEW:
            return [UIColor blackColor];
            break;
        case ConEX:
            return [UIColor blackColor];
            break;
            
        default:
            break;
    }

}

- (UIColor*)textColorForConservationStatus:(ConservationStatus)status
{
    switch (status) {
        case ConLC:
            return [UIColor whiteColor];
            break;
        case ConNT:
            return UIColorFromRGB(0x87D295);
            break;
        case ConVU:
            return [UIColor whiteColor];
            break;
        case ConEN:
            return [UIColor whiteColor];
            break;
        case ConCR:
            return [UIColor whiteColor];
            break;
        case ConEW:
            return [UIColor whiteColor];
            break;
        case ConEX:
            return UIColorFromRGB(0xDF0012);
            break;
            
        default:
            break;
    }
    
}

- (NSString*)textForConservationStatus:(ConservationStatus)status
{
    switch (status) {
        case ConLC:
            return @"LC";
            break;
        case ConNT:
            return @"NT";
            break;
        case ConVU:
            return @"VU";
            break;
        case ConEN:
            return @"EN";
            break;
        case ConCR:
            return @"CR";
            break;
        case ConEW:
            return @"EW";
            break;
        case ConEX:
            return @"EX";
            break;
    }
    
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
