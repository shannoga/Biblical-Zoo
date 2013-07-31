//
//  AnimalAudioGuideView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//
#import <AVFoundation/AVFoundation.h>
#import "AnimalAudioGuideViewController.h"
#import "Animations.h"
#define kPlay  0
#define kStop  1
#define kPause 2


@implementation AnimalAudioGuideViewController
@synthesize player;
@synthesize animal;
@synthesize progressSlider;
@synthesize playButton;

-(void)initializePlayer{
    NSString *fileName = [NSString stringWithFormat:@"%@_%@",animal.nameEn,[Helper appLang]==kHebrew?@"he":@"en"];
    fileName = [[fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];//[path stringByAppendingPathComponent:@"lion.m4a"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        
        NSError *error;
        self.player  = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        [self.player setNumberOfLoops:0];
        label.text = @"Loading";
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            label.text = @"Eroor loading audio file";
        } else {
            
            //Make sure the system follows our playback status
           
            //Load the audio into memory
            label.text = @"Ready";
        }
    }else{
         NSLog(@"no file in path = %@",path);
    }

}

- (id)initWithAniaml:(Animal*)anAnimal
{
    self = [super init];
    if (self) {
        self.animal = anAnimal;
        shouldResume=NO;
        self.view.backgroundColor = [UIColor clearColor];


    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(self.view.bounds.size.width/2-70, 30, 140, 140)];
    btn.backgroundColor = UIColorFromRGB(0xC95000);
    btn.layer.cornerRadius = btn.bounds.size.width/2;
    btn.tag =kPlay;
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton = btn;
    [self.view addSubview:self.playButton];
    
    UIImageView *playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play.png"]];
    playImage.frame = CGRectMake(35, 30, 80, 80);
    [self.playButton addSubview:playImage];
    
    btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(15, 70, 60, 60)];
    btn.backgroundColor = UIColorFromRGB(0x3B2F24);
    btn.layer.cornerRadius = btn.bounds.size.width/2;
    btn.tag =kStop;
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stop.png"]];
    playImage.frame = CGRectMake(15, 15, 30, 30);
    [btn addSubview:playImage];
    
    btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(245, 70, 60, 60)];
    btn.backgroundColor = UIColorFromRGB(0x3B2F24);
    btn.layer.cornerRadius = btn.bounds.size.width/2;
    btn.tag =kPause;
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pouse.png"]];
    playImage.frame = CGRectMake(15, 15, 30, 30);
    [btn addSubview:playImage];
    
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 180, 240, 40)];
    self.progressSlider.maximumValue =1;
    self.progressSlider.minimumValue =0;
    self.progressSlider.value = 0;
    self.progressSlider.thumbTintColor = UIColorFromRGB(0x48382E);
    self.progressSlider.minimumTrackTintColor = UIColorFromRGB(0xC95000);
    self.progressSlider.maximumTrackTintColor = UIColorFromRGB(0x3B2F24);
    [self.progressSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: self.progressSlider];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    label.font = [UIFont fontWithName:@"Futura" size:14];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x3B2F24);
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

-(void)setVol:(UISlider*)sender{
    self.player.volume = sender.value;
}

-(void)togglePlayPause{
    if([self.player isPlaying]){
        [self.player pause];
    }else{
        [self.player play];
    }
}
-(void)play{
    if (self.player==nil) {
        [self initializePlayer];
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[AVAudioSession sharedInstance] setDelegate:self];
    [self.player prepareToPlay];

    [self.player play];
    self.player.delegate = self;
    
     label.text = @"Playing";
    [self.playButton.layer addAnimation:[Animations pulseAnimation:1.05] forKey:@"pulse"];
    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.progressSlider.maximumValue = self.player.duration;
}

- (void)updateSlider {
	// Update the slider about the music time
	self.progressSlider.value = self.player.currentTime;
}

- (void)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
	[self.player stop];
	[self.player setCurrentTime:self.progressSlider.value];
	[self.player prepareToPlay];
	[self play];
}

-(void)pause{
    [self.player pause];
    [self.playButton.layer removeAllAnimations];
    label.text = @"Paused";
}
-(void)stop{
    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    [[AVAudioSession sharedInstance] setDelegate:nil];
    [self.player stop];
    [self.player setCurrentTime:0];
    [self.playButton.layer removeAllAnimations];
    label.text = @"Ready";
}

-(void)btnPressed:(UIButton*)sender{
    switch (sender.tag) {
        case kPlay:
             [self play];
            break;
            
        case kStop:
            [self stop];
            break;
            
        case kPause:
            [self pause];
            break;
    }
}


// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[sliderTimer invalidate];
        [self.playButton.layer removeAllAnimations];

	}

}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)audioPlayer;
{
    if ([self.player isPlaying]) {
        [self pause];
        shouldResume = YES;
    }else{
        shouldResume = NO;
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)audioPlayer;
{
    if(shouldResume) [self play];
}


- (void)endInterruptionWithFlags:(NSUInteger)flags{
   if(shouldResume) [self play];
}
-(void)beginInterruption{
    if ([self.player isPlaying]) {
        [self pause];
        shouldResume = YES;
    }else{
        shouldResume = NO;
    }
      
}




@end
