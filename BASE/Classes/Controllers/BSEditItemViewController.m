//
//  BSEditItemViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSEditItemViewController.h"

#import "BSItemsView.h"


@interface BSEditItemViewController ()

@end

@implementation BSEditItemViewController{
    UIScrollView *scrollView;
    
    //一度だけ商品情報を読み込む
    BOOL isLoaded;
    
    NSArray *variationArray;
    
    //画像のurl
    NSString *imageUrl;
    
    NSString *userAgent;
    
    UIButton *stockButton;
    
    NSString *apiUrl;
    
    
    // 画像の新規との差分を取得する
    NSMutableArray *newPhotosArray;
    
    BSItemsView *itemView;
    
    //一度のみ画像を取得
    BOOL firstConnect;
    
    // 取得した画像一覧
    NSMutableArray *getImageArray;
    
    UIImage *leftButtonImage;
    UIImage *centerLeftButtonImage;
    UIImage *centerButtonImage;
    UIImage *centerRightButtonImage;
    UIImage *rightButtonImage;

    BOOL isFinished;
    
    int uploaded;
    int deleted;

}


@synthesize varyField1;
@synthesize varyField2;
@synthesize varyField3;
@synthesize varyField4;
@synthesize varyField5;

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
    
    
    NSString *itemId = [BSItemAdminViewController getItemId];
    NSLog(@"アイテムid%@",importId);
    if ([BSUserManager sharedManager].sessionId != NULL && !isLoaded) {
        [SVProgressHUD showWithStatus:@"商品情報を取得中" maskType:SVProgressHUDMaskTypeClear];

        //[NSURLConnection connectionWithRequest:request delegate:self ];
        
        
        [[BSSellerAPIClient sharedClient] getItemWithSessionId:[BSUserManager sharedManager].sessionId itemId:itemId completion:^(NSDictionary *results, NSError *error) {
            
            [self loadItemView:results];
            [SVProgressHUD dismiss];
            
            [stockTable reloadData];
        }];
        
        
        
    }else{
    
        
        [[BSSellerAPIClient sharedClient] getItemWithSessionId:[BSUserManager sharedManager].sessionId itemId:itemId completion:^(NSDictionary *results, NSError *error) {
            
            [self loadItemView:results];
            [SVProgressHUD dismiss];
            isLoaded = YES;
            [stockTable reloadData];
        }];
    }
    
}


- (void)viewDidLoad
{
    
    //グーグルアナリティクス
    self.screenName = @"editItem";
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
    
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        //navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        self.navigationController.navigationBar.tag = 100;
        [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];
        self.title = @"商品編集";
        UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"商品を削除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteItem:)];
        self.navigationItem.rightBarButtonItem = rightItemButton;

        UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhoto)];
        self.navigationItem.leftBarButtonItem = leftItemButton;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
        label.text = @"商品編集";
        [label sizeToFit];
        
        self.navigationItem.titleView = label;
        
    }else{
        self.navigationController.navigationBarHidden = YES;
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"商品編集"];
        [navBar pushNavigationItem:navItem animated:YES];
        [self.view addSubview:navBar];
        
        UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"商品を削除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteItem:)];
        navItem.rightBarButtonItem = rightItemButton;
        [navItem.rightBarButtonItem setTintColor:[UIColor redColor]];
        NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
        [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
        [navItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
        
        UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhoto)];
        navItem.leftBarButtonItem = leftItemButton;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
        label.text = @"商品編集";
        [label sizeToFit];
        
        navItem.titleView = label;
    }
    
    
    /*
     //ローディングのアニメーション
     loadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
     loadView.image = [UIImage imageNamed:@"loading01"];
     loadView.center = CGPointMake(self.view.center.x, self.view.center.y);
     [self.view addSubview:loadView];
     
     // アニメーション用画像を配列にセット
     NSMutableArray *imageList = [NSMutableArray array];
     for (NSInteger i = 1; i < 5; i++) {
     NSString *imagePath = [NSString stringWithFormat:@"loading0%d", i];
     UIImage *img = [UIImage imageNamed:imagePath];
     [imageList addObject:img];
     }
     
     // アニメーション用画像をセット
     loadView.animationImages = imageList;
     
     // アニメーションの速度
     loadView.animationDuration = 0.8;
     
     // アニメーションのリピート回数
     loadView.animationRepeatCount = 0;
     
     // アニメーション実行
     [loadView startAnimating];
     
     */
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height -64)];
        scrollView.contentSize = CGSizeMake(320, 690);
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        [self.view insertSubview:scrollView belowSubview:self.navigationController.navigationBar];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];
        scrollView.contentSize = CGSizeMake(320, 690);
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        [self.view insertSubview:scrollView belowSubview:navBar];
    }
    
    itemView = [BSItemsView itemView];
    [scrollView addSubview:itemView];
    
    

    [itemView.leftButton addTarget:self action:@selector(importPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [itemView.centerLeftButton addTarget:self action:@selector(importPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [itemView.centerButton addTarget:self action:@selector(importPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [itemView.centerRightButton addTarget:self action:@selector(importPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [itemView.rightButton addTarget:self action:@selector(importPhoto:) forControlEvents:UIControlEventTouchUpInside];

    
    /*
     if(takePicture3 == NULL){
     UIImage *simage = [UIImage imageNamed:@"btn_addphoto.png"];
     imageSpace3 = [[UIImageView alloc] initWithImage:simage];
     imageSpace3.frame = CGRectMake(220,20,85,85);
     [imageSpace3 setContentMode:UIViewContentModeScaleToFill];
     
     [scrollView addSubview:imageSpace3];
     }
     if(takePicture4 == NULL){
     UIImage *simage = [UIImage imageNamed:@"btn_addphoto.png"];
     imageSpace4 = [[UIImageView alloc] initWithImage:simage];
     imageSpace4.frame = CGRectMake(10,120,85,85);
     [imageSpace4 setContentMode:UIViewContentModeScaleToFill];
     
     [scrollView addSubview:imageSpace4];
     }
     if(takePicture5 == NULL){
     UIImage *simage = [UIImage imageNamed:@"btn_addphoto.png"];
     imageSpace5 = [[UIImageView alloc] initWithImage:simage];
     imageSpace5.frame = CGRectMake(115,120,85,85);
     [imageSpace5 setContentMode:UIViewContentModeScaleToFill];
     
     [scrollView addSubview:imageSpace5];
     }
     */
    
    //入力フォーム
    //商品名
    itemName = [[UITextField alloc] initWithFrame:CGRectMake(5, (itemView.frame.size.height + itemView.frame.origin.y) + 5, 310, 40)];
    itemName.borderStyle = UITextBorderStyleNone;
    itemName.textColor = [UIColor blackColor];
    itemName.placeholder = @"商品名";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    itemName.leftView = paddingView;
    itemName.leftViewMode = UITextFieldViewModeAlways;
    itemName.layer.borderWidth = 1.0;
    itemName.layer.cornerRadius = 8.0;
    itemName.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    itemName.tag = 1;
    itemName.returnKeyType = UIReturnKeyDone;
    itemName.clearButtonMode = UITextFieldViewModeAlways;
    itemName.delegate = self;
    [itemName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    itemName.backgroundColor = [UIColor clearColor];
    [itemName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [scrollView addSubview:itemName];
    NSLog(@"%@",itemName.font);
    
    
    //価格
    price = [[UITextField alloc] initWithFrame:CGRectMake(5, (itemName.frame.size.height + itemName.frame.origin.y) + 5, 260, 40)];
    price.borderStyle = UITextBorderStyleNone;
    price.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    price.leftView = paddingView2;
    price.leftViewMode = UITextFieldViewModeAlways;
    price.textColor = [UIColor blackColor];
    price.placeholder = @"価格";
    price.layer.borderWidth = 1.0;
    price.layer.cornerRadius = 8.0f;
    price.clipsToBounds = YES;
    price.tag = 2;
    price.returnKeyType = UIReturnKeyDone;
    price.keyboardType = UIKeyboardTypeNumberPad;
    price.clearButtonMode = UITextFieldViewModeAlways;
    price.delegate = self;
    price.backgroundColor = [UIColor clearColor];
    [price setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [price setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [scrollView addSubview:price];
    
    
    //商品説明
    detail = [[UITextView alloc] initWithFrame:CGRectMake(5, (price.frame.size.height + price.frame.origin.y) + 5, 310, 150)];
    detail.text = @"商品説明";
    detail.textColor = [UIColor blackColor];
    detail.layer.borderWidth = 1.0;
    detail.layer.cornerRadius = 8.0;
    [detail.layer setMasksToBounds:YES];
    detail.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    detail.textColor = [UIColor lightGrayColor];
    [detail setFont:[UIFont systemFontOfSize:17]];
    detail.clipsToBounds = YES;
    detail.backgroundColor = [UIColor clearColor];
    detail.delegate = self;
    
    [scrollView addSubview:detail];
    
    
    
    
    //在庫テーブル
    stockTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (detail.frame.size.height + detail.frame.origin.y) + 5, 320, 45) style:UITableViewStyleGrouped];
    stockTable.dataSource = self;
    stockTable.delegate = self;
    stockTable.tag = 1;
    stockTable.backgroundView = nil;
    stockTable.backgroundColor = [UIColor clearColor];
    //[scrollView addSubview:stockTable];
    
    //公開テーブル
    openTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (stockTable.frame.size.height + stockTable.frame.origin.y) + 30, 320, 45) style:UITableViewStyleGrouped];
    openTable.dataSource = self;
    openTable.delegate = self;
    openTable.tag = 1;
    openTable.backgroundView = nil;
    openTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:openTable];
    

    //公開ボタン（スイッチ)
    openSwitch = [[UISwitch alloc] init];
    openSwitch.center = CGPointMake(255, 473);
    //openSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    openSwitch.on = YES;
    
    [openSwitch addTarget:self action:@selector(switchcontroll:)
         forControlEvents:UIControlEventValueChanged];
    //[scrollView addSubview:openSwitch];
    visible = 1; //1:公開 2:非公開
    
    
    //「保存する」ボタン
    
    UIImage *submitImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        submitImage = [UIImage imageNamed:@"btn_7_01.png"];
    }else{
        submitImage = [UIImage imageNamed:@"btn_01.png"];
    }
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 292, 61);
    [submitButton setBackgroundImage:submitImage forState:UIControlStateNormal];
    //[submitButton setBackgroundImage:submitImage forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(submitItem:)forControlEvents:UIControlEventTouchUpInside];
    submitButton.center = CGPointMake(160, 540);
    [scrollView addSubview:submitButton];
    
    
    //「保存する」ラベル
    submitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    submitLabel.text = @"保存する";
    submitLabel.textAlignment = NSTextAlignmentCenter;
    submitLabel.center = CGPointMake(160, 540);
    submitLabel.font = [UIFont boldSystemFontOfSize:20];
    if ([BSDefaultViewObject isMoreIos7]) {
       
    }else{
        submitLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        submitLabel.shadowOffset = CGSizeMake(0.f, -1.f);
    }
    
    submitLabel.backgroundColor = [UIColor clearColor];
    submitLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:submitLabel];
    
    
    //「キャンセル」ボタン
    UIImage *cancelImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        cancelImage = [UIImage imageNamed:@"btn_7_03.png"];
    }else{
        cancelImage = [UIImage imageNamed:@"btn_03.png"];
    }
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 292, 61);
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    //[cancelButton setBackgroundImage:cancelImage forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPhoto:)forControlEvents:UIControlEventTouchUpInside];
    cancelButton.center = CGPointMake(160, 610);
    [scrollView addSubview:cancelButton];
    
    //「キャンセル」ラベル
    cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    cancelLabel.text = @"キャンセル";
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.center = CGPointMake(160, 610);
    cancelLabel.font = [UIFont boldSystemFontOfSize:20];
    if ([BSDefaultViewObject isMoreIos7]) {
        
    }else{
        cancelLabel.shadowColor = [UIColor whiteColor];
        cancelLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    cancelLabel.backgroundColor = [UIColor clearColor];
    cancelLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:cancelLabel];
    
    
    
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
    detail.inputAccessoryView = toolBar;
    price.inputAccessoryView = toolBar;

    //受け取るデータ
    receivedData = [[NSMutableData alloc] init];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //バリエーションのテキストボタン
    varyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,(stockTable.frame.size.height + stockTable.frame.origin.y) + 5,200,20)];
    varyLabel.text = @"バリエーションを追加する";
    varyLabel.font = [UIFont systemFontOfSize:13];
    varyLabel.backgroundColor = [UIColor clearColor];
    varyLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:varyLabel];
    UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
    stirngUnderLine.backgroundColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [varyLabel addSubview:stirngUnderLine];
    
    varyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    varyBtn.frame = CGRectMake(5,(stockTable.frame.size.height + stockTable.frame.origin.y) + 5,300,20);
    varyBtn.backgroundColor = [UIColor clearColor];
    
    [varyBtn addTarget:self
                action:@selector(addVary:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:varyBtn];
    
    getImageArray = [@[ @"0", @"0", @"0", @"0", @"0"] mutableCopy];
    
    leftButtonImage = nil;
    centerLeftButtonImage = nil;
    centerButtonImage = nil;
    centerRightButtonImage = nil;
    rightButtonImage = nil;
    newPhotosArray = [@[ @"0", @"0", @"0", @"0", @"0"] mutableCopy];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        
        UIImagePickerControllerSourceType sourceType;
        switch (buttonIndex) {
            case 0: //カメラ起動
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1: //ライブラリ
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2: //商品管理に戻る
                if (btnInf == NULL){
                    NSLog(@"キャンセルしたよ！");
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }
                return;
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
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion: ^{
            NSLog(@"完了");}];
    }else if (actionSheet.tag == 2){
        UIImagePickerControllerSourceType sourceType;
        switch (buttonIndex) {
            case 0: //カメラ起動
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1: //ライブラリ
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2: //商品管理に戻る
                [self deletePhoto];
                return;
                break;
            case 3: //商品管理に戻る
                if (btnInf == NULL){
                    NSLog(@"キャンセルしたよ！");
                    [self dismissViewControllerAnimated:YES completion:NULL];
                }
                return;
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
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion: ^{
            NSLog(@"完了");}];
    }else{
        switch (buttonIndex) {
            case 0: //商品管理に戻る
                [self deleteItem];
                return;
                break;
            default:
                return;
        }
    }
}


/********************************写真追加**********************************/
- (void)importPhoto:(id)sender
{
    btnInf = (UIButton*)sender;
    NSLog(@"%d",btnInf.tag);
    
    if (btnInf.currentImage == nil) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"カメラで撮影",@"ライブラリから選択",nil];
        actionSheet.delegate = self;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"カメラで撮影",@"ライブラリから選択",@"写真を削除",nil];
        actionSheet.delegate = self;
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];
    }
    
    NSLog(@"OK");
}

////////////////////////////////////////////////////
//カメラ終了後の処理
////////////////////////////////////////////////////
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    //取得した画像をviewに表示
    if (btnInf.tag == 2){
        
        [itemView.centerLeftButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        centerLeftButtonImage = info[UIImagePickerControllerEditedImage];
        //デリートボタン
        //deleteButton2.hidden = NO;

        
        //三番目の写真追加ボタンを表示
        if (!centerButtonImage) {
            itemView.centerButton.hidden = NO;
        }
        
    } else if (btnInf.tag == 3){
        
        [itemView.centerButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        centerButtonImage = info[UIImagePickerControllerEditedImage];

        //4番目の写真追加ボタンを表示
        if (!centerRightButtonImage) {
            itemView.centerRightButton.hidden = NO;

        }

        
        
    }else if(btnInf.tag == 4){
        
        [itemView.centerRightButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        centerRightButtonImage = info[UIImagePickerControllerEditedImage];

        //デリートボタン
        deleteButton4.hidden = NO;
        
        //5番目の写真追加ボタンを表示
        if (!rightButtonImage) {
            itemView.rightButton.hidden = NO;
        }
    }else if(btnInf.tag == 5){
        
        [itemView.rightButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        rightButtonImage = info[UIImagePickerControllerEditedImage];

        //デリートボタン
        itemView.rightButton.hidden = NO;
        
    }else{
        //UIImageWriteToSavedPhotosAlbum(takePicture1, self, NULL, NULL);
        
        [itemView.leftButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
        leftButtonImage = info[UIImagePickerControllerEditedImage];

        //デリートボタン

        if (!centerLeftButtonImage) {
            itemView.centerLeftButton.hidden = NO;
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



/*************************************テーブルビュー*************************************/


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
     NSInteger sections;
     if (tableView == _tableView1){
     if (pushCount == 0){
     sections = 1;
     }else if (pushCount == 1){
     sections = 2;
     }else if (pushCount == 2){
     sections = 3;
     }else if (pushCount == 3){
     sections = 4;
     }
     }
     if (tableView == _tableView2) sections = 1;
     */
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    
    if (tableView == stockTable || tableView == openTable){
        rows = 1;
    }else{
        rows = 2;
    }
    return rows;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == stockTable || tableView == openTable) {
        return 0.1;
    }else{
        if(section == 0){
            return 0.1;
        }else{
            return tableView.sectionHeaderHeight;
            
        }
    }
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 9.9;
    
}
//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@,%d",tableView,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }


    
    if (tableView == stockTable){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
        stockButton.backgroundColor = [UIColor clearColor];
        [stockButton addTarget:self
                             action:@selector(selectNumber:)
                   forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:stockButton];
        stockButton.tag =  1;
        if (incVariation1 == 1) {
            cell.textLabel.text = @"バリエーション";
            stockButton.hidden = YES;
        }else{
            cell.textLabel.text = @"在庫数";
        }
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        
        //数量ラベル1
        stock1 = 1;
        stockLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(120, -1,150,50)];
        stockLabel1.text = [NSString stringWithFormat:@"%d個", stock1];
        if (jsonStock && incVariation1 == 0) {
            stockLabel1.text = jsonStock;
        }else{
            stockLabel1.text = [NSString stringWithFormat:@"%d個",variationArray.count];
            varyBtn.hidden = YES;
            varyLabel.hidden = YES;
        }
        stockLabel1.textAlignment = NSTextAlignmentRight;
        stockLabel1.font = [UIFont boldSystemFontOfSize:20];
        stockLabel1.shadowColor = [UIColor whiteColor];
        stockLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
        stockLabel1.backgroundColor = [UIColor clearColor];
        stockLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:stockLabel1];
        
    }else if (tableView == openTable){
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.textLabel.text = @"公開する";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryView = openSwitch;

    }
        
    return cell;
}
//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == stockTable && incVariation1 == 1) {
        UIViewController *varyView = [self.storyboard instantiateViewControllerWithIdentifier:@"vary"];
        [self.navigationController pushViewController:varyView animated:YES];
    }
    
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
}



/************************************テーブルビュー(ここまで)*************************************/
- (void)addVary:(id)sender{
    UIViewController *varyView = [self.storyboard instantiateViewControllerWithIdentifier:@"vary"];
    [self.navigationController pushViewController:varyView animated:YES];
    
}

//テキストフィールドにフォーカスする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scrollView.contentOffset;
    CGPoint pt;
    if (textField == itemName) {
        CGRect rc = [itemName bounds];
        rc = [itemName convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
    }else if (textField == price){
        CGRect rc = [price bounds];
        rc = [price convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
    }else{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 60;
    }
    [scrollView setContentOffset:pt animated:YES];
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
}




//商品説明時のキーボードを消す
-(void)closeKeyboard:(id)sender{
    [detail resignFirstResponder];
    [price resignFirstResponder];
}
//キーボードを閉じる
- (void)allKeyboardClose{
    [price resignFirstResponder];
    [itemName resignFirstResponder];
    [detail resignFirstResponder];
    [self.varyField1 resignFirstResponder];
    [self.varyField2 resignFirstResponder];
    [self.varyField3 resignFirstResponder];
    [self.varyField4 resignFirstResponder];
    [self.varyField5 resignFirstResponder];
}
//リターンを押した時に挙動
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    NSLog(@"%@",nextResponder);
    if (nextTag == 2) {
        // Found next responder, so set it.
        [price becomeFirstResponder];
    }else if(nextTag == 3) {
        // Not found, so remove keyboard.
        [detail becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return NO;
}
//入力開始でプレースホルダーを消す
- (BOOL) textViewShouldBeginEditing: (UITextView*) textView {
    NSLog(@"%@",textView.text);
    NSString *str1 = textView.text;
    NSString *str2 = @"商品説明";
    if([str1 isEqualToString:str2]){
        NSLog(@"からにするよ");
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}
//テキストビューのプレースホルダー
- (BOOL) textViewShouldEndEditing: (UITextView*) textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"商品説明";
    }
    return YES;
}


//数量のピッカー
- (IBAction)selectNumber:(id)sender
{
    [self allKeyboardClose];
    NSLog(@"%c",firstButton);
    //てすと
    NSLog(@"ボタンのタグ:%d",[sender tag]);
    buttonTag = [sender tag];
    
    
    stockActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [stockActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    if (!firstButton) {
        stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        stockPicker.delegate = self; //自分自身をデリゲートに設定する。
        stockPicker.dataSource = self;
        stockPicker.showsSelectionIndicator = YES;
        firstButton = YES;
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
    if (buttonTag == 1) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock1 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel1.text = [NSString stringWithFormat:@"%d", stock1];
        
    }else if (buttonTag == 2) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock2 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel2.text = [NSString stringWithFormat:@"%d", stock2];
    }else if (buttonTag == 3) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock3 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel3.text = [NSString stringWithFormat:@"%d", stock3];
    }else if (buttonTag == 4) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock4 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel4.text = [NSString stringWithFormat:@"%d", stock4];
    }else if (buttonTag == 5) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock5 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel5.text = [NSString stringWithFormat:@"%d", stock5];
    }else if (buttonTag == 6) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock6 = [stockPicker selectedRowInComponent:0] + 1;
        stockLabel6.text = [NSString stringWithFormat:@"%d", stock6];
    }else{
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        buttonTag = 0;
    }
    buttonTag = 0;
    
}


//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 1000;
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    // 行インデックス番号を返す
    return [NSString stringWithFormat:@"%d", row + 1];
    
}


//公開ボタンスイッチ
- (IBAction)switchcontroll:(id)sender
{
    
    UISwitch *switch1 = sender;
    NSLog(@"%@",switch1);
    if (switch1.on == NO) {
        visible = 0;
        NSLog(@"おふです");
    }else if(switch1.on == YES){
        visible = 1;
        NSLog(@"おんです");
    }
    
}

- (IBAction)cancelPhoto:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}





/*****************************通信************************************/

-(void)loadItemView:(id)JSON
{
    //NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
    
    //取得した商品情報を表示
    imageUrl = [JSON valueForKeyPath:@"image_url"];
    
    NSArray *result = JSON[@"result"];
    NSDictionary *Item1 = [result valueForKeyPath:@"Item"];
    variationArray = [result valueForKeyPath:@"Variation"];
    NSLog(@"タイトル: %@", Item1);
    
    NSDictionary *detail1 = [Item1 valueForKeyPath:@"detail"];
    NSDictionary *title1 = [Item1 valueForKeyPath:@"title"];
    NSDictionary *price1 = [Item1 valueForKeyPath:@"price"];
    NSString *jsonIncVariation = [Item1 valueForKeyPath:@"incVariation"];
    NSString *itemVisible = [Item1 valueForKeyPath:@"visible"];
    NSLog(@"itemVisible%@",itemVisible);
    
    NSLog(@"商品詳細！%@",detail1);
    itemName.text = [NSString stringWithFormat:@"%@", title1];
    if (detail1) {
        detail.text = [NSString stringWithFormat:@"%@", detail1];
        detail.textColor = [UIColor blackColor];
    }
    price.text = [NSString stringWithFormat:@"%@", price1];
    
    incVariation1 = [jsonIncVariation intValue];
    if (incVariation1 == 0) {
        jsonStock = [Item1 valueForKeyPath:@"stock"];
    }
    if ([itemVisible intValue] == 1) {
        visible = 1;
        openSwitch.on = YES;
    }else{
        visible = 0;
        openSwitch.on = NO;
    }
    
    if (!firstConnect) {
        [scrollView addSubview:stockTable];
        
        
        
        for ( int n = 0; n < 5; n++) {
            
            if ([[Item1 objectForKey:[NSString stringWithFormat:@"img%d",n + 1]] isEqual:[NSNull null]] || [Item1 objectForKey:[NSString stringWithFormat:@"img%d",n + 1]] == nil) {
                continue;
            }
            NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl, [Item1 objectForKey:[NSString stringWithFormat:@"img%d",n + 1]]];
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", responseObject);
                switch (n) {
                    case 0:
                        [itemView.leftButton setImage:responseObject forState:UIControlStateNormal];
                        leftButtonImage = responseObject;
                        itemView.centerLeftButton.hidden = NO;
                        if (itemView.leftButton.currentImage == nil) {
                            NSLog(@"画像が入ってません");
                        }else{
                            NSLog(@"画像が入っているよ！");
                            
                        }
                        break;
                    case 1:
                        [itemView.centerLeftButton setImage:responseObject forState:UIControlStateNormal];
                        centerLeftButtonImage = responseObject;
                        
                        itemView.centerButton.hidden = NO;
                        break;
                    case 2:
                        [itemView.centerButton setImage:responseObject forState:UIControlStateNormal];
                        centerButtonImage = responseObject;
                        
                        itemView.centerRightButton.hidden = NO;
                        break;
                    case 3:
                        [itemView.centerRightButton setImage:responseObject forState:UIControlStateNormal];
                        centerRightButtonImage = responseObject;
                        
                        itemView.rightButton.hidden = NO;
                        break;
                    case 4:
                        [itemView.rightButton setImage:responseObject forState:UIControlStateNormal];
                        rightButtonImage = responseObject;
                        
                        break;
                        
                    default:
                        break;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
        }
        
        
        
        
        firstConnect = YES;

    }
}

//========================================================================
#pragma mark - deletePhoto
//写真削除
- (void)deletePhoto
{
    // 画像をひとつひだりのボタンに移す
    NSLog(@"ボタン%d",btnInf.tag);
    
    switch (btnInf.tag) {
        case 1:
            if (centerLeftButtonImage) {
                [itemView.leftButton setImage:itemView.centerLeftButton.currentImage forState:UIControlStateNormal];
                leftButtonImage = centerLeftButtonImage;
            } else {
                [itemView.leftButton setImage:nil forState:UIControlStateNormal];
                leftButtonImage = nil;
            }
            if (centerButtonImage) {
                [itemView.centerLeftButton setImage:itemView.centerButton.currentImage forState:UIControlStateNormal];
                centerLeftButtonImage = centerButtonImage;
                
            } else {
                [itemView.centerLeftButton setImage:nil forState:UIControlStateNormal];
                centerLeftButtonImage = nil;
            }
            if (centerRightButtonImage) {
                [itemView.centerButton setImage:itemView.centerRightButton.currentImage forState:UIControlStateNormal];
                centerButtonImage = centerRightButtonImage;
            } else {
                [itemView.centerButton setImage:nil forState:UIControlStateNormal];
                centerButtonImage = nil;
            }
            if (rightButtonImage) {
                [itemView.centerRightButton setImage:itemView.rightButton.currentImage forState:UIControlStateNormal];
                centerRightButtonImage = rightButtonImage;
            } else {
                [itemView.centerRightButton setImage:nil forState:UIControlStateNormal];
                centerRightButtonImage = nil;
            }
            
            [itemView.rightButton setImage:nil forState:UIControlStateNormal];
            rightButtonImage = nil;
            
            break;
        case 2:
            
            if (centerButtonImage) {
                [itemView.centerLeftButton setImage:itemView.centerButton.currentImage forState:UIControlStateNormal];
                centerLeftButtonImage = centerButtonImage;
                
            } else {
                [itemView.centerLeftButton setImage:nil forState:UIControlStateNormal];
                centerLeftButtonImage = nil;
            }
            if (centerRightButtonImage) {
                [itemView.centerButton setImage:itemView.centerRightButton.currentImage forState:UIControlStateNormal];
                centerButtonImage = centerRightButtonImage;
            } else {
                [itemView.centerButton setImage:nil forState:UIControlStateNormal];
                centerButtonImage = nil;
            }
            if (rightButtonImage) {
                [itemView.centerRightButton setImage:itemView.rightButton.currentImage forState:UIControlStateNormal];
                centerRightButtonImage = rightButtonImage;
            } else {
                [itemView.centerRightButton setImage:nil forState:UIControlStateNormal];
                centerRightButtonImage = nil;
            }
            
            [itemView.rightButton setImage:nil forState:UIControlStateNormal];
            rightButtonImage = nil;
            break;
        case 3:
            if (centerRightButtonImage) {
                [itemView.centerButton setImage:itemView.centerRightButton.currentImage forState:UIControlStateNormal];
                centerButtonImage = centerRightButtonImage;
            } else {
                [itemView.centerButton setImage:nil forState:UIControlStateNormal];
                centerButtonImage = nil;
            }
            if (rightButtonImage) {
                [itemView.centerRightButton setImage:itemView.rightButton.currentImage forState:UIControlStateNormal];
                centerRightButtonImage = rightButtonImage;
            } else {
                [itemView.centerRightButton setImage:nil forState:UIControlStateNormal];
                centerRightButtonImage = nil;
            }
            
            [itemView.rightButton setImage:nil forState:UIControlStateNormal];
            rightButtonImage = nil;
            
            break;
        case 4:
            if (rightButtonImage) {
                [itemView.centerRightButton setImage:itemView.rightButton.currentImage forState:UIControlStateNormal];
                centerRightButtonImage = rightButtonImage;
            } else {
                [itemView.centerRightButton setImage:nil forState:UIControlStateNormal];
                centerRightButtonImage = nil;
            }
            
            
            [itemView.rightButton setImage:nil forState:UIControlStateNormal];
            rightButtonImage = nil;
            
            break;
        case 5:
            [itemView.rightButton setImage:nil forState:UIControlStateNormal];
            rightButtonImage = nil;
            break;
        default:
            break;
    }
    
    
    // hiddenにする
    NSMutableArray *isEmptyImageArray = [@[@"0",@"0",@"0",@"0",@"0"] mutableCopy];

    if (leftButtonImage == nil) {
        [isEmptyImageArray replaceObjectAtIndex:0 withObject:@"1"];
    }
    if (centerLeftButtonImage == nil) {
        [isEmptyImageArray replaceObjectAtIndex:1 withObject:@"1"];
    }
    if (centerButtonImage == nil) {
        [isEmptyImageArray replaceObjectAtIndex:2 withObject:@"1"];
    }
    if (centerRightButtonImage == nil) {
        [isEmptyImageArray replaceObjectAtIndex:3 withObject:@"1"];
    }
    if (rightButtonImage == nil) {
        [isEmptyImageArray replaceObjectAtIndex:4 withObject:@"1"];
    }
    NSLog(@"isEmptyImageArray%@",isEmptyImageArray);
    
    NSArray* reversedArray = [[isEmptyImageArray reverseObjectEnumerator] allObjects];
    
    for (int n = 0; n < reversedArray.count; n++) {
        
        if ([reversedArray[n] intValue] == 1) {
            
            switch (n) {
                case 0:
                    newPhotosArray[4] = @"0";
                    itemView.rightButton.hidden = NO;
                    break;
            
                case 1:
                    newPhotosArray[3] = @"0";
                    newPhotosArray[4] = @"0";
                    itemView.rightButton.hidden = YES;
                    break;
                    
            
                case 2:
                    newPhotosArray[2] = @"0";
                    newPhotosArray[3] = @"0";
                    newPhotosArray[4] = @"0";

                    itemView.centerRightButton.hidden = YES;
                    itemView.rightButton.hidden = YES;
                    break;
                case 3:
                    newPhotosArray[1] = @"0";
                    newPhotosArray[2] = @"0";
                    newPhotosArray[3] = @"0";
                    newPhotosArray[4] = @"0";
                    
                    
                    itemView.centerButton.hidden = YES;
                    itemView.centerRightButton.hidden = YES;
                    itemView.rightButton.hidden = YES;
                    break;
                    
                case 4:
                    newPhotosArray[0] = @"0";
                    newPhotosArray[1] = @"0";
                    newPhotosArray[2] = @"0";
                    newPhotosArray[3] = @"0";
                    newPhotosArray[4] = @"0";
                    
                    itemView.centerLeftButton.hidden = YES;
                    itemView.centerButton.hidden = YES;
                    itemView.centerRightButton.hidden = YES;
                    itemView.rightButton.hidden = YES;
                    break;
                default:
                    break;
            }
            
        }
        
    }
    
}

//========================================================================
#pragma mark - submitItem
// 商品を登録
- (IBAction)submitItem:(id)sender
{
    
    if (![self validationCheck]) {
        return;
    }
    
    
    NSString *itemId = [BSItemAdminViewController getItemId];
    NSLog(@"アイテムid%@",importId);
    [SVProgressHUD showWithStatus:@"商品情報を更新中" maskType:SVProgressHUDMaskTypeClear];
 
    NSString *url = [NSString stringWithFormat:@"%@",apiUrl];
    NSLog(@"geturl:%@",url);
    NSDictionary *parameters = @{
                                @"session_id":[BSUserManager sharedManager].sessionId,
                                @"item_id":[BSItemAdminViewController getItemId],
                                @"title":itemName.text,
                                @"price":price.text,
                                @"detail":detail.text,
                                @"stock":stockLabel1.text,
                                @"inc_variation":[NSString stringWithFormat:@"%d",incVariation1],
                                @"visible":[NSString stringWithFormat:@"%d",visible]
                                };
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/items/edit_item",url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        NSLog(@"items/edit_item: %@",responseObject);
        if ([responseObject objectForKey:@"result"]) {
            [SVProgressHUD dismiss];
            
            [self uploadImage:[responseObject valueForKey:@"result.Item"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}
- (BOOL)uploadImage:(NSDictionary*)resultDict
{


    NSData *imageToUpload;
    NSDictionary *parameters;
    
    BOOL isExistImage;
    int imageNumber = 0;
    uploaded = 0;
    for (int n = 0; n < 5; n++) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"画像をアップロード中"] maskType:SVProgressHUDMaskTypeClear];

        isExistImage = YES;

        switch (n) {
            case 0:
                if (leftButtonImage == nil) {
                    NSLog(@"最新の画像がないよ");
                    isExistImage = NO;
                }
                imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(leftButtonImage , 0.7)];
                
                break;
            case 1:
                if (centerLeftButtonImage == nil) {
                    isExistImage = NO;

                }
                imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(centerLeftButtonImage , 0.7)];
                
                break;
            case 2:
                if (centerButtonImage == nil) {
                    isExistImage = NO;

                }
                
                imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(centerButtonImage , 0.7)];
                break;
            case 3:
                if (centerRightButtonImage == nil) {
                    isExistImage = NO;
                }
                imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(centerRightButtonImage , 0.7)];
                
                break;
            case 4:
                if (rightButtonImage == nil) {
                    isExistImage = NO;
                }
                imageToUpload = [[NSData alloc] initWithData:UIImageJPEGRepresentation(rightButtonImage , 0.7)];
                
                break;
                
            default:
                break;
        }
        
        if (!isExistImage) {
            uploaded++;
            if (imageNumber == 0 && uploaded == 5) {
                [self deleteImages];
            }
            continue;
            NSLog(@"画像がない場合");
        } else {
            imageNumber++;
            newPhotosArray[n] = @"1";
        }
        
        
        parameters = @{@"session_id":[BSUserManager sharedManager].sessionId,
                      @"item_id":[BSItemAdminViewController getItemId],
                      @"image_no":[NSString stringWithFormat:@"%d",imageNumber],
                      //:imageToUpload,
                       };
        
        
        /*
        parameters = @{@"session_id":[BSTutorialViewController sessions],
                       @"item_id":[BSItemAdminViewController getItemId],
                       @"image_no":[NSString stringWithFormat:@"%d",n + 1],
                       };
         */
        
        
        isFinished = NO;

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@items/add_image",apiUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageToUpload name:@"image_file" fileName:[NSString stringWithFormat:@"imageNO%d.jpeg",imageNumber] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            NSLog(@"画像アップロード実装: %@",responseObject);
            NSLog(@"response: %@",[[responseObject valueForKeyPath:@"error.validations.Item.image_file"] objectAtIndex:0]);
            NSLog(@"画像がアップロード番号%d",imageNumber);
            uploaded++;
            if (uploaded == 5) {
                if ([newPhotosArray containsObject:@"0"]) {
                    [self deleteImages];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"更新しました"];
                    [self cancelPhoto];
                }
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            return ;
        }];
    
        
    }

    
    
}
//バリデーションチェック
- (BOOL)validationCheck {
    NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
    [checkCharSet addCharactersInString:@"1234567890"];
    
    if (itemName.text == nil || [itemName.text isEqualToString:@""]) {
        [itemName becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"商品名の入力が正しくありません" message:@"商品名を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if([[price.text stringByTrimmingCharactersInSet:checkCharSet] length] > 0){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
        
    }else if ([price.text intValue] < 50 || [price.text intValue] > 500000){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"50円以上500,000円以下の範囲で金額をご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (price.text == nil || [price.text isEqualToString:@""]){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"価格を数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (visibleVary1 && (self.varyField1.text == nil || [self.varyField1.text isEqualToString:@""])){
        [self.varyField1 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (visibleVary2 && (self.varyField2.text == nil || [self.varyField2.text isEqualToString:@""])){
        [self.varyField2 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (visibleVary3 && (self.varyField3.text == nil || [self.varyField3.text isEqualToString:@""])){
        [self.varyField3 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (visibleVary4 && (self.varyField4.text == nil || [self.varyField4.text isEqualToString:@""])){
        [self.varyField4 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else if (visibleVary5 && (self.varyField5.text == nil || [self.varyField5.text isEqualToString:@""])){
        [self.varyField5 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
    
    NSLog(@"バリデーションチェック");
    
}

//キャンセルボタン
- (void)cancelPhoto
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteItem:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"本当に商品を削除しますか？" delegate:self cancelButtonTitle:@"削除しない" destructiveButtonTitle:nil otherButtonTitles:@"削除する",nil];
    actionSheet.tag = 3;
    [actionSheet showInView:self.view];
}

- (void)deleteItem{
    [SVProgressHUD showWithStatus:@"商品を削除しています" maskType:SVProgressHUDMaskTypeClear];
    

    NSString *itemId = [BSItemAdminViewController getItemId];
    
    NSString *url = [NSString stringWithFormat:@"%@/items/delete_item?session_id=%@&item_id=%@",apiUrl, [BSUserManager sharedManager].sessionId, itemId];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:url];
    NSLog(@"URL:%@",url1);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[url1 absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
   
        NSLog(@"削除商法: %@", responseObject);
        NSString *errorString = [responseObject valueForKeyPath:@"error"];
        NSString *resultString = [responseObject valueForKeyPath:@"result"];
        if (errorString){
            NSDictionary *error = [responseObject valueForKeyPath:@"error"];
            NSString *errorMessage = [error valueForKeyPath:@"message"];
            NSLog(@"エラーメッセージ:%@",errorMessage);
            [SVProgressHUD showErrorWithStatus:@"削除失敗"];
        }
        if (resultString) {
            [SVProgressHUD showSuccessWithStatus:@"商品を削除しました"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"削除失敗しました..."];

    }];
    
    
    
    
}


- (void)deleteImages
{
    
    deleted = 0;
    NSLog(@"画像削除の配列%@",newPhotosArray);
    for (int n = 0; n < newPhotosArray.count; n++) {
        
        if ([newPhotosArray[n] intValue] == 0) {

            NSString *sessionId = [BSUserManager sharedManager].sessionId;
            NSString *itemId = [BSItemAdminViewController getItemId];
            NSLog(@"セッションid:%@",sessionId);
            
            NSString *url = [NSString stringWithFormat:@"%@/items/delete_image?session_id=%@&item_id=%@&image_no=%d",apiUrl, sessionId, itemId,n + 1];
            NSLog(@"items/delete_imag:%@", url);
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url1 = [NSURL URLWithString:url];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager GET:[url1 absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"削除: %@", responseObject);
                [SVProgressHUD showSuccessWithStatus:@"更新しました"];
                deleted++;
                
                if (deleted == 5) {
                    [self cancelPhoto];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [SVProgressHUD showErrorWithStatus:@"削除失敗..."];
            }];
            

        }else{
            deleted++;
            if (deleted == 5) {
                [self cancelPhoto];
                
            }
        }
    }
    
}


- (void)centerCroppingImageWithImage:(UIImage*)img atSize:(CGSize)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    /* 画像のサイズ */
    CGSize imgSize = CGSizeMake(img.size.width * img.scale,
                                img.size.height * img.scale);
    /* トリミングするサイズ */
    CGSize croppingSize = CGSizeMake(size.width * [UIScreen mainScreen].scale,
                                     size.height * [UIScreen mainScreen].scale);
    /* 中央でトリミング */
    CIImage *filteredImage = [ciImage imageByCroppingToRect:CGRectMake(imgSize.width/2.f - croppingSize.width/2.f,
                                                                       imgSize.height/2.f - croppingSize.height/2.f,
                                                                       croppingSize.width,
                                                                       croppingSize.height)];
    /* UIImageに変換する */
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

- (UIImage*)uiImageFromCIImage:(CIImage*)ciImage
{
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO }];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

