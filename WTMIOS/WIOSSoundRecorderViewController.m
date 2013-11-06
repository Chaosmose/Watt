//
//  WIOSSoundRecorderCell.m
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 pereira-da-silva.com. All rights reserved.
//

#import "WIOSSoundRecorderViewController.h"

//#import <AVFoundation/AVAudioSettings.h>

#define  AUDIOMONITOR_THRESHOLD

@interface WIOSSoundRecorderViewController(){
    AVAudioRecorder *_recorder;
    AVAudioPlayer   *_player;
    NSURL          *_fileURL;
    
    NSTimer *_timer;
    NSBundle *_wiosBundle;
    float _soundDuration;
    WattRegistryFilesUtils *__utils;
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
}


- (void)setBundleName:(NSString *)bundleName{
    NSString*bundlePath=[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if(!bundlePath){
        [NSException raise:@"Missing bundle" format:@"%@",bundleName];
    }
    _wiosBundle=[NSBundle bundleWithPath:bundlePath];
}





- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_wiosBundle)
        [self setBundleName:@"wiosSound"];
    
    [self.stopButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"stop" ofType:@"png"]]forState:UIControlStateNormal];
    [self.nameTextField setText:self.sound.name];
    [self.progressSlider setContinuous:YES];
    [self.progressSlider setMinimumValue:0.f];
    [self.progressSlider setMaximumValue:1.f];
    
    [self.progressSlider addTarget:self
                            action:@selector(_sliderValueChanged:)
                forControlEvents:UIControlEventValueChanged];

    [self.originLabel setText:@"0"];
    [self.progressSlider setAlpha:1.f];
    [self.progressSlider setValue:0.f];
    [self.originLabel setAlpha:1.f];
    [self.endLabel setAlpha:1.f];
    [self.endLabel setText:@"0"];
    
    [self.recordingProgressLabel setAlpha:1.f];
    [self.recordingProgressLabel setText:@"0"];
    
    [self.activityIndicator setHidesWhenStopped:YES];
    [self _setUpInitialState];
}


- (void)setSound:(WTMSound *)sound{
    _sound=sound;
    _soundDuration=sound.duration;
    _sound.registry.autosave=NO;
}

- (WTMSound*)sound{
    return _sound;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _stop];
    if (![self.nameTextField.text isEqualToString:self.sound.name] || _soundDuration!=_sound.duration) {
        self.sound.name=self.nameTextField.text;
        self.sound.registry.hasChanged=YES;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    //
}

#pragma mark - progress monitoring


#pragma mark - states

- (void) _setUpInitialState {
    _isPlaying=NO;
    _isRecording=NO;
    _isPaused=NO;
    [self _initializePlayer];
    [self _updateState];
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

    BOOL isReset=(!_isPaused && !_isPlaying && ! _isRecording);
    if(isReset){
        BOOL soundExists=[self _soundExists];
        if(soundExists){
            [self _playButtonEnabled:YES];
            [self _recordButtonEnabled:YES];
        }else{
            [self _playButtonEnabled:NO];
            [self _recordButtonEnabled:YES];
        }
        [self _showActivityIndicator:!soundExists isAnimated:NO];
        [self _showSlider:soundExists];
        [self _stopButtonEnabled:NO];
    }else{
        [self _showSlider:_isPlaying];
        [self _showActivityIndicator:_isRecording isAnimated:!_isPaused];
        [self _playButtonEnabled:_isPlaying];
        [self _recordButtonEnabled:_isRecording];
    }
    
    BOOL isActive=(_isPlaying || _isRecording);
    [self _stopButtonEnabled:isActive];
}

- (void)_playButtonEnabled:(BOOL)enabled {
    [self.playButton setEnabled:enabled];
    [self.playButton setAlpha:enabled?1.f:0.3f];
    if(_isPlaying && !_isPaused){
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"pause" ofType:@"png"]]forState:UIControlStateNormal];
    }else{
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"play" ofType:@"png"]] forState:UIControlStateNormal];
    }
}


- (void)_recordButtonEnabled:(BOOL)enabled{
    [self.recordButton setEnabled:enabled];
    [self.recordButton setAlpha:enabled?1.f:0.3f];
    if(_isRecording  && !_isPaused){
        [self.recordButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"pause" ofType:@"png"]]forState:UIControlStateNormal];
    }else{
        [self.recordButton setImage:[UIImage imageWithContentsOfFile:[_wiosBundle pathForResource:@"record" ofType:@"png"]]forState:UIControlStateNormal];
    }
}


- (void)_stopButtonEnabled:(BOOL)enabled{
    [self.stopButton setEnabled:enabled];
    [self.stopButton setAlpha:enabled?1.f:0.3f];
    
}

- (void)_showSlider:(BOOL)show{
    [self.progressSlider setEnabled:show];
    [self.progressSlider setAlpha:show?1.f:0.f];
    [self.originLabel setAlpha:show?1.f:0.f];
    [self.endLabel setAlpha:show?1.f:0.f];
}

- (void)_showActivityIndicator:(BOOL)show isAnimated:(BOOL)animated{
    [self.activityIndicator setAlpha:show?1.f:0.f];
    if(animated && !self.activityIndicator.isAnimating)
        [self.activityIndicator startAnimating];
    if(!animated && self.activityIndicator.isAnimating)
        [self.activityIndicator stopAnimating];
    [self.recordingProgressLabel setAlpha:show?1.f:0.f];
}

- (BOOL)_soundExists{
    return [[NSFileManager defaultManager]fileExistsAtPath:[self _soundPath]];
}

- (void)_displaySoundDuration{
    [self.endLabel setText:[NSString stringWithFormat:@"%.01f s",_player.duration]];
}

- (void)_resetProgress{
    [self.progressSlider setValue:0];
    [self.originLabel setText:@"0"];
}

/**
 *  Handle all the button actions
 *
 *  @param sender a button.
 */
- (IBAction)action:(id)sender {
    if(!_sound){
        [self  raiseExceptionWithFormat:@"WIOSSoundRecorderViewController sound reference is not set"];
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
        NSString *path=[self _soundPath];
        [_sound.registry.pool createRecursivelyRequiredFolderForPath:path];
        _fileURL = [NSURL fileURLWithPath:path ];
    }
    return _fileURL;
}


- (NSString*)_soundPath{
    return  [_sound.registry.pool absolutePathFromRelativePath:self.sound.relativePath inBundleWithName:self.sound.registry.uidString];
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
        if([self _initializeRecorder]){
            _timer=[NSTimer scheduledTimerWithTimeInterval:0.02
                                                    target:self
                                                  selector:@selector(_recordingTimer:)
                                                  userInfo:nil
                                                   repeats:YES];
           
        }
    }
    _isPaused=NO;
    [self setIsRecording:[_recorder isRecording]];
    
}

- (void) _play{
    if(!_isPlaying){
        if([self _initializePlayer]){
            if(self.sound.duration!=_player.duration){
                self.sound.duration=_player.duration;
            }
            _timer=[NSTimer scheduledTimerWithTimeInterval:0.02
                                                    target:self
                                                  selector:@selector(_playingTimer:)
                                                  userInfo:nil
                                                   repeats:YES];
            
        }
    }
    _isPaused=NO;
    [self setIsPlaying:[_player play]];
}


-(void)_playingTimer:(NSTimer*)timer {
    float total=_player.duration;
    float f=_player.currentTime / total;
    [self.progressSlider setValue:f];
    [self.originLabel setText:[NSString stringWithFormat:@"%.01f",_player.currentTime]];
}

-(void)_recordingTimer:(NSTimer*)timer {
    if([_recorder isRecording]){
        [self.recordingProgressLabel setText:[NSString stringWithFormat:@"%.01f s",_recorder.currentTime]];
    }
}


-(void)_sliderValueChanged:(UISlider *)sender{
    NSLog(@"slider value = %f", sender.value);
    if(_player){
        [_player setCurrentTime:_player.duration*sender.value];
    }
}


- (void)_purgeTimer{
    [_timer invalidate];
    _timer=nil;
}

- (void)_stop {
    if(_isPlaying){
        [self _stopPlaying];
    }
    if(_isRecording){
        [self _stopRecording];
    }
}

- (void) _pausePlaying{
    [self setIsPaused:YES];
    [_player pause];
}


- (void) _pauseRecording{
    [self setIsPaused:YES];
    [_recorder pause];
}

- (void) _stopPlaying{
    _isPaused=NO;
    [self _purgePlayer];
    [self _purgeTimer];
    [self _resetProgress];
    [self setIsPlaying:NO];
}


- (void) _stopRecording{
    _isPaused=NO;
    [self _purgeRecorder];
    [self _purgeTimer];
    [self _resetProgress];
    [self setIsRecording:NO];
    [self _initializePlayer];// We reinitialize the player
}


- (BOOL)_proceedError:(NSError*)error withTitle:(NSString*)title{
    if(error){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                      message:[error localizedDescription]
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK choice in alerts")
                                            otherButtonTitles: nil];
        [alert show];
        return NO;
    };
    return YES;
}


- (BOOL)_initializePlayer{
    if(_player || ![self _soundExists]){
        return YES;
    }
    NSError *error=nil;
    _player=[[AVAudioPlayer alloc] initWithContentsOfURL:[self _soundFileUrl] error:&error];
    [_player setDelegate:self];
    [self _displaySoundDuration];
    BOOL success=[self _proceedError:error withTitle:NSLocalizedString(@"Audio player initialization error", @"Audio player initialization error message")];
    if(!success){
        [_player setDelegate:nil];
        _player=nil;
    }
    return success;
}

- (BOOL)_initializeRecorder{
    NSError *error=nil;
    _recorder = [[ AVAudioRecorder alloc] initWithURL:[self _soundFileUrl] settings:[self _soundSettingsDictionary] error:&error];
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
    [_recorder record];
    BOOL success=[self _proceedError:error withTitle:NSLocalizedString(@"Audio recorder initialization error", @"Audio recorder initialization error message")];
    if(!success){
        [_player setDelegate:nil];
        _player=nil;
    }
    return success;
}


- (void)_purgePlayer{
    [_player stop];
    _player.delegate=nil;
    _player=nil;
}

- (void)_purgeRecorder{
    _sound.duration=_recorder.currentTime;
    [_recorder stop];
    _recorder.delegate=nil;
    _recorder=nil;
}

#pragma mark - AVAudioPlayerDelegate

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self _stopPlaying];
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
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    
}

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    
}

@end
