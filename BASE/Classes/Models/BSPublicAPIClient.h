//
//  BSPublicAPIClient.h
//  BASE
//
//  Created by Takkun on 2014/02/18.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BSPublicAPIClient : AFHTTPSessionManager


//---------------------------------------------------------------------------------------
/// @name インスタンスを得る
///---------------------------------------------------------------------------------------

+ (instancetype)sharedClient;



#pragma mark - Zipcode
///---------------------------------------------------------------------------------------
/// @name Zipcode
///---------------------------------------------------------------------------------------

/** 住所補完
 
 @param zipcode 郵便番号.
 @param block 完了時に呼び出される blocks.
 */
- (void)getAddressWithZipcode:(NSString *)zipcode completion:(void (^)(NSDictionary *results, NSError *error))block;

@end
