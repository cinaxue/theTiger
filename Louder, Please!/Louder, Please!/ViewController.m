//
//  ViewController.m
//  Louder, Please!
//
//  Created by Cina on 14-2-13.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import "ViewController.h"
#import "Tools.h"
#import "HistoryPowerViewController.h"
#import "DataPostURL.h"
#import "UploadData.h"

@interface ViewController ()
{
    NSTimer *recordTimer;
}
@end

@implementation ViewController
@synthesize recorder;
@synthesize microphone;

-(void) whenFinished: (id) sender
{
    NSLog(@"123");
}

-(void) getDataFromServer
{
    NSMutableData *data = [NSMutableData dataWithContentsOfURL:audioRecorder.url];
    UploadData *getData = [[[UploadData alloc]initWithUploadMima:audioRecorder] autorelease];
    getData.delegate = self;
    getData.Selector = @selector(whenFinished:);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSURL *url = [NSURL URLWithString:@"http://172.16.40.237/louderplease/registeruser.php"];  // test json
//    NSURL *url = [NSURL URLWithString:@"http://172.16.40.237/louderplease/registeruser.php"];
////
//    DataPostURL *getData = [[[DataPostURL alloc]initWithURL:url] autorelease];
//    getData.delegate = self;
//    getData.Selector = @selector(whenFinished:);
    
	// Do any additional setup after loading the view, typically from a nib.
    recordEncoding = ENC_AAC;
    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    [self.audioPlot setBackgroundColor:[UIColor colorWithRed: 0.984 green: 0.71 blue: 0.365 alpha: 1]];
    self.audioPlot.plotType = EZPlotTypeBuffer;
    
    // Fill
    self.audioPlot.shouldFill = YES;
    // Mirror
    self.audioPlot.shouldMirror = YES;
    [self.microphone startFetchingAudio];
}

// 上面显示正在录制的一个动画效果，每0.1秒按照顺序切换一张图片
-(void) startRecordingAnimation:(NSNumber*) bgNumber
{
    // VoiceSearchFeedback005_ios7
    NSString *imageName = [NSString stringWithFormat:@"VoiceSearchFeedback00%d_ios7",bgNumber.intValue];
    
    if (![UIImage imageNamed:imageName]) {
        imageName = [NSString stringWithFormat:@"VoiceSearchFeedback003_ios7"];
        [self.mRecordingBackgroundImage setImage:[UIImage imageNamed:imageName]];
        [self performSelector:@selector(startRecordingAnimation:) withObject:[NSNumber numberWithInt:3] afterDelay:0.1f];
    }else{
        [self.mRecordingBackgroundImage setImage:[UIImage imageNamed:imageName]];
        self.mRecordingBackgroundImage.alpha = 1.0f;
        [self performSelector:@selector(startRecordingAnimation:) withObject:[NSNumber numberWithInt:bgNumber.intValue+1] afterDelay:0.1f];
    }
}

-(IBAction) startRecording
{
    if (audioRecorder) {
        [audioRecorder release];
        audioRecorder = nil;
    }
    
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
//    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSDictionary* recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    
    // Create a new dated file
    
    recordDate = [[NSDate dateWithTimeIntervalSinceNow:0] retain];
    NSString *caldate = [recordDate description];
    NSString *recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
 
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    
    NSError *error = nil;
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.meteringEnabled = YES;

    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];

        if (audioPlayer) { // 清除之前播放的音频
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil;
        }
        
        [self startRecordingAnimation:[NSNumber numberWithInt:3]];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
    }
    
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(forRecordTimerMethod) userInfo:nil repeats:YES];
}

-(void)forRecordTimerMethod
{
    _mRecordDurationLabel.text = [NSString stringWithFormat:@"%.2f",[recordDate timeIntervalSinceDate:[NSDate date]]];
}

-(IBAction) stopRecording
{
    
    [recordTimer invalidate];
    _mRecordDurationLabel.text = @"";
    
    // 取消[self Perform]的函数的死循环，隐藏正在录制的动画
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.mRecordingBackgroundImage.alpha =0;
    
    float peakPower = 0.0, averagePower = 0.0;
    
    if (audioRecorder) {
        [audioRecorder updateMeters];
        peakPower = [audioRecorder peakPowerForChannel:0];
        averagePower = [audioRecorder averagePowerForChannel:0];
        [audioRecorder stop];
//        [self.microphone stopFetchingAudio];
        
        // 测试上传音频到服务器
        [self getDataFromServer];
        
        // 保存到本地
        [Tools addPowerToHistoryAVAudioRecorder:audioRecorder Date:recordDate];
        [recordDate release];
    }
    
    // Calculate the power for channels
    NSLog(@"stopped! peakPower: %f, averagePower: %f", peakPower,averagePower);
    
    NSString *alertMessage = @"";
    if (averagePower<=-150) {
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_160_150];
    }else if (averagePower>-150 && averagePower<=-120){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_150_120];
    }else if (averagePower>-120 && averagePower<=-90){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_120_90];
    }else if (averagePower>-90 && averagePower<=-60){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_90_60];
    }else if (averagePower>-60 && averagePower<=-30){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_60_30];
    }else if (averagePower>-30 && averagePower<=-10){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_30_10];
    }else if (averagePower>-10 && averagePower<=-5){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_10_5];
    }else if (averagePower>-5 && averagePower<=0){
        alertMessage = [NSString stringWithFormat:@"平均分贝: %f. %@", averagePower, KAlertPowerRange_0];
    }
    
    [Tools showAlert:alertMessage];
}

-(IBAction) playOrStopTrack:(id) sender
{
    UIButton *button = (UIButton*) sender;
    
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if (audioRecorder) {
        if (!audioPlayer) {
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
            audioPlayer.delegate = self;
            audioPlayer.numberOfLoops = 0;
            [audioPlayer play];
            
            [button setTitle:@"Stop" forState:UIControlStateNormal];
            [button setTitle:@"Stop" forState:UIControlStateSelected];
            [button setTitle:@"Stop" forState:UIControlStateHighlighted];
        }else{
            [button setTitle:@"Play" forState:UIControlStateNormal];
            [button setTitle:@"Play" forState:UIControlStateSelected];
            [button setTitle:@"Play" forState:UIControlStateHighlighted];
            [audioPlayer stop];
            [audioPlayer release];
            audioPlayer = nil;
        }
    }
}

- (IBAction)goHistoryViewController:(id)sender {
    HistoryPowerViewController *historyVC = [[HistoryPowerViewController alloc]initWithNibName:@"HistoryPowerViewController" bundle:nil];
    [self presentViewController:historyVC animated:YES completion:NULL];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.mButtonPlay setTitle:@"Play" forState:UIControlStateNormal];
    [self.mButtonPlay setTitle:@"Play" forState:UIControlStateSelected];
    [self.mButtonPlay setTitle:@"Play" forState:UIControlStateHighlighted];
    [audioPlayer stop];
    [audioPlayer release];
    audioPlayer = nil;
}

-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog (@"audioRecorderBeginInterruption:");
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog (@"audioRecorderEncodeErrorDidOccur:");
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    // your actions here
}

#pragma mark - EZMicrophoneDelegate
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.

    dispatch_async(dispatch_get_main_queue(),^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
    // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
    
    // Here's a print function to allow you to inspect it a little easier
    [EZAudio printASBD:audioStreamBasicDescription];

    // We can initialize the recorder with this ASBD
    self.recorder = [EZRecorder recorderWithDestinationURL:[self testFilePathURL]
                                           andSourceFormat:audioStreamBasicDescription];
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {

    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if(audioRecorder.isRecording){
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
-(NSArray*)applicationDocuments {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

-(NSString*)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(NSURL*)testFilePathURL {
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],kAudioFilePath]];
}

- (void)dealloc
{
    [audioPlayer release];
    [audioRecorder release];
    [_mButtonPlay release];
    [_mRecordingBackgroundImage release];
    [_audioPlot release];
    [_mRecordDurationLabel release];
    [super dealloc];
}

@end
