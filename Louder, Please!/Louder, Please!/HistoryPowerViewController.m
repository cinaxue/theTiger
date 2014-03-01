//
//  HistoryPowerViewController.m
//  Louder, Please!
//
//  Created by Cina on 14-2-17.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import "HistoryPowerViewController.h"
#import "Tools.h"
#import "PlayRecordCell.h"
@interface HistoryPowerViewController ()
{
    NSString *LevelSignStr;
    int selectRow;
    
    UISlider *mProgressSlider;
    UILabel *mTimeLabel;
    NSTimer *changeTimeLabelTimer;
    UIButton *playMusicButton;
}

@end

@implementation HistoryPowerViewController



-(void)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _forTableViewArr = [[NSMutableArray alloc] initWithArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_4_6]];
    LevelSignStr = KTimeLevel_4_6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forTimeLevelSegmented:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    [_forTableViewArr removeAllObjects];
    switch (seg.selectedSegmentIndex) {
        case 0:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_4_6]];
            LevelSignStr = KTimeLevel_4_6;
        }
            break;
        case 1:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_6_8]];
            LevelSignStr = KTimeLevel_6_8;
        }
            break;
        case 2:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_8_10]];
            LevelSignStr = KTimeLevel_8_10;
        }
            break;
        case 3:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_10_max]];
            LevelSignStr = KTimeLevel_10_max;
        }
            break;
            
        default:
            break;
    }
    [_mTimeLevelTableView reloadData];
}

- (IBAction)changeEditMode:(id)sender
{
    _mTimeLevelTableView.editing = !_mTimeLevelTableView.editing;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *diction =[_forTableViewArr objectAtIndex:indexPath.row];
    NSString *dataPath = [diction valueForKey:@"path"];
    
    NSFileManager *fileM = [NSFileManager defaultManager];
    [fileM removeItemAtPath:dataPath error:nil];
    [_forTableViewArr removeObjectAtIndex:indexPath.row];
    
    [[[Tools sharedTools].fullLists objectForKey:LevelSignStr] removeObjectAtIndex:indexPath.row];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingFormat:@"/History.plist"];
    [[Tools sharedTools].fullLists writeToFile:path atomically:NO];
    [_mTimeLevelTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [[Tools sharedTools].fullLists valueForKey:KLevel_key4_6].count;
    
    return _forTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PlayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlayRecordCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dic =[_forTableViewArr objectAtIndex:indexPath.row];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[dic valueForKey:@"path"]] error:Nil];
    
    cell.mTextLabel.text = [NSString stringWithFormat:@"%.2f(%.2fs)", [[dic valueForKey:KAveragePower] floatValue],player.duration];
    cell.mDatailTextLabel.text =[[[dic valueForKey:@"date"] description] substringToIndex:20];
    
    if (indexPath.row == selectRow-1)
    {
        [cell.mPlayButton addTarget:self action:@selector(forPlayButtonMethon:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mShareButton addTarget:self action:@selector(forShareButtonMethon:) forControlEvents:UIControlEventTouchUpInside];
        mProgressSlider = [cell.mProgressSlider retain];
        mTimeLabel = [cell.mTimeLabel retain];
        playMusicButton = [cell.mPlayButton retain];
    }
    
    
    [player release];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (audioPlayer && selectRow != indexPath.row) {
        [audioPlayer stop];
        [audioPlayer release];
        audioPlayer = nil;
    }
    selectRow = indexPath.row +1;
    
    [_mTimeLevelTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectRow-1) {
        return 150;
    }
    return 50;
}

-(void)forPlayButtonMethon:(id)sender
{
    UIButton *playButton = (UIButton *)sender;
    NSDictionary *diction =[_forTableViewArr objectAtIndex:selectRow-1];
    //    NSDate *date = [diction valueForKey:@"date"];
    //    NSString *caldate = [date description];
    //    NSString *recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
    
    NSURL *url = [NSURL fileURLWithPath:[diction valueForKey:@"path"]];
    
    if (audioPlayer.isPlaying) {
        [audioPlayer pause ];
        [changeTimeLabelTimer invalidate];
//        [changeTimeLabelTimer release];
        changeTimeLabelTimer = nil;
        [playButton setTitle:@"播放" forState:UIControlStateNormal];
    }else{
        if (!audioPlayer) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayer.delegate = self;
            audioPlayer.numberOfLoops = 0;
        }
        [audioPlayer play];
        changeTimeLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeLabelMethod) userInfo:nil repeats:YES];
        [changeTimeLabelTimer fire];
        [playButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    
    /*
    else{
        [audioPlayer stop];
        [audioPlayer release];
        audioPlayer = nil;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![[diction valueForKey:@"path"] isEqualToString:audioPlayer.url.path]) {
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayer.delegate = self;
            audioPlayer.numberOfLoops = 0;
            [audioPlayer play];
        }
    }*/
}

-(void)changeTimeLabelMethod
{
    mProgressSlider.value = audioPlayer.currentTime/audioPlayer.duration;
//    NSString *current = [NSString stringWithFormat:audioPlayer.currentTime/];
    mTimeLabel.text = [NSString stringWithFormat:@"%.0f                                                            %.0f",audioPlayer.currentTime,audioPlayer.duration];
    NSLog(@"test");
}

-(void)forShareButtonMethon:(id)sender
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件分享", nil];
    [shareSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [self presentViewController:mail animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playMusicButton setTitle:@"播放" forState:UIControlStateNormal];
    [changeTimeLabelTimer invalidate];
    changeTimeLabelTimer = nil;
    mTimeLabel.text = nil;
    mProgressSlider.value = 0;
    [audioPlayer stop];
    [audioPlayer release];
    audioPlayer = nil;
}

-(void)dealloc
{
    if (audioPlayer) {
        [audioPlayer release];
        audioPlayer = nil;
    }
    
    [_mTimeLevelTableView release];
    [super dealloc];
}
@end
