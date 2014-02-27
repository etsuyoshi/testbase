//
//  ShopTableViewCell2.h
//  BASE
//
//  Created by Takkun on 2013/09/04.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell2 : UITableViewCell{
    IBOutlet UIButton *shopImageButton;
    IBOutlet UIImageView *shopDescriptionBackgroundImageView;
    IBOutlet UILabel *shopTitleLabel;
    IBOutlet UILabel *shopAboutLable;
}

@property (nonatomic, retain)  UIButton *shopImageButton;
@property (nonatomic, retain) UIImageView *shopDescriptionBackgroundImageView;
@property (nonatomic, retain) UILabel *shopTitleLabel;
@property (nonatomic, retain) UILabel *shopAboutLable;

@end
