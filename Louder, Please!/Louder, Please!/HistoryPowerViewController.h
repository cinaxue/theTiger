//
//  HistoryPowerViewController.h
//  Louder, Please!
//
//  Created by Cina on 14-2-17.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HistoryPowerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}

-(IBAction)goBack:(id)sender;
@end
