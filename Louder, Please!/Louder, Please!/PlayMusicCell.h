//
//  PlayMusicCell.h
//  Louder, Please!
//
//  Created by Bill on 14-2-23.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMusicCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *mTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *mDetailTextLabel;
@property (retain, nonatomic) IBOutlet UILabel *mTimeLabel;

@property (retain, nonatomic) IBOutlet UISlider *mTimeSlider;
@property (retain, nonatomic) IBOutlet UIButton *mShareButton;
@property (retain, nonatomic) IBOutlet UIButton *mDeleteButton;


@end
