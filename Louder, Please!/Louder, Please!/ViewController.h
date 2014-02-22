//
//  ViewController.h
//  Louder, Please!
//
//  Created by Cina on 14-2-13.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EZAudio.h"
#define kAudioFilePath @"EZAudioTest.caf"

enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;

@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,EZMicrophoneDelegate>
{
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    NSDate *recordDate;
    int recordEncoding;
}

-(IBAction) startRecording;
-(IBAction) stopRecording;
-(IBAction) playOrStopTrack:(id) sender;
- (IBAction)goHistoryViewController:(id)sender;

@property (nonatomic,strong) EZRecorder *recorder;
@property (nonatomic,strong) EZMicrophone *microphone;

@property (retain, nonatomic) IBOutlet UILabel *mRecordDurationLabel;
@property (retain, nonatomic) IBOutlet EZAudioPlotGL *audioPlot;
@property (retain, nonatomic) IBOutlet UIImageView *mRecordingBackgroundImage;
@property (retain, nonatomic) IBOutlet UIButton *mButtonPlay;
@end
