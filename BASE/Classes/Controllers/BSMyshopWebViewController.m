//
//  BSMyshopWebViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMyshopWebViewController.h"

@interface BSMyshopWebViewController ()

@end

@implementation BSMyshopWebViewController{
    NSString *userAgentString;
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
    apiUrl = [BSDefaultViewObject setApiUrl];
    self.screenName = @"MyShopWeb";//グーグルアナリティクス
    
    NSString *sessionId = [BSUserManager sharedManager].sessionId;
    NSLog(@"セッションid:%@",sessionId);
    NSString *urlString = [NSString stringWithFormat:@"%@/users/get_shop?session_id=%@",apiUrl,sessionId];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getUsersShopWithSessionId: %@", results);
        NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
        
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        userAgentString = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"useragent:%@",userAgentString);
        
        NSDictionary *dictionnary = @{@"UserAgent": @"PC"};
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        NSString *shopUrl = shopInfo[@"shop_url"];
        UIWebView *helpWv = [[UIWebView alloc] init];
        helpWv.delegate = self;
        if ([BSDefaultViewObject isMoreIos7]) {
            helpWv.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height - 64);
        }else{
            helpWv.frame = CGRectMake(0, 44, 320, self.view.bounds.size.height - 44);
            
        }
        helpWv.scalesPageToFit = YES;
        [self.view addSubview:helpWv];
        
        NSURL *url = [NSURL URLWithString:shopUrl];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [helpWv loadRequest:req];
        
    }];
    
    
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];


    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ショップを確認"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"ショップを確認";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, -2, 50, 42)];
    [menuButton setImage:[UIImage imageNamed:@"icon_close2"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
    [menuButtonView addSubview:menuButton];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dictionnary = @{@"UserAgent": userAgentString};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
