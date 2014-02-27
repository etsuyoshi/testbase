//
//  BSPaypalViewController.m
//  BASE
//
//  Created by Takkun on 2013/05/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSPaypalViewController.h"

#import "BSSelectPaymentTableViewController.h"
#import "BSConfirmCheckoutViewController.h"




@interface BSPaypalViewController ()

@end

@implementation BSPaypalViewController{
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
    
    self.view.tag = 10;
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.screenName = @"paypal";
    
    //バッググラウンド
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    //ナビゲーションバー
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"クレジットカード決済"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
     */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"クレジットカード決済";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    self.title = @"クレジットカード決済";

    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"住所入力" target:self action:@selector(backRoot) side:1];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    UIWebView *aWebView;
    if ([BSDefaultViewObject isMoreIos7]) {
        aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320,self.view.bounds.size.height - 64)];
    }else{
        aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320,self.view.bounds.size.height - 44)];
    }
    
    aWebView.scalesPageToFit = YES;
    [aWebView setDelegate:self];

    
    NSDictionary *checkOrderInfo = [BSSelectPaymentTableViewController getCartItem];
    NSLog(@"チェックの取得: %@", checkOrderInfo);
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/confirm_checkout",apiUrl]];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url1 absoluteString] parameters:checkOrderInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        id JSON = responseObject;
        
        NSLog(@"注文内容の取得: %@", JSON);
        NSDictionary *error = [JSON valueForKeyPath:@"error"];
        //NSString *paymenterror = [error objectAtIndex:0];
        //NSString *errormessage = [error objectForKey:@"message"];
        //NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
        
        //NSLog(@"Error message: %@", errormessage);
        if (!error) {
            NSString *total = [JSON valueForKeyPath:@"result.total"];
            //NSString *item = @"3000";
            NSInteger amount = [total intValue];
            //NSString *itemParameter = @"itemName=baseItem";
            //itemParameter = [itemParameter stringByAppendingString:item];
            
            NSString *amountParameter = @"amount=";
            amountParameter = [amountParameter stringByAppendingFormat:@"%d",amount];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/payments/checkout?",apiUrl];
            urlString = [urlString stringByAppendingString:amountParameter];
            //urlString = [urlString stringByAppendingString:@"&"];
            //urlString = [urlString stringByAppendingString:itemParameter];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSLog(@"ペイパルの値:%@",urlString);
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            [aWebView loadRequest:requestObj];
            NSString *ua = [aWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            [self.view addSubview:aWebView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD showWithStatus:@"読み込み中" maskType:SVProgressHUDMaskTypeGradient];
    
    NSString* url = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"表示されているURL:%@",url);
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSString *pre = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('pre')[0].innerHTML"];
    NSLog(@"innerHTML=%@", body);
    NSLog(@"innerHTMLpre=%@", pre);
    NSData *preData = [pre dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *checkDict = [NSJSONSerialization JSONObjectWithData:preData options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *check = checkDict[@"result"];
    NSString *result = [checkDict valueForKeyPath:@"result.message"];
    NSString *cancel = [checkDict valueForKeyPath:@"result.cancel"];
    //NSDictionary *error = [checkDict objectForKey:@"error"];
    
    if ([cancel intValue] == 1) {
        [self backRoot];
        [SVProgressHUD showSuccessWithStatus:@"キャンセルしました"];
        return;
    }
    if ([checkDict.allKeys containsObject:@"result"]) {
        BSConfirmCheckoutViewController *vc = [[BSConfirmCheckoutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"読み込み完了"];
        return;

    }
    NSLog(@"json=%@", check);
    NSLog(@"json=result%@", result);
    [SVProgressHUD dismiss];


}

- (void)backRoot{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.26;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
