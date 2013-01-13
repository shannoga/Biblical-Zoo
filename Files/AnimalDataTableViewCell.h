

#import <UIKit/UIKit.h>

@class Animal;


@interface AnimalDataTableViewCell : UITableViewCell {
	NSArray *data;
	UILabel *labelView;
	UILabel *detailLableView;
	UIImageView *cellImageView;
}
 
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UILabel *labelView;
@property (nonatomic,strong) UILabel *detailLableView;
@property (nonatomic,strong)UIImageView *conservationIcon;
- (void)setAnimal:(NSArray *)aDataArray conservationAbviration:(NSString*)abviration atIndex:(NSInteger)cellIndex;
@end
