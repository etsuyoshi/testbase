//
//  BSAboutPolicyViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSAboutPolicyViewController.h"
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"

@interface BSAboutPolicyViewController ()

@end

@implementation BSAboutPolicyViewController{
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"利用規約";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/abouts/get_agreement",apiUrl];
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
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];

        }else{
            tv = [[UITextView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];

        }
        tv.text = content;
        tv.editable = NO;
        tv.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tv];
    } failure:nil];
    [operation start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
