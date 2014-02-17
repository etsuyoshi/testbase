//
//  BSOrderDtailsViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "BSDataAdminViewController.h"
#import "UIBarButtonItem+DesignedButton.h"

#import "GAITrackedViewController.h"
#import "GAI.h"





@interface BSOrderDetailsViewController : GAITrackedViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,copy) NSString *importId;

@end
