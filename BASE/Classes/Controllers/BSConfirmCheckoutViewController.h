//
//  BSConfirmCheckoutViewController.h
//  BASE
//
//  Created by Takkun on 2013/05/15.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPurchaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "GAITrackedViewController.h"
#import "GAI.h"




@interface BSConfirmCheckoutViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

+(NSString*)getShopId;
+(NSString*)getPayment;

@end
