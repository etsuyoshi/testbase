//
//  BSSettingPaymentViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "BSSettingViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"


@interface BSSettingPaymentViewController : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

//+(NSDictionary*)getPaymentInfo;
@end
