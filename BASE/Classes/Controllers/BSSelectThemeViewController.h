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


@interface BSSelectThemeViewController : GAITrackedViewController<UIScrollViewDelegate>{
    
    //テーマ画像
    UIImageView *themeImage1;
    UIImageView *themeImage2;
    UIImageView *themeImage3;
    UIImageView *themeImage4;
    UIImageView *themeImage5;
    UIImageView *themeImage6;
    UIImageView *themeImage7;
    UIImageView *themeImage8;
    UIImageView *themeImage9;
    
    //スイッチ
    BOOL clearImageDone1;
    BOOL clearImageDone2;
    BOOL clearImageDone3;
    BOOL clearImageDone4;
    BOOL clearImageDone5;
    BOOL clearImageDone6;
    BOOL clearImageDone7;
    BOOL clearImageDone8;
    BOOL clearImageDone9;
    
    //チェック
    UIImageView *checkImage1;
    UIImageView *checkImage2;
    UIImageView *checkImage3;
    UIImageView *checkImage4;
    UIImageView *checkImage5;
    UIImageView *checkImage6;
    UIImageView *checkImage7;
    UIImageView *checkImage8;
    UIImageView *checkImage9;
    
    //現在のテーマ取得
    NSString *defaultTheme;
    
    //テーマの画像を取得
    NSMutableArray *themeImageArray;
    
    //セレクトビュー
    UIView *selectView;
    
    
}

@end
