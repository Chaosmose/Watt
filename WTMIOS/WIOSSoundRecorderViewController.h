//
//  WIOSSoundRecorderCell.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 pereira-da-silva.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "WTM.h"
#import "WTMSound.h"

@interface WIOSSoundRecorderViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{

}


@property (weak,nonatomic) WTMSound *sound;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *recordingProgressLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (assign,nonatomic) BOOL isPlaying;
@property (assign,nonatomic) BOOL isRecording;
@property (assign,nonatomic) BOOL isPaused;

/**
 *  You can use your own skin by changing the bundleName; (NSBundle)
 */
- (void)setBundleName:(NSString *)bundleName;

- (IBAction)action:(id)sender;

@end
