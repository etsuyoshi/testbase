//
//  BSBuyerAPIClient.h
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BSBuyerAPIClient : AFHTTPSessionManager


///---------------------------------------------------------------------------------------
/// @name インスタンスを得る
///---------------------------------------------------------------------------------------

+ (instancetype)sharedClient;

///---------------------------------------------------------------------------------------
/// @name API とのやりとり
///---------------------------------------------------------------------------------------


#pragma mark - Shops
///---------------------------------------------------------------------------------------
/// @name Shops
///---------------------------------------------------------------------------------------

/** ショップ情報の取得
 
 @param userId ショップのID.
 @param deviseName ショップのID.                 // 必須ではない
 @param deviseOS ショップのID.                   // 必須ではない
 @param deviseId 完了時に呼び出される blocks.      // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getShopWithUserId:(NSString *)userId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** ショップアイテムの取得
 
 @param userId ショップのID.
 @param deviseName ショップのID.                 // 必須ではない
 @param deviseOS ショップのID.                   // 必須ではない
 @param deviseId 完了時に呼び出される blocks.      // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getShopItemsWithUserId:(NSString *)userId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** アイテムの詳細の取得
 
 @param itemId ショップのID.
 @param deviseName ショップのID.                 // 必須ではない
 @param deviseOS ショップのID.                   // 必須ではない
 @param deviseId 完了時に呼び出される blocks.      // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getShopItemWithItemId:(NSString *)itemId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *results, NSError *error))block;






#pragma mark - IllegalReports
///---------------------------------------------------------------------------------------
/// @name IllegalReports
///---------------------------------------------------------------------------------------

/** 違反通報
 
 @param itemId ショップのID.
 @param title 違反通報のタイトル.
 @param message 違反通報内容.                   // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getIllegalReportsWithItemId:(NSString *)itemId title:(NSString *)title message:(NSString *)message completion:(void (^)(NSDictionary *results, NSError *error))block;


#pragma mark - ShopInquiries
///---------------------------------------------------------------------------------------
/// @name ShopInquiries
///---------------------------------------------------------------------------------------

/** ショップへのお問い合わせ
 
 @param userId ショップのID.
 @param title お問い合せタイトル.
 @param name お問い合せ者名.
 @param mailAddress メールアドレス.
 @param inquiry お問い合せ内容.
 @param block 完了時に呼び出される blocks.
 */
- (void)getShopInquiriesWithUserId:(NSString *)userId title:(NSString *)title name:(NSString *)name mailAddress:(NSString *)mailAddress inquiry:(NSString *)inquiry completion:(void (^)(NSDictionary *results, NSError *error))block;


#pragma mark - Curations
///---------------------------------------------------------------------------------------
/// @name Curations
///---------------------------------------------------------------------------------------

/** キュレーション一覧の取得
 
 @param block 完了時に呼び出される blocks.
 */
- (void)getCurationsWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;


/** キュレーションアイテムの取得（1キュレーション毎）
 
 @param curationId キュレーション商品ののID.
 @param num 1キュレーションの最大商品数.                 // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getCurationItemsWithCurationId:(NSString *)curationId num:(NSString *)num completion:(void (^)(NSDictionary *results, NSError *error))block;


/** キュレーションアイテムの取得（全て）
 
 @param num 1キュレーションの最大商品数.                 // 必須ではない
 @param block 完了時に呼び出される blocks.
 */
- (void)getAllCurationsItemsWithNum:(NSString *)num completion:(void (^)(NSDictionary *results, NSError *error))block;

/** キュレーションキャッシュ削除
 
 @param block 完了時に呼び出される blocks.
 */
- (void)getCurationsDeleteCacheWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;




#pragma mark - Follows
///---------------------------------------------------------------------------------------
/// @name Follows
///---------------------------------------------------------------------------------------


/** ショップ一覧の取得
 
 @param apiTokenId プッシュ通知のID.           // 存在する場合必須
 @param uniqueKey プッシュ通知のID.           // 端末で保持している場合必須
 @param page ページ番号.
 @param block 完了時に呼び出される blocks.
 */
- (void)getFollowingShopsWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey page:(int)page completion:(void (^)(NSDictionary *results, NSError *error))block;



/** 商品一覧の取得
 
 @param apiTokenId プッシュ通知のID.           // 存在する場合必須
 @param uniqueKey プッシュ通知のID.           // 端末で保持している場合必須
 @param page ページ番号.
 @param block 完了時に呼び出される blocks.
 */
- (void)getFollowingShopsItemsWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey page:(int)page completion:(void (^)(NSDictionary *results, NSError *error))block;



/** フォロー
 
 @param apiTokenId プッシュ通知のID.           // 存在する場合必須
 @param uniqueKey プッシュ通知のID.           // 端末で保持している場合必須
 @param userId ショップID.
 @param block 完了時に呼び出される blocks.
 */
- (void)getFollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString*)userId completion:(void (^)(NSDictionary *results, NSError *error))block;



/** アンフォロー
 
 @param apiTokenId プッシュ通知のID.           // 存在する場合必須
 @param uniqueKey プッシュ通知のID.           // 端末で保持している場合必須
 @param userId ショップID.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUnfollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString*)userId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** フォローチェック
 
 @param apiTokenId プッシュ通知のID.           // 存在する場合必須
 @param uniqueKey プッシュ通知のID.           // 端末で保持している場合必須
 @param userId ショップID.
 @param block 完了時に呼び出される blocks.
 */
- (void)getCheckFollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString*)userId completion:(void (^)(NSDictionary *results, NSError *error))block;



@end
