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

@interface AnimalViewToolbar : UIToolbar

- (id)initWithFrame:(CGRect)frame withAudioGuide:(BOOL)hasAudioGuide withDisTributaionMap:(BOOL)hasMap withZooDescription:(BOOL)hasZooDescription isGeneralExhibitDescription:(BOOL)isGeneralExhibitDescription;
@property (nonatomic,weak) id<AnimalViewToolbarDelegate> delegate;

@end
