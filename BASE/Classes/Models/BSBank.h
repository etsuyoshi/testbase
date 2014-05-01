//
//  BSBank.h
//  BASE
//
//  Created by Takkun on 2014/04/12.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSBank : NSObject

/** bank */
@property (nonatomic, readonly) NSString *bankName;

@property (nonatomic, readonly) NSString *bankCode;


/** branch */
@property (nonatomic, readonly) NSString *branchName;

@property (nonatomic, readonly) NSString *branchCode;


/** `AMItem` 初期化
 
 @param name name.
 @param description description.
 @param category category.
 @return `AMItem`.
 */
- (instancetype)initWithBankName:(NSString *)bankName bankCode:(NSString *)bankCode branchName:(NSString *)branchName branchCode:(NSString *)branchCode;
@end
