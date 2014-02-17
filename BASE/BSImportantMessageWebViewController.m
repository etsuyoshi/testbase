//
//  UIImportantMessageWebViewController.m
//  BASE
//
//  Created by Takkun on 2013/12/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSImportantMessageWebViewController.h"

#import "BSMyShopViewController.h"
#import "BSDefaultViewObject.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "UICKeyChainStore.h"


@interface BSImportantMessageWebViewController ()

@end

@implementation BSImportantMessageWebViewController{
    
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
    
    
    
   
    UINavigationBar* navBarTop;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    }else{
        navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    navBarTop.alpha = 0.7f;
    
    // ナビゲーションアイテムを生成
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"お知らせ"];
    
    // 戻るボタンを生成
    UIBarButtonItem* btnItemBack = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeView)];
    
    // ナビゲーションアイテムの右側に戻るボタンを設置
    title.rightBarButtonItem = btnItemBack;
    
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBarTop pushNavigationItem:title animated:YES];
    
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:navBarTop];
    
    
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
	// Do any additional setup after loading the view.
    NSString *sessionId = [BSTutorialViewController sessions];
    NSLog(@"セッションid:%@",sessionId);
    NSString *urlString = [NSString stringWithFormat:@"%@/users/display_webview?session_id=%@",apiUrl,sessionId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    NSLog(@"ショップ情報%@",request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"users/display_webview2: %@", JSON);
        
        
        NSString *shopUrl = [JSON valueForKeyPath:@"result.url"];
        
        NSDictionary *dictionnary = @{@"UserAgent": @"mobile"};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        
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
        
         
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }

    
	// Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSString *js = [NSString stringWithFormat:@"document.body.style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:js];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
    NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
    NSString *email = [store stringForKey:@"email"];
    NSString *password = [store stringForKey:@"password"];

    NSLog(@"webViewDidFinishLoad");
    // テキストフィールドに入力するJSを実行する
    NSString *js1 = [NSString stringWithFormat:@"document.getElementById('mail').value='%@'",email];
    NSLog(@"webViewDidFinishLoad:%@",js1);
    [webView stringByEvaluatingJavaScriptFromString:js1];
    NSString *js2 = [NSString stringWithFormat:@"document.getElementById('pass').value='%@'",password];
    NSLog(@"webViewDidFinishLoad:%@",js2);
    [webView stringByEvaluatingJavaScriptFromString:js2];

    
    // サブミットするJSを実行する
    NSString *js3 = @"document.getElementById('UserLoginForm').submit();";
    [webView stringByEvaluatingJavaScriptFromString:js3];
}

- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
