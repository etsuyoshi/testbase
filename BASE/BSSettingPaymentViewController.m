//
//  BSSettingPaymentViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSSettingPaymentViewController.h"

@interface BSSettingPaymentViewController ()

@end

@implementation BSSettingPaymentViewController{
    UITableView *paymentTable;
    UIScrollView *scrollView;
    
    BOOL creditIs;
    BOOL cashIs;
    BOOL bankIs;
    
    
    UITextField *cashField;
    
    UISwitch *creditSwitch;
    UISwitch *cashSwitch;
    UISwitch *bankSwitch;
    
    UITextField *bankNameField;
    UITextField *branchNameField;
    UITextField *accountVaryField;
    UITextField *accountHolderField;
    UITextField *accountNumberField;
    
    
    UIActionSheet *stockActionSheet;
    UIPickerView *stockPicker;
    
    
}
static NSDictionary *paymentInfo = nil;

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
    self.trackedViewName = @"settingPayment";
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    self.title = @"決済方法";
    
    //ナビゲーションバー
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"決済方法"];
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
    label.text = @"決済方法";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"設定" target:self action:@selector(back) side:0];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    

    UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(savePaymentInfo:)];
    self.navigationItem.rightBarButtonItem = rightItemButton;
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];

    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height )];

    }
    scrollView.contentSize = CGSizeMake(320, 540);
    scrollView.scrollsToTop = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    [self.view insertSubview:scrollView belowSubview:self.navigationController.navigationBar];
    
    
    
    
    
    
    
    paymentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 540) style:UITableViewStyleGrouped];
    paymentTable.dataSource = self;
    paymentTable.delegate = self;
    paymentTable.tag = 1;
    paymentTable.backgroundView = nil;
    paymentTable.scrollEnabled = NO;
    paymentTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:paymentTable];
    
    //クレジットカード利用ボタン（スイッチ)
    creditSwitch = [[UISwitch alloc] init];
    creditSwitch.center = CGPointMake(255, 23);
    creditSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    creditSwitch.on = NO;
    creditSwitch.tag = 1;
    [creditSwitch addTarget:self action:@selector(switchcontroll:)
             forControlEvents:UIControlEventValueChanged];
    
    //代引き利用ボタン（スイッチ)
    cashSwitch = [[UISwitch alloc] init];
    cashSwitch.center = CGPointMake(255, 23);
    cashSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    cashSwitch.on = NO;
    cashSwitch.tag = 2;
    [cashSwitch addTarget:self action:@selector(switchcontroll:)
           forControlEvents:UIControlEventValueChanged];
    
    //銀行振込利用ボタン（スイッチ)
    bankSwitch = [[UISwitch alloc] init];
    bankSwitch.center = CGPointMake(255, 23);
    bankSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    bankSwitch.on = NO;
    bankSwitch.tag = 3;
    [bankSwitch addTarget:self action:@selector(switchcontroll:)
         forControlEvents:UIControlEventValueChanged];
    
    
    
    //代引決済のテキストフィールド
    
    cashField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    cashField.borderStyle = UITextBorderStyleNone;
    cashField.textColor = [UIColor blackColor];
    cashField.placeholder = @"代引手数料(半角数字)";
    cashField.font = [UIFont systemFontOfSize:16];
    cashField.tag = 1;
    cashField.clearButtonMode = UITextFieldViewModeNever;
    cashField.textAlignment = NSTextAlignmentRight;
    cashField.keyboardType = UIKeyboardTypeNumberPad;
    cashField.returnKeyType = UIReturnKeyDone;
    cashField.delegate = self;
    [cashField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    cashField.backgroundColor = [UIColor clearColor];
    [cashField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    //銀行決済のテキストフィールド
    
    //銀行名
    bankNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    bankNameField.borderStyle = UITextBorderStyleNone;
    bankNameField.textColor = [UIColor blackColor];
    bankNameField.placeholder = @"銀行名";
    bankNameField.font = [UIFont systemFontOfSize:16];
    bankNameField.tag = 1;
    bankNameField.clearButtonMode = UITextFieldViewModeNever;
    bankNameField.textAlignment = NSTextAlignmentRight;
    bankNameField.returnKeyType = UIReturnKeyDone;
    bankNameField.delegate = self;
    [bankNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    bankNameField.backgroundColor = [UIColor clearColor];
    [bankNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    //支店名
    branchNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    branchNameField.borderStyle = UITextBorderStyleNone;
    branchNameField.textColor = [UIColor blackColor];
    branchNameField.placeholder = @"支店名";
    branchNameField.font = [UIFont systemFontOfSize:16];
    branchNameField.tag = 2;
    branchNameField.clearButtonMode = UITextFieldViewModeNever;
    branchNameField.textAlignment = NSTextAlignmentRight;
    branchNameField.returnKeyType = UIReturnKeyDone;
    branchNameField.delegate = self;
    [branchNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    branchNameField.backgroundColor = [UIColor clearColor];
    [branchNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
    //口座種別
    accountVaryField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    accountVaryField.borderStyle = UITextBorderStyleNone;
    accountVaryField.textColor = [UIColor blackColor];
    accountVaryField.placeholder = @"口座種別";
    accountVaryField.font = [UIFont systemFontOfSize:16];
    accountVaryField.tag = 10;
    accountVaryField.clearButtonMode = UITextFieldViewModeNever;
    accountVaryField.textAlignment = NSTextAlignmentRight;
    accountVaryField.returnKeyType = UIReturnKeyDone;
    accountVaryField.delegate = self;
    [accountVaryField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    accountVaryField.backgroundColor = [UIColor clearColor];
    [accountVaryField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    //口座名義
    accountHolderField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    accountHolderField.borderStyle = UITextBorderStyleNone;
    accountHolderField.textColor = [UIColor blackColor];
    accountHolderField.placeholder = @"口座名義";
    accountHolderField.font = [UIFont systemFontOfSize:16];
    accountHolderField.tag = 4;
    accountHolderField.clearButtonMode = UITextFieldViewModeNever;
    accountHolderField.textAlignment = NSTextAlignmentRight;
    accountHolderField.returnKeyType = UIReturnKeyDone;
    accountHolderField.delegate = self;
    [accountHolderField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    accountHolderField.backgroundColor = [UIColor clearColor];
    [accountHolderField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    //口座番号
    accountNumberField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    accountNumberField.borderStyle = UITextBorderStyleNone;
    accountNumberField.textColor = [UIColor blackColor];
    accountNumberField.placeholder = @"口座番号";
    accountNumberField.font = [UIFont systemFontOfSize:16];
    accountNumberField.tag = 5;
    accountNumberField.clearButtonMode = UITextFieldViewModeNever;
    accountNumberField.keyboardType = UIKeyboardTypeNumberPad;;
    accountNumberField.textAlignment = NSTextAlignmentRight;
    accountNumberField.returnKeyType = UIReturnKeyDone;
    accountNumberField.delegate = self;
    [accountNumberField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    accountNumberField.backgroundColor = [UIColor clearColor];
    [accountNumberField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
    
    
    //キーボードのバーをつける
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
    // ToolbarをUITextFieldのinputAccessoryViewに設定
    cashField.inputAccessoryView = toolBar;
    //ツールのボタンの文字色変更
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [done setTitleTextAttributes:attribute forState:UIControlStateNormal];
    accountNumberField.inputAccessoryView = toolBar;
    
    
    
    
    NSString *sessionId = [BSTutorialViewController sessions];
    NSLog(@"セッションid:%@",sessionId);
    NSString *urlString = [NSString stringWithFormat:@"%@/users/get_payment?session_id=%@",[BSDefaultViewObject setApiUrl],sessionId];
    NSLog(@"おせてます%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSLog(@"URLあああああ%@",url1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *reloadRequest = [httpClient requestWithMethod:@"GET"
                                                                  path:@""
                                                            parameters:nil];
    NSLog(@"ショップ情報%@",reloadRequest);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:reloadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"決済方法: %@", JSON);
    
        NSDictionary *presentPaymentInfo = [JSON valueForKeyPath:@"result.User"];
        
        // = [BSSettingViewController getPresentPaymentInfo];
        int buttonPosition = 0;
        if ([presentPaymentInfo[@"cod_payment"] intValue] == 1) {
            cashSwitch.on = YES;
            cashIs = YES;
            buttonPosition = 44;
            
        }
        if ([presentPaymentInfo[@"creditcart_payment"] intValue] == 1) {
            creditSwitch.on = YES;
            creditIs = YES;
            if (![presentPaymentInfo[@"charge"] isEqual:[NSNull null]])
                cashField.text = presentPaymentInfo[@"charge"];
        }
        if ([presentPaymentInfo[@"bt_payment"] intValue] == 1) {
            bankSwitch.on = YES;
            bankIs = YES;
            buttonPosition = buttonPosition + 44 * 5;
            
            if (![presentPaymentInfo[@"bank_name"] isEqual:[NSNull null]])
                bankNameField.text = presentPaymentInfo[@"bank_name"];
            if (![presentPaymentInfo[@"branch_name"] isEqual:[NSNull null]])
                branchNameField.text = presentPaymentInfo[@"branch_name"];
            if (![presentPaymentInfo[@"account_type"] isEqual:[NSNull null]])
                accountVaryField.text = presentPaymentInfo[@"account_type"];
            if (![presentPaymentInfo[@"account_name"] isEqual:[NSNull null]])
                accountHolderField.text = presentPaymentInfo[@"account_name"];
            if (![presentPaymentInfo[@"account_number"] isEqual:[NSNull null]])
                accountNumberField.text = presentPaymentInfo[@"account_number"];
            
        }
        
        
        [paymentTable reloadData];
         
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    
    
    
}



/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections;
    sections = 3;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    rows = 1;
    if (section == 1) {
        if (cashIs) {
            rows = 2;
        }else{
            rows = 1;
        }
    }
    if (section == 2) {
        if (bankIs) {
            rows = 6;
        }else{
            rows = 1;
        }
    }
    return rows;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height;
    height = 0.1;
    //if (tableView == paymentTable && section ==)
    return height;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height;
    height = 0.1;
    return height;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return NO;
}




//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    CellIdentifier = @"a";
    if (indexPath.section == 0) {
        CellIdentifier = @"credit";
    }else if (indexPath.section == 1){
        CellIdentifier = @"cash";
    }else if (indexPath.section == 2){
        CellIdentifier = @"bank";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }
    
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"クレジットカード決済";
        [cell addSubview:creditSwitch];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"代金引換決済";
            [cell addSubview:cashSwitch];
        }else{
            cell.textLabel.text = @"代引手数料";
            [cell addSubview:cashField];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"銀行振込決済";
            [cell addSubview:bankSwitch];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"銀行名";
            [cell addSubview:bankNameField];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"支店名";
            [cell addSubview:branchNameField];

        }else if (indexPath.row == 3){
            cell.textLabel.text = @"口座種別";
            [cell addSubview:accountVaryField];
        }else if (indexPath.row == 4){
            cell.textLabel.text = @"口座名義";
            [cell addSubview:accountHolderField];
        }else if (indexPath.row == 5){
            cell.textLabel.text = @"口座番号";
            [cell addSubview:accountNumberField];
        }
        
    }
    
    
    
    return cell;
}






//公開ボタンスイッチ
- (IBAction)switchcontroll:(id)sender
{
    
    UISwitch *switch1 = sender;
    if ([sender tag] == 1) {
        NSLog(@"%@",switch1);
        if (switch1.on == NO) {
            creditIs = NO;
            NSLog(@"おふです");
        }else if(switch1.on == YES){
            creditIs = YES;
            NSLog(@"おんです");
        }
    }else if ([sender tag] == 2) {
        if (switch1.on == NO) {
            cashIs = NO;
            [paymentTable beginUpdates];
            [paymentTable deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable endUpdates];
            NSLog(@"おふです");

            
        }else if(switch1.on == YES){
            cashIs = YES;
            [paymentTable beginUpdates];
            [paymentTable deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable endUpdates];
            NSLog(@"おんです");

        }
    }else{
        if (switch1.on == NO) {
            bankIs = NO;
            [paymentTable beginUpdates];
            [paymentTable deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable endUpdates];

        }else if(switch1.on == YES){
            NSLog(@"おんです");
            bankIs = YES;
            [paymentTable beginUpdates];
            [paymentTable deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [paymentTable endUpdates];
            

        }
    }
    
}


//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
}



//商品説明のキーボードの完了ボタン
-(void)closeKeyboard:(id)sender{
    [cashField resignFirstResponder];
    [accountNumberField resignFirstResponder];
}

//テキストフィールドとテキストビューの設定
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return NO;
}

//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    
    [scrollView setContentOffset:pt animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	// ピッカー表示開始
    if (textField == accountVaryField) {
        [self selectAccountVary];
        return NO;

    }else{
        return YES;

    }
    
}


//口座の種類
- (void)selectAccountVary{
    
    [self allKeyboardClose];
    
    
    stockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [stockActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stockPicker.delegate = self; //自分自身をデリゲートに設定する。
    stockPicker.dataSource = self;
    stockPicker.showsSelectionIndicator = YES;
    [stockPicker selectRow:12 inComponent:0 animated:NO];
    
    
    [stockActionSheet addSubview:stockPicker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"完了"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [stockActionSheet addSubview:closeButton];
    
    [stockActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [stockActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    NSLog(@"数量ボタンが押されたよ！");
    
}

//数量のピッカーを消す
- (void)dismissActionSheet:(id)sender{
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSArray *accountVaryFieldArray = @[@"普通",@"貯蓄",@"当座"];
    accountVaryField.text = accountVaryFieldArray[[stockPicker selectedRowInComponent:0]];
    
    
}


//選択ピッカー
//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 3;
    
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *accountVaryFieldArray = @[@"普通",@"貯蓄",@"当座"];
    
    return accountVaryFieldArray[row];
    
    
}


- (void)allKeyboardClose{
    
    for (UIView *subTableView in [self.view subviews]) {
        if ([subTableView isKindOfClass:[UITableView class]]) {
            for (UIView *subTextField in [subTableView subviews]) {
                if ([subTextField isKindOfClass:[subTextField class]]) {
                    [subTextField resignFirstResponder];
                }
            }
        }
    }
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y = 0;
    [scrollView setContentOffset:pt animated:YES];
    
}


//保存ボタン
-(void)savePaymentInfo:(id)sender{
    
        if ([self validationCheck]) {
            [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeGradient];
            NSString *credit = @"0";
            NSString *cod = @"0";
            NSString *bank = @"0";
            if (creditIs) credit = @"1";
            if (cashIs) cod = @"1";
            if (bankIs) bank = @"1";
            NSString *sessionId = [BSTutorialViewController sessions];

            NSDictionary *importPayment = @{@"session_id": sessionId,
                                           @"creditcart_payment": credit,
                                           @"cod_payment": cod,
                                           @"bt_payment": bank,
                                           @"charge": cashField.text,
                                           @"bank_name": bankNameField.text,
                                           @"branch_name": branchNameField.text,
                                           @"account_type": accountVaryField.text,
                                           @"account_name": accountHolderField.text,
                                           @"account_number": accountNumberField.text};
            paymentInfo = [importPayment copy];
            NSLog(@"importPayment:%@",importPayment);
            
            
            NSLog(@"セッションid:%@",sessionId);
            NSString *urlString = [NSString stringWithFormat:@"%@/users/edit_payment?session_id=%@",[BSDefaultViewObject setApiUrl],sessionId];
            NSLog(@"おせてます%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url1 = [NSURL URLWithString:urlString];
            NSLog(@"URLあああああ%@",url1);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
            //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
            NSMutableURLRequest *reloadRequest = [httpClient requestWithMethod:@"POST"
                                                                          path:@""
                                                                    parameters:paymentInfo];
            NSLog(@"ショップ情報%@",reloadRequest);
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:reloadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"決済方法変更後: %@", JSON);
                [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                NSLog(@"Error: %@", error);
                [SVProgressHUD showErrorWithStatus:@"通信エラー"];
                
            }];
            [operation start];
    
            
            
            //[self.navigationController popToRootViewControllerAnimated:YES];

        }else{
        }
        
}

//バリデーションチェック
- (BOOL)validationCheck{
    
    BOOL validation;
    NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
    [checkCharSet addCharactersInString:@"1234567890"];

    
    if(([[cashField.text stringByTrimmingCharactersInSet:checkCharSet] length] > 0 || cashField.text == nil || [cashField.text isEqualToString:@""]) && cashIs){
        [cashField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"代引手数料の入力が正しくありません" message:@"代引手数料をご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if ((bankNameField.text == nil || [bankNameField.text isEqualToString:@""]) && bankIs){
        [bankNameField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"銀行名の入力が正しくありません" message:@"銀行名をご入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if ((branchNameField.text == nil || [branchNameField.text isEqualToString:@""]) && bankIs){
        [branchNameField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"支店名の入力が正しくありません" message:@"支店名の住所のをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if((accountVaryField.text == nil || [accountVaryField.text isEqualToString:@""]) && bankIs){
        [accountVaryField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"口座種別の入力が正しくありません" message:@"口座種別をご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if ((accountHolderField.text == nil || [accountHolderField.text isEqualToString:@""]) && bankIs){
        [accountHolderField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"口座名義の入力が正しくありません" message:@"口座名義を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if ((accountNumberField.text == nil || [accountNumberField.text isEqualToString:@""]) && bankIs){
        [accountNumberField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"口座番号の入力が正しくありません" message:@"口座番号を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else{
        validation = YES;
    }
    
    return validation;
    NSLog(@"バリデーションチェック");
    
}




- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

+(NSDictionary*)getPaymentInfo{
    return paymentInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
