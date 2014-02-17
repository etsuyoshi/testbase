//
//  BSDataAdminViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSDataAdminViewController.h"

@interface BSDataAdminViewController ()

@end

@implementation BSDataAdminViewController{
    NSString *apiUrl;
    
    NSString *uniqueKey;
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
    
    //グーグルアナリティクス
    self.trackedViewName = @"dataAdmin";
    apiUrl = [BSDefaultViewObject setApiUrl];
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    /*
    //UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"データ管理";
    [label sizeToFit];
    self.title = @"データ管理";
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.tag = 100;
    [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    /*
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, -2, 50, 42)];
    [menuButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(slideMenu) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
    [menuButtonView addSubview:menuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    */
    
    
    UIView *headerView = [[UIView alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        headerView.frame = CGRectMake(0,64,320,140);

        headerView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        headerView.frame = CGRectMake(0,0,320,140);

        //バッググラウンド
        headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
        
    }
    
    headerView.layer.shadowOpacity = 0.75f;
    headerView.layer.shadowRadius = 7.0f;
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.clipsToBounds = NO;
    [self.view insertSubview:headerView belowSubview:self.navigationController.navigationBar];
    
    
    UIView *pvView = [[UIView alloc] init];
    pvView.frame = CGRectMake(20,20,130,80);
    pvView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.65f];
    [[pvView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
    [[pvView layer] setBorderWidth:1.0];
    [headerView addSubview:pvView];
    
    UIView *orderView = [[UIView alloc] init];
    orderView.frame = CGRectMake(170,20,130,80);
    [[orderView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
    [[orderView layer] setBorderWidth:1.0];
    orderView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:241.0f/255.0f blue:252.0f/255.0f alpha:0.65f];
    [headerView addSubview:orderView];
    
    UILabel *todayPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
    todayPvLabel.text = @"今日のPV";
    todayPvLabel.textAlignment = NSTextAlignmentLeft;
    todayPvLabel.font = [UIFont boldSystemFontOfSize:14];
    todayPvLabel.shadowColor = [UIColor whiteColor];
    todayPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    todayPvLabel.backgroundColor = [UIColor clearColor];
    todayPvLabel.textColor = [UIColor darkGrayColor];
    [pvView addSubview:todayPvLabel];
    
    UILabel *totalPvLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
    totalPvLabel.text = @"/累計PV";
    totalPvLabel.textAlignment = NSTextAlignmentRight;
    totalPvLabel.font = [UIFont boldSystemFontOfSize:14];
    totalPvLabel.shadowColor = [UIColor whiteColor];
    totalPvLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    totalPvLabel.backgroundColor = [UIColor clearColor];
    totalPvLabel.textColor = [UIColor darkGrayColor];
    [pvView addSubview:totalPvLabel];
    
    pvNumber = [[UILabel alloc] initWithFrame:CGRectMake(0,50,130,22)];
    pvNumber.text = @"0/0";
    pvNumber.textAlignment = NSTextAlignmentCenter;
    pvNumber.font = [UIFont boldSystemFontOfSize:14];
    pvNumber.shadowColor = [UIColor whiteColor];
    pvNumber.shadowOffset = CGSizeMake(0.f, 1.f);
    pvNumber.backgroundColor = [UIColor clearColor];
    pvNumber.textColor = [UIColor darkGrayColor];
    [pvView addSubview:pvNumber];
    
    
    UILabel *ordersItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,10,100,16)];
    ordersItemLabel.text = @"未発送個数";
    ordersItemLabel.textAlignment = NSTextAlignmentLeft;
    ordersItemLabel.font = [UIFont boldSystemFontOfSize:14];
    ordersItemLabel.shadowColor = [UIColor whiteColor];
    ordersItemLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    ordersItemLabel.backgroundColor = [UIColor clearColor];
    ordersItemLabel.textColor = [UIColor darkGrayColor];
    [orderView addSubview:ordersItemLabel];
    
    UILabel *totalItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,28,100,16)];
    totalItemsLabel.text = @"/累計売上個数";
    totalItemsLabel.textAlignment = NSTextAlignmentRight;
    totalItemsLabel.font = [UIFont boldSystemFontOfSize:14];
    totalItemsLabel.shadowColor = [UIColor whiteColor];
    totalItemsLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    totalItemsLabel.backgroundColor = [UIColor clearColor];
    totalItemsLabel.textColor = [UIColor darkGrayColor];
    [orderView addSubview:totalItemsLabel];
    
    orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,50,120,22)];
    orderNumberLabel.text = @"0/0";
    orderNumberLabel.textAlignment = NSTextAlignmentCenter;
    orderNumberLabel.font = [UIFont boldSystemFontOfSize:14];
    orderNumberLabel.shadowColor = [UIColor whiteColor];
    orderNumberLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    orderNumberLabel.backgroundColor = [UIColor clearColor];
    orderNumberLabel.textColor = [UIColor darkGrayColor];
    [orderView addSubview:orderNumberLabel];
    
    
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,100,200,50)];
    orderLabel.text = @"注文詳細";
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.font = [UIFont boldSystemFontOfSize:16];
    orderLabel.shadowColor = [UIColor whiteColor];
    orderLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.textColor = [UIColor grayColor];
    [headerView addSubview:orderLabel];
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        headerView.frame = CGRectMake(0,64,320,140);
        //注文詳細テーブル
        orderListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.origin.y + headerView.frame.size.height, 320, self.view.bounds.size.height - 204) style:UITableViewStylePlain];
        orderListTable.dataSource = self;
        orderListTable.delegate = self;
        orderListTable.tag = 1;
        
        //orderListTable.backgroundView = nil;
        orderListTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:orderListTable];
    }else{
        //注文詳細テーブル
        orderListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, self.view.frame.size.height - 188) style:UITableViewStylePlain];
        orderListTable.dataSource = self;
        orderListTable.delegate = self;
        orderListTable.tag = 1;
        
        //orderListTable.backgroundView = nil;
        orderListTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:orderListTable];
        
    }
    
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    
    NSString *session_id = [BSTutorialViewController sessions];
    //NSString *urlString = [NSString stringWithFormat:@"%@/orders/get_orders?session_id=%@&=",apiUrl,session_id];
    NSString *urlString = [NSString stringWithFormat:@"%@/order_headers/get_orders?session_id=%@&=",apiUrl,session_id];
    
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"注文詳細！: %@", JSON);
        ordersArray = [JSON valueForKeyPath:@"result"];
        NSLog(@"%d:個orderがあるよ！",ordersArray.count);
        if (ordersArray.count) {
            [orderListTable reloadData];
        }
        
        
    } failure:nil];
    [operation start];
    
    
    urlString = [NSString stringWithFormat:@"%@/data/get_pv?session_id=%@&=",apiUrl,session_id];
    url = [NSURL URLWithString:urlString];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    AFJSONRequestOperation *operation2 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *pvResult1 = [JSON valueForKeyPath:@"result"];
        NSDictionary *pvResult2 = [pvResult1 valueForKeyPath:@"Data"];
        NSString *allPV = [pvResult2 valueForKeyPath:@"pv_all"];
        NSString *todayPV = [pvResult2 valueForKeyPath:@"pv_today"];
        
        
        
        
        pvNumber.text = [NSString stringWithFormat:@"%d/%d",[todayPV intValue],[allPV intValue]];
        
        
    } failure:nil];
    [operation2 start];
    
    
    urlString = [NSString stringWithFormat:@"%@/data/get_dispatch_status?session_id=%@&=",apiUrl,session_id];
    url = [NSURL URLWithString:urlString];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
    
    AFJSONRequestOperation *operation3 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dispatchResult1 = [JSON valueForKeyPath:@"result"];
        NSDictionary *dispatchResult2 = [dispatchResult1 valueForKeyPath:@"Data"];
        NSLog(@"ddddu%@",dispatchResult1);
        
        if ([[dispatchResult2 allKeys] containsObject:@"dispatched"]) {
            // 存在する場合の処理
            NSString *dispatched = [dispatchResult2 valueForKeyPath:@"dispatched"];
            NSString *undispatched = [dispatchResult2 valueForKeyPath:@"undispatched"];
            orderNumberLabel.text = [NSString stringWithFormat:@"%d/%d",[undispatched intValue],[dispatched intValue] + [undispatched intValue]];

        }
            
        
        
        
    } failure:nil];
    [operation3 start];
    
    
    
}



/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    if (ordersArray){
        rows = ordersArray.count;
    }else{
        rows = 1;
    }
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *identifiers;
    NSString *CellIdentifier;
    if (ordersArray.count) {
        NSDictionary *orderId = ordersArray[[indexPath row]];
        NSDictionary *orderListDict = [orderId valueForKeyPath:@"OrderHeader"];
        CellIdentifier = [orderListDict valueForKeyPath:@"id"];
        NSLog(@"%@るよ！",CellIdentifier);
    }else{
        identifiers = @[@"a"];
        CellIdentifier = identifiers[[indexPath row]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = YES;
    }
    
    /*
     switch (indexPath.section) {
     case 0:
     if (indexPath.row == 0) {
     //cell.imageView.image = [UIImage imageNamed:@"check"];
     }
     break;
     default:
     break;
     }
     */
    
    if (ordersArray.count) {
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}




//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ordersArray.count == 0) {
        NSLog(@"%d:番目が押されているよ！",indexPath.row);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSDictionary *orderId = ordersArray[[indexPath row]];
    NSDictionary *orderListDict = [orderId valueForKeyPath:@"OrderHeader"];
    NSString *importId = [orderListDict valueForKeyPath:@"unique_key"];
    
    //NSString *importId = [NSString stringWithFormat:@"%d",indexPath.row];
    NSLog(@"%@",importId);
    //EditViewController *editViewController = [[EditViewController alloc] init];
    BSOrderDetailsViewController *orderDtailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDetails"];
    [orderDtailsViewController setImportId:importId];
    
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:orderDtailsViewController animated:YES];
}
/*
 - (void)updateVisibleCells {
 // 見えているセルの表示更新
 for (UITableViewCell *cell in [orderListTable visibleCells]){
 [self updateCell:cell atIndexPath:[orderListTable indexPathForCell:cell]];
 }
 }
 */

// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    for (int n = 0; n < ordersArray.count; n++) {
        
        if (indexPath.row == n) {
            
            NSDictionary *orderId = ordersArray[[indexPath row]];
            NSDictionary *orderListDict = [orderId valueForKeyPath:@"OrderHeader"];
            
            NSMutableString *itemsName = [NSMutableString string];
            NSArray *itemsArray = [orderId valueForKeyPath:@"Order"];
            for (int n = 0; n < itemsArray.count; n++) {
                NSString *itemName = [[itemsArray objectAtIndex:n] objectForKey:@"title"];
                if (n == 0) {
                    [itemsName appendString:itemName];
                }else{
                    [itemsName appendString:[NSString stringWithFormat:@",%@",itemName]];
                }
            }
            //NSString *itemName = [orderListDict valueForKeyPath:@"title"];
            NSLog(@"オーダ:%@\n商品名:%@",orderId,itemsName);
            UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,280,30)];
            itemNameLabel.text = itemsName;
            itemNameLabel.textAlignment = NSTextAlignmentLeft;
            itemNameLabel.font = [UIFont boldSystemFontOfSize:18];
            itemNameLabel.shadowColor = [UIColor whiteColor];
            
            itemNameLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            itemNameLabel.backgroundColor = [UIColor clearColor];
            itemNameLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:itemNameLabel];
            
            
            NSString *firstName = [orderId valueForKeyPath:@"OrderReceiver.first_name"];
            NSString *lastName = [orderId valueForKeyPath:@"OrderReceiver.last_name"];
            NSString *userName =  [NSString stringWithFormat:@"%@ %@",lastName,firstName];
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,30,100,30)];
            userNameLabel.text = userName;
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            userNameLabel.font = [UIFont boldSystemFontOfSize:16];
            userNameLabel.shadowColor = [UIColor whiteColor];
            userNameLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:userNameLabel];
            
            NSString *orderedTime = [orderListDict valueForKeyPath:@"ordered"];
            UILabel *orderedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,60,160,20)];
            orderedTimeLabel.text = orderedTime;
            orderedTimeLabel.textAlignment = NSTextAlignmentLeft;
            orderedTimeLabel.font = [UIFont boldSystemFontOfSize:12];
            orderedTimeLabel.shadowColor = [UIColor whiteColor];
            orderedTimeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            orderedTimeLabel.backgroundColor = [UIColor clearColor];
            orderedTimeLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:orderedTimeLabel];
            
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(190,60,140,20)];
            statusLabel.textAlignment = NSTextAlignmentLeft;
            statusLabel.font = [UIFont boldSystemFontOfSize:12];
            statusLabel.shadowColor = [UIColor whiteColor];
            statusLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            statusLabel.backgroundColor = [UIColor clearColor];
            
            NSString *status = [orderListDict valueForKeyPath:@"undispatched"];
            if ([status intValue] == 1) {
                status = @"未発送の商品があります";
                statusLabel.textColor = [UIColor colorWithRed:21.0f/255.0f green:118.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
                statusLabel.font = [UIFont boldSystemFontOfSize:10];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"unread"];
                [imageView setFrame:CGRectMake(16, 35, 15, 15)];
                [cell.contentView addSubview:imageView];
                //cell.imageView.image = [UIImage imageNamed:@"unread"];
            } else {
                status = @"発送済";
                statusLabel.textColor = [UIColor lightGrayColor];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"check"];
                [imageView setFrame:CGRectMake(14, 35, 20, 20)];
                [cell.contentView addSubview:imageView];
                //cell.imageView.image = [UIImage imageNamed:@"check"];
            }
            statusLabel.text = status;
            [cell.contentView addSubview:statusLabel];
            
        }
    }
    // textLabel
    //NSString *text = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    //cell.textLabel.text = text;
    //NSString *detailText = @"詳細のtextLabel";
    //cell.textLabel.text = detailText;
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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
