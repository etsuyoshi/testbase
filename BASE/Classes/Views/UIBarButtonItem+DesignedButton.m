//
//  UIBarButtonItem+DesignedButton.m
//  BASE
//
//  Created by Takkun on 2013/05/01.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "UIBarButtonItem+DesignedButton.h"

@implementation UIBarButtonItem (DesignedButton)


- (UIBarButtonItem *)designedBackBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector side:(int)side
{
    // 通常時の画像と押された時の画像を用意する
    UIImage *image;
    UIImage *highlightedImage;

    if (side == 1) {
        image = [UIImage imageNamed:@"backbtn.png"];
        highlightedImage = [UIImage imageNamed:@"backbtn_hl.png"];
    }else{
        image = [UIImage imageNamed:@"backbtn2.png"];
        highlightedImage = [UIImage imageNamed:@"backbtn_hl.png"];
    }
    // 左右 17px 固定で引き伸ばして利用する
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17.f, 0, 17.f)];
    highlightedImage = [highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17.f, 0, 17.f)];
    
    // 表示する文字に応じてボタンサイズを変更する
    UIFont *font = [UIFont boldSystemFontOfSize:12.f];
    CGSize textSize = [title sizeWithFont:font];
    CGSize buttonSize = CGSizeMake(textSize.width + 24.f, image.size.height);
    
    // ボタンを用意する
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 4.f, buttonSize.width, buttonSize.height)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    // ラベルを用意する
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4.f, 0.f, buttonSize.width, buttonSize.height)];
    label.text = title;
    label.textColor = [UIColor darkGrayColor];
    label.font = font;
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    //label.shadowOffset = CGSizeMake(0.f, 1.f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
