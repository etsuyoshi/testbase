//
//  Triangle.m
//  BASE
//
//  Created by Takkun on 2013/04/26.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景を透明にする
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    // 塗りつぶす色を設定する。
    [[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.70f] setFill];
    
    // 三角形のパスを書く　（３点でオープンパスにした。）
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGContextMoveToPoint(ctx, width / 2, 0);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, 0, height);
    
    // 塗りつぶす
    CGContextFillPath(ctx);
}


@end
