//
//  WIOSSoundRecorderCell.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "WIOSSoundRecorderViewController.h"

//#import <AVFoundation/AVAudioSettings.h>

#define  AUDIOMONITOR_THRESHOLD

@interface WIOSSoundRecorderViewController(){
    AVAudioRecorder *_recorder;
    AVAudioPlayer   *_player;
    NSURL          *_fileURL;
    
    NSTimer *_timer;
}
@end

@implementation WIOSSoundRecorderViewController

@synthesize isPlaying = _isPlaying;
@synthesize isRecording = _isRecording;
@synthesize isPaused = _isPaused;
@synthesize sound = _sound;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self _setUpAudioSession];
    [self _setUpInitialState];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.nameTextField setText:self.sound.name];
    [self.progressSlider setContinuous:YES];
    [self.progressSlider setMinimumValue:0.f];
    [self.progressSlider setMaximumValue:1.f];
    
    [self.originLabel setText:@"0"];
    [self.progressSlider setAlpha:1.f];
    [self.originLabel setAlpha:1.f];
    [self.endLabel setAlpha:1.f];

}


- (void)setSound:(WTMSound *)sound{
    _sound=sound;
    _sound.registry.autosave=NO;
}

- (WTMSound*)sound{
    return _sound;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _stopRecording];
    [self _stopPlaying];
    
    if (![self.nameTextField.text isEqualToString:self.sound.name]) {
        self.sound.name=self.nameTextField.text;
        self.sound.registry.hasChanged=YES;
    }
    _sound.registry.autosave=YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    //
}

#pragma mark - progress monitoring


#pragma mark - states

- (void) _setUpInitialState {
    [self setIsPlaying:NO];
    [self setIsRecording:NO];
    [self setIsPaused:NO];
}


- (void)setIsPlaying:(BOOL)isPlaying{
    if(_isRecording && isPlaying==YES){
        self.isRecording=NO;
    }
    _isPlaying=isPlaying;
    [self _updateState];
}

- (BOOL)isPlaying{
    return _isPlaying;
}


- (void)setIsRecording:(BOOL)isRecording{
    if(_isPlaying && isRecording==YES){
        self.isPlaying=NO;
    }
    _isRecording=isRecording;
    [self _updateState];
}

- (BOOL)isRecording{
    return _isRecording;
}

- (void)setIsPaused:(BOOL)isPaused{
    _isPaused=isPaused;
    [self _updateState];
}

- (BOOL)isPaused{
    return _isPaused;
}


/**
 *  Update the views states
 */
- (void) _updateState{
    if(_isPlaying){
        if(self.progressSlider.alpha==0.f){
            [self.originLabel setText:@"0"];
            [self.progressSlider setAlpha:1.f];
            [self.originLabel setAlpha:1.f];
            [self.endLabel setAlpha:1.f];
        }
    }else{
        if(self.progressSlider.alpha==1.f && _isRecording){
            [self.progressSlider setAlpha:0.f];
            [self.originLabel setAlpha:0.f];
            [self.endLabel setAlpha:0.f];
        }
    }
    
    if(self.isRecording){
        if(!self.stopButton.enabled){
            [self.stopButton setEnabled:YES];
            [self.activityIndicator startAnimating];
            [self.activityIndicator setAlpha:1.f];
        }
    }else{
        if(self.stopButton.enabled && _isPlaying){
            [self.stopButton setEnabled:NO];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setAlpha:0.f];
        }
    }
    
    if(self.isRecording && !self.isPaused){
        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
    }else{
        [self.recordButton setTitle:@"Rec" forState:UIControlStateNormal];
    }
    
    if(self.isPlaying && !self.isPaused){
        [self.playButton  setTitle:@"Pause" forState:UIControlStateNormal];
    }else{
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    
    
}

/**
 *  Handle all the button actions
 *
 *  @param sender a button.
 */
- (IBAction)action:(id)sender {
    if(!_sound){
        [wtmAPI raiseExceptionWithFormat:@"WIOSSoundRecorderViewController sound reference is not set"];
    }else{
        if ([sender  isEqual:self.recordButton]) {
            if(_isPlaying){
                [self _stopPlaying];
            }
            if(_isRecording && !_isPaused){
                [self _pauseRecording];
            }else{
                [self _record];
            }
        }else if([sender  isEqual:self.playButton]){
            if(_isRecording){
                [self _stopRecording];
            }
            if(_isPlaying && !_isPaused){
                [self _pausePlaying];
            }else{
                [self _play];
            }
        }else if([sender  isEqual:self.stopButton]){
            [self _stop];
        }
    }
}

#pragma mark - Sound Management

- (NSURL*)_soundFileUrl{
    if(!_fileURL){
        if(!self.sound.relativePath){
            self.sound.relativePath=[NSString stringWithFormat:@"%@/%@/%i.caf",_sound.library.package.objectName,_sound.library.objectName,_sound.uinstID];
        }
        NSString *path=[[wtmAPI absolutePathForRegistryBundleWithName:wtmAPI.currentRegistry.name] stringByAppendingString:self.sound.relativePath];
        [wtmAPI createRecursivelyRequiredFolderForPath:path];
        _fileURL = [NSURL fileURLWithPath:path ];
    }
    return _fileURL;
}

- (NSMutableDictionary*)_soundSettingsDictionary{
    NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
    [settings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    return settings;
}




- (void) _setUpAudioSession {
    NSError *error=nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
}

-(void) _record{
    if(self.isRecording && self.isPaused){
        [_recorder record];
    }else{
        NSError *error=nil;
        _recorder = [[ AVAudioRecorder alloc] initWithURL:[self _soundFileUrl] settings:[self _soundSettingsDictionary] error:&error];
        [_recorder setDelegate:self];
        [_recorder prepareToRecord];
        [_recorder record];
    }
    _isPaused=NO;
    [self setIsRecording:YES];
    
}

- (void) _play{
    NSError *error=nil;
    if(!_isPlaying){
        _player=[[AVAudioPlayer alloc] initWithContentsOfURL:[self _soundFileUrl] error:&error];
        [_player setDelegate:self];
        if([self _proceedError:error withTitle:NSLocalizedString(@"Audio player initialization error", @"")]){
            if(self.sound.duration!=_player.duration){
                self.sound.duration=_player.duration;

            }
            _timer=[NSTimer scheduledTimerWithTimeInterval:0.02
                                                    target:self
                                                  selector:@selector(_playingTimer:)
                                                  userInfo:nil
                                                   repeats:YES];
            [self.endLabel setText:[NSString stringWithFormat:@"%f",_player.duration]];
        }
    }
    [self setIsPlaying:[_player play]];
    _isPaused=NO;
    [self setIsPlaying:YES];
}


-(void)_playingTimer:(NSTimer*)timer {
    float total=_player.duration;
    float f=_player.currentTime / total;
    //NSString *str = [NSString stringWithFormat:@"%f", f];
    [self.progressSlider setValue:f];
}

- (void)_purgeTimer{
    [_timer invalidate];
    _timer=nil;
}

- (void)_stop {
    [self _stopRecording];
    [self _stopPlaying];
}

- (void) _stopRecording{
    [_recorder stop];
    [self _purgeTimer];
}

- (void) _pauseRecording{
    [self setIsPaused:YES];
    [_recorder pause];
}

- (void) _stopPlaying{
    [_player stop];
    [self _purgeTimer];
}

- (void) _pausePlaying{
    [self setIsPaused:YES];
    [_player pause];
}

- (BOOL) _proceedError:(NSError*)error withTitle:(NSString*)title{
    if(error){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                      message:[error localizedDescription]
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles: nil];
        [alert show];
        return NO;
    };
    return YES;
}

#pragma mark - AVAudioPlayerDelegate

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _isPaused=NO;
    [self setIsPlaying:NO];
    [self _purgeTimer];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
}


#pragma mark - AVAudioRecorderDelegate

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    _isPaused=NO;
    [self setIsRecording:NO];
    [self _purgeTimer];
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    
}


/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    
}


@end
