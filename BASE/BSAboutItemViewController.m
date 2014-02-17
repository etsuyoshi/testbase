//
//  BSAboutItemViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/23.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSAboutItemViewController.h"

#import "BSMainPagingScrollView.h"
#import "BSItemView.h"
#import "BSBuyTopViewController.h"



@interface BSAboutItemViewController ()

@end

@implementation BSAboutItemViewController{
    UIScrollView *scrollView;
    UIImageView *starImageView;
    
    BOOL favorited;
    NSString *itemId;
    
    int buttonTag;
    UIActionSheet *stockActionSheet;
    BOOL firstButton;
    UIPickerView *stockPicker;
    
    NSMutableArray *variationNameArray;
    NSMutableArray *variationStockArray;
    
    int selectedRow;
    
    NSArray *variation;
    NSString *stock;
    
    
    
    UIButton *varyNameButton;
    UILabel *varyNamelabel;
    
    UIButton *stockButton;
    UILabel *stocklabel;
    
    UIImageView *loadingImageView;
    
    NSString *shopId;
    
    UIImage *shareImage;
    
    UINavigationItem *navItem;
    
    NSString *itemUrl;
    NSString *itemName;
    NSString *shopName;
    
    
    BSMainPagingScrollView *mainScrollView;
    
    UIPageControl *pc;
    
    UIActivityIndicatorView *ai;
    
    NSString *apiUrl;
    
    NSMutableDictionary *socialInfo;
    
    //ios7orios6ypoint
    int originY;
    
    //ios7View
    UIView *whiteCardView;
    
    BSItemView *footerView;
}
@synthesize importItemId;
static NSString *importShopId = nil;



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
    self.title = @"商品詳細";

    
    apiUrl = [BSDefaultViewObject setApiUrl];
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:swipeRightGesture];
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        originY = 64;
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        
        footerView = [BSItemView setView];
        footerView.frame = CGRectMake(0, self.view.frame.size.height - footerView.frame.size.height, footerView.frame.size.width, footerView.frame.size.height);
        [self.view addSubview:footerView];
        
        [[footerView.socialButton layer] setBorderWidth:0.25f];
        [[footerView.socialButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[footerView.favoriteButton layer] setBorderWidth:0.25f];
        [[footerView.favoriteButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [footerView.cartButton addTarget:self action:@selector(selectNumber:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.socialButton addTarget:self action:@selector(shareToSNS:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.favoriteButton addTarget:self action:@selector(favoriteIOS7:) forControlEvents:UIControlEventTouchUpInside];

        
    }else{
        originY = 0;
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"店舗詳細" target:self action:@selector(back) side:1];
        //UIView *view = [backButton valueForKey:@"view"];
        
        
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
    
    /*
    //ナビゲーションバー
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    navItem = [[UINavigationItem alloc] initWithTitle:@""];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
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
    //[menuButton setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(aboutShop) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
    menuButtonView.backgroundColor = [UIColor clearColor];
    [menuButtonView addSubview:menuButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //スクロール
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height - 108)];
        scrollView.contentSize = CGSizeMake(320, 680);
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        [self.view insertSubview:scrollView belowSubview:self.navigationController.navigationBar];
        
        /*
        //カートボタン
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 44,320,44)];
        navBar.translucent = YES;
        UINavigationItem *navItem = [[UINavigationItem alloc] init];
        //[navBar pushNavigationItem:navItem animated:YES];
        [self.view addSubview:navBar];
        
        
        // 標準ボタン例文
        UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cartBtn.tag = 100;
        cartBtn.frame = CGRectMake(0, 0, 320,40);
        [cartBtn setTitle:@"カートに入れる" forState:UIControlStateNormal];
        // ボタンがタッチダウンされた時にhogeメソッドを呼び出す
        [cartBtn addTarget:self action:@selector(addToCart:)
      forControlEvents:UIControlEventTouchDown];
        [navBar addSubview:cartBtn];
        */
        
    }else{
        //スクロール
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 44)];
        scrollView.contentSize = CGSizeMake(320, 680);
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        [self.view insertSubview:scrollView belowSubview:self.navigationController.navigationBar];
    }
    

    
    
    mainScrollView = [[BSMainPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    //mainScrollView.contentSize = CGSizeMake(800, 500);
    mainScrollView.pagingEnabled = YES;
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    mainScrollView.tag = 20;
    mainScrollView.delegate = self;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.backgroundColor = [UIColor clearColor];
    //mainScrollView.contentOffset = CGPointMake(0, 0);
    [scrollView addSubview:mainScrollView];
    
    
    pc = [[UIPageControl alloc] init];
    pc.frame = CGRectMake(100, self.view.frame.size.height - 50, 160, 30);
    pc.center = CGPointMake(160, self.view.frame.size.height - 24);
    pc.numberOfPages = 6;
    pc.currentPage = 0;
    [scrollView addSubview:pc];
    /*
    UILabel *aboutItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,440,290,200)];
    aboutItemLabel.text = @"イベリコ本来の赤身の味が存分に贅沢に堪能できる、イベリコ豚肩ロースをしゃぶしゃぶ用に超薄にスライス！その厚さは1.5mm（通常2mm）。 沸騰するかしないかくらいのお湯でさっとくぐらせて！ 甘みがたまらないしゃぶしゃぶを味わってみてください！\n使い勝手のよい商品です。色んな料理にアレンジしてみてください！";
    aboutItemLabel.textColor = [UIColor grayColor];
    aboutItemLabel.backgroundColor = [UIColor clearColor];
    aboutItemLabel.font = [UIFont systemFontOfSize:14];
    aboutItemLabel.textAlignment = NSTextAlignmentLeft;
    aboutItemLabel.numberOfLines = 0;
    [scrollView addSubview:aboutItemLabel];
    */
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ai = [[UIActivityIndicatorView alloc] init];
    ai.frame = CGRectMake(0, 0, 50, 50);
    ai.center = self.view.center;
    ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:ai];
    
    [ai startAnimating];
     
     for (UIView *subview in [scrollView subviews]) {
         [subview removeFromSuperview];
     }
    
    
    
    int index = [self.navigationController.viewControllers count];
    UIViewController *parent = (self.navigationController.viewControllers)[index-2];
    NSLog(@"小ビューの情報%@",parent);
    
    if ([parent isKindOfClass:[BSShopViewController class]]) {
        //アイテムId
        itemId = [BSShopViewController getItemId];
    }else if ([parent isKindOfClass:[BSFavoriteViewController class]]) {
        itemId = [BSFavoriteViewController getItemId];
    }else if ([parent isKindOfClass:[BSBuyTopViewController class]]){
        itemId = [BSBuyTopViewController getItemId];

    }
    //グーグルアナリティクス
    self.trackedViewName = [NSString stringWithFormat:@"aboutItem,itemId:%@",itemId];
    
    
    
    NSLog(@"%@",itemId);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/shops/get_item?item_id=%@",apiUrl,itemId];
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
        NSDictionary *result = JSON[@"result"];
        NSString *imageUrl = JSON[@"image_url"];
        importShopId = [JSON valueForKeyPath:@"result.Item.user_id"];
        itemUrl = JSON[@"item_url"];
        
        socialInfo = [NSMutableDictionary dictionary];
        socialInfo[@"facebook"] = [JSON valueForKeyPath:@"social.facebook_content"];
        socialInfo[@"twitter"] = [JSON valueForKeyPath:@"social.tweet_content"];
        socialInfo[@"line"] = [JSON valueForKeyPath:@"social.line_content"];
        socialInfo[@"itemUrl"] = [JSON valueForKeyPath:@"item_url"];
        if (result) {
            if ([BSDefaultViewObject isMoreIos7]) {
                [self addIos7SubViews:result getImageUrl:imageUrl];

            }else{
                [self addSubViews:result getImageUrl:imageUrl];

            }
        }else{
            //jsonでエラーが出た時
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
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


- (void)favoriteIOS7:(id)sender{
    
    if (favorited) {
        [UIView animateWithDuration:0.2 animations:^{
            [footerView.favoriteButton setBackgroundColor:[UIColor whiteColor]];
            [footerView.favoriteButton setTitle:@"お気に入りに追加" forState:UIControlStateNormal]; //有効時
            [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_f_buy_star.png"] forState:UIControlStateNormal]; //有効時
            [footerView.favoriteButton setTintColor:[UIColor lightGrayColor]];

             } completion:^(BOOL finished) {
                 
                 //お気に入りに追加
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                 NSMutableArray *copiedFavoriteArray = [favoriteArray mutableCopy];
                 NSLog(@"取得した配列%@",copiedFavoriteArray);
                 for (int n = 0; n < copiedFavoriteArray.count; n++) {
                     NSString *favoritedItemId = copiedFavoriteArray[n];
                     if ([favoritedItemId isEqualToString:itemId]) {
                         [copiedFavoriteArray removeObjectAtIndex:n];
                         [userDefaults setObject:copiedFavoriteArray forKey:@"favorite"];
                     }
                 }
                 
                 favorited = NO;
             }];
        
    }else{
            [UIView animateWithDuration:0.2 animations:^{
                //[footerView.favoriteButton setTintColor:[UIColor yellowColor]];
                //[footerView.favoriteButton setBackgroundColor:[UIColor yellowColor]];

                [footerView.favoriteButton setTitle:@"お気に入り" forState:UIControlStateNormal]; //有効時
                [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_b_buy_star"] forState:UIControlStateNormal]; //有効時
                [footerView.favoriteButton setTintColor:[UIColor colorWithRed:46.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.0]];
            } completion:^(BOOL finished) {
                
                //お気に入りに追加
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //NSMutableArray* array = [NSMutableArray array];
                NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                NSLog(@"取得した配列%@",favoriteArray);
                if (!favoriteArray) {
                    // NSArrayの保存
                    NSMutableArray* favoriteMutableArray = [NSMutableArray array];
                    [favoriteMutableArray addObject:itemId];
                    [userDefaults setObject:favoriteMutableArray forKey:@"favorite"];
                    
                    if ( ![userDefaults synchronize] ) {
                        NSLog( @"failed ..." );
                    }
                }else{
                    NSMutableArray *copiedFavoriteArray = [favoriteArray mutableCopy];
                    for (int n = 0; n < copiedFavoriteArray.count; n++) {
                        NSString *favoritedItemId = copiedFavoriteArray[n];
                        if ([favoritedItemId isEqualToString:itemId]) {
                            return ;
                        }
                    }
                    [copiedFavoriteArray addObject:itemId];
                    [userDefaults setObject:copiedFavoriteArray forKey:@"favorite"];
                    if ( ![userDefaults synchronize] ) {
                        NSLog( @"failed ..." );
                    }
                    
                }
                favorited = YES;
                NSLog(@"itemId:%@,アイテム名:%@",itemId,itemName);
                [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSAboutItemViewController"
                                                                 withAction:[NSString stringWithFormat:@"itemId:%@,アイテム名:%@",itemId,itemName]
                                                                  withLabel:nil
                                                                  withValue:@100];
            }];
    
    }
}
//お気に入りに追加ボタン
- (void)favorite:(id)sender{
    if (favorited) {
        UIImage *favoriteImage = [UIImage imageNamed:@"icon_f_buy_star"];
        [starImageView setImage:favoriteImage];
        [UIView animateWithDuration:0.2 animations:^{
            starImageView.frame = CGRectMake(6, -3, 32, 32);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                starImageView.frame = CGRectMake(9,0, 26, 26);
            } completion:^(BOOL finished) {
                
                //お気に入りに追加
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                NSMutableArray *copiedFavoriteArray = [favoriteArray mutableCopy];
                NSLog(@"取得した配列%@",copiedFavoriteArray);
                for (int n = 0; n < copiedFavoriteArray.count; n++) {
                    NSString *favoritedItemId = copiedFavoriteArray[n];
                    if ([favoritedItemId isEqualToString:itemId]) {
                        [copiedFavoriteArray removeObjectAtIndex:n];
                        [userDefaults setObject:copiedFavoriteArray forKey:@"favorite"];
                    }
                }
            
                favorited = NO;
            }];
        }];
    }else{
        UIImage *favoriteImage = [UIImage imageNamed:@"icon_f_buy_star_s"];
        [starImageView setImage:favoriteImage];
        [UIView animateWithDuration:0.2 animations:^{
            starImageView.frame = CGRectMake(7, -2, 30, 30);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                starImageView.frame = CGRectMake(9,0, 26, 26);
            } completion:^(BOOL finished) {
                
                //お気に入りに追加
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //NSMutableArray* array = [NSMutableArray array];
                NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                NSLog(@"取得した配列%@",favoriteArray);
                if (!favoriteArray) {
                    // NSArrayの保存
                    NSMutableArray* favoriteMutableArray = [NSMutableArray array];
                    [favoriteMutableArray addObject:itemId];
                    [userDefaults setObject:favoriteMutableArray forKey:@"favorite"];
                    
                    if ( ![userDefaults synchronize] ) {
                        NSLog( @"failed ..." );
                    }
                }else{
                    NSMutableArray *copiedFavoriteArray = [favoriteArray mutableCopy];
                    for (int n = 0; n < copiedFavoriteArray.count; n++) {
                        NSString *favoritedItemId = copiedFavoriteArray[n];
                        if ([favoritedItemId isEqualToString:itemId]) {
                            return ;
                        }
                    }
                    [copiedFavoriteArray addObject:itemId];
                    [userDefaults setObject:copiedFavoriteArray forKey:@"favorite"];
                    if ( ![userDefaults synchronize] ) {
                        NSLog( @"failed ..." );
                    }
                    
                }
                favorited = YES;
                NSLog(@"itemId:%@,アイテム名:%@",itemId,itemName);
                [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSAboutItemViewController"
                                                                 withAction:[NSString stringWithFormat:@"itemId:%@,アイテム名:%@",itemId,itemName]
                                                                  withLabel:nil
                                                                  withValue:@100];
            }];
        }];
    }
}

#pragma mark - ios7
-(void)addIos7SubViews:(NSDictionary*)jsonDictionary getImageUrl:(NSString*)imageUrl {
    

    NSDictionary *item = jsonDictionary[@"Item"];
    NSString *title = item[@"title"];
    itemName = title;
    shopId = item[@"user_id"];
    NSString *price = item[@"price"];
    NSString *detail = item[@"detail"];
    NSString *imageName = item[@"img1"];
    
    stock = item[@"stock"];
    NSLog(@"ストックstock:%@",stock);
    shopName = [jsonDictionary valueForKeyPath:@"Shop.shop_name"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -100, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = shopName;
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    variation = jsonDictionary[@"Variation"];
    NSString *variationName;
    NSString *variationStock;
    
    
    variationNameArray = [NSMutableArray array];
    variationStockArray = [NSMutableArray array];
    
    
    //商品画像名の取得
    NSMutableArray *imageNameArray = [NSMutableArray array];
    for (int n = 1; n < 5; n++) {
        NSString *imageName = item[[NSString stringWithFormat:@"img%d",n + 1]];
        
        if ([imageName isEqual:[NSNull null]] || [imageName isEqualToString:@""]) {
        }else{
            [imageNameArray addObject:imageName];
            
        }
        
    }
    
    
    if (!variation.count) {
        
    }else{
        NSDictionary *variationPath = variation[0];
        variationName = variationPath[@"variation"];
        variationStock = variationPath[@"variationStock"];
        for (int n = 0; n < variation.count; n++) {
            NSDictionary *variationPath = variation[n];
            NSString *varyName = variationPath[@"variation"];
            NSString *varyStock = variationPath[@"variationStock"];
            NSLog(@"バリエーションのストック%@",varyStock);
            [variationNameArray addObject:varyName];
            if ([varyStock intValue] == 0) {
                [variationStockArray addObject:@"売り切れ"];
            }else{
                [variationStockArray addObject:varyStock];
            }
            NSLog(@"バリエーションのストック%@",variationStockArray);
            
        }
        selectedRow = 0;
        [stockPicker reloadAllComponents];
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageName];
    NSLog(@"url%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImageView *itemImageView = [[UIImageView alloc] initWithImage:nil];
    itemImageView.contentMode = UIViewContentModeScaleToFill;
    itemImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:itemImageView];
    
    for (UIView *subview in [itemImageView subviews]) {
        [subview removeFromSuperview];
    }
    
    AFImageRequestOperation *operation = [AFImageRequestOperation
                                          imageRequestOperationWithRequest: request
                                          imageProcessingBlock: nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getFirstImage) {
                                              NSLog(@"つうしんできてるよ");
                                              [ai stopAnimating];
                                              
                                              shareImage = getFirstImage;
                                              [itemImageView setImage:getFirstImage];
                                              itemImageView.frame = CGRectMake(0, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                              
                                              
                                              mainScrollView.frame = CGRectMake(0, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                              
                                              
                                              mainScrollView.contentSize = CGSizeMake(320 * 5, (getFirstImage.size.height / (getFirstImage.size.width / 320)));
                                              [scrollView addSubview:mainScrollView];
                                              
                                              pc.center = CGPointMake(160, getFirstImage.size.height / (getFirstImage.size.width / 320) - 10);
                                              [scrollView addSubview:pc];
                                              
                                              
                                              
                                              //白いビュー
                                              [self setWhiteCardView:title itemPrice:price];
                                              
                                              /*
                                              UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                                              itemBg = [self rotateImage:itemBg angle:180];
                                              UIImageView *titleImageView = [[UIImageView alloc] initWithImage:itemBg];
                                              titleImageView.frame = CGRectMake(0, 0, 320, 56);
                                              
                                              
                                              [scrollView addSubview:titleImageView];
                                              */
                                              
                                              /*
                                              UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,300,56)];
                                              itemLabel.text = title;
                                              itemLabel.textColor = [UIColor whiteColor];
                                              itemLabel.backgroundColor = [UIColor clearColor];
                                              itemLabel.font = [UIFont boldSystemFontOfSize:16];
                                              itemLabel.numberOfLines = 2;
                                              [titleImageView addSubview:itemLabel];
                                              */
                                              
                                              
                                              
                                              
                                              /*
                                              //星
                                              UIView *favoriteView = [[UIView alloc] init];
                                              favoriteView.frame = CGRectMake(17, itemImageView.frame.size.height - 40,90,28);
                                              favoriteView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
                                              favoriteView.layer.cornerRadius = 2;
                                              favoriteView.layer.masksToBounds = YES;
                                              favoriteView.userInteractionEnabled = YES;
                                              [scrollView addSubview:favoriteView];
                                              
                                              UIImage *starImage = [UIImage imageNamed:@"icon_f_buy_star"];
                                              starImageView = [[UIImageView alloc] initWithImage:starImage];
                                              starImageView.frame = CGRectMake(10,1, 26, 26);
                                              [favoriteView addSubview:starImageView];
                                              */
                                              
                                              //お気に入り
                                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                              //NSMutableArray* array = [NSMutableArray array];
                                              NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                                              for (int n = 0; n < favoriteArray.count; n++) {
                                                  NSString *favoritedItemId = favoriteArray[n];
                                                  if ([favoritedItemId isEqualToString:itemId]) {
                                                      //footerView.favoriteButton setBackgroundColor:[UIColor yellowColor]];
                                                      [footerView.favoriteButton setImage:[UIImage imageNamed:@"icon_7_b_buy_star"] forState:UIControlStateNormal]; //有効時
                                                      [footerView.favoriteButton setTitle:@"お気に入り" forState:UIControlStateNormal]; //有効時
                                                      [footerView.favoriteButton setTintColor:[UIColor colorWithRed:46.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.0]];
                                                      //rgba(46, 148, 251, 1.0000)

                                                      favorited = YES;
                                                  }
                                              }
                                              
                                              /*
                                              //お気に入りボタン
                                              UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              favoriteButton.frame = CGRectMake(0, 0,45,26);
                                              favoriteButton.tag = 1;
                                              favoriteButton.backgroundColor = [UIColor clearColor];
                                              [favoriteButton addTarget:self action:@selector(favorite:)forControlEvents:UIControlEventTouchUpInside];
                                              [favoriteView addSubview:favoriteButton];
                                              
                                              
                                              
                                              
                                              
                                              
                                              
                                              UIImage *socialImage = [UIImage imageNamed:@"icon_d_buy_share.png"];
                                              UIImageView *socialImageView = [[UIImageView alloc] initWithImage:socialImage];
                                              socialImageView.frame = CGRectMake(56,1, 26, 26);
                                              [favoriteView addSubview:socialImageView];
                                              */
                                              //共有
                                              /*
                                              UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              socialButton.frame = CGRectMake(45, 0,45,26);
                                              socialButton.tag = 1;
                                              socialButton.backgroundColor = [UIColor clearColor];
                                              [socialButton addTarget:self action:@selector(shareToSNS:)forControlEvents:UIControlEventTouchUpInside];
                                              [favoriteView addSubview:socialButton];
                                              
                                              */
                                              // TODO: コピペする！

                                              varyNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

                                              /*
                                              // ヴァリエーション
                                              varyNameButton.frame = CGRectMake(0, whiteCardView.frame.size.height - 30, 160, 30);
                                              [varyNameButton setTitle:@"▼バリエーション" forState:UIControlStateNormal];
                                              [varyNameButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
//# error いろ
                                        
                                              [[varyNameButton layer] setBorderWidth:0.5f];
                                              [[varyNameButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                                              [whiteCardView addSubview:varyNameButton];
                                              */
                                              
                                              stockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];


                                              /*
                                              //数量
                                              stockButton.frame = CGRectMake(160, whiteCardView.frame.size.height - 30, 160, 30);
                                              [stockButton setTitle:@"▼数量" forState:UIControlStateNormal];
                                              [stockButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
                                              [whiteCardView addSubview:stockButton];
                                              [[stockButton layer] setBorderWidth:0.5f];                                    [[stockButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                                               */
                                              /*
                                              UIImage *image = [UIImage imageNamed:@"selector"];
                                              // 左右 17px 固定で引き伸ばして利用する
                                              image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
                                              
                                              // 表示する文字に応じてボタンサイズを変更する
                                              NSString *varyString = variationName;
                                              UIFont *font = [UIFont systemFontOfSize:12.f];
                                              CGSize textSize2 = [varyString sizeWithFont:font];
                                              CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
                                              
                                              
                                              
                                              // ボタンを用意する
                                              varyNameButton = [[UIButton alloc] initWithFrame:CGRectMake(13, itemImageView.frame.size.height + 6, buttonSize.width, buttonSize.height)];
                                              [varyNameButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
                                              
                                              [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
                                              
                                              // ラベルを用意する
                                              varyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, textSize2.width + 20, buttonSize.height)];
                                              varyNamelabel.text = varyString;
                                              varyNamelabel.textColor = [UIColor darkGrayColor];
                                              varyNamelabel.font = font;
                                              varyNamelabel.shadowColor = [UIColor whiteColor];
                                              varyNamelabel.shadowOffset = CGSizeMake(0.f, 0.1f);
                                              varyNamelabel.backgroundColor = [UIColor clearColor];
                                              varyNamelabel.textAlignment = NSTextAlignmentCenter;
                                              [varyNameButton addSubview:varyNamelabel];
                                              
                                              [scrollView addSubview:varyNameButton];
                                              */
                                              
                                              /*
                                              UIImage *selectorImage = [UIImage imageNamed:@"selector"];
                                              // 左右 17px 固定で引き伸ばして利用する
                                              selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
                                              
                                              // 表示する文字に応じてボタンサイズを変更する
                                              NSString *stockString = @"1";
                                              UIFont *stockFont = [UIFont systemFontOfSize:12.f];
                                              CGSize stockTextSize = [stockString sizeWithFont:stockFont];
                                              CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
                                              
                                              // ボタンを用意する
                                              stockButton = [[UIButton alloc] initWithFrame:CGRectMake(varyNameButton.frame.origin.x + varyNameButton.frame.size.width + 5, itemImageView.frame.size.height + 6, stockButtonSize.width, stockButtonSize.height)];
                                              [stockButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
                                              
                                              [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
                                              
                                              // ラベルを用意する
                                              stocklabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height)];
                                              stocklabel.text = stockString;
                                              stocklabel.textColor = [UIColor darkGrayColor];
                                              stocklabel.font = stockFont;
                                              stocklabel.shadowColor = [UIColor whiteColor];
                                              stocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
                                              stocklabel.backgroundColor = [UIColor clearColor];
                                              stocklabel.textAlignment = NSTextAlignmentCenter;
                                              [stockButton addSubview:stocklabel];
                                              
                                              [scrollView addSubview:stockButton];
                                              */
                                              if (!variation.count) {
                                                  // 表示する文字に応じてボタンサイズを変更する
                                                  NSString *stockString = @"1";
                                                  UIFont *stockFont = [UIFont systemFontOfSize:12.f];
                                    
                                                  varyNameButton.hidden = YES;
                                                  
                                              }
                                              
                                              
                                              /*
                                              //カートに入れるボタン
                                              UIImage *saveImage = [UIImage imageNamed:@"btn_04"];
                                              
                                              UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              sendButton.frame = CGRectMake( 10, (stockButton.frame.size.height + stockButton.frame.origin.y) + 10, 300, 50);
                                              sendButton.tag = 100;
                                              [sendButton setBackgroundImage:saveImage forState:UIControlStateNormal];
                                              //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                                              [sendButton addTarget:self action:@selector(addToCart:)forControlEvents:UIControlEventTouchUpInside];
                                              [scrollView addSubview:sendButton];
                                              
                                              
                                              //ボタンテキスト
                                              UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(stockButton.frame.size.height + stockButton.frame.origin.y) + 15,240,40)];
                                              sendLabel.text = @"カートに追加する";
                                              sendLabel.center = CGPointMake(150, 25);
                                              sendLabel.textAlignment = NSTextAlignmentCenter;
                                              sendLabel.font = [UIFont boldSystemFontOfSize:20];
                                              sendLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
                                              sendLabel.shadowOffset = CGSizeMake(0.f, -1.f);
                                              sendLabel.backgroundColor = [UIColor clearColor];
                                              sendLabel.textColor = [UIColor whiteColor];
                                              [sendButton addSubview:sendLabel];
                                              */
                                              
                                              UILabel *aboutItem = [[UILabel alloc] initWithFrame:CGRectMake(16, (mainScrollView.frame.size.height + mainScrollView.frame.origin.y) + 130, 288,100)];
                                              aboutItem.text = detail;
                                              aboutItem.textAlignment = NSTextAlignmentLeft;
                                              aboutItem.font = [UIFont systemFontOfSize:14];
                                              aboutItem.textColor = [UIColor grayColor];
                                              aboutItem.backgroundColor = [UIColor clearColor];
                                              aboutItem.numberOfLines = 0;
                                              CGRect frame = [aboutItem frame];
                                              frame.size = CGSizeMake(300, 5000);
                                              [aboutItem setFrame:frame];
                                              [aboutItem sizeToFit];
                                              [scrollView addSubview:aboutItem];
                                              
                                              /*
                                               UITextView *aboutItem = [[UITextView alloc] initWithFrame:CGRectMake(10, (sendButton.frame.size.height + sendButton.frame.origin.y) + 20, 300,100)];
                                               aboutItem.editable = NO;
                                               aboutItem.scrollEnabled = NO;
                                               aboutItem.text = detail;
                                               aboutItem.textColor = [UIColor grayColor];
                                               aboutItem.backgroundColor = [UIColor clearColor];
                                               aboutItem.font = [UIFont systemFontOfSize:14];
                                               [scrollView addSubview:aboutItem];
                                               CGRect frame = aboutItem.frame;
                                               frame.size.height = aboutItem.contentSize.height;
                                               aboutItem.frame = frame;
                                               */
                                              
                                              scrollView.contentSize = CGSizeMake(320, (aboutItem.frame.size.height + aboutItem.frame.origin.y) + 100);
                                              
                                              int last = [scrollView.subviews count] - 1;
                                              UIView *hoge = (scrollView.subviews)[last];
                                              
                                              NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
                                              [scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 5))];
                                              
                                              mainScrollView.contentSize = CGSizeMake(320 + 320 * (imageNameArray.count), (getFirstImage.size.height / (getFirstImage.size.width / 320)));
                                              
                                              CGPoint point = CGPointMake(0, 0);
                                              [scrollView setContentOffset:point animated:NO];
                                              
                                              pc.numberOfPages = imageNameArray.count + 1;
                                              
                                              
                                              //複数の商品画像取得
                                              for (int a = 0; a < imageNameArray.count; a++) {
                                                  UIImageView *otherItemImageView = [[UIImageView alloc] initWithImage:nil];
                                                  otherItemImageView.userInteractionEnabled = YES;
                                                  otherItemImageView.backgroundColor = [UIColor clearColor];
                                                  
                                                  [mainScrollView addSubview:otherItemImageView];
                                                  
                                                  NSString *imageName = imageNameArray[a];
                                                  NSString *url1 = [NSString stringWithFormat:@"%@%@",imageUrl,imageName];
                                                  NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                                                  NSLog(@"ゆーあーるえる%@",url1);
                                                  AFImageRequestOperation *operation = [AFImageRequestOperation
                                                                                        imageRequestOperationWithRequest: getImageRequest
                                                                                        imageProcessingBlock: nil
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                                                            
                                                                                            [otherItemImageView setImage:getImage];
                                                                                            otherItemImageView.frame = CGRectMake(320 + 320 * a, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                                                                            [otherItemImageView setContentMode:UIViewContentModeScaleAspectFit];
                                                                                            
                                                                                            
                                                                                        }
                                                                                        failure: nil];
                                                  [operation start];
                                              }
                                              scrollView.contentOffset = CGPointMake(0, 0);
                                              
                                              
                                              
                                              
                                              
                                          }
                                          failure: nil];
    [operation start];
    
}

- (void)setWhiteCardView:(NSString*)itemTitel itemPrice:(NSString*)price{
    
    // UIViewの生成
    whiteCardView = [[UIView alloc] init];
    whiteCardView.frame = CGRectMake(0, mainScrollView.frame.size.height, 320, 90);
    whiteCardView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:whiteCardView];

    
    //商品名f
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,300,52)];
    itemLabel.text = itemTitel;
    itemLabel.textColor = [UIColor blackColor];
    itemLabel.backgroundColor = [UIColor whiteColor];
    itemLabel.font = [UIFont boldSystemFontOfSize:16];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.numberOfLines = 2;
    [whiteCardView addSubview:itemLabel];
    
    
    //お金表記
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencyCode:@"JPY"];
    NSNumber *numPrice = @([price intValue]);
    NSString *strPrice = [nf stringFromNumber:numPrice];
    
    NSLog(@"文字がおかしいよ%@",strPrice);
    NSLog(@"文字がおかしいよ%d",strPrice.length);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (itemLabel.frame.size.height + itemLabel.frame.origin.y),320,28)];
    priceLabel.text = [NSString stringWithFormat:@"%@",strPrice];
    priceLabel.textColor = [UIColor blackColor];
    //priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    //priceLabel.layer.cornerRadius = 2;
    priceLabel.numberOfLines = 1;
    priceLabel.backgroundColor = [UIColor whiteColor];
    [whiteCardView addSubview:priceLabel];
    /*
    CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                  constrainedToSize:CGSizeMake(200, 28)
                                      lineBreakMode:priceLabel.lineBreakMode];
    priceLabel.frame = CGRectMake(304 - textSize.width, itemImageView.frame.size.height - 40,textSize.width,28);
    */

    
}


//========================================================================
#pragma mark - ios6
-(void)addSubViews:(NSDictionary*)jsonDictionary getImageUrl:(NSString*)imageUrl {
    NSDictionary *item = jsonDictionary[@"Item"];
    NSString *title = item[@"title"];
    itemName = title;
    shopId = item[@"user_id"];
    NSString *price = item[@"price"];
    NSString *detail = item[@"detail"];
    NSString *imageName = item[@"img1"];
    
    stock = item[@"stock"];
    NSLog(@"ストックstock:%@",stock);
    shopName = [jsonDictionary valueForKeyPath:@"Shop.shop_name"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -100, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];
    label.text = shopName;
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    variation = jsonDictionary[@"Variation"];
    NSString *variationName;
    NSString *variationStock;
    
    
    variationNameArray = [NSMutableArray array];
    variationStockArray = [NSMutableArray array];
    
    
    //商品画像名の取得
    NSMutableArray *imageNameArray = [NSMutableArray array];
    for (int n = 1; n < 5; n++) {
        NSString *imageName = item[[NSString stringWithFormat:@"img%d",n + 1]];

        if ([imageName isEqual:[NSNull null]] || [imageName isEqualToString:@""]) {
        }else{
            [imageNameArray addObject:imageName];

        }
        
    }
    
    
    if (!variation.count) {
        
    }else{
        NSDictionary *variationPath = variation[0];
        variationName = variationPath[@"variation"];
        variationStock = variationPath[@"variationStock"];
        for (int n = 0; n < variation.count; n++) {
            NSDictionary *variationPath = variation[n];
            NSString *varyName = variationPath[@"variation"];
            NSString *varyStock = variationPath[@"variationStock"];
            NSLog(@"バリエーションのストック%@",varyStock);
            [variationNameArray addObject:varyName];
            if ([varyStock intValue] == 0) {
                [variationStockArray addObject:@"売り切れ"];
            }else{
                [variationStockArray addObject:varyStock];
            }
            NSLog(@"バリエーションのストック%@",variationStockArray);

        }
        selectedRow = 0;
        [stockPicker reloadAllComponents];
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageName];
    NSLog(@"url%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImageView *itemImageView = [[UIImageView alloc] initWithImage:nil];
    itemImageView.contentMode = UIViewContentModeScaleToFill;
    itemImageView.userInteractionEnabled = YES;
    [mainScrollView addSubview:itemImageView];
    
    for (UIView *subview in [itemImageView subviews]) {
        [subview removeFromSuperview];
    }
    
    
    
    //画像がない場合
    if ([imageName isEqual:[NSNull null]] || [imageName isEqualToString:@""]) {
        NSLog(@"からだよおおおおおおおおおおおおおおおおお");
        [ai stopAnimating];
        itemImageView.frame = CGRectMake(-3, -4, 326, 324);
        UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
        [itemImageView setImage:noImage1];
        UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
        UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
        [noImageView2 setFrame:CGRectMake(320/2 - 50, 320/2 - 50, 100, 100)];
        [itemImageView addSubview:noImageView2];
        [scrollView addSubview:itemImageView];
        
    
        
        
        UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
        itemBg = [self rotateImage:itemBg angle:180];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:itemBg];
        titleImageView.frame = CGRectMake(0, 0, 320, 56);
        [scrollView addSubview:titleImageView];
        
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,300,56)];
        itemLabel.text = title;
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.font = [UIFont boldSystemFontOfSize:16];
        itemLabel.numberOfLines = 2;
        [titleImageView addSubview:itemLabel];
        
        
        
        
        //お金表記
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        [nf setCurrencyCode:@"JPY"];
        NSNumber *numPrice = @([price intValue]);
        NSString *strPrice = [nf stringFromNumber:numPrice];
        
        
        NSLog(@"文字がおかしいよ%@",strPrice);
        NSLog(@"文字がおかしいよ%d",strPrice.length);
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(264, itemImageView.frame.size.height - 40,52,28)];
        priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
        priceLabel.font = [UIFont systemFontOfSize:18];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.layer.cornerRadius = 2;
        priceLabel.numberOfLines = 1;
        [scrollView addSubview:priceLabel];
        CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                      constrainedToSize:CGSizeMake(200, 28)
                                          lineBreakMode:priceLabel.lineBreakMode];
        priceLabel.frame = CGRectMake(304 - textSize.width, itemImageView.frame.size.height - 40,textSize.width,28);
        
        
        
        //星
        UIView *favoriteView = [[UIView alloc] init];
        favoriteView.frame = CGRectMake(17, itemImageView.frame.size.height - 40,90,28);
        favoriteView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
        favoriteView.layer.cornerRadius = 2;
        favoriteView.layer.masksToBounds = YES;
        favoriteView.userInteractionEnabled = YES;
        [scrollView addSubview:favoriteView];
        
        UIImage *starImage = [UIImage imageNamed:@"icon_f_buy_star"];
        starImageView = [[UIImageView alloc] initWithImage:starImage];
        starImageView.frame = CGRectMake(10,1, 26, 26);
        [favoriteView addSubview:starImageView];
        
        
        //お気に入り
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray* array = [NSMutableArray array];
        NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
        for (int n = 0; n < favoriteArray.count; n++) {
            NSString *favoritedItemId = favoriteArray[n];
            if ([favoritedItemId isEqualToString:itemId]) {
                UIImage *favoriteImage = [UIImage imageNamed:@"icon_f_buy_star_s"];
                [starImageView setImage:favoriteImage];
                favorited = YES;
            }
        }
        
        
        //お気に入りボタン
        UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favoriteButton.frame = CGRectMake(0, 0,45,28 );
        favoriteButton.tag = 1;
        favoriteButton.backgroundColor = [UIColor clearColor];
        [favoriteButton addTarget:self action:@selector(favorite:)forControlEvents:UIControlEventTouchUpInside];
        [favoriteView addSubview:favoriteButton];
        
        
        
        
        
        
        
        UIImage *socialImage = [UIImage imageNamed:@"icon_d_buy_share.png"];
        UIImageView *socialImageView = [[UIImageView alloc] initWithImage:socialImage];
        socialImageView.frame = CGRectMake(56,1, 26, 26);
        [favoriteView addSubview:socialImageView];
        
        //共有
        UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        socialButton.frame = CGRectMake(45, 0,45,26);
        socialButton.tag = 1;
        socialButton.backgroundColor = [UIColor clearColor];
        [socialButton addTarget:self action:@selector(shareToSNS:)forControlEvents:UIControlEventTouchUpInside];
        [favoriteView addSubview:socialButton];
        
        
        
        UIImage *image = [UIImage imageNamed:@"selector"];
        // 左右 17px 固定で引き伸ばして利用する
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
        
        // 表示する文字に応じてボタンサイズを変更する
        NSString *varyString = variationName;
        UIFont *font = [UIFont systemFontOfSize:12.f];
        CGSize textSize2 = [varyString sizeWithFont:font];
        CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
        
        
        
        // ボタンを用意する
        varyNameButton = [[UIButton alloc] initWithFrame:CGRectMake(13, itemImageView.frame.size.height + 6, buttonSize.width, buttonSize.height)];
        [varyNameButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
        
        [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
        
        // ラベルを用意する
        varyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, textSize2.width + 20, buttonSize.height)];
        varyNamelabel.text = varyString;
        varyNamelabel.textColor = [UIColor darkGrayColor];
        varyNamelabel.font = font;
        varyNamelabel.shadowColor = [UIColor whiteColor];
        varyNamelabel.shadowOffset = CGSizeMake(0.f, 0.1f);
        varyNamelabel.backgroundColor = [UIColor clearColor];
        varyNamelabel.textAlignment = NSTextAlignmentCenter;
        [varyNameButton addSubview:varyNamelabel];
        
        [scrollView addSubview:varyNameButton];
        
        
        
        UIImage *selectorImage = [UIImage imageNamed:@"selector"];
        // 左右 17px 固定で引き伸ばして利用する
        selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
        
        // 表示する文字に応じてボタンサイズを変更する
        NSString *stockString = @"1";
        UIFont *stockFont = [UIFont systemFontOfSize:12.f];
        CGSize stockTextSize = [stockString sizeWithFont:stockFont];
        CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
        
        // ボタンを用意する
        stockButton = [[UIButton alloc] initWithFrame:CGRectMake(varyNameButton.frame.origin.x + varyNameButton.frame.size.width + 5, itemImageView.frame.size.height + 6, stockButtonSize.width, stockButtonSize.height)];
        [stockButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
        
        [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
        
        // ラベルを用意する
        stocklabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height)];
        stocklabel.text = stockString;
        stocklabel.textColor = [UIColor darkGrayColor];
        stocklabel.font = stockFont;
        stocklabel.shadowColor = [UIColor whiteColor];
        stocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
        stocklabel.backgroundColor = [UIColor clearColor];
        stocklabel.textAlignment = NSTextAlignmentCenter;
        [stockButton addSubview:stocklabel];
        
        [scrollView addSubview:stockButton];
        
        if (!variation.count) {
            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString = @"1";
            UIFont *stockFont = [UIFont systemFontOfSize:12.f];
            CGSize stockTextSize = [stockString sizeWithFont:stockFont];
            CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.0f, selectorImage.size.height);
            
            // ラベルを用意する
            stocklabel.frame = CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height);
            varyNameButton.hidden = YES;
            stocklabel.text = stockString;
            stockButton.frame = CGRectMake(13, itemImageView.frame.size.height + 6, stockButtonSize.width, stockButtonSize.height);
        }
        
        
        
        //カートに入れるボタン
        UIImage *saveImage = [UIImage imageNamed:@"btn_04"];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake( 10, (stockButton.frame.size.height + stockButton.frame.origin.y) + 10, 300, 50);
        sendButton.tag = 100;
        [sendButton setBackgroundImage:saveImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(addToCart:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:sendButton];
        
        
        //ボタンテキスト
        UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(stockButton.frame.size.height + stockButton.frame.origin.y) + 15,240,40)];
        sendLabel.text = @"カートに追加する";
        sendLabel.center = CGPointMake(150, 25);
        sendLabel.textAlignment = NSTextAlignmentCenter;
        sendLabel.font = [UIFont boldSystemFontOfSize:20];
        sendLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        sendLabel.shadowOffset = CGSizeMake(0.f, -1.f);
        sendLabel.backgroundColor = [UIColor clearColor];
        sendLabel.textColor = [UIColor whiteColor];
        [sendButton addSubview:sendLabel];
        
        
        //備考欄
        UILabel *aboutItem = [[UILabel alloc] initWithFrame:CGRectMake(16, (sendButton.frame.size.height + sendButton.frame.origin.y) + 20, 288,100)];
        aboutItem.text = detail;
        aboutItem.textAlignment = NSTextAlignmentLeft;
        aboutItem.font = [UIFont systemFontOfSize:14];
        aboutItem.textColor = [UIColor grayColor];
        aboutItem.backgroundColor = [UIColor clearColor];
        aboutItem.numberOfLines = 0;
        CGRect frame = [aboutItem frame];
        frame.size = CGSizeMake(300, 5000);
        [aboutItem setFrame:frame];
        [aboutItem sizeToFit];
        [scrollView addSubview:aboutItem];
        
        scrollView.contentSize = CGSizeMake(320, (aboutItem.frame.size.height + aboutItem.frame.origin.y) + 100);
        
        scrollView.contentOffset = CGPointMake(0, 0);
        int last = [scrollView.subviews count] - 1;
        UIView *hoge = (scrollView.subviews)[last];
        
        NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
        //[scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 5))];
        
        scrollView.contentOffset = CGPointMake(0, 0);
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        pc.numberOfPages = imageNameArray.count + 1;
        
        return;
        
    }
    AFImageRequestOperation *operation = [AFImageRequestOperation
                                          imageRequestOperationWithRequest: request
                                          imageProcessingBlock: nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getFirstImage) {
                                              NSLog(@"つうしんできてるよ");
                                              [ai stopAnimating];

                                              shareImage = getFirstImage;
                                              [itemImageView setImage:getFirstImage];
                                              itemImageView.frame = CGRectMake(0, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                              
                                              
                                              mainScrollView.frame = CGRectMake(0, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                           
                                              
                                              mainScrollView.contentSize = CGSizeMake(320 * 5, (getFirstImage.size.height / (getFirstImage.size.width / 320)));
                                              [scrollView addSubview:mainScrollView];
                                              
                                              pc.center = CGPointMake(160, getFirstImage.size.height / (getFirstImage.size.width / 320) - 10);
                                              [scrollView addSubview:pc];

                                              
                                              UIImage *itemBg = [UIImage imageNamed:@"shoptitle_base"];
                                              itemBg = [self rotateImage:itemBg angle:180];
                                              UIImageView *titleImageView = [[UIImageView alloc] initWithImage:itemBg];
                                              titleImageView.frame = CGRectMake(0, 0, 320, 56);

                                              
                                              [scrollView addSubview:titleImageView];
                                              
                                              
                                              UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,300,56)];
                                              itemLabel.text = title;
                                              itemLabel.textColor = [UIColor whiteColor];
                                              itemLabel.backgroundColor = [UIColor clearColor];
                                              itemLabel.font = [UIFont boldSystemFontOfSize:16];
                                              itemLabel.numberOfLines = 2;
                                              [titleImageView addSubview:itemLabel];
                                              
                                              
                                              
                                              
                                              //お金表記
                                              NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                                              [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
                                              [nf setCurrencyCode:@"JPY"];
                                              NSNumber *numPrice = @([price intValue]);
                                              NSString *strPrice = [nf stringFromNumber:numPrice];
                                              
                                              
                                              NSLog(@"文字がおかしいよ%@",strPrice);
                                              NSLog(@"文字がおかしいよ%d",strPrice.length);
                                              UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(264, itemImageView.frame.size.height - 40,52,28)];
                                              priceLabel.text = [NSString stringWithFormat:@" %@ ",strPrice];
                                              priceLabel.textColor = [UIColor whiteColor];
                                              priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
                                              priceLabel.font = [UIFont systemFontOfSize:18];
                                              priceLabel.textAlignment = NSTextAlignmentRight;
                                              priceLabel.layer.cornerRadius = 2;
                                              priceLabel.numberOfLines = 1;
                                              [scrollView addSubview:priceLabel];
                                              CGSize textSize = [priceLabel.text sizeWithFont: priceLabel.font
                                                                              constrainedToSize:CGSizeMake(200, 28)
                                                                                  lineBreakMode:priceLabel.lineBreakMode];
                                              priceLabel.frame = CGRectMake(304 - textSize.width, itemImageView.frame.size.height - 40,textSize.width,28);
                                              
                                              
                                              
                                              //星
                                              UIView *favoriteView = [[UIView alloc] init];
                                              favoriteView.frame = CGRectMake(17, itemImageView.frame.size.height - 40,90,28);
                                              favoriteView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
                                              favoriteView.layer.cornerRadius = 2;
                                              favoriteView.layer.masksToBounds = YES;
                                              favoriteView.userInteractionEnabled = YES;
                                              [scrollView addSubview:favoriteView];
                                              
                                              UIImage *starImage = [UIImage imageNamed:@"icon_f_buy_star"];
                                              starImageView = [[UIImageView alloc] initWithImage:starImage];
                                              starImageView.frame = CGRectMake(10,1, 26, 26);
                                              [favoriteView addSubview:starImageView];
                                              

                                              //お気に入り
                                              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                              //NSMutableArray* array = [NSMutableArray array];
                                              NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
                                              for (int n = 0; n < favoriteArray.count; n++) {
                                                  NSString *favoritedItemId = favoriteArray[n];
                                                  if ([favoritedItemId isEqualToString:itemId]) {
                                                      UIImage *favoriteImage = [UIImage imageNamed:@"icon_f_buy_star_s"];
                                                      [starImageView setImage:favoriteImage];
                                                      favorited = YES;
                                                  }
                                              }
                                              
                                              
                                              //お気に入りボタン
                                              UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              favoriteButton.frame = CGRectMake(0, 0,45,26);
                                              favoriteButton.tag = 1;
                                              favoriteButton.backgroundColor = [UIColor clearColor];
                                              [favoriteButton addTarget:self action:@selector(favorite:)forControlEvents:UIControlEventTouchUpInside];
                                              [favoriteView addSubview:favoriteButton];
                                              
                                              
                                              
                                              
                                              
                    
                                              
                                              UIImage *socialImage = [UIImage imageNamed:@"icon_d_buy_share.png"];
                                              UIImageView *socialImageView = [[UIImageView alloc] initWithImage:socialImage];
                                              socialImageView.frame = CGRectMake(56,1, 26, 26);
                                              [favoriteView addSubview:socialImageView];
                                              
                                              //共有
                                              UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              socialButton.frame = CGRectMake(45, 0,45,26);
                                              socialButton.tag = 1;
                                              socialButton.backgroundColor = [UIColor clearColor];
                                              [socialButton addTarget:self action:@selector(shareToSNS:)forControlEvents:UIControlEventTouchUpInside];
                                              [favoriteView addSubview:socialButton];
                                              
                                              
                                              
                                              UIImage *image = [UIImage imageNamed:@"selector"];
                                              // 左右 17px 固定で引き伸ばして利用する
                                              image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
                                              
                                              // 表示する文字に応じてボタンサイズを変更する
                                              NSString *varyString = variationName;
                                              UIFont *font = [UIFont systemFontOfSize:12.f];
                                              CGSize textSize2 = [varyString sizeWithFont:font];
                                              CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
                                              
                                              
                                              
                                              // ボタンを用意する
                                              varyNameButton = [[UIButton alloc] initWithFrame:CGRectMake(13, itemImageView.frame.size.height + 6, buttonSize.width, buttonSize.height)];
                                              [varyNameButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
                                              
                                              [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
                                              
                                              // ラベルを用意する
                                              varyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, textSize2.width + 20, buttonSize.height)];
                                              varyNamelabel.text = varyString;
                                              varyNamelabel.textColor = [UIColor darkGrayColor];
                                              varyNamelabel.font = font;
                                              varyNamelabel.shadowColor = [UIColor whiteColor];
                                              varyNamelabel.shadowOffset = CGSizeMake(0.f, 0.1f);
                                              varyNamelabel.backgroundColor = [UIColor clearColor];
                                              varyNamelabel.textAlignment = NSTextAlignmentCenter;
                                              [varyNameButton addSubview:varyNamelabel];
                                              
                                              [scrollView addSubview:varyNameButton];
                                              
                                              
                                              
                                              UIImage *selectorImage = [UIImage imageNamed:@"selector"];
                                              // 左右 17px 固定で引き伸ばして利用する
                                              selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
                                              
                                              // 表示する文字に応じてボタンサイズを変更する
                                              NSString *stockString = @"1";
                                              UIFont *stockFont = [UIFont systemFontOfSize:12.f];
                                              CGSize stockTextSize = [stockString sizeWithFont:stockFont];
                                              CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
                                              
                                              // ボタンを用意する
                                              stockButton = [[UIButton alloc] initWithFrame:CGRectMake(varyNameButton.frame.origin.x + varyNameButton.frame.size.width + 5, itemImageView.frame.size.height + 6, stockButtonSize.width, stockButtonSize.height)];
                                              [stockButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
                                              
                                              [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
                                              
                                              // ラベルを用意する
                                              stocklabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height)];
                                              stocklabel.text = stockString;
                                              stocklabel.textColor = [UIColor darkGrayColor];
                                              stocklabel.font = stockFont;
                                              stocklabel.shadowColor = [UIColor whiteColor];
                                              stocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
                                              stocklabel.backgroundColor = [UIColor clearColor];
                                              stocklabel.textAlignment = NSTextAlignmentCenter;
                                              [stockButton addSubview:stocklabel];
                                              
                                              [scrollView addSubview:stockButton];
                                              
                                              if (!variation.count) {
                                                  // 表示する文字に応じてボタンサイズを変更する
                                                  NSString *stockString = @"1";
                                                  UIFont *stockFont = [UIFont systemFontOfSize:12.f];
                                                  CGSize stockTextSize = [stockString sizeWithFont:stockFont];
                                                  CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.0f, selectorImage.size.height);
                                                  
                                                  // ラベルを用意する
                                                  stocklabel.frame = CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height);
                                                  varyNameButton.hidden = YES;
                                                  stocklabel.text = stockString;
                                                  stockButton.frame = CGRectMake(13, itemImageView.frame.size.height + 6, stockButtonSize.width, stockButtonSize.height);
                                              }
                                              
                                              
                                              
                                              //カートに入れるボタン
                                              UIImage *saveImage = [UIImage imageNamed:@"btn_04"];
                                              
                                              UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              sendButton.frame = CGRectMake( 10, (stockButton.frame.size.height + stockButton.frame.origin.y) + 10, 300, 50);
                                              sendButton.tag = 100;
                                              [sendButton setBackgroundImage:saveImage forState:UIControlStateNormal];
                                              //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                                              [sendButton addTarget:self action:@selector(addToCart:)forControlEvents:UIControlEventTouchUpInside];
                                              [scrollView addSubview:sendButton];
                                              
                                              
                                              //ボタンテキスト
                                              UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(stockButton.frame.size.height + stockButton.frame.origin.y) + 15,240,40)];
                                              sendLabel.text = @"カートに追加する";
                                              sendLabel.center = CGPointMake(150, 25);
                                              sendLabel.textAlignment = NSTextAlignmentCenter;
                                              sendLabel.font = [UIFont boldSystemFontOfSize:20];
                                              sendLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
                                              sendLabel.shadowOffset = CGSizeMake(0.f, -1.f);
                                              sendLabel.backgroundColor = [UIColor clearColor];
                                              sendLabel.textColor = [UIColor whiteColor];
                                              [sendButton addSubview:sendLabel];
                
                                              
                                              UILabel *aboutItem = [[UILabel alloc] initWithFrame:CGRectMake(16, (sendButton.frame.size.height + sendButton.frame.origin.y) + 20, 288,100)];
                                              aboutItem.text = detail;
                                              aboutItem.textAlignment = NSTextAlignmentLeft;
                                              aboutItem.font = [UIFont systemFontOfSize:14];
                                              aboutItem.textColor = [UIColor grayColor];
                                              aboutItem.backgroundColor = [UIColor clearColor];
                                              aboutItem.numberOfLines = 0;
                                              CGRect frame = [aboutItem frame];
                                              frame.size = CGSizeMake(300, 5000);
                                              [aboutItem setFrame:frame];
                                              [aboutItem sizeToFit];
                                              [scrollView addSubview:aboutItem];
                                              
                                              /*
                                              UITextView *aboutItem = [[UITextView alloc] initWithFrame:CGRectMake(10, (sendButton.frame.size.height + sendButton.frame.origin.y) + 20, 300,100)];
                                              aboutItem.editable = NO;
                                              aboutItem.scrollEnabled = NO;
                                              aboutItem.text = detail;
                                              aboutItem.textColor = [UIColor grayColor];
                                              aboutItem.backgroundColor = [UIColor clearColor];
                                              aboutItem.font = [UIFont systemFontOfSize:14];
                                              [scrollView addSubview:aboutItem];
                                              CGRect frame = aboutItem.frame;
                                              frame.size.height = aboutItem.contentSize.height;
                                              aboutItem.frame = frame;
                                              */
                                               
                                              scrollView.contentSize = CGSizeMake(320, (aboutItem.frame.size.height + aboutItem.frame.origin.y) + 100);
                                              
                                              int last = [scrollView.subviews count] - 1;
                                              UIView *hoge = (scrollView.subviews)[last];
                                              
                                              NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
                                              [scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 5))];
                                              
                                              mainScrollView.contentSize = CGSizeMake(320 + 320 * (imageNameArray.count), (getFirstImage.size.height / (getFirstImage.size.width / 320)));
                                              
                                              CGPoint point = CGPointMake(0, 0);
                                              [scrollView setContentOffset:point animated:NO];
                                              
                                              pc.numberOfPages = imageNameArray.count + 1;
                                              for (int a = 0; a < imageNameArray.count; a++) {
                                                  UIImageView *otherItemImageView = [[UIImageView alloc] initWithImage:nil];
                                                  otherItemImageView.userInteractionEnabled = YES;
                                                  otherItemImageView.backgroundColor = [UIColor clearColor];

                                                  [mainScrollView addSubview:otherItemImageView];
                                                  
                                                  NSString *imageName = imageNameArray[a];
                                                  NSString *url1 = [NSString stringWithFormat:@"%@%@",imageUrl,imageName];
                                                  NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                                                  NSLog(@"ゆーあーるえる%@",url1);
                                                  AFImageRequestOperation *operation = [AFImageRequestOperation
                                                                                        imageRequestOperationWithRequest: getImageRequest
                                                                                        imageProcessingBlock: nil
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                                                            
                                                                                            [otherItemImageView setImage:getImage];
                                                                                            otherItemImageView.frame = CGRectMake(320 + 320 * a, 0, 320, getFirstImage.size.height / (getFirstImage.size.width / 320));
                                                                                            [otherItemImageView setContentMode:UIViewContentModeScaleAspectFit];

                                                                                            
                                                                                        }
                                                                                        failure: nil];
                                                  [operation start];
                                              }
                                              scrollView.contentOffset = CGPointMake(0, 0);
                                              
                                             
                                              

                                              
                                          }
                                          failure: nil];
    [operation start];

}

//========================================================================
# pragma mark - addToCartIos7

- (void)addToCartIos7:(id)sender{
    
    NSLog(@"バリエーション:%@,数量:%@",varyNameButton.currentTitle,stockButton.currentTitle);
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSAboutItemViewController"
                                                     withAction:[NSString stringWithFormat:@"addToCart itemId:%@shopId:%@",itemId,importShopId]
                                                      withLabel:nil
                                                      withValue:@100];
    //お気に入りに追加
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *cartArray = [userDefaults arrayForKey:@"cart"];
    NSLog(@"取得した配列%@",cartArray);
    if (!cartArray) {
        // NSArrayの保存
        NSMutableArray *cartMutableArray = [NSMutableArray array];
        NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
        //在庫数のみの時にバリエーションネームを空にする
        if (!variation.count) {
            [varyNameButton setTitle:@"" forState:UIControlStateNormal];
        }
        
        cartMutableDictionary[@"itemId"] = itemId;
        cartMutableDictionary[@"variationName"] = varyNameButton.currentTitle;
        
        if ([stockButton.currentTitle compare:@"▼数量"] == NSOrderedSame){
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"商品の個数を選択して下さい" message:@""
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([stockButton.currentTitle isEqualToString:@"売り切れ"]) {
            cartMutableDictionary[@"variationStock"] = [NSString stringWithFormat:@"%d",0];
            
        }else{
            cartMutableDictionary[@"variationStock"] = stockButton.currentTitle;
            
        }
        cartMutableDictionary[@"shopId"] = shopId;
        
        
        [cartMutableArray addObject:cartMutableDictionary];
        [userDefaults setObject:cartMutableArray forKey:@"cart"];
        
        if ( ![userDefaults synchronize] ) {
            NSLog( @"failed ..." );
        }else{
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        NSMutableArray *copiedCartArray = [cartArray mutableCopy];
        for (int n = 0; n < copiedCartArray.count; n++) {
            NSDictionary *itemDictionary = copiedCartArray[n];
            NSString *cartItemId = itemDictionary[@"itemId"];
            if ([cartItemId isEqualToString:itemId]) {
                
                NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
                //在庫数のみの時にバリエーションネームを空にする
                if (!variation.count) {
                    [varyNameButton setTitle:@"" forState:UIControlStateNormal];
                }
                cartMutableDictionary[@"itemId"] = itemId;
                cartMutableDictionary[@"variationName"] = varyNameButton.currentTitle;
                if ([stockButton.currentTitle compare:@"▼数量"] == NSOrderedSame){
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:@"商品の個数を選択して下さい" message:@""
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if ([stockButton.currentTitle isEqualToString:@"売り切れ"]) {
                    cartMutableDictionary[@"variationStock"] = [NSString stringWithFormat:@"%d",0];
                    
                }else{
                    cartMutableDictionary[@"variationStock"] = stockButton.currentTitle;
                    
                }
                cartMutableDictionary[@"shopId"] = shopId;
                
                
                copiedCartArray[n] = cartMutableDictionary;
                [userDefaults setObject:copiedCartArray forKey:@"cart"];
                
                if ( ![userDefaults synchronize] ) {
                    NSLog( @"failed ..." );
                }else{
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                return ;
            }
        }
        
        NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
        //在庫数のみの時にバリエーションネームを空にする
        if (!variation.count) {
            [varyNameButton setTitle:@"" forState:UIControlStateNormal];
        }
        cartMutableDictionary[@"itemId"] = itemId;
        cartMutableDictionary[@"variationName"] = varyNameButton.currentTitle;
        cartMutableDictionary[@"variationStock"] = stockButton.currentTitle;
        cartMutableDictionary[@"shopId"] = shopId;
        
        [copiedCartArray addObject:cartMutableDictionary];
        [userDefaults setObject:copiedCartArray forKey:@"cart"];
        if ( ![userDefaults synchronize] ) {
            NSLog( @"failed ..." );
        }else{
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

//カートに追加
- (void)addToCart:(id)sender{
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSAboutItemViewController"
                                                     withAction:[NSString stringWithFormat:@"addToCart itemId:%@shopId:%@",itemId,importShopId]
                                                      withLabel:nil
                                                      withValue:@100];
    //お気に入りに追加
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *cartArray = [userDefaults arrayForKey:@"cart"];
    NSLog(@"取得した配列%@",cartArray);
    if (!cartArray) {
        // NSArrayの保存
        NSMutableArray *cartMutableArray = [NSMutableArray array];
        NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
        //在庫数のみの時にバリエーションネームを空にする
        if (!variation.count) {
            varyNamelabel.text = @"";
        }
        
        cartMutableDictionary[@"itemId"] = itemId;
        cartMutableDictionary[@"variationName"] = varyNamelabel.text;
        
        if ([stocklabel.text isEqualToString:@"売り切れ"]) {
            cartMutableDictionary[@"variationStock"] = [NSString stringWithFormat:@"%d",0];

        }else{
            cartMutableDictionary[@"variationStock"] = stocklabel.text;

        }
        cartMutableDictionary[@"shopId"] = shopId;

        
        [cartMutableArray addObject:cartMutableDictionary];
        [userDefaults setObject:cartMutableArray forKey:@"cart"];
        
        if ( ![userDefaults synchronize] ) {
            NSLog( @"failed ..." );
        }else{
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        NSMutableArray *copiedCartArray = [cartArray mutableCopy];
        for (int n = 0; n < copiedCartArray.count; n++) {
            NSDictionary *itemDictionary = copiedCartArray[n];
            NSString *cartItemId = itemDictionary[@"itemId"];
            if ([cartItemId isEqualToString:itemId]) {
                
                NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
                //在庫数のみの時にバリエーションネームを空にする
                if (!variation.count) {
                    varyNamelabel.text = @"";
                }
                cartMutableDictionary[@"itemId"] = itemId;
                cartMutableDictionary[@"variationName"] = varyNamelabel.text;
                if ([stocklabel.text isEqualToString:@"売り切れ"]) {
                    cartMutableDictionary[@"variationStock"] = [NSString stringWithFormat:@"%d",0];
                    
                }else{
                    cartMutableDictionary[@"variationStock"] = stocklabel.text;
                    
                }
                cartMutableDictionary[@"shopId"] = shopId;

                
                copiedCartArray[n] = cartMutableDictionary;
                [userDefaults setObject:copiedCartArray forKey:@"cart"];
                
                if ( ![userDefaults synchronize] ) {
                    NSLog( @"failed ..." );
                }else{
                    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                return ;
            }
        }
        
        NSMutableDictionary *cartMutableDictionary = [NSMutableDictionary dictionary];
        //在庫数のみの時にバリエーションネームを空にする
        if (!variation.count) {
            varyNamelabel.text = @"";
        }
        cartMutableDictionary[@"itemId"] = itemId;
        cartMutableDictionary[@"variationName"] = varyNamelabel.text;
        cartMutableDictionary[@"variationStock"] = stocklabel.text;
        cartMutableDictionary[@"shopId"] = shopId;
        
        [copiedCartArray addObject:cartMutableDictionary];
        [userDefaults setObject:copiedCartArray forKey:@"cart"];
        if ( ![userDefaults synchronize] ) {
            NSLog( @"failed ..." );
        }else{
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


//数量のピッカー
- (IBAction)selectNumber:(id)sender
{
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //てすと
        NSLog(@"ボタンのタグ:%d",[sender tag]);
        buttonTag = [sender tag];
        
        
        stockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        
        [stockActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        if (!firstButton) {
            stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
            stockPicker.delegate = self; //自分自身をデリゲートに設定する。
            stockPicker.dataSource = self;
            stockPicker.showsSelectionIndicator = YES;
            firstButton = YES;
        }
        
        [stockActionSheet addSubview:stockPicker];
        
        UISegmentedControl *cartButton = [[UISegmentedControl alloc] initWithItems:@[@"カートへ"]];
        cartButton.momentary = YES;
        cartButton.frame = CGRectMake(240, 7.0f, 70.0f, 30.0f);
        cartButton.segmentedControlStyle = UISegmentedControlStylePlain;
        //closeButton.tintColor = [UIColor blackColor];
        [cartButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        [stockActionSheet addSubview:cartButton];
        
        
        
        
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"キャンセル"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(10, 7.0f, 70.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStylePlain;
        closeButton.tintColor = [UIColor grayColor];
        [closeButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
        [stockActionSheet addSubview:closeButton];
        
        
        
        
        
        [stockActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        
        [stockActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        
        NSLog(@"数量ボタンが押されたよ！");
    
    
    }else{
    
        //てすと
        NSLog(@"ボタンのタグ:%d",[sender tag]);
        buttonTag = [sender tag];
        
        
        stockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        
        [stockActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
        
        if (!firstButton) {
            stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
            stockPicker.delegate = self; //自分自身をデリゲートに設定する。
            stockPicker.dataSource = self;
            stockPicker.showsSelectionIndicator = YES;
            firstButton = YES;
        }
        
        [stockActionSheet addSubview:stockPicker];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"完了"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        [stockActionSheet addSubview:closeButton];
        
        [stockActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        
        [stockActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        
        NSLog(@"数量ボタンが押されたよ！");
    }
    
}
- (void)cancelActionSheet:(id)sender{
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//数量のピッカーを消す
- (void)dismissActionSheet:(id)sender{
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    // TODO: ios7対応
    if ([BSDefaultViewObject isMoreIos7]) {
        if (!variation.count) {
            int stock1 = [stockPicker selectedRowInComponent:0] + 1;
            
            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString;
            if ([stock intValue] == 0) {
                stockString = @"売り切れ";
            }else{
                stockString = [NSString stringWithFormat:@"%d",stock1];
            }
            // ボタンを用意する
            [stockButton setTitle:stockString forState:UIControlStateNormal];
            
            // ラベルを用意する
            stocklabel.text = stockString;
            
            NSLog(@"数量！%@",stockButton.currentTitle);
            [self addToCartIos7:nil];
        }else{
            NSString *varyName = variationNameArray[[stockPicker selectedRowInComponent:0]];
            int stock1 = [stockPicker selectedRowInComponent:1] + 1;
            
            // 表示する文字に応じてボタンサイズを変更する
            varyNamelabel.text = varyName;
            [varyNameButton setTitle:varyName forState:UIControlStateNormal];
            

            

            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString;
            if ([variationStockArray[selectedRow] intValue] == 0) {
                stockString = @"売り切れ";
            }else{
                stockString = [NSString stringWithFormat:@"%d",stock1];
            }
            
            // ボタンを用意する
            [stockButton setTitle:stockString forState:UIControlStateNormal];
            
            // ラベルを用意する
            stocklabel.text = stockString;
            
            [self addToCartIos7:nil];

        }
    }else{
        if (!variation.count) {
            int stock1 = [stockPicker selectedRowInComponent:0] + 1;
            UIImage *selectorImage = [UIImage imageNamed:@"selector"];
            // 左右 17px 固定で引き伸ばして利用する
            selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
            
            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString;
            if ([stock intValue] == 0) {
                stockString = @"売り切れ";
            }else{
                stockString = [NSString stringWithFormat:@"%d",stock1];
            }
            UIFont *stockFont = [UIFont systemFontOfSize:12.f];
            CGSize stockTextSize = [stockString sizeWithFont:stockFont];
            CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
            
            // ボタンを用意する
            stockButton.frame = CGRectMake(stockButton.frame.origin.x, stockButton.frame.origin.y, stockButtonSize.width, stockButtonSize.height);
            
            
            stocklabel.frame =CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height);
            [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
            
            
            [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
            
            // ラベルを用意する
            stocklabel.text = stockString;
            NSLog(@"数量！%@",stocklabel.text);
        }else{
            NSString *varyName = variationNameArray[[stockPicker selectedRowInComponent:0]];
            int stock1 = [stockPicker selectedRowInComponent:1] + 1;
            
            
            
            UIImage *image = [UIImage imageNamed:@"selector"];
            // 左右 17px 固定で引き伸ばして利用する
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
            
            // 表示する文字に応じてボタンサイズを変更する
            NSString *varyString = varyName;
            UIFont *font = [UIFont systemFontOfSize:12.f];
            CGSize textSize2 = [varyString sizeWithFont:font];
            CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
            
            // ボタンを用意する
            varyNameButton.frame = CGRectMake(13, varyNameButton.frame.origin.y,buttonSize.width, buttonSize.height);
            [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
            // ラベルを用意する
            varyNamelabel.text = varyString;
            
            varyNamelabel.frame = CGRectMake(5.f, 0.f, textSize2.width + 20, buttonSize.height);
            
            
            
            
            
            
            
            
            UIImage *selectorImage = [UIImage imageNamed:@"selector"];
            // 左右 17px 固定で引き伸ばして利用する
            selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
            
            // 表示する文字に応じてボタンサイズを変更する
            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString;
            if ([variationStockArray[selectedRow] intValue] == 0) {
                stockString = @"売り切れ";
            }else{
                stockString = [NSString stringWithFormat:@"%d",stock1];
            }        UIFont *stockFont = [UIFont systemFontOfSize:12.f];
            CGSize stockTextSize = [stockString sizeWithFont:stockFont];
            CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
            
            // ボタンを用意する
            stockButton.frame = CGRectMake(varyNameButton.frame.origin.x + varyNameButton.frame.size.width + 5, stockButton.frame.origin.y, stockButtonSize.width, stockButtonSize.height);
            
            stocklabel.frame =CGRectMake(5.f, 0.f, stockTextSize.width + 20, stockButtonSize.height);
            [stockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
            
            // ラベルを用意する
            stocklabel.text = stockString;
            
            
        }
    }
    
    
    
}


//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (!variation.count) {
        return 1;
    }else{
        return 2;  // 1列目は10行
    }
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        if (variation.count) {
            return variationNameArray.count;
        }else{
            if ([stock intValue] == 0) {
                return 1;
            }
            return [stock intValue];  // 1列目は10行
        }
    }else{
        if (variation.count) {
            if ([variationStockArray[selectedRow] intValue] == 0) {
                return 1;
            }
            return [variationStockArray[selectedRow] intValue];
        }else{
            return 5;  // 2列目は5行
        }
    }
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        if (variation.count) {
            return variationNameArray[row];
        }else{
            if ([stock intValue] == 0) {
                return [NSString stringWithFormat:@"売り切れ"];
            }
            return [NSString stringWithFormat:@"%d", row + 1];
        }
    }else{
        /*
        if ([variationStockArray objectAtIndex:row]) {
            <#statements#>
        }
         */
        ;
        if ([variationStockArray[selectedRow] isEqualToString:@"売り切れ"]) {
            return [NSString stringWithFormat:@"売り切れ"];
        }
        return [NSString stringWithFormat:@"%d", row + 1];
    }
    
}
//選択した行を確認
- (void) pickerView:(UIPickerView*)view didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (!variation.count) {
        return;
    }
    if(component == 0) {
        selectedRow = row;
        [stockPicker reloadComponent:1];
    }
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSURL *url = [NSURL URLWithString:@"http://gogengo.me"];
    switch (buttonIndex) {
        case 0:
            [self sendTwitter];
            break;
        case 1:
            [self sendFacebook:shareImage title:[NSString stringWithFormat:@"%@",socialInfo[@"facebook"]] url:socialInfo[@"itemUrl"]];
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
    NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/text/%@%@",content,socialInfo[@"itemUrl"]];
    
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

- (void)shareToSNS:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    
    actionSheet.delegate = self;
    actionSheet.title = @"商品をSNSで共有する";
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"LINE"];
    [actionSheet addButtonWithTitle:@"キャンセル"];
    actionSheet.cancelButtonIndex = 3;
   [actionSheet showInView:self.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)newScrollView {
    
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    pc.currentPage = newScrollView.contentOffset.x / 320;
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

+(NSString*)getShopId {
    return importShopId;
}
+(void)resetShopId {
    importShopId = nil;
}
- (void)aboutShop{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"shopInfo"];
    [self presentViewController:vc animated:YES completion: ^{
        
        NSLog(@"完了");}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
