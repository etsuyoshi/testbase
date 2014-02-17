//
//  BSLoginViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UICKeyChainStore.h"






@interface BSLoginViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


+ (NSString*)sessions;
+ (NSString*)importShopId;
@end

