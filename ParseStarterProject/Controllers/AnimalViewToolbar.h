//
//  AnimalViewToolbar.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/3/12.
//
//

#import <UIKit/UIKit.h>

@protocol AnimalViewToolbarDelegate <NSObject>
    -(void)userTappedOnbuttonWithIndex:(NSUInteger)index;
@end

@interface AnimalViewToolbar : UIToolbar{
    __unsafe_unretained id<AnimalViewToolbarDelegate> delegate;
}
- (id)initWithFrame:(CGRect)frame withAudioGuide:(BOOL)hasAudioGuide withDisTributaionMap:(BOOL)hasMap withZooDescription:(BOOL)hasZooDescription isGeneralExhibitDescription:(BOOL)isGeneralExhibitDescription;
@property (nonatomic,assign) id<AnimalViewToolbarDelegate> delegate;

@end
