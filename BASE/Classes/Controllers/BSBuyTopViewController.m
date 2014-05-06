//
//  BSBuyTopViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSBuyTopViewController.h"

#import "BSTutorialViewController.h"
#import "UICKeyChainStore.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <ImageIO/ImageIO.h>
#import <MapKit/MapKit.h>
#import "BSTopFooterView.h"
#import "BSItemListView.h"
#import "FollowShopTableViewCell.h"






@interface BSBuyTopViewController ()

@end
@implementation BSBuyTopViewController{
    
    @private
    //バッググラウンド
    UIImageView *backgroundImageView;
    
    int selectedIndex;
    int maxIndex;
    
    BSCategoryView *categoryView;
    
    BSMainPagingScrollView *mainScrollView;
    
    CGRect fullScreenFrame;

    UIActivityIndicatorView *centerLoadingIndicator;
    UIView *smallMenuView;
    //UINavigationBar *navBar;
    
    int visibleMainPageIndex;
    
    //NSString *imageRootUrl;
    
    
    //お気に入りorかごリスト
    UIView *listView;
    
    //吹き出しの三角の部分
    Triangle *triView;
    
    BOOL favoriteIsShowed;
    BOOL cartIsShowed;
    
    UIButton *favoriteBtn;
    UIButton *cartBtn;
    UIScrollView *cartlistScroll;
    UIScrollView *favoritelistScroll;
    NSArray *shop2;
    
    NSMutableArray *favoriteImageIdArray;
    NSMutableArray *favoriteImageNameArray;
    
    NSMutableArray *cartImageIdArray;
    NSMutableArray *cartImageNameArray;
    
    //取得したカテゴリー情報
    NSArray *categoryArray;
    
    //s3のurl
    NSString *s3Url;
    
    UILabel *pvNumber;
    UILabel *orderNumberLabel;
    
    NSString *apiUrl;
    
    //NSMutableArray *categoryInfo;
    
    BOOL categoryScrolled;
    
    BOOL isFullView;
    
    
    //ios7parts
    UINavigationBar *categoryBar;
    
    BSItemListView *itemListView;
    BSTopFooterView *footerView;
    BOOL isOpenedFavoriteView;
    
    BOOL isOffSetToTop;
    float categoryViewOffSetY;
    
    //ホームテーブル
    UITableView *homeTable;
    
    //テーブルビューの動き
    BOOL isLeftMove;
    
    int numberOfShopTables;
    
    NSArray *followShopInfo;
    NSMutableArray *AllFollowShopInfo;
    
    NSString *logoUrl;
    NSString *followItemImageName;
    NSString *maxPage;
    
    BOOL isfinishedLoading;
    
    NSString *apnTokenId;
    
    UIActivityIndicatorView *curationLoadingIndicator;
    UILabel *recommendFollowMessage;
    
    NSMutableArray *shopTableViewContentOffsetYArray;
}
static NSString *importShopId = nil;
static NSString *selectedShopInfo = nil;
static NSString *importItemId = nil;


@synthesize beginScrollOffsetY;
//@synthesize shopCell;
#define TABLE_WIDTH 300

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        AllFollowShopInfo = [NSMutableArray array];

        
        NSLog(@"iPhoneの処理");
        //グーグルアナリティクス
        self.screenName = @"buyTop";
        
        //apiのurl
        apiUrl = [BSDefaultViewObject setApiUrl];
        
        
        //self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
        //[[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
        //[[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
        self.title = @"BASE";

        [self setBackgroundView];
        
        NSString *loadingString = [self setLoadingString];
        
        if ([BSDefaultViewObject isMoreIos7]) {
            [self startCurationLoading:loadingString];
            
        }else{
            
        }
        
        [self setCategoryView];
        
        [self setNavigationBar];

        [self setFooterView];
        
        
        
        //NSMutableArray *category = [NSMutableArray array];

        /*
        for (UIView *subview in [mainScrollView subviews]) {
            [UIView animateWithDuration:0.3 animations:^{
                subview.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }
        
        */

        if ([BSDefaultViewObject isMoreIos7]) {
        }else{

        }
        [self connectGetItems];
        
    }else{
        NSLog(@"iPadの処理");
    }
    
}

- (void)startCurationLoading:(NSString*)curationLoadingString{
    
    curationLoadingIndicator = [[UIActivityIndicatorView alloc] init];
    curationLoadingIndicator.frame = CGRectMake(0, 0, 50, 50);
    curationLoadingIndicator.center = self.view.center;
    curationLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    curationLoadingIndicator.color = [UIColor darkGrayColor];
    [self.view addSubview:curationLoadingIndicator];

    recommendFollowMessage = [[UILabel alloc] initWithFrame:CGRectMake(20,curationLoadingIndicator.frame.size.height + curationLoadingIndicator.frame.origin.y,280,20)];
    recommendFollowMessage.text = curationLoadingString;
    recommendFollowMessage.textColor = [UIColor darkGrayColor];
    recommendFollowMessage.backgroundColor = [UIColor clearColor];
    recommendFollowMessage.textAlignment = NSTextAlignmentCenter;
    recommendFollowMessage.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:recommendFollowMessage];

    
    [curationLoadingIndicator startAnimating];  // アニメーションを開始させたい時に呼ぶ
    
    
    /*
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(-50);
    
    verticalMotionEffect.maximumRelativeValue = @(50);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-50);
    horizontalMotionEffect.maximumRelativeValue = @(50);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [curationLoadingIndicator addMotionEffect:group];
    [recommendFollowMessage addMotionEffect:group];
*/
}
- (void)stopCurationLoading{
    [curationLoadingIndicator stopAnimating];
    [recommendFollowMessage removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        /*
        for (UIView *subview in [mainScrollView subviews]) {
            [UIView animateWithDuration:0.3 animations:^{
                subview.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }
        */
        /*
        UITableView *tableView = (UITableView *)[mainScrollView viewWithTag:100 + categoryArray.count];
        [tableView reloadData];
        */
        
        /*
        if (maxPage == 0){
            AllFollowShopInfo = [NSMutableArray array];
            [self refreshHomeTable:<#(NSString *)#> pages:<#(int)#>]
        }

        */
        
    }else{
        NSLog(@"iPadの処理");
        
        //バッググラウンド
        backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
    }
    
    /*
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            for (UIView *view2 in view.subviews) {
                if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 1) {
                    [view2 setHidden:NO];
                    break;
                }
            }
        }
    }
     */
}

//========================================================================

#pragma mark - refreshTableView

-(void)refreshHomeTable:(NSString*)tokenId pages:(int)pages{
    
    
    // ユニークキーの保持を確認
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSLog(@"[store stringForKeyuniqueKey:%@",[store stringForKey:@"uniqueKey"]);
    NSString *uniqueKey = [store stringForKey:@"uniqueKey"];
    //[UICKeyChainStore setString:signUpPassword.text forKey:@"password" service:@"in.thebase"];
    
    
    NSLog(@"通ったよ");
    
    NSString *urlString;
    if (!uniqueKey) {
        urlString = [NSString stringWithFormat:@"%@/following_shops/get_shop_items?apn_token_id=%@&page=%d",[BSDefaultViewObject setApiUrl],tokenId,pages];
    }else{
        urlString = [NSString stringWithFormat:@"%@/following_shops/get_shop_items?apn_token_id=%@&page=%d&unique_key=%@",[BSDefaultViewObject setApiUrl],tokenId,pages,uniqueKey];
    }
    
    NSLog(@"folllowurlString%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"ホームURL1%@",url1);

    
    
    [[BSBuyerAPIClient sharedClient] getFollowingShopsItemsWithApiTokenId:tokenId uniqueKey:uniqueKey page:pages completion:^(NSDictionary *results, NSError *error) {
        
        
        NSLog(@"ホーム情報！: %@", results);
        NSString *uniqueKey = [results objectForKey:@"unique_key"];
        if (uniqueKey) {
            [store setString:uniqueKey forKey:@"uniqueKey"];
            [store synchronize];
        }
        
        
        
        NSArray *addFollowShopInfo = @[];
        addFollowShopInfo = [results valueForKeyPath:@"result"];
        //NSString *resultString  = [JSON valueForKeyPath:@"result"];
        maxPage = [results valueForKeyPath:@"maxPage"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([maxPage intValue] == 0 && pages > 1) {
            maxPage = @"1";
            followItemImageName = [results valueForKeyPath:@"image_url"];
            logoUrl = [results valueForKeyPath:@"logo_url"];
            //[homeTable reloadData];
            isfinishedLoading = YES;
            
            [self animateShowFooterView];
            [self animateShowHeaderView];
            [self animateDefaultShopTable];
            isFullView = NO;
            return ;
        }
        //NSString *resultString = [JSON valueForKeyPath:@"result"];
        if ([maxPage intValue] == 0) {
            
            followItemImageName = [results valueForKeyPath:@"image_url"];
            logoUrl = [results valueForKeyPath:@"logo_url"];
            NSLog(@"全てのフォロー情報%@",AllFollowShopInfo);
            [homeTable reloadData];
            isfinishedLoading = YES;
            
            [self animateShowFooterView];
            [self animateShowHeaderView];
            [self animateDefaultShopTable];
            isFullView = NO;
            
        }else{
            followItemImageName = [results valueForKeyPath:@"image_url"];
            logoUrl = [results valueForKeyPath:@"logo_url"];
            [AllFollowShopInfo addObject:addFollowShopInfo];
            NSLog(@"全てのフォロー情報%@",AllFollowShopInfo);
            [homeTable reloadData];
            isfinishedLoading = YES;
            
            [self animateShowFooterView];
            [self animateShowHeaderView];
            [self animateDefaultShopTable];
            isFullView = NO;
        }
        
    }];
    
    
}

-(void)finishLoading{
    isfinishedLoading = YES;

}
-(void)firstRefreshHomeTable{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [self refreshHomeTable:apnTokenId pages:1];
}

/*
-(void)addHomeTable pages:(int)pages{
}
 */


//========================================================================
#pragma mark - setView
-(void)setBackgroundView{
    
    //バッググラウンド
    backgroundImageView = [BSDefaultViewObject setBackground];
    if ([BSDefaultViewObject isMoreIos7]) {
        fullScreenFrame = CGRectMake(0, -64, backgroundImageView.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        backgroundImageView.image = nil;
        backgroundImageView.frame = CGRectMake(0, -64, backgroundImageView.frame.size.width, [[UIScreen mainScreen] bounds].size.height + 64);
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        backgroundImageView = [BSDefaultViewObject setBackground];
        fullScreenFrame = CGRectMake(0, -64, backgroundImageView.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        backgroundImageView.frame = fullScreenFrame;
    }
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

}
-(void)setCategoryView{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
        //カテゴリーのスライド
        //-----カテゴリーメニューの作成
        categoryView = [[BSCategoryView alloc] initWithFrame:CGRectMake(0,63,320,40)];
        categoryView.backgroundColor = [UIColor clearColor];
        categoryView.clipsToBounds = YES;
        categoryView.hidden = NO;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [categoryView addGestureRecognizer:tap];
        
        self.categoryScrollView = [[UIScrollView alloc] init];
        self.categoryScrollView.frame = CGRectMake(0,0.0f,320.0f,40.0f);
        self.categoryScrollView.pagingEnabled = YES;
        self.categoryScrollView.showsVerticalScrollIndicator = NO;
        self.categoryScrollView.showsHorizontalScrollIndicator = NO;
        self.categoryScrollView.bounces = YES;
        self.categoryScrollView.alwaysBounceHorizontal = YES;
        self.categoryScrollView.alwaysBounceVertical = NO;
        self.categoryScrollView.backgroundColor = [UIColor clearColor];
        self.categoryScrollView.delegate = self;
        self.categoryScrollView.scrollsToTop = NO;
        self.categoryScrollView.tag = 1;
        self.categoryScrollView.scrollEnabled = YES;
        
        self.navigationController.navigationBar.hidden = NO;
        categoryView.categoryScrollView = self.categoryScrollView;
        
        
        //ios7カテゴリーバー
        categoryBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        categoryBar.translucent = YES;
        categoryBar.alpha = 0.0;
        categoryBar.barTintColor = [UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
        [categoryView addSubview:categoryBar];
        
    }else{
        //カテゴリーのスライド
        //-----カテゴリーメニューの作成
        categoryView = [[BSCategoryView alloc] initWithFrame:CGRectMake(0,-self.navigationController.navigationBar.frame.size.height,320,44)];
        categoryView.backgroundColor = [UIColor clearColor];
        categoryView.clipsToBounds = YES;
        categoryView.hidden = NO;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [categoryView addGestureRecognizer:tap];
        
        self.categoryScrollView = [[UIScrollView alloc] init];
        self.categoryScrollView.frame = CGRectMake(0,0.0f,320.0f,40.0f);
        self.categoryScrollView.pagingEnabled = YES;
        self.categoryScrollView.showsVerticalScrollIndicator = NO;
        self.categoryScrollView.showsHorizontalScrollIndicator = NO;
        self.categoryScrollView.bounces = YES;
        self.categoryScrollView.alwaysBounceHorizontal = YES;
        self.categoryScrollView.alwaysBounceVertical = NO;
        self.categoryScrollView.backgroundColor = [UIColor clearColor];
        self.categoryScrollView.delegate = self;
        self.categoryScrollView.scrollsToTop = NO;
        self.categoryScrollView.tag = 1;
        self.categoryScrollView.scrollEnabled = YES;
        
        self.navigationController.navigationBar.hidden = NO;
        categoryView.categoryScrollView = self.categoryScrollView;
        
        UIImage *categroyImage = [UIImage imageNamed:@"buy_category"];
        UIImageView *categoryImageView = [[UIImageView alloc] initWithImage:categroyImage];
        [categoryView addSubview:categoryImageView];
    }
    
    [categoryView addSubview:self.categoryScrollView];
    
}

-(void)setNavigationBar{
    
    //ナビゲーションバー
    //navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"BASE"];
    if ([BSDefaultViewObject isMoreIos7]) {
        
        
        self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.frame.size.width, 44);
        
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_7_header.png"]];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    }else{
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_header.png"]];
    }
    
    //[self.view addSubview:navBar];
    [self.view insertSubview:categoryView belowSubview:self.navigationController.navigationBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    if ([BSDefaultViewObject isMoreIos7]) {
        leftButton.frame = CGRectMake(-20.0f, 0, 50, 42);
        leftButton.backgroundColor = [UIColor clearColor];

        [leftButton setImage:[UIImage imageNamed:@"icon_7_info.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(aboutApp) forControlEvents:UIControlEventTouchDown];
        UIView * leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
        leftButtonView.backgroundColor = [UIColor clearColor];
        leftButton.tag = 1;
        [leftButtonView addSubview:leftButton];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_7_info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(aboutApp)];
        //[self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"icon_7_info.png"]];
    }else{
        leftButton.frame = CGRectMake(0, 0, 50, 42);
        [leftButton setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(aboutApp) forControlEvents:UIControlEventTouchDown];
        UIView * leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
        leftButtonView.backgroundColor = [UIColor clearColor];
        leftButton.tag = 1;
        [leftButtonView addSubview:leftButton];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    }

    /*
    [leftButton addTarget:self action:@selector(aboutApp) forControlEvents:UIControlEventTouchUpInside];
    UIView * leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
    leftButtonView.backgroundColor = [UIColor clearColor];
    leftButton.tag = 1;
    [leftButtonView addSubview:leftButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    */
    
    
    /*
     UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"売る" style:UIBarButtonItemStyleBordered target:self action:@selector(goSell)];
     navItem.rightBarButtonItem = rightItemButton;
     */
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.backgroundColor = [UIColor clearColor];
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton.frame = CGRectMake(10, 0, 70, 42);
        menuButton.backgroundColor = [UIColor clearColor];
        [menuButton setImage:[UIImage imageNamed:@"icon_7_myshop.png"] forState:UIControlStateNormal];
        
    }else{
        menuButton.frame = CGRectMake(0, 0, 50, 42);
        [menuButton setImage:[UIImage imageNamed:@"icon_myshop.png"] forState:UIControlStateNormal];
        
    }
    [menuButton addTarget:self action:@selector(goSell) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
    menuButtonView.backgroundColor = [UIColor clearColor];
    menuButtonView.userInteractionEnabled = YES;
    [menuButtonView addSubview:menuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    
}

-(void)setFooterView{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
        footerView = [BSTopFooterView setView];
        footerView.frame = CGRectMake(0, self.view.frame.size.height - footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
        [self.view addSubview:footerView];
        
        itemListView = [BSItemListView setView];
        itemListView.frame = CGRectMake(0, self.view.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
        [self.view addSubview:itemListView];
        
        [[footerView.favoriteButton layer] setBorderWidth:0.25f];
        [[footerView.favoriteButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[footerView.cartButton layer] setBorderWidth:0.25f];
        [[footerView.cartButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [footerView.favoriteButton addTarget:self
                                      action:@selector(showFavoriteIOS7:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.cartButton addTarget:self
                                  action:@selector(showCartIOS7:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
      
        // TODO: footerViewの配置を表示
        
        //左下のメニュー
        smallMenuView = [[UIView alloc] init];
        smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 100,90,35);
        smallMenuView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.70f];
        smallMenuView.layer.cornerRadius = 2;
        smallMenuView.layer.masksToBounds = YES;
        [self.view addSubview:smallMenuView];
        
        //吹き出しの三角
        triView = [[Triangle alloc] initWithFrame:CGRectMake(18, [[UIScreen mainScreen] bounds].size.height - 70, 20, 10)];
        triView.alpha = 0.0;
        [self.view addSubview:triView];
        
        //お気に入りorかごのリスト
        listView = [[UIView alloc] init];
        listView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 125,310,55);
        listView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.70f];
        listView.layer.cornerRadius = 2;
        listView.layer.masksToBounds = YES;
        listView.alpha = 0.0;
        [self.view addSubview:listView];
        
        
        
        //スクロール
        favoritelistScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(5,0,300,55)];
        favoritelistScroll.contentSize = CGSizeMake(460,55);
        favoritelistScroll.scrollsToTop = NO;
        favoritelistScroll.hidden = YES;
        [listView addSubview:favoritelistScroll];
        
        
        //スクロール
        cartlistScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(5,0,300,55)];
        cartlistScroll.contentSize = CGSizeMake(460,55);
        cartlistScroll.scrollsToTop = NO;
        cartlistScroll.hidden = YES;
        [listView addSubview:cartlistScroll];
        
        
        
        
        centerLoadingIndicator = [[UIActivityIndicatorView alloc] init];
        centerLoadingIndicator.frame = CGRectMake(0, 0, 50, 50);
        centerLoadingIndicator.center = self.view.center;
        centerLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:centerLoadingIndicator];
        [centerLoadingIndicator startAnimating];  // アニメーションを開始させたい時に呼ぶ
        
        
        
        
        UIImage *starImage = [UIImage imageNamed:@"icon_f_buy_star"];
        favoriteBtn = [[UIButton alloc]
                       initWithFrame:CGRectMake(0, 0, 45, 35)];
        [favoriteBtn setImage:starImage forState:UIControlStateNormal];
        [favoriteBtn addTarget:self
                        action:@selector(showFavorite:) forControlEvents:UIControlEventTouchUpInside];
        favoriteBtn.tag = 1;
        favoriteBtn.backgroundColor = [UIColor clearColor];
        [smallMenuView addSubview:favoriteBtn];
        
        
        UIImage *cartImage = [UIImage imageNamed:@"icon_f_buy_cart"];
        cartBtn = [[UIButton alloc]
                   initWithFrame:CGRectMake(45, 0, 45, 35)];
        [cartBtn setImage:cartImage forState:UIControlStateNormal];
        [cartBtn addTarget:self
                    action:@selector(showCart:) forControlEvents:UIControlEventTouchUpInside];
        cartBtn.tag = 1;
        //cartBtn.backgroundColor = [UIColor blueColor];
        [smallMenuView addSubview:cartBtn];
    }
}
-(NSString*)setLoadingString{
    
    // 現在日付を取得
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    // 年・月・日を取得
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:flags fromDate:now];
    
    //NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    
    return [NSString stringWithFormat:@"%d月%d日のおすすめ商品を取得中",month,day];
    
}

- (void)setShopTable{
    
    
    
    //ショップ+マイショップを並べるtableの数
    numberOfShopTables = categoryArray.count + 1;
    
    [self setDefaultShopTableContentOffsetY:categoryArray.count];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGRect tableBounds = CGRectMake(0, 0, TABLE_WIDTH + 20, height);
    if ([BSDefaultViewObject isMoreIos7]) {
        mainScrollView = [[BSMainPagingScrollView alloc] initWithFrame:CGRectMake(fullScreenFrame.origin.x, 0, fullScreenFrame.size.width, fullScreenFrame.size.height)];
        mainScrollView.contentSize = CGSizeMake((TABLE_WIDTH + 20) * (numberOfShopTables + 1), height);

    }else{
        mainScrollView = [[BSMainPagingScrollView alloc] initWithFrame:CGRectMake(fullScreenFrame.origin.x, -64, fullScreenFrame.size.width, fullScreenFrame.size.height)];
        mainScrollView.contentSize = CGSizeMake((TABLE_WIDTH + 20) * (numberOfShopTables), height);

    }
    
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounds = tableBounds;
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    mainScrollView.tag = 20;
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor clearColor];
    if ([BSDefaultViewObject isMoreIos7])
    {
        mainScrollView.contentOffset = CGPointMake(320 * 3, 0);
    }
    else
    {
        mainScrollView.contentOffset = CGPointMake(320 * 2, 0);
    }
    mainScrollView.scrollsToTop = NO;
    //[self.view insertSubview:mainScrollView belowSubview:categoryView];
    [self.view insertSubview:mainScrollView aboveSubview:backgroundImageView];
    
    
    // ５つのtableViewを横に並べる
    CGRect tableFrame = fullScreenFrame;
    if ([BSDefaultViewObject isMoreIos7]) {
        //tableFrame.origin.y += 0;
        tableFrame.origin.x = 320;

    }else{
        tableFrame.origin.x = 0;
    }
    if ([BSDefaultViewObject isMoreIos7]) {
        //tableFrame.origin.y += 0;
        tableFrame.origin.y += 64;

    }else{
        tableFrame.origin.y += 64;

    }
    for (int i = 0; i < 6; i++) {
        
        if (i + 1 == 6) {
            UITableView *itemTable;
            if ([BSDefaultViewObject isMoreIos7]) {
                itemTable = [[UITableView alloc] initWithFrame:CGRectMake(320 * numberOfShopTables, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height) style:UITableViewStylePlain];
            }else{
                itemTable = [[UITableView alloc] initWithFrame:CGRectMake(320 * (numberOfShopTables - 1), tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height) style:UITableViewStylePlain];
            }
            
            itemTable.dataSource = self;
            itemTable.delegate = self;
            itemTable.scrollEnabled = NO;
            itemTable.scrollsToTop = NO;
            itemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            itemTable.rowHeight = 320.0;
            itemTable.backgroundColor = [UIColor clearColor];
            itemTable.tag = [[NSString stringWithFormat:@"%d",numberOfShopTables - 1] intValue] + 100;
            [mainScrollView addSubview:itemTable];
            
            
        }else{
            UITableView *itemTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
            UINib *nib = [UINib nibWithNibName:@"ShopTableViewCell" bundle:nil];
            [itemTable registerNib:nib forCellReuseIdentifier:@"shopCell"];
            /*
            nib = [UINib nibWithNibName:@"ShopTableViewCell2" bundle:nil];
            [itemTable registerNib:nib forCellReuseIdentifier:@"shopCell2"];
             */
            itemTable.dataSource = self;
            itemTable.delegate = self;
            itemTable.scrollEnabled = YES;
            itemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            itemTable.rowHeight = 320.0;
            itemTable.backgroundColor = [UIColor clearColor];
            itemTable.tag = [[NSString stringWithFormat:@"%d",i] intValue] + 100;
            [mainScrollView addSubview:itemTable];
            
            /*
             UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
             
             verticalMotionEffect.minimumRelativeValue = @(-20);
             
             verticalMotionEffect.maximumRelativeValue = @(20);
             */
            [itemTable reloadData];
        }
        
        tableFrame.origin.x += TABLE_WIDTH + 20;
        
    }
    [self stopCurationLoading];

    [self performSelector:@selector(setHomeTable) withObject:nil afterDelay:1];

    
    
}
- (void)setDefaultShopTableContentOffsetY:(int)numberOfShops{
    
    shopTableViewContentOffsetYArray = [NSMutableArray array];
    for (int x = 0; x < numberOfShopTables; x++) {
        [shopTableViewContentOffsetYArray addObject:@"0"];
    }
    
}

- (void)setHomeTable{
    
    NSLog(@"startSetHomeTable");
    
    [[BSCommonAPIClient sharedClient] getPushNotificationsSettingWithSessionId:nil token:[AppDelegate getDeviceToken] curation:2 order:2 completion:^(NSDictionary *results, NSError *error) {
        
        
        NSLog(@"トークンの取得二回目: %@", results);
   
        apnTokenId = [results valueForKeyPath:@"result.PushNotification.apn_token_id"];
        // 開発モードではapnTokenIdはnull
//        NSLog(@"ぷっしゅのいｄ%@",apnTokenId);
        
        NSString *errorMessage = [results valueForKeyPath:@"error.message"];
        NSLog(@"%@",errorMessage);
        
        //BSBuyTopViewController *apnDelegate = [[BSBuyTopViewController alloc]init];
        //[apnDelegate connectFollowShops];
        //[apnDelegate performSelector:@selector(connectFollowShops) withObject:nil afterDelay:5];
        
        
        
        if ([BSDefaultViewObject isMoreIos7]) {
            homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, backgroundImageView.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
            UINib *nib = [UINib nibWithNibName:@"FollowShopTableViewCell" bundle:nil];
            [homeTable registerNib:nib forCellReuseIdentifier:@"followCell"];
            /*
             nib = [UINib nibWithNibName:@"ShopTableViewCell2" bundle:nil];
             [homeTable registerNib:nib forCellReuseIdentifier:@"shopCell2"];
             */
            
            homeTable.dataSource = self;
            homeTable.delegate = self;
            homeTable.scrollEnabled = YES;
            homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            homeTable.rowHeight = 320.0;
            homeTable.backgroundColor = [UIColor whiteColor];
            homeTable.tag = 10000;
            homeTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            //refreshControl.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
            [mainScrollView addSubview:homeTable];
            
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            [refreshControl addTarget:self action:@selector(initializeHomeTable) forControlEvents:UIControlEventValueChanged];
            [homeTable addSubview:refreshControl];
            //action initializeHomeTable

            //refreshControl.frame = CGRectMake(refreshControl.frame.origin.x, refreshControl.frame.origin.y + 100, refreshControl.frame.size.height, refreshControl.frame.size.width);
            NSLog(@"せいせい");
            isfinishedLoading = YES;
            [self refreshHomeTable:apnTokenId pages:1];
        }
        
        
        
        
    }];
    



}
- (void)initializeHomeTable{
        AllFollowShopInfo = [NSMutableArray array];
        [self refreshHomeTable:apnTokenId pages:1];
}

- (void)setUpScrollView:(NSArray *)titleLabels {
    NSLog(@"setupscroll view");
    //NSLog(@"%@",titleLabels);
    
    int scrollSize = 320;
    int i = 0;
    int offsetX = 0;
    int scrollViewWidth = 0;
    maxIndex = titleLabels.count;
    
    //if our scrollview has already the labels stop here
    if ([self.categoryScrollView subviews].count>0) {
        NSLog(@"category scrollview のサブビューが存在しません");
        self.categoryScrollView.contentOffset = CGPointZero;
        return;
    }
    //get the max width of the labels, which will define our label width
    for (NSString *titleLabel in titleLabels) {
        CGSize expectedLabelSize = [[titleLabel capitalizedString] sizeWithFont:[UIFont fontWithName:@"ArialMT" size:30] constrainedToSize:CGSizeMake(320, 22)];
        scrollViewWidth = MAX(scrollViewWidth,expectedLabelSize.width);
    }
    
    //restrict max width for title items to 106 pixels (to fit 3 labels in the screen)
    //this is optional and can adjusted or removed, but I suggest to make labels equal width
    
    scrollViewWidth = MIN(scrollViewWidth, 106);
    
    //now draw the labels
    for (NSString *titleLabel in titleLabels) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 3, scrollViewWidth, 34)];
        
        label.text = [titleLabel capitalizedString];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"ArialMT" size:13];
        
        if (i==selectedIndex) {
            if ([BSDefaultViewObject isMoreIos7]) {
                label.textColor = [UIColor darkGrayColor];
            }else{
                label.textColor = [UIColor whiteColor];
            }
            label.font = [UIFont systemFontOfSize:13];
        }
        else {
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:10];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 23000+i;
        label.alpha = 0.0;
        [self.categoryScrollView addSubview:label];
        
        
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             categoryBar.alpha = 1.0;
                             label.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        
        offsetX+=scrollViewWidth;
        
        i++;
    }
    
    self.categoryScrollView.frame = CGRectMake((320-scrollViewWidth)/2, 0, scrollViewWidth, 36);
    self.categoryScrollView.clipsToBounds = NO;
    self.categoryScrollView.contentSize = CGSizeMake(MAX(scrollSize,offsetX), 36);
    self.categoryScrollView.contentOffset = CGPointMake(scrollViewWidth*3, 0);
}


#pragma mark - networking
-(void)connectGetItems{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/curations/get_items",apiUrl];
    NSLog(@"urlString%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URL1%@",url1);

    
    [[BSBuyerAPIClient sharedClient] getAllCurationsItemsWithNum:@"30" completion:^(NSDictionary *results, NSError *error) {
        
        
        //カテゴリーを表示させるアニメーション
        [self animateShowCategoryView];
        
        if ([BSDefaultViewObject isMoreIos7]) {
            
        }else{
        }
        [centerLoadingIndicator stopAnimating];
        centerLoadingIndicator = nil;
        NSLog(@"キュレーション情報！: %@", results);
        //NSString *imageRootUrl = [JSON valueForKeyPath:@"image_url"];
        //NSDictionary *result = [JSON valueForKeyPath:@"result"];
        
        //商品画像のurlを取得
        s3Url = [results valueForKeyPath:@"image_url"];
        
        categoryArray = [results valueForKeyPath:@"result.Category"];
        //横スライドのメニューのカテゴリー一覧
        NSMutableArray *categoryInfo = [NSMutableArray array];
        NSString *categoryName;
        for (int n = 0; n < categoryArray.count; n++) {
            
            //カテゴリー名を取得
            //NSDictionary *categoryDict = [categoryArray objectAtIndex:n];
            //NSLog(@"ゼロ番目のcategory:%@",categoryDict);
            
            categoryName= categoryArray[n][@"name"];
            NSLog(@"ゼ名:%@",categoryName);
            [categoryInfo addObject:[NSString stringWithFormat:@"%@",categoryName]];
            
            //NSArray *category = [NSArray arrayWithObjects:@"Shoes",@"Ring",@"MY STORE",@"Food",@"Watch",nil];
            
            /*
             //カテゴリー別商品情報を取得
             NSArray *shopArray = [categoryDict valueForKeyPath:@"Shop"];
             for (int s = 0; s < shopArray.count; s++) {
             //NSDictionary *shopInfo = [];
             }
             */
            
        }
        if ([BSDefaultViewObject isMoreIos7]) {
            [categoryInfo insertObject:@"ホーム" atIndex:0];
        }
        [categoryInfo addObject:[NSString stringWithFormat:@"My Shop"]];
        [self setUpScrollView:categoryInfo];
        
        categoryInfo = nil;
        categoryName = nil;
        
        [self setShopTable];
        
        
    }];
    
}

/*
- (void)connectFollowShops
{
    NSLog(@"≈≈");
    [self refreshHomeTable];
}
*/

#pragma mark - tableViewDelegate
/*************************************テーブルビュー*************************************/
//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == homeTable) {
        NSLog(@"ほーむせくしょんすう%d",AllFollowShopInfo.count);
        
        if ([maxPage intValue] == 0) {
            return 2;
        }
        if (AllFollowShopInfo.count) {
            /*
             */
            return [self getNumberOfSections];
        }
        return 1;
    }
    return 1;
}

- (int)getNumberOfSections{
    NSLog(@"せくしょんとおおたよ");
    int numberOfSections = 0;
    NSMutableArray *numberOfFollowShops = [NSMutableArray array];
    for (int n = 0; n < AllFollowShopInfo.count; n++) {
        numberOfFollowShops = AllFollowShopInfo[n];
        numberOfSections += numberOfFollowShops.count;
    }
    numberOfFollowShops= nil;
    
    return numberOfSections + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        if (tableView == homeTable) {
            
            if (section == 0) {
                return 0;
            }else{
                if ([maxPage intValue] == 0) {
                    return 1;
                }
                if (AllFollowShopInfo.count) {
                    NSLog(@"せくしょんとおおたよ");
                    /*
                    NSArray *numberOfFollowShops = [[[AllFollowShopInfo objectAtIndex:0] objectAtIndex:section - 1] valueForKeyPath:@"Item"];
                    return numberOfFollowShops.count;
                     */
                    return [self getNumberOfRows:section];

                }
                return 2;

            }
        }
    }
    if(tableView.tag == 100 + categoryArray.count)return 1;
    NSDictionary *shopInfo = categoryArray[tableView.tag - 100];
    NSArray *shopArray = shopInfo[@"Shop"];
    NSInteger rows;
    rows = shopArray.count;
    shopArray = nil;
    shopInfo = nil;
    return rows;
}


- (int)getNumberOfRows:(int)section{
    NSLog(@"getNumberOfRows");
    
    //ページを取得
    int page = [self getPageOfSection:section];
    int shopIndex = [self shopIndex:section ];
    NSLog(@"page:%d  shopindex;%d",page,shopIndex);
    
    NSArray *numberOfFollowShops = [AllFollowShopInfo[page][shopIndex] valueForKeyPath:@"Item"];
    return numberOfFollowShops.count;

    /*
    [AllFollowShopInfo objectAtIndex:n];

    
        //一個のpagesの書品を取得
        for (int i = 0; i < numberOfFollowItemArray.count; i++) {
            [[AllFollowShopInfo objectAtIndex:0] objectAtIndex:section - 1]；
        }
    */
}


- (int)getPageOfSection:(int)section{
    
    int page = 0;
    int numberOfSections = 0;
    NSMutableArray *numberOfFollowShops = [NSMutableArray array];
    for (int n = 0; n < AllFollowShopInfo.count; n++) {
        numberOfFollowShops = AllFollowShopInfo[n];
        numberOfSections += numberOfFollowShops.count;
        
        if (numberOfSections >= section) {
            numberOfFollowShops = nil;
            return page;
            
        }
        page++;
    }
    return 0;
}

- (int)shopIndex:(int)section{
    
    int page = 0;
    int numberOfSections = 0;
    int presentOfSections = 0;
    NSMutableArray *numberOfFollowShops = [NSMutableArray array];
    for (int n = 0; n < AllFollowShopInfo.count; n++) {
        numberOfFollowShops = AllFollowShopInfo[n];
        numberOfSections += numberOfFollowShops.count;
        
        if (numberOfSections >= section) {
            numberOfFollowShops = nil;
            int shopIndex = section - (presentOfSections + 1);
            return shopIndex;
        }
        presentOfSections += numberOfFollowShops.count;
        page++;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        if (tableView == homeTable) {
            return 400;
        }
    }
    if(tableView.tag == 100 + categoryArray.count){
        if ([BSDefaultViewObject isMoreIos7]) {
            return 500;  // １番目のセクションの行の高さを30にする
        }
        return 370;  // １番目のセクションの行の高さを30にする
    }else{
        if ([BSDefaultViewObject isMoreIos7]) {
            return 320;  // １番目のセクションの行の高さを30にする
        }else{
            return 320;  // １番目のセクションの行の高さを30にする
        }
    }
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        if (tableView == homeTable) {
            if (section == 0) {
                return 88;
            }else{
                return 60;
            }
        }else{
            return 102;
        }
    }else{
        return 108;

    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == homeTable) {
        
        if (section == 0) {
            UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
            return marginView;
        }else{
            
            
            NSLog(@"ホームテーブルセクションカスタム");
            UINavigationBar *navBar;
            navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,60)];
            navBar.tag = 100000;
            navBar.barTintColor = [UIColor whiteColor];
            for (UIView *view in navBar.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                    for (UIView *view2 in view.subviews) {
                        if ([view2 isKindOfClass:[UIImageView class]] && view2.frame.size.height < 1) {
                            [view2 setHidden:YES];
                            break;
                        }
                    }
                }
            }
            
            if ([maxPage intValue] == 0) {
                return navBar;
            }
            
            UIButton *logoButton = [[UIButton alloc] init];
            logoButton.frame = CGRectMake(5, 5, 50, 50);
            logoButton.backgroundColor = [UIColor clearColor];
            logoButton.alpha = 0.0;
            //logoButton.layer.
            [[logoButton layer] setCornerRadius:25];
            [[logoButton layer] setBorderWidth:0.5];
            [logoButton setClipsToBounds:YES];
            [navBar addSubview:logoButton];
            
            
            int page = [self getPageOfSection:section];
            int shopIndex = [self shopIndex:section ];
            //NSLog(@"page:%d  shopindex;%d",page,shopIndex);
            
            //NSArray *numberOfFollowShops = [[[AllFollowShopInfo objectAtIndex:page] objectAtIndex:shopIndex] valueForKeyPath:@"Item"];
            
            
            if (AllFollowShopInfo.count) {
                logoButton.tag = [[AllFollowShopInfo[page][shopIndex] valueForKeyPath:@"Shop.id"] intValue];
                [logoButton addTarget:self action:@selector(goShopPage:) forControlEvents:UIControlEventTouchUpInside];
                NSString *logoImageName = [AllFollowShopInfo[page][shopIndex] valueForKeyPath:@"Shop.logo"];
                NSLog(@"ロゴ名%@",logoImageName);
                if ([logoImageName isEqualToString:@""]) {
                    logoButton.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:197.0/255.0 blue:183.0/255.0 alpha:1.0];
                }
                NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoImageName];
                //__weak UIButton *weakLogoButton = logoButton;
                [logoButton setImageWithURL:[NSURL URLWithString:url1]
                                   forState:UIControlStateNormal
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      
                                
                                      
                                  }];
                logoImageName = nil;
                url1 = nil;
            }else{
                
            }
            
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^(void){
                                 logoButton.alpha = 1.0;
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            
            
            UILabel *shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((logoButton.frame.origin.x + logoButton.frame.size.width) + 10,5,280,20)];
            shopTitleLabel.center = CGPointMake(shopTitleLabel.center.x, navBar.center.y);
            shopTitleLabel.alpha = 0.0;
            if (AllFollowShopInfo.count) {
                shopTitleLabel.text = [AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Shop.shop_name"];
            }else{
                
            }
            
            shopTitleLabel.textColor = [UIColor colorWithRed:15.0/255.0f green:15.0/255.0f blue:15.0/255.0f alpha:1.0];
            shopTitleLabel.backgroundColor = [UIColor clearColor];
            shopTitleLabel.font = [UIFont boldSystemFontOfSize:18];
            [navBar addSubview:shopTitleLabel];
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^(void){
                                 shopTitleLabel.alpha = 1.0;
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            
            
            
            UILabel *modifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(215,35,100,20)];
            shopTitleLabel.center = CGPointMake(shopTitleLabel.center.x, navBar.center.y);
            modifyLabel.alpha = 0.0;
            if (AllFollowShopInfo.count) {
                modifyLabel.text = [[AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Item"][0] valueForKeyPath:@"updated"];
                
            }else{
                
            }
            
            modifyLabel.textColor = [UIColor grayColor];
            modifyLabel.backgroundColor = [UIColor clearColor];
            modifyLabel.textAlignment = NSTextAlignmentRight;
            modifyLabel.font = [UIFont systemFontOfSize:12];
            [navBar addSubview:modifyLabel];
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^(void){
                                 modifyLabel.alpha = 1.0;
                                 
                             }
                             completion:^(BOOL finished){
                             }];
            /*
             UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"新規商品追加"];
             [navBar pushNavigationItem:navItem animated:YES];
             [self.view addSubview:navBar];
             */
            
            /*
             UIView *containerView = [[UIView alloc] init];
             UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
             button1.frame = CGRectMake(0, 0, 320, 60);
             [button1 setTitle:@"button1" forState:UIControlStateNormal];
             
             [containerView addSubview:button1];
             */
            return navBar;
        }
        
        
    }else{
        UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
        return zeroSizeView;
    }
    
}

//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        if (tableView == homeTable) {
            if (section != 0) {
                return 0.1;
            }
            return 0.1;
        }else{
            return 10;

        }
    }else{
        return 0.1;
    }

}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (tableView == homeTable) {
        UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
        return zeroSizeView;
    }
    UIView *footerMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    [footerMarginView setBackgroundColor:[UIColor clearColor]];
    return footerMarginView;
}
//セクションフッターの高さ変更
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}
*/

//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *itemList = [NSArray arrayWithObjects:@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11", @"12",@"13", @"14", @"15", nil];
    
    /*
    if (tableView.tag != 100 + categoryArray.count) {
    }
     */
    /*
    static NSString *identifier = @"shopCell";
	ShopTableViewCell *shopCell = (ShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
     */
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
        if (tableView == homeTable) {
            NSLog(@"ほーむてぶる%@",homeTable);
            static NSString *CellIdentifier = @"followCell";
            FollowShopTableViewCell *followCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!followCell) {
                NSLog(@"followCell");
                followCell = [[FollowShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                followCell.selectionStyle = UITableViewCellSelectionStyleNone;
                followCell.backgroundColor = [UIColor clearColor];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //}
                
            }
            followCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (UIView *subview in [followCell.contentView subviews]) {
                if (subview.tag == 500) {
                    [subview removeFromSuperview];
                }
            }
            if ([maxPage intValue] == 0) {
                UILabel *norecommendMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5,280,20)];
                norecommendMessageLabel.text = @"ファンになっているお店がありません:(";
                norecommendMessageLabel.textColor = [UIColor darkGrayColor];
                norecommendMessageLabel.backgroundColor = [UIColor clearColor];
                norecommendMessageLabel.textAlignment = NSTextAlignmentCenter;
                norecommendMessageLabel.tag = 500;
                norecommendMessageLabel.font = [UIFont boldSystemFontOfSize:14];
                //[titleItemView addSubview:titleLabel];
                [followCell.contentView addSubview:norecommendMessageLabel];
                [followCell.itemImageView setImage:nil];
                followCell.itemNameLable.text = @"";
                followCell.priceLabel.text = @"";
                followCell.tag = 1000000;
                
                
                UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
                refreshButton.frame = CGRectMake(20, norecommendMessageLabel.frame.origin.y + norecommendMessageLabel.frame.size.height, 280, 55);
                [refreshButton addTarget:self action:@selector(firstRefreshHomeTable)forControlEvents:UIControlEventTouchUpInside];
                [refreshButton setTitle:@"再読込する" forState:UIControlStateNormal];
                refreshButton.tag = 500;
                [followCell.contentView addSubview:refreshButton];
                
                return followCell;
            }
            if (AllFollowShopInfo.count) {
                [followCell.itemImageView setImage:nil];
                int page = [self getPageOfSection:indexPath.section];
                int shopIndex = [self shopIndex:indexPath.section];
                
                followCell.itemNameLable.text = [[AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Item"][indexPath.row] valueForKeyPath:@"title"];
                NSString *cellTag = [[AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Item"][indexPath.row] valueForKeyPath:@"id"];
                followCell.tag = [cellTag intValue];
                
                
                //値段
                NSString *price = [[AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Item"][indexPath.row] valueForKeyPath:@"price"];
                //お金表記
                NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                [nf setCurrencyCode:@"JPY"];
                NSNumber *numPrice = @([price intValue]);
                NSString *strPrice = [nf stringFromNumber:numPrice];
                
                
                followCell.priceLabel.text = strPrice;
                //商品画像
                followCell.itemImageView.alpha = 0.0;

                followCell.number = indexPath.row;
               NSString *itemImageName = [[AllFollowShopInfo[page][shopIndex]valueForKeyPath:@"Item"][indexPath.row] valueForKeyPath:@"image"];
               NSString *url1 = [NSString stringWithFormat:@"%@%@",followItemImageName,itemImageName];
                
                /*
                [followCell.itemImageView setImageWithURL:[NSURL URLWithString:url1]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      
                                      [UIView animateWithDuration:0.6f
                                                            delay:0.0f
                                                          options:UIViewAnimationOptionAllowUserInteraction
                                                       animations:^(void){
                                                           followCell.itemImageView.alpha = 1.0;
                                                           
                                                       }
                                                       completion:^(BOOL finished){
                                                       }];
                                      
                                  }];
                price = nil;
                strPrice = nil;
                itemImageName = nil;
                url1 = nil;
                */
                
                
                
                
        
                
                
                
                
                NSError* err = nil;
                NSRegularExpression* regex = nil;
                
                // 検索する文字列
                NSString* string = itemImageName;
                
                // 正規表現オブジェクト作成
                regex = [NSRegularExpression regularExpressionWithPattern:@"^sp"
                                                                  options:0
                                                                    error:&err];
                
                // 比較
                NSTextCheckingResult *match = [regex firstMatchInString:string
                                                                options:0
                                               
                                                                  range:NSMakeRange(0, string.length)];
                if (!match) {
                    // マッチした時の処理
                    NSLog(@"origineモード");
                    NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                    [followCell.itemImageView setImage:nil];
                    
                    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"Response: %@", responseObject);

                        UIImage *getImage = responseObject;
                        
                        int imageW = getImage.size.width;
                        int imageH = getImage.size.height;
                        //float resizeAcpect;
                        NSLog(@"オリジナル w:%d,h:%d",imageW,imageH);
                        
                        //画像をはみ出して（フル画面）中央表示
                        if (imageW < imageH) {
                            //縦長の場合
                            imageH = imageH * 330 / imageW;
                            imageW = 330;
                            
                            //resizeAcpect = 320 / imageW  * 100;
                            //resizeAcpect = 320/(float)imageW * 100;
                            
                        }else{
                            NSLog(@"横長だよ！");
                            imageW = imageW * 330 / imageH;
                            imageH = 330;
                            
                            //resizeAcpect = 320/(float)imageH * 100;
                            //resizeAcpect = 320 / imageW * 100;
                        }
                        
                        
                        //NSLog(@"ばいいりｎ%f",resizeAcpect);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [self resizeAspectFitImageWithImage:getImage atSize:200.0f imageWidth:imageW imageHeight:imageH completion:^(UIImage *resultImg){
                                followCell.itemImageView.clipsToBounds = YES;
                                //shopCell.shopImageButton.imageView.backgroundColor = [UIColor blueColor];
                                //shopCell.shopImageButton.contentMode = UIViewContentModeScaleAspectFill;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (followCell.number == indexPath.row) {
                                        [followCell.itemImageView setImage:resultImg];
                                        
                                        //shopCell.shopImageButton.imageView.backgroundColor = [UIColor redColor];
                                        
                                        followCell.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
                                        
                                        //shopCell.shopImageButton.imageView.center = CGPointMake(shopCell.shopImageButton.frame.size.width / 2, shopCell.shopImageButton.frame.size.height / 2);
                                        
                                        //shopCell.shopImageButton.clipsToBounds = YES;
                                        //shopCell.shopImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                                        
                                        [UIView animateWithDuration:0.6f
                                                              delay:0.0f
                                                            options:UIViewAnimationOptionAllowUserInteraction
                                                         animations:^(void){
                                                             followCell.itemImageView.alpha = 1.0;
                                                             
                                                         }
                                                         completion:^(BOOL finished){
                                                         }];
                                    }
                                });
                                
                                
                                
                            }];
                        });
                        getImage = nil;
                        
                        NSLog(@"変更指示 w:%d,h:%d",imageW,imageH);
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Image error: %@", error);
                    }];
                    [requestOperation start];

  
                    // get the og:image URL from the find result
                }else{
                    
                    [followCell.itemImageView setImageWithURL:[NSURL URLWithString:url1]
                                             placeholderImage:nil
                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                                        
                                                        [UIView animateWithDuration:0.6f
                                                                              delay:0.0f
                                                                            options:UIViewAnimationOptionAllowUserInteraction
                                                                         animations:^(void){
                                                                             followCell.itemImageView.alpha = 1.0;
                                                                             
                                                                         }
                                                                         completion:^(BOOL finished){
                                                                         }];
                                                        
                                                    }];
                    price = nil;
                    strPrice = nil;
                    itemImageName = nil;
                    url1 = nil;
                    
                    
                }
             
            }
            
            return followCell;
        }
    }
    
    
    
    if (!(tableView.tag == 100 + categoryArray.count)) {
        
        static NSString *CellIdentifier = @"shopCell";
        ShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!shopCell) {
            shopCell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
            shopCell.backgroundColor = [UIColor clearColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            
            
            //}
            
        }
    
        shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //見えているビューにcscrollToTopを有効にする
        [self changeScrollableTableView:tableView];

        if (tableView.tag != 100 + categoryArray.count) {
            
            
            //ショップ情報を取得
            NSDictionary *shopInfo = categoryArray[tableView.tag - 100];
            NSArray *shopArray = shopInfo[@"Shop"];
            
            //for (int x = 0; x < shopArray.count; x++) {
            //if (indexPath.row == x) {
            NSLog(@"%d回目エラーになるよ！%@",indexPath.row,shopArray);
            
            NSDictionary *itemInfo = shopArray[indexPath.row];
            /*
             //ボタン
             //UIImage *image = [UIImage imageNamed:@"itemm1.jpg"];
             BSCustomButton *shopBtn_ = [[BSCustomButton alloc]
             initWithFrame:CGRectMake(10, 5, 300, 300)];
             __weak BSCustomButton *shopBtn = shopBtn_;
             //[shopBtn setBackgroundImage:nil forState:UIControlStateNormal];
             //shopBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
             //shopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
             //shopBtn.imageView.frame = CGRectMake(0, 0, 320, 320);
             //shopBtn.imageView.contentMode = UIViewContentModeScaleToFill;
             //shopBtn.imageView.clipsToBounds = YES;
             [shopBtn setBackgroundImage:nil forState:UIControlStateNormal];
             [shopBtn addTarget:self
             action:@selector(goShopPage:) forControlEvents:UIControlEventTouchUpInside];
             shopBtn.tag = [[itemInfo objectForKey:@"id"] intValue];
             shopBtn.alpha = 0.0;
             if (shopBtn) {
             shopBtn.row = [indexPath row] + 1;
             shopBtn.line = visibleMainPageIndex + 1;
             //shopBtn.category = [categoryInfo objectAtIndex:visibleMainPageIndex];
             
             }
             */
            //[cell addSubview:shopBtn];
            
            
            //ショップ説明のバックグランドイメージ
            /*
             UIImage *titleImage = [UIImage imageNamed:@"shoptitle_base"];
             UIImageView *titleItemView = [[UIImageView alloc] initWithImage:titleImage];
             titleItemView.frame = CGRectMake(10, 249, 300, 56);
             UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,280,20)];
             titleLabel.text = [itemInfo objectForKey:@"shop_name"];
             titleLabel.textColor = [UIColor whiteColor];
             titleLabel.backgroundColor = [UIColor clearColor];
             titleLabel.font = [UIFont boldSystemFontOfSize:18];
             [titleItemView addSubview:titleLabel];
             */
            //[cell addSubview:titleItemView];
            
            shopCell.shopTitleLabel.text = itemInfo[@"shop_name"];
            /*
             //シャドウをかける
             shopBtn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
             // 影の透明度
             shopBtn.layer.shadowOpacity = 0.6f;
             // 影の色
             shopBtn.layer.shadowColor = [UIColor blackColor].CGColor;
             // ぼかしの量
             shopBtn.layer.shadowRadius = 4.0f;
             UIBezierPath *path = [UIBezierPath bezierPathWithRect:shopBtn.bounds];
             shopBtn.layer.shadowPath = path.CGPath;
             */
            
            /*
             shopBtn.layer.shadowOffset = CGSizeMake(0, 0);
             shopBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
             shopBtn.layer.shadowRadius = 2.0f;
             shopBtn.layer.shadowOpacity = 0.60f;
             shopBtn.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shopBtn.layer.bounds] CGPath];
             */
            //ショップ説明
            /*
             UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,30,280,20)];
             aboutLabel.text = [itemInfo objectForKey:@"shop_introduction"];
             aboutLabel.textColor = [UIColor lightGrayColor];
             aboutLabel.backgroundColor = [UIColor clearColor];
             aboutLabel.font = [UIFont boldSystemFontOfSize:12];
             [titleItemView addSubview:aboutLabel];
             */
            
            shopCell.shopAboutLable.text = itemInfo[@"shop_introduction"];
            
            NSString *imageName = [itemInfo valueForKeyPath:@"Item.image"];
            NSString *url1 = [NSString stringWithFormat:@"%@%@",s3Url,imageName];
            
            NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
            
            NSLog(@"画像名%@",imageName);
            //UIImageView *nilimage = [UIImageView new];
            
            NSError* err = nil;
            NSRegularExpression* regex = nil;
            
            // 検索する文字列
            NSString* string = imageName;
            
            // 正規表現オブジェクト作成
            regex = [NSRegularExpression regularExpressionWithPattern:@"^sp"
                                                              options:0
                                                                error:&err];
            
            // 比較
            NSTextCheckingResult *match = [regex firstMatchInString:string
                                                            options:0
                                           
                                                              range:NSMakeRange(0, string.length)];
            
            shopCell.tag = [itemInfo[@"id"] intValue];
            /*
             [shopCell.shopImageButton setBackgroundImage:nil forState:UIControlStateNormal];
             shopCell.shopImageButton.alpha = 0.0;
             [shopCell.shopImageButton addTarget:self
             action:@selector(goShopPage:) forControlEvents:UIControlEventTouchUpInside];
             shopCell.shopImageButton.tag = [[itemInfo objectForKey:@"id"] intValue];
             [shopCell.shopImageButton setImage:nil forState:UIControlStateNormal];
             */
            shopCell.shopImageButton.alpha = 0.0;
            /*
             [shopCell.shopImageButton addTarget:self
             action:@selector(goShopPage:) forControlEvents:UIControlEventTouchUpInside];
             */
            shopCell.shopImageButton.tag = [itemInfo[@"id"] intValue];
            [shopCell.shopImageButton setImage:nil];
            if (!match) {
                // マッチした時の処理
                shopCell.number = indexPath.row;
                NSLog(@"origineモード");
                [shopCell.shopImageButton setImage:nil];
    
                
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Response: %@", responseObject);

                    UIImage *getImage = responseObject;
                    
                    int imageW = getImage.size.width;
                    int imageH = getImage.size.height;
                    //float resizeAcpect;
                    NSLog(@"オリジナル w:%d,h:%d",imageW,imageH);
                    
                    //画像をはみ出して（フル画面）中央表示
                    if (imageW < imageH) {
                        //縦長の場合
                        imageH = imageH * 330 / imageW;
                        imageW = 330;
                        
                        //resizeAcpect = 320 / imageW  * 100;
                        //resizeAcpect = 320/(float)imageW * 100;
                        
                    }else{
                        NSLog(@"横長だよ！");
                        imageW = imageW * 330 / imageH;
                        imageH = 330;
                        
                        //resizeAcpect = 320/(float)imageH * 100;
                        //resizeAcpect = 320 / imageW * 100;
                    }
                    
                    
                    //NSLog(@"ばいいりｎ%f",resizeAcpect);
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self resizeAspectFitImageWithImage:getImage atSize:200.0f imageWidth:imageW imageHeight:imageH completion:^(UIImage *resultImg){
                            shopCell.shopImageButton.clipsToBounds = YES;
                            //shopCell.shopImageButton.imageView.backgroundColor = [UIColor blueColor];
                            //shopCell.shopImageButton.contentMode = UIViewContentModeScaleAspectFill;
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (shopCell.number == indexPath.row) {
                                    [shopCell.shopImageButton setImage:resultImg];
                                    [shopCell setNeedsLayout];
                                    
                                    shopCell.shopImageButton.contentMode = UIViewContentModeScaleAspectFill;
                                    
                                    //shopCell.shopImageButton.imageView.center = CGPointMake(shopCell.shopImageButton.frame.size.width / 2, shopCell.shopImageButton.frame.size.height / 2);
                                    
                                    //shopCell.shopImageButton.clipsToBounds = YES;
                                    //shopCell.shopImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                                    
                                    [UIView animateWithDuration:0.6f
                                                          delay:0.0f
                                                        options:UIViewAnimationOptionAllowUserInteraction
                                                     animations:^(void){
                                                         shopCell.shopImageButton.alpha = 1.0;
                                                         
                                                     }
                                                     completion:^(BOOL finished){
                                                     }];
                                }
                            });
                            
                            
                            //shopCell.shopImageButton.imageView.backgroundColor = [UIColor redColor];
                            
                            
                            resultImg = nil;
                            
                        }];
                    });
                    getImage = nil;
                    
                    NSLog(@"変更指示 w:%d,h:%d",imageW,imageH);
                    
                    /*
                     shopCell.shopImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                     shopCell.shopImageButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                     */
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
                
                
                // get the og:image URL from the find result
            }else{
                shopCell.number = indexPath.row;
                NSLog(@"spモード");
                shopCell.shopImageButton.contentMode = UIViewContentModeScaleAspectFill;
                __weak UIImageView *shopButton = shopCell.shopImageButton;

                

                    [shopButton setImageWithURL:[NSURL URLWithString:url1]
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                          
                                          image = nil;
                                          dispatch_async(dispatch_get_main_queue(), ^{

                                          if (shopCell.number == indexPath.row) {

                                          [UIView animateWithDuration:0.6f
                                                                delay:0.0f
                                                              options:UIViewAnimationOptionAllowUserInteraction
                                                           animations:^(void){
                                                               shopButton.alpha = 1.0;
                                                               
                                                           }
                                                           completion:^(BOOL finished){
                                                           }];
                                          }

                                      });

                                      }];

                    [shopCell setNeedsLayout];

                
                
                
                
            }
            

        }

    /*
    for (UIView *subview in [cell subviews]) {

        [subview removeFromSuperview];
    }
    */
    
    //for (int n = 0; n < categoryArray.count; n++) {
    
    
    
    
        return shopCell;

    
}else if (tableView.tag == 100 + categoryArray.count) {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        
        //}
        
    }
    
        if (indexPath.row == 0) {
            for (UIView *subview in [cell.contentView subviews]) {
     
                [subview removeFromSuperview];
            }
            UIImage *backgroundImage;
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
     
                UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
     
                NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
                NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
                NSString *email = [store stringForKey:@"email"];
     
                if (!email) {
                    //最初の場合
                    backgroundImage = [UIImage imageNamed:@"bnr_open-568h@2x.png"];
                    UIButton *shopBtn = [[UIButton alloc]
                                         initWithFrame:CGRectMake(0, -5, 320, 460)];
                    [shopBtn setImage:backgroundImage forState:UIControlStateNormal];
                    [shopBtn addTarget:self
                                action:@selector(goSell) forControlEvents:UIControlEventTouchUpInside];
                    //shopBtn.tag = [[itemInfo objectForKey:@"id"] intValue];
                    shopBtn.alpha = 0.0;
                    //shopBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                    shopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    //shopBtn.imageView.frame = CGRectMake(0, 0, 320, 320);
                    shopBtn.imageView.contentMode = UIViewContentModeScaleToFill;
                    //shopBtn.imageView.clipsToBounds = YES;
                    [cell.contentView addSubview:shopBtn];
                    
                    
                    [UIView animateWithDuration:0.8f
                                          delay:0.0f
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^(void){
                                         shopBtn.alpha = 1.0;
                                     }
                     
                                     completion:^(BOOL finished){
                                         
                                     }];
                    
                    
                    
                }else{
                    //[BSTutorialViewController autoLogin:@"buy"];
                    
                    [[BSUserManager sharedManager] autoSignInWithBlock:^(NSError *error) {
                        
                        
                        UIView *pvView = [[UIView alloc] init];
                        pvView.frame = CGRectMake(20,20,130,80);
                        pvView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.65f];
                        [[pvView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
                        [[pvView layer] setBorderWidth:1.0];
                        [cell.contentView addSubview:pvView];
                        
                        UIView *orderView = [[UIView alloc] init];
                        orderView.frame = CGRectMake(170,20,130,80);
                        [[orderView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
                        [[orderView layer] setBorderWidth:1.0];
                        orderView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:241.0f/255.0f blue:252.0f/255.0f alpha:0.65f];
                        [cell.contentView addSubview:orderView];
                        
                        UILabel *todayPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
                        todayPvLabel.text = @"今日のPV";
                        todayPvLabel.textAlignment = NSTextAlignmentLeft;
                        todayPvLabel.font = [UIFont boldSystemFontOfSize:14];
                        todayPvLabel.shadowColor = [UIColor whiteColor];
                        todayPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        todayPvLabel.backgroundColor = [UIColor clearColor];
                        todayPvLabel.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:todayPvLabel];
                        
                        UILabel *totalPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
                        totalPvLabel.text = @"/累計PV";
                        totalPvLabel.textAlignment = NSTextAlignmentRight;
                        totalPvLabel.font = [UIFont boldSystemFontOfSize:14];
                        totalPvLabel.shadowColor = [UIColor whiteColor];
                        totalPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        totalPvLabel.backgroundColor = [UIColor clearColor];
                        totalPvLabel.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:totalPvLabel];
                        
                        pvNumber = [[UILabel alloc] initWithFrame:CGRectMake(0,50,130,22)];
                        pvNumber.text = @"0/0";
                        pvNumber.textAlignment = NSTextAlignmentCenter;
                        pvNumber.font = [UIFont boldSystemFontOfSize:14];
                        pvNumber.shadowColor = [UIColor whiteColor];
                        pvNumber.shadowOffset = CGSizeMake(0.f, 1.f);
                        pvNumber.backgroundColor = [UIColor clearColor];
                        pvNumber.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:pvNumber];
                        
                        
                        UILabel *ordersItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
                        ordersItemLabel.text = @"未発送個数";
                        ordersItemLabel.textAlignment = NSTextAlignmentLeft;
                        ordersItemLabel.font = [UIFont boldSystemFontOfSize:14];
                        ordersItemLabel.shadowColor = [UIColor whiteColor];
                        ordersItemLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        ordersItemLabel.backgroundColor = [UIColor clearColor];
                        ordersItemLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:ordersItemLabel];
                        
                        UILabel *totalItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
                        totalItemsLabel.text = @"/累計売上個数";
                        totalItemsLabel.textAlignment = NSTextAlignmentRight;
                        totalItemsLabel.font = [UIFont boldSystemFontOfSize:14];
                        totalItemsLabel.shadowColor = [UIColor whiteColor];
                        totalItemsLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        totalItemsLabel.backgroundColor = [UIColor clearColor];
                        totalItemsLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:totalItemsLabel];
                        
                        orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,50,120,22)];
                        orderNumberLabel.text = @"0/0";
                        orderNumberLabel.textAlignment = NSTextAlignmentCenter;
                        orderNumberLabel.font = [UIFont boldSystemFontOfSize:14];
                        orderNumberLabel.shadowColor = [UIColor whiteColor];
                        orderNumberLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        orderNumberLabel.backgroundColor = [UIColor clearColor];
                        orderNumberLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:orderNumberLabel];
                        
                        
                        
                        //「ログイン」ボタン
                        UIImage *loginImage;
                        if ([BSDefaultViewObject isMoreIos7]) {
                            loginImage = [UIImage imageNamed:@"btn_7_03.png"];
                            
                        }else{
                            loginImage = [UIImage imageNamed:@"btn_03.png"];
                            
                        }
                        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        loginButton.frame = CGRectMake(0, 0, 288, 55);
                        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                        //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                        [loginButton addTarget:self action:@selector(goSell)forControlEvents:UIControlEventTouchUpInside];
                        loginButton.center = CGPointMake(160, 160);
                        [cell.contentView addSubview:loginButton];
                        //[self.view addSubview:loginButton];
                        
                        
                        if ([BSDefaultViewObject isMoreIos7]) {
                            //「ログイン」ラベル
                            UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,50)];
                            loginLabel.text = @"お店を管理する";
                            loginLabel.textAlignment = NSTextAlignmentCenter;
                            loginLabel.center = CGPointMake(144, 27.5);
                            loginLabel.font = [UIFont boldSystemFontOfSize:18];
                            loginLabel.backgroundColor = [UIColor clearColor];
                            loginLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:164.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
                            [loginButton addSubview:loginLabel];
                        }else{
                            //「ログイン」ラベル
                            UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,50)];
                            loginLabel.text = @"お店を管理する";
                            loginLabel.textAlignment = NSTextAlignmentCenter;
                            loginLabel.center = CGPointMake(144, 27.5);
                            loginLabel.font = [UIFont boldSystemFontOfSize:18];
                            loginLabel.shadowColor = [UIColor whiteColor];
                            loginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                            loginLabel.backgroundColor = [UIColor clearColor];
                            loginLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:164.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
                            [loginButton addSubview:loginLabel];
                        }
                        
                        
                        
                        NSString *session_id = [BSUserManager sharedManager].sessionId;
                        NSString *urlString;
                        NSURL *url;
                        NSMutableURLRequest *request;
                        
                        urlString = [NSString stringWithFormat:@"%@/data/get_pv?session_id=%@&=",apiUrl,session_id];
                        url = [NSURL URLWithString:urlString];
                        
                        [[BSSellerAPIClient sharedClient] getDataPVWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                            
                            NSLog(@"getDataPVWithSessionId:%@",results);
                            NSDictionary *pvResult1 = [results valueForKeyPath:@"result"];
                            NSDictionary *pvResult2 = [pvResult1 valueForKeyPath:@"Data"];
                            NSString *allPV = [pvResult2 valueForKeyPath:@"pv_all"];
                            NSString *todayPV = [pvResult2 valueForKeyPath:@"pv_today"];
                            
                            
                            
                            
                            pvNumber.text = [NSString stringWithFormat:@"%d/%d",[todayPV intValue],[allPV intValue]];
                            
                        }];
                        
                        
                        
                        
                        
                        
                        [[BSSellerAPIClient sharedClient] getDataDispatchStatusWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                            
                            
                            NSDictionary *dispatchResult1 = [results valueForKeyPath:@"result"];
                            NSDictionary *dispatchResult2 = [dispatchResult1 valueForKeyPath:@"Data"];
                            NSLog(@"ddddu%@",dispatchResult1);
                            
                            if ([[dispatchResult2 allKeys] containsObject:@"dispatched"]) {
                                // 存在する場合の処理
                                NSString *dispatched = [dispatchResult2 valueForKeyPath:@"dispatched"];
                                NSString *undispatched = [dispatchResult2 valueForKeyPath:@"undispatched"];
                                orderNumberLabel.text = [NSString stringWithFormat:@"%d/%d",[undispatched intValue],[dispatched intValue] + [undispatched intValue]];
                                
                            }
                            
                        }];
                        
                    }];
                    
                    
                    
                    
                }
                
                    
                
                
    
                
            }
            else
            {
                UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
                
                NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
                NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
                NSString *email = [store stringForKey:@"email"];
                
                if (!email) {
                    //最初の場合
                    backgroundImage = [UIImage imageNamed:@"bnr_open@2x.png"];
                    
                    UIButton *shopBtn = [[UIButton alloc]
                                         initWithFrame:CGRectMake(0, -3, 320, 365)];
                    [shopBtn setImage:backgroundImage forState:UIControlStateNormal];
                    [shopBtn addTarget:self
                                action:@selector(goSell) forControlEvents:UIControlEventTouchUpInside];
                    //shopBtn.tag = [[itemInfo objectForKey:@"id"] intValue];
                    shopBtn.alpha = 0.0;
                    //shopBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                    shopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    //shopBtn.imageView.frame = CGRectMake(0, 0, 320, 320);
                    shopBtn.imageView.contentMode = UIViewContentModeScaleToFill;
                    //shopBtn.imageView.clipsToBounds = YES;
                    [cell.contentView addSubview:shopBtn];
                    
                    [UIView animateWithDuration:0.8f
                                          delay:0.0f
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^(void){
                                         shopBtn.alpha = 1.0;
                                     }
                     
                                     completion:^(BOOL finished){
                                         
                                     }];

                    
                    
                    
                }else{
                    //[BSTutorialViewController autoLogin:@"buy"];
                    
                    [[BSUserManager sharedManager] autoSignInWithBlock:^(NSError *error) {
                        
                        
                        UIView *pvView = [[UIView alloc] init];
                        pvView.frame = CGRectMake(20,20,130,80);
                        pvView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.65f];
                        [[pvView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
                        [[pvView layer] setBorderWidth:1.0];
                        [cell.contentView addSubview:pvView];
                        
                        UIView *orderView = [[UIView alloc] init];
                        orderView.frame = CGRectMake(170,20,130,80);
                        [[orderView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
                        [[orderView layer] setBorderWidth:1.0];
                        orderView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:241.0f/255.0f blue:252.0f/255.0f alpha:0.65f];
                        [cell addSubview:orderView];
                        
                        UILabel *todayPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
                        todayPvLabel.text = @"今日のPV";
                        todayPvLabel.textAlignment = NSTextAlignmentLeft;
                        todayPvLabel.font = [UIFont boldSystemFontOfSize:14];
                        todayPvLabel.shadowColor = [UIColor whiteColor];
                        todayPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        todayPvLabel.backgroundColor = [UIColor clearColor];
                        todayPvLabel.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:todayPvLabel];
                        
                        UILabel *totalPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
                        totalPvLabel.text = @"/累計PV";
                        totalPvLabel.textAlignment = NSTextAlignmentRight;
                        totalPvLabel.font = [UIFont boldSystemFontOfSize:14];
                        totalPvLabel.shadowColor = [UIColor whiteColor];
                        totalPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        totalPvLabel.backgroundColor = [UIColor clearColor];
                        totalPvLabel.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:totalPvLabel];
                        
                        pvNumber = [[UILabel alloc] initWithFrame:CGRectMake(0,50,130,22)];
                        pvNumber.text = @"0/0";
                        pvNumber.textAlignment = NSTextAlignmentCenter;
                        pvNumber.font = [UIFont boldSystemFontOfSize:14];
                        pvNumber.shadowColor = [UIColor whiteColor];
                        pvNumber.shadowOffset = CGSizeMake(0.f, 1.f);
                        pvNumber.backgroundColor = [UIColor clearColor];
                        pvNumber.textColor = [UIColor darkGrayColor];
                        [pvView addSubview:pvNumber];
                        
                        
                        UILabel *ordersItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
                        ordersItemLabel.text = @"未発送個数";
                        ordersItemLabel.textAlignment = NSTextAlignmentLeft;
                        ordersItemLabel.font = [UIFont boldSystemFontOfSize:14];
                        ordersItemLabel.shadowColor = [UIColor whiteColor];
                        ordersItemLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        ordersItemLabel.backgroundColor = [UIColor clearColor];
                        ordersItemLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:ordersItemLabel];
                        
                        UILabel *totalItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
                        totalItemsLabel.text = @"/累計売上個数";
                        totalItemsLabel.textAlignment = NSTextAlignmentRight;
                        totalItemsLabel.font = [UIFont boldSystemFontOfSize:14];
                        totalItemsLabel.shadowColor = [UIColor whiteColor];
                        totalItemsLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        totalItemsLabel.backgroundColor = [UIColor clearColor];
                        totalItemsLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:totalItemsLabel];
                        
                        orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,50,120,22)];
                        orderNumberLabel.text = @"0/0";
                        orderNumberLabel.textAlignment = NSTextAlignmentCenter;
                        orderNumberLabel.font = [UIFont boldSystemFontOfSize:14];
                        orderNumberLabel.shadowColor = [UIColor whiteColor];
                        orderNumberLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        orderNumberLabel.backgroundColor = [UIColor clearColor];
                        orderNumberLabel.textColor = [UIColor darkGrayColor];
                        [orderView addSubview:orderNumberLabel];
                        
                        
                        
                        //「ログイン」ボタン
                        UIImage *loginImage = [UIImage imageNamed:@"btn_03.png"];
                        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        loginButton.frame = CGRectMake(0, 0, 288, 55);
                        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                        //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                        [loginButton addTarget:self action:@selector(goSell)forControlEvents:UIControlEventTouchUpInside];
                        loginButton.center = CGPointMake(160, 160);
                        [cell.contentView addSubview:loginButton];
                        //[self.view addSubview:loginButton];
                        
                        //「ログイン」ラベル
                        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,50)];
                        loginLabel.text = @"お店を管理する";
                        loginLabel.textAlignment = NSTextAlignmentCenter;
                        loginLabel.center = CGPointMake(144, 27.5);
                        loginLabel.font = [UIFont boldSystemFontOfSize:18];
                        loginLabel.shadowColor = [UIColor whiteColor];
                        loginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                        loginLabel.backgroundColor = [UIColor clearColor];
                        loginLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:164.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
                        [loginButton addSubview:loginLabel];
                        
                        
                        
                        [[BSSellerAPIClient sharedClient] getDataPVWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                            
                            NSLog(@"getDataPVWithSessionId:%@",results);
                            NSDictionary *pvResult1 = [results valueForKeyPath:@"result"];
                            NSDictionary *pvResult2 = [pvResult1 valueForKeyPath:@"Data"];
                            NSString *allPV = [pvResult2 valueForKeyPath:@"pv_all"];
                            NSString *todayPV = [pvResult2 valueForKeyPath:@"pv_today"];
                            
                            
                            
                            
                            pvNumber.text = [NSString stringWithFormat:@"%d/%d",[todayPV intValue],[allPV intValue]];
                            
                        }];
                        
                        
                        
                        [[BSSellerAPIClient sharedClient] getDataDispatchStatusWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                            
                            NSDictionary *dispatchResult1 = [results valueForKeyPath:@"result"];
                            NSDictionary *dispatchResult2 = [dispatchResult1 valueForKeyPath:@"Data"];
                            NSLog(@"valueForKeyPath:Data:%@",dispatchResult1);
                            
                            if ([[dispatchResult2 allKeys] containsObject:@"dispatched"]) {
                                // 存在する場合の処理
                                NSString *dispatched = [dispatchResult2 valueForKeyPath:@"dispatched"];
                                NSString *undispatched = [dispatchResult2 valueForKeyPath:@"undispatched"];
                                orderNumberLabel.text = [NSString stringWithFormat:@"%d/%d",[undispatched intValue],[dispatched intValue] + [undispatched intValue]];
                                
                            }
                            
                            
                        }];

                        
                        
                    }];
                    
                    
                }
            }
            
            return cell;
        }
}else{
    return nil;

}
    


}

//
-(void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([maxPage intValue] == [self getPageOfSection:indexPath.section]) {
        return;
    }
    //NSArray *numberOfFollowShops;
    if (AllFollowShopInfo.count) {
        /*
        int page = [self getPageOfSection:indexPath.section];
        numberOfFollowShops = [AllFollowShopInfo objectAtIndex:page];
         */
        //NSLog(@"section数%d",numberOfFollowShops.count);
        if ([self getNumberOfSections] - 1 == indexPath.section) {
            NSLog(@"最後のsectionだよ");

            //numberOfFollowShops = [[[AllFollowShopInfo objectAtIndex:0] objectAtIndex:indexPath.section - 1] valueForKeyPath:@"Item"];
            if ([self getNumberOfRows:indexPath.section] - 1 == indexPath.row && isfinishedLoading) {
                isfinishedLoading = NO;
                [self refreshHomeTable:apnTokenId pages:AllFollowShopInfo.count + 1];
                NSLog(@"最後のセルだよ");
                
            }
        }
        
    }
    
    
}
//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 100 + categoryArray.count){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == homeTable) {
        [self goItem:cell.tag];
    }else{
        [self goShop:cell.tag];
    }
    
}


//========================================================================

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    self.beginScrollOffsetY = [scrollView contentOffset].y;
    categoryViewOffSetY = categoryView.frame.origin.y;
    NSLog(@"始まり:%f",self.beginScrollOffsetY);
    NSLog(@"categoryViewOffSetY%f",categoryViewOffSetY);

    //isOffSetToTop
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"スクロールの距離%f",scrollView.contentOffset.y);
    NSLog(@"self.beginScrollOffsetY%f",self.beginScrollOffsetY);
    NSLog(@"動いた分%f",scrollView.contentOffset.y  - self.beginScrollOffsetY);
    
    /*
        itemListView.frame = CGRectMake(0, itemListView.frame.origin.y - (scrollView.contentOffset.y  - self.beginScrollOffsetY), itemListView.frame.size.width, itemListView.frame.size.height);
    return;
    */
    
    //メインスクロールビュー
    if (scrollView.tag == 20) {
        [self animateMainScrollView:scrollView];
    }
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        if (scrollView.tag >= 100){
            NSLog(@"%@",scrollView);
            if (scrollView.tag == 10000) {
                if (60 > [scrollView contentOffset].y) {
                    [self animateHideHeaderView];
                    [self animateHideFooterView];
                    [self animateFullShopTable];
                    isFullView = YES;
                    return;
                    
                }
            }
            if (60 > [scrollView contentOffset].y) {
                    [self animateShowHeaderView];
                    [self animateDefaultShopTable];
                    isFullView = NO;
                    return;
                
            }
            
            if (scrollView.tag == 10000) {
                
                if (self.beginScrollOffsetY < [scrollView contentOffset].y
                    && !categoryView.hidden && !isFullView) {
                    NSLog(@"うごいているお");
                    //スクロール前のオフセットよりスクロール後が多い=下を見ようとした =>スクロールバーを隠す
                    [self animateHideFooterView];
                    [self animateHideHeaderView];
                    [self animateFullShopTable];
                    isFullView = YES;
                } else if ([scrollView contentOffset].y < self.beginScrollOffsetY
                           && 0.0 != self.beginScrollOffsetY && !isFullView) {
                    
                    
                    NSLog(@"スクロールを止めた時");
                    [self animateHideFooterView];
                    [self animateHideHeaderView];
                    [self animateFullShopTable];
                    isFullView = YES;
                }
                
            }else{
                if (self.beginScrollOffsetY < [scrollView contentOffset].y
                    && !categoryView.hidden && !isFullView) {
                    NSLog(@"うごいているお");
                    //スクロール前のオフセットよりスクロール後が多い=下を見ようとした =>スクロールバーを隠す
                    [self animateHideFooterView];
                    [self animateHideHeaderView];
                    [self animateFullShopTable];
                    isFullView = YES;
                } else if ([scrollView contentOffset].y < self.beginScrollOffsetY
                           && 0.0 != self.beginScrollOffsetY && isFullView) {
                    
                    
                    NSLog(@"スクロールを止めた時");
                    [self animateShowFooterView];
                    [self animateShowHeaderView];
                    [self animateDefaultShopTable];
                    isFullView = NO;
                }
            }
            
        }
        
        
    }else{
        //テーブルをするロールさせたときのアニメーション
        if (scrollView.tag >= 100){
            NSLog(@"%@",scrollView);
            if (60 > [scrollView contentOffset].y) {
              
                    [self animateShowHeaderView];
                    [self animateDefaultShopTable];
                    isFullView = NO;
                    return;
                
                
            }
            if (self.beginScrollOffsetY < [scrollView contentOffset].y
                && !categoryView.hidden && !isFullView) {
                NSLog(@"うごいているお");
                //スクロール前のオフセットよりスクロール後が多い=下を見ようとした =>スクロールバーを隠す
                [self animateHideHeaderView];
                [self animateFullShopTable];
                isFullView = YES;
            } else if ([scrollView contentOffset].y < self.beginScrollOffsetY
                       && 0.0 != self.beginScrollOffsetY && isFullView) {
                
                NSLog(@"スクロールを止めた時");
                [self animateShowHeaderView];
                [self animateDefaultShopTable];
                isFullView = NO;
            }
        }
    }
    
    
    
    
    
    //カテゴリーをスクロールさせたとき
    if(scrollView.tag == 1) {
        //get the index of the label we scrolled into!
        visibleMainPageIndex = round(scrollView.contentOffset.x/scrollView.bounds.size.width);
        NSLog(@"visiblePageIndex:%d",visibleMainPageIndex);
        NSLog(@"カテゴリーを動かしたvisiblePageIndex:%d",visibleMainPageIndex);

        //set page number..
        if (selectedIndex!=visibleMainPageIndex) {
            
            if((visibleMainPageIndex - selectedIndex) < 0){
                isLeftMove = YES;
            }else if((visibleMainPageIndex - selectedIndex) > 0){
                isLeftMove = NO;
            }
            [self arrangeShopTableView];

            NSLog(@"カテゴリースクロール左:%d",isLeftMove);
            //get the label and set it to red
            UILabel *label = (UILabel*)[self.categoryScrollView viewWithTag:23000+visibleMainPageIndex];
            if ([BSDefaultViewObject isMoreIos7]) {
                label.textColor = [UIColor darkGrayColor];
            }else{
                label.textColor = [UIColor whiteColor];
            }
            label.font = [UIFont systemFontOfSize:13];
            NSLog(@"label%@",label);
            //文字の位置変更

            //get the previous Label and set it back to White
            UILabel *oldLabel = (UILabel*)[self.categoryScrollView viewWithTag:23000+selectedIndex];
            oldLabel.textColor = [UIColor lightGrayColor];
            oldLabel.font =[UIFont systemFontOfSize:10];
            //set the new index to the index holder
            selectedIndex = visibleMainPageIndex;
            //メインのスクロールを動かす

            

                for (UIView *subview in [mainScrollView subviews]) {
                    subview.alpha = 0.0;
                }
            
            [UIView animateWithDuration:0.4 animations:^{
                
                mainScrollView.contentOffset = CGPointMake(320 * visibleMainPageIndex,0);

            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    for (UIView *subview in [mainScrollView subviews]) {
                        subview.alpha = 1.0;
                    }
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"とまった%d",scrollView.tag);
    [self animateShowHeaderView];
    [self animateShowFooterView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        appFrame.origin.y -= 20;
        //[[self view] setFrame:appFrame];
        //mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        
        /*
         for (UIView *subview in [mainScrollView subviews]) {
         if ([subview isKindOfClass:[UITableView class]]) {
         subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
         }
         
         }
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        isFullView = NO;
    }];

}




- (void)scrollHeaderView:(float)contentOfsetY{
    
    /*
    int intContentOfsetY = (int)categoryView.frame.origin.y - (int)contentOfsetY;
    int test = (int)contentOfsetY;
    NSLog(@"ナビゲーションの幅%d",intContentOfsetY);
    if (intContentOfsetY <= 63) {
        categoryView.frame = CGRectMake(categoryView.frame.origin.x, categoryViewOffSetY - contentOfsetY,  categoryView.frame.size.width, categoryView.frame.size.height);
    }
     */
}
-(void)changeScrollableTableView:(UITableView*)tableView{
    
    for (UITableView *view in [mainScrollView subviews]) {
        if (tableView == view) {
            tableView.scrollsToTop = YES;
        }else{
            if ([view isKindOfClass:[UITableView class]]) {
                view.scrollsToTop = NO;
            }
        }
    }
    
}



//========================================================================
#pragma mark - arrangeShopTableView
- (void)arrangeShopTableView{
    //visibleMainPageIndexが3の時shopTableTagが102
    if (numberOfShopTables <= visibleMainPageIndex + 2) {
        NSLog(@"同じ所");
        return;
    }else if (2 >= visibleMainPageIndex){
        return;

    }
    if ([BSDefaultViewObject isMoreIos7]) {
        if(isLeftMove){
            
            
            if (numberOfShopTables - 3 == visibleMainPageIndex){
                NSLog(@"同じ所sssss%d",numberOfShopTables - 2 == visibleMainPageIndex);
                return;
            }
            
            
            NSLog(@"左に動いた%d",isLeftMove);
            if (visibleMainPageIndex < 3) {
                return;
            }
            /*
             UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex - 4)];
             moveTableView.frame = CGRectMake(moveTableView.frame.origin.x + (moveTableView.frame.size.width * 4), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
             */
            UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex + 2)];
            shopTableViewContentOffsetYArray[visibleMainPageIndex + 2] = [NSString stringWithFormat:@"%d",(int)moveTableView.contentOffset.y];
            NSLog(@"shopTableViewContentOffsetYArray:\n%@",shopTableViewContentOffsetYArray);
            
            moveTableView.frame = CGRectMake(moveTableView.frame.origin.x - (moveTableView.frame.size.width * 5), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
            moveTableView.tag = 100 + (visibleMainPageIndex - 3);
            
            int moveTableViewContentOffsetY = [shopTableViewContentOffsetYArray[visibleMainPageIndex - 3] intValue];
            moveTableView.delegate = nil;
            moveTableView.contentOffset = CGPointMake(moveTableView.contentOffset.x, moveTableViewContentOffsetY);
            moveTableView.delegate = self;

            //[self changeShopTableViewContentOffsetY:(visibleMainPageIndex - 3)];
            [moveTableView reloadData];
            
        }else{
            
            if (visibleMainPageIndex < 4 || categoryArray.count <= visibleMainPageIndex + 1) {
                return;
            }
            NSLog(@"右に動いた%d",visibleMainPageIndex);
            UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex - 4)];
            shopTableViewContentOffsetYArray[visibleMainPageIndex - 4] = [NSString stringWithFormat:@"%d",(int)moveTableView.contentOffset.y];
            NSLog(@"shopTableViewContentOffsetYArray:\n%@",shopTableViewContentOffsetYArray);


            moveTableView.frame = CGRectMake(moveTableView.frame.origin.x + (moveTableView.frame.size.width * 5), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
            moveTableView.tag = 100 + (visibleMainPageIndex + 1);
            
            int moveTableViewContentOffsetY = [shopTableViewContentOffsetYArray[visibleMainPageIndex + 1] intValue];
            moveTableView.delegate = nil;
            moveTableView.contentOffset = CGPointMake(moveTableView.contentOffset.x, moveTableViewContentOffsetY);
            moveTableView.delegate = self;

            [moveTableView reloadData];
            
        }
    }else{
        if(isLeftMove){
            
            
            if (numberOfShopTables - 3 == visibleMainPageIndex){
                NSLog(@"同じ所sssss%d",numberOfShopTables - 2 == visibleMainPageIndex);
                return;
            }
            
            NSLog(@"左に動いた%d",isLeftMove);
            /*
             UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex - 4)];
             moveTableView.frame = CGRectMake(moveTableView.frame.origin.x + (moveTableView.frame.size.width * 4), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
             */
            UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex + 2)];
            moveTableView.frame = CGRectMake(moveTableView.frame.origin.x - (moveTableView.frame.size.width * 5), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
            moveTableView.tag = 100 + (visibleMainPageIndex - 3);
            [moveTableView reloadData];
            
        }else{
            
            NSLog(@"右に動いた%d",visibleMainPageIndex);
            UITableView *moveTableView = (UITableView*)[mainScrollView viewWithTag:100 + (visibleMainPageIndex - 4)];
            moveTableView.frame = CGRectMake(moveTableView.frame.origin.x + (moveTableView.frame.size.width * 5), moveTableView.frame.origin.y, moveTableView.frame.size.width,moveTableView.frame.size.height);
            moveTableView.tag = 100 + (visibleMainPageIndex + 1);
            [moveTableView reloadData];
            
        }
    }
    


}


//========================================================================
#pragma mark - animation
- (void)animateShowCategoryView{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        [UIView animateWithDuration:0.4 animations:^{
            //NSLog(@"てすてす%@",response.allHeaderFields);
            categoryView.frame = CGRectMake(0.0f, 63, 320.0f, 60.0f);
        } completion:^(BOOL finished) {
        }];
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            //NSLog(@"てすてす%@",response.allHeaderFields);
            categoryView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 60.0f);
        } completion:^(BOOL finished) {
        }];
    }
    
    
}

-(void)animateMainScrollView:(UIScrollView *)scrollView {

    NSLog(@"ofset:%f",self.categoryScrollView.contentOffset.x);
    visibleMainPageIndex = round(scrollView.contentOffset.x/scrollView.bounds.size.width);
    NSLog(@"visibleMainPageIndexだよ:%d",visibleMainPageIndex);
    
    if (selectedIndex!=visibleMainPageIndex) {
        
        if((visibleMainPageIndex - selectedIndex) < 0){
            isLeftMove = YES;
        }else if((visibleMainPageIndex - selectedIndex) > 0){
            isLeftMove = NO;
        }

        //get the label and set it to red
        UILabel *label = (UILabel*)[self.categoryScrollView viewWithTag:23000+visibleMainPageIndex];
        if ([BSDefaultViewObject isMoreIos7]) {
            label.textColor = [UIColor darkGrayColor];
        }else{
            label.textColor = [UIColor whiteColor];
        }
        label.font = [UIFont systemFontOfSize:13];
        NSLog(@"%@",label);
        /*
         if (label.tag == 23004) {
         label.frame = CGRectMake(424, 5, 130, 34);
         }
         */
        //get the previous Label and set it back to White
        UILabel *oldLabel = (UILabel*)[self.categoryScrollView viewWithTag:23000+selectedIndex];
        oldLabel.textColor = [UIColor lightGrayColor];
        oldLabel.font =[UIFont systemFontOfSize:10];
        
        //set the new index to the index holder
        selectedIndex = visibleMainPageIndex;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.categoryScrollView.contentOffset = CGPointMake(106 * visibleMainPageIndex, 0);
            NSLog(@"カテゴリーのいち%@",self.categoryScrollView);
            
        } completion:^(BOOL finished) {
            //ヘッダー表示アニメーション
            [self animateShowHeaderView];
            [self animateDefaultShopTable];
            isFullView = NO;
        }];
        [self arrangeShopTableView];


        
    }
    
}
- (void)animateShowFooterView{
    NSLog(@"フッターを表示");
    if ([BSDefaultViewObject isMoreIos7]) {
        if (footerView.frame.origin.y < (self.view.frame.size.height - footerView.frame.size.height)) {
            return;
        }
        [UIView animateWithDuration:0.4 animations:^{
            
            if (itemListView.frame.origin.y >= (self.view.frame.size.height + itemListView.frame.size.height)) {
                itemListView.frame = CGRectMake(itemListView.frame.origin.x, self.view.frame.size.height - itemListView.frame.size.height,  itemListView.frame.size.width, itemListView.frame.size.height);
                footerView.frame = CGRectMake(footerView.frame.origin.x, self.view.frame.size.height - (footerView.frame.size.height + itemListView.frame.size.height),  footerView.frame.size.width, footerView.frame.size.height);
            }else{
                footerView.frame = CGRectMake(footerView.frame.origin.x, self.view.frame.size.height - footerView.frame.size.height,  footerView.frame.size.width, footerView.frame.size.height);
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}
- (void)animateHideFooterView{
    NSLog(@"フッターを表示");

    if ([BSDefaultViewObject isMoreIos7]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (itemListView.frame.origin.y < self.view.frame.size.height) {
                itemListView.frame = CGRectMake(itemListView.frame.origin.x, self.view.frame.size.height + footerView.frame.size.height,  itemListView.frame.size.width, itemListView.frame.size.height);
            }
            footerView.frame = CGRectMake(footerView.frame.origin.x, self.view.frame.size.height,  footerView.frame.size.width, footerView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
}
//ヘッダを表示するアニメーション
- (void)animateShowHeaderView{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        [UIView animateWithDuration:0.4 animations:^{
            
            //navBar.frame = CGRectMake(0,0,320,44);
            //self.navigationController.navigationBar.frame = CGRectMake(0,0,320,64);
            //categoryView.frame = CGRectMake(0.0f, 64, 320.0f, 44.0f);
            self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x, 20,  self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, 64,  categoryView.frame.size.width, categoryView.frame.size.height);
            
            
        } completion:^(BOOL finished) {
            
        }];

    }else{
        [UIView animateWithDuration:0.4 animations:^{
            
            //navBar.frame = CGRectMake(0,0,320,44);
            self.navigationController.navigationBar.frame = CGRectMake(0,20,320,44);
            categoryView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 40.0f);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
//ヘッダを隠すアニメーション
- (void)animateHideHeaderView{

    if ([BSDefaultViewObject isMoreIos7]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x, 0 - (self.navigationController.navigationBar.frame.size.height + categoryView.frame.size.height),  self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
            categoryView.frame = CGRectMake(categoryView.frame.origin.x, 0 - categoryView.frame.size.height,  categoryView.frame.size.width, categoryView.frame.size.height);
            if (itemListView.frame.origin.y < self.view.frame.size.height) {
                itemListView.frame = CGRectMake(itemListView.frame.origin.x, self.view.frame.size.height + footerView.frame.size.height,  itemListView.frame.size.width, itemListView.frame.size.height);
            }
            footerView.frame = CGRectMake(footerView.frame.origin.x, self.view.frame.size.height,  footerView.frame.size.width, footerView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = categoryView.frame;
            categoryView.frame = CGRectMake(0,
                                            -self.navigationController.navigationBar.frame.size.height*2 - 20,
                                            rect.size.width,
                                            rect.size.height);
            self.navigationController.navigationBar.frame = CGRectMake(0,-64,320,44);
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

//通常時のショップテーブルアニメーション
- (void)animateDefaultShopTable{
    
    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        //[[self view] setFrame:appFrame];
        //mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        
        for (UIView *subview in [mainScrollView subviews]) {
            if ([subview isKindOfClass:[UITableView class]]) {
                if (subview == homeTable) {
                    subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 20);
                    break ;
                }
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
            }
        }
        
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];

}

//ショップテーブルを全画面にするアニメーション
- (void)animateFullShopTable{

    backgroundImageView.frame = CGRectMake(backgroundImageView.frame.origin.x, -64,backgroundImageView.frame.size.width,backgroundImageView.frame.size.height);
    
    [UIView animateWithDuration:0.1 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = YES;
        
        //[[self view] setFrame:appFrame];
        smallMenuView.alpha = 0;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 0;
            listView.alpha = 0;
        }
        
        /*
        for (UIView *subview in [mainScrollView subviews]) {
            if ([subview isKindOfClass:[UITableView class]]) {
                subview.frame = CGRectMake(subview.frame.origin.x, 0, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
            }
        }
         */
    
    } completion:^(BOOL finished) {
    }];
    
}

- (void)labelTapped:(UITapGestureRecognizer*)gestureRecognizer {
    

    
    
    CGPoint pressPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (pressPoint.x>(self.categoryScrollView.frame.size.width+self.view.frame.size.width)/2) {
        //move to next page if one is available...
        if (selectedIndex+1<maxIndex) {
            float currentOffset = self.categoryScrollView.contentOffset.x+self.categoryScrollView.frame.size.width;
            [self.categoryScrollView setContentOffset:CGPointMake(currentOffset, 0) animated:YES];
        }
    }
    else if (pressPoint.x<(self.view.frame.size.width-self.categoryScrollView.frame.size.width)/2) {
        //move to previous page if one is available
        if (selectedIndex>0) {
            float currentOffset = self.categoryScrollView.contentOffset.x-self.categoryScrollView.frame.size.width;
            [self.categoryScrollView setContentOffset:CGPointMake(currentOffset, 0) animated:YES];
        }
    }
}



#pragma mark - pushNextView
//店舗詳細に行く
-(void)goShopPage:(id)sender{
    
    //NSLog(@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category);
    //selectedShopInfo = [NSString stringWithFormat:@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category];
    
    
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    NSLog(@"しょっぷID:%d",[sender tag]);
    importShopId = [NSString stringWithFormat:@"%d",[sender tag]];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shop"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self animateShowHeaderView];

    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        appFrame.origin.y -= 20;
        /*
        [[self view] setFrame:appFrame];
        mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    /*
    for (UIView *subview in [mainScrollView subviews]) {
        [UIView animateWithDuration:0.3 animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
     */
}


-(void)goShop:(int)cellTag{
    
    //NSLog(@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category);
    //selectedShopInfo = [NSString stringWithFormat:@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category];
    
    
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    NSLog(@"しょっぷID:%d",cellTag);
    importShopId = [NSString stringWithFormat:@"%d",cellTag];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shop"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self animateShowHeaderView];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        appFrame.origin.y -= 20;
        /*
         [[self view] setFrame:appFrame];
         mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    /*
    for (UIView *subview in [mainScrollView subviews]) {
        [UIView animateWithDuration:0.3 animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
     */
}

-(void)goItem:(int)cellTag{
    
    //NSLog(@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category);
    //selectedShopInfo = [NSString stringWithFormat:@"%d列目、%d行目、カテゴリー:%@",button.line,button.row,button.category];
    
    if (cellTag == 1000000) {
        return;
    }
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    NSLog(@"しょっぷID:%d",cellTag);
    importItemId = [NSString stringWithFormat:@"%d",cellTag];
    //importShopId = [NSString stringWithFormat:@"%d",cellTag];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutItem"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [self animateShowHeaderView];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        appFrame.origin.y -= 20;
        /*
         [[self view] setFrame:appFrame];
         mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    /*
    for (UIView *subview in [mainScrollView subviews]) {
        [UIView animateWithDuration:0.3 animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
     */
}




- (void)showCartIOS7:(id)sender{
    
    for (UIView *view in itemListView.itemScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (itemListView.frame.origin.y == self.view.frame.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"お気に入り一覧表示");
            footerView.cartButton.layer.borderWidth = 0.0f;
            [footerView.cartButton setTintColor:[UIColor colorWithRed:25.0/255.0f green:148.0/255.0f blue:250.0/255.0f alpha:1.0]];
            [footerView.cartButton setImage:[UIImage imageNamed:@"icon_7_b_buy_cart"] forState:UIControlStateNormal];
            [footerView.favoriteButton setTintColor:[UIColor lightGrayColor]];
            [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_f_buy_star"] forState:UIControlStateNormal];


            footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y - itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
            itemListView.frame = CGRectMake(0, self.view.frame.size.height - itemListView.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
            
            footerView.favoriteButton.backgroundColor = [UIColor grayColor];
            footerView.cartButton.backgroundColor = [UIColor whiteColor];

            
        } completion:^(BOOL finished) {
            isOpenedFavoriteView = NO;
            
        }];
        
    }else{
        if (!isOpenedFavoriteView) {
            [UIView animateWithDuration:0.2 animations:^{
                NSLog(@"アニメーションしてるよ");
                footerView.cartButton.layer.borderWidth = 0.25f;
                footerView.favoriteButton.layer.borderWidth = 0.25f;
                [footerView.cartButton setTintColor:[UIColor lightGrayColor]];
                [footerView.cartButton setImage:[UIImage imageNamed:@"icon_7_f_buy_cart"] forState:UIControlStateNormal];

                footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y + itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
                itemListView.frame = CGRectMake(0, self.view.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
                
                footerView.favoriteButton.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                isOpenedFavoriteView = NO;
                
            }];
        }else{
            NSLog(@"お気に入り一覧が開いている時");
            [UIView animateWithDuration:0.2 animations:^{
                NSLog(@"アニメーションしてるよ");
                footerView.cartButton.layer.borderWidth = 0.0f;
                [footerView.cartButton setTintColor:[UIColor colorWithRed:25.0/255.0f green:148.0/255.0f blue:250.0/255.0f alpha:1.0]];
                [footerView.cartButton setImage:[UIImage imageNamed:@"icon_7_b_buy_cart"] forState:UIControlStateNormal];
                [footerView.favoriteButton setTintColor:[UIColor lightGrayColor]];
                [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_f_buy_star"] forState:UIControlStateNormal];

                footerView.favoriteButton.backgroundColor = [UIColor grayColor];
                footerView.cartButton.backgroundColor = [UIColor whiteColor];

                
            } completion:^(BOOL finished) {
                isOpenedFavoriteView = NO;
                
            }];
        }
        
    }
    
    [itemListView.detailButton removeTarget:self
                                     action:nil forControlEvents:UIControlEventTouchUpInside];
    [itemListView.detailButton addTarget:self
                                  action:@selector(goCart:) forControlEvents:UIControlEventTouchUpInside];
    
    cartImageIdArray = [NSMutableArray array];
    cartImageNameArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *cartArray = [userDefaults arrayForKey:@"cart"];
    NSLog(@"カート情報:%@",cartArray);
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (int n = 0; n < cartArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        NSDictionary *cartItemInfo = cartArray[n];
        NSString *itemId = cartItemInfo[@"itemId"];
        mdic[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
    }
    
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    mdic[@"version"] = version;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_items",apiUrl]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSLog(@"カート情報！: %@", responseObject);
        NSDictionary *error = [responseObject valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeFavoriteViewIOS7:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (void)showCart:(id)sender{
    for (UIView *view in cartlistScroll.subviews) {
        [view removeFromSuperview];
    }
    
    cartImageIdArray = [NSMutableArray array];
    cartImageNameArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *cartArray = [userDefaults arrayForKey:@"cart"];
    NSLog(@"カート情報:%@",cartArray);
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (int n = 0; n < cartArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        NSDictionary *cartItemInfo = cartArray[n];
        NSString *itemId = cartItemInfo[@"itemId"];
        mdic[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
    }
    
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    mdic[@"version"] = version;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_items",apiUrl]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"お気に入り情報！: %@", responseObject);
        NSDictionary *error = [responseObject valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeCartView:responseObject];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    if (favoriteIsShowed) {
        cartlistScroll.hidden = NO;
        favoritelistScroll.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_cart_s"];
        [cartBtn setImage:image forState:UIControlStateNormal];
        UIImage *image2 = [UIImage imageNamed:@"icon_f_buy_star"];
        [favoriteBtn setImage:image2 forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            triView.frame = CGRectMake(68, smallMenuView.frame.origin.y + smallMenuView.frame.size.height, 10, 10);
        } completion:^(BOOL finished) {
            cartIsShowed = YES;
            favoriteIsShowed = NO;
            return ;
        }];
    }
    if (cartIsShowed) {
        cartIsShowed = NO;
        cartlistScroll.hidden = NO;
        favoritelistScroll.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_cart"];
        [cartBtn setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 100,90,35);
            triView.alpha = 0.0;
            listView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }else{
        cartIsShowed = YES;
        cartlistScroll.hidden = NO;
        favoritelistScroll.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_cart_s"];
        [cartBtn setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 170,90,35);
            triView.alpha = 1.0;
            listView.alpha = 1.0;
            triView.frame = CGRectMake(68, smallMenuView.frame.origin.y + smallMenuView.frame.size.height, 10, 10);
        } completion:^(BOOL finished) {
        }];
    }
}


- (void)arrangeCartView:(id)jsonData{
    
    NSArray *itemArray = jsonData[@"result"];
    NSString *imageUrl = jsonData[@"image_url"];
    NSLog(@"あいてむすう: %d", itemArray.count);
    
    
    
    UIButton *goCartBtn = [[UIButton alloc]
                           initWithFrame:CGRectMake(5, 5, 45, 45)];
    goCartBtn.backgroundColor = [UIColor clearColor];
    //[goCartBtn setBackgroundImage:[UIImage imageNamed:@"icon_f_buy_more.png"] forState:UIControlStateNormal];
    [goCartBtn addTarget:self
                  action:@selector(goCart:) forControlEvents:UIControlEventTouchUpInside];
    goCartBtn.tag = 1;
    [cartlistScroll addSubview:goCartBtn];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_f_buy_more.png"]];
    listImageView.frame = CGRectMake(8.5, 8.5, 28, 28);
    [goCartBtn addSubview:listImageView];
    
    cartlistScroll.contentSize = CGSizeMake(50 * itemArray.count + 55,55);
    cartlistScroll.bounces = YES;
    for (int n = 0; n < itemArray.count; n++) {
        NSDictionary *itemRoot = itemArray[n];
        NSDictionary *item = itemRoot[@"Item"];
        
        NSString *itemImageName = item[@"img"];
        NSString *itemId = item[@"id"];
        
        [cartImageIdArray addObject:itemId];
        [cartImageNameArray addObject:itemImageName];
        
        UIImageView *itemView = [[UIImageView alloc] initWithImage:nil];
        itemView.frame = CGRectMake(60 + 50 * n, 5, 45, 45);
        [cartlistScroll addSubview:itemView];
        
        NSString *url1 = [NSString stringWithFormat:@"%@%@",imageUrl,itemImageName];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        NSLog(@"画像のurl%@",url1);
        if (url1) {
        
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", responseObject);
                [itemView setImage:responseObject];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
            
        }
    }

}

- (void)showFavoriteIOS7:(id)sender{

    
    if (itemListView.frame.origin.y == self.view.frame.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"お気に入り一覧表示");
            footerView.favoriteButton.layer.borderWidth = 0.0f;
            [footerView.favoriteButton setTintColor:[UIColor colorWithRed:25.0/255.0f green:148.0/255.0f blue:250.0/255.0f alpha:1.0]];
            [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_b_buy_star"] forState:UIControlStateNormal];

            footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y - itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
            itemListView.frame = CGRectMake(0, self.view.frame.size.height - itemListView.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
            
            footerView.cartButton.backgroundColor = [UIColor grayColor];
            footerView.favoriteButton.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            isOpenedFavoriteView = YES;

        }];
        
    }else{
        if (isOpenedFavoriteView) {
            [UIView animateWithDuration:0.2 animations:^{
                NSLog(@"アニメーションしてるよ");
                footerView.favoriteButton.layer.borderWidth = 0.25f;
                footerView.cartButton.layer.borderWidth = 0.25f;
                [footerView.favoriteButton setTintColor:[UIColor lightGrayColor]];
                [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_f_buy_star"] forState:UIControlStateNormal];

                footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y + itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
                itemListView.frame = CGRectMake(0, self.view.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
                
                footerView.cartButton.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                isOpenedFavoriteView = NO;

            }];
        }else{
            NSLog(@"カート一覧が開いている時");
            [UIView animateWithDuration:0.2 animations:^{
                NSLog(@"アニメーションしてるよ");
                footerView.favoriteButton.layer.borderWidth = 0.0f;
                [footerView.favoriteButton setTintColor:[UIColor colorWithRed:25.0/255.0f green:148.0/255.0f blue:250.0/255.0f alpha:1.0]];
                [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_b_buy_star"] forState:UIControlStateNormal];

                [footerView.cartButton setTintColor:[UIColor lightGrayColor]];
                [footerView.cartButton setImage:[UIImage imageNamed:@"icon_7_f_buy_cart"] forState:UIControlStateNormal];
                footerView.cartButton.backgroundColor = [UIColor grayColor];
                footerView.favoriteButton.backgroundColor = [UIColor whiteColor];

            } completion:^(BOOL finished) {
                isOpenedFavoriteView = YES;

            }];
        }
        
    }
    [itemListView.detailButton removeTarget:self
                                     action:nil forControlEvents:UIControlEventTouchUpInside];
    [itemListView.detailButton addTarget:self
                                  action:@selector(goFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (UIView *view in itemListView.itemScrollView.subviews) {
        [view removeFromSuperview];
    }
    favoriteImageIdArray = [NSMutableArray array];
    favoriteImageNameArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (int n = 0; n < favoriteArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        mdic[[NSString stringWithFormat:@"item_id[%d]",n]] = favoriteArray[n];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/favorites/get_items",apiUrl]];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"お気に入り情報！: %@", responseObject);
        NSDictionary *error = [responseObject valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeFavoriteViewIOS7:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}
- (void)showFavorite:(id)sender{
    
    for (UIView *view in favoritelistScroll.subviews) {
        [view removeFromSuperview];
    }
    favoriteImageIdArray = [NSMutableArray array];
    favoriteImageNameArray = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (int n = 0; n < favoriteArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        mdic[[NSString stringWithFormat:@"item_id[%d]",n]] = favoriteArray[n];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/favorites/get_items",apiUrl]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"お気に入り情報！: %@", responseObject);
        NSDictionary *error = [responseObject valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeFavoriteView:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
    /*
    NSArray *imageArray = [NSArray arrayWithObjects:@"ring.jpg", @"ring2.jpg", @"ring3.jpg",@"ring4.jpg", @"ring5.jpg", @"ring6.jpg",@"ring7.jpg", @"ring8.jpg",  nil];
    for (int n = 0; n < 8; n++) {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:n]];
        UIImageView *itemView = [[UIImageView alloc] initWithImage:image];
        itemView.frame = CGRectMake(60 + 50 * n, 5, 45, 45);
        [favoritelistScroll addSubview:itemView];
    }
    UIButton *goFavoriteBtn = [[UIButton alloc]
                               initWithFrame:CGRectMake(5, 5, 45, 45)];
    goFavoriteBtn.backgroundColor = [UIColor yellowColor];
    [goFavoriteBtn addTarget:self
                      action:@selector(goFavorite:) forControlEvents:UIControlEventTouchUpInside];
    goFavoriteBtn.tag = 1;
    [favoritelistScroll addSubview:goFavoriteBtn];
    */
    
    
    
    
    
    
    
    
    
    
    
    if (cartIsShowed) {
        cartlistScroll.hidden = NO;
        favoritelistScroll.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_star_s"];
        [favoriteBtn setImage:image forState:UIControlStateNormal];
        UIImage *image2 = [UIImage imageNamed:@"icon_f_buy_cart"];
        [cartBtn setImage:image2 forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            triView.frame = CGRectMake(24, smallMenuView.frame.origin.y + smallMenuView.frame.size.height, 10, 10);
        } completion:^(BOOL finished) {
            cartIsShowed = NO;
            favoriteIsShowed = YES;
            return ;
        }];
    }
    if (favoriteIsShowed) {
        favoriteIsShowed = NO;
        cartlistScroll.hidden = YES;
        favoritelistScroll.hidden = NO;
        
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_star"];
        [favoriteBtn setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 100,90,35);
            triView.alpha = 0.0;
            listView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }else{
        favoriteIsShowed = YES;
        cartlistScroll.hidden = YES;
        favoritelistScroll.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_star_s"];
        [favoriteBtn setImage:image forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 170,90,35);
            triView.alpha = 1.0;
            listView.alpha = 1.0;
            triView.frame = CGRectMake(24, smallMenuView.frame.origin.y + smallMenuView.frame.size.height, 10, 10);
        } completion:^(BOOL finished) {
        }];
    }
    
}
- (void)arrangeFavoriteViewIOS7:(id)jsonData{
    
    
    
    NSArray *itemArray = jsonData[@"result"];
    NSString *imageUrl = jsonData[@"image_url"];
    //NSLog(@"あいてむすう: %d", itemArray.count);
    if ([itemArray isEqual:[NSNull null]]) {
        
    }else{
        itemListView.itemScrollView.contentSize = CGSizeMake(5 + (49 * itemArray.count),44);
        for (int n = 0; n < itemArray.count; n++) {
            NSDictionary *itemRoot = itemArray[n];
            NSDictionary *item = itemRoot[@"Item"];
            
            NSString *itemImageName = item[@"img"];
            NSString *itemId = item[@"id"];
            
            [favoriteImageIdArray addObject:itemId];
            [favoriteImageNameArray addObject:itemImageName];
            
            
            UIImageView *itemView = [[UIImageView alloc] init];
            itemView.frame = CGRectMake(5 + (49 * n), 2, 40, 40);
            [itemListView.itemScrollView addSubview:itemView];
            
            NSString *url1 = [NSString stringWithFormat:@"%@%@",imageUrl,itemImageName];
            NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
            NSLog(@"画像のurl%@",url1);
            if (url1) {
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Response: %@", responseObject);
                    [itemView setImage:responseObject];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
            }
        }

    }
}
- (void)arrangeFavoriteView:(id)jsonData{
    
    
    
    
    NSArray *itemArray = jsonData[@"result"];
    NSString *imageUrl = jsonData[@"image_url"];
    NSLog(@"あいてむすう: %d", itemArray.count);
    
    
    
    UIButton *goFavoriteBtn = [[UIButton alloc]
                               initWithFrame:CGRectMake(5, 5, 45, 45)];
    goFavoriteBtn.backgroundColor = [UIColor clearColor];
    [goFavoriteBtn addTarget:self
                      action:@selector(goFavorite:) forControlEvents:UIControlEventTouchUpInside];
    goFavoriteBtn.tag = 1;
    [favoritelistScroll addSubview:goFavoriteBtn];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_f_buy_more.png"]];
    listImageView.frame = CGRectMake(8.5, 8.5, 28, 28);
    [goFavoriteBtn addSubview:listImageView];
    
    favoritelistScroll.contentSize = CGSizeMake(50 * itemArray.count + 55,55);
    for (int n = 0; n < itemArray.count; n++) {
        NSDictionary *itemRoot = itemArray[n];
        NSDictionary *item = itemRoot[@"Item"];
        
        NSString *itemImageName = item[@"img"];
        NSString *itemId = item[@"id"];
        
        [favoriteImageIdArray addObject:itemId];
        [favoriteImageNameArray addObject:itemImageName];
        
        UIImageView *itemView = [[UIImageView alloc] initWithImage:nil];
        itemView.frame = CGRectMake(60 + 50 * n, 5, 45, 45);
        [favoritelistScroll addSubview:itemView];
        
        NSString *url1 = [NSString stringWithFormat:@"%@%@",imageUrl,itemImageName];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        NSLog(@"画像のurl%@",url1);
        if (url1) {
        
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", responseObject);
                [itemView setImage:responseObject];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
        }
    }
    
    


    
}

- (void)goFavorite:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"favorite"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    
    
    [self animateShowHeaderView];

    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        appFrame.origin.y -= 20;
        /*
        //[[self view] setFrame:appFrame];
        //mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 0);
        for (UIView *subview in [mainScrollView subviews]) {
            if ([subview isKindOfClass:[UITableView class]]) {
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
            }
            
        }
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    /*
    for (UIView *subview in [mainScrollView subviews]) {
        [UIView animateWithDuration:0.3 animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }*/
}

- (void)goCart:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    [self animateShowHeaderView];

    [UIView animateWithDuration:0.3 animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        app.statusBarHidden = NO;
        CGRect appFrame = [[UIScreen mainScreen] bounds];
        appFrame.origin.y -= 20;
        /*
        //[[self view] setFrame:appFrame];
        //mainScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        for (UIView *subview in [mainScrollView subviews]) {
            if ([subview isKindOfClass:[UITableView class]]) {
                subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
            }
            
        }
         */
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    /*
    for (UIView *subview in [mainScrollView subviews]) {
        [UIView animateWithDuration:0.3 animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
     */
}


- (void)goSell{
    
    
    [[BSCommonAPIClient sharedClient] getCheckVersionWithUserType:@"seller" completion:^(NSDictionary *results, NSError *error) {
        NSLog(@"getCheckVersionWithUserType:%@",results);

        NSString *isStabel = results[@"result"][@"is_stable"];
        NSString *message = results[@"result"][@"message"];
        if ([isStabel intValue] == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.title = @"お知らせ";
            alert.delegate = self;
            alert.message = message;
            [alert addButtonWithTitle:@"確認"];
            [alert show];
            
        } else {
            
            
            
            UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
            
            NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
            NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
            NSString *email = [store stringForKey:@"email"];
            
            NSLog(@"goSellgoSell:email:%@",email);
            if (!email) {
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"init"];
                vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:vc animated:YES completion: ^{
                    NSLog(@"goSell:完了");
                }];
            } else {
                
                [[BSUserManager sharedManager] autoSignInWithBlock:^(NSError *error) {
                    
                    
                    [[BSCommonAPIClient sharedClient] getPushNotificationsSettingWithSessionId:[BSUserManager sharedManager].sessionId token:[AppDelegate getDeviceToken] curation:2 order:2 completion:^(NSDictionary *results, NSError *error) {
                        
                        
                        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"init"];
                        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [self presentViewController:vc animated:YES completion: ^{
                            NSLog(@"goSell:完了");
                        }];
                        
                    }];
                    
                    
                }];
            }
            
        }
    }];
    
    
    
    
    
    
}



#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self openAppStore];
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            break;
    }
    
}

- (void)openAppStore
{
    NSString *urlString = @"https://itunes.apple.com/jp/app/sumahode-jian-danshoppingu/id661263905?mt=8";
    NSURL *url= [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - imageEdit
//画像トリミング
- (void)resizeAspectFitImageWithImage:(UIImage*)img atSize:(CGFloat)size imageWidth:(int)imageWidth imageHeight:(int)imageHeight completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    // リサイズする倍率を求める:2
    // 新しい画像サイズ
    CGSize newSize = CGSizeMake(imageWidth*2, imageHeight*2);
    
    // ソーズ画像のサイズと、新しいサイズの比率計算
    CGRect imageRect = [ciImage extent];
    CGPoint scale = CGPointMake(newSize.width/imageRect.size.width,
                                newSize.height/imageRect.size.height);
    
    //CGFloat scale = img.size.width < img.size.height ? size/img.size.height : size/img.size.width;
    // CGAffineTransformでサイズ変更
    CIImage *filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale.x,scale.y)];
    // UIImageに変換
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

- (void)centerCroppingImageWithImage:(UIImage*)img atSize:(CGSize)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    /* 画像のサイズ */
    CGSize imgSize = CGSizeMake(img.size.width * img.scale,
                                img.size.height * img.scale);
    /* トリミングするサイズ */
    CGSize croppingSize = CGSizeMake(size.width * [UIScreen mainScreen].scale,
                                     size.height * [UIScreen mainScreen].scale);
    /* 中央でトリミング */
    CIImage *filteredImage = [ciImage imageByCroppingToRect:CGRectMake(imgSize.width/2.f - croppingSize.width/2.f,
                                                                       imgSize.height/2.f - croppingSize.height/2.f,
                                                                       croppingSize.width,
                                                                       croppingSize.height)];
    /* UIImageに変換する */
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

- (UIImage*)uiImageFromCIImage:(CIImage*)ciImage
{
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO }];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    //CGImageContext(aho);
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];f
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [BSDefaultViewObject customNavigationBar:1];
    
}
- (void)aboutApp
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutApp"];
    [self presentViewController:vc animated:YES completion: ^{
        
        NSLog(@"完了");}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    /*
    UITableView *tableView = (UITableView*)[mainScrollView viewWithTag:102];
    NSArray *checkCells = [tableView visibleCells];
    NSArray *cells = [tableView subviews];
    for (UITableViewCell *cell in cells) {
        NSLog(@"配列%@",checkCells);
        int objectIndex = [checkCells indexOfObject:cell];
        if (objectIndex == NSNotFound) {
            
             for (UIView *subview in [cell subviews]) {
                 [cell removeFrom
     view];
             }
            
        }
    }
     */
}
#pragma mark - Private
+(NSString*)getShopId {
    return importShopId;
}
+(NSString*)getSelectedShopInfo {
    return selectedShopInfo;
}

//アイテムIdを取得
+(NSString*)getItemId {
    return importItemId;
}

@end
