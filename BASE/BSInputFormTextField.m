//
//  BSInputFormTextField.m
//  BASE
//
//  Created by Takkun on 2014/02/04.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSInputFormTextField.h"

@implementation BSInputFormTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
        self.font = [UIFont systemFontOfSize:14];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textAlignment = NSTextAlignmentLeft;
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

@end
