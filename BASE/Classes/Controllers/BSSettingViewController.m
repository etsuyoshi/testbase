//
//  BSSettingViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSSettingViewController.h"

@interface BSSettingViewController ()

@end

@implementation BSSettingViewController{
    
    UIImageView *tabView;
    UIView *shopInfoView;
    UIView *termInfoView;
    
    //ショップ情報側の変数;
    
    UIScrollView *scrollView;
    UITableView *shopStatusTable;
    UILabel *shopUrl;
    
    //ショップ説明フォーム
    UITextView *shopDescription;
    //ソーシャルアカウント
    UITableView *socialTable;
    //決済関係
    UITableView *paymentTable;
    
    //公開スイッチ
    UISwitch *openSwitch;
    int visible;
    
    //ソーシャルアカウント入力
    UITextField *facebookField;
    UITextField *twitterField;
    
    
    //配送料
    UISwitch *deliverySwitch;
    BOOL isUsed;
    UILabel *deliverLabel;
    int delivery;
    UITextField *deliveryField;
    
    //数量のピッカー
    UIPickerView *stockPicker;
    UIActionSheet *stockActionSheet;
    BOOL pickerIsOpened;
    int buttonTag;
    
    //保存ボタン
    UILabel *modalSelectLabel1;
    UIButton *modalSaveButton;
    //テキストフィールドにフォーカスした時の座標
    CGPoint svos;
    
    
    //特定商取引法側の変数
    //スクロール
    UIScrollView *scrollView2;
    
    UITextField *lastNameField;
    UITextField *firstNameField;
    UITextField *zipCodeField;
    UITableView *prefectureTable;
    UITextView *addressTextView;
    UITextField *telField;
    UITextView *alterAddressTextView;
    UITextView *priceTextView;
    UITextView *payTextView;
    UITextView *serviceTextView;
    UITextView *returnTextVfiew;
    
    UILabel *prefectureLbl;

    NSArray *prefectureArray;
    
    NSMutableDictionary *presentPaymentParam;
    
    NSString *apiUrl;
    
    //メール認証
    //BOOL authorized;
    BOOL available;
    NSString *unavailableReasonsString;

    
}
static NSDictionary *presentPaymentInfo = nil;

@synthesize importPayment;

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

    [self setShopInfo];
    
    
}


- (void)setShopInfo
{
    NSString *sessionId = [BSUserManager sharedManager].sessionId;
    NSLog(@"セッションid:%@",sessionId);
    NSString *urlString = [NSString stringWithFormat:@"%@/users/get_shop?session_id=%@",apiUrl,sessionId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];

    
    [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
            NSLog(@"ショップ情報！: %@", results);
            NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
            presentPaymentInfo = [shopInfo copy];
            shopUrl.text = shopInfo[@"shop_url"];
            BOOL shopOpened = [shopInfo[@"able_to_business"] intValue];
            available = [shopInfo[@"available"] intValue];
            //NSLog(@"unavailableReasonsString:%@",unavailableReasonsString);
            
            if (shopOpened) {
                openSwitch.on = YES;
                visible = YES;
            }else{
                openSwitch.on = NO;
                visible = NO;
            }
            
            //メール認証
            if (available){
                openSwitch.enabled = YES;
                visible = YES;
            }else{
                unavailableReasonsString = shopInfo[@"unavailable_reasons"][0];
                
                openSwitch.on = NO;
                openSwitch.enabled = NO;
                visible = NO;
            }
            if ([shopInfo[@"delivery"] intValue] == 1) {
                isUsed = YES;
                deliverySwitch.on = YES;
                if (![shopInfo[@"fee"] isEqual:[NSNull null]])
                    deliveryField.text = shopInfo[@"fee"];
                
                if ([BSDefaultViewObject isMoreIos7]) {
                    scrollView.contentSize = CGSizeMake(320, 660);
                    modalSaveButton.frame = CGRectMake( 20, 600, 280, 50);
                }else{
                    scrollView.contentSize = CGSizeMake(320, 630);
                    modalSaveButton.frame = CGRectMake( 20, 560, 280, 50);
                }
                
                modalSelectLabel1.frame = CGRectMake(40,565,240,40);
            }else{
                if ([shopInfo[@"delivery"] intValue] == 0) {
                    isUsed = NO;
                    deliverySwitch.on = NO;
                }else{
                    isUsed = NO;
                    deliverySwitch.on = NO;
                    deliverySwitch.enabled = NO;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"\n"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    
                }
                
                
            }
            if (![shopInfo[@"shop_introduction"] isEqual:[NSNull null]])
                shopDescription.text = shopInfo[@"shop_introduction"];
            if (![shopInfo[@"facebook_id"] isEqual:[NSNull null]])
                facebookField.text = shopInfo[@"facebook_id"];
            if (![shopInfo[@"twitter_id"] isEqual:[NSNull null]])
                twitterField.text = shopInfo[@"twitter_id"];
            
            presentPaymentParam = [NSMutableDictionary dictionary];
            presentPaymentParam[@"bt_payment"] = [results valueForKeyPath:@"result.Shop.bt_payment"];
            presentPaymentParam[@"creditcart_payment"] = [results valueForKeyPath:@"result.Shop.creditcart_payment"];
            presentPaymentParam[@"cod_payment"] = [results valueForKeyPath:@"result.Shop.cod_payment"];
            if ([[results valueForKeyPath:@"result.Shop.cod_payment"] intValue] == 1) {
                presentPaymentParam[@"charge"] = [results valueForKeyPath:@"result.Shop.charge"];
            }
            if ([[results valueForKeyPath:@"result.Shop.cod_payment"] intValue] == 1) {
                presentPaymentParam[@"bank_name"] = [results valueForKeyPath:@"result.Shop.bank_name"];
                presentPaymentParam[@"branch_name"] = [results valueForKeyPath:@"result.Shop.branch_name"];
                presentPaymentParam[@"account_type"] = [results valueForKeyPath:@"result.Shop.account_type"];
                presentPaymentParam[@"account_name"] = [results valueForKeyPath:@"result.Shop.account_name"];
                presentPaymentParam[@"account_number"] = [results valueForKeyPath:@"result.Shop.account_number"];
                
            }
            
            [shopStatusTable reloadData];
            [paymentTable reloadData];
            
        
        [[BSSellerAPIClient sharedClient] getUsersTransactioinWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
            
            
            NSLog(@"特商法情報！: %@", results);
            
            lastNameField.text = [results valueForKeyPath:@"result.Shop.last_name"];
            if ([[results valueForKeyPath:@"result.Shop.last_name"] isEqual:[NSNull null]])
                lastNameField.text = @"";
            NSLog(@"ここまではオケ%@",lastNameField.text);
            
            if ([[results valueForKeyPath:@"result.Shop.first_name"] isEqual:[NSNull null]]){
                firstNameField.text = @"";
            }else{
                firstNameField.text = [results valueForKeyPath:@"result.Shop.first_name"];
            }
            
            
            if ([[results valueForKeyPath:@"result.Shop.zip_code"] isEqual:[NSNull null]]){
                zipCodeField.text = @"";
            }else{
                zipCodeField.text = [results valueForKeyPath:@"result.Shop.zip_code"];
            }
            NSLog(@"ここまではオケzipCodeField.text%@",zipCodeField.text);
            
            if ([[results valueForKeyPath:@"result.Shop.prefecture"] isEqual:[NSNull null]]){
                prefectureLbl.text = @"";
                
            }else{
                prefectureLbl.text = [results valueForKeyPath:@"result.Shop.prefecture"];
                
            }
            NSLog(@"ここまではオケ prefectureLbl.text%@",zipCodeField.text);
            
            if ([[results valueForKeyPath:@"result.Shop.address"] isEqual:[NSNull null]]){
                addressTextView.text = @"住所（建物まで明記）";
                
            }else{
                addressTextView.text = [results valueForKeyPath:@"result.Shop.address"];
                
            }
            NSLog(@"ここまではオケ addressTextView.textt%@",addressTextView.text);
            
            if ([[results valueForKeyPath:@"result.Shop.tel_no"] isEqual:[NSNull null]]){
                telField.text = @"";
                
            }else{
                telField.text = [results valueForKeyPath:@"result.Shop.tel_no"];
                
            }
            NSLog(@"ここまではオケ telField.textt%@",telField.text);
            
            if ([[results valueForKeyPath:@"result.Shop.contact"] isEqual:[NSNull null]]){
                alterAddressTextView.text = @"";
                
            }else{
                alterAddressTextView.text = [results valueForKeyPath:@"result.Shop.contact"];
                
            }
            NSLog(@"ここまではオケalterAddressTextView.texttt%@",alterAddressTextView.text);
            
            if ([[results valueForKeyPath:@"result.Shop.price"] isEqual:[NSNull null]]){
                priceTextView.text = @"";
                
            }else{
                priceTextView.text = [results valueForKeyPath:@"result.Shop.price"];
                
            }
            NSLog(@"ここまではオケapriceTextView.text.texttt%@",priceTextView.text);
            
            if ([[results valueForKeyPath:@"result.Shop.pay"] isEqual:[NSNull null]]){
                payTextView.text = @"";
                
            }else{
                payTextView.text = [results valueForKeyPath:@"result.Shop.pay"];
                
            }
            
            if ([[results valueForKeyPath:@"result.Shop.service"] isEqual:[NSNull null]]){
                serviceTextView.text = @"";
                
            }else{
                serviceTextView.text = [results valueForKeyPath:@"result.Shop.service"];
            }
            if ([[results valueForKeyPath:@"result.Shop.return"] isEqual:[NSNull null]]){
                returnTextVfiew.text = @"";
                
            }else{
                returnTextVfiew.text = [results valueForKeyPath:@"result.Shop.return"];
                
            }
            
        }];
        
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //グーグルアナリティクス
    self.screenName = @"shopSetting";
    
    self.title = @"ショップ設定";
    apiUrl = [BSDefaultViewObject setApiUrl];
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
    self.navigationController.navigationBar.tag = 100;
    [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];
    /*
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ショップ設定"];
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
    label.text = @"ショップ設定";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
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
    
    
    
    //タブテキスト
    UILabel *shopInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,150,24)];
    shopInfoLabel.text = @"ショップ情報";
    shopInfoLabel.textAlignment = NSTextAlignmentCenter;
    shopInfoLabel.font = [UIFont boldSystemFontOfSize:14];
    shopInfoLabel.backgroundColor = [UIColor clearColor];
    shopInfoLabel.textColor = [UIColor darkGrayColor];
    [tabView addSubview:shopInfoLabel];
    
    //タブテキスト
    UILabel *termInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(160,10,150,24)];
    termInfoLabel.text = @"特定商取引法に関する表記";
    termInfoLabel.textAlignment = NSTextAlignmentCenter;
    termInfoLabel.font = [UIFont boldSystemFontOfSize:11];
    termInfoLabel.backgroundColor = [UIColor clearColor];
    termInfoLabel.textColor = [UIColor darkGrayColor];
    [tabView addSubview:termInfoLabel];

    
    
    
    //タブ画面１
    shopInfoView = [[UIView alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        shopInfoView.frame = CGRectMake(0,88,320,self.view.bounds.size.height - 44);
    }else{
        shopInfoView.frame = CGRectMake(0,44,320,self.view.bounds.size.height - 44);

    }
    shopInfoView.backgroundColor = [UIColor clearColor];
    shopInfoView.clipsToBounds = NO;
    shopInfoView.hidden = NO;
    [self.view insertSubview:shopInfoView belowSubview:tabView];
    
    //タブ画面2
    termInfoView = [[UIView alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        termInfoView.frame = CGRectMake(0,88,320,self.view.bounds.size.height - 44);
    }else{
        termInfoView.frame = CGRectMake(0,44,320,self.view.bounds.size.height - 44);
        
    }
    termInfoView.backgroundColor = [UIColor clearColor];
    termInfoView.clipsToBounds = NO;
    termInfoView.hidden = YES;
    [self.view insertSubview:termInfoView belowSubview:tabView];
    
    
    
    //タブ画面１のビュー
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //スクロール
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20,320,self.view.frame.size.height - 108)];
        scrollView.contentSize = CGSizeMake(320, 630);
        scrollView.scrollsToTop = YES;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        [shopInfoView addSubview:scrollView];
        
        shopStatusTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) style:UITableViewStyleGrouped];
        shopStatusTable.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }else{
        //スクロール
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 88)];
        scrollView.contentSize = CGSizeMake(320, 600);
        scrollView.scrollsToTop = YES;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        [shopInfoView addSubview:scrollView];
        shopStatusTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) style:UITableViewStyleGrouped];
    }
    
    shopStatusTable.dataSource = self;
    shopStatusTable.delegate = self;
    shopStatusTable.tag = 1;
    shopStatusTable.backgroundView = nil;
    shopStatusTable.scrollEnabled = NO;
    shopStatusTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:shopStatusTable];
    
    shopUrl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,170,22)];
    shopUrl.center = CGPointMake(220, 22);
    shopUrl.textColor = [UIColor grayColor];
    shopUrl.backgroundColor = [UIColor clearColor];
    shopUrl.font = [UIFont boldSystemFontOfSize:11];
    shopUrl.textAlignment = NSTextAlignmentRight;
    shopUrl.numberOfLines = 1;
    
    
    shopDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, 115, 300, 120)];
    shopDescription.text = @"ショップ説明";
    shopDescription.textColor = [UIColor blackColor];
    shopDescription.layer.borderWidth = 1.0;
    shopDescription.layer.cornerRadius = 8.0;
    [shopDescription.layer setMasksToBounds:YES];
    shopDescription.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    shopDescription.textColor = [UIColor lightGrayColor];
    [shopDescription setFont:[UIFont systemFontOfSize:17]];
    shopDescription.clipsToBounds = YES;
    shopDescription.backgroundColor = [UIColor clearColor];
    shopDescription.delegate = self;
    [scrollView addSubview:shopDescription];
    
    
    socialTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, 320, 120) style:UITableViewStyleGrouped];
    socialTable.dataSource = self;
    socialTable.delegate = self;
    socialTable.tag = 1;
    socialTable.backgroundView = nil;
    socialTable.scrollEnabled = NO;
    socialTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:socialTable];
    
    if ([BSDefaultViewObject isMoreIos7]) {
       paymentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 385, 320, 220) style:UITableViewStyleGrouped];
    }else{
        paymentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 385, 320, 170) style:UITableViewStyleGrouped];
    }
    
    paymentTable.dataSource = self;
    paymentTable.delegate = self;
    paymentTable.tag = 1;
    paymentTable.backgroundView = nil;
    paymentTable.scrollEnabled = NO;
    paymentTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:paymentTable];
    
    
    UIImage *saveImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        //保存ボタン
        saveImage = [UIImage imageNamed:@"btn_7_01"];
        
        modalSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        modalSaveButton.frame = CGRectMake( 20, 560, 280, 50);
        modalSaveButton.tag = 1;
        [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [modalSaveButton addTarget:self action:@selector(saveShopInfo:)forControlEvents:UIControlEventTouchUpInside];
        [modalSaveButton setTitle:@"保存する" forState:UIControlStateNormal];
        [scrollView addSubview:modalSaveButton];
        
    }else{
        //保存ボタン
        saveImage = [UIImage imageNamed:@"btn_01"];
        
        modalSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        modalSaveButton.frame = CGRectMake( 20, 530, 280, 50);
        modalSaveButton.tag = 1;
        [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [modalSaveButton addTarget:self action:@selector(saveShopInfo:)forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:modalSaveButton];
        
        //ボタンテキスト
        modalSelectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40,535,240,40)];
        modalSelectLabel1.text = @"保存する";
        modalSelectLabel1.textAlignment = NSTextAlignmentCenter;
        modalSelectLabel1.font = [UIFont boldSystemFontOfSize:20];
        modalSelectLabel1.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        modalSelectLabel1.shadowOffset = CGSizeMake(0.f, -1.f);
        modalSelectLabel1.backgroundColor = [UIColor clearColor];
        modalSelectLabel1.textColor = [UIColor whiteColor];
        [scrollView addSubview:modalSelectLabel1];
    }
    
    
    
    //公開ボタン（スイッチ)
    openSwitch = [[UISwitch alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        openSwitch.center = CGPointMake(255, 76);
    }else{
        openSwitch.center = CGPointMake(255, 76);
        
    }
    openSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    openSwitch.on = NO;
    openSwitch.tag = 1;
    [openSwitch addTarget:self action:@selector(switchcontroll:)
         forControlEvents:UIControlEventValueChanged];
    //[scrollView addSubview:openSwitch];
    visible = 1;
    
    //Facebook
    facebookField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    facebookField.borderStyle = UITextBorderStyleNone;
    facebookField.textColor = [UIColor blackColor];
    facebookField.placeholder = @"https://facebook.com/○○○";
    facebookField.font = [UIFont systemFontOfSize:16];
    /*
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    facebookField.leftView = paddingView;
    facebookField.leftViewMode = UITextFieldViewModeAlways;
     */
    facebookField.tag = 1;
    facebookField.clearButtonMode = UITextFieldViewModeNever;
    facebookField.textAlignment = NSTextAlignmentRight;
    facebookField.returnKeyType = UIReturnKeyDone;
    facebookField.delegate = self;
    [facebookField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    facebookField.backgroundColor = [UIColor clearColor];
    [facebookField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
   
    //twitter
    twitterField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    twitterField.borderStyle = UITextBorderStyleNone;
    twitterField.textColor = [UIColor blackColor];
    twitterField.placeholder = @"https://twitter.com/○○○";
    twitterField.font = [UIFont systemFontOfSize:16];
    /*
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
     facebookField.leftView = paddingView;
     facebookField.leftViewMode = UITextFieldViewModeAlways;
     */
    twitterField.tag = 1;
    twitterField.clearButtonMode = UITextFieldViewModeNever;
    twitterField.textAlignment = NSTextAlignmentRight;
    twitterField.returnKeyType = UIReturnKeyDone;
    twitterField.delegate = self;
    [twitterField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    twitterField.backgroundColor = [UIColor clearColor];
    [twitterField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    
    //送料利用ボタン（スイッチ)
    deliverySwitch = [[UISwitch alloc] init];
    if ([BSDefaultViewObject isMoreIos7]) {
        deliverySwitch.center = CGPointMake(255, 420);
    }else{
        deliverySwitch.center = CGPointMake(255, 420);

    }
    deliverySwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    deliverySwitch.on = NO;
    deliverySwitch.tag = 2;
    [deliverySwitch addTarget:self action:@selector(switchcontroll:)
             forControlEvents:UIControlEventValueChanged];
    //[scrollView addSubview:deliverySwitch];
    
    //配送料
    deliveryField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 250, 44)];
    deliveryField.borderStyle = UITextBorderStyleNone;
    deliveryField.textColor = [UIColor blackColor];
    deliveryField.placeholder = @"(0~50000円まで)";
    deliveryField.keyboardType = UIKeyboardTypeNumberPad;
    deliveryField.font = [UIFont systemFontOfSize:16];
    /*
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
     facebookField.leftView = paddingView;
     facebookField.leftViewMode = UITextFieldViewModeAlways;
     */
    deliveryField.tag = 1;
    deliveryField.clearButtonMode = UITextFieldViewModeNever;
    deliveryField.textAlignment = NSTextAlignmentRight;
    deliveryField.returnKeyType = UIReturnKeyDone;
    deliveryField.delegate = self;
    [deliveryField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    deliveryField.backgroundColor = [UIColor clearColor];
    [deliveryField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    /*
    //配送料
    deliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(250,8,100,30)];
    deliverLabel.text = @"0円";
    deliverLabel.textAlignment = NSTextAlignmentLeft;
    deliverLabel.font = [UIFont systemFontOfSize:16];
    deliverLabel.shadowColor = [UIColor whiteColor];
    deliverLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    deliverLabel.backgroundColor = [UIColor clearColor];
    deliverLabel.textColor = [UIColor blackColor];
    */
    
    
    
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
    shopDescription.inputAccessoryView = toolBar;
    //ツールのボタンの文字色変更
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [done setTitleTextAttributes:attribute forState:UIControlStateNormal];
    deliveryField.inputAccessoryView = toolBar;
    
    
    //ここまでタブ画面1のビュー
    
    //タブ画面2
    
    
    //スクロール
    scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 88)];
    scrollView2.contentSize = CGSizeMake(320, 1340);
    scrollView2.scrollsToTop = YES;
    scrollView2.backgroundColor = [UIColor clearColor];
    scrollView2.delegate = self;
    [termInfoView addSubview:scrollView2];
    
    
    
    //事業者ラベル
    UILabel *personName = [[UILabel alloc] initWithFrame:CGRectMake(12,26,240,22)];
    personName.text = @"事業者の名前";
    personName.textAlignment = NSTextAlignmentLeft;
    personName.font = [UIFont boldSystemFontOfSize:18];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:personName];
    //名前フォーム（姓）
    lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 140, 40)];
    lastNameField.borderStyle = UITextBorderStyleNone;
    lastNameField.textColor = [UIColor blackColor];
    lastNameField.placeholder = @"姓";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    lastNameField.leftView = paddingView;
    lastNameField.leftViewMode = UITextFieldViewModeAlways;
    lastNameField.layer.borderWidth = 1.0;
    lastNameField.layer.cornerRadius = 8.0;
    lastNameField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    lastNameField.tag = 5;
    lastNameField.returnKeyType = UIReturnKeyDone;
    lastNameField.clearButtonMode = UITextFieldViewModeAlways;
    lastNameField.delegate = self;
    [lastNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    lastNameField.backgroundColor = [UIColor clearColor];
    [lastNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView2 addSubview:lastNameField];
    
    
    //名前フォーム（名）
    firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(170, 60, 140, 40)];
    firstNameField.borderStyle = UITextBorderStyleNone;
    firstNameField.textColor = [UIColor blackColor];
    firstNameField.placeholder = @"名";
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    firstNameField.leftView = paddingView2;
    firstNameField.leftViewMode = UITextFieldViewModeAlways;
    firstNameField.layer.borderWidth = 1.0;
    firstNameField.layer.cornerRadius = 8.0;
    firstNameField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    firstNameField.tag = 6;
    firstNameField.returnKeyType = UIReturnKeyDone;
    firstNameField.clearButtonMode = UITextFieldViewModeAlways;
    firstNameField.delegate = self;
    [firstNameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    firstNameField.backgroundColor = [UIColor clearColor];
    [firstNameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView2 addSubview:firstNameField];
    
    
    //郵便番号フォーム
    zipCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 115, 300, 40)];
    zipCodeField.borderStyle = UITextBorderStyleNone;
    zipCodeField.textColor = [UIColor blackColor];
    zipCodeField.placeholder = @"郵便番号";
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    zipCodeField.leftView = paddingView3;
    zipCodeField.leftViewMode = UITextFieldViewModeAlways;
    zipCodeField.layer.borderWidth = 1.0;
    zipCodeField.layer.cornerRadius = 8.0;
    zipCodeField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    zipCodeField.tag = 7;
    zipCodeField.returnKeyType = UIReturnKeyDone;
    zipCodeField.clearButtonMode = UITextFieldViewModeAlways;
    zipCodeField.delegate = self;
    [zipCodeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    zipCodeField.backgroundColor = [UIColor clearColor];
    [zipCodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView2 addSubview:zipCodeField];
    
    //住所テーブル
    prefectureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 320, 56) style:UITableViewStyleGrouped];
    prefectureTable.dataSource = self;
    prefectureTable.delegate = self;
    prefectureTable.tag = 1;
    prefectureTable.backgroundView = nil;
    prefectureTable.scrollEnabled = NO;
    prefectureTable.backgroundColor = [UIColor clearColor];
    if ([BSDefaultViewObject isMoreIos7]) {
        prefectureTable.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
    }
    [scrollView2 addSubview:prefectureTable];
    
    //県名ラベル
    prefectureLbl = [[UILabel alloc] initWithFrame:CGRectMake(140,0,140,44)];
    prefectureLbl.text = @"東京都";
    prefectureLbl.backgroundColor = [UIColor clearColor];
    prefectureLbl.textAlignment = NSTextAlignmentRight;
    prefectureLbl.font = [UIFont boldSystemFontOfSize:17];
    prefectureLbl.textColor = [UIColor darkGrayColor];
    
    
    //住所その他
    addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 230, 300, 120)];
    addressTextView.text = @"住所（建物まで明記）";
    addressTextView.textColor = [UIColor blackColor];
    addressTextView.layer.borderWidth = 1.0;
    addressTextView.layer.cornerRadius = 8.0;
    [addressTextView.layer setMasksToBounds:YES];
    addressTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    addressTextView.textColor = [UIColor lightGrayColor];
    [addressTextView setFont:[UIFont systemFontOfSize:17]];
    addressTextView.clipsToBounds = YES;
    addressTextView.backgroundColor = [UIColor clearColor];
    addressTextView.delegate = self;
    addressTextView.inputAccessoryView = toolBar;
    [scrollView2 addSubview:addressTextView];
    

    //事業者の連絡先ラベル
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,360,240,22)];
    addressLbl.text = @"事業者の連絡先（電話番号）";
    addressLbl.textAlignment = NSTextAlignmentLeft;
    addressLbl.font = [UIFont boldSystemFontOfSize:17];
    addressLbl.backgroundColor = [UIColor clearColor];
    addressLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:addressLbl];
    
    //事業者の連絡先（電話番号）
    telField = [[UITextField alloc] initWithFrame:CGRectMake(10, 385, 300, 40)];
    telField.borderStyle = UITextBorderStyleNone;
    telField.textColor = [UIColor blackColor];
    telField.placeholder = @"0123-456-789";
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    telField.leftView = paddingView4;
    telField.leftViewMode = UITextFieldViewModeAlways;
    telField.layer.borderWidth = 1.0;
    telField.layer.cornerRadius = 8.0;
    telField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    telField.tag = 6;
    telField.returnKeyType = UIReturnKeyDone;
    telField.clearButtonMode = UITextFieldViewModeAlways;
    telField.delegate = self;
    [telField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    telField.backgroundColor = [UIColor clearColor];
    [telField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView2 addSubview:telField];
    
    
    
    //事業者の連絡先ラベル
    UILabel *alterAddressLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,435,240,22)];
    alterAddressLbl.text = @"事業者の連絡先";
    alterAddressLbl.textAlignment = NSTextAlignmentLeft;
    alterAddressLbl.font = [UIFont boldSystemFontOfSize:17];
    alterAddressLbl.backgroundColor = [UIColor clearColor];
    alterAddressLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:alterAddressLbl];
    //事業者連絡先（その他）
    alterAddressTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 460, 300, 120)];
    alterAddressTextView.text = @"連絡先：営業時間：";
    alterAddressTextView.textColor = [UIColor blackColor];
    alterAddressTextView.layer.borderWidth = 1.0;
    alterAddressTextView.layer.cornerRadius = 8.0;
    [alterAddressTextView.layer setMasksToBounds:YES];
    alterAddressTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    alterAddressTextView.textColor = [UIColor lightGrayColor];
    [alterAddressTextView setFont:[UIFont systemFontOfSize:17]];
    alterAddressTextView.clipsToBounds = YES;
    alterAddressTextView.backgroundColor = [UIColor clearColor];
    alterAddressTextView.delegate = self;
    alterAddressTextView.inputAccessoryView = toolBar;
    [scrollView2 addSubview:alterAddressTextView];
    
    
    
    //事業者の連絡先ラベル
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,590,240,22)];
    priceLbl.text = @"販売価格について";
    priceLbl.textAlignment = NSTextAlignmentLeft;
    priceLbl.font = [UIFont boldSystemFontOfSize:17];
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:priceLbl];
    //販売価格について
    priceTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 615, 300, 120)];
    priceTextView.text = @"販売価格は、表示された金額（表示価格/消費税込）と致します";
    priceTextView.textColor = [UIColor blackColor];
    priceTextView.layer.borderWidth = 1.0;
    priceTextView.layer.cornerRadius = 8.0;
    [priceTextView.layer setMasksToBounds:YES];
    priceTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    priceTextView.textColor = [UIColor lightGrayColor];
    [priceTextView setFont:[UIFont systemFontOfSize:17]];
    priceTextView.clipsToBounds = YES;
    priceTextView.backgroundColor = [UIColor clearColor];
    priceTextView.delegate = self;
    priceTextView.inputAccessoryView = toolBar;
    [scrollView2 addSubview:priceTextView];
    
    
    
    //事業者の連絡先ラベル
    UILabel *payLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,745,240,22)];
    payLbl.text = @"代金（対価）の支払方法と時期";
    payLbl.textAlignment = NSTextAlignmentLeft;
    payLbl.font = [UIFont boldSystemFontOfSize:17];
    payLbl.backgroundColor = [UIColor clearColor];
    payLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:payLbl];
    
    //代価（対価）の支払方法と時期
    payTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 770, 300, 120)];
    payTextView.text = @"支払方法：クレジットカードによる決済がご利用頂けます。支払時期：商品注文確定時でお支払いが確定致します。";
    payTextView.layer.borderWidth = 1.0;
    payTextView.layer.cornerRadius = 8.0;
    [payTextView.layer setMasksToBounds:YES];
    payTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    payTextView.textColor = [UIColor lightGrayColor];
    [payTextView setFont:[UIFont systemFontOfSize:17]];
    payTextView.clipsToBounds = YES;
    payTextView.backgroundColor = [UIColor clearColor];
    payTextView.delegate = self;
    payTextView.inputAccessoryView = toolBar;
    [scrollView2 addSubview:payTextView];
    
    
    //事業者の連絡先ラベル
    UILabel *serviceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,900,240,22)];
    serviceLbl.text = @"役務または商品の引渡時期";
    serviceLbl.textAlignment = NSTextAlignmentLeft;
    serviceLbl.font = [UIFont boldSystemFontOfSize:17];
    serviceLbl.backgroundColor = [UIColor clearColor];
    serviceLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:serviceLbl];
    //役務または商品の引渡時期
    serviceTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 925, 300, 120)];
    serviceTextView.text = @"配送のご依頼を受けてから5日以内に発送いたします。";
    serviceTextView.layer.borderWidth = 1.0;
    serviceTextView.layer.cornerRadius = 8.0;
    [serviceTextView.layer setMasksToBounds:YES];
    serviceTextView.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    serviceTextView.textColor = [UIColor lightGrayColor];
    [serviceTextView setFont:[UIFont systemFontOfSize:17]];
    serviceTextView.clipsToBounds = YES;
    serviceTextView.backgroundColor = [UIColor clearColor];
    serviceTextView.delegate = self;
    serviceTextView.inputAccessoryView = toolBar;
    [scrollView2 addSubview:serviceTextView];
    
    
    //事業者の連絡先ラベル
    UILabel *returnLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,1055,300,22)];
    returnLbl.text = @"役務返品についての特約に関する事項";
    returnLbl.textAlignment = NSTextAlignmentLeft;
    returnLbl.font = [UIFont boldSystemFontOfSize:15];
    returnLbl.backgroundColor = [UIColor clearColor];
    returnLbl.textColor = [UIColor darkGrayColor];
    [scrollView2 addSubview:returnLbl];
    //返品についての特約に関する条項
    returnTextVfiew = [[UITextView alloc] initWithFrame:CGRectMake(10, 1080, 300, 120)];
    returnTextVfiew.text = @"配送のご依頼を受けてから5日以内に発送いたします。";
    returnTextVfiew.layer.borderWidth = 1.0;
    returnTextVfiew.layer.cornerRadius = 8.0;
    [returnTextVfiew.layer setMasksToBounds:YES];
    returnTextVfiew.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    returnTextVfiew.textColor = [UIColor lightGrayColor];
    [returnTextVfiew setFont:[UIFont systemFontOfSize:17]];
    returnTextVfiew.clipsToBounds = YES;
    returnTextVfiew.backgroundColor = [UIColor clearColor];
    returnTextVfiew.delegate = self;
    returnTextVfiew.inputAccessoryView = toolBar;

    [scrollView2 addSubview:returnTextVfiew];
    
    //保存ボタン
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake( 20, 1240, 280, 50);
    saveButton.tag = 2;
    [saveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveShopInfo:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView2 addSubview:saveButton];
    
    //ボタンテキスト
    UILabel *saveLbl = [[UILabel alloc] initWithFrame:CGRectMake(40,1245,240,40)];
    saveLbl.text = @"保存する";
    saveLbl.textAlignment = NSTextAlignmentCenter;
    saveLbl.font = [UIFont boldSystemFontOfSize:20];
    saveLbl.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    saveLbl.shadowOffset = CGSizeMake(0.f, -1.f);
    saveLbl.backgroundColor = [UIColor clearColor];
    saveLbl.textColor = [UIColor whiteColor];
    [scrollView2 addSubview:saveLbl];
    
    
    //完了ボタン
    
}



- (void)changeTab:(id)sender{
    if ([sender tag] == 1) {
        UIImage *image = [UIImage imageNamed:@"tab_setting1"];
        [tabView setImage:image];
        shopInfoView.hidden = NO;
        termInfoView.hidden = YES;
    }else{
        UIImage *image = [UIImage imageNamed:@"tab_setting2"];
        [tabView setImage:image];
        shopInfoView.hidden = YES;
        termInfoView.hidden = NO;
    }
}



/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections;
    sections = 1;
    if (tableView == paymentTable) sections = 2;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if (tableView == shopStatusTable || tableView == socialTable) {
        rows = 2;
    }else if(tableView == paymentTable && isUsed && section == 0){
        return 2;
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
    if (tableView == socialTable) height = 30;
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
    if (tableView == socialTable) {
    
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 22)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = [UIColor grayColor];
    
    
    switch (section) {
        case 0:
            sectionLabel.text = @"ソーシャルアカウント連携";
            break;
        case 1:
            sectionLabel.text = @"サポート";
            break;
        default:
            break;
    }
    sectionLabel.font = [UIFont systemFontOfSize:18];
    [sectionHeaderView addSubview:sectionLabel];
        return sectionHeaderView;
    }
    
    return NO;
}




//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier;
    if (tableView == shopStatusTable) {
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"shopUrl",@"shopStatus"];
            CellIdentifier = contentArray[[indexPath row]];
        }else{
            
        }
    }else if (tableView == socialTable){
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"facebook",@"twitter"];
            CellIdentifier = contentArray[[indexPath row]];
        }else{
            
        }
    }else if (tableView == paymentTable){
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"delivery",@"price"];
            CellIdentifier = contentArray[[indexPath row]];
        }else{
            CellIdentifier = @"payment";
        }
    }else{
        CellIdentifier = @"else";
    }
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }

    if (tableView == shopStatusTable) {
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"ショップURL",@"ショップ公開状況"];
            cell.textLabel.text = contentArray[[indexPath row]];
            if (indexPath.row == 0) {
                [cell addSubview:shopUrl];
            }else{
                openSwitch.center = CGPointMake(openSwitch.center.x, cell.frame.size.height / 2);
               
                [cell addSubview:openSwitch];

            }
        }else{
            
        }
    }else if (tableView == socialTable){
        if (indexPath.section == 0) {
            NSArray *contentArray = @[@"facebook",@"twitter"];
            CellIdentifier = contentArray[[indexPath row]];
            if (indexPath.row == 0) {
                //ソーシャルボタン
                /*
                UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
                socialButton.frame = CGRectMake( 50, 0, 250, 44);
                socialButton.tag = 1;
                socialButton.backgroundColor = [UIColor redColor];
                [socialButton addTarget:self action:@selector(inputForm:)forControlEvents:UIControlEventTouchUpInside];
                 */
                //[cell addSubview:facebookUrl];
                //[cell addSubview:facebookFieldUnder];
                [cell addSubview:facebookField];
                
                UIImage *image = [UIImage imageNamed:@"set_facebook"];
                cell.imageView.image = image;
            }else{
                //ソーシャルボタン
                [cell addSubview:twitterField];
                UIImage *image = [UIImage imageNamed:@"set_twitter"];
                cell.imageView.image = image;
            }
        }else{
        }
    }else if (tableView == paymentTable){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"送料を設定する";
                [cell addSubview:deliverLabel];
                deliverySwitch.center = CGPointMake(deliverySwitch.center.x, cell.frame.size.height / 2);
                [cell addSubview:deliverySwitch];

            }else{
                cell.textLabel.text = @"送料";
                [cell addSubview:deliveryField];
            }
        }else{
            cell.textLabel.text = @"決済方法";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (tableView == prefectureTable){
        cell.textLabel.text = @"都道府県名";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:prefectureLbl];
    }
    
    
    
    return cell;
}



//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == paymentTable && indexPath.section == 1) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"setPayment"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == prefectureTable){
        [self selectNumber];
    }
    
    //メール認証
    if (tableView == shopStatusTable && indexPath.row == 1 && !available) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"公開に出来ません"
                                                        message:unavailableReasonsString
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
}






- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}



//公開ボタンスイッチ
- (IBAction)switchcontroll:(id)sender
{
    
    UISwitch *switch1 = sender;
    if ([sender tag] == 1) {
        NSLog(@"%@",switch1);
        if (switch1.on == NO) {
            visible = 0;
            NSLog(@"おふです");
        }else if(switch1.on == YES){
            visible = 1;
            NSLog(@"おんです");
        }
    }else{
        NSLog(@"%@",switch1);
        if (switch1.on == NO) {
            isUsed = NO;
            NSIndexPath* path1 = [NSIndexPath indexPathForRow:1 inSection:0];
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentSize = CGSizeMake(320, 600);
                if ([BSDefaultViewObject isMoreIos7]) {
                    scrollView.contentSize = CGSizeMake(320, 630);
                    modalSaveButton.frame = CGRectMake( 20, 560, 280, 50);
                }else{
                    modalSaveButton.frame = CGRectMake( 20, 530, 280, 50);
                }
                modalSelectLabel1.frame = CGRectMake(40,535,240,40);
            } completion:^(BOOL finished) {
            }];
            [paymentTable beginUpdates];
            [paymentTable deleteRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationTop];
            [paymentTable endUpdates];
        }else if(switch1.on == YES){
            NSLog(@"おんです");
            isUsed = YES;
            [UIView animateWithDuration:0.2 animations:^{
                scrollView.contentSize = CGSizeMake(320, 630);
                
                if ([BSDefaultViewObject isMoreIos7]) {
                    scrollView.contentSize = CGSizeMake(320, 660);
                    modalSaveButton.frame = CGRectMake( 20, 600, 280, 50);
                }else{
                    modalSaveButton.frame = CGRectMake( 20, 560, 280, 50);

                }
                
                modalSelectLabel1.frame = CGRectMake(40,565,240,40);
            } completion:^(BOOL finished) {
            }];
            NSIndexPath* path1 = [NSIndexPath indexPathForRow:1 inSection:0];
            [paymentTable beginUpdates];
            [paymentTable insertRowsAtIndexPaths:@[path1] withRowAnimation:UITableViewRowAnimationBottom];
            [paymentTable endUpdates];
        }
    }
    
}


//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 47;
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    prefectureArray = @[@"北海道", @"青森県", @"岩手県",@"宮城県", @"秋田県", @"山形県",@"福島県", @"茨城県", @"栃木県",@"群馬県", @"埼玉県", @"千葉県",@"東京都", @"神奈川県", @"新潟県",@"富山県", @"石川県", @"福井県",@"山梨県", @"長野県", @"岐阜県",@"静岡県", @"愛知県", @"三重県",@"滋賀県", @"京都府", @"大阪府",@"兵庫県", @"奈良県", @"和歌山県",@"鳥取県", @"島根県", @"岡山県",@"広島県", @"山口県", @"徳島県",@"香川県", @"愛媛県", @"高知県",@"福岡県", @"佐賀県", @"長崎県",@"熊本県", @"大分県", @"宮崎県",@"鹿児島県", @"沖縄県"];

    return prefectureArray[row];
}

//キーボードを閉じる
- (void)allKeyboardClose{
    [facebookField resignFirstResponder];
    [twitterField resignFirstResponder];
    [shopDescription resignFirstResponder];
    
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
    prefectureLbl.text = prefectureArray[[stockPicker selectedRowInComponent:0]];
    
}

//商品説明のキーボードの完了ボタン
-(void)closeKeyboard:(id)sender{
    
    [deliveryField resignFirstResponder];
    for (UIView *subview in [scrollView subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [subview resignFirstResponder];
        }else if ([subview isKindOfClass:[UITextView class]]){
            [subview resignFirstResponder];
        }
    }
    
    UITableViewCell *cell = [paymentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    for (UIView *subview in [cell subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [subview resignFirstResponder];
        }else if ([subview isKindOfClass:[UITextView class]]){
            [subview resignFirstResponder];
        }
    }
    
    
    for (UIView *subview in [scrollView2 subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [subview resignFirstResponder];
        }else if ([subview isKindOfClass:[UITextView class]]){
            [subview resignFirstResponder];
        }
    }
}

//テキストフィールドとテキストビューの設定
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return NO;
}
- (BOOL) textViewShouldBeginEditing: (UITextView*) textView {
    NSLog(@"%@",textView.text);
    NSString *str1 = textView.text;
    NSString *str2;
    if (textView == shopDescription) {
        str2 = @"ショップ説明";
    }else if (textView == addressTextView){
        str2 = @"住所（建物まで明記）";
    }
    if([str1 isEqualToString:str2]){
        NSLog(@"からにするよ");
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (BOOL) textViewShouldEndEditing: (UITextView*) textView {
    if([textView.text isEqual:[NSNull null]] || textView.text.length == 0){
        if (textView == shopDescription) {
            textView.textColor = [UIColor lightGrayColor];
            textView.text = @"ショップ説明";
        }else if (textView == addressTextView){
            textView.textColor = [UIColor lightGrayColor];
            textView.text = @"住所（建物まで明記）";
        }
    }
    return YES;
}
//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == firstNameField && textField == lastNameField) return;
    svos = scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];
    [scrollView2 setContentOffset:pt animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    svos = scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;

    [scrollView setContentOffset:pt animated:YES];
    [scrollView2 setContentOffset:pt animated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == firstNameField && textField == lastNameField) return;
    svos = scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y = 130;
    [scrollView setContentOffset:pt animated:YES];
    [scrollView2 setContentOffset:pt animated:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    return YES; //これをNOにすると、キーボードが消えません
}





//保存ボタン
-(void)saveShopInfo:(id)sender{
    if ([sender tag] == 2) {
        [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];
        
        
        [[BSSellerAPIClient sharedClient] getUsersEditTransactionWithSessionId:[BSUserManager sharedManager].sessionId userType:0 corporateName:Nil lastName:lastNameField.text firstName:firstNameField.text zipCode:zipCodeField.text prefecture:prefectureLbl.text address:addressTextView.text telNo:telField.text contact:alterAddressTextView.text price:priceTextView.text pay:payTextView.text service:serviceTextView.text returnDescription:returnTextVfiew.text completion:^(NSDictionary *results, NSError *error) {
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"エラー"];
            }
            
            NSLog(@"getUsersEditTransactionWithSessionId: %@", results);
            NSArray *telArray = [results valueForKeyPath:@"error.validations.User.tel_no"];
            if (telArray.count) {
                NSString *tel = telArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                
                return ;
            }
            NSArray *zipcodeArray = [results valueForKeyPath:@"error.validations.User.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                
                return ;
            }
            
            NSDictionary *errorMessage = results[@"error"];
            if (errorMessage) {
                [SVProgressHUD showErrorWithStatus:@"入力に問題があります"];
                
            }else{
                [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
                [self setShopInfo];
            }
            
            
            
            
        }];
    }else{
        [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];

        
        
                /*
        NSDictionary *importPayment2 = [BSSettingPaymentViewController getPaymentInfo];
        NSLog(@"決済パラメータ%@",importPayment2);
         */
        
        NSString *sessionId = [BSUserManager sharedManager].sessionId;
        NSLog(@"セッションid:%@",sessionId);
        NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/users/edit_shop?session_id=%@&twitter_id=%@&facebook_id=%@",apiUrl,sessionId,twitterField.text,facebookField.text];
        NSLog(@"おせてます%@",urlString);
        
        
        
        NSString *shopStatus = [NSString string];
        if (visible) {
            shopStatus = @"1";
        }else{
            shopStatus = @"0";
        }
        

        
        
        int deliveryEnable;
        int fee;
        if (isUsed) {
            deliveryEnable = 1;
            fee = [deliveryField.text intValue];
        }else{
            deliveryEnable = 0;
            fee = 0;
        }
        NSString *descriptionParam = @"";
        if (![shopDescription.text isEqualToString:@"ショップ説明"]) {
            descriptionParam = [NSString stringWithFormat:@"&shop_introduction=%@",shopDescription.text];
            descriptionParam = [descriptionParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        
        [[BSSellerAPIClient sharedClient] getUsersEditShopWithSessionId:[BSUserManager sharedManager].sessionId ableToBusiness:[shopStatus intValue] shopIntroduction:shopDescription.text twitterId:twitterField.text facebookId:facebookField.text delivery:deliveryEnable fee:fee completion:^(NSDictionary *results, NSError *error) {
            
            
            NSLog(@"getUsersEditShopWithSessionId: %@", results);
            NSArray *deliveryFeeArray = [results valueForKeyPath:@"error.validations.User.Delivery"];
            if (deliveryFeeArray.count) {
                NSDictionary *deliveryFeeDict = deliveryFeeArray[0];
                NSArray *feeArray = [deliveryFeeDict valueForKeyPath:@"DeliveryFee"];
                
                if (feeArray.count) {
                    NSDictionary *feeDict = feeArray[0];
                    NSArray *fee = [feeDict valueForKeyPath:@"fee"];
                    
                    if (fee.count) {
                        NSString *feeError = fee[0];
                        
                        
                        [SVProgressHUD showErrorWithStatus:feeError];
                        
                        return ;
                    }
                    
                }
                
            }
            
            
            [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
                
                NSLog(@"ショップ情報！: %@", results);
                NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
                presentPaymentInfo = [shopInfo copy];
                
            }];
            
            
            [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
            
            
        }];

        
        
    }
}




- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


/*
+(NSDictionary*)getPresentPaymentInfo{
    return presentPaymentInfo;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end