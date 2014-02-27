//
//  BSMoneyAdminViewController.h
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

#import "GAITrackedViewController.h"
#import "GAI.h"

@interface BSMoneyAdminViewController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


- (IBAction)revealMenu:(id)sender;

@end
