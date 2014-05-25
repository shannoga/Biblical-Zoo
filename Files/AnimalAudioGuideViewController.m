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

- (void)awakeFromNib
{
    self.shouldResume=NO;
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)initializePlayer{
    NSString *fileName = [NSString stringWithFormat:@"%@_%@",self.animal.nameEn,[Helper appLang]==kHebrew?@"he":@"en"];
    fileName = [[fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];//[path stringByAppendingPathComponent:@"lion.m4a"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        
        NSError *error;
        self.player  = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
        [self.player setNumberOfLoops:0];
        self.label.text = @"Loading";
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            self.label.text = @"Eroor loading audio file";
        } else {
            
            //Make sure the system follows our playback status
           
            //Load the audio into memory
            self.label.text = @"Ready";
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
        self.shouldResume=NO;
        self.view.backgroundColor = [UIColor clearColor];


    }
    return self;
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stop:nil];
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
-(IBAction)play:(id)sender{
    if (self.player==nil) {
        [self initializePlayer];
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[AVAudioSession sharedInstance] setDelegate:self];
    [self.player prepareToPlay];

    [self.player play];
    self.player.delegate = self;
    
     self.label.text = @"Playing";
    self.playButton.enabled = NO;
//    [self.playButton.layer addAnimation:[Animations pulseAnimation:1.05] forKey:@"pulse"];
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.progressSlider.maximumValue = self.player.duration;
}

- (void)updateSlider {
	// Update the slider about the music time
	self.progressSlider.value = self.player.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
	[self.player stop];
	[self.player setCurrentTime:self.progressSlider.value];
	[self.player prepareToPlay];
	[self play:sender];
}

-(IBAction)pause:(id)sender{
    [self.player pause];
    self.playButton.enabled = YES;

   // [self.playButton.layer removeAllAnimations];
    self.label.text = @"Paused";
}
-(IBAction)stop:(id)sender{
    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    [[AVAudioSession sharedInstance] setDelegate:nil];
    [self.player stop];
    [self.player setCurrentTime:0];
    self.playButton.enabled = YES;

   // [self.playButton.layer removeAllAnimations];
    self.label.text = @"Ready";
}

-(void)btnPressed:(UIButton*)sender{
    switch (sender.tag) {
        case kPlay:
            [self play:sender];
            break;
            
        case kStop:
            [self stop:sender];
            break;
            
        case kPause:
            [self pause:sender];
            break;
    }
}


// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[self.sliderTimer invalidate];
        self.playButton.enabled = YES;

      //  [self.playButton.layer removeAllAnimations];

	}

}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)audioPlayer;
{
    if ([self.player isPlaying]) {
        [self pause:nil];
        self.shouldResume = YES;
    }else{
        self.shouldResume = NO;
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)audioPlayer;
{
    if(self.shouldResume) [self play:nil];
}


- (void)endInterruptionWithFlags:(NSUInteger)flags{
    if(self.shouldResume) [self play:nil];
}
-(void)beginInterruption{
    if ([self.player isPlaying]) {
        [self pause:nil];
        self.shouldResume = YES;
    }else{
        self.shouldResume = NO;
    }
      
}




@end
