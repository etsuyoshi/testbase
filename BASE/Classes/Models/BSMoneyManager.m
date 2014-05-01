//
//  BSMoneyManager.m
//  BASE
//
//  Created by Takkun on 2014/04/22.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSMoneyManager.h"

@interface BSMoneyManager ()

@property (nonatomic) BSBank *bank;

@end

@implementation BSMoneyManager


+ (BSMoneyManager *)sharedManager
{
    static BSMoneyManager *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}



- (void)saveBank:(BSBank*)bank withBlock:(void (^)(NSError *error))block
{
    
    self.bank = bank;
    if (block) block(nil);
}


@end
