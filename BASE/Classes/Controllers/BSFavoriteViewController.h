//
//  BSFavoriteViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/29.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BSDefaultViewObject.h"
#import "BSMainPagingScrollView.h"
#import "BSCategoryView.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "GAITrackedViewController.h"


#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface BSFavoriteViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
+(NSString*)getItemId;
@end
