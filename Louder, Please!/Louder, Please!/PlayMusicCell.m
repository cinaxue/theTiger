//
//  PlayMusicCell.m
//  Louder, Please!
//
//  Created by Bill on 14-2-23.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import "PlayMusicCell.h"

@implementation PlayMusicCell

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
    [_mDetailTextLabel release];
    [_mTimeLabel release];
    [_mTimeSlider release];
    [_mShareButton release];
    [_mDeleteButton release];
    [super dealloc];
}
@end
