//
//  BSItemAdminViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSDefaultViewObject.h"
#import "BSEditItemViewController.h"
#import "BSTutorialViewController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"





@interface BSItemAdminViewController : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>

-(void)helloDelegate;
+(NSString*)getItemId;
+(void)setItemId:(NSString*)str;
@end
