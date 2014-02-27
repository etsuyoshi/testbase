//
//  BSCommonAPIClient.h
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BSCommonAPIClient : AFHTTPSessionManager

//---------------------------------------------------------------------------------------
/// @name インスタンスを得る
///---------------------------------------------------------------------------------------

+ (instancetype)sharedClient;

///---------------------------------------------------------------------------------------
/// @name API とのやりとり
///---------------------------------------------------------------------------------------



#pragma mark - PushNotifications
///---------------------------------------------------------------------------------------
/// @name PushNotifications
///---------------------------------------------------------------------------------------

/** プッシュ通知の設定
 
 @param sessionId セッション.
 @param token APNトークン.                 // 必須ではない
 @param curation 1 or 0.                   // 必須ではない
 @param order 1 or 0.      // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getPushNotificationsSettingWithSessionId:(NSString *)sessionId token:(NSString *)token curation:(int)curation order:(int)order completion:(void (^)(NSDictionary *results, NSError *error))block;


@end
