//
//  AppDelegate.h
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

#import "BSBuyTopViewController.h"


// デリゲートを定義
@protocol apnTokeDelegate <NSObject>

// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)connectFollowShops;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) id<apnTokeDelegate> delegate;
+(NSString*)getDeviceToken;
+(NSString*)getTokenId;

- (void)getApnToken;
@end
void exceptionHandler(NSException *exception);