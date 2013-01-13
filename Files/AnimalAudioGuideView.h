//
//  AnimalAudioGuideView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Animal.h"
@interface AnimalAudioGuideView : UIView <AVAudioPlayerDelegate,AVAudioSessionDelegate>{
    UILabel *label;
    BOOL shouldResume;
    __unsafe_unretained Animal *animal;
    NSTimer *sliderTimer;
}
 @property (nonatomic,assign) Animal *animal;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) UISlider *progressSlider;
@property (nonatomic,strong) UIButton *playButton;
-(void)play;
-(void)pause;
-(void)stop;
-(void)togglePlayPause;
- (id)initWithFrame:(CGRect)frame withAniaml:(Animal*)anAnimal;
@end
