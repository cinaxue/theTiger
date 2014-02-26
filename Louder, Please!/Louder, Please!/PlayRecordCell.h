//
//  PlayRecordCell.h
//  Louder, Please!
//
//  Created by Bill on 14-2-26.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRecordCell : UITableViewCell



@property (retain, nonatomic) IBOutlet UILabel *mTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *mDatailTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (retain, nonatomic) IBOutlet UISlider *mProgressSlider;
@property (retain, nonatomic) IBOutlet UIButton *mPlayButton;
@property (retain, nonatomic) IBOutlet UIButton *mShareButton;



@end
