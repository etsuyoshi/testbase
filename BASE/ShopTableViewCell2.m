//
//  ShopTableViewCell2.m
//  BASE
//
//  Created by Takkun on 2013/09/04.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "ShopTableViewCell2.h"

@implementation ShopTableViewCell2

@synthesize shopImageButton;
@synthesize shopDescriptionBackgroundImageView;
@synthesize shopTitleLabel;
@synthesize shopAboutLable;

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

@end
