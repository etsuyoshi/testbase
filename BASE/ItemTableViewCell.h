//
//  ItemTableViewCell.h
//  BASE
//
//  Created by Takkun on 2013/09/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell{
    
}
@property (weak, nonatomic) IBOutlet UIButton *leftItemButton;
@property (weak, nonatomic) IBOutlet UIButton *rightItemButton;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *leftCartView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *LeftTitleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *RightTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *rightCardView;
@property (nonatomic, readwrite) NSUInteger number;


@end
