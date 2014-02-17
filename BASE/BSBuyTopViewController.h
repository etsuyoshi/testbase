//
//  BSBuyTopViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BSDefaultViewObject.h"
#import "BSMainPagingScrollView.h"
#import "BSCategoryView.h"
#import "AFNetworking.h"
#import "Triangle.h"
#import "UIBarButtonItem+DesignedButton.h"
#import <AdSupport/ASIdentifierManager.h>
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "ShopTableViewCell.h"
#import "ShopTableViewCell2.h"
#import "AppDelegate.h"
#import "BSCustomButton.h"





@interface BSBuyTopViewController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>{
    
    //IBOutlet ShopTableViewCell *shopCell;

    
}
+(NSString*)getShopId;
+(NSString*)getSelectedShopInfo;
+(NSString*)getItemId;

@property(nonatomic,strong)UIScrollView *categoryScrollView;
@property(nonatomic) CGFloat beginScrollOffsetY;
//@property (nonatomic, retain) ShopTableViewCell *shopCell;

@end
