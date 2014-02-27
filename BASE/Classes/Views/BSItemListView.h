//
//  BSItemListView.h
//  BASE
//
//  Created by Takkun on 2013/09/17.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSItemListView : UIView
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIScrollView *itemScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;


+ (id)setView;
@end
