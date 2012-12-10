//
//  AnimalAudioGuideView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//
#import <AVFoundation/AVFoundation.h>
#import "AnimalAudioGuideView.h"
#define kPlay  0
#define kStop  1
#define kPause 2


@implementation AnimalAudioGuideView
@synthesize player;
@synthesize animal;

-(void)initializePlayer{
#warning set back to animal URL
   // NSString *component = [NSString stringWithFormat:@"%@_%@.m4a",animal.nameEn,[Helper currentLang]];
    NSString *path = [Helper audioGuideFilesPath];
    path = [path stringByAppendingPathComponent:@"audioGuideExample.m4a"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"path = %@",path);
    }else{
         NSLog(@"no file in path = %@",path);
    }
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
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[AVAudioSession sharedInstance] setDelegate:self];
        //Load the audio into memory
        [self.player prepareToPlay];
        label.text = @"Ready";
    }
}

- (id)initWithFrame:(CGRect)frame withAniaml:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animal = anAnimal;
        shouldResume=NO;
        self.backgroundColor = [UIColor clearColor];

        UIButton *btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(0, 0, 90, 90)];
        btn.backgroundColor = [UIColor redColor];
        btn.tag =kPlay;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        
        btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(0, 110, 40, 40)];
         btn.backgroundColor = [UIColor blueColor];
        btn.tag =kStop;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        
        btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(80, 110, 40, 40)];
         btn.backgroundColor = [UIColor yellowColor];
        btn.tag =kPause;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        
        UISlider *volSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 180, 280, 40)];
        volSlider.maximumValue =1;
        volSlider.minimumValue =0;
        volSlider.value = .5;
        [volSlider addTarget:self action:@selector(setVol:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:volSlider];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 100, 50)];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [self initializePlayer];
   
    }
    return self;
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
    [self.player play];
     label.text = @"Playing";
}
-(void)pause{
     [self.player stop];
    [self.player setCurrentTime:0];
    label.text = @"Paused";
}
-(void)stop{
    [self.player pause];
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


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)audioPlayer;
{
    if ([self.player isPlaying]) {
        [self.player pause];
        shouldResume = YES;
    }else{
        shouldResume = NO;
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)audioPlayer;
{
    if(shouldResume) [self.player play];
}


- (void)endInterruptionWithFlags:(NSUInteger)flags{
   if(shouldResume) [self.player play];
}
-(void)beginInterruption{
    if ([self.player isPlaying]) {
        [self.player pause];
        shouldResume = YES;
    }else{
        shouldResume = NO;
    }
      
}



@end
