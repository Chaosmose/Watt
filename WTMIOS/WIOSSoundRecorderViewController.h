//
//  WIOSSoundRecorderCell.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "WTMSound.h"

@interface WIOSSoundRecorderViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{

}


@property (strong,nonatomic) WTMSound *sound;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;



@property (assign,nonatomic) BOOL isPlaying;
@property (assign,nonatomic) BOOL isRecording;
@property (assign,nonatomic) BOOL isPaused;


- (IBAction)action:(id)sender;

@end
