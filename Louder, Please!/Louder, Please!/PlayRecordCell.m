//
//  PlayRecordCell.m
//  Louder, Please!
//
//  Created by Bill on 14-2-26.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import "PlayRecordCell.h"

@implementation PlayRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_mTextLabel release];
    [_mDatailTextLabel release];
    [_mTimeLabel release];
    [_mProgressSlider release];
    [_mPlayButton release];
    [_mShareButton release];
    [super dealloc];
}
@end
