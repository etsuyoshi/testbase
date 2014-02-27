//
//  BSHelpViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSHelpViewController.h"

@interface BSHelpViewController ()

@end

@implementation BSHelpViewController

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
    self.screenName = @"help";//グーグルアナリティクス

    
    
    
    UIWebView *helpWv = [[UIWebView alloc] init];
    helpWv.delegate = self;
    if ([BSDefaultViewObject isMoreIos7]) {
        helpWv.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height - 44);
    }else{
        helpWv.frame = CGRectMake(0, 44, 320, self.view.bounds.size.height - 44);
    }
    helpWv.scalesPageToFit = YES;
    [self.view addSubview:helpWv];
    
    NSURL *url = [NSURL URLWithString:@"http://thebase.in/pages/help.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [helpWv loadRequest:req];
    
    //バッググラウンド
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ヘルプ"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"ヘルプ";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    UIButton *menuButton;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, -2, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_7_menu"] forState:UIControlStateNormal];
    }else{
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, -2, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    }
    [menuButton addTarget:self action:@selector(slideMenu) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
    [menuButtonView addSubview:menuButton];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[BSMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
