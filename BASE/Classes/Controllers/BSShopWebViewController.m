//
//  BSShopWebViewController.m
//  BASE
//
//  Created by Takkun on 2013/07/01.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSShopWebViewController.h"

#import "BSMyShopViewController.h"
#import "BSDefaultViewObject.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+DesignedButton.h"


@interface BSShopWebViewController ()

@end

@implementation BSShopWebViewController{
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
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

	// Do any additional setup after loading the view.
    NSString *sessionId = [BSUserManager sharedManager].sessionId;

    
    [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        NSLog(@"getUsersShopWithSessionId: %@", results);
        NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
        
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        userAgentString = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"useragent:%@",userAgentString);
        if ([[BSMyShopViewController getViewMode] isEqualToString:@"mobile"]) {
            
        }else{
            
            NSDictionary *dictionnary = @{@"UserAgent": @"PC"};
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
            
        }
        NSString *shopUrl = shopInfo[@"shop_url"];
        UIWebView *helpWv = [[UIWebView alloc] init];
        helpWv.delegate = self;
        if ([BSDefaultViewObject isMoreIos7]) {
            helpWv.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height - 64);
            
        }else{
            helpWv.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
            
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"ショップを確認";
    if ([[BSMyShopViewController getViewMode] isEqualToString:@"mobile"]) {
        label.text = @"モバイルビュー";
    }else{
       label.text = @"PCビュー";
    }
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"お店情報" target:self action:@selector(closeView) side:0];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    
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
   
    NSDictionary *dictionnary = @{@"UserAgent": userAgentString};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSDictionary *dictionnary = @{@"UserAgent": userAgentString};
     [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
