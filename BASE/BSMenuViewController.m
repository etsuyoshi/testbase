//
//  BSMenuViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMenuViewController.h"
#import "UICKeyChainStore.h"


@interface BSMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *supportItems;

@end

@implementation BSMenuViewController{
    BOOL goBuy;
    NSString *apiUrl;
}

@synthesize menuItems;
@synthesize supportItems;


- (void)awakeFromNib
{
    self.menuItems = @[@"itemAdmin", @"editShop", @"dataAdmin", @"moneyAdmin", @"myShopInfo",@"setting",@"account"];
    
    self.supportItems = @[@"help", @"contact", @"term", @"company",@"login"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:265.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    apiUrl = [BSDefaultViewObject setApiUrl];
    self.view.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 20, self.view.bounds.size.width, self.view.bounds.size.height - 20) style:UITableViewStylePlain];
    menuTable.dataSource = self;
    menuTable.delegate = self;
    menuTable.backgroundView = nil;
    menuTable.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    menuTable.separatorColor = [UIColor blackColor];
    [self.view addSubview:menuTable];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            return 84;

        }else{
            if ([BSDefaultViewObject isMoreIos7]) {
                return 54;
            }else{
                return 44;
            }

        }
    }else{
        if ([BSDefaultViewObject isMoreIos7]) {
            return 54;
        }else{
            return 44;
        }

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    int rows;
    if (sectionIndex == 0){
        rows = self.menuItems.count ;
    }else if (sectionIndex == 1){
        rows = self.supportItems.count + 1;
    }else{
        rows = 1;
    }
    
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}


//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 22;

}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 22)];
    sectionLabel.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0];
    sectionLabel.textColor = [UIColor grayColor];
    
    switch (section) {
        case 0:
            sectionLabel.text = @"メニュー";
            break;
        case 1:
            sectionLabel.text = @"サポート";
            break;
        default:
            break;
    }
    sectionLabel.font = [UIFont systemFontOfSize:14];
    [sectionHeaderView addSubview:sectionLabel];
    return sectionHeaderView;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        //cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        /*
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine.png"]];
        [bg setFrame:CGRectMake(0, 0, 320, 45)];
        */
        if (indexPath.section == 0) {
            //[cell addSubview:bg];
            //アイコン指定
            if (indexPath.row == 0) {
                cell.textLabel.text = @"商品管理";
                
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_managegoods"];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = @"デザイン編集";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_editshop"];
            }else if (indexPath.row == 2) {
                cell.textLabel.text = @"データ管理";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_data"];
            }else if (indexPath.row == 3) {
                cell.textLabel.text = @"お金管理";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_money"];
            }else if (indexPath.row == 4) {
                cell.textLabel.text = @"ショップ情報";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_shopinfo"];
            }else if (indexPath.row == 5) {
                cell.textLabel.text = @"ショップ設定";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_setting"];
            }else if (indexPath.row == 6) {
                cell.textLabel.text = @"アカウント設定";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_setting"];
            }
            
        }else if (indexPath.section == 1){
            //アイコン指定
            if (indexPath.row == 0) {
               // [cell addSubview:bg];
                cell.textLabel.text = @"ヘルプ";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_help"];
            }else if (indexPath.row == 1) {
               // [cell addSubview:bg];
                cell.textLabel.text = @"お問い合わせ";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_support"];
            }else if (indexPath.row == 2) {
              //  [cell addSubview:bg];
                cell.textLabel.text = @"利用規約";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_policy"];
            }else if (indexPath.row == 3) {
               // [cell addSubview:bg];
                cell.textLabel.text = @"会社概要";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_company"];
            }else if (indexPath.row == 4) {
             //   [cell addSubview:bg];
                cell.textLabel.text = @"ログアウト";
                cell.imageView.image = [UIImage imageNamed:@"icon_menu_logout"];
            }else if (indexPath.row == 5){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //買い手に遷移
                UIImage *buyImage = [UIImage imageNamed:@"btn_shopping.png"];
                UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                buyButton.frame = CGRectMake(15, 7, 234, 70);
                [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
                //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                [buyButton addTarget:self action:@selector(goBuy:)forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:buyButton];
            }
        }
        
        cell.textLabel.textColor = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.0];

    }
      
    
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        NSString *identifier = [NSString stringWithFormat:@"%@", (self.menuItems)[indexPath.row]];
        
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }else if (indexPath.section==1){
        if (indexPath.row == 5) {
            return;
        }
        if (indexPath.row == 4){
            [SVProgressHUD showWithStatus:@"ロード中です" maskType:SVProgressHUDMaskTypeGradient];
            NSString *session_id = [BSTutorialViewController sessions];
            
            if (session_id) {
                NSString *url = [NSString stringWithFormat:@"%@/users/sign_out?session_id=%@",apiUrl,session_id];
                //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                NSLog(@"%@",url);
                NSURL *baseUrl = [NSURL URLWithString:url];
                AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
                NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"" parameters:nil];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    NSLog(@"注文詳細！: %@", JSON);
                    NSString *error = [JSON valueForKeyPath:@"error.message"];
                    NSLog(@"エラーログ%@",error);
                    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
                    
                    [store removeItemForKey:@"email"];
                    [store removeItemForKey:@"password"];
                    
                    [store synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"ログアウトしました！"];
                    NSString *identifier = [NSString stringWithFormat:@"itemAdmin"];
                    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
                    
                    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                        CGRect frame = self.slidingViewController.topViewController.view.frame;
                        self.slidingViewController.topViewController = newTopViewController;
                        self.slidingViewController.topViewController.view.frame = frame;
                        [self.slidingViewController resetTopView];
                    }];
                    
                    
                    goBuy = YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } failure:nil];
                [operation start];                
            }
            return;
        }
        NSString *identifier = [NSString stringWithFormat:@"%@", (self.supportItems)[indexPath.row]];
        
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    
}

- (void)goBuy:(id)sender{
    goBuy = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *identifier = [NSString stringWithFormat:@"itemAdmin"];
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];

    if (goBuy) {
        [BSDefaultViewObject customNavigationBar:1];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
