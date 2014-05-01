//
//  BSMoneyManager.h
//  BASE
//
//  Created by Takkun on 2014/04/22.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BSBank;

@interface BSMoneyManager : NSObject


/** 銀行情報
 
 `BSBank`.
 */
@property (nonatomic, readonly) BSBank *bank;


///---------------------------------------------------------------------------------------
/// @name 管理オブジェクトを得る
///---------------------------------------------------------------------------------------

/** シングルトンの管理オブジェクトを得る
 
 @return `AMItemManager`.
 */
+ (BSMoneyManager *)sharedManager;


/** 銀行情報を保存
 
 @param block 完了時に呼び出される blocks.
 */
- (void)saveBank:(BSBank*)bank withBlock:(void (^)(NSError *error))block;


@end
