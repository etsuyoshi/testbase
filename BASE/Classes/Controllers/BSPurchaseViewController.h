//
//  BSPurchaseViewController.h
//  BASE
//
//  Created by Takkun on 2013/05/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "BSCartViewController.h"

#import "GAITrackedViewController.h"





@interface BSPurchaseViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

+(NSDictionary*)getCartItem;
+(NSDictionary*)checkCartItem;
@end
