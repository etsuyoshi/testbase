//
//  BSTermViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSTermViewController.h"

@interface BSTermViewController ()

@end

@implementation BSTermViewController{
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
    //グーグルアナリティクス
    self.trackedViewName = @"term";
    
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
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"利用規約"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"利用規約";
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

- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[BSMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
 
    
    NSString *sessionId = [BSTutorialViewController sessions];
    NSString *urlString = [NSString stringWithFormat:@"%@/abouts/get_agreement?session_id=%@&=",apiUrl,sessionId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    NSLog(@"djkfalkjaslkd%@",request);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"注文詳細！: %@", JSON);
        NSString *content = [JSON valueForKey:@"contents"];
        UITextView *tv;
        if ([BSDefaultViewObject isMoreIos7]) {
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
        }else{
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,44, self.view.bounds.size.width, self.view.bounds.size.height -44)];
        }
        
        tv.text = content;
        tv.editable = NO;
        tv.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:tv atIndex:1];
    } failure:nil];
    [operation start];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
