//
//  BSSelectThemeViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "BSDefaultViewObject.h"

#import "SVProgressHUD.h"

#import "GAITrackedViewController.h"
#import "GAI.h"


@interface BSSelectThemeViewController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    //現在のテーマ取得
    NSString *defaultTheme;
    
    //テーマの画像を取得
    NSMutableArray *themeImageArray;
    
    //セレクトビュー
    UIView *selectView;
    
    
}

@end
