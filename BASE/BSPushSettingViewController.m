//
//  BSPushSettingViewController.m
//  BASE
//
//  Created by Takkun on 2013/07/17.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSPushSettingViewController.h"

#import "AppDelegate.h"


@interface BSPushSettingViewController ()

@end

@implementation BSPushSettingViewController{
    NSString *apiUrl;
    UISwitch *pushSwitch1;
    UISwitch *pushSwitch2;
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
    //グーグルアナリティクス
    self.trackedViewName = @"pushSetting";
    
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
    label.text = @"通知設定";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    
    UITableView *menuTable;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 280) style:UITableViewStyleGrouped];
        menuTable.center =  CGPointMake(160, 200);

    }else{
        menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 299, 280) style:UITableViewStyleGrouped];
        menuTable.center =  CGPointMake(160, 140);

    }
    menuTable.dataSource = self;
    menuTable.delegate = self;
    menuTable.backgroundView = nil;
    menuTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:menuTable];
    
    
    pushSwitch1 = [[UISwitch alloc] init];
    //openSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    pushSwitch1.on = YES;
    pushSwitch1.tag = 1;
    [pushSwitch1 addTarget:self action:@selector(switchcontroll:)
         forControlEvents:UIControlEventValueChanged];
    
    pushSwitch2 = [[UISwitch alloc] init];
    //openSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    pushSwitch2.on = YES;
    pushSwitch2.tag = 2;
    [pushSwitch2 addTarget:self action:@selector(switchcontroll:)
          forControlEvents:UIControlEventValueChanged];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?token=%@",[BSDefaultViewObject setApiUrl],[AppDelegate getDeviceToken]];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"トークンの取得: %@", JSON);
        
        NSString *curation = [JSON valueForKeyPath:@"result.PushNotification.curation"];
        NSString *order = [JSON valueForKeyPath:@"result.PushNotification.order"];
        
        if ([curation intValue] == 1) {
            pushSwitch1.on = YES;
        }else{
            pushSwitch1.on = NO;
        }
        
        if ([order intValue] == 1) {
            pushSwitch2.on = YES;
        }else{
            pushSwitch2.on = NO;
        }
        NSString *errorMessage = [JSON valueForKeyPath:@"error.message"];
        NSLog(@"%@",errorMessage);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"ショッピング";
            break;
        case 1: // 2個目のセクションの場合
            return @"店舗管理";
            break;
    }
    return nil; //ビルド警告回避用
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"モールの更新通知";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //公開ボタン（スイッチ)
            pushSwitch1.center = CGPointMake(240, cell.frame.size.height/2);
            [cell addSubview:pushSwitch1];
            
        }else if (indexPath.section == 1) {
            cell.textLabel.text = @"注文通知";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            pushSwitch2.center = CGPointMake(240, cell.frame.size.height/2);
            [cell addSubview:pushSwitch2];

        }
    }
    return cell;
}

- (void)switchcontroll:(id)sender{
    
    [SVProgressHUD showWithStatus:@"変更中" maskType:SVProgressHUDMaskTypeGradient];
    
    int curation;
    int order;
    
    if (pushSwitch1.on) {
        curation = 1;
    }else{
        curation = 0;
    }
    if (pushSwitch2.on) {
        order = 1;
    }else{
        order = 0;
    }
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?token=%@&curation=%d&order=%d",[BSDefaultViewObject setApiUrl],[AppDelegate getDeviceToken],curation,order];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"トークンの取得: %@", JSON);
        
        NSString *curation = [JSON valueForKeyPath:@"result.PushNotification.curation"];
        NSString *order = [JSON valueForKeyPath:@"result.PushNotification.order"];
        
        if ([curation intValue] == 1) {
            pushSwitch1.on = YES;
        }else{
            pushSwitch1.on = NO;
        }
        
        if ([order intValue] == 1) {
            pushSwitch2.on = YES;
        }else{
            pushSwitch2.on = NO;
        }
        

        NSString *errorMessage = [JSON valueForKeyPath:@"error.message"];
        NSLog(@"%@",errorMessage);
        if (errorMessage) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",errorMessage]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"変更しました"];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    /*
    if ([sender tag] == 1) {
        NSLog(@"%@",pushSwitch1);
        if (pushSwitch1.on == NO) {
            creditIs = NO;
            NSLog(@"おふです");
        }else if(pushSwitch1.on == YES){
            creditIs = YES;
            NSLog(@"おんです");
        }
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
