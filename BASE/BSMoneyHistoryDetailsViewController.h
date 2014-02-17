//
//  BSMoneyHistoryDetailsViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/21.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "UIBarButtonItem+DesignedButton.h"

#import "GAITrackedViewController.h"
#import "GAI.h"


@interface BSMoneyHistoryDetailsViewController : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,copy) NSString *importId;
@end
