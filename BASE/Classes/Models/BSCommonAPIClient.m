//
//  BSCommonAPIClient.m
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSCommonAPIClient.h"

static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 本番環境
// static NSString * const kBSAPIBaseURLString = @"http://dt.base0.info";      // ステージング
 //static NSString * const kBSAPIBaseURLString = @"http://api.base0.info";     // テスト
//static NSString * const kBSAPIBaseURLString = @"http://api.n-base.info";    // テスト
// static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 反社チェック用


@implementation BSCommonAPIClient


+ (instancetype)sharedClient
{
    static BSCommonAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[BSCommonAPIClient alloc]
                         initWithBaseURL:[NSURL URLWithString:kBSAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}



#pragma mark - PushNotifications
///---------------------------------------------------------------------------------------
/// @name PushNotifications
///---------------------------------------------------------------------------------------

- (void)getPushNotificationsSettingWithSessionId:(NSString *)sessionId token:(NSString *)token curation:(int)curation order:(int)order completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSLog(@"parametergetPushNotificationsSettingWithSessionIdparameter");
    NSDictionary *parameter;
    NSLog(@"getPushNotificationsSettingWithSessionIdparameter");
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    // cration:2, order:2の場合はパラメータ自体を送らない
    if (!(curation == 2 && order == 2)) {
        
        parameters[@"curation"] = @(curation);
        parameters[@"order"] = @(order);

        /*
        if (!sessionId) {
            
            parameter = @{
                           @"token"                : token,
                           };

        } else {
            parameter = @{
                          @"session_id"           : sessionId,
                          @"token"                : token,
                          };
        }
         */
        
    }
    
    if (sessionId) {
        parameters[@"session_id"] = sessionId;

    }
    
    if (token) {
        parameters[@"token"] = token;

    }


    [self GET:@"/push_notifications/settings"
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


#pragma mark - Version
///---------------------------------------------------------------------------------------
/// @name Version
///---------------------------------------------------------------------------------------


- (void)getCheckVersionWithUserType:(NSString *)userType completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];

    [self GET:@"/stable_versions/check_version"
   parameters:@{
                @"user_type"           : userType,
                @"version"                : version,
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

@end
