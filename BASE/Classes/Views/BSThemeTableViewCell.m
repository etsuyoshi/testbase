//
//  BSThemeTableViewCell.m
//  BASE
//
//  Created by Takkun on 2014/04/03.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSThemeTableViewCell.h"

@implementation BSThemeTableViewCell

@synthesize checkImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization coded
    }

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
