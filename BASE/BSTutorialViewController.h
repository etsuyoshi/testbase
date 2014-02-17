//
//  BSTutorialViewController.h
//  BASE
//
//  Created by Takkun on 2013/05/25.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "GAI.h"




@interface BSTutorialViewController : GAITrackedViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
}

+ (NSString*)sessions;
+ (NSString*)importShopId;
+ (BOOL)autoLogin:(NSString*)view;

@end
