//
//  BSOrderDtailsViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSOrderDetailsViewController.h"

@interface BSOrderDetailsViewController ()

@end

@implementation BSOrderDetailsViewController{
    UIScrollView *scrollView;
    NSDictionary *ordersDict;
    UITableView *orderReceiverDetailsTable;
    UITableView *orderDetailsTable;

    
    NSString *mail_address;
    NSString *remark;
    NSString *detailAddress;
    NSString *orderReceiverDetailAddress;
    
    int totalHeight;
    
    NSString *presentStatus;
    
    NSString *presentPayment;
    
    NSString *apiUrl;
    
    UIImageView *tabView;
    
    NSArray *orderItemsArray;
    
    int orderItemId;
    
    NSString *status;
    
    

}
@synthesize importId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [[BSSellerAPIClient sharedClient] getOrderHeadersOrderWithSessionId:[BSUserManager sharedManager].sessionId uniqueKey:importId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getOrderHeadersOrderWithSessionId: %@", results);
        ordersDict = [results valueForKeyPath:@"result"];
        orderItemsArray = [results valueForKeyPath:@"result.Order"];
        //presentPayment = [JSON valueForKeyPath:@"result.Order.payment"];
        [orderDetailsTable reloadData];
        [orderReceiverDetailsTable reloadData];
        
    }];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //グーグルアナリティクス
    self.screenName = @"orderDetails";
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
    //ナビゲーションバー
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"詳細"];
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
    label.text = @"詳細";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"データ管理" target:self action:@selector(back) side:0];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    
    /*
    //スクロール
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height)];
    scrollView.contentSize = CGSizeMake(320, 800);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    */
    
    
    self.navigationController.navigationBar.tag = 100;
    [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];

    if ([BSDefaultViewObject isMoreIos7]) {
        //タブ画像
        UIImage *Tabimage = [UIImage imageNamed:@"tab_setting1"];
        tabView = [[UIImageView alloc] initWithImage:Tabimage];
        tabView.frame = CGRectMake(0, 64, 320, 48);
        [self.view addSubview:tabView];
        
        //タブのボタン
        UIButton *leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftTabButton.frame = CGRectMake( 10,  64, 150, 48);
        leftTabButton.backgroundColor = [UIColor clearColor];
        leftTabButton.tag = 1;
        [leftTabButton addTarget:self action:@selector(changeTab:)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftTabButton];
        
        
        //タブのボタン
        UIButton *rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightTabButton.frame = CGRectMake( 160,  64, 150, 48);
        rightTabButton.backgroundColor = [UIColor clearColor];
        rightTabButton.tag = 2;
        [rightTabButton addTarget:self action:@selector(changeTab:)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightTabButton];
        
    }else{
        //タブ画像
        UIImage *Tabimage = [UIImage imageNamed:@"tab_setting1"];
        tabView = [[UIImageView alloc] initWithImage:Tabimage];
        tabView.frame = CGRectMake(0, 0, 320, 48);
        [self.view addSubview:tabView];
        
        
        //タブのボタン
        UIButton *leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftTabButton.frame = CGRectMake( 10,  0, 150, 48);
        leftTabButton.backgroundColor = [UIColor clearColor];
        leftTabButton.tag = 1;
        [leftTabButton addTarget:self action:@selector(changeTab:)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftTabButton];
        
        
        //タブのボタン
        UIButton *rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightTabButton.frame = CGRectMake( 160,  0, 150, 48);
        rightTabButton.backgroundColor = [UIColor clearColor];
        rightTabButton.tag = 2;
        [rightTabButton addTarget:self action:@selector(changeTab:)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightTabButton];
        
    }
   
    
    if ([BSDefaultViewObject isMoreIos7]) {
        orderReceiverDetailsTable = [[UITableView alloc] initWithFrame:CGRectMake(0,  tabView.frame.origin.y + tabView.frame.size.height, 320, self.view.frame.size.height - (tabView.frame.origin.y + tabView.frame.size.height + 44)) style:UITableViewStyleGrouped];
    }else{
        orderReceiverDetailsTable = [[UITableView alloc] initWithFrame:CGRectMake(0,  tabView.frame.origin.y + tabView.frame.size.height, 320, self.view.frame.size.height - (tabView.frame.origin.y + tabView.frame.size.height + 44)) style:UITableViewStyleGrouped];
    }
    orderReceiverDetailsTable.dataSource = self;
    orderReceiverDetailsTable.delegate = self;
    orderReceiverDetailsTable.tag = 1;
    orderReceiverDetailsTable.hidden = YES;
    orderReceiverDetailsTable.backgroundView = nil;
    orderReceiverDetailsTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderReceiverDetailsTable];
    
    
    //在庫テーブル
    if ([BSDefaultViewObject isMoreIos7]) {
        orderDetailsTable = [[UITableView alloc] initWithFrame:CGRectMake(0,  tabView.frame.origin.y + tabView.frame.size.height, 320, self.view.frame.size.height - (tabView.frame.origin.y + tabView.frame.size.height + 44)) style:UITableViewStyleGrouped];
    }else{
        orderDetailsTable = [[UITableView alloc] initWithFrame:CGRectMake(0,  tabView.frame.origin.y + tabView.frame.size.height, 320, self.view.frame.size.height - (tabView.frame.origin.y + tabView.frame.size.height + 44)) style:UITableViewStyleGrouped];
    }
    
    orderDetailsTable.dataSource = self;
    orderDetailsTable.delegate = self;
    orderDetailsTable.tag = 2;
    orderDetailsTable.hidden = NO;
    orderDetailsTable.backgroundView = nil;
    orderDetailsTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderDetailsTable];
    
    
    
    //タブテキスト
    UILabel *shopInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,150,24)];
    shopInfoLabel.text = @"お届先情報";
    shopInfoLabel.textAlignment = NSTextAlignmentCenter;
    shopInfoLabel.font = [UIFont boldSystemFontOfSize:14];
    shopInfoLabel.backgroundColor = [UIColor clearColor];
    shopInfoLabel.textColor = [UIColor darkGrayColor];
    [tabView addSubview:shopInfoLabel];
    
    //タブテキスト
    UILabel *termInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,10,150,24)];
    termInfoLabel.text = @"請求先情報";
    termInfoLabel.textAlignment = NSTextAlignmentCenter;
    termInfoLabel.font = [UIFont boldSystemFontOfSize:14];
    termInfoLabel.backgroundColor = [UIColor clearColor];
    termInfoLabel.textColor = [UIColor darkGrayColor];
    [tabView addSubview:termInfoLabel];
    
    
    
    
    
    
}







/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return 1;
    }else{
        return orderItemsArray.count + 2;
    }}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return 8;
    }else{
        if (section == 0) {
            return 1;

        } else if (section == 1) {
            return 4;
            
        }else{
            return 6;

        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    height = 54;
    if (tableView.tag == 1) {
        if (indexPath.row == 4) {
            [self tableView:orderReceiverDetailsTable cellForRowAtIndexPath:indexPath];
            CGSize bounds = CGSizeMake(orderReceiverDetailsTable.frame.size.width, orderReceiverDetailsTable.frame.size.height);
            //textLabelのサイズ
            CGSize size = [detailAddress sizeWithFont:[UIFont systemFontOfSize:20]
                                    constrainedToSize:bounds
                                        lineBreakMode:NSLineBreakByClipping];
            height = 54 + size.height;
        }
        if (indexPath.row == 5) {
            [self tableView:orderReceiverDetailsTable cellForRowAtIndexPath:indexPath];
            CGSize bounds = CGSizeMake(orderReceiverDetailsTable.frame.size.width, orderReceiverDetailsTable.frame.size.height);
            //textLabelのサイズ
            CGSize size = [mail_address sizeWithFont:[UIFont systemFontOfSize:20]
                                   constrainedToSize:bounds
                                       lineBreakMode:NSLineBreakByClipping];
            height = 54 + size.height;
        }
        if (indexPath.row == 7) {
            [self tableView:orderReceiverDetailsTable cellForRowAtIndexPath:indexPath];
            CGSize bounds = CGSizeMake(orderReceiverDetailsTable.frame.size.width, orderReceiverDetailsTable.frame.size.height);
            //textLabelのサイズ
            CGSize size = [remark sizeWithFont:[UIFont systemFontOfSize:20]
                             constrainedToSize:bounds
                                 lineBreakMode:NSLineBreakByClipping];
            height = 54 + size.height;
        }
        
        
        return height;
    }else{
    
        if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                [self tableView:orderDetailsTable cellForRowAtIndexPath:indexPath];
                CGSize bounds = CGSizeMake(orderDetailsTable.frame.size.width, orderDetailsTable.frame.size.height);
                //textLabelのサイズ
                CGSize size = [orderReceiverDetailAddress sizeWithFont:[UIFont systemFontOfSize:20]
                                                     constrainedToSize:bounds
                                                         lineBreakMode:NSLineBreakByClipping];
                height = 54 + size.height;
            }
        } else {
        }
        
        
        return height;
    }
    
}



//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag != 1) {
        return 40;
    }
    return 40;
    
}
//セクションタイトル
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView.tag == 1) {
        return @"請求先情報";
    }else{
        switch (section) {
            case 0:
                return @"注文ID";
                break;
            case 1:
                return @"お届先情報";
                break;
            case 2:
                return [NSString stringWithFormat:@"商品%d",section - 1];
                break;
                
            default:
                return nil;
                break;
        }
        
    }
    
}

//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
    
}

//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        
        NSArray *identifiers = @[@"payment",@"orderDay",@"purchaser",@"postcode",@"address",@"email",@"phone",@"remark"];
        NSString *CellIdentifier = identifiers[[indexPath row]];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            tableView.scrollEnabled = YES;
        }
        
        //NSArray *contentArray = @[@"商品名",@"価格",@"バリエーション",@"個数",@"合計金額",@"決済方法",@"発注日",@"購入者名",@"請求先郵便番号",@"請求先住所",@"メールアドレス",@"請求先電話番号",@"備考欄"];
        NSArray *contentArray = @[@"決済方法",@"発注日",@"購入者名",@"請求先郵便番号",@"請求先住所",@"メールアドレス",@"請求先電話番号",@"備考欄"];
        cell.textLabel.text = contentArray[[indexPath row]];
        cell.textLabel.textColor = [UIColor grayColor];
        
    
        
        if (ordersDict) {
            [self updateCell:cell atIndexPath:indexPath updateTableView:tableView];
        }
        
        
        return cell;
    }else{
        
        if (indexPath.section == 0) {
            NSString *CellIdentifier = @"orderID";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                tableView.scrollEnabled = YES;
            }
            
            cell.textLabel.text = @"注文ID";
            cell.textLabel.textColor = [UIColor grayColor];
            
            /*
             if (indexPath.row == 4) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
             }
             */
            
            if (ordersDict) {
                [self updateCell:cell atIndexPath:indexPath updateTableView:tableView];
            }
            
            
            return cell;
        } else if (indexPath.section == 1) {
            NSArray *identifiers = @[@"purchaser",@"postcode",@"address",@"phone"];
            NSString *CellIdentifier = identifiers[[indexPath row]];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                tableView.scrollEnabled = YES;
            }
            
            NSArray *contentArray = @[@"お届け先名",@"お届け先郵便番号",@"お届け先住所",@"お届け先電話番号"];
            cell.textLabel.text = contentArray[[indexPath row]];
            cell.textLabel.textColor = [UIColor grayColor];
            
            /*
             if (indexPath.row == 4) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
             }
             */
            
            if (ordersDict) {
                [self updateCell:cell atIndexPath:indexPath updateTableView:tableView];
            }
            
            
            return cell;
        }else{
            
            NSArray *identifiers = @[@"title",@"price",@"variation",@"amount",@"total",@"status"];
            NSString *CellIdentifier = identifiers[[indexPath row]];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                tableView.scrollEnabled = YES;
            }
            
            NSArray *contentArray = @[@"商品名",@"価格",@"バリエーション",@"個数",@"合計金額",@"配送状況"];
            cell.textLabel.text = contentArray[[indexPath row]];
            cell.textLabel.textColor = [UIColor grayColor];
            
            
             if (indexPath.row == 5) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
             }
            
            
            if (ordersDict) {
                [self updateCell:cell atIndexPath:indexPath updateTableView:tableView];
            }
            
            
            return cell;
        }
        
    }
    
   
}



//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    NSLog(@"決済方法%@",presentPayment);
    
    if (tableView.tag != 1) {
        /*
        NSString *test = importId;
        int orderNumber = [test intValue];
        NSDictionary *selectedOrderItem = ordersArray[orderNumber];
         */
        presentPayment = [ordersDict valueForKeyPath:@"OrderHeader.payment"];
        if (indexPath.row == 5) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

            orderItemId = cell.tag;
            if ([cell.detailTextLabel.text isEqualToString:@"注文をキャンセル"] || [cell.detailTextLabel.text isEqualToString:@"発送済"]) {
                return;
            }
      
            if ([presentPayment isEqualToString:@"creditcard"]) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"発送済",nil];
                actionSheet.tag = 2;
                [actionSheet showInView:self.view];
            }else{
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"発送済",@"注文をキャンセル",nil];
                actionSheet.tag = 1;
                [actionSheet showInView:self.view];
            }
            
        }
    }else{
        
    }
    
    
    /*
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDtails"];
    [self.navigationController pushViewController:vc animated:YES];
     */
    
    
}
//アクションシートの分岐
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
                /*
            case 0: //未発送
                status = @"ordered";
                break;
                 */
            case 0:  //発送済
                status = @"dispatched";
                break;                
            default:
                return;
        }
    }else{
        switch (buttonIndex) {
                /*
            case 0: //未発送
                status = @"ordered";
                break;
                 */
            case 0:  //発送済
                status = @"dispatched";
                break;
            case 1:  //キャンセル
                status = @"cancelled";
                break;
                
            default:
                return;
        }
        
    }
    
    
    if (status) {
        [SVProgressHUD showWithStatus:@"ステータスを変更中" maskType:SVProgressHUDMaskTypeGradient];
        
        /*
        NSString *test = importId;
        int orderNumber = [test intValue];
        NSDictionary *order = ordersArray[orderNumber];
         */
        //NSDictionary *orderListDict = [order valueForKeyPath:@"Order"];
        
        [[BSSellerAPIClient sharedClient] getChangingStatusMessageWithSessionId:[BSUserManager sharedManager].sessionId orderId:[NSString stringWithFormat:@"%d",orderItemId] status:status completion:^(NSDictionary *results, NSError *error) {
            
            NSLog(@"getChangingStatusMessageWithSessionId: %@", results);
            
            NSString *messageString = results[@"result"][@"message"];
            // １行で書くタイプ（複数ボタンタイプ）
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:messageString
                                      delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            [alert show];

            
            
        }];
        
        
    }
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [SVProgressHUD dismiss];
            break;
        case 1:
            [self changeDispatch];
            break;
    }
    
}

- (void)changeDispatch
{
    
    [[BSSellerAPIClient sharedClient] getOrdersChangeDispathcStatusWithSessionId:[BSUserManager sharedManager].sessionId orderId:[NSString stringWithFormat:@"%d",orderItemId] status:status completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getOrdersChangeDispathcStatusWithSessionId: %@", results);
        [SVProgressHUD showSuccessWithStatus:@"ステータス変更しました"];
        
        [[BSSellerAPIClient sharedClient] getOrderHeadersOrderWithSessionId:[BSUserManager sharedManager].sessionId uniqueKey:importId completion:^(NSDictionary *results, NSError *error) {
            
            NSLog(@"getOrderHeadersOrderWithSessionId: %@", results);
            orderItemsArray = [results valueForKeyPath:@"result.Order"];
            ordersDict = [results valueForKeyPath:@"result"];
            
            NSLog(@"status: %@",status);
            
            
            [orderDetailsTable reloadData];
            
        }];
        
    }];
}
// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath updateTableView:(UITableView *)tableView{
    
    if (tableView.tag == 1) {
        /*
        NSString *test = importId;
        int orderNumber = [test intValue];
        NSDictionary *orderId = ordersArray[orderNumber];
         */
        NSDictionary *orderListDict = [ordersDict valueForKeyPath:@"OrderHeader"];
        if(indexPath.row == 0){
            
            NSString *payment = [orderListDict valueForKeyPath:@"payment"];
            NSLog(@"payment123:%@",payment);
            
            
            if ([payment isEqualToString:@"bt"]) {
                payment = @"銀行振込";
            }else if([payment isEqualToString:@"cod"]){
                payment = @"代引き";
            }else{
                payment = @"クレジットカード";
            }
            cell.detailTextLabel.text = payment;
        }else if(indexPath.row == 1){
            NSString *ordered = [orderListDict valueForKeyPath:@"ordered"];
            cell.detailTextLabel.text = ordered;
        }else if(indexPath.row == 2){
            NSString *firstName = [orderListDict valueForKeyPath:@"first_name"];
            NSString *lastName = [orderListDict valueForKeyPath:@"last_name"];
            NSString *userName =  [NSString stringWithFormat:@"%@ %@",lastName,firstName];
            cell.detailTextLabel.text = userName;
        }else if(indexPath.row == 3){
            NSString *zipCode = [orderListDict valueForKeyPath:@"zip_code"];
            cell.detailTextLabel.text = zipCode;
        }else if(indexPath.row == 4){
            NSMutableString *prefecture = [orderListDict valueForKeyPath:@"prefecture"];
            NSMutableString *address = [orderListDict valueForKeyPath:@"address"];
            NSMutableString *address2 = [orderListDict valueForKeyPath:@"address2"];
            detailAddress = [NSString stringWithFormat:@"%@%@%@",prefecture,address,address2];
            
            cell.detailTextLabel.text = detailAddress;
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.numberOfLines = 0;
        }else if(indexPath.row == 5){
            
            mail_address = [orderListDict valueForKeyPath:@"mail_address"];
            cell.detailTextLabel.text = mail_address;
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.numberOfLines = 0;
        }else if(indexPath.row == 6){
            NSString *tel = [orderListDict valueForKeyPath:@"tel"];
            cell.detailTextLabel.text = tel;
        }else if(indexPath.row == 7){
            
            
            remark = [orderListDict valueForKeyPath:@"remark"];
            NSLog(@"remark123%@",remark);
            if ([remark isEqual:[NSNull null]]) {
                remark = @"";
            }
            
            
            cell.detailTextLabel.text = remark;
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            
            
            
            cell.detailTextLabel.numberOfLines = 0;
            
        }
    }else{
        /*
        NSString *test = importId;
        int orderNumber = [test intValue];
        NSDictionary *orderId = ordersArray[orderNumber];
         */
        if (indexPath.section == 0) {
            cell.detailTextLabel.text = importId;
        } else if (indexPath.section == 1) {
            NSDictionary *orderListDict = [ordersDict valueForKeyPath:@"OrderReceiver"];
            if (indexPath.row == 0) {
                NSString *firstName = [orderListDict valueForKeyPath:@"first_name"];
                NSString *lastName = [orderListDict valueForKeyPath:@"last_name"];
                NSString *userName =  [NSString stringWithFormat:@"%@ %@",lastName,firstName];
                cell.detailTextLabel.text = userName;
            }else if(indexPath.row == 1){
                NSString *zipCode = [orderListDict valueForKeyPath:@"zip_code"];
                cell.detailTextLabel.text = zipCode;
            }else if(indexPath.row == 2){
                NSMutableString *prefecture = [orderListDict valueForKeyPath:@"prefecture"];
                NSMutableString *address = [orderListDict valueForKeyPath:@"address"];
                NSMutableString *address2 = [orderListDict valueForKeyPath:@"address2"];
                orderReceiverDetailAddress = [NSString stringWithFormat:@"%@%@%@",prefecture,address,address2];
                
                cell.detailTextLabel.text = orderReceiverDetailAddress;
                cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
                cell.detailTextLabel.numberOfLines = 0;
            }else if(indexPath.row == 3){
                NSString *amount = [orderListDict valueForKeyPath:@"tel"];
                cell.detailTextLabel.text = amount;
            }else if(indexPath.row == 4){
                NSString *status = [ordersDict valueForKeyPath:@"OrderHeader.status"];
                NSLog(@"status123%@",status);
                if ([status isEqualToString:@"ordered"]) {
                    status = @"未発送";
                }else if([status isEqualToString:@"dispatched"]){
                    status = @"発送済";
                }else{
                    status = @"注文をキャンセル";
                }
                presentStatus = status;
                cell.detailTextLabel.text = status;
            }
        }else{
            NSDictionary *orderItemDict = [orderItemsArray objectAtIndex:indexPath.section - 2];
            
            //お金表記
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice;
            if (indexPath.row == 1) {
                numPrice = @([[orderItemDict objectForKey:@"price"] intValue]);
            } else if (indexPath.row == 4) {
                numPrice = @([[orderItemDict objectForKey:@"total"] intValue]);

            }
            NSString *strPrice = [nf stringFromNumber:numPrice];

            NSString *status = [orderItemDict objectForKey:@"status"];
            if ([status isEqualToString:@"ordered"]) {
                status = @"未発送";
            }else if([status isEqualToString:@"dispatched"]){
                status = @"発送済";
            }else{
                status = @"注文をキャンセル";
            }
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = [orderItemDict objectForKey:@"title"];
                    break;
                case 1:
                    
                    cell.detailTextLabel.text = strPrice;
                    break;
                case 2:
                    cell.detailTextLabel.text = [orderItemDict objectForKey:@"variation"];
                    break;
                case 3:
                    cell.detailTextLabel.text = [orderItemDict objectForKey:@"amount"];
                    break;
                case 4:
                    cell.detailTextLabel.text = strPrice;
                    break;
                case 5:
                    cell.tag = [[orderItemDict objectForKey:@"id"] intValue];
                    cell.detailTextLabel.text = status;
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    
    
            
}

//タブ切り替え
- (void)changeTab:(id)sender{
    if ([sender tag] == 1) {
        UIImage *image = [UIImage imageNamed:@"tab_setting1"];
        [tabView setImage:image];
        orderReceiverDetailsTable.hidden = YES;
        orderDetailsTable.hidden = NO;
    }else{
        UIImage *image = [UIImage imageNamed:@"tab_setting2"];
        [tabView setImage:image];
        orderReceiverDetailsTable.hidden = NO;
        orderDetailsTable.hidden = YES;

    }
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
