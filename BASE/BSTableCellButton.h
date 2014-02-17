//
//  BSTableCellButton.h
//  BASE
//
//  Created by Takkun on 2013/05/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCartViewController.h"

@interface BSTableCellButton : UIButton {
    NSUInteger section;
    NSUInteger row;
}

@property (nonatomic, readwrite) NSUInteger section;
@property (nonatomic, readwrite) NSUInteger row;
@end
