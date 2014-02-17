//
//  Ltv.h
//  admage
//
//  Created by 佐藤 亘 on 11/02/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PARAM_SKU "_sku"
#define PARAM_PRICE "_price"
#define PARAM_OUT "_out"

@interface DimageLtv : NSObject {
@private
	id _ltv;
}

- (id)init;

// use all ltv
- (void)setLtvCookie;
- (void)ltvOpenBrowser:(NSString*)url;

- (void)sendLtv:(int)cvpointId;
- (void)sendLtv:(int)cvpointId :(NSString*)buid;

// change param  
- (void)addParameter:(NSString*)args :(NSString*)argv;
@end
