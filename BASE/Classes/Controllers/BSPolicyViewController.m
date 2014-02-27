//
//  BSSpecifiedCommercialTransactionLawViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/09.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSPolicyViewController.h"

#import "BSTutorialViewController.h"
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"

@interface BSPolicyViewController ()

@end

@implementation BSPolicyViewController{
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
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        //navBar.barTintColor = [UIColor grayColor];
        //navBar.backgroundColor = [UIColor grayColor];
    }else{
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    
    
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"利用規約"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissPolicy)];
    navItem.leftBarButtonItem = leftItemButton;
    
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    
    NSString *urlString = [NSString stringWithFormat:@"%@/abouts/get_agreement",apiUrl];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[BSSellerAPIClient sharedClient] getAboutsCompletion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"注文詳細！: %@", results);
        NSString *content = [results valueForKey:@"contents"];
        UITextView *tv;
        if ([BSDefaultViewObject isMoreIos7]) {
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        }else{
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,44, self.view.bounds.size.width, self.view.bounds.size.height -44)];
        }
        tv.text = content;
        tv.editable = NO;
        tv.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tv];
        
        
    }];
    
}

- (void)dismissPolicy{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
