    //
//  BSTopFooterView.h
//  BASE
//
//  Created by Takkun on 2013/09/17.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTopFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

+ (id)setView;

@end
