//
//  BSMoneyHistoryDetailsViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/21.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMoneyHistoryDetailsViewController.h"

@interface BSMoneyHistoryDetailsViewController ()

@end

@implementation BSMoneyHistoryDetailsViewController{
    UITableView *historyDetailTable;
    NSArray *historyDetailArray;
    
    NSString *apiUrl;
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
    
    [[BSSellerAPIClient sharedClient] getSavingsWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getSavingsWithSessionId: %@", results);
        historyDetailArray = [results valueForKeyPath:@"result"];
        [historyDetailTable reloadData];
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //グーグルアナリティクス
    self.screenName = @"moneyHistory";
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    self.title = @"履歴詳細";
    //バッググラウンド
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
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"履歴詳細"];
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
    label.text = @"履歴詳細";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"お金管理" target:self action:@selector(back) side:0];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    //引き出し履歴
    if ([BSDefaultViewObject isMoreIos7]) {
        historyDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
        
    }else{
        historyDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
        
    }
    historyDetailTable.dataSource = self;
    historyDetailTable.delegate = self;
    historyDetailTable.tag = 1;
    historyDetailTable.backgroundView = nil;
    historyDetailTable.scrollEnabled = YES;
    historyDetailTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyDetailTable];
    
    
    
    
    
}

/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    height = 54;
    return height;
}



//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
    
}

//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *identifiers = @[@"id",@"bankName", @"branchName",@"acountName", @"accountType",@"acountNumber",@"drawings",@"orderDay",@"status"];
    NSString *CellIdentifier = identifiers[[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = YES;
    }
    
    NSArray *contentArray = @[@"ID",@"銀行名", @"支店名",@"口座名義",@"口座種別",@"口座番号",@"引き出し金額",@"申請日時",@"状況"];
    cell.textLabel.text = contentArray[[indexPath row]];
    cell.textLabel.textColor = [UIColor grayColor];
    
    if (historyDetailArray.count) {
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    
    return cell;
}



//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    /*
     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDtails"];
     [self.navigationController pushViewController:vc animated:YES];
     */
}

// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *test = importId;
    int orderNumber = [test intValue];
    NSDictionary *orderId = historyDetailArray[orderNumber];
    NSDictionary *orderListDict = [orderId valueForKeyPath:@"Saving"];
    if (indexPath.row == 0) {
        NSString *itemName = [NSString stringWithFormat:@"%d",[test intValue] + 1];
        NSLog(@"オーダ:%@\n商品名:%@",orderId,itemName);
        cell.detailTextLabel.text = itemName;
    }else if(indexPath.row == 1){
        NSString *bankName = [orderListDict valueForKeyPath:@"bank_name"];
        cell.detailTextLabel.text = bankName;
    }else if(indexPath.row == 2){
        NSString *accountName = [orderListDict valueForKeyPath:@"branch_name"];
        cell.detailTextLabel.text = accountName;
    }else if(indexPath.row == 3){
        NSString *accountName = [orderListDict valueForKeyPath:@"account_name"];
        cell.detailTextLabel.text = accountName;
    }else if(indexPath.row == 4){
        NSString *accountNumber = [orderListDict valueForKeyPath:@"account_type"];
        cell.detailTextLabel.text = accountNumber;
    }else if(indexPath.row == 5){
        NSString *accountNumber = [orderListDict valueForKeyPath:@"account_number"];
        cell.detailTextLabel.text = accountNumber;
    }else if(indexPath.row == 6){
        NSString *drawings = [orderListDict valueForKeyPath:@"drawings"];
        cell.detailTextLabel.text = drawings;
    }else if(indexPath.row == 7){
        NSString *created = [orderListDict valueForKeyPath:@"created"];
        cell.detailTextLabel.text = created;
    }else if(indexPath.row == 8){
        NSString *status = [orderListDict valueForKeyPath:@"status"];
        if ([status isEqualToString:@"requested"]) {
            status = @"申請中";
        }else if([status isEqualToString:@"processing"]){
            status = @"処理中";
        }else if([status isEqualToString:@"done"]){
            status = @"完了";
        }else if([status isEqualToString:@"rejected"]){
            status = @"拒否";
        }
        cell.detailTextLabel.text = status;
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
