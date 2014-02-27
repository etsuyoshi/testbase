//
//  BSBuyContactViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/18.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSBuyContactViewController.h"

@interface BSBuyContactViewController ()

@end

@implementation BSBuyContactViewController{
    UIScrollView *scrollView;
    UITextField *userNameField;
    UITextField *emailField;
    
    UITableView *questionTable;
    
    UITextView *questionTextView;
    
    //質問項目ピッカー
    UIActionSheet *stockActionSheet;
    BOOL pickerIsOpened;
    UIPickerView *stockPicker;
    
    UILabel *questionLabel;
    
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
	// Do any additional setup after loading the view.
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.screenName = @"buyContact";
    
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
    label.text = @"お問い合わせ";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height)];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height)];
    }
    scrollView.contentSize = CGSizeMake(320, 528);
    scrollView.scrollsToTop = YES;
    [self.view addSubview:scrollView];
    
    
    //お名前フォーム
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
    userNameField.borderStyle = UITextBorderStyleNone;
    userNameField.textColor = [UIColor blackColor];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    userNameField.leftView = paddingView1;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    userNameField.placeholder = @"お名前";
    userNameField.layer.borderWidth = 1.0;
    userNameField.layer.cornerRadius = 8.0;
    userNameField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    userNameField.font = [UIFont systemFontOfSize:18];
    userNameField.clearButtonMode = UITextFieldViewModeAlways;
    userNameField.delegate = self;
    userNameField.backgroundColor = [UIColor clearColor];
    [userNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [userNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:userNameField];
    
    //メールフォーム
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 72, 300, 44)];
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textColor = [UIColor blackColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftView = paddingView2;
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.placeholder = @"メールアドレス";
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.font = [UIFont systemFontOfSize:16];
    emailField.clearButtonMode = UITextFieldViewModeAlways;
    emailField.delegate = self;
    emailField.backgroundColor = [UIColor clearColor];
    emailField.layer.borderWidth = 1.0;
    emailField.layer.cornerRadius = 8.0;
    emailField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:emailField];
    
    
    
    //公開テーブル
    questionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 124, 320, 60) style:UITableViewStyleGrouped];
    questionTable.dataSource = self;
    questionTable.delegate = self;
    questionTable.tag = 1;
    questionTable.backgroundView = nil;
    questionTable.backgroundColor = [UIColor clearColor];
    questionTable.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [scrollView addSubview:questionTable];
    
    questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(46,2,240,40)];
    questionLabel.text = @"商品画像の表示について";
    questionLabel.textAlignment = NSTextAlignmentRight;
    questionLabel.font = [UIFont boldSystemFontOfSize:14];
    questionLabel.backgroundColor = [UIColor clearColor];
    questionLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    
    
    questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 196, 300, 120)];
    questionTextView.text = @"質問内容";
    questionTextView.textColor = [UIColor blackColor];
    questionTextView.layer.borderWidth = 1.0;
    questionTextView.layer.cornerRadius = 8.0;
    [questionTextView.layer setMasksToBounds:YES];
    questionTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    questionTextView.textColor = [UIColor lightGrayColor];
    [questionTextView setFont:[UIFont systemFontOfSize:17]];
    questionTextView.clipsToBounds = YES;
    questionTextView.backgroundColor = [UIColor clearColor];
    questionTextView.delegate = self;
    [scrollView addSubview:questionTextView];
    
    
    
    
    
    
    //保存ボタン
    UIImage *saveImage = [UIImage imageNamed:@"btn_01"];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake( 20, 340, 280, 50);
    sendButton.tag = 100;
    [sendButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [sendButton addTarget:self action:@selector(sendQuestion:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendButton];
    
    //ボタンテキスト
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,345,240,40)];
    sendLabel.text = @"送信する";
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.font = [UIFont boldSystemFontOfSize:20];
    sendLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    sendLabel.shadowOffset = CGSizeMake(0.f, -1.f);
    sendLabel.backgroundColor = [UIColor clearColor];
    sendLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:sendLabel];
    
    
    
    
    
    
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
    questionTextView.inputAccessoryView = toolBar;
    //ツールのボタンの文字色変更
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [done setTitleTextAttributes:attribute forState:UIControlStateNormal];
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
    rows = 1;
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
    height = 1;
    return height;
    
}



//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    CellIdentifier = @"question";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"質問事項";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:questionLabel];
        
    }
    
    
    return cell;
}






//商品説明のキーボードの完了ボタン
-(void)closeKeyboard:(id)sender{
    [questionTextView resignFirstResponder];
}

//テキストフィールドとテキストビューの設定
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return NO;
}
- (BOOL) textViewShouldBeginEditing: (UITextView*) textView {
    NSLog(@"%@",textView.text);
    NSString *str1 = textView.text;
    NSString *str2 = @"質問内容";
    if([str1 isEqualToString:str2]){
        NSLog(@"からにするよ");
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (BOOL) textViewShouldEndEditing: (UITextView*) textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"質問内容";
    }
    return YES;
}
//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == userNameField) {
        return;
    }
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


- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y = 0;
    [scrollView setContentOffset:pt animated:YES];
    
}
- (void)textViewDidEndEditing:(UITextField *)textField{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y = 0;
    [scrollView setContentOffset:pt animated:YES];
    
}


//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 4;
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (row) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"1.商品画像の表示について"];
            break;
        case 1: // 2列目
            return [NSString stringWithFormat:@"2.モールの更新について"];
            break;
        case 2: // 3列目
            return [NSString stringWithFormat:@"3.ショップ掲載について"];
            break;
        case 3: // 4列目
            return [NSString stringWithFormat:@"4.その他"];
            break;
        default:
            return 0;
            break;
    }
    
}
//質問項目ピッカー//キーボードを閉じる
- (void)allKeyboardClose{
    [userNameField resignFirstResponder];
    [emailField resignFirstResponder];
    [questionTextView resignFirstResponder];
    
}

//数量のピッカー
- (void)selectNumber{
    
    [self allKeyboardClose];
    
    stockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [stockActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    if (!pickerIsOpened) {
        stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        stockPicker.delegate = self; //自分自身をデリゲートに設定する。
        stockPicker.dataSource = self;
        stockPicker.showsSelectionIndicator = YES;
        pickerIsOpened = YES;
    }
    
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
    if ([stockPicker selectedRowInComponent:0] == 0) {
        questionLabel.text = @"商品画像の表示について";
    }else if ([stockPicker selectedRowInComponent:0] == 1){
        questionLabel.text = @"モールの更新について";
    }else if ([stockPicker selectedRowInComponent:0] == 2){
        questionLabel.text = @"ショップ掲載について";
    }else if ([stockPicker selectedRowInComponent:0] == 3){
        questionLabel.text = @"その他";
    }
    //stockLabel1.text = [NSString stringWithFormat:@"%d", stock1];
    
}

//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectNumber];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
}




//送信ボタン挙動
-(void)sendQuestion:(id)sender{
    [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    if ([questionTextView.text isEqualToString:@"質問内容"]) {
        questionTextView.text = @"";
    }
    NSString *emaiPrams = emailField.text;
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) emaiPrams,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    
    NSString *urlString = [NSString stringWithFormat:@"%@/inquiries/inquiry_for_buyer?title=%@&name=%@&mail_address=%@&inquiry=%@",apiUrl,[questionLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[userNameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],escapedString,[questionTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"おせてます%@",urlString);
    //[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        

        
        NSLog(@"ログイン情報！: %@", responseObject);
        NSArray *nameArray = [responseObject valueForKeyPath:@"error.validations.Inquiry.name"];
        if (nameArray.count) {
            NSString *name = nameArray[0];
            [SVProgressHUD showErrorWithStatus:name];
            return ;
        }
        NSArray *mailArray = [responseObject valueForKeyPath:@"error.validations.Inquiry.mail_address"];
        if (mailArray.count) {
            NSString *mail = mailArray[0];
            [SVProgressHUD showErrorWithStatus:mail];
            return ;
        }
        NSArray *inquiryArray = [responseObject valueForKeyPath:@"error.validations.Inquiry.inquiry"];
        if (inquiryArray.count) {
            NSString *inquiry = inquiryArray[0];
            [SVProgressHUD showErrorWithStatus:inquiry];
            return ;
        }
        
        
        [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    /*
     NSURL *url = [NSURL URLWithString:urlString];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     
     NSLog(@"注文詳細！: %@", JSON);
     
     
     
     } failure:nil];
     [operation start];
     
     */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
