//
//  FollowShopTableViewCell.h
//  BASE
//
//  Created by Takkun on 2013/09/27.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLable;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, readwrite) NSUInteger number;


@end
