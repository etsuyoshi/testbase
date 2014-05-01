//
//  BSBank.m
//  BASE
//
//  Created by Takkun on 2014/04/12.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSBank.h"

@implementation BSBank


- (instancetype)initWithBankName:(NSString *)bankName bankCode:(NSString *)bankCode branchName:(NSString *)branchName branchCode:(NSString *)branchCode
{
    self = [super init];
    if (self) {
        _bankName = bankName;
        _bankCode = bankCode;
        _branchName = branchName;
        _branchCode = branchCode;
    }
    
    return self;
}



@end
