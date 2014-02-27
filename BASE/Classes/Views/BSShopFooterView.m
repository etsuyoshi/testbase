//
//  BSShopFooterView.m
//  BASE
//
//  Created by Takkun on 2013/09/17.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSShopFooterView.h"

@implementation BSShopFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (id)setView
{
    // nib ファイルから読み込む
    UINib *nib = [UINib nibWithNibName:@"BSShopFooterView" bundle:nil];
    BSShopFooterView *view = [nib instantiateWithOwner:self options:nil][0];
    return view;
}

@end
