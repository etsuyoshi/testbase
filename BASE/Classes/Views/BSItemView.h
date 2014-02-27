//
//  BSItemView.h
//  BASE
//
//  Created by Takkun on 2013/09/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSItemView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIButton *socialButton;
@property (weak, nonatomic) IBOutlet UIImageView *scialImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;


+ (id)setView;
@end
