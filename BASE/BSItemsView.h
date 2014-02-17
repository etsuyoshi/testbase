//
//  BSItemsView.h
//  BASE
//
//  Created by Takkun on 2013/11/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSItemsView : UIView

+ (id)itemView;

@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *centerLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *centerButton;
@property (strong, nonatomic) IBOutlet UIButton *centerRightButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@end
