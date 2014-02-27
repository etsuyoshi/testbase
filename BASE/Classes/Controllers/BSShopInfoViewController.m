//
//  BSShopInfoViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/03.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSShopInfoViewController.h"
#import "BSBuyTopViewController.h"
#import "BSAboutItemViewController.h"
#import "BSShopViewController.h"




@interface BSShopInfoViewController ()

@end

@implementation BSShopInfoViewController{
    UITableView *shopInfoTable;
    
    NSString *privacy;
    
    UIButton *sendButton;
    UITextField *userNameField;
    UITextField *emailField;
    
    UITableView *questionTable;
    UILabel *questionLabel;
    
    UITextView *questionTextView;
    
    //質問項目ピッカー
    UIActionSheet *stockActionSheet;
    BOOL pickerIsOpened;
    UIPickerView *stockPicker;
    
    //特商法
    
    UILabel *userInfoLabel;
    UILabel *nameLabel;
    UILabel *name;
    UILabel *addressLabel;
    UILabel *postcodeLabel;
    UILabel *address;
    UILabel *contactLabel;
    UILabel *tel;
    UILabel *contact;

    UILabel *priceLabel;
    UITextView *priceTextView;
    
    UILabel *payLabel;
    UITextView *payTextView;

    UILabel *returnLabel;
    UITextView *returnTextView;
    
    UILabel *serviceLabel;
    UITextView *serviceTextView;
    
    NSString *userId;

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
	
    //グーグルアナリティクス
    self.screenName = @"buyShopInfo";
    apiUrl = [BSDefaultViewObject setApiUrl];
    UIViewController* previousViewController = [self presentingViewController];
    if ([NSStringFromClass([previousViewController class]) isEqualToString:@"BSBuyNavigationController"]) {
        NSLog(@"親ビュー%@",previousViewController.title);

    }
    //バッググラウンド
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    //ナビゲーションバー
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        navBar.barTintColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"店舗情報"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"店舗情報";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        shopInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 64) style:UITableViewStylePlain];

    }else{
        shopInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    }
    shopInfoTable.scrollEnabled = YES;
    shopInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    shopInfoTable.backgroundColor = [UIColor clearColor];
    shopInfoTable.tag = 1;
    shopInfoTable.dataSource = self;
    shopInfoTable.delegate = self;
    [self.view insertSubview:shopInfoTable belowSubview:navBar];
    
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([BSDefaultViewObject isMoreIos7]) {
        dismissButton.frame = CGRectMake(10,23,30,30);

    }else{
        dismissButton.frame = CGRectMake(10,5,30,30);

    }
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.alpha = 0.6;
    [dismissButton addTarget:self action:@selector(dismissModal:)forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:dismissButton];
    
    //dismissラベル
    UILabel *dismissLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
    dismissLabel.text = @"×";
    dismissLabel.textAlignment = NSTextAlignmentLeft;
    dismissLabel.font = [UIFont boldSystemFontOfSize:40];
    /*
    dismissLabel.shadowColor = [UIColor darkGrayColor];
    dismissLabel.shadowOffset = CGSizeMake(0.f, 1.f);
     */
    dismissLabel.backgroundColor = [UIColor clearColor];
    dismissLabel.textColor = [UIColor darkGrayColor];
    
    [dismissButton addSubview:dismissLabel];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BSShopViewController getShopId]) {
        userId = [BSShopViewController getShopId];

    }else{
        userId = [BSAboutItemViewController getShopId];
    }
    
    
    [[BSBuyerAPIClient sharedClient] getShopWithUserId:userId deviseName:nil deviseOS:nil deviseId:nil completion:^(NSDictionary *results, NSError *error) {
        
        if (error) {
            [BSShopViewController resetShopId];
            [BSAboutItemViewController resetShopId];
        } else {
            NSLog(@"キュレーション情報！: %@", results);
            privacy = results[@"privacy"];
            
            [self generateShopInfo:results];
            
            [shopInfoTable reloadData];
            
            
            [BSShopViewController resetShopId];
            [BSAboutItemViewController resetShopId];
            
        }
       
        
        
    }];
    
        
}

- (void)generateShopInfo:(id)JSON{
    
    NSDictionary *shopInfo = [JSON valueForKeyPath:@"shop.Shop"];
    
    NSString *firstName = shopInfo[@"first_name"];
    NSString *lastName = shopInfo[@"last_name"];
    NSString *postcodeInfo = shopInfo[@"zip_code"];
    NSString *prefecture = shopInfo[@"prefecture"];
    NSString *addressInfo = shopInfo[@"address"];
    NSString *telInfo = shopInfo[@"tel_no"];
    NSString *priceInfo = shopInfo[@"price"];
    NSString *payInfo = shopInfo[@"pay"];
    NSString *returnInfo = shopInfo[@"return"];
    NSString *serviceInfo = shopInfo[@"service"];
    NSString *contactInfo = shopInfo[@"contact"];
    
    userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,240,40)];
    userInfoLabel.text = @"2.特定商取引法に基づく表記";
    userInfoLabel.textAlignment = NSTextAlignmentLeft;
    userInfoLabel.font = [UIFont boldSystemFontOfSize:18];
    userInfoLabel.backgroundColor = [UIColor clearColor];
    userInfoLabel.textColor = [UIColor blackColor];
    
    //氏名
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(userInfoLabel.frame.origin.y + userInfoLabel.frame.size.height + 12),320,16)];
    nameLabel.text = @"事業者の名称";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    
    //氏名
    name = [[UILabel alloc] initWithFrame:CGRectMake(10,(nameLabel.frame.origin.y + nameLabel.frame.size.height + 4),320,22)];
    name.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:16];
    name.textColor = [UIColor grayColor];
    name.backgroundColor = [UIColor clearColor];
    
    //郵便番号
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(name.frame.origin.y + name.frame.size.height +12),320,22)];
    addressLabel.text = @"事業者の所在地";
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont boldSystemFontOfSize:16];
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    
    
    //郵便番号
    postcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(addressLabel.frame.origin.y + addressLabel.frame.size.height + 4),320,16)];
    postcodeLabel.text = [NSString stringWithFormat:@"郵便番号：%@",postcodeInfo];
    postcodeLabel.textAlignment = NSTextAlignmentLeft;
    postcodeLabel.font = [UIFont systemFontOfSize:16];
    postcodeLabel.textColor = [UIColor grayColor];
    postcodeLabel.backgroundColor = [UIColor clearColor];
    
    //郵便番号
    address = [[UILabel alloc] initWithFrame:CGRectMake(10,(postcodeLabel.frame.origin.y + postcodeLabel.frame.size.height + 4),300,38)];
    address.numberOfLines = 0;
    address.text = [NSString stringWithFormat:@"住所：%@%@",prefecture,addressInfo];
    address.textAlignment = NSTextAlignmentLeft;
    address.font = [UIFont systemFontOfSize:16];
    address.textColor = [UIColor grayColor];
    address.backgroundColor = [UIColor clearColor];
    CGRect newFrame = [address frame];
    newFrame.size = CGSizeMake(300, 5000);
    [address setFrame:newFrame];
    [address sizeToFit];
    
    //郵便番号
    contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(address.frame.origin.y + address.frame.size.height +12),320,22)];
    contactLabel.text = @"事業者の連絡先";
    contactLabel.textAlignment = NSTextAlignmentLeft;
    contactLabel.font = [UIFont boldSystemFontOfSize:16];
    contactLabel.textColor = [UIColor grayColor];
    contactLabel.backgroundColor = [UIColor clearColor];
    
    
    //郵便番号
    tel = [[UILabel alloc] initWithFrame:CGRectMake(10,(contactLabel.frame.origin.y + contactLabel.frame.size.height + 4),320,16)];
    tel.text = [NSString stringWithFormat:@"電話番号：%@",telInfo];
    tel.textAlignment = NSTextAlignmentLeft;
    tel.font = [UIFont systemFontOfSize:16];
    tel.textColor = [UIColor grayColor];
    tel.backgroundColor = [UIColor clearColor];
    
    //郵便番号
    contact = [[UILabel alloc] initWithFrame:CGRectMake(10,(tel.frame.origin.y + tel.frame.size.height + 4),300,16)];
    contact.text = [NSString stringWithFormat:@"住所：%@",contactInfo];
    contact.textAlignment = NSTextAlignmentLeft;
    contact.font = [UIFont systemFontOfSize:16];
    contact.textColor = [UIColor grayColor];
    contact.backgroundColor = [UIColor clearColor];
    contact.numberOfLines = 0;
    newFrame = [contact frame];
    newFrame.size = CGSizeMake(300, 5000);
    [contact setFrame:newFrame];
    [contact sizeToFit];
    

    
    //郵便番号
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(contact.frame.origin.y + contact.frame.size.height +12),320,22)];
    priceLabel.text = @"販売価格について";
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = [UIColor grayColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    
    priceTextView = [[UITextView alloc] initWithFrame:CGRectMake(2,(priceLabel.frame.origin.y + priceLabel.frame.size.height -4),310,10)];
    priceTextView.text = priceInfo;
    priceTextView.textColor = [UIColor grayColor];
    [priceTextView setFont:[UIFont systemFontOfSize:16]];
    priceTextView.backgroundColor = [UIColor clearColor];
    priceTextView.delegate = self;
    priceTextView.editable = NO;
    priceTextView.hidden = YES;
    [self.view addSubview:priceTextView];
    CGRect frame = priceTextView.frame;
    frame.size.height = priceTextView.contentSize.height;
    priceTextView.frame = frame;
    
    
    
    //郵便番号
    payLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(priceTextView.frame.origin.y + priceTextView.frame.size.height +12),320,22)];
    payLabel.text = @"代金（対価）の支払方法と時期";
    payLabel.textAlignment = NSTextAlignmentLeft;
    payLabel.font = [UIFont boldSystemFontOfSize:16];
    payLabel.textColor = [UIColor grayColor];
    payLabel.backgroundColor = [UIColor clearColor];
    
    payTextView = [[UITextView alloc] initWithFrame:CGRectMake(2,(payLabel.frame.origin.y + payLabel.frame.size.height -4),310,10)];
    payTextView.text = payInfo;
    payTextView.textColor = [UIColor grayColor];
    [payTextView setFont:[UIFont systemFontOfSize:16]];
    payTextView.backgroundColor = [UIColor clearColor];
    payTextView.delegate = self;
    payTextView.editable = NO;
    payTextView.hidden = YES;
    [self.view addSubview:payTextView];
    frame = payTextView.frame;
    frame.size.height = payTextView.contentSize.height;
    payTextView.frame = frame;
    
    
    //郵便番号
    returnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(payTextView.frame.origin.y + payTextView.frame.size.height +12),320,22)];
    returnLabel.text = @"役務または商品の引渡時期";
    returnLabel.textAlignment = NSTextAlignmentLeft;
    returnLabel.font = [UIFont boldSystemFontOfSize:16];
    returnLabel.textColor = [UIColor grayColor];
    returnLabel.backgroundColor = [UIColor clearColor];
    
    returnTextView = [[UITextView alloc] initWithFrame:CGRectMake(2,(returnLabel.frame.origin.y + returnLabel.frame.size.height -4),310,10)];
    returnTextView.text = returnInfo;
    returnTextView.textColor = [UIColor grayColor];
    [returnTextView setFont:[UIFont systemFontOfSize:16]];
    returnTextView.backgroundColor = [UIColor clearColor];
    returnTextView.delegate = self;
    returnTextView.editable = NO;
    returnTextView.hidden = YES;
    [self.view addSubview:returnTextView];
    frame = returnTextView.frame;
    frame.size.height = returnTextView.contentSize.height;
    returnTextView.frame = frame;
    
    
    //郵便番号
    serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(returnTextView.frame.origin.y + returnTextView.frame.size.height +12),320,22)];
    serviceLabel.text = @"返品についての特約に関する事項";
    serviceLabel.textAlignment = NSTextAlignmentLeft;
    serviceLabel.font = [UIFont boldSystemFontOfSize:16];
    serviceLabel.textColor = [UIColor grayColor];
    serviceLabel.backgroundColor = [UIColor clearColor];
    
    serviceTextView = [[UITextView alloc] initWithFrame:CGRectMake(2,(serviceLabel.frame.origin.y + serviceLabel.frame.size.height -4),310,10)];
    serviceTextView.text = serviceInfo;
    serviceTextView.textColor = [UIColor grayColor];
    [serviceTextView setFont:[UIFont systemFontOfSize:16]];
    serviceTextView.backgroundColor = [UIColor clearColor];
    serviceTextView.delegate = self;
    serviceTextView.editable = NO;
    serviceTextView.hidden = YES;
    [self.view addSubview:serviceTextView];
    frame = serviceTextView.frame;
    frame.size.height = serviceTextView.contentSize.height;
    serviceTextView.frame = frame;
    
    
    
    /*
    CGRect f = textview.frame;
    3
    f.size.height = textview.contentSize.height;
    4
    textview.frame = f;
    
    */
    /*
    //郵便番号
    UILabel *postcode = [[UILabel alloc] initWithFrame:CGRectMake(10,(postcodeLabel.frame.origin.y + postcodeLabel.frame.size.height + 4),320,22)];
    postcode.text = postcodeInfo;
    postcode.textAlignment = NSTextAlignmentLeft;
    postcode.font = [UIFont boldSystemFontOfSize:20];
    postcode.textColor = [UIColor darkGrayColor];
    postcode.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:postcode];
    
    //住所
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(postcode.frame.origin.y + postcode.frame.size.height + 12),320,16)];
    addressLabel.text = [NSString stringWithFormat:@"住所：%@%@%@%@",prefecture,addressInfo,addressInfo2];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont boldSystemFontOfSize:16];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:addressLabel];
    CGRect newFrame = addressLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    addressLabel.frame = newFrame;
    
    //住所
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(10,(addressLabel.frame.origin.y + addressLabel.frame.size.height + 4),280,22)];
    address.text = [NSString stringWithFormat:@"事業者の連絡先"];
    address.textAlignment = NSTextAlignmentLeft;
    address.font = [UIFont boldSystemFontOfSize:20];
    address.textColor = [UIColor darkGrayColor];
    address.backgroundColor = [UIColor clearColor];
    address.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(280, 200);
    CGSize expectedLabelSize = [address.text sizeWithFont:address.font constrainedToSize:maximumLabelSize lineBreakMode:address.lineBreakMode];
    
    [scrollView addSubview:address];
     */
    /*
    //電話番号
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(address.frame.origin.y + address.frame.size.height + 12),320,16)];
    telLabel.text = @"電話番号";
    telLabel.textAlignment = NSTextAlignmentLeft;
    telLabel.font = [UIFont boldSystemFontOfSize:16];
    telLabel.textColor = [UIColor lightGrayColor];
    telLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:telLabel];
    
    //電話番号
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(10,(telLabel.frame.origin.y + telLabel.frame.size.height + 4),320,22)];
    tel.text = telInfo;
    tel.textAlignment = NSTextAlignmentLeft;
    tel.font = [UIFont boldSystemFontOfSize:20];
    tel.textColor = [UIColor darkGrayColor];
    tel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tel];
    
    
    //メールアドレス
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(tel.frame.origin.y + tel.frame.size.height + 12),320,16)];
    mailLabel.text = @"メールアドレス";
    mailLabel.textAlignment = NSTextAlignmentLeft;
    mailLabel.font = [UIFont boldSystemFontOfSize:16];
    mailLabel.textColor = [UIColor lightGrayColor];
    mailLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:mailLabel];
    
    //メールアドレス
    UILabel *mail = [[UILabel alloc] initWithFrame:CGRectMake(10,(mailLabel.frame.origin.y + mailLabel.frame.size.height + 4),320,22)];
    mail.text = mailInfo;
    mail.textAlignment = NSTextAlignmentLeft;
    mail.font = [UIFont boldSystemFontOfSize:20];
    mail.textColor = [UIColor darkGrayColor];
    mail.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:mail];
    
    
    //備考欄
    UILabel *commentLable = [[UILabel alloc] initWithFrame:CGRectMake(10,(mail.frame.origin.y + mail.frame.size.height + 12),320,16)];
    commentLable.text = @"備考欄";
    commentLable.textAlignment = NSTextAlignmentLeft;
    commentLable.font = [UIFont boldSystemFontOfSize:16];
    commentLable.textColor = [UIColor lightGrayColor];
    commentLable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:commentLable];
    
    //備考欄
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(10,(commentLable.frame.origin.y + commentLable.frame.size.height + 4),280,22)];
    comment.text = remarkInfo;
    comment.textAlignment = NSTextAlignmentLeft;
    comment.font = [UIFont boldSystemFontOfSize:20];
    comment.textColor = [UIColor darkGrayColor];
    comment.backgroundColor = [UIColor clearColor];
    comment.numberOfLines = 0;
    CGSize maximumLabelSize2 = CGSizeMake(280, 200);
    CGSize expectedLabelSize2 = [comment.text sizeWithFont:comment.font constrainedToSize:maximumLabelSize2 lineBreakMode:address.lineBreakMode];
    [scrollView addSubview:comment];
    CGRect newFrame2 = comment.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    comment.frame = newFrame2;
    
    
    //支払い方法
    UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(comment.frame.origin.y + comment.frame.size.height + 12),320,16)];
    paymentLabel.text = @"支払い方法";
    paymentLabel.textAlignment = NSTextAlignmentLeft;
    paymentLabel.font = [UIFont boldSystemFontOfSize:16];
    paymentLabel.textColor = [UIColor lightGrayColor];
    paymentLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:paymentLabel];
    
    //支払い方法
    UILabel *payment = [[UILabel alloc] initWithFrame:CGRectMake(10,(paymentLabel.frame.origin.y + paymentLabel.frame.size.height + 4),320,22)];
    payment.text = paymentInfo;
    payment.textAlignment = NSTextAlignmentLeft;
    payment.font = [UIFont boldSystemFontOfSize:20];
    payment.textColor = [UIColor darkGrayColor];
    payment.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:payment];
     */
}


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == questionTable) {
        return 1;
    }
    return 4;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}

//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

//セクションフッターの高さ変更

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    int height;
    if (tableView == questionTable) {
        return 44;
    }
    if (indexPath.row == 0) {
        height = 170;
    }else if (indexPath.row == 1){
        UILabel *policy = [[UILabel alloc] initWithFrame:CGRectMake(10,5,280,22)];
        policy.text = privacy;
        policy.textAlignment = NSTextAlignmentLeft;
        policy.font = [UIFont systemFontOfSize:16];
        policy.textColor = [UIColor darkGrayColor];
        policy.backgroundColor = [UIColor clearColor];
        policy.numberOfLines = 0;
        policy.hidden = YES;
        CGSize maximumLabelSize = CGSizeMake(280, 3000);
        CGSize expectedLabelSize = [policy.text sizeWithFont:policy.font constrainedToSize:maximumLabelSize lineBreakMode:policy.lineBreakMode];
        [self.view addSubview:policy];
        CGRect newFrame = policy.frame;
        newFrame.size.height = expectedLabelSize.height + 10;
        policy.frame = newFrame;
        [policy removeFromSuperview];
        
        height = newFrame.size.height + 80;
    }else if (indexPath.row == 3){
        height = 460;
    }else{
        height = serviceTextView.frame.origin.y + serviceTextView.frame.size.height + 4;
    }

    return height;
    
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%drows:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (tableView == questionTable){
        cell.textLabel.text = @"質問事項";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,2,240,40)];
        questionLabel.text = @"店舗について";
        questionLabel.textAlignment = NSTextAlignmentRight;
        questionLabel.font = [UIFont boldSystemFontOfSize:14];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:questionLabel];
        return cell;
    }
    if (indexPath.row == 0) {
        
        
        //プライバシーポリシーへ飛ぶ
        //バリエーションのテキストボタン
        UILabel *selectMenuLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,20,300,20)];
        selectMenuLabel1.text = @"1.プライバシーポリシー";
        selectMenuLabel1.font = [UIFont systemFontOfSize:16];
        selectMenuLabel1.backgroundColor = [UIColor clearColor];
        selectMenuLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:selectMenuLabel1];
        UIView *stirngUnderLine = [[UIView alloc] initWithFrame:CGRectMake(0,18,174,1)];
        stirngUnderLine.backgroundColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [selectMenuLabel1 addSubview:stirngUnderLine];
        
        UIButton *selectMenuBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        selectMenuBtn1.frame = CGRectMake(10,20,300,20);
        selectMenuBtn1.backgroundColor = [UIColor clearColor];
        selectMenuBtn1.tag = 1;
        [selectMenuBtn1 addTarget:self
                           action:@selector(goMenu:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectMenuBtn1];
        
        
        //バリエーションのテキストボタン
        UILabel *selectMenuLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10,60,300,20)];
        selectMenuLabel2.text = @"2.特定商取引法に基づく表記";
        selectMenuLabel2.font = [UIFont systemFontOfSize:16];
        selectMenuLabel2.backgroundColor = [UIColor clearColor];
        selectMenuLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:selectMenuLabel2];
        UIView *stirngUnderLine2 = [[UIView alloc] initWithFrame:CGRectMake(0,18,204,1)];
        stirngUnderLine2.backgroundColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [selectMenuLabel2 addSubview:stirngUnderLine2];

        UIButton *selectMenuBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        selectMenuBtn2.frame = CGRectMake(10,60,300,20);
        selectMenuBtn2.backgroundColor = [UIColor clearColor];
        selectMenuBtn2.tag = 2;
        [selectMenuBtn2 addTarget:self
                           action:@selector(goMenu:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectMenuBtn2];
        
        
        //バリエーションのテキストボタン
        UILabel *selectMenuLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10,100,300,20)];
        selectMenuLabel3.text = @"3.お問い合わせ";
        selectMenuLabel3.font = [UIFont systemFontOfSize:16];
        selectMenuLabel3.backgroundColor = [UIColor clearColor];
        selectMenuLabel3.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [cell.contentView addSubview:selectMenuLabel3];
        
        UIView *stirngUnderLine3 = [[UIView alloc] initWithFrame:CGRectMake(0,18,110,1)];
        stirngUnderLine3.backgroundColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [selectMenuLabel3 addSubview:stirngUnderLine3];
        
        UIButton *selectMenuBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        selectMenuBtn3.frame = CGRectMake(10,100,300,20);
        selectMenuBtn3.backgroundColor = [UIColor clearColor];
        selectMenuBtn3.tag = 3;
        [selectMenuBtn3 addTarget:self
                           action:@selector(goMenu:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectMenuBtn3];
        
        
        
        
        
    }else if (indexPath.row == 1) {
        UIView *topLine1 = [[UIView alloc] init];
        topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        topLine1.frame = CGRectMake(0, 0, 320, 1);
        UIView *bottomLine1 = [[UIView alloc] init];
        bottomLine1.backgroundColor = [UIColor whiteColor];
        bottomLine1.frame = CGRectMake(0, 1, 320, 1);
        [cell addSubview:topLine1];
        [cell addSubview:bottomLine1];
        
        
        UILabel *policyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,240,40)];
        policyLabel.text = @"1.プライバシーポリシー";
        policyLabel.textAlignment = NSTextAlignmentLeft;
        policyLabel.font = [UIFont boldSystemFontOfSize:18];
        policyLabel.backgroundColor = [UIColor clearColor];
        policyLabel.textColor = [UIColor blackColor];
        [cell addSubview:policyLabel];
        //cell.textLabel.text = @"1.プライバシーポリシー";
        
        
        UILabel *policy = [[UILabel alloc] initWithFrame:CGRectMake(10,59,280,22)];
        policy.text = privacy;
        policy.textAlignment = NSTextAlignmentLeft;
        policy.font = [UIFont systemFontOfSize:16];
        policy.textColor = [UIColor grayColor];
        policy.backgroundColor = [UIColor clearColor];
        policy.numberOfLines = 0;
        CGSize maximumLabelSize = CGSizeMake(280, 3000);
        CGSize expectedLabelSize = [policy.text sizeWithFont:policy.font constrainedToSize:maximumLabelSize lineBreakMode:policy.lineBreakMode];
        [cell addSubview:policy];
        CGRect newFrame = policy.frame;
        newFrame.size.height = expectedLabelSize.height + 10;
        policy.frame = newFrame;
        //cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    }else if (indexPath.row == 2) {
        UIView *topLine1 = [[UIView alloc] init];
        topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        topLine1.frame = CGRectMake(0, 0, 320, 1);
        UIView *bottomLine1 = [[UIView alloc] init];
        bottomLine1.backgroundColor = [UIColor whiteColor];
        bottomLine1.frame = CGRectMake(0, 1, 320, 1);
        [cell addSubview:topLine1];
        [cell addSubview:bottomLine1];
        
        [cell.contentView addSubview:userInfoLabel];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:addressLabel];
        [cell.contentView addSubview:postcodeLabel];
        [cell.contentView addSubview:address];
        
        [cell.contentView addSubview:contactLabel];
        [cell.contentView addSubview:tel];
        [cell.contentView addSubview:contact];
        [cell.contentView addSubview:priceLabel];
        [cell.contentView addSubview:priceTextView];
        priceTextView.hidden = NO;
        [cell.contentView addSubview:payLabel];
        [cell.contentView addSubview:payTextView];
        payTextView.hidden = NO;
        [cell.contentView addSubview:returnLabel];
        [cell.contentView addSubview:returnTextView];
        returnTextView.hidden = NO;
        [cell.contentView addSubview:serviceLabel];
        [cell.contentView addSubview:serviceTextView];
        serviceTextView.hidden = NO;
        
        
    }else if (indexPath.row == 3){
        UIView *topLine1 = [[UIView alloc] init];
        topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        topLine1.frame = CGRectMake(0, 0, 320, 1);
        UIView *bottomLine1 = [[UIView alloc] init];
        bottomLine1.backgroundColor = [UIColor whiteColor];
        bottomLine1.frame = CGRectMake(0, 1, 320, 1);
        [cell addSubview:topLine1];
        [cell addSubview:bottomLine1];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,240,40)];
        titleLabel.text = @"3.お問い合わせ";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        
        //お名前フォーム
        userNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 62, 300, 44)];
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
        [cell.contentView addSubview:userNameField];
        
        
        //メールフォーム
        emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 124, 300, 44)];
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
        [cell.contentView addSubview:emailField];
        
        
        
        //公開テーブル
        questionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 184, 320, 60) style:UITableViewStyleGrouped];
        questionTable.dataSource = self;
        questionTable.delegate = self;
        questionTable.tag = 1;
        questionTable.backgroundView = nil;
        questionTable.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:questionTable];
        
        
        
        
        
        questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 248, 300, 120)];
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
        [cell.contentView addSubview:questionTextView];
        
        
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
        
        
        
        
        //保存ボタン
        UIImage *saveImage = [UIImage imageNamed:@"btn_01"];
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake( 20, 382, 280, 50);
        sendButton.tag = 100;
        [sendButton setBackgroundImage:saveImage forState:UIControlStateNormal];
        //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendQuestion:)forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:sendButton];
        
        
        //ボタンテキスト
        UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,345,240,40)];
        sendLabel.text = @"送信する";
        sendLabel.center = CGPointMake(140, 25);
        sendLabel.textAlignment = NSTextAlignmentCenter;
        sendLabel.font = [UIFont boldSystemFontOfSize:20];
        sendLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        sendLabel.shadowOffset = CGSizeMake(0.f, -1.f);
        sendLabel.backgroundColor = [UIColor clearColor];
        sendLabel.textColor = [UIColor whiteColor];
        [sendButton addSubview:sendLabel];
        
    }else{
        UIView *topLine1 = [[UIView alloc] init];
        topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        topLine1.frame = CGRectMake(0, 0, 320, 1);
        UIView *bottomLine1 = [[UIView alloc] init];
        bottomLine1.backgroundColor = [UIColor whiteColor];
        bottomLine1.frame = CGRectMake(0, 1, 320, 1);
        [cell addSubview:topLine1];
        [cell addSubview:bottomLine1];
    }
    
    
    
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}


//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == questionTable) {
        [self selectNumber];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"%d:番目が押されているよ！",indexPath.row);
    }
    
}


//数量のピッカー
- (void)selectNumber{
    
    
    
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
            return [NSString stringWithFormat:@"1.店舗について"];
            break;
        case 1: // 2列目
            return [NSString stringWithFormat:@"2.商品について"];
            break;
            
        case 2: // 3列目
            return [NSString stringWithFormat:@"3.発送について"];
            break;
        case 3: // 4列目
            return [NSString stringWithFormat:@"4.その他"];
            break;
        default:
            return 0;
            break;
    }
    
}

//数量のピッカーを消す
- (void)dismissActionSheet:(id)sender{
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if ([stockPicker selectedRowInComponent:0] == 0) {
        questionLabel.text = @"店舗について";
    }else if ([stockPicker selectedRowInComponent:0] == 1){
        questionLabel.text = @"商品について";
    }else if ([stockPicker selectedRowInComponent:0] == 2){
        questionLabel.text = @"発送について";
    }else if ([stockPicker selectedRowInComponent:0] == 3){
        questionLabel.text = @"その他";
    }
    //stockLabel1.text = [NSString stringWithFormat:@"%d", stock1];
    
}

//商品説明のキーボードの完了ボタン
-(void)closeKeyboard:(id)sender{
    [questionTextView resignFirstResponder];
}


- (void)goMenu:(id)sender{
    if ([sender tag] == 1) {
        NSLog(@"押せてるよ");
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [shopInfoTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if ([sender tag] == 2) {
        NSLog(@"押せてるよ");
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [shopInfoTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else if ([sender tag] == 3) {
        NSLog(@"押せてるよ");
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [shopInfoTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:shopInfoTable];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [shopInfoTable setContentOffset:pt animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:shopInfoTable];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    
    [shopInfoTable setContentOffset:pt animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [shopInfoTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
- (void)textViewDidEndEditing:(UITextField *)textField{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [shopInfoTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)dismissModal:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

//送信ボタン挙動
-(void)sendQuestion:(id)sender{
    [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];
    
    /*
    NSString *encodedEmail = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                           NULL,
                                                                                           (__bridge CFStringRef) emailField.text,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8));
     */
    
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) emailField.text,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    
    NSLog(@"encodedEmail%@",escapedString);
    NSString *urlString = [NSString stringWithFormat:@"%@/shop_inquiries/inquiry?user_id=%@&title=%@&name=%@&mail_address=%@&inquiry=%@",apiUrl,[userId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[questionLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[userNameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],escapedString,[questionTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"おせてます%@",urlString);
    //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [[BSBuyerAPIClient sharedClient] getShopInquiriesWithUserId:[userId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] title:[questionLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] name:[userNameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mailAddress:escapedString inquiry:[questionTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getShopInquiriesWithUserId: %@", results);
        NSArray *nameArray = [results valueForKeyPath:@"error.validations.ShopInquiry.name"];
        if (nameArray.count) {
            NSString *nameError = nameArray[0];
            [SVProgressHUD showErrorWithStatus:nameError];
            return ;
        }
        NSArray *mailArray = [results valueForKeyPath:@"error.validations.ShopInquiry.mail_address"];
        if (mailArray.count) {
            NSString *mail = mailArray[0];
            [SVProgressHUD showErrorWithStatus:mail];
            return ;
        }
        NSArray *inquiryArray = [results valueForKeyPath:@"error.validations.ShopInquiry.inquiry"];
        if (inquiryArray.count) {
            NSString *inquiry = inquiryArray[0];
            [SVProgressHUD showErrorWithStatus:inquiry];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
        
        
        
    }];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
