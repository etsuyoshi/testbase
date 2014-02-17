//
//  BSCategoryView.m
//  BASE
//
//  Created by Takkun on 2013/04/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSCategoryView.h"

@implementation BSCategoryView


@synthesize categoryScrollView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return categoryScrollView;
    }
    return nil;
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
