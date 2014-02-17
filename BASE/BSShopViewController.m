//
//  BSShopViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/23.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSShopViewController.h"

#import "BSBuyTopViewController.h"
#import "BSShopFooterView.h"
#import "BSItemListView.h"


#import "AppDelegate.h"


@interface BSShopViewController ()

@end

@implementation BSShopViewController{
    
    UINavigationItem *navItem;
    
    UIImageView *loadingImageView;
    
    int contentSize;
    
    UIActivityIndicatorView *ai;

    UITableView *shopTable;
    NSString *logoUrl;
    NSString *logoTitle;
    
    UIImageView *shopImageView;
    UILabel *aboutLabel;
    
    NSArray *ItemArray;
    NSString *imageRootUrl;
    NSString *apiUrl;

    
    
    UIButton *favoriteBtn;
    UIButton *cartBtn;
    UIButton *socialBtn;
    UIScrollView *cartlistScroll;
    UIScrollView *favoritelistScroll;
    
    //お気に入りorかごリスト
    UIView *listView;
    //吹き出しの三角の部分
    Triangle *triView;
    BOOL favoriteIsShowed;
    BOOL cartIsShowed;
    
    UIView *smallMenuView;
    
    NSMutableArray *favoriteImageIdArray;
    NSMutableArray *favoriteImageNameArray;
    
    NSMutableArray *cartImageIdArray;
    NSMutableArray *cartImageNameArray;
    
    //取得したカテゴリー情報
    NSArray *categoryArray;

    NSMutableDictionary *socialInfo;
    
    UIImage *shareImage;
    
    
    //店舗情報表示
    BOOL isOpened;
    //店舗のaboutが三行の場合
    BOOL isMoreThreeLines;
     
    //aboutのグラデーション
    UIView* aboutLabelGradationView;
    
    //スクロールスピード
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
    BOOL isScrollingFast;
    
    BSItemListView *itemListView;
    BSShopFooterView *footerView;
}
static NSString *importItemId = nil;
static NSString *importShopId = nil;

@synthesize beginScrollOffsetY;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    NSString *analyShopId = [BSBuyTopViewController getShopId];
    //グーグルアナリティクス
    self.trackedViewName = [NSString stringWithFormat:@"buyShop,shopId:%@",analyShopId];
    
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRoot)];
    [self.view addGestureRecognizer:swipeRightGesture];
    
    self.title = @"お店";
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    /*
    //スクロール
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];
    scrollView.contentSize = CGSizeMake(320, 2000);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    */
    
    //ナビゲーションバー
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    navItem = [[UINavigationItem alloc] initWithTitle:@""];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];    
     */
    
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"店舗一覧" target:self action:@selector(backRoot) side:1];
    self.navigationItem.leftBarButtonItem = backButton;
    */
    
    UIButton *menuButton;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20, -2.0, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_7_info.png"] forState:UIControlStateNormal];

    }else{
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -2.0, 50, 42)];

        [menuButton setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    }
    menuButton.backgroundColor = [UIColor clearColor];
    [menuButton addTarget:self action:@selector(aboutShop) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
    menuButtonView.backgroundColor = [UIColor clearColor];
    [menuButtonView addSubview:menuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    
    ai = [[UIActivityIndicatorView alloc] init];
    ai.frame = CGRectMake(0, 0, 50, 50);
    ai.center = self.view.center;
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:ai];
    [ai startAnimating];

    if ([BSDefaultViewObject isMoreIos7]) {
        shopTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
        shopTable.scrollEnabled = YES;
        shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        shopTable.backgroundColor = [UIColor clearColor];
        shopTable.tag = 1;
        shopTable.hidden = YES;
        shopTable.dataSource = self;
        shopTable.delegate = self;
        [self.view insertSubview:shopTable belowSubview:self.navigationController.navigationBar];
        
        UINib *nib = [UINib nibWithNibName:@"ItemTableViewCell" bundle:nil];
        [shopTable registerNib:nib forCellReuseIdentifier:@"itemCell"];
        

        
        //店舗のaboutをうすくする
        aboutLabelGradationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
        CAGradientLayer *pageGradient = [CAGradientLayer layer];
        pageGradient.frame = aboutLabelGradationView.bounds;
        pageGradient.colors =
        @[(id)[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0].CGColor,
         (id)[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8].CGColor];
        [aboutLabelGradationView.layer insertSublayer:pageGradient atIndex:0];
        
        [self setFooterView];
        
        
    }else{
        shopTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44) style:UITableViewStylePlain];
        shopTable.scrollEnabled = YES;
        shopTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        shopTable.backgroundColor = [UIColor clearColor];
        shopTable.tag = 1;
        shopTable.dataSource = self;
        shopTable.delegate = self;
        [self.view insertSubview:shopTable belowSubview:self.navigationController.navigationBar];
        
        UINib *nib = [UINib nibWithNibName:@"ItemTableViewCell" bundle:nil];
        [shopTable registerNib:nib forCellReuseIdentifier:@"itemCell"];
        
        //左下のメニュー
        smallMenuView = [[UIView alloc] init];
        smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 61,135,35);
        smallMenuView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.70f];
        smallMenuView.hidden = YES;
        smallMenuView.layer.cornerRadius = 2;
        smallMenuView.layer.masksToBounds = YES;
        [self.view addSubview:smallMenuView];
        
        //吹き出しの三角
        triView = [[Triangle alloc] initWithFrame:CGRectMake(18, [[UIScreen mainScreen] bounds].size.height - 70, 20, 10)];
        triView.alpha = 0.0;
        [self.view addSubview:triView];
        
        //お気に入りorかごのリスト
        listView = [[UIView alloc] init];
        listView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 80,310,55);
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
        
        
        UIImage *socialImage = [UIImage imageNamed:@"icon_d_buy_share.png"];
        socialBtn = [[UIButton alloc]
                     initWithFrame:CGRectMake(90, 0, 45, 35)];
        [socialBtn setImage:socialImage forState:UIControlStateNormal];
        [socialBtn addTarget:self
                      action:@selector(shareToSNS:) forControlEvents:UIControlEventTouchUpInside];
        socialBtn.tag = 1;
        //cartBtn.backgroundColor = [UIColor blueColor];
        [smallMenuView addSubview:socialBtn];
        
        //店舗のaboutをうすくする
        aboutLabelGradationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
        CAGradientLayer *pageGradient = [CAGradientLayer layer];
        pageGradient.frame = aboutLabelGradationView.bounds;
        pageGradient.colors =
        @[(id)[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0].CGColor,
         (id)[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8].CGColor];
        [aboutLabelGradationView.layer insertSublayer:pageGradient atIndex:0];
        //[self.view addSubview:aboutLabelGradationView];
        
        /*
         int line = 0;
         int row = 0;
         for (int n = 0; n < 8; n++) {
         ++line;
         
         UIImage *img = [UIImage imageNamed:[itemImage objectAtIndex:n]];
         UIButton *shopBtn = [[UIButton alloc]
         initWithFrame:CGRectMake(0, 5, 300, 300)];
         [shopBtn setBackgroundImage:img forState:UIControlStateNormal];
         [shopBtn addTarget:self
         action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
         shopBtn.tag = 1;
         //UIImageView *shopImageView = [[UIImageView alloc] initWithImage:img];
         //shopImageView.contentMode = UIViewContentModeScaleToFill;
         if (line == 1) shopBtn.frame = CGRectMake(5, (aboutLabel.frame.size.height + aboutLabel.frame.origin.y + 20) + (305/2 + 5) * row, 305/2, 305/2);
         if (line == 2) shopBtn.frame = CGRectMake(10 + 305/2, (aboutLabel.frame.size.height + aboutLabel.frame.origin.y + 20) + (305/2 + 5) * row, 305/2, 305/2);
         
         UIImage *itemBg = [UIImage imageNamed:@"itemtitle_base.png"];
         itemBg = [self rotateImage:itemBg angle:180];
         UIImageView *itemImageView = [[UIImageView alloc] initWithImage:itemBg];
         itemImageView.frame = CGRectMake(0, 0, 305/2, 32);
         [shopBtn addSubview:itemImageView];
         
         
         UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,-5,148,40)];
         itemLabel.text = [itemTitle objectAtIndex:n];
         itemLabel.textColor = [UIColor whiteColor];
         itemLabel.backgroundColor = [UIColor clearColor];
         itemLabel.font = [UIFont boldSystemFontOfSize:10];
         itemLabel.numberOfLines = 2;
         [itemImageView addSubview:itemLabel];
         
         //値段ビュー
         UIView *priceView = [[UIView alloc] init];
         priceView.frame = CGRectMake(102, 130,46,20);
         priceView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
         priceView.layer.cornerRadius = 2;
         priceView.layer.masksToBounds = YES;
         [itemImageView addSubview:priceView];
         
         UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,42,20)];
         priceLabel.text = @"¥2900";
         priceLabel.textColor = [UIColor whiteColor];
         priceLabel.backgroundColor = [UIColor clearColor];
         priceLabel.font = [UIFont systemFontOfSize:12];
         priceLabel.textAlignment = NSTextAlignmentRight;
         priceLabel.numberOfLines = 1;
         [priceView addSubview:priceLabel];
         
         
         [scrollView addSubview:shopBtn];
         if (line == 2) {
         ++row;
         line = 0;
         }
         
         }
         */
        
    }
    
    
    
    
    
    
    
    

    
    
    NSString *userId = [BSBuyTopViewController getShopId];
    importShopId = userId;
    NSString *deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // osのバージョン取得
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *deviceName;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        deviceName = @"iPhone5";
    }
    else
    {
        deviceName = @"iPhone4";
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/shops/get_shop?user_id=%@&device_os=%f&device_id=%@&device_name=%@",apiUrl,userId,iOSVersion,deviceId,deviceName];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ショップ情報！: %@", JSON);
        NSDictionary *rootShop = [JSON valueForKeyPath:@"shop"];
        NSDictionary *shop = [rootShop valueForKeyPath:@"Shop"];
        NSString *shopIntroduction = [shop valueForKeyPath:@"shop_introduction"];
        NSString *shopName = [shop valueForKeyPath:@"shop_name"];
        NSLog(@"%@",shopIntroduction);

        //self.title = shopName;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -100, 0, 0)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
        label.text = shopName;
        [label sizeToFit];
        label.hidden = YES;
        [self.navigationItem setTitleView:label];
        label.hidden = NO;

        NSLog(@"%@,ショップ名:%@",[BSBuyTopViewController getSelectedShopInfo],label.text);

        [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSShopViewController"
                                                         withAction:[NSString stringWithFormat:@"%@,ショップ名:%@",[BSBuyTopViewController getSelectedShopInfo],label.text]
                                                          withLabel:nil
                                                          withValue:@100];
        
        
        //店舗のロゴ
        logoUrl = JSON[@"logo_url"];
        logoTitle = shop[@"logo"];
        
        shopImageView = [[UIImageView alloc] initWithImage:nil];
        shopImageView.contentMode = UIViewContentModeScaleToFill;
        
        if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]) {
            //店舗の説明

            aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,80)];
            aboutLabel.textColor = [UIColor grayColor];
            aboutLabel.backgroundColor = [UIColor clearColor];
            aboutLabel.font = [UIFont boldSystemFontOfSize:12];
            [aboutLabel setText:@""];
            if (!([shopIntroduction isEqual:[NSNull null]] || [shopIntroduction isEqualToString:@""]))[aboutLabel setText:shopIntroduction];
            //[aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [aboutLabel setNumberOfLines:0];
            CGRect frame = [aboutLabel frame];
            frame.size = CGSizeMake(300, 5000);
            [aboutLabel setFrame:frame];
            [aboutLabel sizeToFit];
            //[scrollView addSubview:aboutLabel];
            NSLog(@"aboutLabel.text%@",aboutLabel.text);
            if (aboutLabel.frame.size.height > 45) {
                isMoreThreeLines = YES;
            }
            [aboutLabel setNumberOfLines:3];
            frame = [aboutLabel frame];
            frame.size = CGSizeMake(300, 5000);
            [aboutLabel setFrame:frame];
            [aboutLabel sizeToFit];
            
            
            
            
            NSString *urlString = [NSString stringWithFormat:@"%@/shops/get_shop_items?user_id=%@",apiUrl,userId];
            NSLog(@"おせてます%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url1 = [NSURL URLWithString:urlString];
            NSLog(@"URLあああああ%@",url1);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
            //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:@""
                                                              parameters:nil];
            
            AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"ショップ情報！: %@", JSON);
                smallMenuView.hidden = NO;
                ItemArray = [JSON valueForKeyPath:@"result"];
                imageRootUrl = [JSON valueForKeyPath:@"image_url"];
                
                socialInfo = [NSMutableDictionary dictionary];
                socialInfo[@"facebook"] = [JSON valueForKeyPath:@"social.facebook_content"];
                socialInfo[@"twitter"] = [JSON valueForKeyPath:@"social.tweet_content"];
                socialInfo[@"line"] = [JSON valueForKeyPath:@"social.line_content"];
                socialInfo[@"shopUrl"] = [JSON valueForKeyPath:@"shop_url"];
                
                
                NSLog(@"あいてっっｍ%d",ItemArray.count);
                NSLog(@"ショップ情報！: %@", JSON);
                [ai stopAnimating];
                shopTable.hidden = NO;
                [shopTable reloadData];

            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                NSLog(@"Error: %@", error);
                
            }];
            [operation2 start];
            return ;
        }
        
        //[scrollView addSubview:shopImageView];
        NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoTitle];
        NSLog(@"ロゴ取得%@%@",logoUrl,logoTitle);
        url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/pjpeg"]];
        [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"image/x-png"]];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        AFImageRequestOperation *operation = [AFImageRequestOperation
                                              imageRequestOperationWithRequest: getImageRequest
                                              imageProcessingBlock: nil
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                  shareImage = getImage;
                                                  [shopImageView setImage:getImage];
                                                  NSLog(@"取得した画像のサイズタテ%fヨコ%f",getImage.size.height,getImage.size.width);
                                                  shopImageView.frame = CGRectMake(0, 0, 320, getImage.size.height / (getImage.size.width / 320));
                                                  if (getImage.size.width >= 320 ) {
                                                      shopImageView.contentMode = UIViewContentModeScaleToFill;

                                                  }else{
                                                      shopImageView.contentMode = UIViewContentModeCenter;

                                                  }
                                                  
                                                  //店舗の説明
                                                  aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,300,80)];
                                                  aboutLabel.textColor = [UIColor grayColor];
                                                  aboutLabel.backgroundColor = [UIColor clearColor];
                                                  aboutLabel.font = [UIFont boldSystemFontOfSize:12];
                                                  [aboutLabel setText:shopIntroduction];
                                                  //[aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
                                                  [aboutLabel setNumberOfLines:0];
                                                  CGRect frame = [aboutLabel frame];
                                                  frame.size = CGSizeMake(300, 5000);
                                                  [aboutLabel setFrame:frame];
                                                  [aboutLabel sizeToFit];
                                                  //[scrollView addSubview:aboutLabel];
                                                  NSLog(@"aboutLabel.text%@",aboutLabel.text);
                                                  if (aboutLabel.frame.size.height > 45) {
                                                      isMoreThreeLines = YES;
                                                  }
                                                  [aboutLabel setNumberOfLines:3];
                                                  frame = [aboutLabel frame];
                                                  frame.size = CGSizeMake(300, 5000);
                                                  [aboutLabel setFrame:frame];
                                                  [aboutLabel sizeToFit];

                                                  
                                                  
                                                  
                                                  contentSize = (aboutLabel.frame.size.height + aboutLabel.frame.origin.y + 20);
                                                  
                                                  
                                                  
                                                  NSString *urlString = [NSString stringWithFormat:@"%@/shops/get_shop_items?user_id=%@",apiUrl,userId];
                                                  NSLog(@"おせてます%@",urlString);
                                                  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                  
                                                  NSURL *url1 = [NSURL URLWithString:urlString];
                                                  NSLog(@"URLあああああ%@",url1);
                                                  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
                                                  //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
                                                  NSMutableURLRequest *itemRequest = [httpClient requestWithMethod:@"GET"
                                                                                                          path:@""
                                                                                                    parameters:nil];
                                                  
                                                  AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:itemRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                      NSLog(@"ショップ情報！: %@", JSON);
                                                      smallMenuView.hidden = NO;

                                                      ItemArray = [JSON valueForKeyPath:@"result"];
                                                      imageRootUrl = [JSON valueForKeyPath:@"image_url"];
                                                      
                                                      NSLog(@"あいてっっｍ%d",ItemArray.count);
                                                      
                                                      NSLog(@"[JSON valueForKeyPath:social.facebook_content]]%@",[JSON valueForKeyPath:@"social.facebook_content"]);
                                                      socialInfo = [NSMutableDictionary dictionary];
                                                      socialInfo[@"facebook"] = [JSON valueForKeyPath:@"social.facebook_content"];
                                                      socialInfo[@"twitter"] = [JSON valueForKeyPath:@"social.tweet_content"];
                                                      socialInfo[@"line"] = [JSON valueForKeyPath:@"social.line_content"];
                                                      socialInfo[@"shopUrl"] = [JSON valueForKeyPath:@"shop_url"];
                                                      
                                                      
                                                      NSLog(@"socialInfo%@",socialInfo);
                                                      
                                                      //float rate = (float)ItemArray.count / 2;

                                                      //scrollView.contentSize = CGSizeMake(320, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height + 20) + (305/2 + 5) * ceil(rate) );
                                                      [ai stopAnimating];
                                                      shopTable.hidden = NO;

                                                      [shopTable reloadData];
                                                      
        
                                                  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                                      NSLog(@"Error: %@", error);
                                                      
                                                  }];
                                                  [operation2 start];
                                                  
                                              }
                                              failure: nil];
        [operation start];
        NSLog(@"ここまでは動いてる");
        
        
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// TODO: アクション
- (void)setFooterView{
    footerView = [BSShopFooterView setView];
    footerView.frame = CGRectMake(0, self.view.frame.size.height - footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
    [self.view addSubview:footerView];
    
    [[footerView.favoriteButton layer] setBorderWidth:0.25f];
    [[footerView.favoriteButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[footerView.cartButton layer] setBorderWidth:0.25f];
    [[footerView.cartButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[footerView.favoriteButton layer] setBorderWidth:0.25f];
    [[footerView.favoriteButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[footerView.socialButton layer] setBorderWidth:0.25f];
    [[footerView.socialButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[footerView.fanButton layer] setBorderWidth:0.25f];
    [[footerView.fanButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [footerView.cartButton addTarget:self
                             action:@selector(showCartIOS7:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.fanButton addTarget:self
                 action:@selector(beFanOfThisShop:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.socialButton addTarget:self
                             action:@selector(shareToSNS:) forControlEvents:UIControlEventTouchUpInside];
    
    itemListView = [BSItemListView setView];
    itemListView.frame = CGRectMake(0, self.view.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
    
    [itemListView.detailButton addTarget:self
                                action:@selector(goCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemListView];
    
    [self checkFan];
    
    
}
- (void)checkFan{
    
    NSString *userId = [BSBuyTopViewController getShopId];
    // ユニークキーの保持を確認
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSLog(@"[store stringForKeyuniqueKey:%@",[store stringForKey:@"uniqueKey"]);
    NSString *uniqueKey = [store stringForKey:@"uniqueKey"];
    //[UICKeyChainStore setString:signUpPassword.text forKey:@"password" service:@"in.thebase"];

    NSString *urlString;
    if (!uniqueKey) {
        urlString = [NSString stringWithFormat:@"%@/following_shops/is_following_shop?apn_token_id=%@&user_id=%@",apiUrl,[AppDelegate getTokenId],userId];
    }else{
        urlString = [NSString stringWithFormat:@"%@/following_shops/is_following_shop?apn_token_id=%@&user_id=%@&unique_key=%@",apiUrl,[AppDelegate getTokenId],userId,uniqueKey];
    }
    
    NSLog(@"url%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"フォロー完了%@",JSON);
        
        NSString *uniqueKey = [JSON objectForKey:@"unique_key"];
        if (uniqueKey) {
            [store setString:uniqueKey forKey:@"uniqueKey"];
            [store synchronize];
        }
        /*
         NSString *errorMessage = [[JSON valueForKeyPath:@"error.validations.FollowingShop.apn_token_id"] objectAtIndex:0];
         if (errorMessage) {
         //NSString *test = [errorMessage obje
         NSLog(@"エラー%@",errorMessage);
         
         [SVProgressHUD showErrorWithStatus:@"エラー:("];
         return ;
         }
         */
        NSString *result = [JSON valueForKey:@"result"];
        if ([result intValue] == 1) {
            UIEdgeInsets insets = footerView.fanButton.imageEdgeInsets;
            //NSLog(@"インセット%@",insets);
            insets.right = 37.0;
            footerView.fanButton.imageEdgeInsets = insets;
            [footerView.fanButton setImage:[UIImage imageNamed:@"icon_7_w_love2"] forState:UIControlStateNormal];
            [footerView.fanButton setTitle:@"ファン" forState:UIControlStateNormal];
            [footerView.fanButton removeTarget:self
                                        action:nil forControlEvents:UIControlEventTouchUpInside];
            [footerView.fanButton addTarget:self
                                     action:@selector(beUnfanOfThisShop:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    } failure:nil];
    [operation start];
    
}
- (void)beFanOfThisShop:(id)sender{
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeGradient];
    NSString *userId = [BSBuyTopViewController getShopId];
    
    
    // ユニークキーの保持を確認
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSLog(@"[store stringForKeyuniqueKey:%@",[store stringForKey:@"uniqueKey"]);
    NSString *uniqueKey = [store stringForKey:@"uniqueKey"];
    //[UICKeyChainStore setString:signUpPassword.text forKey:@"password" service:@"in.thebase"];
    
    NSString *urlString;
    if (!uniqueKey) {
        urlString = [NSString stringWithFormat:@"%@/following_shops/follow?apn_token_id=%@&user_id=%@",apiUrl,[AppDelegate getTokenId],userId];

    }else{
        urlString = [NSString stringWithFormat:@"%@/following_shops/follow?apn_token_id=%@&user_id=%@&unique_key=%@",apiUrl,[AppDelegate getTokenId],userId,uniqueKey];

    }
    
    
    NSLog(@"url%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ファンになったよ！%@",JSON);
        
        NSString *uniqueKey = [JSON objectForKey:@"unique_key"];
        if (uniqueKey) {
            [store setString:uniqueKey forKey:@"uniqueKey"];
            [store synchronize];
        }
        /*
        NSString *errorMessage = [[JSON valueForKeyPath:@"error.validations.FollowingShop.apn_token_id"] objectAtIndex:0];
        if (errorMessage) {
            //NSString *test = [errorMessage obje
            NSLog(@"エラー%@",errorMessage);

            [SVProgressHUD showErrorWithStatus:@"エラー:("];
            return ;
        }
         */
        UIEdgeInsets insets = footerView.fanButton.imageEdgeInsets;
        //NSLog(@"インセット%@",insets);
        insets.right = 37.0;
        footerView.fanButton.imageEdgeInsets = insets;
        [SVProgressHUD showSuccessWithStatus:@"ファン！"];
        [footerView.fanButton setTitle:@"ファン" forState:UIControlStateNormal];
        [footerView.fanButton setImage:[UIImage imageNamed:@"icon_7_w_love2"] forState:UIControlStateNormal];
        [footerView.fanButton removeTarget:self
                                    action:nil forControlEvents:UIControlEventTouchUpInside];
        [footerView.fanButton addTarget:self
                                 action:@selector(beUnfanOfThisShop:) forControlEvents:UIControlEventTouchUpInside];
        
    } failure:nil];
    [operation start];
    
}

- (void)beUnfanOfThisShop:(id)sender{
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeGradient];
    NSString *userId = [BSBuyTopViewController getShopId];
    
    // ユニークキーの保持を確認
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSLog(@"[store stringForKeyuniqueKey:%@",[store stringForKey:@"uniqueKey"]);
    NSString *uniqueKey = [store stringForKey:@"uniqueKey"];
    //[UICKeyChainStore setString:signUpPassword.text forKey:@"password" service:@"in.thebase"];
    
    NSString *urlString;
    if (!uniqueKey) {
        urlString = [NSString stringWithFormat:@"%@/following_shops/unfollow?apn_token_id=%@&user_id=%@",apiUrl,[AppDelegate getTokenId],userId];
        
    }else{
        urlString = [NSString stringWithFormat:@"%@/following_shops/unfollow?apn_token_id=%@&user_id=%@&unique_key=%@",apiUrl,[AppDelegate getTokenId],userId,uniqueKey];
        
    }
    
    
    

    NSLog(@"url%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"フォロー完了%@",JSON);
        
        NSString *uniqueKey = [JSON objectForKey:@"unique_key"];
        if (uniqueKey) {
            [store setString:uniqueKey forKey:@"uniqueKey"];
            [store synchronize];
        }
        
        /*
         NSString *errorMessage = [[JSON valueForKeyPath:@"error.validations.FollowingShop.apn_token_id"] objectAtIndex:0];
         if (errorMessage) {
         //NSString *test = [errorMessage obje
         NSLog(@"エラー%@",errorMessage);
         
         [SVProgressHUD showErrorWithStatus:@"エラー:("];
         return ;
         }
         */
        UIEdgeInsets insets = footerView.fanButton.imageEdgeInsets;
        //NSLog(@"インセット%@",insets);
        insets.right = 27.0;
        footerView.fanButton.imageEdgeInsets = insets;
        [SVProgressHUD showSuccessWithStatus:@"ファンをやめました"];
        [footerView.fanButton setTitle:@"お店のファンになる" forState:UIControlStateNormal];
        [footerView.fanButton setImage:[UIImage imageNamed:@"icon_7_w_love"] forState:UIControlStateNormal];
        [footerView.fanButton removeTarget:self
                                 action:nil forControlEvents:UIControlEventTouchDown];
        [footerView.fanButton addTarget:self
                                 action:@selector(beFanOfThisShop:) forControlEvents:UIControlEventTouchUpInside];
        
    } failure:nil];
    [operation start];
    
}

//========================================================================
#pragma mark - tableView

//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
        return 2;
    }else{
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
        if (section == 0) {
            rows = 1;
        }else{
            float rate = ItemArray.count/(float)2;
            rows = ceil(rate);
        }
    }else{
        if (section == 2) {
            float rate = ItemArray.count/(float)2;
            rows = ceil(rate);
        }else{
            rows = 1;
        }
    }
    return rows;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        if (section == 0) {
            return 64;
        }else{
            return 0.1;
        }
    }else{
        return 0.1;

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([BSDefaultViewObject isMoreIos7]) {
        return nil;
    }else{
        UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
        return zeroSizeView;
    }
    
}

 
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
            if (section == 1) {
                return 44;
            }else{
                return 0.1;
            }
        }else{
            if (section == 2) {
                return 44;
            }else{
                return 0.1;
            }
        }
        

    }else{
        return 0.1;

    }
    
}

//セクションフッターの高さ変更

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}
 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int height;
    if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
        if (indexPath.section == 0) {
            height = aboutLabel.frame.size.height + 10;
        }else{
            if ([BSDefaultViewObject isMoreIos7]) {
                height = 212;
            }else{
                height = 305/2 + 10;
                
            }
        }
    }else{
        if (indexPath.section == 0) {
            height = shopImageView.frame.size.height;
        }else if (indexPath.section == 1){
            //
            if (isOpened) {
                height = aboutLabel.frame.size.height + 10;
            }else{
                height = 50;
            }
        }else{
            if ([BSDefaultViewObject isMoreIos7]) {
                height = 212;
            }else{
                height = 305/2 + 10;

            }
        }
    }
        
    return height;
    
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%drows:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([BSDefaultViewObject isMoreIos7]) {
        
        //ロゴがない場合
        if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
            
            //商品説明のsection
            if (indexPath.section == 0) {
    
                [cell.contentView addSubview:aboutLabel];
                
                //ショップのaboutが三行以上の時に折りたたむ
                if (isMoreThreeLines) {
                    [aboutLabelGradationView setFrame:CGRectMake(0, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) - 50, self.view.frame.size.width, 52)];
                    [cell.contentView addSubview:aboutLabelGradationView];
                }
                
                return cell;

                
            }else{
                //商品のsection
                static NSString *CellIdentifier = @"itemCell";
                ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                [self updateItemCell:cell atIndexPath:indexPath];

                return cell;

            }
            
        }else{
            if (indexPath.section == 0) {
                [cell addSubview:shopImageView];
            }else if (indexPath.section == 1) {
                
                [cell.contentView addSubview:aboutLabel];
                
                //ショップのaboutが三行以上の時に折りたたむ
                if (isMoreThreeLines) {
                    [aboutLabelGradationView setFrame:CGRectMake(0, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) - 50, self.view.frame.size.width, 52)];
                    [cell addSubview:aboutLabelGradationView];
                }
                
                return cell;
                
                
            }else{
                //商品のsection
                static NSString *CellIdentifier = @"itemCell";
                ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                [self updateItemCell:cell atIndexPath:indexPath];
                
                [cell setNeedsLayout];

                return cell;
                
            }
        }
        
        
    }else{
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"section:%drows:%d",indexPath.section,indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        for (UIView *subview in [cell subviews]) {
            [subview removeFromSuperview];
        }
        
        
        if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]){
            if (indexPath.section == 0) {
                
                [cell addSubview:aboutLabel];
                
                
                //ショップのaboutが三行以上の時に折りたたむ
                if (isMoreThreeLines) {
                    [aboutLabelGradationView setFrame:CGRectMake(0, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) - 50, self.view.frame.size.width, 52)];
                    [cell addSubview:aboutLabelGradationView];
                }
                
                
            }else if (indexPath.section == 1) {
                int line = 0;
                if (indexPath.row == 0) {
                    line = 0;
                }else{
                    line = indexPath.row * 2;
                }
                NSDictionary *itemRoot1 = ItemArray[line];
                NSDictionary *item1 = itemRoot1[@"Item"];
                NSString *imageUrl1 = item1[@"img1"];
                NSString *itemTitle1 = item1[@"title"];
                NSString *itemId1 = item1[@"id"];
                NSString *price1 = item1[@"price"];
                
                
                NSDictionary *itemRoot2;
                NSDictionary *item2 = @{};
                NSString *imageUrl2;
                NSString *itemTitle2;
                NSString *itemId2;
                NSString *price2;
                
                if (ItemArray.count > line + 1){
                    itemRoot2 = ItemArray[line + 1];
                    item2 = itemRoot2[@"Item"];
                    imageUrl2 = item2[@"img1"];
                    itemTitle2 = item2[@"title"];
                    itemId2 = item2[@"id"];
                    price2 = item2[@"price"];
                }
                // TODO: コピー
                NSString *url1 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl1];
                NSString *url2 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl2];
                NSURLRequest *getImageRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                NSURLRequest *getImageRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
                UIButton *shopBtn1 = [[UIButton alloc]
                                      initWithFrame:CGRectMake(0, 5, 300, 300)];
                UIButton *shopBtn2;
                if (ItemArray.count > line + 1)shopBtn2 = [[UIButton alloc]
                                                           initWithFrame:CGRectMake(0, 5, 300, 300)];
                [shopBtn1 addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
                [shopBtn2 addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
                shopBtn1.tag = [itemId1 intValue];
                shopBtn2.tag = [itemId2 intValue];
                //UIImageView *shopImageView = [[UIImageView alloc] initWithImage:img];
                //shopImageView.contentMode = UIViewContentModeScaleToFill;
                shopBtn1.frame = CGRectMake(5, 2.5, 305/2, 305/2);
                shopBtn2.frame = CGRectMake(10 + 305/2, 2.5, 305/2, 305/2);
                shopBtn1.alpha = 0.0;
                shopBtn2.alpha = 0.0;
                
                UIImageView *itemImageView;
                if ([imageUrl1 isEqual:[NSNull null]] || [imageUrl1 isEqualToString:@""]) {
                    UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                    [shopBtn1 setBackgroundImage:noImage1 forState:UIControlStateNormal];
                    shopBtn1.frame = CGRectMake(4, 5, 307/2, 308/2);
                    
                    UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                    UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                    [noImageView2 setFrame:CGRectMake(307/4 - 25, 308/4 - 25, 50, 50)];
                    [shopBtn1 addSubview:noImageView2];
                    
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(1, 1, 303/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn1 addSubview:itemImageView];
                }else{
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(0, 0, 305/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn1 addSubview:itemImageView];
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,-5,148,40)];
                    itemLabel.text = itemTitle1;
                    itemLabel.textColor = [UIColor whiteColor];
                    itemLabel.backgroundColor = [UIColor clearColor];
                    itemLabel.alpha = 1.0;
                    itemLabel.font = [UIFont boldSystemFontOfSize:10];
                    itemLabel.numberOfLines = 2;
                    [itemImageView addSubview:itemLabel];
                    
                    
                    
                    
                    
                    //お金表記
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [nf setCurrencyCode:@"JPY"];
                    NSNumber *numPrice = @([price1 intValue]);
                    NSString *strPrice = [nf stringFromNumber:numPrice];
                    
                    NSLog(@"文字がおかしいよ%@",strPrice);
                    NSLog(@"文字がおかしいよ%d",strPrice.length);
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 128,52,28)];
                    priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
                    priceLabel.textColor = [UIColor whiteColor];
                    priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.45f];
                    priceLabel.font = [UIFont systemFontOfSize:12];
                    priceLabel.textAlignment = NSTextAlignmentRight;
                    priceLabel.layer.cornerRadius = 2;
                    priceLabel.numberOfLines = 1;
                    [itemImageView addSubview:priceLabel];
                    CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                                  constrainedToSize:CGSizeMake(200, 28)
                                                      lineBreakMode:priceLabel.lineBreakMode];
                    priceLabel.frame = CGRectMake(148 - textSize.width, 128,textSize.width,20);
                    
                    
                    [cell addSubview:shopBtn1];
                    
                    AFImageRequestOperation *operation3 = [AFImageRequestOperation
                                                           imageRequestOperationWithRequest: getImageRequest1
                                                           imageProcessingBlock: nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                               [ai stopAnimating];
                                                               
                                                               int imageW = getImage.size.width;
                                                               int imageH = getImage.size.height;
                                                               
                                                               int minSize = 0;
                                                               if (imageH <= imageW) {
                                                                   //横長の場合
                                                                   minSize = imageH;
                                                               } else {
                                                                   //縦長の場合
                                                                   minSize = imageW;
                                                               }
                                                               
                                                               
                                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                   [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                                       //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                                       
                                                                       
                                                                       
                                                                       [shopBtn1 setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                       [UIView animateWithDuration:0.6f
                                                                                             delay:0.0f
                                                                                           options:UIViewAnimationOptionAllowUserInteraction
                                                                                        animations:^(void){
                                                                                            shopBtn1.alpha = 1.0;
                                                                                        }
                                                                        
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                       
                                                                   }];
                                                               });
                                                               
                                                               
                                                           }
                                                           failure: nil];
                    [operation3 start];
                    
                }
                
                
                if ([imageUrl2 isEqual:[NSNull null]] || [imageUrl2 isEqualToString:@""]) {
                    UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                    [shopBtn2 setBackgroundImage:noImage1 forState:UIControlStateNormal];
                    shopBtn2.frame = CGRectMake(9 + 305/2, 5, 307/2, 308/2);
                    
                    UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                    UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                    [noImageView2 setFrame:CGRectMake(307/4 - 25, 308/4 - 25, 50, 50)];
                    [shopBtn2 addSubview:noImageView2];
                    
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(1, 1, 303/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn2 addSubview:itemImageView];
                }else{
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(0, 0, 305/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn2 addSubview:itemImageView];
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,-5,148,40)];
                    itemLabel.text = itemTitle2;
                    itemLabel.textColor = [UIColor whiteColor];
                    itemLabel.backgroundColor = [UIColor clearColor];
                    itemLabel.alpha = 1.0;
                    itemLabel.font = [UIFont boldSystemFontOfSize:10];
                    itemLabel.numberOfLines = 2;
                    [itemImageView addSubview:itemLabel];
                    
                    
                    
                    //お金表記
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [nf setCurrencyCode:@"JPY"];
                    NSNumber *numPrice = @([price2 intValue]);
                    NSString *strPrice = [nf stringFromNumber:numPrice];
                    
                    NSLog(@"文字がおかしいよ%@",strPrice);
                    NSLog(@"文字がおかしいよ%d",strPrice.length);
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 128,52,28)];
                    priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
                    priceLabel.textColor = [UIColor whiteColor];
                    priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.45f];
                    priceLabel.font = [UIFont systemFontOfSize:12];
                    priceLabel.textAlignment = NSTextAlignmentRight;
                    priceLabel.layer.cornerRadius = 2;
                    priceLabel.numberOfLines = 1;
                    [itemImageView addSubview:priceLabel];
                    CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                                  constrainedToSize:CGSizeMake(200, 28)
                                                      lineBreakMode:priceLabel.lineBreakMode];
                    priceLabel.frame = CGRectMake(148 - textSize.width, 128,textSize.width,20);
                    
                    
                    if (ItemArray.count > line + 1)[cell addSubview:shopBtn2];
                    
                    AFImageRequestOperation *operation3 = [AFImageRequestOperation
                                                           imageRequestOperationWithRequest: getImageRequest2
                                                           imageProcessingBlock: nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                               
                                                               int imageW = getImage.size.width;
                                                               int imageH = getImage.size.height;
                                                               
                                                               int minSize = 0;
                                                               if (imageH <= imageW) {
                                                                   //横長の場合
                                                                   minSize = imageH;
                                                               } else {
                                                                   //縦長の場合
                                                                   minSize = imageW;
                                                               }
                                                               
                                                               
                                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                   [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                                       //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                                       
                                                                       
                                                                       
                                                                       [shopBtn2 setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                       [UIView animateWithDuration:0.6f
                                                                                             delay:0.0f
                                                                                           options:UIViewAnimationOptionAllowUserInteraction
                                                                                        animations:^(void){
                                                                                            shopBtn2.alpha = 1.0;
                                                                                        }
                                                                        
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                       
                                                                   }];
                                                               });
                                                               
                                                               
                                                           }
                                                           failure: nil];
                    [operation3 start];
                    
                }
                
                itemRoot1 = nil;
                item1 = nil;
                imageUrl1 = nil;
                itemTitle1 = nil;
                itemId1 = nil;
                price1 = nil;
                
                
                itemRoot2 = nil;
                item2 = nil;
                imageUrl2 = nil;
                itemTitle2 = nil;
                itemId2 = nil;
                price2 = nil;
                
            }
        }else{
            if (indexPath.section == 0) {
                [cell addSubview:shopImageView];
            }else if (indexPath.section == 1) {
                [cell addSubview:aboutLabel];
                
                //ショップのaboutが三行以上の時に折りたたむ
                if (isMoreThreeLines) {
                    [aboutLabelGradationView setFrame:CGRectMake(0, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) - 50, self.view.frame.size.width, 52)];
                    [cell.contentView addSubview:aboutLabelGradationView];
                }
                
            }else if (indexPath.section == 2) {
                int line = 0;
                if (indexPath.row == 0) {
                    line = 0;
                }else{
                    line = indexPath.row * 2;
                }
                
                //for (int n = 0; n < ItemArray.count; n++) {
                NSDictionary *itemRoot1 = ItemArray[line];
                NSDictionary *item1 = itemRoot1[@"Item"];
                NSString *imageUrl1 = item1[@"img1"];
                NSString *itemTitle1 = item1[@"title"];
                NSString *itemId1 = item1[@"id"];
                NSString *price1 = item1[@"price"];
                
                NSDictionary *itemRoot2;
                NSDictionary *item2 = @{};
                NSString *imageUrl2;
                NSString *itemTitle2;
                NSString *itemId2;
                NSString *price2;
                if (ItemArray.count > line + 1){
                    itemRoot2 = ItemArray[line + 1];
                    item2 = itemRoot2[@"Item"];
                    imageUrl2 = item2[@"img1"];
                    itemTitle2 = item2[@"title"];
                    itemId2 = item2[@"id"];
                    price2 = item2[@"price"];
                }
                
                NSString *url1 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl1];
                NSString *url2 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl2];
                NSURLRequest *getImageRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                NSURLRequest *getImageRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
                UIButton *shopBtn1 = [[UIButton alloc]
                                      initWithFrame:CGRectMake(0, 5, 300, 300)];
                UIButton *shopBtn2;
                if (ItemArray.count > line + 1)shopBtn2 = [[UIButton alloc]
                                                           initWithFrame:CGRectMake(0, 5, 300, 300)];
                [shopBtn1 addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
                [shopBtn2 addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
                shopBtn1.tag = [itemId1 intValue];
                shopBtn2.tag = [itemId2 intValue];
                shopBtn1.alpha = 0.0;
                shopBtn2.alpha = 0.0;
                //UIImageView *shopImageView = [[UIImageView alloc] initWithImage:img];
                //shopImageView.contentMode = UIViewContentModeScaleToFill;
                shopBtn1.frame = CGRectMake(5, 2.5, 305/2, 305/2);
                shopBtn2.frame = CGRectMake(10 + 305/2, 2.5, 305/2, 305/2);
                UIImageView *itemImageView;
                if ([imageUrl1 isEqual:[NSNull null]] || [imageUrl1 isEqualToString:@""]) {
                    UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                    [shopBtn1 setBackgroundImage:noImage1 forState:UIControlStateNormal];
                    shopBtn1.frame = CGRectMake(4, 5, 307/2, 308/2);
                    
                    UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                    UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                    [noImageView2 setFrame:CGRectMake(307/4 - 25, 308/4 - 25, 50, 50)];
                    [shopBtn1 addSubview:noImageView2];
                    
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(1, 1, 303/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn1 addSubview:itemImageView];
                }else{
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(0, 0, 305/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn1 addSubview:itemImageView];
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,-5,148,40)];
                    itemLabel.text = itemTitle1;
                    itemLabel.textColor = [UIColor whiteColor];
                    itemLabel.backgroundColor = [UIColor clearColor];
                    itemLabel.alpha = 1.0;
                    itemLabel.font = [UIFont boldSystemFontOfSize:10];
                    itemLabel.numberOfLines = 2;
                    [itemImageView addSubview:itemLabel];
                    
                    
                    
                    
                    
                    //お金表記
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [nf setCurrencyCode:@"JPY"];
                    NSNumber *numPrice = @([price1 intValue]);
                    NSString *strPrice = [nf stringFromNumber:numPrice];
                    
                    NSLog(@"文字がおかしいよ%@",strPrice);
                    NSLog(@"文字がおかしいよ%d",strPrice.length);
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 128,52,28)];
                    priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
                    priceLabel.textColor = [UIColor whiteColor];
                    priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.45f];
                    priceLabel.font = [UIFont systemFontOfSize:12];
                    priceLabel.textAlignment = NSTextAlignmentRight;
                    priceLabel.layer.cornerRadius = 2;
                    priceLabel.numberOfLines = 1;
                    [itemImageView addSubview:priceLabel];
                    CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                                  constrainedToSize:CGSizeMake(200, 28)
                                                      lineBreakMode:priceLabel.lineBreakMode];
                    priceLabel.frame = CGRectMake(148 - textSize.width, 128,textSize.width,20);
                    
                    
                    [cell addSubview:shopBtn1];
                    
                    AFImageRequestOperation *operation3 = [AFImageRequestOperation
                                                           imageRequestOperationWithRequest: getImageRequest1
                                                           imageProcessingBlock: nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                               [ai stopAnimating];
                                                               
                                                               int imageW = getImage.size.width;
                                                               int imageH = getImage.size.height;
                                                               
                                                               int minSize = 0;
                                                               if (imageH <= imageW) {
                                                                   //横長の場合
                                                                   minSize = imageH;
                                                               } else {
                                                                   //縦長の場合
                                                                   minSize = imageW;
                                                               }
                                                               
                                                               
                                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                   [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                                       //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                                       
                                                                       
                                                                       
                                                                       [shopBtn1 setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                       
                                                                       [UIView animateWithDuration:0.6f
                                                                                             delay:0.0f
                                                                                           options:UIViewAnimationOptionAllowUserInteraction
                                                                                        animations:^(void){
                                                                                            shopBtn1.alpha = 1.0;
                                                                                        }
                                                                        
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                   }];
                                                               });
                                                               
                                                               
                                                           }
                                                           failure: nil];
                    [operation3 start];
                    
                }
                
                
                if ([imageUrl2 isEqual:[NSNull null]] || [imageUrl2 isEqualToString:@""]) {
                    UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                    [shopBtn2 setBackgroundImage:noImage1 forState:UIControlStateNormal];
                    shopBtn2.frame = CGRectMake(9 + 305/2, 5, 307/2, 308/2);
                    
                    UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                    UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                    [noImageView2 setFrame:CGRectMake(307/4 - 25, 308/4 - 25, 50, 50)];
                    [shopBtn2 addSubview:noImageView2];
                    
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(1, 1, 303/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn2 addSubview:itemImageView];
                }else{
                    UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                    //itemBg = [self rotateImage:itemBg angle:180];
                    itemImageView = [[UIImageView alloc] initWithImage:itemBg];
                    itemImageView.frame = CGRectMake(0, 0, 305/2, 32);
                    //itemImageView.opaque = 0.45;
                    [shopBtn2 addSubview:itemImageView];
                    
                    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(6,-5,148,40)];
                    itemLabel.text = itemTitle2;
                    itemLabel.textColor = [UIColor whiteColor];
                    itemLabel.backgroundColor = [UIColor clearColor];
                    itemLabel.alpha = 1.0;
                    itemLabel.font = [UIFont boldSystemFontOfSize:10];
                    itemLabel.numberOfLines = 2;
                    [itemImageView addSubview:itemLabel];
                    
                    
                    
                    //お金表記
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                    [nf setCurrencyCode:@"JPY"];
                    NSNumber *numPrice = @([price2 intValue]);
                    NSString *strPrice = [nf stringFromNumber:numPrice];
                    
                    NSLog(@"文字がおかしいよ%@",strPrice);
                    NSLog(@"文字がおかしいよ%d",strPrice.length);
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 128,52,28)];
                    priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
                    priceLabel.textColor = [UIColor whiteColor];
                    priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.45f];
                    priceLabel.font = [UIFont systemFontOfSize:12];
                    priceLabel.textAlignment = NSTextAlignmentRight;
                    priceLabel.layer.cornerRadius = 2;
                    priceLabel.numberOfLines = 1;
                    [itemImageView addSubview:priceLabel];
                    CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                                  constrainedToSize:CGSizeMake(200, 28)
                                                      lineBreakMode:priceLabel.lineBreakMode];
                    priceLabel.frame = CGRectMake(148 - textSize.width, 128,textSize.width,20);
                    
                    
                    if (ItemArray.count > line + 1)[cell addSubview:shopBtn2];
                    
                    AFImageRequestOperation *operation3 = [AFImageRequestOperation
                                                           imageRequestOperationWithRequest: getImageRequest2
                                                           imageProcessingBlock: nil
                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                               
                                                               int imageW = getImage.size.width;
                                                               int imageH = getImage.size.height;
                                                               
                                                               int minSize = 0;
                                                               if (imageH <= imageW) {
                                                                   //横長の場合
                                                                   minSize = imageH;
                                                               } else {
                                                                   //縦長の場合
                                                                   minSize = imageW;
                                                               }
                                                               
                                                               
                                                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                   [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                                       //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                                       
                                                                       
                                                                       
                                                                       [shopBtn2 setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                       
                                                                       [UIView animateWithDuration:0.6f
                                                                                             delay:0.0f
                                                                                           options:UIViewAnimationOptionAllowUserInteraction
                                                                                        animations:^(void){
                                                                                            shopBtn2.alpha = 1.0;
                                                                                        }
                                                                        
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                   }];
                                                               });
                                                               
                                                               
                                                           }
                                                           failure: nil];
                    [operation3 start];
                    
                }
                
                
                //contentSize = (shopBtn.frame.size.height + shopBtn.frame.origin.y + 5);
                
                
                
                //}
                
            }
        }
        return cell;

    }
    
    return cell;

    
}


- (void)updateItemCell:(ItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {


    int line = 0;
    if (indexPath.row == 0) {
        line = 0;
    }else{
        line = indexPath.row * 2;
    }
    NSDictionary *itemRoot1 = ItemArray[line];
    NSDictionary *item1 = itemRoot1[@"Item"];
    NSString *imageUrl1 = item1[@"img1"];
    NSString *itemTitle1 = item1[@"title"];
    NSString *itemId1 = item1[@"id"];
    NSString *price1 = item1[@"price"];
    
    
    NSDictionary *itemRoot2;
    NSDictionary *item2 = @{};
    NSString *imageUrl2;
    NSString *itemTitle2;
    NSString *itemId2;
    NSString *price2;
    
    if (ItemArray.count > line + 1){
        itemRoot2 = ItemArray[line + 1];
        item2 = itemRoot2[@"Item"];
        imageUrl2 = item2[@"img1"];
        itemTitle2 = item2[@"title"];
        itemId2 = item2[@"id"];
        price2 = item2[@"price"];
    }
    
    
    
    cell.number = indexPath.row;
    
    NSString *url1 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl1];
    NSString *url2 = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl2];
    NSURLRequest *getImageRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
    NSURLRequest *getImageRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];


    [cell.leftItemButton addTarget:self
                 action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightItemButton addTarget:self
                 action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.leftItemButton.tag = [itemId1 intValue];
    cell.rightItemButton.tag = [itemId2 intValue];
    //UIImageView *shopImageView = [[UIImageView alloc] initWithImage:img];
    //shopImageView.contentMode = UIViewContentModeScaleToFill;
    cell.leftItemButton.alpha = 0.0;
    cell.rightItemButton.alpha = 0.0;
    
    
    cell.leftTitleLabel.text = itemTitle1;
    
    //お金表記
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencyCode:@"JPY"];
    NSNumber *numPrice = @([price1 intValue]);
    NSString *strPrice = [nf stringFromNumber:numPrice];
    NSLog(@"文字がおかしいよ%@",strPrice);
    NSLog(@"文字がおかしいよ%d",strPrice.length);
    [cell.leftItemButton setBackgroundImage:nil forState:UIControlStateNormal];
    cell.leftPriceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
    cell.leftPriceLabel.layer.cornerRadius = 2;
    //[cell.leftPriceLabel sizeToFit];
        AFImageRequestOperation *operation3 = [AFImageRequestOperation
                                               imageRequestOperationWithRequest: getImageRequest1
                                               imageProcessingBlock: nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                   [ai stopAnimating];
                                                   
                                                   int imageW = getImage.size.width;
                                                   int imageH = getImage.size.height;
                                                   
                                                   int minSize = 0;
                                                   if (imageH <= imageW) {
                                                       //横長の場合
                                                       minSize = imageH;
                                                   } else {
                                                       //縦長の場合
                                                       minSize = imageW;
                                                   }
                                                   
                                                   
                                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                       [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                           //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                           
                                                           
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{

                                                               if (cell.number == indexPath.row) {
                                                                   [cell.leftItemButton setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                   [UIView animateWithDuration:0.6f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^(void){
                                                                                        cell.leftItemButton.alpha = 1.0;
                                                                                    }
                                                                    
                                                                                    completion:^(BOOL finished){
                                                                                        
                                                                                    }];
                                                               }
                                                               
                                                           
                                                           });

                                                           
                                                           
                                                           
                                                       }];
                                                   });
                                                   
                                                   
                                               }
                                               failure: nil];
        [operation3 start];
    

        
        cell.rightTitleLabel.text = itemTitle2;
        
        //お金表記
    if ([price2 intValue] == 0) {
        cell.rightPriceLabel.text = [NSString stringWithFormat:@""];
        
        
    }else{
        nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        [nf setCurrencyCode:@"JPY"];
        numPrice = [NSNumber numberWithInt:[price2 intValue]];
        strPrice = [nf stringFromNumber:numPrice];
        
        NSLog(@"文字がおかしいよ%@",strPrice);
        NSLog(@"文字がおかしいよ%d",strPrice.length);
        cell.rightPriceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
    }

    [cell.rightItemButton setBackgroundImage:nil forState:UIControlStateNormal];

        AFImageRequestOperation *operation = [AFImageRequestOperation
                                               imageRequestOperationWithRequest: getImageRequest2
                                               imageProcessingBlock: nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                   
                                                   int imageW = getImage.size.width;
                                                   int imageH = getImage.size.height;
                                                   
                                                   int minSize = 0;
                                                   if (imageH <= imageW) {
                                                       //横長の場合
                                                       minSize = imageH;
                                                   } else {
                                                       //縦長の場合
                                                       minSize = imageW;
                                                   }
                                                   
                                                   
                                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                       [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                                                           //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                                                           
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{

                                                               if (cell.number == indexPath.row) {

                                                                   [cell.rightItemButton setBackgroundImage:resultImg forState:UIControlStateNormal];
                                                                   [UIView animateWithDuration:0.6f
                                                                                         delay:0.0f
                                                                                       options:UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^(void){
                                                                                        cell.rightItemButton.alpha = 1.0;
                                                                                    }
                                                                    
                                                                                    completion:^(BOOL finished){
                                                                                        
                                                                                    }];
                                                               }
                                                           
                                                           });

                                                           
                                                           
                                                           
                                                       }];
                                                   });
                                                   
                                                   
                                               }
                                               failure: nil];
        [operation start];
    

}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // For even
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    // For odd
    else {
        cell.backgroundColor = [UIColor colorWithHue:0.61
                                          saturation:0.09
                                          brightness:0.99
                                               alpha:1.0];
    }
}
*/
//cellをタップ
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"三行の場合の高さ%f",aboutLabel.frame.size.height);
    
    //aboutLabelがあるsectionのみ
    if (isOpened && tableView.numberOfSections - 2 == indexPath.section && isMoreThreeLines) {
        isOpened = NO;
        aboutLabelGradationView.hidden = NO;
        [self resizeAboutLabel:3];
        [self openShopDescription:indexPath];
    }else if (!isOpened && tableView.numberOfSections - 2 == indexPath.section && isMoreThreeLines){
        isOpened = YES;
        aboutLabelGradationView.hidden = YES;
        [self resizeAboutLabel:0];
        [self openShopDescription:indexPath];
    }
}

//aboutLabelをのサイズ変更
- (void)resizeAboutLabel:(int)visibleLine{
    [aboutLabel setNumberOfLines:visibleLine];
    [aboutLabel sizeToFit];
}
//お店の説明を表示or非表示にする
- (void)openShopDescription:(NSIndexPath *)indexPath{
    
    NSArray* paths = @[indexPath];
    [shopTable beginUpdates];
    [shopTable insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [shopTable deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [shopTable endUpdates];
    [shopTable deselectRowAtIndexPath:indexPath animated:YES];
    
}

//画像を回転させる
- (UIImage *) rotateImage:(UIImage *)img angle:(int)angle
{
    CGImageRef imgRef = [img CGImage];
    CGContextRef context;
    
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            NSLog(@"you can select an angle of 90, 180, 270");
            return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}


-(float)textHeight:(NSString*)text{
	CGSize boundingSize = CGSizeMake(320, 400);
	//文字の横幅から高さを算出
	CGSize labelsize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                        constrainedToSize:boundingSize
                            lineBreakMode:NSLineBreakByWordWrapping];
	return labelsize.height;
}



//画像トリミング
- (void)resizeAspectFitImageWithImage:(UIImage*)img atSize:(CGFloat)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    // リサイズする倍率を求める
    CGFloat scale = img.size.width < img.size.height ? size/img.size.height : size/img.size.width;
    // CGAffineTransformでサイズ変更
    CIImage *filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale,scale)];
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
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}


- (void)backRoot{
    /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    */
    /*
     CATransition *transition = [CATransition animation];
     transition.duration = 0.4f;
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
     
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
     */
    /*
     CATransition *transition = [CATransition animation];
     transition.duration = 0.4f;
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
     
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
     */
    /*
     CATransition *transition = [CATransition animation];
     transition.duration = 0.4f;
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
     
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
     */
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aboutItem:(id)sender{
    
    
    //UIButton *sender_btn = [(UIButton *)sender copy];

    /*
    UIView *preView = [[UIView alloc] init];
    preView.frame = CGRectMake(10,self.view.frame.size.height + 10,300,400);
    preView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.65f];
    [[preView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
    [[preView layer] setBorderWidth:1.0];
    [self.view addSubview:preView];
    
    //スクロール
    UIScrollView *itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,300,300)];
    itemScrollView.contentSize = CGSizeMake(900, 300);
    itemScrollView.scrollsToTop = NO;
    itemScrollView.delegate = self;
    itemScrollView.scrollEnabled = YES;
    itemScrollView.pagingEnabled = YES;
    [preView addSubview:itemScrollView];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shops/get_item?item_id=%d",apiUrl,[sender tag]];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [loadingImageView stopAnimating];
        NSLog(@"ログイン情報！: %@", JSON);
        NSDictionary *result = [JSON objectForKey:@"result"];
        NSString *imageUrl = [JSON objectForKey:@"image_url"];
        //importShopId = [JSON valueForKeyPath:@"result.Item.user_id"];
        NSString *itemUrl = [JSON objectForKey:@"item_url"];
        if (result) {
            [self addSubViews:result getImageUrl:imageUrl itemUrl:itemUrl setView:preView setScrollView:itemScrollView];
        }else{
            //jsonでエラーが出た時
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void){
                         preView.frame = CGRectMake(10, 40,300,400);

                         
                     }
     
                     completion:^(BOOL finished){
                         
                     }];
     */
    
    
    importItemId = [NSString stringWithFormat:@"%d",[sender tag]];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutItem"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)shareToSNS:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    
    actionSheet.delegate = self;
    actionSheet.title = @"ショップををSNSで共有する";
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"LINE"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    actionSheet.cancelButtonIndex = 3;
    [actionSheet showInView:self.view];
}

- (void)aboutShop{
    
    NSString *userId = [BSBuyTopViewController getShopId];
    importShopId = userId;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shopInfo"];
    [self presentViewController:vc animated:YES completion: ^{
        
        NSLog(@"完了");}];
}



//店舗詳細に行く
-(void)goShopPage:(UIButton*)button{
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    NSLog(@"しょっぷID:%d",button.tag);
    importShopId = [NSString stringWithFormat:@"%d",button.tag];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shop"];
    [self.navigationController pushViewController:vc animated:YES];

    [UIView animateWithDuration:0.3 animations:^{
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    
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
            footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y - itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
            itemListView.frame = CGRectMake(0, self.view.frame.size.height - itemListView.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
            
            footerView.favoriteButton.backgroundColor = [UIColor grayColor];
            footerView.cartButton.backgroundColor = [UIColor whiteColor];
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            footerView.cartButton.layer.borderWidth = 0.25f;
            [footerView.cartButton setTintColor:[UIColor lightGrayColor]];
            [footerView.cartButton setImage:[UIImage imageNamed:@"icon_7_f_buy_cart"] forState:UIControlStateNormal];
            footerView.frame = CGRectMake(footerView.frame.origin.x, footerView.frame.origin.y + itemListView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
            itemListView.frame = CGRectMake(0, self.view.frame.size.height, itemListView.frame.size.width, itemListView.frame.size.height);
            
            footerView.favoriteButton.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            
        }];
        
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
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    // don't forget to set parameterEncoding!
    NSLog(@"＠あらめーた！: %@", mdic);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:mdic];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"お気に入り情報！: %@", JSON);
        NSDictionary *error = [JSON valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self setCartViewIOS7:JSON];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
}

- (void)setCartViewIOS7:(id)jsonData{
    
    
    
    NSArray *itemArray = jsonData[@"result"];
    NSString *imageUrl = jsonData[@"image_url"];
    NSLog(@"あいてむすう: %d", itemArray.count);
    
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
            
            AFImageRequestOperation *operation = [AFImageRequestOperation
                                                  imageRequestOperationWithRequest: getImageRequest
                                                  imageProcessingBlock: nil
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                      [itemView setImage:getImage];
                                                      
                                                  }
                                                  failure: nil];
            [operation start];
        }
    }
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
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    // don't forget to set parameterEncoding!
    NSLog(@"＠あらめーた！: %@", mdic);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:mdic];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"お気に入り情報！: %@", JSON);
        NSDictionary *error = [JSON valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeCartView:JSON];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    if (favoriteIsShowed) {
        cartlistScroll.hidden = NO;
        favoritelistScroll.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"icon_f_buy_cart_s"];
        [cartBtn setImage:image forState:UIControlStateNormal];
        UIImage *image2 = [UIImage imageNamed:@"icon_f_buy_star"];
        [favoriteBtn setImage:image2 forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            NSLog(@"アニメーションしてるよ");
            triView.frame = CGRectMake(68, [[UIScreen mainScreen] bounds].size.height - 90, 10, 10);
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
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 61,135,35);
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
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 127,135,35);
            triView.alpha = 1.0;
            listView.alpha = 1.0;
            triView.frame = CGRectMake(68, [[UIScreen mainScreen] bounds].size.height - 90, 10, 10);
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
            
            AFImageRequestOperation *operation = [AFImageRequestOperation
                                                  imageRequestOperationWithRequest: getImageRequest
                                                  imageProcessingBlock: nil
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                      [itemView setImage:getImage];
                                                      getImage = nil;
                                                      
                                                  }
                                                  failure: nil];
            [operation start];
        }
    }
    
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
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    // don't forget to set parameterEncoding!
    NSLog(@"＠あらめーた！: %@", mdic);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:mdic];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"お気に入り情報！: %@", JSON);
        NSDictionary *error = [JSON valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            NSLog(@"エラー！: %@", errormessage);
        }else{
            [self arrangeFavoriteView:JSON];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    
    
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
            triView.frame = CGRectMake(24, [[UIScreen mainScreen] bounds].size.height - 90, 10, 10);
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
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 61,135,35);
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
            smallMenuView.frame = CGRectMake(5,[[UIScreen mainScreen] bounds].size.height - 127,135,35);
            triView.alpha = 1.0;
            listView.alpha = 1.0;
            triView.frame = CGRectMake(24, [[UIScreen mainScreen] bounds].size.height - 90, 10, 10);
        } completion:^(BOOL finished) {
        }];
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
            
            AFImageRequestOperation *operation = [AFImageRequestOperation
                                                  imageRequestOperationWithRequest: getImageRequest
                                                  imageProcessingBlock: nil
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                      [itemView setImage:getImage];
                                                      
                                                  }
                                                  failure: nil];
            [operation start];
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
    
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];

}

- (void)goCart:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    if (favoriteIsShowed) {
        [self showFavorite:nil];
    }else if (cartIsShowed){
        [self showCart:nil];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{

        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
}


//========================================================================

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self getScrollSpeed:scrollView];
    //テーブルをするロールさせたときのアニメーション
        NSLog(@"%@",scrollView);
        if (0 > [scrollView contentOffset].y) {
            
            [UIView animateWithDuration:0.2 animations:^{
                smallMenuView.alpha = 0.7f;
                if (favoriteIsShowed || cartIsShowed) {
                    triView.alpha = 1.0;
                    listView.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
            }];
            return;
        }
        if (self.beginScrollOffsetY < [scrollView contentOffset].y) {
            NSLog(@"うごいているお");
            //スクロール前のオフセットよりスクロール後が多い=下を見ようとした =>スクロールバーを隠す
            [UIView animateWithDuration:0.1 animations:^{
                smallMenuView.alpha = 0;
                if (favoriteIsShowed || cartIsShowed) {
                    triView.alpha = 0;
                    listView.alpha = 0;
                }
    
            } completion:^(BOOL finished) {
            }];
        } else if ([scrollView contentOffset].y < self.beginScrollOffsetY
                   && 0.0 != self.beginScrollOffsetY ) {
            
            
            NSLog(@"うごかないいいいい");

            [UIView animateWithDuration:0.3 animations:^{
                
                smallMenuView.alpha = 0.7f;
                if (favoriteIsShowed || cartIsShowed) {
                    triView.alpha = 1.0;
                    listView.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
            }];
        }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    [UIView animateWithDuration:0.3 animations:^{
        smallMenuView.alpha = 0.7f;
        if (favoriteIsShowed || cartIsShowed) {
            triView.alpha = 1.0;
            listView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];
    
}
- (void) getScrollSpeed:(UIScrollView *)scrollView {
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
    if(timeDiff > 0.1) {
        CGFloat distance = currentOffset.y - lastOffset.y;
        
        CGFloat scrollSpeedNotAbs = (distance * 10) / 1000;
        
        CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
        NSLog(@"すぴいいいいいいいど%f",scrollSpeed);
        if (scrollSpeed > 4.0) {
            isScrollingFast = YES;
            NSLog(@"Fast");
        } else {
            isScrollingFast = NO;
            NSLog(@"Slow");
        }
        
        lastOffset = currentOffset;
        lastOffsetCapture = currentTime;
    }
}

//========================================================================
#pragma mark - social

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSURL *url = [NSURL URLWithString:@"http://gogengo.me"];
    switch (buttonIndex) {
        case 0:
            [self sendTwitter];
            break;
        case 1:
            [self sendFacebook:shareImage title:[NSString stringWithFormat:@"%@",socialInfo[@"facebook"]] url:socialInfo[@"shopUrl"]];
            break;
        case 2:
            [self postToLine];
            break;
        case 3:
            // キャンセルの場合
            break;
    }
}

- (void)postToLine {
    /*
     // この例ではUIImageクラスの_resultImageを送る
     UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
     [pasteboard setData:UIImagePNGRepresentation(shareImage) forPasteboardType:@"public.png"];
     */
    
    // pasteboardを使ってパスを生成
    NSString *content = [NSString stringWithFormat:@"%@",socialInfo[@"line"]];
    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/text/%@%@",content,socialInfo[@"shopUrl"]];
    
    // URLスキームを使ってLINEを起動
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LineUrlString]];
}

- (void)sendTwitter{
    NSString* postContent = [NSString stringWithFormat:@"%@",socialInfo[@"twitter"]];
    NSURL* appURL = [NSURL URLWithString:@"https://thebase.in/"];
    // =========== iOSバージョンで、処理を分岐 ============
    // iOS Version
    NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Social.frameworkを使う
    if ([iosVersion floatValue] >= 6.0) {
        SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPostVC setInitialText:postContent];
        //[twitterPostVC addURL:appURL]; // アプリURL
        [self presentViewController:twitterPostVC animated:YES completion:nil];
    }
    // Twitter.frameworkを使う
    else if ([iosVersion floatValue] >= 5.0) {
        // Twitter画面を保持するViewControllerを作成する。
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        // 初期表示する文字列を指定する。
        [twitter setInitialText:postContent];
        // TweetにURLを追加することが出来ます。
        [twitter addURL:appURL];
        // Tweet後のコールバック処理を記述します。
        // ブロックでの記載となり、引数にTweet結果が渡されます。
        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (res == TWTweetComposeViewControllerResultDone)
                NSLog(@"tweet done.");
            else if (res == TWTweetComposeViewControllerResultCancelled)
                NSLog(@"tweet canceled.");
        };
        // Tweet画面を表示します。
        [self presentViewController:twitter animated:YES completion: ^{
            
            NSLog(@"完了");}];
    }
}


- (NSString *)encode:(NSString *)string
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}


- (void)sendFacebook:(UIImage *)image title:(NSString *)title url:(NSString *)urlString
{
    if(NSClassFromString(@"SLComposeViewController")) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@\n%@", title, urlString]];
        [composeViewController addImage:image];
        [self.navigationController presentViewController:composeViewController
                                                animated:YES
                                              completion:nil];
    } else {
        // iOS 5 以下はブラウザに移動してシェア機能を起動する
        NSString *escapedMessage = [self encode:title];
        NSString *escapedUrlString = [self encode:urlString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@&t=%@", escapedUrlString, escapedMessage]]];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    self.beginScrollOffsetY = [scrollView contentOffset].y;
}

#pragma mark - Public
+(NSString*)getShopId {
    return importShopId;
}
+(void)resetShopId {
    importShopId = nil;
}

//アイテムIdを取得
+(NSString*)getItemId {
    return importItemId;
}
+(void)setItemId:(NSString*)str {
    importItemId = [str copy];
}




@end
