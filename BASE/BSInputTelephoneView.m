//
//  BSInputTelephoneView.m
//  BASE
//
//  Created by Takkun on 2014/02/04.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSInputTelephoneView.h"

@implementation BSInputTelephoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"BSInputTelephoneView" bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"BSInputTelephoneView" bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
    }
    return self;
}

+ (id)inputTelephoneView
{
    // nib ファイルから読み込む
    UINib *nib = [UINib nibWithNibName:@"BSInputTelephoneView" bundle:nil];
    BSInputTelephoneView *view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    return view;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
