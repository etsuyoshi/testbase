//
//  BSThankYouViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/19.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSThankYouViewController.h"

@interface BSThankYouViewController ()

@end

@implementation BSThankYouViewController{
    UIScrollView *scrollView;
    
    NSString *twitterContent;
    NSString *facebookContent;
    NSString *shopUrl;
    
    NSString *boughtShopId;
    
    NSString *apiUrl;
}

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
	// Do any additional setup after loading the view.
    
    //グーグルアナリティクス
    self.screenName = @"thankYou";
    apiUrl = [BSDefaultViewObject setApiUrl];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    //ナビゲーションバー
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ありがとうございました"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"ありがとうございました";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    //スクロール
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 44)];
    scrollView.contentSize = CGSizeMake(320, 2000);
    scrollView.scrollsToTop = YES;
    [self.view addSubview:scrollView];
    
    
    
    NSLog(@"しょっぷId%@",[BSConfirmCheckoutViewController getShopId]);
    NSString *shopId = [BSConfirmCheckoutViewController getShopId];
    NSString *urlString = [NSString stringWithFormat:@"%@/cart/complete_checkout?shop_id=%@",apiUrl,shopId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"ソーシャル共有！: %@", responseObject);
        NSString *logoTitle = [responseObject valueForKeyPath:@"result.logo"];
        
        twitterContent = [responseObject valueForKeyPath:@"result.tweet_content"];
        facebookContent = [responseObject valueForKeyPath:@"result.facebook_content"];
        shopUrl = [responseObject valueForKeyPath:@"shop_url"];
        boughtShopId = [responseObject valueForKeyPath:@"result.id"];
        [self deleteCartItem];
        //ロゴがあるorない場合のビュー
        if ([logoTitle isEqual:[NSNull null]] || [logoTitle isEqualToString:@""]) {
            [self noLogoArrange:responseObject];
        }else{
            [self existedLogoArrange:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
    
    
}
- (void)noLogoArrange:(id)JSON
{
    //店舗の説明
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,80)];
    aboutLabel.textColor = [UIColor darkGrayColor];
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.font = [UIFont boldSystemFontOfSize:16];
    [aboutLabel setText:@"ご購入ありがとうございました！\nまたの機会をお待ちしております。"];
    [aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [aboutLabel setNumberOfLines:0];
    [aboutLabel sizeToFit];
    aboutLabel.center = CGPointMake(160,30);
    [scrollView addSubview:aboutLabel];
    
    NSString *payment = [BSConfirmCheckoutViewController getPayment];
    
    if ([payment isEqualToString:@"creditcard"]) {
        //店舗の説明
        UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10,aboutLabel.frame.size.width,100)];
        checkLabel.textColor = [UIColor grayColor];
        checkLabel.backgroundColor = [UIColor clearColor];
        checkLabel.font = [UIFont boldSystemFontOfSize:12];
        [checkLabel setText:@"ご記入いただいたメールアドレスの方にご控えメールをお送りしておりますので御確認下さい。\nクレジットカードの利用明細にはPAYPAL*BASE SHOPと記載されます。来ていない場合は迷惑メールフォルダを御覧下さい。"];
        [checkLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [checkLabel setNumberOfLines:0];
        checkLabel.center = CGPointMake(160, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 60);
        [scrollView addSubview:checkLabel];
        
        
        UIImage *facebookImage = [UIImage imageNamed:@"btn_sns_fb.png"];
        
        UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        facebookButton.frame = CGRectMake( 10, (checkLabel.frame.origin.y + checkLabel.frame.size.height) + 10, 145, 42);
        facebookButton.tag = 1;
        [facebookButton setBackgroundImage:facebookImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [facebookButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:facebookButton];
        
        
        
        UIImage *twitterImage = [UIImage imageNamed:@"btn_sns_tw.png"];
        UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.frame = CGRectMake( 165, (checkLabel.frame.origin.y + checkLabel.frame.size.height) + 10, 145, 42);
        twitterButton.tag = 2;
        [twitterButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [twitterButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:twitterButton];
        
        
        
        
        UIImage *backImage = [UIImage imageNamed:@"btn_05.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake( 10, (twitterButton.frame.origin.y + twitterButton.frame.size.height) + 30, 300, 50);
        backButton.tag = 1;
        [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backRoot)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:backButton];
        
        
        //ボタンテキスト
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(twitterButton.frame.origin.y + twitterButton.frame.size.height) + 35,240,40)];
        backLabel.text = @"TOPへ戻る";
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.font = [UIFont boldSystemFontOfSize:20];
        backLabel.shadowColor = [UIColor whiteColor];
        backLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        backLabel.backgroundColor = [UIColor clearColor];
        backLabel.textColor = [UIColor grayColor];
        [scrollView addSubview:backLabel];
    }else{
        
        
        
        UIImage *facebookImage = [UIImage imageNamed:@"btn_sns_fb.png"];
        
        UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        facebookButton.frame = CGRectMake( 10, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10, 145, 42);
        facebookButton.tag = 1;
        [facebookButton setBackgroundImage:facebookImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [facebookButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:facebookButton];
        
        
        
        UIImage *twitterImage = [UIImage imageNamed:@"btn_sns_tw.png"];
        UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        twitterButton.frame = CGRectMake( 165, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10, 145, 42);
        twitterButton.tag = 2;
        [twitterButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [twitterButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:twitterButton];
        
        
        
        
        UIImage *backImage = [UIImage imageNamed:@"btn_05.png"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake( 10, (twitterButton.frame.origin.y + twitterButton.frame.size.height) + 30, 300, 50);
        backButton.tag = 1;
        [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backRoot)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:backButton];
        
        
        //ボタンテキスト
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(twitterButton.frame.origin.y + twitterButton.frame.size.height) + 35,240,40)];
        backLabel.text = @"TOPへ戻る";
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.font = [UIFont boldSystemFontOfSize:20];
        backLabel.shadowColor = [UIColor whiteColor];
        backLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        backLabel.backgroundColor = [UIColor clearColor];
        backLabel.textColor = [UIColor grayColor];
        [scrollView addSubview:backLabel];
    }
    
    for (UIView *view in scrollView.subviews) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 100, view.frame.size.width, view.frame.size.height);
    }
    
    int last = [scrollView.subviews count] - 1;
    UIView *hoge = (scrollView.subviews)[last];
    
    NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
    [scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 20))];
    
}
- (void)existedLogoArrange:(id)JSON
{
    UIImageView *shopImageView = [[UIImageView alloc] initWithImage:nil];
    shopImageView.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:shopImageView];
    NSString *logoUrl = JSON[@"logo_url"];
    NSString *logoTitle = [JSON valueForKeyPath:@"result.logo"];
    
    NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoTitle];
    NSLog(@"ロゴ取得%@%@",logoUrl,logoTitle);
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/pjpeg"];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/x-png"];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        UIImage *getImage = responseObject;
        [shopImageView setImage:getImage];
        NSLog(@"取得した画像のサイズタテ%fヨコ%f",getImage.size.height,getImage.size.width);
        if ([BSDefaultViewObject isMoreIos7]) {
            shopImageView.frame = CGRectMake(0, 0, 320, getImage.size.height / (getImage.size.width / 320));
            
        }else{
            shopImageView.frame = CGRectMake(0, 0, 320, getImage.size.height / (getImage.size.width / 320));
            
        }
        if (getImage.size.width >= 320 ) {
            shopImageView.contentMode = UIViewContentModeScaleToFill;
            
        }else{
            shopImageView.contentMode = UIViewContentModeCenter;
            
        }
        //店舗の説明
        UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(shopImageView.frame.origin.y + shopImageView.frame.size.height) + 10,300,80)];
        aboutLabel.textColor = [UIColor darkGrayColor];
        aboutLabel.backgroundColor = [UIColor clearColor];
        aboutLabel.font = [UIFont boldSystemFontOfSize:16];
        [aboutLabel setText:@"ご購入ありがとうございました！\nまたの機会をお待ちしております。"];
        [aboutLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [aboutLabel setNumberOfLines:0];
        [aboutLabel sizeToFit];
        aboutLabel.center = CGPointMake(160, (shopImageView.frame.origin.y + shopImageView.frame.size.height) + 30);
        [scrollView addSubview:aboutLabel];
        
        NSString *payment = [BSConfirmCheckoutViewController getPayment];
        
        if ([payment isEqualToString:@"creditcard"]) {
            //店舗の説明
            UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10,aboutLabel.frame.size.width,100)];
            checkLabel.textColor = [UIColor grayColor];
            checkLabel.backgroundColor = [UIColor clearColor];
            checkLabel.font = [UIFont boldSystemFontOfSize:12];
            [checkLabel setText:@"ご記入いただいたメールアドレスの方にご控えメールをお送りしておりますので御確認下さい。\nクレジットカードの利用明細にはPAYPAL*BASE SHOPと記載されます。着ていない場合は迷惑メールフォルダを御覧下さい。"];
            [checkLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [checkLabel setNumberOfLines:0];
            checkLabel.center = CGPointMake(160, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 60);
            [scrollView addSubview:checkLabel];
            
            
            UIImage *facebookImage = [UIImage imageNamed:@"btn_sns_fb.png"];
            
            UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
            facebookButton.frame = CGRectMake( 10, (checkLabel.frame.origin.y + checkLabel.frame.size.height) + 10, 145, 42);
            facebookButton.tag = 1;
            [facebookButton setBackgroundImage:facebookImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [facebookButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:facebookButton];
            
            
            
            UIImage *twitterImage = [UIImage imageNamed:@"btn_sns_tw.png"];
            UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            twitterButton.frame = CGRectMake( 165, (checkLabel.frame.origin.y + checkLabel.frame.size.height) + 10, 145, 42);
            twitterButton.tag = 2;
            [twitterButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [twitterButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:twitterButton];
            
            
            
            
            UIImage *backImage = [UIImage imageNamed:@"btn_05.png"];
            
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake( 10, (twitterButton.frame.origin.y + twitterButton.frame.size.height) + 30, 300, 50);
            backButton.tag = 1;
            [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [backButton addTarget:self action:@selector(backRoot)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:backButton];
            
            
            //ボタンテキスト
            UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(twitterButton.frame.origin.y + twitterButton.frame.size.height) + 35,240,40)];
            backLabel.text = @"TOPへ戻る";
            backLabel.textAlignment = NSTextAlignmentCenter;
            backLabel.font = [UIFont boldSystemFontOfSize:20];
            backLabel.shadowColor = [UIColor whiteColor];
            backLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            backLabel.backgroundColor = [UIColor clearColor];
            backLabel.textColor = [UIColor grayColor];
            [scrollView addSubview:backLabel];
        }else{
            
            
            
            UIImage *facebookImage = [UIImage imageNamed:@"btn_sns_fb.png"];
            
            UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
            facebookButton.frame = CGRectMake( 10, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10, 145, 42);
            facebookButton.tag = 1;
            [facebookButton setBackgroundImage:facebookImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [facebookButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:facebookButton];
            
            
            
            UIImage *twitterImage = [UIImage imageNamed:@"btn_sns_tw.png"];
            UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            twitterButton.frame = CGRectMake( 165, (aboutLabel.frame.origin.y + aboutLabel.frame.size.height) + 10, 145, 42);
            twitterButton.tag = 2;
            [twitterButton setBackgroundImage:twitterImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [twitterButton addTarget:self action:@selector(social:)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:twitterButton];
            
            
            
            
            UIImage *backImage = [UIImage imageNamed:@"btn_05.png"];
            
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake( 10, (twitterButton.frame.origin.y + twitterButton.frame.size.height) + 30, 300, 50);
            backButton.tag = 1;
            [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
            //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
            [backButton addTarget:self action:@selector(backRoot)forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:backButton];
            
            
            //ボタンテキスト
            UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(twitterButton.frame.origin.y + twitterButton.frame.size.height) + 35,240,40)];
            backLabel.text = @"TOPへ戻る";
            backLabel.textAlignment = NSTextAlignmentCenter;
            backLabel.font = [UIFont boldSystemFontOfSize:20];
            backLabel.shadowColor = [UIColor whiteColor];
            backLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            backLabel.backgroundColor = [UIColor clearColor];
            backLabel.textColor = [UIColor grayColor];
            [scrollView addSubview:backLabel];
        }
        
        
        
        int last = [scrollView.subviews count] - 1;
        UIView *hoge = (scrollView.subviews)[last];
        
        NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
        [scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 20))];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    
    
}

- (void)social:(id)sender{
    if ([sender tag] == 1) {
        [self sendFacebook:facebookContent];
    }else{
        [self sendTwitter];
    }
    
}

- (void)sendTwitter{
    NSString* postContent = twitterContent;
    NSURL* appURL = [NSURL URLWithString:@"https://thebase.in/"];
    // =========== iOSバージョンで、処理を分岐 ============
    // iOS Version
    NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Social.frameworkを使う
    if ([iosVersion floatValue] >= 6.0) {
        SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPostVC setInitialText:postContent];
        [twitterPostVC addURL:appURL]; // アプリURL
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


- (void)sendFacebook:(NSString *)text
{
    if(NSClassFromString(@"SLComposeViewController")) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@",text]];
        [self.navigationController presentViewController:composeViewController
                                                animated:YES
                                              completion:nil];
    } else {
        // iOS 5 以下はブラウザに移動してシェア機能を起動する
        NSString *escapedMessage = [self encode:text];
        NSString *escapedUrl = [self encode:shopUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@&t=%@",escapedUrl, escapedMessage]]];
        
    }
}
//カートの中身を削除
- (void)deleteCartItem{
    
    
    //boughtShopId
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *cartArray = @[];
    cartArray = [userDefaults arrayForKey:@"cart"];
    NSMutableArray *newCartArray = [NSMutableArray array];
    
    if (cartArray.count) {
        for (int n = 0; n < cartArray.count; n++) {
            NSDictionary *itemInfo = cartArray[n];
            NSString *shopId = itemInfo[@"shopId"];
            if ([shopId isEqualToString:boughtShopId]) {
                continue;
            }else{
                [newCartArray addObject:itemInfo];
            }
            
        }
        
        [userDefaults setObject:newCartArray forKey:@"cart"];
    }
    
    NSLog(@"newCartArray%@",cartArray);
    NSLog(@"cartArray%@",cartArray);
    
}
- (void)backRoot{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
