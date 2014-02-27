//
//  BSAboutItemViewController.h
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
#import "BSShopViewController.h"
#import "BSFavoriteViewController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"

#import <Social/Social.h>
#import <Twitter/Twitter.h>



@interface BSAboutItemViewController : GAITrackedViewController<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>


+(NSString*)getShopId;
+(void)resetShopId;
@property (nonatomic,copy) NSString *importItemId;
@end
