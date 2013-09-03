//
//  WIOSSoundRecorderCell.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "WIOSSoundRecorderViewController.h"

#define  AUDIOMONITOR_THRESHOLD

@interface WIOSSoundRecorderViewController(){
    AVAudioRecorder *_recorder;
    AVAudioPlayer   *_player;
    NSURL *_fileURL;
}
@end

@implementation WIOSSoundRecorderViewController

@synthesize isPlaying = _isPlaying;
@synthesize isRecording = _isRecording;
@synthesize isPaused = _isPaused;


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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    //
}

#pragma mark - states


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


- (void) _updateState{
    if(self.isPlaying){
        
    }else if(self.isRecording){
        
    }
    if(self.isRecording || self.isPlaying){
        [self.stopButton setEnabled:YES];
    }else{
        [self.stopButton setEnabled:NO];
    }
}


- (IBAction)action:(id)sender {
    if(!_sound){
        [wtmAPI raiseExceptionWithFormat:@"WIOSSoundRecorderViewController sound reference is not set"];
    }else{
        if ([sender  isEqual:self.recordButton]) {
            if(_isRecording){
                [self _stopRecording];
            }else{
                [self _record];
            }
        }else if([sender  isEqual:self.stopButton]){
            if(_isRecording){
                [self _stopRecording];
            }
            if(_isPlaying){
                [self _stopPlaying];
            }
        }else if([sender  isEqual:self.playButton]){
            
        }
    }
}

#pragma mark -

- (NSURL*)_soundFileUrl{
    if(!_fileURL){
        if(!self.sound.relativePath){
            self.sound.relativePath=[NSString stringWithFormat:@"%@/%@/%i.caf",_sound.library.package.name,_sound.library.name,_sound.uinstID];
        }
        _fileURL = [NSURL fileURLWithPath:[wtmAPI absolutePathFromRelativePath:self.sound.relativePath] ];
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

#pragma mark - Sound


- (void) _setUpAudioSession {
    NSError *error=nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
}

-(void) _record{
    
    NSError *error=nil;
    _recorder = [[ AVAudioRecorder alloc] initWithURL:[self _soundFileUrl] settings:[self _soundSettingsDictionary] error:&error];
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
    [_recorder record];
}


- (void) _stopRecording{
    [self setIsRecording:NO];
}

- (void) _stopPlaying{
    [self setIsPlaying:NO];
}

- (void) _pauseRecording{
    [self setIsPaused:YES];
    [_recorder pause];
}

- (void) _pausePlaying{
    [self setIsPaused:YES];
    [_player pause];
}


@end
