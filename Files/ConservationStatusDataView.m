//
//  ConservationStatusDataView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 6/25/13.
//
//

#import "ConservationStatusDataView.h"
#import "ConservationCircleImage.h"

#define NUMBER_OF_STATUSES 7
@interface ConservationStatusDataView()
    @property (nonatomic, strong) UILabel*label;
@end

@implementation ConservationStatusDataView

- (id)initWithFrame:(CGRect)frame withConservationStatus:(NSString*)status
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf8eddf);
        CGFloat diameter = CGRectGetWidth(frame)/8;
        for (NSInteger i =0; i< NUMBER_OF_STATUSES; i++) {
            
            ConservationCircleImage *circle = [[ConservationCircleImage alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)/7)*i+2,10, diameter, diameter) withConservationStatus:i];
            [self addSubview:circle];
            
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, diameter + 16, CGRectGetWidth(frame), 20)];
            if ([self conservationStatusFromAnimalConservationType:status]!=-1) {
                self.label.backgroundColor = [self colorForConservationStatus:[self conservationStatusFromAnimalConservationType:status]];
            }
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.textColor = [UIColor whiteColor];
            self.label.text = NSLocalizedStringFromTableInBundle(status, nil, [Helper localizationBundle], nil);
            [self addSubview:self.label];
        }
    }
    return self;
}

- (ConservationStatus)conservationStatusFromAnimalConservationType:(NSString*)status
{
    NSArray *statuses = @[@"EX",@"EW",@"CR",@"EN",@"VU",@"NT",@"LC"];
    if([statuses containsObject:status])
    {
     return  [statuses indexOfObject:status];
    }else{
      return -1;
    }
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
