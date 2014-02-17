//
//  BSShopViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/23.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "BSDefaultViewObject.h"
#import "BSMainPagingScrollView.h"
#import "BSCategoryView.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "AFNetworking.h"
#import "BSFavoriteViewController.h"
#import "BSBuyTopViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

#import "ItemTableViewCell.h"





@interface BSShopViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>


+(NSString*)getItemId;
+(NSString*)getShopId;
+(void)resetShopId;
+(void)setItemId:(NSString*)str;
@property(nonatomic) CGFloat beginScrollOffsetY;

@end
