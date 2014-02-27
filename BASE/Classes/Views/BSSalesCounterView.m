//
//  BSSalesCounterView.m
//  BASE
//
//  Created by Takkun on 2014/02/13.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSSalesCounterView.h"

@implementation BSSalesCounterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UINib *nib = [UINib nibWithNibName:@"BSSalesCounterView" bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        
        UINib *nib = [UINib nibWithNibName:@"BSSalesCounterView" bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 8;
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
