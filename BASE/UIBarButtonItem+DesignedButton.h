//
//  UIBarButtonItem+DesignedButton.h
//  BASE
//
//  Created by Takkun on 2013/05/01.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DesignedButton)

- (UIBarButtonItem *)designedBackBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector side:(int)side;

@end
