//
//  BSAddressInfoCell.h
//  BASE
//
//  Created by Takkun on 2014/02/05.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSAddressInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *buttonTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *orderButtonTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *deleteButtonTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
