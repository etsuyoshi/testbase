//
//  AdManager.h
//  admage
//
//  Created by 佐藤 亘 on 11/02/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DimageManager : NSObject

- (void)sendConversion;
- (void)sendConversionWithStartPage:(NSString*)url;
- (void)openConversionPage:(NSString*)url;
- (void)track:(NSString*)xtrack;
+ (DimageManager*)sharedManager;

@end
