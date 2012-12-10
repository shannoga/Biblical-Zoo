

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Madad.h"

typedef enum{
    kMadadNone,
    kMadadCalm,
    kMadadFlowing,
    kMadadLively,
    kMadadBusy
}MadadVal;


@interface SectionHeaderView : UIView {
    MadadVal amVal;
    MadadVal pmVal;
}
@property (nonatomic,strong) UILabel *dateLabelView;
@property (nonatomic,strong) UILabel *morning;
@property (nonatomic,strong) UILabel *afterNone;
@property (nonatomic,strong) UILabel *afterNoneTitle;
@property (nonatomic,strong) UILabel *morningTitle;


-(void)setaMadad:(Madad*)aMadad;
@end

