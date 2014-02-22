//
//  HistoryPowerViewController.m
//  Louder, Please!
//
//  Created by Cina on 14-2-17.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import "HistoryPowerViewController.h"
#import "Tools.h"

@interface HistoryPowerViewController ()

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
        }
            break;
        case 1:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_6_8]];
        }
            break;
        case 2:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_8_10]];
        }
            break;
        case 3:{
            [_forTableViewArr addObjectsFromArray:[[Tools sharedTools].fullLists objectForKey:KTimeLevel_10_max]];
        }
            break;
            
        default:
            break;
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    NSDictionary *dic =[_forTableViewArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f", [[dic valueForKey:KAveragePower] floatValue]];
    cell.detailTextLabel.text =[[[dic valueForKey:@"date"] description] substringToIndex:20];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *diction =[_forTableViewArr objectAtIndex:indexPath.row];
//    NSDate *date = [diction valueForKey:@"date"];
//    NSString *caldate = [date description];
//    NSString *recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
    
    NSURL *url = [NSURL fileURLWithPath:[diction valueForKey:@"path"]];

    if (!audioPlayer) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.delegate = self;
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
    }else{
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
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
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
