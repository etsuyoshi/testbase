//
//  BSDataAdminViewController.h
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
#import "BSOrderDetailsViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"



@interface BSDataAdminViewController : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource>{
    
    
    
    UITableView *orderListTable;
    NSArray *ordersArray;
    
    UILabel *orderNumberLabel;
    UILabel *pvNumber;
}
- (IBAction)revealMenu:(id)sender;

@end
