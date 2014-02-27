//
//  BSMoneyAdminViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMoneyAdminViewController.h"

#import "BSSalesCounterView.h"
#import "BSBalanceView.h"



@interface BSMoneyAdminViewController ()

@end

@implementation BSMoneyAdminViewController{
    UITableView *historyTable;
    UITableView *bankInfoTable;
    
    
    UITextField *bankNameField;
    UITextField *bankBranchNameField;

    UITextField *bankVaryField;
    UITextField *bankHolderField;
    UITextField *bankNumberField;

    UITextField *amoutField;
    
    UILabel *salesAmountLabel;
    UILabel *balanceAmountLabel;
    
    UITextField *passwordField;
    
    UIScrollView *scrollView;
    //テキストフィールドにフォーカスした時の座標
    CGPoint svos;

    NSString *apiUrl;
    
    BSSalesCounterView *salesCounterView;
    BSBalanceView *balanceView;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bankNameField = nil;
        bankBranchNameField = nil;
        bankVaryField = nil;
        bankHolderField = nil;
        bankNumberField = nil;
        amoutField = nil;
        passwordField = nil;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self setMoneyInfo];

    
}

- (void)setMoneyInfo
{

    
    [[BSSellerAPIClient sharedClient] getDataFinanceWithSessionId:[BSUserManager sharedManager].sessionId type:nil completion:^(NSDictionary *results, NSError *error) {
        
        
        NSLog(@"getDataFinanceWithSessionId: %@", results);
        NSDictionary *result = [results valueForKeyPath:@"result"];
        NSDictionary *Data = [result valueForKeyPath:@"Data"];
        NSString *sales = [Data valueForKeyPath:@"sales"];
        NSString *withdrawal = [[Data valueForKeyPath:@"withdrawal"] stringValue];
        NSString *unwithdrawal = [[Data valueForKeyPath:@"unwithdrawal"] stringValue];
        
        salesCounterView.salesLabel.text = [NSString stringWithFormat:@"¥ %@",sales];
        balanceView.balanceLabel.text = [NSString stringWithFormat:@"¥ %@",withdrawal];
        balanceView.notRecordedLabel.text = [NSString stringWithFormat:@"(¥%@)",unwithdrawal];
        
        
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //グーグルアナリティクス
    self.screenName = @"moneyAdmin";
    
    self.title = @"お金管理";
    
    
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
    
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,164,320,self.view.bounds.size.height - 164)];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,320,self.view.bounds.size.height - 100)];
    }
    
    scrollView.contentSize = CGSizeMake(320, 560);
    scrollView.scrollsToTop = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    
    /*
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
    label.text = @"お金管理";
    [label sizeToFit];
    
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
    
    
    UIView *headerView = [[UIView alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        headerView.frame = CGRectMake(0,64,320,100);
        
        headerView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        headerView.frame = CGRectMake(0,0,320,100);
        //バッググラウンド
        headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
    }
    headerView.layer.shadowOpacity = 0.75f;
    headerView.layer.shadowRadius = 7.0f;
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.clipsToBounds = NO;
    [self.view insertSubview:headerView belowSubview:self.navigationController.navigationBar];
    
    

    /*
    UIView *salesView = [[UIView alloc] init];
    salesView.frame = CGRectMake(25,15,120,70);
    salesView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.65f];
    [[salesView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
    [[salesView layer] setBorderWidth:1.0];
    [headerView addSubview:salesView];
    
    UIView *balanceView = [[UIView alloc] init];
    balanceView.frame = CGRectMake(175,15,120,70);
    [[balanceView layer] setBorderColor:[[UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f] CGColor]];
    [[balanceView layer] setBorderWidth:1.0];
    balanceView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:241.0f/255.0f blue:252.0f/255.0f alpha:0.65f];
    [headerView addSubview:balanceView];
    
    
    
    UILabel *salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,10,100,14)];
    salesLabel.text = @"累計売り上げ";
    salesLabel.textAlignment = NSTextAlignmentCenter;
    salesLabel.font = [UIFont boldSystemFontOfSize:14];
    salesLabel.shadowColor = [UIColor whiteColor];
    salesLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    salesLabel.backgroundColor = [UIColor clearColor];
    salesLabel.textColor = [UIColor darkGrayColor];
    [salesView addSubview:salesLabel];
    
    
    salesAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,40,100,16)];
    salesAmountLabel.text = @"0";
    salesAmountLabel.font = [UIFont boldSystemFontOfSize:16];
    salesAmountLabel.shadowColor = [UIColor whiteColor];
    salesAmountLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    salesAmountLabel.backgroundColor = [UIColor clearColor];
    salesAmountLabel.textColor = [UIColor darkGrayColor];
    salesAmountLabel.textAlignment = NSTextAlignmentCenter;
    [salesView addSubview:salesAmountLabel];
    
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,10,100,14)];
    balanceLabel.text = @"未引き出し残高";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = [UIFont boldSystemFontOfSize:14];
    balanceLabel.shadowColor = [UIColor whiteColor];
    balanceLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    balanceLabel.backgroundColor = [UIColor clearColor];
    balanceLabel.textColor = [UIColor darkGrayColor];
    [balanceView addSubview:balanceLabel];
    
    balanceAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,40,100,16)];
    balanceAmountLabel.text = @"0";
    balanceAmountLabel.textAlignment = NSTextAlignmentCenter;
    balanceAmountLabel.font = [UIFont boldSystemFontOfSize:16];
    balanceAmountLabel.shadowColor = [UIColor whiteColor];
    balanceAmountLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    balanceAmountLabel.backgroundColor = [UIColor clearColor];
    balanceAmountLabel.textColor = [UIColor darkGrayColor];
    [balanceView addSubview:balanceAmountLabel];
    
    */
    
    
    
    
    
    
    //引き出し履歴
    historyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 45) style:UITableViewStylePlain];
    historyTable.dataSource = self;
    historyTable.delegate = self;
    historyTable.tag = 1;
    historyTable.backgroundView = nil;
    historyTable.scrollEnabled = NO;
    historyTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:historyTable];
    
    bankInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, 320, 400) style:UITableViewStyleGrouped];
    bankInfoTable.dataSource = self;
    bankInfoTable.delegate = self;
    bankInfoTable.tag = 2;
    bankInfoTable.backgroundView = nil;
    bankInfoTable.backgroundColor = [UIColor clearColor];
    bankInfoTable.scrollEnabled = NO;
    [scrollView addSubview:bankInfoTable];
    
    
    
    //ボタン
    UIImage *saveImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        saveImage = [UIImage imageNamed:@"btn_7_01"];
    }else{
        saveImage = [UIImage imageNamed:@"btn_01"];
    }
    UIButton *modalSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modalSaveButton.frame = CGRectMake( 20, 450, 280, 60);
    modalSaveButton.tag = 100;
    [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [modalSaveButton addTarget:self action:@selector(saveTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:modalSaveButton];
    
    /*
    //ボタン
    UIImage *normalImage = [UIImage imageNamed:@"btn_03"];
    UIButton *itemButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton2.frame = CGRectMake(20, 515, 280, 60);
    itemButton2.tag = 100;
    [itemButton2 setBackgroundImage:normalImage forState:UIControlStateNormal];
    //[itemButton2 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton2 addTarget:self action:@selector(cancelTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton2];
     */
    
    
    //ボタンテキスト
    UILabel *modalSelectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40,460,240,40)];
    modalSelectLabel1.text = @"申請する";
    modalSelectLabel1.textAlignment = NSTextAlignmentCenter;
    modalSelectLabel1.font = [UIFont boldSystemFontOfSize:20];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        modalSelectLabel1.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        modalSelectLabel1.shadowOffset = CGSizeMake(0.f, -1.f);
    }
    modalSelectLabel1.backgroundColor = [UIColor clearColor];
    modalSelectLabel1.textColor = [UIColor whiteColor];
    [scrollView addSubview:modalSelectLabel1];
    
    /*
    UILabel *modalSelectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 525, 240, 40)];
    modalSelectLabel2.text = @"キャンセル";
    modalSelectLabel2.textAlignment = NSTextAlignmentCenter;
    modalSelectLabel2.font = [UIFont boldSystemFontOfSize:20];
    modalSelectLabel2.shadowColor = [UIColor whiteColor];
    modalSelectLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    modalSelectLabel2.backgroundColor = [UIColor clearColor];
    modalSelectLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:modalSelectLabel2];

     */
     
    //完了ボタン
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque; // スタイルを設定
    [toolBar sizeToFit];
    // フレキシブルスペースの作成（Doneボタンを右端に配置したいため）
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Doneボタンの作成
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)] ;
    [done setTintColor:[UIColor blackColor]];
    
    // ボタンをToolbarに設定
    NSArray *items = @[spacer, done];
    [toolBar setItems:items animated:YES];
    
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [done setTitleTextAttributes:attribute forState:UIControlStateNormal];
    
    // ToolbarをUITextFieldのinputAccessoryViewに設定

    //入力フォーム
    bankNameField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    bankNameField.returnKeyType = UIReturnKeyNext;
    bankNameField.placeholder = @"例:○○銀行";
    bankNameField.delegate = self;
    bankNameField.text = @"";
    [bankNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    bankNameField.textAlignment = NSTextAlignmentRight;
    bankNameField.backgroundColor = [UIColor clearColor];
    
    bankBranchNameField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    bankBranchNameField.returnKeyType = UIReturnKeyNext;
    bankBranchNameField.placeholder = @"例:○○支店";
    bankBranchNameField.delegate = self;
    bankBranchNameField.text = @"";
    [bankBranchNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    bankBranchNameField.textAlignment = NSTextAlignmentRight;
    bankBranchNameField.backgroundColor = [UIColor clearColor];
    
    bankVaryField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    bankVaryField.returnKeyType = UIReturnKeyNext;
    bankVaryField.placeholder = @"普通";
    bankVaryField.delegate = self;
    bankVaryField.text = @"";
    [bankVaryField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    bankVaryField.textAlignment = NSTextAlignmentRight;
    bankVaryField.backgroundColor = [UIColor clearColor];
    
    bankHolderField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    bankHolderField.returnKeyType = UIReturnKeyNext;
    bankHolderField.placeholder = @"ノバタ タク";
    bankHolderField.delegate = self;
    bankHolderField.text = @"";
    [bankHolderField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    bankHolderField.textAlignment = NSTextAlignmentRight;
    bankHolderField.backgroundColor = [UIColor clearColor];
    
    
    bankNumberField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    bankNumberField.returnKeyType = UIReturnKeyNext;
    bankNumberField.placeholder = @"1234567";
    bankNumberField.delegate = self;
    bankNumberField.text = @"";
    bankNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [bankNumberField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    bankNumberField.textAlignment = NSTextAlignmentRight;
    bankNumberField.backgroundColor = [UIColor clearColor];
    
    amoutField = [[UITextField alloc] initWithFrame:CGRectMake(100.0, 0, 200.0, 44.0)];
    amoutField.returnKeyType = UIReturnKeyNext;
    amoutField.placeholder = @"20000";
    amoutField.delegate = self;
    amoutField.text = @"";
    amoutField.keyboardType = UIKeyboardTypeNumberPad;
    [amoutField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    amoutField.textAlignment = NSTextAlignmentRight;
    amoutField.backgroundColor = [UIColor clearColor];
    
    
    //入力フォームに完了ボタンを追加
    bankNameField.inputAccessoryView = toolBar;
    bankBranchNameField.inputAccessoryView = toolBar;
    bankVaryField.inputAccessoryView = toolBar;
    bankHolderField.inputAccessoryView = toolBar;
    bankNumberField.inputAccessoryView = toolBar;
    amoutField.inputAccessoryView = toolBar;
    
    UIScrollView *counterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    counterScrollView.contentSize = CGSizeMake(counterScrollView.frame.size.width * 2 - 38, headerView.frame.size.height);
    counterScrollView.pagingEnabled = YES;
    [headerView addSubview:counterScrollView];



    
    
    
    salesCounterView = [[BSSalesCounterView alloc] init];
    salesCounterView.center = CGPointMake(headerView.frame.size.width / 2, headerView.frame.size.height / 2);
    [counterScrollView addSubview:salesCounterView];
    
    balanceView = [[BSBalanceView alloc] init];
    balanceView.center = CGPointMake(headerView.frame.size.width / 2, headerView.frame.size.height / 2);
    balanceView.frame = CGRectMake((balanceView.frame.origin.x + balanceView.frame.size.width) + 8, balanceView.frame.origin.y, balanceView.frame.size.width, balanceView.frame.size.height);
    [counterScrollView addSubview:balanceView];
}



/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections;
    if (tableView == historyTable) {
        sections = 1;
    }else if(tableView == bankInfoTable){
        sections = 3;
    }else{
        sections = 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if (tableView == historyTable) {
        rows = 1;
    }else if(tableView == bankInfoTable){
        if (section == 0) {
            rows = 2;
        }else if (section == 1){
            rows = 3;
        }else{
            rows = 1;
        }
    }else{
        rows = 1;
    }
    return rows;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height;
    if(tableView == bankInfoTable){
        if (section == 0) {
            height = 42;
        }else if (section == 1){
            height = 16;
        }else{
            height = 30;
        }
    }else{
        height = 0.1;
    }
    return height;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height;
    if(tableView == bankInfoTable){
        if (section == 0) {
            height = 0.1;
        }else if (section == 1){
            height = 16;
        }else{
            height = 0.1;
        }
    }else{
        height = 0.1;
    }
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 20)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = [UIColor grayColor];
    
    switch (section) {
        case 0:
            sectionLabel.text = @"お金を引き出す";
            break;
        default:
            break;
    }
    sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    [sectionHeaderView addSubview:sectionLabel];
    return sectionHeaderView;
    
}



//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    if (tableView == bankInfoTable) {
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"bank",@"bankBranch"];
            CellIdentifier = contentArray[[indexPath row]];
        }else if(indexPath.section == 1){
            NSArray *contentArray = @[@"acount",@"acountName",@"acountNumber"];
            CellIdentifier = contentArray[[indexPath row]];
        }else{
            NSArray *contentArray = @[@"amount"];
            CellIdentifier = contentArray[[indexPath row]];
        }
    }else{
         CellIdentifier = @"history";
    }
        
            
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }
    
    
    
    if (tableView == bankInfoTable) {
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"銀行名",@"支店名"];
            cell.textLabel.text = contentArray[[indexPath row]];
            cell.textLabel.textColor = [UIColor grayColor];
            if (indexPath.row == 0) {
                
                [cell addSubview:bankNameField];
            }else{
                
                [cell addSubview:bankBranchNameField];
            }
        }else if(indexPath.section == 1){
            NSArray *contentArray = @[@"口座種別",@"口座名義",@"口座番号"];
            cell.textLabel.text = contentArray[[indexPath row]];
            cell.textLabel.textColor = [UIColor grayColor];
            
            cell.textLabel.textColor = [UIColor grayColor];
            if (indexPath.row == 0) {
                
                
                [cell addSubview:bankVaryField];
            }else if(indexPath.row == 1){
                
                [cell addSubview:bankHolderField];
            }else{
                
                [cell addSubview:bankNumberField];
            }
        }else{
            NSArray *contentArray = @[@"引出額"];
            cell.textLabel.text = contentArray[[indexPath row]];
            cell.textLabel.textColor = [UIColor grayColor];
            
            [cell addSubview:amoutField];
        }
    }else{
        if (indexPath.section == 0) {
            cell.textLabel.text = @"引き出し履歴";
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    
    
    
    
    
    return cell;
}

-(void)closeKeyboard:(id)sender{
    [bankNameField resignFirstResponder];
    [bankBranchNameField resignFirstResponder];
    [bankVaryField resignFirstResponder];
    [bankHolderField resignFirstResponder];
    [bankNumberField resignFirstResponder];
    [amoutField resignFirstResponder];

}
//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scrollView.contentOffset;
    CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];

}


//エンターを押した時に挙動
-(BOOL)textFieldShouldReturn:(UITextField*)textField{

    
    NSInteger nextTag = [textField tag] + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    NSLog(@"%@だよおおおおおお",nextResponder);
    if (textField == bankNameField) {
        // Found next responder, so set it.
        [bankBranchNameField becomeFirstResponder];
    }else if(textField == bankBranchNameField) {
        // Not found, so remove keyboard.
        [bankVaryField becomeFirstResponder];
    }else if(textField == bankVaryField){
        [bankHolderField becomeFirstResponder];
    }else if (textField == bankHolderField){
        [bankNumberField becomeFirstResponder];
    }else if (textField == bankNumberField){
        [amoutField becomeFirstResponder];
    }
    return NO;
}



//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    if (tableView == historyTable) {
        
    if (indexPath.row == 0) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
        [self.navigationController pushViewController:vc animated:YES];
        
        /*
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"未発送",@"発送済",nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
         */
    }
    }
    /*
     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDtails"];
     [self.navigationController pushViewController:vc animated:YES];
     */
}



- (IBAction)saveTheme:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"パスワードを入力してください"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"申請する", nil];
    /*
    if ([BSDefaultViewObject isMoreIos7]) {
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alert.delegate = self;

    }
     */
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.delegate = self;
    
    /*
    //Alertに乗せる入力テキストを作成
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 24.0)];
    passwordField.backgroundColor=[UIColor whiteColor];
    passwordField.text = @"";
    passwordField.keyboardType = UIKeyboardTypeEmailAddress;
    passwordField.secureTextEntry = YES;
    [alert addSubview:passwordField];
*/
    //Alertを表示
    [alert show];    
    //Responderをセット
    [passwordField becomeFirstResponder];
    

}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//OKボタンが押されたときのメソッド
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSString *session_id = [BSUserManager sharedManager].sessionId;
        
        NSString *url = [NSString stringWithFormat:@"%@/savings/apply_to_withdraw",apiUrl];
        url =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"ゆあるえる:%@",url);
        NSURL *url1 = [NSURL URLWithString:url];
        
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        parameter[@"session_id"] = session_id;
        parameter[@"bank_name"] = bankNameField.text;
        parameter[@"branch_name"] = bankBranchNameField.text;
        parameter[@"account_type"] = bankVaryField.text;
        parameter[@"account_name"] = bankHolderField.text;
        parameter[@"account_number"] = bankNumberField.text;
        parameter[@"drawings"] = amoutField.text;
        /*
        if ([BSDefaultViewObject isMoreIos7]) {
            parameter[@"password"] = [[alertView textFieldAtIndex:0] text];

        }else{
            parameter[@"password"] = passwordField.text;

        }
        
        */
        parameter[@"password"] = [[alertView textFieldAtIndex:0] text];

        
        NSLog(@"parameter%@",parameter);

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            
            NSLog(@"引き出し情報！: %@", responseObject);
            NSDictionary *error = [responseObject valueForKey:@"error"];
            NSArray *errorAcountTypeArray = [responseObject valueForKeyPath:@"error.validations.Saving.account_type"];
            if (errorAcountTypeArray.count) {
                NSString *errorAcountType = errorAcountTypeArray[0];
                [SVProgressHUD showErrorWithStatus:errorAcountType];
                
                return ;
            }
            NSArray *drawingsArray = [responseObject valueForKeyPath:@"error.validations.Saving.drawings"];
            if (drawingsArray.count) {
                NSString *drawings = drawingsArray[0];
                [SVProgressHUD showErrorWithStatus:drawings];
                
                return ;
            }
            NSArray *bankNameArray = [responseObject valueForKeyPath:@"error.validations.Saving.bank_name"];
            if (bankNameArray.count) {
                NSString *bankName = bankNameArray[0];
                [SVProgressHUD showErrorWithStatus:bankName];
                
                return ;
            }
            NSArray *branchNameArray = [responseObject valueForKeyPath:@"error.validations.Saving.branch_name"];
            if (branchNameArray.count) {
                NSString *branchName = branchNameArray[0];
                [SVProgressHUD showErrorWithStatus:branchName];
                
                return ;
            }
            NSArray *accountNameArray = [responseObject valueForKeyPath:@"error.validations.Saving.account_name"];
            if (accountNameArray.count) {
                NSString *accountName = accountNameArray[0];
                [SVProgressHUD showErrorWithStatus:accountName];
                
                return ;
            }
            NSArray *accountNumberArray = [responseObject valueForKeyPath:@"error.validations.Saving.account_number"];
            if (accountNumberArray.count) {
                NSString *accountNumber = accountNumberArray[0];
                [SVProgressHUD showErrorWithStatus:accountNumber];
                
                return ;
            }
            NSArray *passwordArray = [responseObject valueForKeyPath:@"error.validations.Saving.password"];
            if (passwordArray.count) {
                NSString *passwordNumber = passwordArray[0];
                [SVProgressHUD showErrorWithStatus:passwordNumber];
                
                return ;
            }
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"入力が正しくありません"];
                NSString *errorMessage = [error valueForKey:@"message"];
                NSLog(@"エラーメッセージ%@",errorMessage);
                return ;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"引き出し申請しました"];
            bankNameField.text = nil;
            bankBranchNameField.text = nil;
            bankVaryField.text = nil;
            bankHolderField.text = nil;
            bankNumberField.text = nil;
            amoutField.text = nil;
            passwordField.text = nil;
            [self setMoneyInfo];
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"通信に失敗しました..."];

        }];
        
    }
}

- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
