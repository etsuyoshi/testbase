//
//  BSBuyerAPIClient.m
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSBuyerAPIClient.h"


static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 本番環境
// static NSString * const kBSAPIBaseURLString = @"http://dt.base0.info";      // ステージング
// static NSString * const kBSAPIBaseURLString = @"http://api.base0.info";     // テスト
// static NSString * const kBSAPIBaseURLString = @"http://api.n-base.info";    // テスト
// static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 反社チェック用


@implementation BSBuyerAPIClient

+ (instancetype)sharedClient
{
    static BSBuyerAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[BSBuyerAPIClient alloc]
                         initWithBaseURL:[NSURL URLWithString:kBSAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}

#pragma mark - Shops
///---------------------------------------------------------------------------------------
/// @name Shops
///---------------------------------------------------------------------------------------

- (void)getShopWithUserId:(NSString *)userId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/shops/get_shop"
   parameters:@{
                @"user_id"              : userId,
                //@"device_name"          : deviseName,
                //@"device_os"            : deviseOS,
                //@"device_id"            : deviseId,

                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
    
}


- (void)getShopItemsWithUserId:(NSString *)userId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSMutableDictionary *parameters = [@{
                                        @"user_id"              : userId,
                                        
                                        } mutableCopy];
    
    [self GET:@"/shops/get_shop_items"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getShopItemWithItemId:(NSString *)itemId deviseName:(NSString *)deviseName deviseOS:(NSString *)deviseOS deviseId:(NSString *)deviseId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/shops/get_item"
   parameters:@{
                @"item_id"              : itemId,
                //@"device_name"          : deviseName,
                //@"device_os"            : deviseOS,
                //;@"device_id"            : deviseId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}



#pragma mark - IllegalReports
///---------------------------------------------------------------------------------------
/// @name IllegalReports
///---------------------------------------------------------------------------------------

- (void)getIllegalReportsWithItemId:(NSString *)itemId title:(NSString *)title message:(NSString *)message completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/illegal_reports/report"
   parameters:@{
                @"item_id"              : itemId,
                @"title"                : title,
                @"message"              : message,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


#pragma mark - ShopInquiries
///---------------------------------------------------------------------------------------
/// @name ShopInquiries
///---------------------------------------------------------------------------------------

- (void)getShopInquiriesWithUserId:(NSString *)userId title:(NSString *)title name:(NSString *)name mailAddress:(NSString *)mailAddress inquiry:(NSString *)inquiry completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/shop_inquiries/inquiry"
   parameters:@{
                @"user_id"                  : userId,
                @"title"                    : title,
                @"name"                     : name,
                @"mail_address"             : mailAddress,
                @"inquiry"                  : inquiry,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


#pragma mark - Curations
///---------------------------------------------------------------------------------------
/// @name Curations
///---------------------------------------------------------------------------------------

- (void)getCurationsWithCompletion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/curations/get_curations"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getCurationItemsWithCurationId:(NSString *)curationId num:(NSString *)num completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/curations/get_curation_items"
   parameters:@{
                @"curation_id"            : curationId,
                @"num"                    : num,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getAllCurationsItemsWithNum:(NSString *)num completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/curations/get_items"
   parameters:@{
                @"num"                    : num,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getCurationsDeleteCacheWithCompletion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/curations/delete_cache"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}



#pragma mark - Follows
///---------------------------------------------------------------------------------------
/// @name Follows
///---------------------------------------------------------------------------------------

- (void)getFollowingShopsWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey page:(int)page completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (apiTokenId) {
        parameters = @{
                       @"api_token_id"                 : apiTokenId,
                       @"unique_key"                   : uniqueKey,
                       @"page"                          : @(page),
                       
                       };
        
    } else {
        parameters = @{
                       @"unique_key"                   : uniqueKey,
                       @"page"                          : @(page),
                       
                       };
    }
    
    
    [self GET:@"/following_shops/get_shops"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getFollowingShopsItemsWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey page:(int)page completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (apiTokenId) {
        parameters = @{
            @"api_token_id"                 : apiTokenId,
            @"unique_key"                   : uniqueKey,
            @"page"                          : @(page),
            
        };

    } else {
        parameters = @{
                       @"unique_key"                   : uniqueKey,
                       @"page"                          : @(page),
                       
                       };
    }
    
    [self GET:@"/following_shops/get_shop_items"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getFollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString *)userId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (apiTokenId) {
        parameters = @{
                       @"api_token_id"                 : apiTokenId,
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
        
    } else {
        parameters = @{
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
    }
    
    [self GET:@"/following_shops/follow"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getUnfollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString *)userId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (apiTokenId) {
        parameters = @{
                       @"api_token_id"                 : apiTokenId,
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
        
    } else {
        parameters = @{
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
    }
    
    [self GET:@"/following_shops/follow"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getCheckFollowShopWithApiTokenId:(NSString *)apiTokenId uniqueKey:(NSString *)uniqueKey userId:(NSString *)userId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (apiTokenId) {
        parameters = @{
                       @"api_token_id"                 : apiTokenId,
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
        
    } else {
        parameters = @{
                       @"unique_key"                   : uniqueKey,
                       @"user_id"                         : userId,
                       
                       };
    }
    
    [self GET:@"/following_shops/follow"
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];

}






@end
