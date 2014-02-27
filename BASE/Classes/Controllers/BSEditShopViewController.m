//
//  BSEditShopViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSEditShopViewController.h"

@interface BSEditShopViewController ()

@end

@implementation BSEditShopViewController{
    UIScrollView *scrollView;
    
    NSString *userAgent;
    
    //ローディング
    UIActivityIndicatorView *ai1;
    UIActivityIndicatorView *ai2;
    UIActivityIndicatorView *ai3;
    
    
    UIImageView *BgImage1;
    UIImageView *BgImage2;


    NSString *shopUrl;
    NSString *apiUrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //グーグルアナリティクス
    self.screenName = @"editShop";
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
    //ナビゲーションバー
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];

    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"デザイン編集";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    
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
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    
    
    UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"お店を確認" style:UIBarButtonItemStyleBordered target:self action:@selector(checkShop:)];
    navItem.rightBarButtonItem = rightItemButton;
    
    //スクロール
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];
    scrollView.contentSize = CGSizeMake(320, 707 + 85);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    [self.view insertSubview:scrollView belowSubview:navBar];
    
    
    
    
    int ySpace = 257;
    int firstSpace = 342;
    
    
    
    
    
    //画像
    logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"de_no_image.png"]];
    logoImage.frame = CGRectMake( 0, 0, 255, 145);
    logoImage.center = CGPointMake(160, 104.5);
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:logoImage];
    
    ai1 = [[UIActivityIndicatorView alloc] init];
    ai1.frame = CGRectMake(97.5, 80, 50, 50);
    //ai.center = self.view.center;
    ai1.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [logoImage addSubview:ai1];
    [ai1 startAnimating];
    
    BgImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"de_no_image.png"]];
    BgImage1.frame = CGRectMake( 0, 0, 255, 145);
    BgImage1.center = CGPointMake(160, logoImage.center.y + firstSpace);
    [scrollView addSubview:BgImage1];
    
    ai2 = [[UIActivityIndicatorView alloc] init];
    ai2.frame = CGRectMake(97.5, 80, 50, 50);
    //ai.center = self.view.center;
    ai2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [BgImage1 addSubview:ai2];
    [ai2 startAnimating];
    
    BgImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"de_no_image.png"]];
    BgImage2.frame = CGRectMake( 0, 0, 255, 145);
    BgImage2.center = CGPointMake(160, BgImage1.center.y + ySpace + 22);
    [scrollView addSubview:BgImage2];
    
    ai3 = [[UIActivityIndicatorView alloc] init];
    ai3.frame = CGRectMake(97.5, 80, 50, 50);
    //ai.center = self.view.center;
    ai3.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [BgImage2 addSubview:ai3];
    [ai3 startAnimating];
    
    /*
    UIImageView *themeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"themeImage.png"]];
    themeImage.frame = CGRectMake( 0, 0, 255, 145);
    themeImage.center = CGPointMake(160, BgImage2.center.y + ySpace);
    [scrollView addSubview:themeImage];
    */
    
    
    //横線
    
    UIView *topLine1 = [[UIView alloc] init];
    topLine1.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    topLine1.frame = CGRectMake(0, 342, 320, 1);
    UIView *bottomLine1 = [[UIView alloc] init];
    bottomLine1.backgroundColor = [UIColor whiteColor];
    bottomLine1.frame = CGRectMake(0, 343, 320, 1);
    [scrollView addSubview:topLine1];
    [scrollView addSubview:bottomLine1];
    
    UIView *topLine2 = [[UIView alloc] init];
    topLine2.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    topLine2.frame = CGRectMake(0, topLine1.frame.origin.y + ySpace + 22, 320, 1);
    UIView *bottomLine2 = [[UIView alloc] init];
    bottomLine2.backgroundColor = [UIColor whiteColor];
    bottomLine2.frame = CGRectMake(0, bottomLine1.frame.origin.y + ySpace + 22, 320, 1);
    [scrollView addSubview:topLine2];
    [scrollView addSubview:bottomLine2];
    
    UIView *topLine3 = [[UIView alloc] init];
    topLine3.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    topLine3.frame = CGRectMake(0, topLine2.frame.origin.y + ySpace + 22, 320, 1);
    UIView *bottomLine3 = [[UIView alloc] init];
    bottomLine3.backgroundColor = [UIColor whiteColor];
    bottomLine3.frame = CGRectMake(0, bottomLine2.frame.origin.y + ySpace + 22, 320, 1);
    [scrollView addSubview:topLine3];
    [scrollView addSubview:bottomLine3];
    
    
    //ボタン
    UIImage *normalImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        normalImage = [UIImage imageNamed:@"btn_7_03.png"];
    }else{
        normalImage = [UIImage imageNamed:@"btn_03.png"];
    }
    UIButton *itemButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton1.frame = CGRectMake( 0,  0, 260, 60);
    itemButton1.center = CGPointMake(160, 217);
    itemButton1.tag = 4;
    [itemButton1 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton1 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton1 addTarget:self action:@selector(uploadLogo:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton1];
    
    UIButton *itemButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton2.frame = CGRectMake( 0,  0, 260, 60);
    itemButton2.tag = 1;
    itemButton2.center = CGPointMake(160, itemButton1.center.y + firstSpace);
    [itemButton2 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton2 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton2 addTarget:self action:@selector(selectEdit:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton2];
    
    UIButton *itemButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton3.frame = CGRectMake( 0,  0, 260, 60);
    itemButton3.tag = 2;
    itemButton3.center = CGPointMake(160, itemButton2.center.y + ySpace + 22);
    [itemButton3 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton3 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton3 addTarget:self action:@selector(selectEdit:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton3];
    
    /*
    UIButton *itemButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton4.frame = CGRectMake( 0,  0, 260, 60);
    itemButton4.tag = 3;
    itemButton4.center = CGPointMake(160, itemButton3.center.y + ySpace);
    [itemButton4 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton4 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton4 addTarget:self action:@selector(selectEdit:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton4];
    */
    
    //ボタンテキスト
    UILabel *selectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel1.text = @"ロゴをアップロード";
    selectLabel1.textAlignment = NSTextAlignmentCenter;
    selectLabel1.center = CGPointMake(160, 217);
    selectLabel1.font = [UIFont boldSystemFontOfSize:20];
    
    selectLabel1.shadowColor = [UIColor whiteColor];
    selectLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel1.backgroundColor = [UIColor clearColor];
    selectLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel1];
    
    
    UILabel *selectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel2.text = @"デザインテーマを選ぶ";
    selectLabel2.textAlignment = NSTextAlignmentCenter;
    selectLabel2.center = CGPointMake(160, selectLabel1.center.y + firstSpace);
    selectLabel2.font = [UIFont boldSystemFontOfSize:20];
    selectLabel2.shadowColor = [UIColor whiteColor];
    selectLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel2.backgroundColor = [UIColor clearColor];
    selectLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel2];
    
    UILabel *selectLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel3.text = @"バックグラウンドを変更";
    selectLabel3.textAlignment = NSTextAlignmentCenter;
    selectLabel3.center = CGPointMake(160, selectLabel2.center.y + ySpace  + 22);
    selectLabel3.font = [UIFont boldSystemFontOfSize:20];
    selectLabel3.shadowColor = [UIColor whiteColor];
    selectLabel3.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel3.backgroundColor = [UIColor clearColor];
    selectLabel3.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel3];
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        selectLabel1.shadowColor = nil;
        selectLabel1.shadowOffset = CGSizeMake(0.f, 0.f);
        selectLabel2.shadowColor = nil;
        selectLabel2.shadowOffset = CGSizeMake(0.f, 0.f);
        selectLabel3.shadowColor = nil;
        selectLabel3.shadowOffset = CGSizeMake(0.f, 0.f);
    }else{
    }
    /*
    UILabel *selectLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel4.text = @"背景画像を変更";
    selectLabel4.textAlignment = NSTextAlignmentCenter;
    selectLabel4.center = CGPointMake(160, selectLabel3.center.y + ySpace);
    selectLabel4.font = [UIFont boldSystemFontOfSize:20];
    selectLabel4.shadowColor = [UIColor whiteColor];
    selectLabel4.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel4.backgroundColor = [UIColor clearColor];
    selectLabel4.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel4];
    */
    
    
    //ショップ名変更フォーム
    shopName = [[UITextField alloc] initWithFrame:CGRectMake(10, itemButton1.center.y + 50 , 300, 40)];
    shopName.borderStyle = UITextBorderStyleNone;
    shopName.textColor = [UIColor blackColor];
    shopName.placeholder = @"ショップ名の変更";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    shopName.leftView = paddingView;
    shopName.leftViewMode = UITextFieldViewModeAlways;
    shopName.layer.borderWidth = 1.0;
    shopName.layer.cornerRadius = 8.0;
    shopName.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    shopName.tag = 1;
    shopName.returnKeyType = UIReturnKeyDone;
    shopName.clearButtonMode = UITextFieldViewModeAlways;
    shopName.delegate = self;
    [shopName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    shopName.backgroundColor = [UIColor clearColor];
    [shopName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:shopName];
    
    /*
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, shopName.center.y + 25, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"※ショップロゴとショップ名の同時適用はできません。";
    [scrollView addSubview:label];
    
     */
    //完了ボタン
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque; // スタイルを設定
    [toolBar sizeToFit];
    
    // フレキシブルスペースの作成（Doneボタンを右端に配置したいため）
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Doneボタンの作成
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"変更"  style:UIBarButtonItemStyleBordered target:self action:@selector(doRename:)];
    [done setTintColor:[UIColor blackColor]];
    [done setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    // cancelボタンの作成
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRename:)] ;
    [cancel setTintColor:[UIColor blackColor]];
    [cancel setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    // ボタンをToolbarに設定
    NSArray *items = @[cancel,spacer, done];
    [toolBar setItems:items animated:YES];
    
    // ToolbarをUITextFieldのinputAccessoryViewに設定
    shopName.inputAccessoryView = toolBar;
    
    //受け取るデータ
    receivedData = [[NSMutableData alloc] init];
    
    scrollView.contentSize = CGSizeMake(320, bottomLine2.frame.origin.y + ySpace + 23);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[BSMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    self.slidingViewController.anchorLeftPeekAmount     = 0;
    self.slidingViewController.anchorLeftRevealAmount   = 0;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    

    
    [[BSSellerAPIClient sharedClient] getDesignLogoWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"getDesignLogoWithSessionId: %@", results);
        NSLog(@"task.originalRequest.allHTTPHeaderFields: %@", [task.originalRequest.allHTTPHeaderFields valueForKey:@"User-Agent"]);


        
        userAgent = [task.originalRequest.allHTTPHeaderFields valueForKey:@"User-Agent"];
        NSString *logoUrl = [results valueForKeyPath:@"logo_url"];
        NSDictionary *rootUser = [results valueForKeyPath:@"user"];
        NSDictionary *user = [rootUser valueForKeyPath:@"User"];
        NSString *logoImageUrl = [user valueForKeyPath:@"logo"];
        shopName.text = [user valueForKeyPath:@"shop_name"];
        
        if ([logoImageUrl isEqual:[NSNull null]] || [logoImageUrl isEqualToString:@""]) {
            [ai1 stopAnimating];
        }
        
        NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoImageUrl];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            [ai1 stopAnimating];
            [ai3 stopAnimating];
            [logoImage setImage:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
        
    }];
    
    

    
    [[BSSellerAPIClient sharedClient] getDesignThemeWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getDesignThemeWithSessionId！: %@", results);
        NSString *defaultView = [results valueForKeyPath:@"user.User.default_view"];
        [ai2 stopAnimating];
        
        
        
        for (int n = 1; n < 10; n++) {
            if ([defaultView isEqualToString:[NSString stringWithFormat:@"shop"]]) {
                [BgImage1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shop_1"]]];
                break;
            }
            if ([defaultView isEqualToString:[NSString stringWithFormat:@"shop_0%d",n - 1]]) {
                [BgImage1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shop_%d",n]]];
            }
        }
        
    }];
    
    
    
    //バックグラウンドの取得
    
    [[BSSellerAPIClient sharedClient] getDesignBackgroundWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getDesignBackgroundWithSessionId: %@", results);
        //NSString *defaultView = [JSON valueForKeyPath:@"user.User.default_view"];
        [ai3 stopAnimating];
        
        NSString *url1 = [NSString stringWithFormat:@"%@%@",results[@"background_url"],[results valueForKeyPath:@"user.User.background"]];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            [BgImage2 setImage:responseObject];

        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
    }];
    
    

    
    
    [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getUsersShopWithSessionId: %@", results);
        NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
        shopUrl = shopInfo[@"shop_url"];
    }];
    
    
}

//キャンセル時
- (IBAction)cancelRename:(id)sender {
    
    [shopName resignFirstResponder];
    
}


//ショップ名変更
- (IBAction)doRename:(id)sender {
    
    [self validationCheck];
    if (!validation) {
        return;
    }
    [SVProgressHUD showWithStatus:@"ショップ名を変更中..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[BSSellerAPIClient sharedClient] getUsersEditNameWithSessionId:[BSUserManager sharedManager].sessionId shopName:shopName.text completion:^(NSDictionary *results, NSError *error) {
        
        if (error) {
            NSLog(@"エラーになりました");
        } else {
            [SVProgressHUD showSuccessWithStatus:@"ショップ名を変更しました！"];

        }
        NSLog(@"getUsersEditNameWithSessionId:%@",results);
        [shopName resignFirstResponder];
        
    }];
    
}

//バリデーションチェック
- (void)validationCheck {
    if (shopName.text == nil || [shopName.text isEqualToString:@""]) {
        [shopName becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"ショップ名の入力が正しくありません" message:@""
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else{
        validation = YES;
    }
    
    
    NSLog(@"バリデーションチェック");
    
}


//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scrollView.contentOffset;
    CGPoint pt;
    if (textField == shopName) {
        CGRect rc = [shopName bounds];
        rc = [shopName convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
    }
    [scrollView setContentOffset:pt animated:YES];
}


- (IBAction)selectEdit:(id)sender {
    
    UIViewController *vc;
    if ([sender tag] == 1) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"selectTheme"];
    }else if ([sender tag] == 2) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"selectBg"];
    }else if ([sender tag] == 3) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"editBgImage"];
    }
    [self presentViewController:vc animated:YES completion: ^{
        
        NSLog(@"完了");}];
    
}

- (IBAction)uploadLogo:(id)sender {
    
    UIActionSheet *logoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"カメラで撮影",@"ライブラリから選択",nil];
    [logoActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    switch (buttonIndex) {
        case 0: //カメラ起動
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1: //ライブラリ
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    
    /*---イメージピッカーの生成---*/
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // イメージピッカーのタイプを代入
    picker.sourceType = sourceType;
    // 写真を編集する
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    
    [self presentViewController:picker animated:YES completion: ^{
        
        NSLog(@"完了");}];
    
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *getLogoImage = info[UIImagePickerControllerOriginalImage];
    //[logoImage setImage:getLogoImage];
    NSLog(@"取得した画像のサイズタテ%fヨコ%f",getLogoImage.size.height,getLogoImage.size.width);

    if (getLogoImage) {
        
        //CGImageRef imageRef = [getLogoImage CGImage];
        //float width = w;
        
        int resize_w = 640;
        float rate = (resize_w / getLogoImage.size.width);
        NSLog(@"比率%f",rate);
            
        int resize_h = (float)getLogoImage.size.height * rate;

         NSLog(@"リサイズ比率%d",resize_h);
        UIGraphicsBeginImageContext(CGSizeMake(resize_w, resize_h));
        [getLogoImage drawInRect:CGRectMake(0, 0, resize_w, resize_h)];
        getLogoImage = UIGraphicsGetImageFromCurrentImageContext();  
        UIGraphicsEndImageContext();
         
    }
    NSLog(@"取得した画像のサイズその２タテ%fヨコ%f",getLogoImage.size.height,getLogoImage.size.width);
    

    
    
    // add image data
    NSData *imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(getLogoImage , 1.0)];
    UIImage *dataimage = [[UIImage alloc] initWithData:imageToUpload];
    NSLog(@"取得した画像のサイズその3タテ%fヨコ%f",dataimage.size.height,dataimage.size.width);
    NSLog(@"画像のサイズ%d",[imageToUpload length]);
    
    
    if (imageToUpload)
    {
       NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[BSUserManager sharedManager].sessionId, @"session_id", nil];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSString *ua = userAgent;
        [requestSerializer setValue:ua forHTTPHeaderField:@"User-Agent"];
        manager.requestSerializer = requestSerializer;
        [manager POST:[NSString stringWithFormat:@"%@/design/upload_logo",apiUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageToUpload name:@"logo" fileName:@"logo.jpeg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            [[BSSellerAPIClient sharedClient] getDesignLogoWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results,  NSURLSessionDataTask *task, NSError *error) {
                
                
                userAgent = [task.originalRequest.allHTTPHeaderFields valueForKey:@"User-Agent"];
                NSString *logoUrl = [results valueForKeyPath:@"logo_url"];
                NSDictionary *rootUser = [results valueForKeyPath:@"user"];
                NSDictionary *user = [rootUser valueForKeyPath:@"User"];
                NSDictionary *logoImageUrl = [user valueForKeyPath:@"logo"];
                
                
                [ai1 startAnimating];
                NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoImageUrl];
                NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];

                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Response: %@", responseObject);
                    [ai1 stopAnimating];
                    [logoImage setImage:responseObject];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
                
                
            }];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"ロゴアップロードError: %@", error);
        }];
        
    }
    

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"レスポンスきたよ！！！");
    [receivedData setLength:0];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
    NSArray *test = [jsonObject valueForKeyPath:@"error.validations.User.logo"];
    NSString *jsonString = test[0];
    //取得した商品情報を表示
    
    
    [[BSSellerAPIClient sharedClient] getDesignLogoWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results,  NSURLSessionDataTask *task,NSError *error) {
        
        
        NSLog(@"getDesignLogoWithSessionId！: %@", results);
        
        
        
        userAgent = [task.originalRequest.allHTTPHeaderFields valueForKey:@"User-Agent"];
        NSString *logoUrl = [results valueForKeyPath:@"logo_url"];
        NSDictionary *rootUser = [results valueForKeyPath:@"user"];
        NSDictionary *user = [rootUser valueForKeyPath:@"User"];
        NSDictionary *logoImageUrl = [user valueForKeyPath:@"logo"];
        
        
        [ai1 startAnimating];
        NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoImageUrl];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            [ai1 stopAnimating];
            [logoImage setImage:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];

        
        
        
    }];
}


- (void)checkShop:(id)sender{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myshop"];
    [self presentViewController:vc animated:YES completion: ^{
        
        NSLog(@"完了");}];
}


- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)goSafari:(id)sender
{
    NSString *shopId = [BSTutorialViewController importShopId];
    NSString *url = [NSString stringWithFormat:@"https://%@.upbase.info/",shopId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
