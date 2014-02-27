//
//  BSSettingViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "BSSettingPaymentViewController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"





@interface BSSettingViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource>
{
    
}
- (IBAction)revealMenu:(id)sender;
@property (nonatomic,copy) NSDictionary *importPayment;
//+(NSDictionary*)getPresentPaymentInfo;
@end
