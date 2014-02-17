//
//  BSAddressInfoCell.m
//  BASE
//
//  Created by Takkun on 2014/02/05.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSAddressInfoCell.h"

@implementation BSAddressInfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSLog(@"reuseIdentifier");
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
