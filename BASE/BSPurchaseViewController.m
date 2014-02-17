//
//  BSPurchaseViewController.m
//  BASE
//
//  Created by Takkun on 2013/05/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSPurchaseViewController.h"

@interface BSPurchaseViewController ()

@end

@implementation BSPurchaseViewController{
    UIScrollView *scrollView;
    
    
    UITableView *nameTable;
    UITextField *lastNameField;
    UITextField *firstNameField;
    
    
    UITableView *prefectureTable;
    UILabel *prefectureLabel;
    
    UITableView *postcodeTable;
    
    UITextView *commentTextView;
    UITableView *paymentTable;
    
    
    
    UIActionSheet *stockActionSheet;
    UIPickerView *stockPicker;
    BOOL pickerIsOpened;
    
    NSArray *prefectureArray;
    NSMutableArray *paymentArray;
    UILabel *payLabel;
    
    int selectedRow;
    
    NSMutableArray *orderItem;
    
    BOOL orderItemExisted;
    
    UITextField *postcodeField;
    UITextField *addressField;
    UITextField *fartherAddressField;
    UITextField *telField;
    UITextField *mailField;
    
    NSString *apiUrl;
    
}
static NSDictionary *importOrderDictionary = nil;
static NSDictionary *checkOrderDictionary = nil;

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
    self.trackedViewName = @"purchase";
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
    }
    
    //ナビゲーションバー
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"購入"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
     */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"お届け先";
    [label sizeToFit];
    self.title = @"お届け先";
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"カート" target:self action:@selector(backRoot) side:1];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height - 64)];
        scrollView.contentSize = CGSizeMake(320, 1000);
        scrollView.scrollsToTop = YES;
        [self.view addSubview:scrollView];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 44)];
        scrollView.contentSize = CGSizeMake(320, 1000);
        scrollView.scrollsToTop = YES;
        [self.view addSubview:scrollView];
    }
    

    
    //氏名
    //
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,14,240,22)];
    nameLabel.text = @"氏名";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:nameLabel];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //氏名
        nameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (nameLabel.frame.origin.y + nameLabel.frame.size.height) + 4, 320, 100) style:UITableViewStylePlain];
        nameTable.dataSource = self;
        nameTable.delegate = self;
        nameTable.tag = 1;
        nameTable.backgroundView = nil;
        nameTable.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:nameTable];
    }else{
        //氏名
        nameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (nameLabel.frame.origin.y + nameLabel.frame.size.height) + 4, 320, 100) style:UITableViewStyleGrouped];
        nameTable.dataSource = self;
        nameTable.delegate = self;
        nameTable.tag = 1;
        nameTable.backgroundView = nil;
        nameTable.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:nameTable];
    }
    
    //名前テーブルのセル内
    //名前フォーム（姓）
    lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 45)];
    lastNameField.borderStyle = UITextBorderStyleNone;
    lastNameField.textColor = [UIColor blackColor];
    lastNameField.textAlignment = NSTextAlignmentRight;
    lastNameField.placeholder = @"田中";
     //lastNameField.text = @"宮本";
    lastNameField.tag = 5;
    lastNameField.returnKeyType = UIReturnKeyDone;
    lastNameField.clearButtonMode = UITextFieldViewModeAlways;
    lastNameField.delegate = self;
    [lastNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    lastNameField.backgroundColor = [UIColor clearColor];
    [lastNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
    //名前フォーム（名）
    firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 45)];
    firstNameField.borderStyle = UITextBorderStyleNone;
    firstNameField.textColor = [UIColor blackColor];
    firstNameField.textAlignment = NSTextAlignmentRight;
    firstNameField.placeholder = @"太郎";
    //firstNameField.text = @"拓";
    firstNameField.tag = 6;
    firstNameField.returnKeyType = UIReturnKeyDone;
    firstNameField.clearButtonMode = UITextFieldViewModeAlways;
    firstNameField.delegate = self;
    [firstNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    firstNameField.backgroundColor = [UIColor clearColor];
    [firstNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
    
    
    
    
    
    //郵便番号
    UILabel *postcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(nameTable.frame.origin.y + nameTable.frame.size.height) + 10,240,22)];
    postcodeLabel.text = @"郵便番号";
    postcodeLabel.textAlignment = NSTextAlignmentLeft;
    postcodeLabel.font = [UIFont boldSystemFontOfSize:17];
    postcodeLabel.backgroundColor = [UIColor clearColor];
    postcodeLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:postcodeLabel];
    
    /*
    postcodeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (postcodeLabel.frame.origin.y + postcodeLabel.frame.size.height), 320, 60) style:UITableViewStyleGrouped];
    postcodeTable.dataSource = self;
    postcodeTable.delegate = self;
    postcodeTable.tag = 1;
    postcodeTable.backgroundView = nil;
    postcodeTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:postcodeTable];
    */
     
    //郵便番号
    postcodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, (postcodeLabel.frame.origin.y + postcodeLabel.frame.size.height) + 4, 300, 44)];
    postcodeField.borderStyle = UITextBorderStyleNone;
    postcodeField.textColor = [UIColor blackColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    postcodeField.leftView = paddingView;
    postcodeField.leftViewMode = UITextFieldViewModeAlways;
    postcodeField.placeholder = @"123-4567";
    //postcodeField.text = @"123-4567";
    postcodeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    postcodeField.font = [UIFont systemFontOfSize:16];
    postcodeField.clearButtonMode = UITextFieldViewModeAlways;
    postcodeField.delegate = self;
    postcodeField.backgroundColor = [UIColor clearColor];
    postcodeField.layer.borderWidth = 1.0;
    postcodeField.layer.cornerRadius = 8.0;
    postcodeField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [postcodeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [postcodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:postcodeField];

    
    
    //都道府県
    prefectureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (postcodeField.frame.origin.y + postcodeField.frame.size.height), 320, 60) style:UITableViewStylePlain];
    prefectureTable.dataSource = self;
    prefectureTable.delegate = self;
    prefectureTable.tag = 1;
    prefectureTable.backgroundView = nil;
    prefectureTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:prefectureTable];
    
    prefectureLabel = [[UILabel alloc] initWithFrame:CGRectMake(46,3,240,40)];
    prefectureLabel.text = @"東京都";
    prefectureLabel.textAlignment = NSTextAlignmentRight;
    prefectureLabel.font = [UIFont boldSystemFontOfSize:16];
    prefectureLabel.backgroundColor = [UIColor clearColor];
    prefectureLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:130.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
    
    
    
    //住所
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(prefectureTable.frame.origin.y + prefectureTable.frame.size.height) + 10,240,22)];
    addressLabel.text = @"住所";
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont boldSystemFontOfSize:17];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:addressLabel];
    
    
    //住所フォーム
    addressField = [[UITextField alloc] initWithFrame:CGRectMake(10, (addressLabel.frame.origin.y + addressLabel.frame.size.height) + 4, 300, 44)];
    addressField.borderStyle = UITextBorderStyleNone;
    addressField.textColor = [UIColor blackColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    addressField.leftView = paddingView2;
    addressField.leftViewMode = UITextFieldViewModeAlways;
    addressField.placeholder = @"〇〇市△△町";
    //addressField.text = @"港区六本木";
    addressField.keyboardType = UIKeyboardTypeEmailAddress;
    addressField.font = [UIFont systemFontOfSize:16];
    addressField.clearButtonMode = UITextFieldViewModeAlways;
    addressField.delegate = self;
    addressField.backgroundColor = [UIColor clearColor];
    addressField.layer.borderWidth = 1.0;
    addressField.layer.cornerRadius = 8.0;
    addressField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [addressField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [addressField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:addressField];
    
    
    //その他の住所
    UILabel *fartherAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(addressField.frame.origin.y + addressField.frame.size.height) + 10,240,22)];
    //fartherAddressLabel.text = @"その以降の住所";
    fartherAddressLabel.textAlignment = NSTextAlignmentLeft;
    fartherAddressLabel.font = [UIFont boldSystemFontOfSize:17];
    fartherAddressLabel.backgroundColor = [UIColor clearColor];
    fartherAddressLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:fartherAddressLabel];
    
    fartherAddressField = [[UITextField alloc] initWithFrame:CGRectMake(10, (fartherAddressLabel.frame.origin.y + fartherAddressLabel.frame.size.height) + 4, 300, 44)];
    fartherAddressField.borderStyle = UITextBorderStyleNone;
    fartherAddressField.textColor = [UIColor blackColor];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    fartherAddressField.leftView = paddingView3;
    fartherAddressField.leftViewMode = UITextFieldViewModeAlways;
    fartherAddressField.placeholder = @"〇丁目△-△BASEタワー〇号室";
    //fartherAddressField.text = @"7-11-12";
    fartherAddressField.keyboardType = UIKeyboardTypeEmailAddress;
    fartherAddressField.font = [UIFont systemFontOfSize:16];
    fartherAddressField.clearButtonMode = UITextFieldViewModeAlways;
    fartherAddressField.delegate = self;
    fartherAddressField.backgroundColor = [UIColor clearColor];
    fartherAddressField.layer.borderWidth = 1.0;
    fartherAddressField.layer.cornerRadius = 8.0;
    fartherAddressField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [fartherAddressField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [fartherAddressField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:fartherAddressField];
    
    
    
    //電話番号
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(fartherAddressField.frame.origin.y + fartherAddressField.frame.size.height) + 10,240,22)];
    telLabel.text = @"電話番号";
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.font = [UIFont boldSystemFontOfSize:17];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:telLabel];
    
    telField = [[UITextField alloc] initWithFrame:CGRectMake(10, (telLabel.frame.origin.y + telLabel.frame.size.height) + 4, 300, 44)];
    telField.borderStyle = UITextBorderStyleNone;
    telField.textColor = [UIColor blackColor];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    telField.leftView = paddingView4;
    telField.leftViewMode = UITextFieldViewModeAlways;
    telField.placeholder = @"123-456-7890";
    //telField.text = @"123-456-7890";
    telField.font = [UIFont systemFontOfSize:16];
    telField.clearButtonMode = UITextFieldViewModeAlways;
    telField.delegate = self;
    telField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    telField.backgroundColor = [UIColor clearColor];
    telField.layer.borderWidth = 1.0;
    telField.layer.cornerRadius = 8.0;
    telField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [telField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [telField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:telField];

    
    
    
    //メールアドレス
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(telField.frame.origin.y + telField.frame.size.height) + 10,240,22)];
    mailLabel.text = @"メールアドレス";
    mailLabel.textAlignment = NSTextAlignmentLeft;
    mailLabel.font = [UIFont boldSystemFontOfSize:17];
    mailLabel.backgroundColor = [UIColor clearColor];
    mailLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:mailLabel];
    
    mailField = [[UITextField alloc] initWithFrame:CGRectMake(10, (mailLabel.frame.origin.y + mailLabel.frame.size.height) + 4, 300, 44)];
    mailField.borderStyle = UITextBorderStyleNone;
    mailField.textColor = [UIColor blackColor];
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    mailField.leftView = paddingView5;
    mailField.leftViewMode = UITextFieldViewModeAlways;
    mailField.placeholder = @"example@example.com";
    //mailField.text = @"example@example.com";
    mailField.keyboardType = UIKeyboardTypeEmailAddress;
    mailField.font = [UIFont systemFontOfSize:16];
    mailField.clearButtonMode = UITextFieldViewModeAlways;
    mailField.delegate = self;
    mailField.backgroundColor = [UIColor clearColor];
    mailField.layer.borderWidth = 1.0;
    mailField.layer.cornerRadius = 8.0;
    mailField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    [mailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [mailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:mailField];
    
    
    //以前入力した情報を入力
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefaults dictionaryForKey:@"userInfo"];
    NSLog(@"userInfo:%@",userInfo);
    
    if (userInfo) {
        lastNameField.text = userInfo[@"last_name"];
        firstNameField.text = userInfo[@"first_name"];
        postcodeField.text = userInfo[@"zip_code"];
        prefectureLabel.text = userInfo[@"prefecture"];
        addressField.text = userInfo[@"address"];
        fartherAddressField.text = userInfo[@"address2"];
        telField.text = userInfo[@"tel"];
        mailField.text = userInfo[@"mail_address"];

    }
    
    
    
    
    
    //備考欄
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(mailField.frame.origin.y + mailField.frame.size.height) + 10,240,22)];
    commentLabel.text = @"備考欄";
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = [UIFont boldSystemFontOfSize:17];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:commentLabel];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, (commentLabel.frame.origin.y + commentLabel.frame.size.height) + 4, 300, 120)];
    commentTextView.text = @"ご要望がありましたら、ご記入ください。";
    commentTextView.textColor = [UIColor blackColor];
    commentTextView.layer.borderWidth = 1.0;
    commentTextView.layer.cornerRadius = 8.0;
    [commentTextView.layer setMasksToBounds:YES];
    commentTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    commentTextView.textColor = [UIColor lightGrayColor];
    [commentTextView setFont:[UIFont systemFontOfSize:17]];
    commentTextView.clipsToBounds = YES;
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.delegate = self;
    [scrollView addSubview:commentTextView];
    
    
    
    
    //エンボス
    UIView *topLine1 = [[UIView alloc] init];
    topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
    topLine1.frame = CGRectMake(0,  (commentTextView.frame.origin.y + commentTextView.frame.size.height) + 8, 320, 1);
    UIView *bottomLine1 = [[UIView alloc] init];
    bottomLine1.backgroundColor = [UIColor whiteColor];
    bottomLine1.frame = CGRectMake(0, (commentTextView.frame.origin.y + commentTextView.frame.size.height) + 9, 320, 1);
    [scrollView addSubview:topLine1];
    [scrollView addSubview:bottomLine1];
    
    
    
    
    //お支払い方法
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,(bottomLine1.frame.origin.y + bottomLine1.frame.size.height) + 10,240,22)];
    paymentLabel.text = @"お支払い方法";
    paymentLabel.textAlignment = NSTextAlignmentLeft;
    paymentLabel.font = [UIFont boldSystemFontOfSize:17];
    paymentLabel.backgroundColor = [UIColor clearColor];
    paymentLabel.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:paymentLabel];

    paymentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (paymentLabel.frame.origin.y + paymentLabel.frame.size.height) + 4, 320, 60) style:UITableViewStylePlain];
    paymentTable.dataSource = self;
    paymentTable.delegate = self;
    paymentTable.tag = 1;
    paymentTable.backgroundView = nil;
    paymentTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:paymentTable];
    
    payLabel = [[UILabel alloc] initWithFrame:CGRectMake(46,3,240,40)];
    payLabel.text = @"クレジットカード決済";
    payLabel.textAlignment = NSTextAlignmentRight;
    payLabel.font = [UIFont boldSystemFontOfSize:16];
    payLabel.backgroundColor = [UIColor clearColor];
    payLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:130.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        UIImage *buyImage = [UIImage imageNamed:@"btn_7_04"];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake( 10, (paymentTable.frame.origin.y + paymentTable.frame.size.height) + 10, 300, 50);
        buyButton.tag = 1;
        [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
        [buyButton setTitle:@"購入画面へ" forState:UIControlStateNormal];

        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [buyButton addTarget:self action:@selector(purchase:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:buyButton];
    }else{
        UIImage *buyImage = [UIImage imageNamed:@"btn_04"];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake( 10, (paymentTable.frame.origin.y + paymentTable.frame.size.height) + 10, 300, 50);
        buyButton.tag = 1;
        [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [buyButton addTarget:self action:@selector(purchase:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:buyButton];
        
        
        //ボタンテキスト
        UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(paymentTable.frame.origin.y + paymentTable.frame.size.height) + 15,240,40)];
        buyLabel.text = @"購入画面へ";
        buyLabel.textAlignment = NSTextAlignmentCenter;
        buyLabel.font = [UIFont boldSystemFontOfSize:20];
        buyLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        buyLabel.shadowOffset = CGSizeMake(0.f, -1.f);
        buyLabel.backgroundColor = [UIColor clearColor];
        buyLabel.textColor = [UIColor whiteColor];
        [scrollView addSubview:buyLabel];
    }
    

    
    
    
    //完了ボタン
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque; // スタイルを設定
    [toolBar sizeToFit];
    
    // フレキシブルスペースの作成（Doneボタンを右端に配置したいため）
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Doneボタンの作成
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)] ;
    [done setTintColor:[UIColor blackColor]];
    [done setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    // ボタンをToolbarに設定
    NSArray *items = @[spacer, done];
    [toolBar setItems:items animated:YES];
    
    // ToolbarをUITextFieldのinputAccessoryViewに設定
    commentTextView.inputAccessoryView = toolBar;

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    
    orderItem = [[BSCartViewController getCartItem] mutableCopy];
    
    
    //商品内容を確認
    NSString *version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    [orderItem setValue:version forKey:@"version"];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_order_details/",apiUrl]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    // don't forget to set parameterEncoding!
    NSDictionary *cartParameters = [orderItem copy];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:cartParameters];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"注文内容の取得: %@", JSON);
        NSDictionary *error = JSON[@"error"];
        NSString *errormessage = error[@"message"];
        NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
        NSLog(@"えあっっっっｒ%@",errormessage1);
        NSLog(@"Error message: %@", errormessage);
        [self setPayment:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    NSLog(@"orderItem%@",orderItem);
}

- (void)setPayment:(id)JSON{
    paymentArray = [NSMutableArray array];
    if ([[JSON valueForKeyPath:@"result.Shop.creditcart_payment"] intValue] == 1) {
        [paymentArray addObject:@"クレジットカード決済"];
        payLabel.text = @"クレジットカード決済";
    }
    if ([[JSON valueForKeyPath:@"result.Shop.bt_payment"] intValue] == 1) {
        [paymentArray addObject:@"銀行振込決済"];
        payLabel.text = @"銀行振込決済";

    }
    if ([[JSON valueForKeyPath:@"result.Shop.cod_payment"] intValue] == 1) {
        [paymentArray addObject: @"代金引換決済"];
        payLabel.text = @"代金引換決済";

    }
    if (!paymentArray.count) {
        NSLog(@"配列がないです%@",paymentArray);
        payLabel.text  = @"決済方法がありません";
    }else{
        NSLog(@"配列があります%@",paymentArray);
        payLabel.text  = paymentArray[0];
    }
    [stockPicker reloadAllComponents];
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
    if (tableView == nameTable) {
        rows = 2;
    }
    return rows;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height;
    if ([BSDefaultViewObject isMoreIos7]) {
        height = 0.1;

    }else{
        height = 0.1;

    }
    
    return height;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int height;
    height = 0.1;
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
    
    
    if (tableView == nameTable) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓";
            [cell addSubview:lastNameField];
        }else{
            cell.textLabel.text = @"名";
            [cell addSubview:firstNameField];
        }
    }else if (tableView == prefectureTable) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"都道府県";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell addSubview:prefectureLabel];
            
        }
    }else if (tableView == paymentTable) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"決済方法";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell addSubview:payLabel];
            
        }
    }
    
    return cell;
}

//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == prefectureTable) {
        selectedRow = 1;
        [stockPicker reloadAllComponents];
        [self selectNumber];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        if ([payLabel.text isEqualToString:@"決済方法がありません"]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
        selectedRow = 2;
        [stockPicker reloadAllComponents];
        [self selectNumber];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
}
//リターンを押した時に挙動
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
   
    [textField resignFirstResponder];
    return NO;
}

//備考欄のプレースホルダ
- (BOOL) textViewShouldBeginEditing: (UITextView*) textView {
    NSLog(@"%@",textView.text);
    NSString *str1 = textView.text;
    NSString *str2 = @"ご要望がありましたら、ご記入ください。";
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
        textView.text = @"ご要望がありましたら、ご記入ください。";
    }
    return YES;
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







//選択ピッカー
//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (selectedRow == 1) {

        return 47;
    }else{
        return paymentArray.count;
    }
    
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    prefectureArray = @[@"北海道", @"青森県", @"岩手県",@"宮城県", @"秋田県", @"山形県",@"福島県", @"茨城県", @"栃木県",@"群馬県", @"埼玉県", @"千葉県",@"東京都", @"神奈川県", @"新潟県",@"富山県", @"石川県", @"福井県",@"山梨県", @"長野県", @"岐阜県",@"静岡県", @"愛知県", @"三重県",@"滋賀県", @"京都府", @"大阪府",@"兵庫県", @"奈良県", @"和歌山県",@"鳥取県", @"島根県", @"岡山県",@"広島県", @"山口県", @"徳島県",@"香川県", @"愛媛県", @"高知県",@"福岡県", @"佐賀県", @"長崎県",@"熊本県", @"大分県", @"宮崎県",@"鹿児島県", @"沖縄県"];
    //paymentArray = [NSArray arrayWithObjects:@"クレジットカード決済", @"代金引換決済", @"銀行振込決済", nil];
    if (selectedRow == 1) {
        return prefectureArray[row];
    }else{
        return paymentArray[row];
    }
    
}

//キーボードを閉じる
- (void)allKeyboardClose{
    
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
    
    
    if (selectedRow == 1) {
        prefectureLabel.text = prefectureArray[[stockPicker selectedRowInComponent:0]];
    }else{
        payLabel.text = paymentArray[[stockPicker selectedRowInComponent:0]];
    }
    
    
}


- (void)purchase:(id)sender{

    if ([commentTextView.text isEqualToString:@"ご要望がありましたら、ご記入ください。"]) {
        commentTextView.text = @"";
    }
    
    
    //商品内容を確認
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/confirm_checkout",apiUrl]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    // don't forget to set parameterEncoding!
    NSMutableDictionary *cartDict = [orderItem mutableCopy];
    
    //バリデーションチェック
    BOOL validation = [self validationCheck];
    if (validation) {
        cartDict[@"last_name"] = lastNameField.text;
        cartDict[@"first_name"] = firstNameField.text;
        cartDict[@"zip_code"] = postcodeField.text;
        cartDict[@"prefecture"] = prefectureLabel.text;
        cartDict[@"address"] = addressField.text;
        cartDict[@"address2"] = fartherAddressField.text;
        cartDict[@"tel"] = telField.text;
        cartDict[@"mail_address"] = mailField.text;
        cartDict[@"remark"] = commentTextView.text;
         NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        cartDict[@"version"] = version;

    }else{
        return;
    }
    [SVProgressHUD showWithStatus:@"注文情報を確認中" maskType:SVProgressHUDMaskTypeGradient];
    
    NSLog(@"cartDict:%@", cartDict);
    //決済情報なし
    checkOrderDictionary = [cartDict copy];
    //決済情報を追加
    if ([payLabel.text isEqualToString:@"クレジットカード決済"]) {
        cartDict[@"payment"] = @"creditcard";
        NSLog(@"クレジットカード決済cartDict:%@", cartDict);
        NSLog(@"クレジットカード決済");
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:cartParameters];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"注文内容の取得: %@", JSON);
            NSDictionary *error = JSON[@"error"];
            NSString *errormessage = error[@"message"];
            NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"えあっっっっｒ%@",errormessage1);
            NSLog(@"Error message: %@", errormessage);
            
            
            
            NSArray *zipcodeArray = [JSON valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [JSON valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [JSON valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [JSON valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [JSON valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [JSON valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [JSON valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];


                
        
            }else{
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userInfo = [userDefaults dictionaryForKey:@"userInfo"];
                NSLog(@"住所情報userInfo:%@",userInfo);
                if (!userInfo) {
                    NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
                    
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                    /*
                     if ( ![userDefaults synchronize] ) {
                     NSLog( @"failed ..." );
                     }else{
                     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
                     [self.navigationController pushViewController:vc animated:YES];
                     }
                     */
                }else{
                    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                }
                [SVProgressHUD showSuccessWithStatus:@"完了"];
                
                //ペイパル決済に飛ぶ
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"paypal"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        NSLog(@"orderItem%@",orderItem);
        
        
    
    }else if ([payLabel.text isEqualToString:@"代金引換決済"]){
        cartDict[@"payment"] = @"cod";
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:cartParameters];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"注文内容の取得: %@", JSON);
            NSDictionary *error = JSON[@"error"];
            NSString *errormessage = error[@"message"];
            NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"エラーです%@",errormessage1);
            NSLog(@"Error message: %@", errormessage);
            
            
            NSArray *zipcodeArray = [JSON valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [JSON valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [JSON valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [JSON valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [JSON valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [JSON valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [JSON valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];
                return ;
            }else{
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userInfo = [userDefaults dictionaryForKey:@"userInfo"];
                NSLog(@"住所情報userInfo:%@",userInfo);
                if (!userInfo) {
                    NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
                    
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                    /*
                     if ( ![userDefaults synchronize] ) {
                     NSLog( @"failed ..." );
                     }else{
                     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
                     [self.navigationController pushViewController:vc animated:YES];
                     }
                     */
                }else{
                    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                }
                
                
                
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        NSLog(@"orderItem%@",orderItem);
    }else{
        //銀行決済
        cartDict[@"payment"] = @"bt";
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:cartParameters];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"注文内容の取得: %@", JSON);
            NSDictionary *error = JSON[@"error"];
            NSString *errormessage = [JSON valueForKeyPath:@"error.message"];
            NSString *errormessage2 = [JSON valueForKeyPath:@"result.Cart.0.error"];
            NSArray *errorArray = [JSON valueForKeyPath:@"result.Cart"];
            NSLog(@"エラーの配列%@",errorArray);
            NSLog(@"アイテム数%d",errorArray.count);

            
            NSArray *zipcodeArray = [JSON valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [JSON valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [JSON valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [JSON valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [JSON valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [JSON valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [JSON valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [JSON valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            if (error) {
                NSLog(@"エラーメッセージ%@",errormessage);
                NSLog(@"エラーメッセージ2%@",errormessage2);

                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];

            }else{
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *userInfo = [userDefaults dictionaryForKey:@"userInfo"];
                NSLog(@"住所情報userInfo:%@",userInfo);
                if (!userInfo) {
                    NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
                    
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                    /*
                     if ( ![userDefaults synchronize] ) {
                     NSLog( @"failed ..." );
                     }else{
                     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
                     [self.navigationController pushViewController:vc animated:YES];
                     }
                     */
                }else{
                    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
                    mutableUserInfo[@"last_name"] = lastNameField.text;
                    mutableUserInfo[@"first_name"] = firstNameField.text;
                    mutableUserInfo[@"zip_code"] = postcodeField.text;
                    mutableUserInfo[@"prefecture"] = prefectureLabel.text;
                    mutableUserInfo[@"address"] = addressField.text;
                    mutableUserInfo[@"address2"] = fartherAddressField.text;
                    mutableUserInfo[@"tel"] = telField.text;
                    mutableUserInfo[@"mail_address"] = mailField.text;
                    
                    [userDefaults setObject:mutableUserInfo forKey:@"userInfo"];
                    [userDefaults synchronize];
                }
                
                [SVProgressHUD showSuccessWithStatus:@"完了"];
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        NSLog(@"orderItem%@",orderItem);
    }

}
+(NSDictionary*)getCartItem{
    return importOrderDictionary;
}
+(NSDictionary*)checkCartItem{
    return checkOrderDictionary;
}

//バリデーションチェック
- (BOOL)validationCheck{
    
    BOOL validation;
    NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
    [checkCharSet addCharactersInString:@"1234567890"];
    
    NSMutableCharacterSet *checkZipSet = [[NSMutableCharacterSet alloc] init];
    [checkZipSet addCharactersInString:@"1234567890-"];
    
    if (lastNameField.text == nil || [lastNameField.text isEqualToString:@""]) {
        [lastNameField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"名前(姓)の入力が正しくありません" message:@"名前(姓)を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (firstNameField.text == nil || [firstNameField.text isEqualToString:@""]) {
        [firstNameField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"名前(名)の入力が正しくありません" message:@"名前(名)を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if([[postcodeField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || postcodeField.text == nil || [postcodeField.text isEqualToString:@""]){
        [postcodeField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"郵便番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if (addressField.text == nil || [addressField.text isEqualToString:@""]){
        [addressField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"住所の入力が正しくありません" message:@"住所を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (fartherAddressField.text == nil || [fartherAddressField.text isEqualToString:@""]){
        [fartherAddressField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"その他の住所の入力が正しくありません" message:@"その他の住所のをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if([[telField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || telField.text == nil || [telField.text isEqualToString:@""]){
        [telField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"電話番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if (mailField.text == nil || [mailField.text isEqualToString:@""] || ![self NSStringIsValidEmail:mailField.text]){
        [mailField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"メールアドレスの入力が正しくありません" message:@"メールアドレスを入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else{
        validation = YES;
    }
    
    return validation;
    NSLog(@"バリデーションチェック");
    
}
//メールアドレスのバリデーション
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (void)closeKeyboard:(id)sender{
    [commentTextView resignFirstResponder];
}

- (void)backRoot{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
