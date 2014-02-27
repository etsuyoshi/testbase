//
//  BSPublicAPIClient.m
//  BASE
//
//  Created by Takkun on 2014/02/18.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSPublicAPIClient.h"

@implementation BSPublicAPIClient


+ (instancetype)sharedClient
{
    static BSPublicAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[BSPublicAPIClient alloc]
                         initWithBaseURL:[NSURL URLWithString:@"http://api.zipaddress.net"]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}


#pragma mark - Zipcode
///---------------------------------------------------------------------------------------
/// @name Zipcode
///---------------------------------------------------------------------------------------


- (void)getAddressWithZipcode:(NSString *)zipcode completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/"
   parameters:@{
                @"zipcode"                 : zipcode,
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
