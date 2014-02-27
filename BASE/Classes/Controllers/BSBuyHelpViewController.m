//
//  BSBuyHelpViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSBuyHelpViewController.h"

@interface BSBuyHelpViewController ()

@end

@implementation BSBuyHelpViewController

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
	
    //グーグルアナリティクス
    self.screenName = @"buyHelp";//グーグルアナリティクス
    
    
    
    
    UIWebView *helpWv = [[UIWebView alloc] init];
    helpWv.delegate = self;
    if ([BSDefaultViewObject isMoreIos7]) {
        helpWv.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height -64);
    }else{
        helpWv.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    }
    helpWv.scalesPageToFit = YES;
    [self.view addSubview:helpWv];
    
    NSURL *url = [NSURL URLWithString:@"http://thebase.in/pages/help_for_buyer.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [helpWv loadRequest:req];
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        //navBar.barTintColor = [UIColor grayColor];
        //navBar.backgroundColor = [UIColor grayColor];
    }else{
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"ヘルプ";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    
}


// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
