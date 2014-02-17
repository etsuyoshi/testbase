//
//  BSAddItemViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSAddItemViewController.h"
#import "SVProgressHUD.h"


@interface BSAddItemViewController ()
//数量変更ボタン
@property (retain, nonatomic) UIButton *stockButton;
@end

@implementation BSAddItemViewController{
    
    NSString *apiUrl;
    //スクロール
    UIScrollView *scrollView;

    //初回起動時カメラ起動
    BOOL isAddedFirstPhoto;
    //写真
    UIImage *takePicture1;
    UIImage *takePicture2;
    UIImage *takePicture3;
    UIImage *takePicture4;
    UIImage *takePicture5;
    
    UIButton *takePictureButton1;
    UIButton *takePictureButton2;
    UIButton *takePictureButton3;
    UIButton *takePictureButton4;
    UIButton *takePictureButton5;
    
    //画像削除ボタン
    UIButton *deleteButton1;
    UIButton *deleteButton2;
    UIButton *deleteButton3;
    UIButton *deleteButton4;
    UIButton *deleteButton5;
    
    //写真ボタンの情報
    UIButton *btnInf;
    
    
    //入力フォーム
    UITextField *itemName;
    UITextField *price;
    UITextView *detail;
    
    //在庫テーブル
    UITableView *stockTable;
    int stock1;
    UILabel *stockLabel1;
    //公開テーブル
    UITableView *openTable;
    int visible;
    //getで在庫数を送るか、バリエーションを送るか
    int incVariation;
    
    //バリエーションテーブル
    UITableView *variationTable1;
    UITableView *variationTable2;
    UITableView *variationTable3;
    UITableView *variationTable4;
    UITableView *variationTable5;
    
    //バリエーション追加ボタン
    UIButton *varyBtn;
    UILabel *addVaryLabel;
    UILabel *varyLabel2;
    UIButton *varyBtn2;
    UILabel *varyLabel3;
    UIButton *varyBtn3;
    UILabel *varyLabel4;
    UIButton *varyBtn4;
    UILabel *varyLabel5;
    UIButton *varyBtn5;
    UILabel *varyLabel6;
    UIButton *varyBtn6;
    
    //バリエーションが表示されているか
    BOOL visibleVary1;
    BOOL visibleVary2;
    BOOL visibleVary3;
    BOOL visibleVary4;
    BOOL visibleVary5;
    
    
    //バリエーションストック
    UILabel *varyStockLabel1;
    UILabel *varyStockLabel2;
    UILabel *varyStockLabel3;
    UILabel *varyStockLabel4;
    UILabel *varyStockLabel5;
    
    //横線
    UIView *line1;
    UIView *line2;
    UIView *line3;
    UIView *line4;
    UIView *line5;
    UIView *line6;
    UIView *line7;
    UIView *line8;
    UIView *line9;
    UIView *line10;
    
    
    //保存、キャンセル
    UIButton *submitButton;
    UIButton *cancelButton;
    UILabel *submitLabel;
    UILabel *cancelLabel;
    
    UITextField *varyField1;
    UITextField *varyField2;
    UITextField *varyField3;
    UITextField *varyField4;
    UITextField *varyField5;
    
    //画像が二列表示か
    BOOL isAdded;
    
    //数量のピッカー
    UIPickerView *stockPicker;
    UIActionSheet *stockActionSheet;
    BOOL pickerIsOpened;
    int buttonTag;
    
    //テキストフィールドにフォーカスした時の座標
    CGPoint svos;

    //入力された情報のバリデーションチェック
    BOOL validation;
    
    //アップロードされる画像
    NSMutableArray *uploadImageArray;
    int upTimes;
    
    //商品の情報
    NSString *jsonItemId;
    
    UISwitch *openSwitch;
    
    //ユーザーエージェント
    NSString *userAgent;
}
@synthesize stockButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}//画面遷移後アクションシートを起動（初回のみ）
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        if (!isAddedFirstPhoto){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"カメラで撮影",@"ライブラリから選択",nil];
            [actionSheet showInView:self.view];
            NSLog(@"viewWillAppear");
        }
    }
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.[
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.trackedViewName = @"addItem";
    
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
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"新規商品追加"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"新規商品追加";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    UIBarButtonItem *leftItemButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhoto)];
    navItem.leftBarButtonItem = leftItemButton;
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height -64)];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];
    }
    
    scrollView.contentSize = CGSizeMake(320, 690);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    [self.view insertSubview:scrollView belowSubview:navBar];
    
    
    
    
    
    //写真追加ボタン
    takePictureButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //[takePictureButton1 setBackgroundImage:simage forState:UIControlStateHighlighted];
    [takePictureButton1 addTarget:self action:@selector(importPhoto:)forControlEvents:UIControlEventTouchUpInside];
    takePictureButton1.frame = CGRectMake(0, 0,80,80);
    takePictureButton1.center = CGPointMake(self.view.center.x / 3, 55);
    takePictureButton1.tag = 1;
    takePictureButton1.hidden = YES;
    [scrollView addSubview:takePictureButton1];
    

    UIImage *simage;
    if ([BSDefaultViewObject isMoreIos7]) {
        simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
    }else{
        simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
    }
    if (!takePicture1){
        takePictureButton1.hidden = NO;
        [takePictureButton1 setBackgroundImage:simage forState:UIControlStateNormal];
    }
    
    
    
    takePictureButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePictureButton2 setBackgroundImage:simage forState:UIControlStateNormal];
    //[takePictureButton1 setBackgroundImage:empImage forState:UIControlStateHighlighted];
    [takePictureButton2 addTarget:self action:@selector(importPhoto:)forControlEvents:UIControlEventTouchUpInside];
    takePictureButton2.frame = CGRectMake(0, 0,80,80);
    takePictureButton2.center = CGPointMake(self.view.center.x, 55);
    takePictureButton2.tag = 2;
    takePictureButton2.hidden = YES;
    [scrollView addSubview:takePictureButton2];
    
    takePictureButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePictureButton3 setBackgroundImage:simage forState:UIControlStateNormal];
    //[takePictureButton1 setBackgroundImage:empImage forState:UIControlStateHighlighted];
    [takePictureButton3 addTarget:self action:@selector(importPhoto:)forControlEvents:UIControlEventTouchUpInside];
    takePictureButton3.frame = CGRectMake(0, 0,80,80);
    takePictureButton3.center = CGPointMake(self.view.center.x * 5 / 3, 55);
    takePictureButton3.tag = 3;
    takePictureButton3.hidden = YES;
    [scrollView addSubview:takePictureButton3];
    
    takePictureButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
    //[takePictureButton1 setBackgroundImage:empImage forState:UIControlStateHighlighted];
    [takePictureButton4 addTarget:self action:@selector(importPhoto:)forControlEvents:UIControlEventTouchUpInside];
    takePictureButton4.frame = CGRectMake(0, 0,80,80);
    takePictureButton4.center = CGPointMake(self.view.center.x / 3, 152.5);
    takePictureButton4.tag = 4;
    takePictureButton4.hidden = YES;
    [scrollView addSubview:takePictureButton4];
    
    takePictureButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
    //[takePictureButton1 setBackgroundImage:empImage forState:UIControlStateHighlighted];
    [takePictureButton5 addTarget:self action:@selector(importPhoto:)forControlEvents:UIControlEventTouchUpInside];
    takePictureButton5.frame = CGRectMake(0, 0,80,80);
    takePictureButton5.center = CGPointMake(self.view.center.x, 152.5);
    takePictureButton5.tag = 5;
    takePictureButton5.hidden = YES;
    [scrollView addSubview:takePictureButton5];
    
    
    //写真削除ボタン
    
    UIImage *deleteImage = [UIImage imageNamed:@"delete"];
    
    deleteButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton1.frame = CGRectMake( 0,  0, 35, 35);
    deleteButton1.center = CGPointMake( 95, 15);
    deleteButton1.tag = 1;
    [deleteButton1 setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton1 setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
    deleteButton1.hidden = YES;
    [deleteButton1 addTarget:self action:@selector(deletePhoto:)forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:deleteButton1];
    
    [deleteButton2 removeFromSuperview];
    deleteButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton2.frame = CGRectMake( 0,  0, 35, 35);
    deleteButton2.center = CGPointMake( 200, 15);
    deleteButton2.tag = 2;
    [deleteButton2 setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton2 setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
    deleteButton2.hidden = YES;
    [deleteButton2 addTarget:self action:@selector(deletePhoto:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deleteButton2];
    
    [deleteButton3 removeFromSuperview];
    deleteButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton3.frame = CGRectMake( 0,  0, 35, 35);
    deleteButton3.center = CGPointMake( 305, 15);
    deleteButton3.tag = 3;
    [deleteButton3 setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton3 setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
    deleteButton3.hidden = YES;
    [deleteButton3 addTarget:self action:@selector(deletePhoto:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deleteButton3];
    
    [deleteButton4 removeFromSuperview];
    deleteButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton4.frame = CGRectMake( 0,  0, 35, 35);
    deleteButton4.center = CGPointMake( 95, 110);
    deleteButton4.tag = 4;
    [deleteButton4 setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton4 setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
    deleteButton4.hidden = YES;
    [deleteButton4 addTarget:self action:@selector(deletePhoto:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deleteButton4];
    
    
    [deleteButton5 removeFromSuperview];
    deleteButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton5.frame = CGRectMake( 0,  0, 35, 35);
    deleteButton5.center = CGPointMake( 200, 110);
    deleteButton5.tag = 5;
    [deleteButton5 setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton5 setBackgroundImage:deleteImage forState:UIControlStateHighlighted];
    deleteButton5.hidden = YES;
    [deleteButton5 addTarget:self action:@selector(deletePhoto:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deleteButton5];
    
    
    //入力フォーム
    //商品名
    itemName = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
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
    
    
    //価格
    price = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, 250, 40)];
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
    detail = [[UITextView alloc] initWithFrame:CGRectMake(10, 210, 300, 150)];
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
    stockTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 370, 320, 45) style:UITableViewStyleGrouped];
    stockTable.dataSource = self;
    stockTable.delegate = self;
    stockTable.tag = 1;
    stockTable.backgroundView = nil;
    stockTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:stockTable];
    incVariation = 0;
    
    
    //公開テーブル
    openTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 455, 320, 45) style:UITableViewStyleGrouped];
    openTable.dataSource = self;
    openTable.delegate = self;
    openTable.tag = 1;
    openTable.backgroundView = nil;
    openTable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:openTable];
    
    //公開ボタン（スイッチ)
    openSwitch = [[UISwitch alloc] init];
    openSwitch.center = CGPointMake(255, 478);
    openSwitch.transform = CGAffineTransformMakeScale(1.2, 1.2);
    openSwitch.on = YES;
    
    [openSwitch addTarget:self action:@selector(switchcontroll:)
         forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:openSwitch];
    visible = 1; //1:公開 2:非公開
    
    
    //バリエーションテーブル1
    variationTable1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 370, 320, 90) style:UITableViewStyleGrouped];
    variationTable1.dataSource = self;
    variationTable1.delegate = self;
    variationTable1.tag = 1;
    variationTable1.backgroundView = nil;
    variationTable1.backgroundColor = [UIColor clearColor];
    
    //バリエーションテーブル2
    variationTable2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 521, 320, 90) style:UITableViewStyleGrouped];
    variationTable2.dataSource = self;
    variationTable2.delegate = self;
    variationTable2.tag = 1;
    variationTable2.backgroundView = nil;
    variationTable2.backgroundColor = [UIColor clearColor];
    
    //バリエーションテーブル3
    variationTable3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 671, 320, 90) style:UITableViewStyleGrouped];
    variationTable3.dataSource = self;
    variationTable3.delegate = self;
    variationTable3.tag = 1;
    variationTable3.backgroundView = nil;
    variationTable3.backgroundColor = [UIColor clearColor];
    
    //バリエーションテーブル4
    variationTable4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 821, 320, 90) style:UITableViewStyleGrouped];
    variationTable4.dataSource = self;
    variationTable4.delegate = self;
    variationTable4.tag = 1;
    variationTable4.backgroundView = nil;
    variationTable4.backgroundColor = [UIColor clearColor];
    
    //バリエーションテーブル5
    variationTable5 = [[UITableView alloc] initWithFrame:CGRectMake(0, 971, 320, 90) style:UITableViewStyleGrouped];
    variationTable5.dataSource = self;
    variationTable5.delegate = self;
    variationTable5.tag = 1;
    variationTable5.backgroundView = nil;
    variationTable5.backgroundColor = [UIColor clearColor];
    
    
    
    
    //バリエーションのテキストボタン
    addVaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,425,200,20)];
    addVaryLabel.text = @"バリエーションを追加する";
    addVaryLabel.font = [UIFont systemFontOfSize:13];
    addVaryLabel.backgroundColor = [UIColor clearColor];
    addVaryLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:addVaryLabel];
    
    UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
    stirngUnderLine.backgroundColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [addVaryLabel addSubview:stirngUnderLine];
    
    varyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    varyBtn.frame = CGRectMake(20,425,300,20);
    varyBtn.backgroundColor = [UIColor clearColor];
    [varyBtn addTarget:self
                action:@selector(addValue:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:varyBtn];
    
    
    
    
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
    [submitButton addTarget:self action:@selector(submitPhoto:)forControlEvents:UIControlEventTouchUpInside];
    submitButton.center = CGPointMake(160, 560);
    [scrollView addSubview:submitButton];
    
    //「保存する」ラベル
    submitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    submitLabel.text = @"保存する";
    submitLabel.textAlignment = NSTextAlignmentCenter;
    submitLabel.center = CGPointMake(160, 560);
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
    cancelButton.center = CGPointMake(160, 630);
    [scrollView addSubview:cancelButton];
    
    //「キャンセル」ラベル
    cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    cancelLabel.text = @"キャンセル";
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.center = CGPointMake(160, 630);
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
    
    /*
    
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    [attribute setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [attribute setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)] forKey:UITextAttributeTextShadowOffset];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attribute forState:UIControlStateNormal];
    */
    
    
}





/*************************************テーブルビュー*************************************/


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
    }
    if (tableView == stockTable){
        self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
        self.stockButton.backgroundColor = [UIColor clearColor];
        [self.stockButton addTarget:self
                             action:@selector(selectNumber:)
                   forControlEvents:UIControlEventTouchDown];
        self.stockButton.tag =  1;
        cell.textLabel.text = @"在庫数";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.stockButton];
        
        //数量ラベル1
        stock1 = 1;
        stockLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
        stockLabel1.text = [NSString stringWithFormat:@"%d", stock1];
        stockLabel1.textAlignment = NSTextAlignmentCenter;
        stockLabel1.font = [UIFont boldSystemFontOfSize:20];
        stockLabel1.shadowColor = [UIColor whiteColor];
        stockLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
        stockLabel1.backgroundColor = [UIColor clearColor];
        stockLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell addSubview:stockLabel1];
        
    }else if (tableView == openTable){
        cell.textLabel.text = @"公開する";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }else if (tableView == variationTable1){
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    
                    varyField1 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 14.0, 280.0, 50.0)];
                    if ([BSDefaultViewObject isMoreIos7]) {
                        varyField1.center = CGPointMake(154,cell.frame.size.height / 2);
                    }
                    varyField1.returnKeyType = UIReturnKeyDone;
                    varyField1.placeholder = @"サイズ：S";
                    varyField1.delegate = self;
                    varyField1.backgroundColor = [UIColor clearColor];
                    [varyField1 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [cell addSubview:varyField1];
                }else{
                    self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
                    self.stockButton.backgroundColor = [UIColor clearColor];
                    [self.stockButton addTarget:self
                                         action:@selector(selectNumber:)
                               forControlEvents:UIControlEventTouchDown];
                    self.stockButton.tag = 2;
                    cell.textLabel.text = @"数量";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.stockButton];
                    
                    //数量ラベル2
                    varyStockLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
                    varyStockLabel1.text = [NSString stringWithFormat:@"%d", 1];
                    varyStockLabel1.textAlignment = NSTextAlignmentCenter;
                    varyStockLabel1.font = [UIFont boldSystemFontOfSize:20];
                    varyStockLabel1.shadowColor = [UIColor whiteColor];
                    varyStockLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
                    varyStockLabel1.backgroundColor = [UIColor clearColor];
                    varyStockLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
                    [cell addSubview:varyStockLabel1];
                    
                    
                }
                break;
            default:
                break;
        }
        
        
    }else if (tableView == variationTable2){
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    varyField2 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 14.0, 280.0, 50.0)];
                    if ([BSDefaultViewObject isMoreIos7]) {
                        varyField2.center = CGPointMake(154,cell.frame.size.height / 2);
                    }
                    varyField2.returnKeyType = UIReturnKeyDone;
                    varyField2.placeholder = @"サイズ：S";
                    varyField2.delegate = self;
                    varyField2.backgroundColor = [UIColor clearColor];
                    [varyField2 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [cell addSubview:varyField2];
                }else{
                    self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
                    self.stockButton.backgroundColor = [UIColor clearColor];
                    [self.stockButton addTarget:self
                                         action:@selector(selectNumber:)
                               forControlEvents:UIControlEventTouchDown];
                    self.stockButton.tag = 3;
                    
                    cell.textLabel.text = @"数量";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.stockButton];
                    
                    //数量ラベル3
                    varyStockLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
                    varyStockLabel2.text = [NSString stringWithFormat:@"%d", 1];
                    varyStockLabel2.textAlignment = NSTextAlignmentCenter;
                    varyStockLabel2.font = [UIFont boldSystemFontOfSize:20];
                    varyStockLabel2.shadowColor = [UIColor whiteColor];
                    varyStockLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
                    varyStockLabel2.backgroundColor = [UIColor clearColor];
                    varyStockLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
                    [cell addSubview:varyStockLabel2];
                }
                break;
            default:
                break;
        }
        
        
    }else if (tableView == variationTable3){
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    varyField3 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 14.0, 280.0, 50.0)];
                    if ([BSDefaultViewObject isMoreIos7]) {
                        varyField3.center = CGPointMake(154,cell.frame.size.height / 2);
                    }
                    varyField3.returnKeyType = UIReturnKeyDone;
                    varyField3.placeholder = @"サイズ：S";
                    varyField3.delegate = self;
                    varyField3.backgroundColor = [UIColor clearColor];
                    [varyField3 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [cell addSubview:varyField3];
                }else{
                    self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
                    self.stockButton.backgroundColor = [UIColor clearColor];
                    [self.stockButton addTarget:self
                                         action:@selector(selectNumber:)
                               forControlEvents:UIControlEventTouchDown];
                    self.stockButton.tag = 4;
                    
                    cell.textLabel.text = @"数量";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.stockButton];
                    
                    //数量ラベル4
                    varyStockLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
                    varyStockLabel3.text = [NSString stringWithFormat:@"%d", 1];
                    varyStockLabel3.textAlignment = NSTextAlignmentCenter;
                    varyStockLabel3.font = [UIFont boldSystemFontOfSize:20];
                    varyStockLabel3.shadowColor = [UIColor whiteColor];
                    varyStockLabel3.shadowOffset = CGSizeMake(0.f, 1.f);
                    varyStockLabel3.backgroundColor = [UIColor clearColor];
                    varyStockLabel3.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
                    [cell addSubview:varyStockLabel3];
                    
                    
                }
                break;
            default:
                break;
        }
        
        
    }else if (tableView == variationTable4){
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    varyField4 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 14.0, 280.0, 50.0)];
                    if ([BSDefaultViewObject isMoreIos7]) {
                        varyField4.center = CGPointMake(154,cell.frame.size.height / 2);
                    }
                    varyField4.returnKeyType = UIReturnKeyDone;
                    varyField4.placeholder = @"サイズ：S";
                    varyField4.delegate = self;
                    varyField4.backgroundColor = [UIColor clearColor];
                    [varyField4 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [cell addSubview:varyField4];
                }else{
                    self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
                    self.stockButton.backgroundColor = [UIColor clearColor];
                    [self.stockButton addTarget:self
                                         action:@selector(selectNumber:)
                               forControlEvents:UIControlEventTouchDown];
                    self.stockButton.tag = 5;
                    
                    cell.textLabel.text = @"数量";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.stockButton];
                    
                    //数量ラベル5
                    varyStockLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
                    varyStockLabel4.text = [NSString stringWithFormat:@"%d", 1];
                    varyStockLabel4.textAlignment = NSTextAlignmentCenter;
                    varyStockLabel4.font = [UIFont boldSystemFontOfSize:20];
                    varyStockLabel4.shadowColor = [UIColor whiteColor];
                    varyStockLabel4.shadowOffset = CGSizeMake(0.f, 1.f);
                    varyStockLabel4.backgroundColor = [UIColor clearColor];
                    varyStockLabel4.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
                    [cell addSubview:varyStockLabel4];
                }
                break;
            default:
                break;
        }
        
        
    }else if (tableView == variationTable5){
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    varyField5 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 14.0, 280.0, 50.0)];
                    if ([BSDefaultViewObject isMoreIos7]) {
                        varyField5.center = CGPointMake(154,cell.frame.size.height / 2);
                    }
                    varyField5.returnKeyType = UIReturnKeyDone;
                    varyField5.placeholder = @"サイズ：S";
                    varyField5.delegate = self;
                    varyField5.backgroundColor = [UIColor clearColor];
                    [varyField5 setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [cell addSubview:varyField5];
                }else{
                    self.stockButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 2.0, 280.0, 40.0)];
                    self.stockButton.backgroundColor = [UIColor clearColor];
                    [self.stockButton addTarget:self
                                         action:@selector(selectNumber:)
                               forControlEvents:UIControlEventTouchDown];
                    self.stockButton.tag = 6;
                    cell.textLabel.text = @"数量";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.stockButton];
                    
                    //数量ラベル6
                    varyStockLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(200, -1,120,50)];
                    varyStockLabel5.text = [NSString stringWithFormat:@"%d", 1];
                    varyStockLabel5.textAlignment = NSTextAlignmentCenter;
                    varyStockLabel5.font = [UIFont boldSystemFontOfSize:20];
                    varyStockLabel5.shadowColor = [UIColor whiteColor];
                    varyStockLabel5.shadowOffset = CGSizeMake(0.f, 1.f);
                    varyStockLabel5.backgroundColor = [UIColor clearColor];
                    varyStockLabel5.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
                    [cell addSubview:varyStockLabel5];
                }
                break;
            default:
                break;
        }
        
        
    }
    return cell;
}



/************************************テーブルビュー************************/




/********************************写真追加**********************************/
- (IBAction)importPhoto:(id)sender
{
    btnInf = (UIButton*)sender;
    NSLog(@"%d",btnInf.tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"カメラで撮影",@"ライブラリから選択",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    NSLog(@"OK");
}


////////////////////////////////////////////////////
//アクションシートの分岐（カメラ起動orライブラリorキャンセル）
////////////////////////////////////////////////////
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
        case 2: //商品管理に戻る
            if (btnInf == NULL){
                NSLog(@"キャンセルしたよ！");
                [self dismissViewControllerAnimated:NO completion:nil];
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
}
////////////////////////////////////////////////////
//カメラ終了後の処理
////////////////////////////////////////////////////
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    isAddedFirstPhoto = YES;
    //取得した画像をviewに表示
    if (btnInf.tag == 2){
        
        takePicture2 = info[UIImagePickerControllerEditedImage];
        [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
        
        //デリートボタン
        deleteButton2.hidden = NO;
        
        
        //三番目の写真追加ボタンを表示
        if (!takePicture3) {
            UIImage *simage;
            if ([BSDefaultViewObject isMoreIos7]) {
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }else{
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }
            [takePictureButton3 setBackgroundImage:simage forState:UIControlStateNormal];
            takePictureButton3.hidden = NO;
        }
        
    } else if (btnInf.tag == 3){
        takePicture3 = info[UIImagePickerControllerEditedImage];
        [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
        
        
        
        //デリートボタン
        deleteButton3.hidden = NO;
        
        
        //4番目の写真追加ボタンを表示
        if (!takePicture4) {
            UIImage *simage;
            if ([BSDefaultViewObject isMoreIos7]) {
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }else{
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }
            [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
            takePictureButton4.hidden = NO;
        }
        if (!isAdded) {
            
            
            float yPoint = 97.5f;
            int movePoint = 150;
            
            line1.frame = CGRectMake(0,line1.frame.origin.y + yPoint,320,1);
            line2.frame = CGRectMake(0,line2.frame.origin.y + yPoint,320,1);
            line3.frame = CGRectMake(0,line1.frame.origin.y + movePoint,320,1);
            line4.frame = CGRectMake(0,line2.frame.origin.y + movePoint,320,1);
            line5.frame = CGRectMake(0,line3.frame.origin.y + movePoint,320,1);
            line6.frame = CGRectMake(0,line4.frame.origin.y + movePoint,320,1);
            line7.frame = CGRectMake(0,line5.frame.origin.y + movePoint,320,1);
            line8.frame = CGRectMake(0,line6.frame.origin.y + movePoint,320,1);
            line9.frame = CGRectMake(0,line7.frame.origin.y + movePoint,320,1);
            line10.frame = CGRectMake(0,line8.frame.origin.y + movePoint,320,1);
            
            
            
            
            varyLabel2.frame = CGRectMake(20,varyLabel2.frame.origin.y + yPoint,200,20);
            varyBtn2.frame = CGRectMake(20,varyBtn2.frame.origin.y + yPoint,300,20);
            varyLabel3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,200,20);
            varyBtn3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,300,20);
            varyLabel4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,200,20);
            varyBtn4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,300,20);
            varyLabel5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,200,20);
            varyBtn5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,300,20);
            varyLabel6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,200,20);
            varyBtn6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,300,20);
            
            itemName.frame = CGRectMake(10, itemName.frame.origin.y + yPoint, 300, 40);
            price.frame = CGRectMake(10, price.frame.origin.y + yPoint, 250, 40);
            detail.frame = CGRectMake(10, detail.frame.origin.y + yPoint, 300, 150);
            stockTable.frame = CGRectMake(0, stockTable.frame.origin.y + yPoint, 320, 45);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + yPoint, 320, 45);
            variationTable1.frame = CGRectMake(0, variationTable1.frame.origin.y + yPoint, 320, 90);
            variationTable2.frame = CGRectMake(0, variationTable2.frame.origin.y + yPoint, 320, 90);
            variationTable3.frame = CGRectMake(0, variationTable3.frame.origin.y + yPoint, 320, 90);
            variationTable4.frame = CGRectMake(0, variationTable4.frame.origin.y + yPoint, 320, 90);
            variationTable5.frame = CGRectMake(0, variationTable5.frame.origin.y + yPoint, 320, 90);
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + yPoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y +yPoint,200,20);
            openSwitch.center = CGPointMake(openSwitch.center.x, openSwitch.center.y + yPoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + yPoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + yPoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + yPoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + yPoint);
            scrollView.contentSize = CGSizeMake(320, scrollView.contentSize.height + yPoint);
            
            
            
            isAdded = YES;
        }
        
        
    }else if(btnInf.tag == 4){
        takePicture4 = info[UIImagePickerControllerEditedImage];
        [takePictureButton4 setBackgroundImage:takePicture4 forState:UIControlStateNormal];
        
        
        //デリートボタン
        deleteButton4.hidden = NO;
        
        //5番目の写真追加ボタンを表示
        if (!takePicture5) {
            UIImage *simage;
            if ([BSDefaultViewObject isMoreIos7]) {
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }else{
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }
            [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
            takePictureButton5.hidden = NO;
            
        }
    }else if(btnInf.tag == 5){
        
        takePicture5 = info[UIImagePickerControllerEditedImage];
        [takePictureButton5 setBackgroundImage:takePicture5 forState:UIControlStateNormal];
        
        //デリートボタン
        deleteButton5.hidden = NO;
        
    }else{
        UIImageWriteToSavedPhotosAlbum(takePicture1, self, NULL, NULL);
        
        takePicture1 = info[UIImagePickerControllerEditedImage];
        [takePictureButton1 setBackgroundImage:takePicture1 forState:UIControlStateNormal];
        
        //デリートボタン
        deleteButton1.hidden = NO;
        
        if (!takePicture2) {
            UIImage *simage;
            if ([BSDefaultViewObject isMoreIos7]) {
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }else{
                simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
            }
            [takePictureButton2 setBackgroundImage:simage forState:UIControlStateNormal];
            takePictureButton2.hidden = NO;
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//写真削除
- (IBAction)deletePhoto:(id)sender
{
    /*
     if (!getImageDone) {
     for (int n = 0; n < importImageArray.count; n++) {
     if (n == 0) {
     takePicture1 = imageView1.image;
     }else if (n == 1){
     takePicture2 = imageView2.image;
     }else if (n == 2){
     takePicture3 = imageView3.image;
     }else if (n == 3){
     takePicture4 = imageView4.image;
     }else if (n == 4){
     takePicture5 = imageView5.image;
     }
     }
     getImageDone = YES;
     }
     
     */
    
    NSLog(@"写真を削除するよ");
    if ([sender tag] == 1){
        NSLog(@"撮り直すよ！");
        if (!takePicture2) {
            //1枚目を空にする
            takePicture1 = NULL;
            deleteButton1.hidden = YES;
            
            if (!takePicture1) {
                //2番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton1 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //2枚目を空にする
            takePictureButton2.hidden = YES;
            deleteButton2.hidden = YES;
            
        }else if (takePicture2 && !takePicture3) {
            //2枚目の画像を1番目に持ってくる
            takePicture1 = NULL;
            takePicture1 = takePicture2;
            [takePictureButton1 setBackgroundImage:takePicture1 forState:UIControlStateNormal];
            //2枚目を空にする
            takePicture2 = NULL;
            deleteButton2.hidden = YES;
            
            if (!takePicture2) {
                //2番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton2 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //3枚目を空にする
            takePictureButton3.hidden = YES;
            deleteButton3.hidden = YES;
            
        }else if (takePicture2 && takePicture3 && !takePicture4 && !takePicture5){
            NSLog(@"移し替えるよ");
            
            //2枚目の画像を1番目に持ってくる
            takePicture1 = NULL;
            takePicture1 = takePicture2;
            [takePictureButton1 setBackgroundImage:takePicture1 forState:UIControlStateNormal];
            
            
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            //三枚目を空にする
            takePicture3 = NULL;
            deleteButton3.hidden = YES;
            
            if (!takePicture3) {
                //3番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton3 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //4枚目を空にする
            takePicture4 = NULL;
            takePictureButton4.hidden = YES;
            deleteButton4.hidden = YES;
            
            //座標を元に戻す
            float yPoint = -97.5f;
            if (isAdded) {
                itemName.frame = CGRectMake(10, itemName.frame.origin.y + yPoint, 300, 40);
                price.frame = CGRectMake(10, price.frame.origin.y + yPoint, 250, 40);
                detail.frame = CGRectMake(10, detail.frame.origin.y + yPoint, 300, 150);
                stockTable.frame = CGRectMake(0, stockTable.frame.origin.y + yPoint, 320, 45);
                openTable.frame = CGRectMake(0, openTable.frame.origin.y + yPoint, 320, 45);
                variationTable1.frame = CGRectMake(0, variationTable1.frame.origin.y + yPoint, 320, 90);
                variationTable2.frame = CGRectMake(0, variationTable2.frame.origin.y + yPoint, 320, 90);
                variationTable3.frame = CGRectMake(0, variationTable3.frame.origin.y + yPoint, 320, 90);
                variationTable4.frame = CGRectMake(0, variationTable4.frame.origin.y + yPoint, 320, 90);
                variationTable5.frame = CGRectMake(0, variationTable5.frame.origin.y + yPoint, 320, 90);
                addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + yPoint,200,20);
                varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y +yPoint,200,20);
                openSwitch.center = CGPointMake(openSwitch.center.x, openSwitch.center.y + yPoint);
                submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + yPoint);
                submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + yPoint);
                cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + yPoint);
                cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + yPoint);
                scrollView.contentSize = CGSizeMake(320, scrollView.contentSize.height + yPoint);
                
                //バリエーションが一つでも表示されていた場合
                if (visibleVary1) {
                    
                    
                    //横線とバリエーション削除ボタンの位置を変更
                    int movePoint = 150;
                    
                    line1.frame = CGRectMake(0,505 ,320,1);
                    line2.frame = CGRectMake(0,506 ,320,1);
                    
                    varyLabel2.frame = CGRectMake(20,470 ,200,20);
                    varyBtn2.frame = CGRectMake(20,470 ,300,20);
                    
                    
                    //line1.frame = CGRectMake(0,line1.frame.origin.y + yPoint,320,1);
                    //line2.frame = CGRectMake(0,line2.frame.origin.y + yPoint,320,1);
                    line3.frame = CGRectMake(0,line1.frame.origin.y + movePoint,320,1);
                    line4.frame = CGRectMake(0,line2.frame.origin.y + movePoint,320,1);
                    line5.frame = CGRectMake(0,line3.frame.origin.y + movePoint,320,1);
                    line6.frame = CGRectMake(0,line4.frame.origin.y + movePoint,320,1);
                    line7.frame = CGRectMake(0,line5.frame.origin.y + movePoint,320,1);
                    line8.frame = CGRectMake(0,line6.frame.origin.y + movePoint,320,1);
                    line9.frame = CGRectMake(0,line7.frame.origin.y + movePoint,320,1);
                    line10.frame = CGRectMake(0,line8.frame.origin.y + movePoint,320,1);
                    
                    //varyLabel2.frame = CGRectMake(20,varyLabel2.frame.origin.y + yPoint,200,20);
                    //varyBtn2.frame = CGRectMake(20,varyBtn2.frame.origin.y + yPoint,300,20);
                    varyLabel3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,200,20);
                    varyBtn3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,300,20);
                    varyLabel4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,200,20);
                    varyBtn4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,300,20);
                    varyLabel5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,200,20);
                    varyBtn5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,300,20);
                    varyLabel6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,200,20);
                    varyBtn6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,300,20);
                    
                }
                
                isAdded = NO;
            }
            
            
            
        }else if (takePicture2 && takePicture3 && takePicture4 && !takePicture5){
            
            //2枚目の画像を1番目に持ってくる
            takePicture1 = NULL;
            takePicture1 = takePicture2;
            [takePictureButton1 setBackgroundImage:takePicture1 forState:UIControlStateNormal];
            
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            
            
            //四番目を三番目に持ってくる
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            //4枚目を空にする
            takePicture4 = NULL;
            deleteButton4.enabled = NO;
            deleteButton4.hidden = YES;
            
            
            
            if (!takePicture4) {
                //4番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            //5番目を削除
            takePictureButton5.enabled = NO;
            takePictureButton5.hidden = YES;
            deleteButton5.enabled = NO;
            deleteButton5.hidden = YES;
            
        }else if (takePicture2 && takePicture3 && takePicture4 && takePicture5){
            //2枚目の画像を1番目に持ってくる
            takePicture1 = NULL;
            takePicture1 = takePicture2;
            [takePictureButton1 setBackgroundImage:takePicture1 forState:UIControlStateNormal];
            
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            
            //四番目を三番目に持ってくる
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            //5番目を4番目に持ってくる
            takePicture4 = NULL;
            takePicture4 = takePicture5;
            [takePictureButton4 setBackgroundImage:takePicture4 forState:UIControlStateNormal];
            
            //5枚目を空にする
            takePicture5 = NULL;
            deleteButton5.enabled = NO;
            deleteButton5.hidden = YES;
            
            
            if (!takePicture5) {
                //5目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
                
            }
            
        }
    }else if ([sender tag] == 2){
        if (!takePicture3) {
            //2枚目を空にする
            takePicture2 = NULL;
            deleteButton2.enabled = NO;
            deleteButton2.hidden = YES;
            
            if (!takePicture2) {
                //2番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton2 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //3枚目を空にする
            takePictureButton3.enabled = NO;
            takePictureButton3.hidden = YES;
            deleteButton3.enabled = NO;
            deleteButton3.hidden = YES;
            
        }else if (takePicture3 && !takePicture4 && !takePicture5){
            NSLog(@"移し替えるよ");
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            //三枚目を空にする
            takePicture3 = NULL;
            deleteButton3.enabled = NO;
            deleteButton3.hidden = YES;
            
            if (!takePicture3) {
                //3番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton3 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //4枚目を空にする
            takePicture4 = NULL;
            takePictureButton4.enabled = NO;
            takePictureButton4.hidden = YES;
            deleteButton4.enabled = NO;
            deleteButton4.hidden = YES;
            
            //座標を元に戻す
            float yPoint = -97.5f;
            if (isAdded) {
                itemName.frame = CGRectMake(10, itemName.frame.origin.y + yPoint, 300, 40);
                price.frame = CGRectMake(10, price.frame.origin.y + yPoint, 250, 40);
                detail.frame = CGRectMake(10, detail.frame.origin.y + yPoint, 300, 150);
                stockTable.frame = CGRectMake(0, stockTable.frame.origin.y + yPoint, 320, 45);
                openTable.frame = CGRectMake(0, openTable.frame.origin.y + yPoint, 320, 45);
                variationTable1.frame = CGRectMake(0, variationTable1.frame.origin.y + yPoint, 320, 90);
                variationTable2.frame = CGRectMake(0, variationTable2.frame.origin.y + yPoint, 320, 90);
                variationTable3.frame = CGRectMake(0, variationTable3.frame.origin.y + yPoint, 320, 90);
                variationTable4.frame = CGRectMake(0, variationTable4.frame.origin.y + yPoint, 320, 90);
                variationTable5.frame = CGRectMake(0, variationTable5.frame.origin.y + yPoint, 320, 90);
                addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + yPoint,200,20);
                varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y +yPoint,200,20);
                openSwitch.center = CGPointMake(openSwitch.center.x, openSwitch.center.y + yPoint);
                submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + yPoint);
                submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + yPoint);
                cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + yPoint);
                cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + yPoint);
                scrollView.contentSize = CGSizeMake(320, scrollView.contentSize.height + yPoint);
                
                //バリエーションが一つでも表示されていた場合
                if (visibleVary1) {
                    
                    
                    //横線とバリエーション削除ボタンの位置を変更
                    int movePoint = 150;
                    
                    line1.frame = CGRectMake(0,505 ,320,1);
                    line2.frame = CGRectMake(0,506 ,320,1);
                    
                    varyLabel2.frame = CGRectMake(20,470 ,200,20);
                    varyBtn2.frame = CGRectMake(20,470 ,300,20);
                    
                    
                    //line1.frame = CGRectMake(0,line1.frame.origin.y + yPoint,320,1);
                    //line2.frame = CGRectMake(0,line2.frame.origin.y + yPoint,320,1);
                    line3.frame = CGRectMake(0,line1.frame.origin.y + movePoint,320,1);
                    line4.frame = CGRectMake(0,line2.frame.origin.y + movePoint,320,1);
                    line5.frame = CGRectMake(0,line3.frame.origin.y + movePoint,320,1);
                    line6.frame = CGRectMake(0,line4.frame.origin.y + movePoint,320,1);
                    line7.frame = CGRectMake(0,line5.frame.origin.y + movePoint,320,1);
                    line8.frame = CGRectMake(0,line6.frame.origin.y + movePoint,320,1);
                    line9.frame = CGRectMake(0,line7.frame.origin.y + movePoint,320,1);
                    line10.frame = CGRectMake(0,line8.frame.origin.y + movePoint,320,1);
                    
                    //varyLabel2.frame = CGRectMake(20,varyLabel2.frame.origin.y + yPoint,200,20);
                    //varyBtn2.frame = CGRectMake(20,varyBtn2.frame.origin.y + yPoint,300,20);
                    varyLabel3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,200,20);
                    varyBtn3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,300,20);
                    varyLabel4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,200,20);
                    varyBtn4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,300,20);
                    varyLabel5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,200,20);
                    varyBtn5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,300,20);
                    varyLabel6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,200,20);
                    varyBtn6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,300,20);
                    
                }
                
                isAdded = NO;
            }
            
            
            
        }else if (takePicture3 && takePicture4 && !takePicture5){
            
            
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            
            
            //四番目を三番目に持ってくる
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            //4枚目を空にする
            takePicture4 = NULL;
            deleteButton4.hidden = YES;
            
            
            
            if (!takePicture4) {
                //4番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            //5番目を削除
            takePictureButton5.hidden = YES;
            deleteButton5.hidden = YES;
            
        }else if (takePicture3 && takePicture4 && takePicture5){
            
            //三枚目の画像を二番目に持ってくる
            takePicture2 = NULL;
            takePicture2 = takePicture3;
            [takePictureButton2 setBackgroundImage:takePicture2 forState:UIControlStateNormal];
            
            
            //四番目を三番目に持ってくる
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            //5番目を4番目に持ってくる
            takePicture4 = NULL;
            takePicture4 = takePicture5;
            [takePictureButton4 setBackgroundImage:takePicture4 forState:UIControlStateNormal];
            
            //5枚目を空にする
            takePicture5 = NULL;
            deleteButton5.hidden = YES;
            
            
            if (!takePicture5) {
                //5目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
                
            }
            
        }
    }else if ([sender tag] == 3){
        if (!takePicture4) {
            takePicture3 = NULL;
            deleteButton3.hidden = YES;
            
            takePictureButton4.hidden = YES;
            
            if (!takePicture3) {
                //3番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                
                [takePictureButton3 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
            //座標を元に戻す
            float yPoint = -97.5f;
            if (isAdded) {
                itemName.frame = CGRectMake(10, itemName.frame.origin.y + yPoint, 300, 40);
                price.frame = CGRectMake(10, price.frame.origin.y + yPoint, 250, 40);
                detail.frame = CGRectMake(10, detail.frame.origin.y + yPoint, 300, 150);
                stockTable.frame = CGRectMake(0, stockTable.frame.origin.y + yPoint, 320, 45);
                openTable.frame = CGRectMake(0, openTable.frame.origin.y + yPoint, 320, 45);
                variationTable1.frame = CGRectMake(0, variationTable1.frame.origin.y + yPoint, 320, 90);
                variationTable2.frame = CGRectMake(0, variationTable2.frame.origin.y + yPoint, 320, 90);
                variationTable3.frame = CGRectMake(0, variationTable3.frame.origin.y + yPoint, 320, 90);
                variationTable4.frame = CGRectMake(0, variationTable4.frame.origin.y + yPoint, 320, 90);
                variationTable5.frame = CGRectMake(0, variationTable5.frame.origin.y + yPoint, 320, 90);
                addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + yPoint,200,20);
                varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y +yPoint,200,20);
                openSwitch.center = CGPointMake(openSwitch.center.x, openSwitch.center.y + yPoint);
                submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + yPoint);
                submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + yPoint);
                cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + yPoint);
                cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + yPoint);
                scrollView.contentSize = CGSizeMake(320, scrollView.contentSize.height + yPoint);
                
                //バリエーションが一つでも表示されていた場合
                if (visibleVary1) {
                    
                    
                    //横線とバリエーション削除ボタンの位置を変更
                    int movePoint = 150;
                    
                    line1.frame = CGRectMake(0,505 ,320,1);
                    line2.frame = CGRectMake(0,506 ,320,1);
                    
                    varyLabel2.frame = CGRectMake(20,470 ,200,20);
                    varyBtn2.frame = CGRectMake(20,470 ,300,20);
                    
                    
                    //line1.frame = CGRectMake(0,line1.frame.origin.y + yPoint,320,1);
                    //line2.frame = CGRectMake(0,line2.frame.origin.y + yPoint,320,1);
                    line3.frame = CGRectMake(0,line1.frame.origin.y + movePoint,320,1);
                    line4.frame = CGRectMake(0,line2.frame.origin.y + movePoint,320,1);
                    line5.frame = CGRectMake(0,line3.frame.origin.y + movePoint,320,1);
                    line6.frame = CGRectMake(0,line4.frame.origin.y + movePoint,320,1);
                    line7.frame = CGRectMake(0,line5.frame.origin.y + movePoint,320,1);
                    line8.frame = CGRectMake(0,line6.frame.origin.y + movePoint,320,1);
                    line9.frame = CGRectMake(0,line7.frame.origin.y + movePoint,320,1);
                    line10.frame = CGRectMake(0,line8.frame.origin.y + movePoint,320,1);
                    
                    //varyLabel2.frame = CGRectMake(20,varyLabel2.frame.origin.y + yPoint,200,20);
                    //varyBtn2.frame = CGRectMake(20,varyBtn2.frame.origin.y + yPoint,300,20);
                    varyLabel3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,200,20);
                    varyBtn3.frame = CGRectMake(20,varyLabel2.frame.origin.y + movePoint,300,20);
                    varyLabel4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,200,20);
                    varyBtn4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,300,20);
                    varyLabel5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,200,20);
                    varyBtn5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,300,20);
                    varyLabel6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,200,20);
                    varyBtn6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint,300,20);
                    
                }
                
                isAdded = NO;
            }
        }else if(takePicture4 && takePicture5){
            NSLog(@"4,5枚目有るよ");
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            
            takePicture4 = NULL;
            takePicture4 = takePicture5;
            [takePictureButton4 setBackgroundImage:takePicture4 forState:UIControlStateNormal];
            
            
            takePicture5 = NULL;
            deleteButton5.hidden = YES;
            
            
            if (!takePicture5) {
                //5番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
            }
            
        }else if(takePicture4 && !takePicture5){
            takePicture3 = NULL;
            takePicture3 = takePicture4;
            [takePictureButton3 setBackgroundImage:takePicture3 forState:UIControlStateNormal];
            
            takePicture4 = NULL;
            deleteButton4.hidden = YES;
            
            takePictureButton5.hidden = YES;
            
            if (!takePicture4) {
                //4番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
            }
        }
    }else if ([sender tag] == 4){
        if (!takePicture5) {
            takePicture4 = NULL;
            deleteButton4.hidden = YES;
            
            takePictureButton5.hidden = YES;
            
            if (!takePicture4) {
                //4番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton4 setBackgroundImage:simage forState:UIControlStateNormal];
            }
        }else{
            takePicture4 = NULL;
            takePicture4 = takePicture5;
            [takePictureButton4 setBackgroundImage:takePicture4 forState:UIControlStateNormal];
            
            takePicture5 = NULL;
            deleteButton5.hidden = YES;
            
            
            if (!takePicture5) {
                //5番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
                
            }
        }
    }else if ([sender tag] == 5){
        if (takePicture5) {
            takePicture5 = NULL;
            deleteButton5.hidden = YES;
            if (!takePicture5) {
                //5番目の写真追加ボタンを表示
                UIImage *simage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }else{
                    simage = [UIImage imageNamed:@"btn_7_addphoto.png"];
                }
                [takePictureButton5 setBackgroundImage:simage forState:UIControlStateNormal];
            }
        }
    }
    
}

//商品説明のキーボードの完了ボタン
-(void)closeKeyboard:(id)sender{
    [detail resignFirstResponder];
    [price resignFirstResponder];
}
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
- (BOOL) textViewShouldEndEditing: (UITextView*) textView {
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"商品説明";
    }
    return YES;
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

//キーボードを閉じる
- (void)allKeyboardClose{
    [price resignFirstResponder];
    [itemName resignFirstResponder];
    [detail resignFirstResponder];
    [varyField1 resignFirstResponder];
    [varyField2 resignFirstResponder];
    [varyField3 resignFirstResponder];
    [varyField4 resignFirstResponder];
    [varyField5 resignFirstResponder];
}

//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 1001;
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    // 行インデックス番号を返す
    return [NSString stringWithFormat:@"%d", row];
    
}

//数量のピッカー
- (IBAction)selectNumber:(id)sender
{
    [self allKeyboardClose];
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
    if (buttonTag == 1) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        stock1 = [stockPicker selectedRowInComponent:0];
        stockLabel1.text = [NSString stringWithFormat:@"%d", stock1];
        
    }else if (buttonTag == 2) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        varyStockLabel1.text = [NSString stringWithFormat:@"%d", [stockPicker selectedRowInComponent:0]];
    }else if (buttonTag == 3) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        varyStockLabel2.text = [NSString stringWithFormat:@"%d", [stockPicker selectedRowInComponent:0]];
    }else if (buttonTag == 4) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        varyStockLabel3.text = [NSString stringWithFormat:@"%d", [stockPicker selectedRowInComponent:0]];
    }else if (buttonTag == 5) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        varyStockLabel4.text = [NSString stringWithFormat:@"%d", [stockPicker selectedRowInComponent:0]];
    }else if (buttonTag == 6) {
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        varyStockLabel5.text = [NSString stringWithFormat:@"%d", [stockPicker selectedRowInComponent:0]];
    }else{
        [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
        buttonTag = 0;
    }
    buttonTag = 0;
    
}

//バリエーションを追加ボタン
- (IBAction)addValue:(id)sender
{
    if (!visibleVary1) {
        //バリエーション有無のフラグ
        incVariation = 1;
        
        int movePoint = 95;
        [stockTable removeFromSuperview];
        [scrollView addSubview:variationTable1];
        //横線
        line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor whiteColor];
        
        
        //バリエーションを削除するボタン
        varyLabel2 = [[UILabel alloc] init];
        varyLabel2.text = @"バリエーションを削除する";
        varyLabel2.font = [UIFont systemFontOfSize:13];
        varyLabel2.backgroundColor = [UIColor clearColor];
        varyLabel2.textColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        varyBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        varyBtn2.frame = CGRectMake(20,470,300,20);
        varyBtn2.backgroundColor = [UIColor clearColor];
        varyBtn2.tag = 1;
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [varyLabel2 addSubview:stirngUnderLine];
        [varyBtn2 addTarget:self
                     action:@selector(dismissValue:) forControlEvents:UIControlEventTouchUpInside];
        
        float yPoint = 97.5f;
        if (isAdded) {
            line1.frame = CGRectMake(0,505 + yPoint,320,1);
            line2.frame = CGRectMake(0,506 + yPoint,320,1);
            
            varyLabel2.frame = CGRectMake(20,470 + yPoint,200,20);
            varyBtn2.frame = CGRectMake(20,470 + yPoint,300,20);
            
            
        }else{
            line1.frame = CGRectMake(0,505,320,1);
            line2.frame = CGRectMake(0,506,320,1);
            
            varyLabel2.frame = CGRectMake(20,470,200,20);
            varyBtn2.frame = CGRectMake(20,470,300,20);
        }
        
        [scrollView addSubview:line1];
        [scrollView addSubview:line2];
        
        [scrollView addSubview:varyLabel2];
        [scrollView addSubview:varyBtn2];
        
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
        varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        visibleVary1 = YES;
    }else if (visibleVary1 && !visibleVary2){
        int movePoint = 150;
        [scrollView addSubview:variationTable2];
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        //横線
        line3 = [[UIView alloc] initWithFrame:CGRectMake(0,line1.frame.origin.y + movePoint,320,1)];
        line3.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [scrollView addSubview:line3];
        line4 = [[UIView alloc] initWithFrame:CGRectMake(0,line2.frame.origin.y + movePoint,320,1)];
        line4.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:line4];
        
        //バリエーションを削除するボタン
        varyLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20,varyLabel2.frame.origin.y + movePoint,200,20)];
        varyLabel3.text = @"バリエーションを削除する";
        varyLabel3.font = [UIFont systemFontOfSize:13];
        varyLabel3.backgroundColor = [UIColor clearColor];
        varyLabel3.textColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [scrollView addSubview:varyLabel3];
        varyBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        varyBtn3.frame = CGRectMake(20,varyBtn2.frame.origin.y + movePoint,300,20);
        varyBtn3.backgroundColor = [UIColor clearColor];
        varyBtn3.tag = 2;
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [varyLabel3 addSubview:stirngUnderLine];
        [varyBtn3 addTarget:self
                     action:@selector(dismissValue:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:varyBtn3];
        
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
        varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        visibleVary2 = YES;
    }else if (visibleVary1 && visibleVary2 && !visibleVary3){
        int movePoint = 150;
        [scrollView addSubview:variationTable3];
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        
        //横線
        line5 = [[UIView alloc] initWithFrame:CGRectMake(0,line3.frame.origin.y + movePoint,320,1)];
        line5.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [scrollView addSubview:line5];
        line6 = [[UIView alloc] initWithFrame:CGRectMake(0,line4.frame.origin.y + movePoint,320,1)];
        line6.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:line6];
        
        //バリエーションを削除するボタン
        varyLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(20,varyLabel3.frame.origin.y + movePoint,200,20)];
        varyLabel4.text = @"バリエーションを削除する";
        varyLabel4.font = [UIFont systemFontOfSize:13];
        varyLabel4.backgroundColor = [UIColor clearColor];
        varyLabel4.textColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [scrollView addSubview:varyLabel4];
        varyBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        varyBtn4.frame = CGRectMake(20,varyLabel3.frame.origin.y + movePoint,300,20);
        varyBtn4.backgroundColor = [UIColor clearColor];
        varyBtn4.tag = 3;
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [varyLabel4 addSubview:stirngUnderLine];
        [varyBtn4 addTarget:self
                     action:@selector(dismissValue:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:varyBtn4];
        
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
        varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        visibleVary3 = YES;
    }else if (visibleVary1 && visibleVary2 && visibleVary3 && !visibleVary4){
        int movePoint = 150;
        [scrollView addSubview:variationTable4];
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        
        //横線
        line7 = [[UIView alloc] initWithFrame:CGRectMake(0,line5.frame.origin.y + movePoint,320,1)];
        line7.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [scrollView addSubview:line7];
        line8 = [[UIView alloc] initWithFrame:CGRectMake(0,line6.frame.origin.y + movePoint,320,1)];
        line8.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:line8];
        
        //バリエーションを削除するボタン
        varyLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(20,varyLabel4.frame.origin.y + movePoint,200,20)];
        varyLabel5.text = @"バリエーションを削除する";
        varyLabel5.font = [UIFont systemFontOfSize:13];
        varyLabel5.backgroundColor = [UIColor clearColor];
        varyLabel5.textColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [scrollView addSubview:varyLabel5];
        varyBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        varyBtn5.frame = CGRectMake(20,varyLabel4.frame.origin.y + movePoint,300,20);
        varyBtn5.backgroundColor = [UIColor clearColor];
        varyBtn5.tag = 4;
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [varyLabel5 addSubview:stirngUnderLine];
        [varyBtn5 addTarget:self
                     action:@selector(dismissValue:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:varyBtn5];
        
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
        varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        visibleVary4 = YES;
    }else if (visibleVary1 && visibleVary2 && visibleVary3 && visibleVary4 && !visibleVary5){
        int movePoint = 120;
        [addVaryLabel removeFromSuperview];
        [varyBtn removeFromSuperview];
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        [scrollView addSubview:variationTable5];
        
        //横線
        line9 = [[UIView alloc] initWithFrame:CGRectMake(0,line7.frame.origin.y + 150,320,1)];
        line9.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [scrollView addSubview:line9];
        line10 = [[UIView alloc] initWithFrame:CGRectMake(0,line8.frame.origin.y + 150,320,1)];
        line10.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:line10];
        
        //バリエーションを削除するボタン
        varyLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(20,varyLabel5.frame.origin.y + movePoint + 30,200,20)];
        varyLabel6.text = @"バリエーションを削除する";
        varyLabel6.font = [UIFont systemFontOfSize:13];
        varyLabel6.backgroundColor = [UIColor clearColor];
        varyLabel6.textColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [scrollView addSubview:varyLabel6];
        varyBtn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        varyBtn6.frame = CGRectMake(20,varyLabel5.frame.origin.y + movePoint + 30,300,20);
        varyBtn6.backgroundColor = [UIColor clearColor];
        varyBtn6.tag = 5;
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,156,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:129.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
        [varyLabel6 addSubview:stirngUnderLine];
        [varyBtn6 addTarget:self
                     action:@selector(dismissValue:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:varyBtn6];
        
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        visibleVary5 = YES;
    }
    
    
}

/***************************バリエーションを削除する***********************************/
- (IBAction)dismissValue:(id)sender {
    int buttonNumber = [sender tag];
    NSLog(@"%d:が押されているよ！！！",buttonNumber);
    
    if (buttonNumber == 5) {
        int movePoint = -120;
        [scrollView addSubview:addVaryLabel];
        [scrollView addSubview:varyBtn];
        
        [line9 removeFromSuperview];
        [line10 removeFromSuperview];
        [varyLabel6 removeFromSuperview];
        [varyBtn6 removeFromSuperview];
        [variationTable5 removeFromSuperview];
        varyField5.tag = [@"" intValue];
        
        
        //スクロールの高さ変更
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
        
        
        openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
        openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
        submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
        submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
        cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
        cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
        
        
        
        visibleVary5 = NO;
        
    }else if (buttonNumber == 4) {
        if (visibleVary5) {
            varyField4.text = varyField5.text;
            varyField5.text = NULL;
            varyField5.tag = [@"" intValue];
            varyStockLabel4.text = varyStockLabel5.text;
            varyStockLabel5.text = @"1";
            
            int movePoint = -120;
            [scrollView addSubview:addVaryLabel];
            [scrollView addSubview:varyBtn];
            
            [line9 removeFromSuperview];
            [line10 removeFromSuperview];
            [varyLabel6 removeFromSuperview];
            [varyBtn6 removeFromSuperview];
            [variationTable5 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary5 = NO;
        }else{
            
            int movePoint = -150;
            
            [line7 removeFromSuperview];
            [line8 removeFromSuperview];
            [varyLabel5 removeFromSuperview];
            [varyBtn5 removeFromSuperview];
            [variationTable4 removeFromSuperview];
            varyField4.tag = [@"" intValue];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary4 = NO;
            
            
        }
    }else if (buttonNumber == 3) {
        if (visibleVary4 && visibleVary5) {
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            varyField4.text = varyField5.text;
            varyField5.text = NULL;
            varyField5.tag = [@"" intValue];
            varyStockLabel4.text = varyStockLabel5.text;
            varyStockLabel5.text = @"1";
            
            
            
            int movePoint = -120;
            [scrollView addSubview:addVaryLabel];
            [scrollView addSubview:varyBtn];
            
            [line9 removeFromSuperview];
            [line10 removeFromSuperview];
            [varyLabel6 removeFromSuperview];
            [varyBtn6 removeFromSuperview];
            [variationTable5 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary5 = NO;
        }else if (visibleVary4 && !visibleVary5){
            
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            
            int movePoint = -150;
            
            [line7 removeFromSuperview];
            [line8 removeFromSuperview];
            [varyLabel5 removeFromSuperview];
            [varyBtn5 removeFromSuperview];
            [variationTable4 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary4 = NO;
            
            
        }else{
            int movePoint = -150;
            
            [line5 removeFromSuperview];
            [line6 removeFromSuperview];
            [varyLabel4 removeFromSuperview];
            [varyBtn4 removeFromSuperview];
            [variationTable3 removeFromSuperview];
            varyField3.tag = [@"" intValue];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary3 = NO;
        }
    }else if (buttonNumber == 2) {
        if (visibleVary3 && visibleVary4 && visibleVary5) {
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            varyField4.text = varyField5.text;
            varyField5.text = NULL;
            varyField5.tag = [@"" intValue];
            varyStockLabel4.text = varyStockLabel5.text;
            varyStockLabel5.text = @"1";
            
            
            
            int movePoint = -120;
            [scrollView addSubview:addVaryLabel];
            [scrollView addSubview:varyBtn];
            
            [line9 removeFromSuperview];
            [line10 removeFromSuperview];
            [varyLabel6 removeFromSuperview];
            [varyBtn6 removeFromSuperview];
            [variationTable5 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary5 = NO;
        }else if (visibleVary3 && visibleVary4 && !visibleVary5){
            
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            
            int movePoint = -150;
            
            [line7 removeFromSuperview];
            [line8 removeFromSuperview];
            [varyLabel5 removeFromSuperview];
            [varyBtn5 removeFromSuperview];
            [variationTable4 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary4 = NO;
            
            
        }else if (visibleVary3 && !visibleVary4 && !visibleVary5){
            
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            
            int movePoint = -150;
            
            [line5 removeFromSuperview];
            [line6 removeFromSuperview];
            [varyLabel4 removeFromSuperview];
            [varyBtn4 removeFromSuperview];
            [variationTable3 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary3 = NO;
        }else{
            
            
            int movePoint = -150;
            
            [line3 removeFromSuperview];
            [line4 removeFromSuperview];
            [varyLabel3 removeFromSuperview];
            [varyBtn3 removeFromSuperview];
            [variationTable2 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary2 = NO;
        }
    }else if (buttonNumber == 1) {
        if (visibleVary2 && visibleVary3 && visibleVary4 && visibleVary5) {
            
            varyField1.text = varyField2.text;
            varyField2.text = NULL;
            varyField2.tag = [@"" intValue];
            varyStockLabel1.text = varyStockLabel2.text;
            varyStockLabel2.text = @"1";
            
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            varyField4.text = varyField5.text;
            varyField5.text = NULL;
            varyField5.tag = [@"" intValue];
            varyStockLabel4.text = varyStockLabel5.text;
            varyStockLabel5.text = @"1";
            
            
            
            int movePoint = -120;
            [scrollView addSubview:addVaryLabel];
            [scrollView addSubview:varyBtn];
            
            [line9 removeFromSuperview];
            [line10 removeFromSuperview];
            [varyLabel6 removeFromSuperview];
            [varyBtn6 removeFromSuperview];
            [variationTable5 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary5 = NO;
        }else if (visibleVary2 && visibleVary3 && visibleVary4 && !visibleVary5){
            
            varyField1.text = varyField2.text;
            varyField2.text = NULL;
            varyField2.tag = [@"" intValue];
            varyStockLabel1.text = varyStockLabel2.text;
            varyStockLabel2.text = @"1";
            
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            varyField3.text = varyField4.text;
            varyField4.text = NULL;
            varyField4.tag = [@"" intValue];
            varyStockLabel3.text = varyStockLabel4.text;
            varyStockLabel4.text = @"1";
            
            
            int movePoint = -150;
            
            [line7 removeFromSuperview];
            [line8 removeFromSuperview];
            [varyLabel5 removeFromSuperview];
            [varyBtn5 removeFromSuperview];
            [variationTable4 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary4 = NO;
            
            
        }else if (visibleVary2 && visibleVary3 && !visibleVary4 && !visibleVary5){
            
            varyField1.text = varyField2.text;
            varyField2.text = NULL;
            varyField2.tag = [@"" intValue];
            varyStockLabel1.text = varyStockLabel2.text;
            varyStockLabel2.text = @"1";
            
            varyField2.text = varyField3.text;
            varyField3.text = NULL;
            varyField3.tag = [@"" intValue];
            varyStockLabel2.text = varyStockLabel3.text;
            varyStockLabel3.text = @"1";
            
            
            int movePoint = -150;
            
            [line5 removeFromSuperview];
            [line6 removeFromSuperview];
            [varyLabel4 removeFromSuperview];
            [varyBtn4 removeFromSuperview];
            [variationTable3 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary3 = NO;
        }else if (visibleVary2 && !visibleVary3 && !visibleVary4 && !visibleVary5){
            
            varyField1.text = varyField2.text;
            varyField2.text = NULL;
            varyField2.tag = [@"" intValue];
            varyStockLabel1.text = varyStockLabel2.text;
            varyStockLabel2.text = @"1";
            
            
            int movePoint = -150;
            
            [line3 removeFromSuperview];
            [line4 removeFromSuperview];
            [varyLabel3 removeFromSuperview];
            [varyBtn3 removeFromSuperview];
            [variationTable2 removeFromSuperview];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary2 = NO;
        }else if (!visibleVary2 && !visibleVary3 && !visibleVary4 && !visibleVary5){
            
            varyField1.text = NULL;
            varyField1.tag = [@"" intValue];
            varyStockLabel1.text = @"1";
            
            int movePoint = -95;
            
            [line1 removeFromSuperview];
            [line2 removeFromSuperview];
            [varyLabel2 removeFromSuperview];
            [varyBtn2 removeFromSuperview];
            [variationTable1 removeFromSuperview];
            
            [scrollView addSubview:stockTable];
            
            
            //スクロールの高さ変更
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + movePoint);
            
            addVaryLabel.frame = CGRectMake(20, addVaryLabel.frame.origin.y + movePoint,200,20);
            varyBtn.frame = CGRectMake(20, varyBtn.frame.origin.y + movePoint,200,20);
            openTable.frame = CGRectMake(0, openTable.frame.origin.y + movePoint, 320, 45);
            openSwitch.center = CGPointMake(255, openSwitch.center.y + movePoint);
            submitButton.center = CGPointMake(submitButton.center.x, submitButton.center.y + movePoint);
            submitLabel.center = CGPointMake(submitLabel.center.x, submitLabel.center.y + movePoint);
            cancelButton.center = CGPointMake(cancelButton.center.x, cancelButton.center.y + movePoint);
            cancelLabel.center = CGPointMake(cancelLabel.center.x, cancelLabel.center.y + movePoint);
            
            visibleVary1 = NO;
            incVariation = 0;
        }
    }
}



//バリデーションチェック
- (void)validationCheck {
    NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
    [checkCharSet addCharactersInString:@"1234567890"];
    
    if (itemName.text == nil || [itemName.text isEqualToString:@""]) {
        [itemName becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"商品名の入力が正しくありません" message:@"商品名を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if([[price.text stringByTrimmingCharactersInSet:checkCharSet] length] > 0){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if ([price.text intValue] < 50 || [price.text intValue] > 500000){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"50円以上500,000円以下の範囲で金額をご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (price.text == nil || [price.text isEqualToString:@""]){
        [price becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"価格を数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (visibleVary1 && (varyField1.text == nil || [varyField1.text isEqualToString:@""])){
        [varyField1 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (visibleVary2 && (varyField2.text == nil || [varyField2.text isEqualToString:@""])){
        [varyField2 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (visibleVary3 && (varyField3.text == nil || [varyField3.text isEqualToString:@""])){
        [varyField3 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (visibleVary4 && (varyField4.text == nil || [varyField4.text isEqualToString:@""])){
        [varyField4 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (visibleVary5 && (varyField5.text == nil || [varyField5.text isEqualToString:@""])){
        [varyField5 becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"バリエーションの入力が正しくありません" message:@"バリエーションをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else{
        validation = YES;
    }
    
    
    NSLog(@"バリデーションチェック");
    
}


/////////////////////////////
//「保存する」ボタンのアクション
/////////////////////////////
- (IBAction)submitPhoto:(id)sender
{
    
    [self validationCheck];
    if (!validation) {
        return;
    }
    
    
    
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeGradient];
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSAddItemViewController"
                                                     withAction:@"addItem"
                                                      withLabel:nil
                                                      withValue:@100];
    
    uploadImageArray = [NSMutableArray array];
    for (int n = 0; n < 5; n++) {
        if (n == 0 && takePicture1) {
            [uploadImageArray addObject:takePicture1];
        }else if (n == 1 && takePicture2){
            [uploadImageArray addObject:takePicture2];
        }else if (n == 2 && takePicture3){
            [uploadImageArray addObject:takePicture3];
        }else if (n == 3 && takePicture4){
            [uploadImageArray addObject:takePicture4];
        }else if (n == 4 && takePicture5){
            [uploadImageArray addObject:takePicture5];
        }
    }
    NSLog(@"%@",uploadImageArray);
    
    //セッションID
    NSString *session_id = [BSTutorialViewController sessions];
    
    NSString *getUrl = NULL;
    /*
     getUrl = [NSString stringWithFormat:@"http://api.base0.info/items/add_item?title=%@&price=%d&detail=%@&stock=%d&variation[0]=   %@&variation_stock[0]=%@&visible=%d&session_id=%@",itemName.text,[price.text intValue],detail.text,stock1,variationArray,dumpVariationStock,visible,session_id];
     */
    if (incVariation == 0) {
        //在庫数のみの場合
        getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=0&stock=%d&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,stock1,visible,session_id];
    }else{
        //バリエーションがある場合
        if(visibleVary1 && !visibleVary2) getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=1&variation[0]=%@&variation_stock[0]=%@&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,varyField1.text,varyStockLabel1.text,visible,session_id];
        if(visibleVary2 && !visibleVary3) getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=1&variation[0]=%@&variation_stock[0]=%@&variation[1]=%@&variation_stock[1]=%@&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,varyField1.text,varyStockLabel1.text,varyField2.text,varyStockLabel2.text,visible,session_id];
        if(visibleVary3 && !visibleVary4) getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=1&variation[0]=%@&variation_stock[0]=%@&variation[1]=%@&variation_stock[1]=%@&variation[2]=%@&variation_stock[2]=%@&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,varyField1.text,varyStockLabel1.text,varyField2.text,varyStockLabel2.text,varyField3.text,varyStockLabel3.text,visible,session_id];
        if(visibleVary4 && !visibleVary5) getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=1&variation[0]=%@&variation_stock[0]=%@&variation[1]=%@&variation_stock[1]=%@&variation[2]=%@&variation_stock[2]=%@&variation[3]=%@&variation_stock[3]=%@&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,varyField1.text,varyStockLabel1.text,varyField2.text,varyStockLabel2.text,varyField3.text,varyStockLabel3.text,varyField4.text,varyStockLabel4.text,visible,session_id];
        if(visibleVary5) getUrl = [NSString stringWithFormat:@"%@/items/add_item?title=%@&price=%d&detail=%@&inc_variation=1&variation[0]=%@&variation_stock[0]=%@&variation[1]=%@&variation_stock[1]=%@&variation[2]=%@&variation_stock[2]=%@&variation[3]=%@&variation_stock[3]=%@&variation[4]=%@&variation_stock[4]=%@&visible=%d&session_id=%@",apiUrl,itemName.text,[price.text intValue],detail.text,varyField1.text,varyStockLabel1.text,varyField2.text,varyStockLabel2.text,varyField3.text,varyStockLabel3.text,varyField4.text,varyStockLabel4.text,varyField5.text,varyStockLabel5.text,visible,session_id];
    }
    NSLog(@"getrequest%@",getUrl);
    getUrl = [getUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:getUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"リクエスト情報:%@",request.allHTTPHeaderFields);
        NSLog(@"注文詳細！: %@", JSON);
        userAgent = (request.allHTTPHeaderFields)[@"User-Agent"];
        
        NSLog(@"jsonデータ:%@",JSON);
        jsonItemId = [JSON valueForKeyPath:@"result.Item.id"];
        NSLog(@"jsonデータのその2%@",JSON);
        
        NSArray *error = [JSON valueForKeyPath:@"error.validations.Item.Variation"];
        NSDictionary *errora = [error objectAtIndex:0];
        NSArray *errora2 = [errora valueForKey:@"variation_stock"];
        

        NSLog(@"jsonデータのその2%@",[errora2 objectAtIndex:0]);

        
        
        //画像アップロードpost
        //一枚目の画像アップロード
        if (jsonItemId){
            NSString *upTimesString = [NSString stringWithFormat:@"画像を受け取っています1/%d",uploadImageArray.count];
            [SVProgressHUD showWithStatus:upTimesString maskType:SVProgressHUDMaskTypeGradient];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            [request setHTTPShouldHandleCookies:NO];
            [request setTimeoutInterval:120];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            // set Content-Type in HTTP header
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:userAgent forHTTPHeaderField: @"User-Agent"];
            [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
            // post body
            NSMutableData *body = [[NSMutableData alloc] init];
            int item_id =  [jsonItemId intValue];
            int image_no = 1;
            NSLog(@"セッション%@",session_id);
            // add params (all params are strings)
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"item_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d\r\n", item_id] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d\r\n", image_no] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // add image data
            NSData *imageData =  [[NSData alloc] initWithData:UIImagePNGRepresentation(takePicture1)];
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"画像が入っています。");
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"session_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", session_id] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //NSString *str3= [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            NSString* newStr = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
            NSLog(@"ポストのボディ%@",newStr);
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set URL
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/items/add_image",apiUrl]]];
            
            upTimes = 1;
            [NSURLConnection connectionWithRequest:request delegate:self];
            //jsonItemId = nil;
        }else{
            NSLog(@"アイテムIDがありません");
            [SVProgressHUD showErrorWithStatus:@"入力が正しくありません"];
        }
        
        
    } failure:nil];
    [operation start];
    
    
    
    
    
}
//キャンセルボタン
- (IBAction)cancelPhoto:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//キャンセルボタン
- (void)cancelPhoto
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"receive data");
    NSLog(@"%@",jsonObject);
    
}


//データをすべて受け取った時
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    upTimes++;
    if (upTimes <= uploadImageArray.count) {
        if (jsonItemId) {
            NSString *upTimesString = [NSString stringWithFormat:@"画像を受け取っています%d/%d",upTimes,uploadImageArray.count];
            [SVProgressHUD showWithStatus:upTimesString maskType:SVProgressHUDMaskTypeGradient];
            NSString *session_id = [BSTutorialViewController sessions];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            [request setHTTPShouldHandleCookies:NO];
            [request setTimeoutInterval:120];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            // set Content-Type in HTTP header
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:userAgent forHTTPHeaderField: @"User-Agent"];
            [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            // post body
            NSMutableData *body = [[NSMutableData alloc] init];
            int item_id =  [jsonItemId intValue];
            int image_no = upTimes;
            NSLog(@"セッション%@",session_id);
            // add params (all params are strings)
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"item_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d\r\n", item_id] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_no\"\r\n\r\n"] dataUsingEncoding:   NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%d\r\n", image_no] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // add image data
            //NSString * upimage = [@"takePicture%d",upTimes];
            NSData *imageData;
            if (upTimes == 2) {
                //imageData = UIImageJPEGRepresentation(takePicture2, 1.0);
                imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(takePicture2)];
            }else if (upTimes == 3) {
                //imageData = UIImageJPEGRepresentation(takePicture3, 1.0);
                imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(takePicture3)];

            }else if (upTimes == 4) {
                //imageData = UIImageJPEGRepresentation(takePicture4, 1.0);
                imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(takePicture4)];

            }else if (upTimes == 5) {
                //imageData = UIImageJPEGRepresentation(takePicture5, 1.0);
                imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(takePicture5)];
            }
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"画像が入っています。");
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"session_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", session_id] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //NSString *str3= [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
            NSString* newStr = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
            NSLog(@"ポストのボディ%@",newStr);
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set URL
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/items/add_image",apiUrl]]];
            
            [NSURLConnection connectionWithRequest:request delegate:self];
        }else{
            NSLog(@"エラーが起きたよ！！！！");
        }
    }else{
        jsonItemId = nil;
        [SVProgressHUD showSuccessWithStatus:@"アップロード完了！"];
        NSLog(@"connectionDidFinishLoading");
        [self dismissViewControllerAnimated:YES completion:nil];
        /*
         NSLog(@"アイテムIDがありません");
         [SVProgressHUD showErrorWithStatus:@"入力が正しくありません"];
         */
    }
    
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
