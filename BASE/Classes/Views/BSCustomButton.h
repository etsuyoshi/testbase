//
//  BSCustomButton.h
//  BASE
//
//  Created by Takkun on 2013/07/29.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSCustomButton : UIButton {
    NSUInteger row;
    NSUInteger line;
    NSString *category;

}

@property (nonatomic, readwrite) NSUInteger row;
@property (nonatomic, readwrite) NSUInteger line;
@property (nonatomic, readwrite) NSString *category;

@end
