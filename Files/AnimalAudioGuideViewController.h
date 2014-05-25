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
@interface AnimalAudioGuideViewController : UIViewController <AVAudioPlayerDelegate,AVAudioSessionDelegate>
@property (nonatomic) BOOL shouldResume;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSTimer *sliderTimer;
@property (nonatomic,strong) Animal *animal;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,weak) IBOutlet UISlider *progressSlider;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *pouseButton;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *stopButton;
-(void)play;
-(void)pause;
-(void)stop;
-(void)togglePlayPause;
- (id)initWithAniaml:(Animal*)anAnimal;
@end
