//
//  ShopTableViewCell.h
//  BASE
//
//  Created by Takkun on 2013/09/03.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell{
    /*
    IBOutlet UIButton *shopImageButton;
    IBOutlet UIImageView *shopDescriptionBackgroundImageView;
    IBOutlet UILabel *shopTitleLabel;
    IBOutlet UILabel *shopAboutLable;
     */
}
@property (weak, nonatomic) IBOutlet UIImageView *shopImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *shopDescriptionBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAboutLable;
@property (nonatomic, readwrite) NSUInteger number;


@end
