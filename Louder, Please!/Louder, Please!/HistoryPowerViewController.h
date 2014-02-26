//
//  HistoryPowerViewController.h
//  Louder, Please!
//
//  Created by Cina on 14-2-17.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
@interface HistoryPowerViewController : UIViewController<UITableViewDataSource,
                                                            UITableViewDelegate,
                                                            AVAudioPlayerDelegate,
                                                            UIActionSheetDelegate,
                                                            MFMailComposeViewControllerDelegate>
{
    AVAudioPlayer *audioPlayer;
}

@property (retain, nonatomic) IBOutlet UITableView *mTimeLevelTableView;

@property (retain, nonatomic) NSMutableArray *forTableViewArr;
- (IBAction)forTimeLevelSegmented:(id)sender;
- (IBAction)changeEditMode:(id)sender;

-(IBAction)goBack:(id)sender;
@end
