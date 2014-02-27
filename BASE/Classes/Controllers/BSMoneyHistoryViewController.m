//
//  BSMoneyHistoryViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/21.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMoneyHistoryViewController.h"

@interface BSMoneyHistoryViewController ()

@end

@implementation BSMoneyHistoryViewController{
    UITableView *historyTable;
    NSArray *historyArray;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[BSSellerAPIClient sharedClient] getSavingsWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
       
        NSLog(@"getSavingsWithSessionId: %@", results);
        historyArray = [results valueForKeyPath:@"result"];
        NSLog(@"%d:個orderがあるよ！",historyArray.count);
        [historyTable reloadData];

        
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    apiUrl = [BSDefaultViewObject setApiUrl];
    self.title = @"引き出し履歴";
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
    label.text = @"引き出し履歴";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"お金管理" target:self action:@selector(back) side:0];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    
    
    
    //引き出し履歴
    if ([BSDefaultViewObject isMoreIos7]) {
        historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64) style:UITableViewStylePlain];

    }else{
        historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44) style:UITableViewStylePlain];

    }
    historyTable.dataSource = self;
    historyTable.delegate = self;
    historyTable.tag = 1;
    historyTable.backgroundView = nil;
    historyTable.scrollEnabled = YES;
    historyTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyTable];
    
    
}


/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections;
    sections = 1;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int rows;
    if (historyArray){
        rows = historyArray.count;
    }else{
        rows = 1;
    }
    return rows;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height;    
    height = 0.1;
    return height;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height;
    height = 0.1;
    return height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    height = 80;
    
    return height;
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    CellIdentifier = @"history";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    if (historyArray.count) {
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}


- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    for (int n = 0; n < historyArray.count; n++) {
        
        if (indexPath.row == n) {
            
            NSDictionary *historyId = historyArray[[indexPath row]];
            NSDictionary *historyListDict = [historyId valueForKeyPath:@"Saving"];
            NSString *itemName = [NSString stringWithFormat:@"ID %d",[indexPath row] + 1];
            NSLog(@"ID:%d",[indexPath row]);
            UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,280,30)];
            itemNameLabel.text = itemName;
            itemNameLabel.textAlignment = NSTextAlignmentLeft;
            itemNameLabel.font = [UIFont boldSystemFontOfSize:18];
            itemNameLabel.shadowColor = [UIColor whiteColor];
            itemNameLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            itemNameLabel.backgroundColor = [UIColor clearColor];
            itemNameLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:itemNameLabel];
            
            
            NSString *drawings = [historyListDict valueForKeyPath:@"drawings"];
            //お金表記
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([drawings intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            NSString *userName =  [NSString stringWithFormat:@"引き出し金額:%@",strPrice];
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,30,300,30)];
            userNameLabel.text = userName;
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            userNameLabel.font = [UIFont boldSystemFontOfSize:16];
            userNameLabel.shadowColor = [UIColor whiteColor];
            userNameLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:userNameLabel];
            
            NSString *orderTime = [historyListDict valueForKeyPath:@"created"];
            UILabel *orderedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,60,160,20)];
            orderedTimeLabel.text = orderTime;
            orderedTimeLabel.textAlignment = NSTextAlignmentLeft;
            orderedTimeLabel.font = [UIFont boldSystemFontOfSize:12];
            orderedTimeLabel.shadowColor = [UIColor whiteColor];
            orderedTimeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            orderedTimeLabel.backgroundColor = [UIColor clearColor];
            orderedTimeLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:orderedTimeLabel];
            
            
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(190,60,100,20)];
            statusLabel.textAlignment = NSTextAlignmentLeft;
            statusLabel.font = [UIFont boldSystemFontOfSize:12];
            statusLabel.shadowColor = [UIColor whiteColor];
            statusLabel.shadowOffset = CGSizeMake(0.f, 1.f);
            statusLabel.backgroundColor = [UIColor clearColor];
            
            NSString *status = [historyListDict valueForKeyPath:@"status"];
            if ([status isEqualToString:@"requested"]) {
                status = @"申請中";
                statusLabel.textColor = [UIColor lightGrayColor];
            }else if([status isEqualToString:@"processing"]){
                status = @"処理中";
                statusLabel.textColor = [UIColor lightGrayColor];
            }else if([status isEqualToString:@"done"]){
                status = @"完了";
                statusLabel.textColor = [UIColor colorWithRed:21.0f/255.0f green:118.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
            }else if([status isEqualToString:@"rejected"]){
                status = @"拒否";
                statusLabel.textColor = [UIColor lightGrayColor];
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
//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *importId = [NSString stringWithFormat:@"%d",indexPath.row];
    NSLog(@"%@",importId);
    //EditViewController *editViewController = [[EditViewController alloc] init];
    
    BSMoneyHistoryDetailsViewController *historyDtailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"historyDetails"];
    [historyDtailsViewController setImportId:importId];
    
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:historyDtailsViewController animated:YES];
    /*
     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDtails"];
     [self.navigationController pushViewController:vc animated:YES];
     */
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
