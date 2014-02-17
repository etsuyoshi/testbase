//
//  ShopTableViewCell.m
//  BASE
//
//  Created by Takkun on 2013/09/03.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell


@synthesize shopImageButton;
@synthesize shopDescriptionBackgroundImageView;
@synthesize shopTitleLabel;
@synthesize shopAboutLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:nil];
    if (self) {
        // Initialization code」
        shopImageButton = nil;
        shopDescriptionBackgroundImageView = nil;
        shopTitleLabel = nil;
        shopAboutLable = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
