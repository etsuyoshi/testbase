//
//  BSConfirmCheckoutViewController.m
//  BASE
//
//  Created by Takkun on 2013/05/15.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSConfirmCheckoutViewController.h"

#import "BSSelectPaymentTableViewController.h"
#import "BSThankYouViewController.h"
#import "BSPaypalViewController.h"



@interface BSConfirmCheckoutViewController ()

@end

@implementation BSConfirmCheckoutViewController{
    UIScrollView *scrollView;
    NSMutableDictionary *orderInfo;
    
    
    UITableView *confirmInfoTable;
    
    NSArray *orderItem;
    NSString *imageUrl;
    
    id jsonData;
    
    NSString *apiUrl;
    
    UITextView *commentTextView;
    
}
static NSString *importShopId = nil;
static NSString *importPayment = nil;


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
    self.trackedViewName = @"confirmCheckout";
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
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
    label.text = @"購入";
    [label sizeToFit];
    self.title = @"購入";

    self.navigationItem.titleView = label;
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"決済方法" target:self action:@selector(backRoot) side:1];
        self.navigationItem.leftBarButtonItem = backButton;
    }else{
        

    }
    
    if ([BSDefaultViewObject isMoreIos7]) {
       //confirmInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height - 64)];
        confirmInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height) style:UITableViewStyleGrouped];

    }else{
        confirmInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,self.view.bounds.size.height - 44)];
    }
    
    confirmInfoTable.dataSource = self;
    confirmInfoTable.delegate = self;
    confirmInfoTable.tag = 1;
    confirmInfoTable.backgroundView = nil;
    [self.view addSubview:confirmInfoTable];
    
    
    orderInfo = [[BSSelectPaymentTableViewController getCartItem] mutableCopy];
    //NSDictionary *checkOrderInfo = [BSPurchaseViewController checkCartItem];
    NSLog(@"orderInfo:%@",orderInfo);
    //NSLog(@"checkOrderInfo:%@",checkOrderInfo);

   
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, 300, 100)];
    commentTextView.layer.borderWidth = 1.0;
    commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    commentTextView.layer.cornerRadius = 4.0;
    
    //ツールバーを生成
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //スタイルの設定
    toolBar.barStyle = UIBarStyleDefault;
    //ツールバーを画面サイズに合わせる
    [toolBar sizeToFit];
    // 「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //　完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStylePlain target:self action:@selector(closeKeyboard)];
    // ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    // 表示・非表示の設定
    [toolBar setItems:toolBarItems animated:YES];
    commentTextView.inputAccessoryView = toolBar;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@"注文情報を確認中" maskType:SVProgressHUDMaskTypeGradient];
    //商品内容を確認
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/confirm_checkout",apiUrl]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    orderInfo[@"remark"] = commentTextView.text;
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:orderInfo];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"注文内容の取得: %@", JSON);
        jsonData = JSON;
        NSDictionary *error = JSON[@"error"];
        NSString *errormessage = [JSON valueForKeyPath:@"error.message"];
        NSString *errormessage2 = [JSON valueForKeyPath:@"result.Cart.0.error"];
        orderItem = @[];
        orderItem = [JSON valueForKeyPath:@"result.Cart"];
        NSLog(@"取得して%@",orderItem);
        imageUrl = [JSON valueForKeyPath:@"image_url"];
        
        if (error) {
            NSLog(@"エラーメッセージ%@",errormessage);
            NSLog(@"エラーメッセージ2%@",errormessage2);
            [confirmInfoTable reloadData];

            [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"完了"];
            [confirmInfoTable reloadData];

        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
}


/*************************************テーブルビュー*************************************/


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if (section == 0) {
        rows = 7;
    }else if (section == 1){
        rows = orderItem.count;
    }else{
        rows = 2;
    }
    
    return rows;
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}
 */





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int height;
    height = 60;
    if (indexPath.section == 0) {
        if (indexPath.row == 2){
            NSString *prefecture = orderInfo[@"prefecture"];
            NSString *addressInfo = orderInfo[@"address"];
            NSString *addressInfo2 = orderInfo[@"address2"];
            //住所
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(10,10,280,30)];
            address.text = [NSString stringWithFormat:@"%@%@%@",prefecture,addressInfo,addressInfo2];
            address.textAlignment = NSTextAlignmentLeft;
            address.font = [UIFont boldSystemFontOfSize:20];
            address.textColor = [UIColor darkGrayColor];
            address.backgroundColor = [UIColor clearColor];
            address.numberOfLines = 0;
            //表示しない
            address.hidden = YES;
            CGSize maximumLabelSize = CGSizeMake(280, 200);
            CGSize expectedLabelSize = [address.text sizeWithFont:address.font constrainedToSize:maximumLabelSize lineBreakMode:address.lineBreakMode];
            [self.view addSubview:address];
            CGRect newFrame = address.frame;
            newFrame.size.height = expectedLabelSize.height;
            address.frame = newFrame;
            [address removeFromSuperview];
            
            return newFrame.size.height + 40;
            
            
        }
        if (indexPath.row == 6) {
            //備考欄
         

            return 140;
        }
    }else if (indexPath.section == 1){
        height = 107;
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            height = 60;

        }else{
            height = 180;
        }
    }
    return height;
    
}

//セクションのカスタマイズ

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 22)];
    sectionLabel.backgroundColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0];
    sectionLabel.textColor = [UIColor colorWithRed:8.0f/255.0f green:8.0f/255.0f blue:8.0f/255.0f alpha:1.0];
    switch (section) {
        case 0:
            sectionLabel.text = @"注文情報";
            sectionLabel.textColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
            break;
        case 1:
            sectionLabel.text = @"注文商品";
            sectionLabel.textColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];

            break;
        case 2:
            sectionLabel.text = @"お支払い合計金額";
            sectionLabel.textColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];

            break;
        default:
            break;
    }
    sectionLabel.font = [UIFont systemFontOfSize:14];
    [sectionHeaderView addSubview:sectionLabel];
    return sectionHeaderView;
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"注文情報";
            break;
        case 1:
            return @"注文商品";
            
            break;
        case 2:
            return @"お支払い合計金額";
            
            break;
        default:
            break;
    }
    return nil; //ビルド警告回避用
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%drows:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.section == 0) {
        
        

        
        
        NSString *firstName = orderInfo[@"first_name"];
        NSString *lastName = orderInfo[@"last_name"];
        NSString *postcodeInfo = orderInfo[@"zip_code"];
        NSString *prefecture = orderInfo[@"prefecture"];
        NSString *addressInfo = orderInfo[@"address"];
        NSString *addressInfo2 = orderInfo[@"address2"];
        NSString *telInfo = orderInfo[@"tel"];
        NSString *mailInfo = orderInfo[@"mail_address"];
        NSString *remarkInfo = orderInfo[@"remark"];
        NSString *paymentInfo = orderInfo[@"payment"];
        importPayment = orderInfo[@"payment"];
        if ([paymentInfo isEqualToString:@"cod"]) {
            paymentInfo = @"代金引換";
        }else if ([paymentInfo isEqualToString:@"bt"]) {
            paymentInfo = @"銀行振込";
        }else{
            paymentInfo = @"クレジットカード決済";
        }
        if (indexPath.row == 0) {
            
            
            
            //氏名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            nameLabel.text = @"氏名";
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:16];
            nameLabel.textColor = [UIColor lightGrayColor];
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            
            //氏名
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15,(nameLabel.frame.origin.y + nameLabel.frame.size.height),320,30)];
            name.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
            name.textAlignment = NSTextAlignmentLeft;
            name.font = [UIFont boldSystemFontOfSize:20];
            name.textColor = [UIColor darkGrayColor];
            name.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:name];
            
        }else if (indexPath.row == 1){
            //郵便番号
            UILabel *postcodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            postcodeLabel.text = @"郵便番号";
            postcodeLabel.textAlignment = NSTextAlignmentLeft;
            postcodeLabel.font = [UIFont boldSystemFontOfSize:16];
            postcodeLabel.textColor = [UIColor lightGrayColor];
            postcodeLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:postcodeLabel];
            
            //郵便番号
            UILabel *postcode = [[UILabel alloc] initWithFrame:CGRectMake(15,(postcodeLabel.frame.origin.y + postcodeLabel.frame.size.height),320,30)];
            postcode.text = postcodeInfo;
            postcode.textAlignment = NSTextAlignmentLeft;
            postcode.font = [UIFont boldSystemFontOfSize:20];
            postcode.textColor = [UIColor darkGrayColor];
            postcode.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:postcode];

        }else if (indexPath.row == 2){
            //住所
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            addressLabel.text = @"住所";
            addressLabel.textAlignment = NSTextAlignmentLeft;
            addressLabel.font = [UIFont boldSystemFontOfSize:16];
            addressLabel.textColor = [UIColor lightGrayColor];
            addressLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:addressLabel];
            
            //住所
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(15,(addressLabel.frame.origin.y + addressLabel.frame.size.height),280,30)];
            address.text = [NSString stringWithFormat:@"%@%@%@",prefecture,addressInfo,addressInfo2];
            address.textAlignment = NSTextAlignmentLeft;
            address.font = [UIFont boldSystemFontOfSize:20];
            address.textColor = [UIColor darkGrayColor];
            address.backgroundColor = [UIColor clearColor];
            address.numberOfLines = 0;
            CGSize maximumLabelSize = CGSizeMake(280, 200);
            CGSize expectedLabelSize = [address.text sizeWithFont:address.font constrainedToSize:maximumLabelSize lineBreakMode:address.lineBreakMode];
            [cell.contentView addSubview:address];
            CGRect newFrame = address.frame;
            newFrame.size.height = expectedLabelSize.height + 10;
            address.frame = newFrame;
    
        }else if (indexPath.row == 3){
            //電話番号
            UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            telLabel.text = @"電話番号";
            telLabel.textAlignment = NSTextAlignmentLeft;
            telLabel.font = [UIFont boldSystemFontOfSize:16];
            telLabel.textColor = [UIColor lightGrayColor];
            telLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:telLabel];
            
            //電話番号
            UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(15,(telLabel.frame.origin.y + telLabel.frame.size.height),320,30)];
            tel.text = telInfo;
            tel.textAlignment = NSTextAlignmentLeft;
            tel.font = [UIFont boldSystemFontOfSize:20];
            tel.textColor = [UIColor darkGrayColor];
            tel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tel];
            

        }else if (indexPath.row == 4){
            //メールアドレス
            UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            mailLabel.text = @"メールアドレス";
            mailLabel.textAlignment = NSTextAlignmentLeft;
            mailLabel.font = [UIFont boldSystemFontOfSize:16];
            mailLabel.textColor = [UIColor lightGrayColor];
            mailLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:mailLabel];
            
            //メールアドレス
            UILabel *mail = [[UILabel alloc] initWithFrame:CGRectMake(15,(mailLabel.frame.origin.y + mailLabel.frame.size.height),320,30)];
            mail.text = mailInfo;
            mail.textAlignment = NSTextAlignmentLeft;
            mail.font = [UIFont boldSystemFontOfSize:18];
            mail.textColor = [UIColor darkGrayColor];
            mail.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:mail];
            
        }else if (indexPath.row == 6){
            //備考欄
            UILabel *commentLable = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            commentLable.text = @"備考欄(お店へのご要望等)";
            commentLable.textAlignment = NSTextAlignmentLeft;
            commentLable.font = [UIFont boldSystemFontOfSize:16];
            commentLable.textColor = [UIColor lightGrayColor];
            commentLable.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:commentLable];
            
            
            //備考欄
            /*
            UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(15,(commentLable.frame.origin.y + commentLable.frame.size.height),280,30)];
            comment.text = remarkInfo;
            comment.textAlignment = NSTextAlignmentLeft;
            comment.font = [UIFont boldSystemFontOfSize:20];
            comment.textColor = [UIColor darkGrayColor];
            comment.backgroundColor = [UIColor clearColor];
            comment.numberOfLines = 0;
            CGSize maximumLabelSize2 = CGSizeMake(280, 200);
            CGSize expectedLabelSize2 = [comment.text sizeWithFont:comment.font constrainedToSize:maximumLabelSize2 lineBreakMode:comment.lineBreakMode];
            [cell.contentView addSubview:comment];
            CGRect newFrame2 = comment.frame;
            newFrame2.size.height = expectedLabelSize2.height + 10;
            comment.frame = newFrame2;
             */
            
            [cell.contentView addSubview:commentTextView];

            

        }else if (indexPath.row == 5){
            //支払い方法
            UILabel *paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,2,320,24)];
            paymentLabel.text = @"支払い方法";
            paymentLabel.textAlignment = NSTextAlignmentLeft;
            paymentLabel.font = [UIFont boldSystemFontOfSize:16];
            paymentLabel.textColor = [UIColor lightGrayColor];
            paymentLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:paymentLabel];
            
            
            //支払い方法
            UILabel *payment = [[UILabel alloc] initWithFrame:CGRectMake(15,(paymentLabel.frame.origin.y + paymentLabel.frame.size.height),320,30)];
            payment.text = paymentInfo;
            payment.textAlignment = NSTextAlignmentLeft;
            payment.font = [UIFont boldSystemFontOfSize:20];
            payment.textColor = [UIColor darkGrayColor];
            payment.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:payment];
            
            

        }
    }
    if (indexPath.section == 1){
        if (indexPath.row == orderItem.count - 1) {
        
        }else{
     
        }
        
        
            NSLog(@"orderItem111:%@",orderItem);
            UIImageView *itemImageView = [[UIImageView alloc] initWithImage:nil];
            itemImageView.frame = CGRectMake(18, 13, 75, 75);
            [cell.contentView addSubview:itemImageView];
        
    
        NSDictionary *item = orderItem[indexPath.row];
        
            //アイテム情報を整理
            //NSDictionary *itemInfoDictionary = [itemsInfoArray objectAtIndex:indexPath.row - 1];
            NSString *title = [item valueForKeyPath:[NSString stringWithFormat:@"title"]];
            NSString *price = [item valueForKeyPath:[NSString stringWithFormat:@"price"]];
            NSString *imageName = [item valueForKeyPath:[NSString stringWithFormat:@"img"]];
            //NSString *itemId = [itemInfoDictionary objectForKey:@"item"];
            //int incVariation = [[itemInfoDictionary objectForKey:@"incVariation"] intValue];
            
            
            
            
            
            //お金表記変換
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([price intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            
            
            
            NSString *url = [NSString stringWithFormat:@"%@%@",imageUrl,imageName];
            NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSLog(@"画像のurl%@",url);
            if ([imageName isEqual:[NSNull null]] || [imageName isEqualToString:@""]) {
                UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                [itemImageView setImage:noImage1];
                
                
                UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                [noImageView2 setFrame:CGRectMake(12.5, 12.5, 50, 50)];
                [itemImageView addSubview:noImageView2];
            }else{
                AFImageRequestOperation *operation = [AFImageRequestOperation
                                                      imageRequestOperationWithRequest: getImageRequest
                                                      imageProcessingBlock: nil
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *getImage) {
                                                          [itemImageView setImage:getImage];
                                                          
                                                          
                                                      }
                                                      failure: nil];
                [operation start];
            }
            
            
            //商品名
            UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(103,10,100,100)];
            itemTitle.text = title;
            itemTitle.textAlignment = NSTextAlignmentLeft;
            itemTitle.font = [UIFont systemFontOfSize:16];
            itemTitle.textColor = [UIColor blackColor];
            itemTitle.backgroundColor = [UIColor clearColor];
            itemTitle.numberOfLines = 5;
            [itemTitle sizeToFit];
            [cell.contentView addSubview:itemTitle];
            
            //値段
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(204,10,102,20)];
            priceLabel.text = strPrice;
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = [UIFont boldSystemFontOfSize:16];
            priceLabel.textColor = [UIColor lightGrayColor];
            
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.numberOfLines = 1;
            [cell.contentView addSubview:priceLabel];
            
            
            
            //NSLog(@"商品自体の個数%@",stockArray);
            
            
            /*
             
             // 表示する文字に応じてボタンサイズを変更する
             int rows = 0;
             for (int n = 0; n < indexPath.section; n++) {
             rows = rows + [[itemRowsArray objectAtIndex:n] intValue];
             }
             NSLog(@"itemRowsArray:%@",itemRowsArray);
             NSLog(@"cartSelectedStockArray:%@",cartSelectedStockArray);
             NSString *stockString = @"0";
             if (rows + (indexPath.row - 1)<cartSelectedStockArray.count) {
             stockString = [cartSelectedStockArray objectAtIndex:rows + (indexPath.row - 1)];
             }
             UIFont *stockFont = [UIFont systemFontOfSize:12.f];
             CGSize stockTextSize = [stockString sizeWithFont:stockFont];
             CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
             */
            
            /*
             // ボタンを用意する
             BSTableCellButton *varyStockButton = [[BSTableCellButton alloc] initWithFrame:CGRectMake(315 - stockButtonSize.width, (priceLabel.frame.size.height + priceLabel.frame.origin.y)  + 10, stockButtonSize.width, stockButtonSize.height)];
             [varyStockButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
             varyStockButton.tag = 300000;
             [varyStockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
             */
            
            
            // ラベルを用意する
            UILabel *varyStocklabel = [[UILabel alloc] initWithFrame:CGRectMake(204,30,102,20)];
            varyStocklabel.text = [NSString stringWithFormat:@"%@個",[item valueForKeyPath:[NSString stringWithFormat:@"amount"]]];
            varyStocklabel.textColor = [UIColor colorWithRed:3.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
            varyStocklabel.font = [UIFont boldSystemFontOfSize:16];
            varyStocklabel.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            varyStocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
            varyStocklabel.backgroundColor = [UIColor clearColor];
            varyStocklabel.textAlignment = NSTextAlignmentRight;
            varyStocklabel.tag = 300000;
            [cell.contentView addSubview:varyStocklabel];
            //[cell addSubview:varyStockButton];
            
            
            // ラベルを用意する
            numPrice = @([[item valueForKeyPath:[NSString stringWithFormat:@"subtotal"]] intValue]);
            NSString *subtotal = [nf stringFromNumber:numPrice];
            
            UILabel *subtotallabel = [[UILabel alloc] initWithFrame:CGRectMake(144,71,162,20)];
            subtotallabel.text = [NSString stringWithFormat:@"計 : %@円",subtotal];
            subtotallabel.textColor = [UIColor colorWithRed:3.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
            subtotallabel.font = [UIFont boldSystemFontOfSize:16];
            subtotallabel.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            subtotallabel.shadowOffset = CGSizeMake(0.f, 0.1f);
            subtotallabel.backgroundColor = [UIColor clearColor];
            subtotallabel.textAlignment = NSTextAlignmentRight;
            subtotallabel.tag = 300000;
            [cell.contentView addSubview:subtotallabel];
            /*
             BSTableCellButton *theButton = (BSTableCellButton *)[cell viewWithTag:300000];
             if (theButton) {
             theButton.section = [indexPath section];
             theButton.row = [indexPath row];
             }
             */
            /*
             if ([[stockArray objectAtIndex:rows + indexPath.row - 1] intValue] == 0) {
             varyStocklabel.hidden = YES;
             
             // ラベルを用意する
             UILabel *soldOutlabel = [[UILabel alloc] initWithFrame:CGRectMake(204,50,102,20)];
             soldOutlabel.text = @"SOLD OUT";
             soldOutlabel.textColor = [UIColor colorWithRed:247.0/255.0 green:161.0/255.0 blue:174.0/255.0 alpha:1.0];
             soldOutlabel.font = stockFont;
             //soldOutlabel.shadowColor = [UIColor colorWithRed:247.0/255.0 green:161.0/255.0 blue:174.0/255.0 alpha:1.0];
             soldOutlabel.shadowOffset = CGSizeMake(0.f, 0.1f);
             soldOutlabel.backgroundColor = [UIColor clearColor];
             soldOutlabel.textAlignment = NSTextAlignmentRight;
             [cell addSubview:soldOutlabel];
             }
             */
            
            
            
            /*
             
             if (incVariation) {
             
             //数量andバリエーション
             UIImage *image = [UIImage imageNamed:@"selector"];
             // 左右 17px 固定で引き伸ばして利用する
             image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
             
             // 表示する文字に応じてボタンサイズを変更する
             NSString *varyString = variation;
             UIFont *font = [UIFont systemFontOfSize:12.f];
             CGSize textSize2 = [varyString sizeWithFont:font];
             CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
             
             // ボタンを用意する
             UIButton *varyNameButton = [[UIButton alloc] initWithFrame:CGRectMake(264, (varyStockButton.frame.size.height + varyStockButton.frame.origin.y) + 10, buttonSize.width, buttonSize.height)];
             [varyNameButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
             
             [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
             // ラベルを用意する
             UILabel *varyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(104,90,202,20)];
             varyNamelabel.text = varyString;
             varyNamelabel.textColor = [UIColor colorWithRed:3.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
             varyNamelabel.font = [UIFont boldSystemFontOfSize:14];
             varyNamelabel.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
             varyNamelabel.shadowOffset = CGSizeMake(0.f, 0.1f);
             varyNamelabel.backgroundColor = [UIColor clearColor];
             varyNamelabel.textAlignment = NSTextAlignmentRight;
             [cell addSubview:varyNamelabel];
             //[cell addSubview:varyNameButton];
             //varyNameButton.frame = CGRectMake(315 - buttonSize.width, (varyStockButton.frame.size.height + varyStockButton.frame.origin.y) + 10, buttonSize.width, buttonSize.height);
             }
             
             */
            /*
             UIView *topLine1 = [[UIView alloc] init];
             topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
             topLine1.frame = CGRectMake(0, 138, 320, 1);
             UIView *bottomLine1 = [[UIView alloc] init];
             bottomLine1.backgroundColor = [UIColor whiteColor];
             bottomLine1.frame = CGRectMake(0, 139, 320, 1);
             [cell addSubview:topLine1];
             [cell addSubview:bottomLine1];
             */
            
    }
    if(indexPath.section == 2){
        if (indexPath.row == 1){
            
            if ([BSDefaultViewObject isMoreIos7]) {
                
                UIImage *buyImage = [UIImage imageNamed:@"btn_7_04"];
                
                UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                buyButton.frame = CGRectMake( 10, 5, 300, 50);
                buyButton.tag = 1;
                [buyButton setTitle:@"購入を確定する" forState:UIControlStateNormal];
                [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [buyButton addTarget:self action:@selector(decision:)forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buyButton];
                
        
                
            }else{
                UIImage *buyImage = [UIImage imageNamed:@"btn_04"];
                
                UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                buyButton.frame = CGRectMake( 10, 5, 300, 50);
                buyButton.tag = 1;
                [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [buyButton addTarget:self action:@selector(decision:)forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buyButton];
                
                
                //ボタンテキスト
                UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,10,240,40)];
                buyLabel.text = @"購入を確定する";
                buyLabel.textAlignment = NSTextAlignmentCenter;
                buyLabel.font = [UIFont boldSystemFontOfSize:20];
                buyLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
                buyLabel.shadowOffset = CGSizeMake(0.f, -1.f);
                buyLabel.backgroundColor = [UIColor clearColor];
                buyLabel.textColor = [UIColor whiteColor];
                [cell.contentView addSubview:buyLabel];

            }
        }else{
            //お金表記変換
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([[jsonData valueForKeyPath:@"result.subtotal"] intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            
            //購入金額
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,12,140,30)];
            priceLabel.text = @"商品:";
            priceLabel.textAlignment = NSTextAlignmentLeft;
            priceLabel.font = [UIFont boldSystemFontOfSize:18];
            priceLabel.textColor = [UIColor darkGrayColor];
            priceLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:priceLabel];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(164,12,140,30)];
            price.text = strPrice;
            price.textAlignment = NSTextAlignmentRight;
            price.font = [UIFont boldSystemFontOfSize:18];
            price.textColor = [UIColor darkGrayColor];
            price.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:price];
            
            
            //送料
            numPrice = @([[jsonData valueForKeyPath:@"result.DeliveryFee.fee"] intValue]);
            NSString *fee = [nf stringFromNumber:numPrice];
            UILabel *carriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(priceLabel.frame.origin.y + priceLabel.frame.size.height) + 10,140,30)];
            carriageLabel.text = @"送料：";
            carriageLabel.textAlignment = NSTextAlignmentLeft;
            carriageLabel.font = [UIFont boldSystemFontOfSize:18];
            carriageLabel.textColor = [UIColor darkGrayColor];
            carriageLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:carriageLabel];
            
            UILabel *carriage = [[UILabel alloc] initWithFrame:CGRectMake(164,(priceLabel.frame.origin.y + priceLabel.frame.size.height) + 10,140,30)];
            carriage.text = fee;
            carriage.textAlignment = NSTextAlignmentRight;
            carriage.font = [UIFont boldSystemFontOfSize:18];
            carriage.textColor = [UIColor darkGrayColor];
            carriage.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:carriage];
            
            
            
            if ([[jsonData valueForKeyPath:@"result.Order.payment"] isEqualToString:@"cod"]) {
                //合計金額のお金表記変換
                numPrice = @([[jsonData valueForKeyPath:@"result.Shop.charge"] intValue]);
                NSString *strCodPrice = [nf stringFromNumber:numPrice];
                
                //合計金額
                UILabel *codLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(carriageLabel.frame.origin.y + carriageLabel.frame.size.height) + 10,140,30)];
                codLabel.text = @"代引き手数料：";
                codLabel.textAlignment = NSTextAlignmentLeft;
                codLabel.font = [UIFont boldSystemFontOfSize:18];
                codLabel.textColor = [UIColor darkGrayColor];
                codLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:codLabel];
                
                UILabel *cod = [[UILabel alloc] initWithFrame:CGRectMake(164,(carriageLabel.frame.origin.y + carriageLabel.frame.size.height) + 10,140,30)];
                cod.text = strCodPrice;
                cod.textAlignment = NSTextAlignmentRight;
                cod.font = [UIFont boldSystemFontOfSize:18];
                cod.textColor = [UIColor darkGrayColor];
                cod.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:cod];
                
                
                //合計金額のお金表記変換
                numPrice = @([[jsonData valueForKeyPath:@"result.total"] intValue]);
                NSString *strTotalPrice = [nf stringFromNumber:numPrice];
                
                //合計金額
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(codLabel.frame.origin.y + codLabel.frame.size.height) + 10,140,30)];
                totalLabel.text = @"合計金額：";
                totalLabel.textAlignment = NSTextAlignmentLeft;
                totalLabel.font = [UIFont boldSystemFontOfSize:18];
                totalLabel.textColor = [UIColor darkGrayColor];
                totalLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:totalLabel];
                
                UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(164,(codLabel.frame.origin.y + codLabel.frame.size.height) + 10,140,30)];
                total.text = strTotalPrice;
                total.textAlignment = NSTextAlignmentRight;
                total.font = [UIFont boldSystemFontOfSize:18];
                total.textColor = [UIColor darkGrayColor];
                total.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:total];
            }else{
                //合計金額のお金表記変換
                numPrice = @([[jsonData valueForKeyPath:@"result.total"] intValue]);
                NSString *strTotalPrice = [nf stringFromNumber:numPrice];
                
                //合計金額
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(carriageLabel.frame.origin.y + carriageLabel.frame.size.height) + 10,140,30)];
                totalLabel.text = @"合計金額：";
                totalLabel.textAlignment = NSTextAlignmentLeft;
                totalLabel.font = [UIFont boldSystemFontOfSize:18];
                totalLabel.textColor = [UIColor darkGrayColor];
                totalLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:totalLabel];
                
                UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(164,(carriageLabel.frame.origin.y + carriageLabel.frame.size.height) + 10,140,30)];
                total.text = strTotalPrice;
                total.textAlignment = NSTextAlignmentRight;
                total.font = [UIFont boldSystemFontOfSize:18];
                total.textColor = [UIColor darkGrayColor];
                total.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:total];
            }
            
            
         
        }
    }
    
   

    return cell;
    
}


- (void)closeKeyboard{
    [commentTextView resignFirstResponder];
    
}

- (void)decision:(id)sender{
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSConfirmCheckoutViewController"
                                                     withAction:@"decision"
                                                      withLabel:nil
                                                      withValue:@100];
    
    
    [SVProgressHUD showWithStatus:@"注文を確定中" maskType:SVProgressHUDMaskTypeGradient];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/checkout",apiUrl]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    orderInfo[@"remark"] = commentTextView.text;
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:orderInfo];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"確定の取得: %@", JSON);
        NSString *error = JSON[@"error"];
        NSString *errormessage = [JSON valueForKeyPath:@"error.message"];
        NSString *paypalErrormessage = [JSON valueForKeyPath:@"error.paypalError"];
        NSLog(@"獲得のエラー%@",errormessage);
        if (paypalErrormessage) {
            [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSConfirmCheckoutViewController"
                                                             withAction:@"failDecision:paypalError"
                                                              withLabel:nil
                                                              withValue:@100];
            [SVProgressHUD showErrorWithStatus:@"PayPal決済が完了出来ませんでした。"];
            UIViewController *parent = (self.navigationController.viewControllers)[1];
            [self.navigationController popToViewController:parent animated:YES];
            return ;
        }
        
        if (error) {
            [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSConfirmCheckoutViewController"
                                                             withAction:@"failDecision:soldout"
                                                              withLabel:nil
                                                              withValue:@100];
            
            [SVProgressHUD showErrorWithStatus:@"商品が売り切れました"];
            UIViewController *parent = (self.navigationController.viewControllers)[1];
            [self.navigationController popToViewController:parent animated:YES];
            return ;
        }
        
        importShopId = [JSON valueForKeyPath:@"order.Shop.shop_id"];
        [SVProgressHUD showSuccessWithStatus:@"注文を完了しました"];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        BSThankYouViewController *vc = [[BSThankYouViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        /*
        if (errormessage == nil && errormessage1 == nil) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
         
        }
         */
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
    }];
    [operation start];

}

- (void)backRoot{
    
        
        int index = [self.navigationController.viewControllers indexOfObject:self];
        NSLog(@"index%d",index);
        // ビューコントローラーが見つかって (index != NSNotFound)、それがルートビューコントローラーでなければ (index > 0)、ひとつ前のビューコントローラーを取得します。
        if (index != NSNotFound && index > 0)
        {
            // ひとつ前のビューコントローラーを取得します。
            UIViewController* backViewController = (self.navigationController.viewControllers)[(index - 1)];
            
            NSLog(@"backViewController%d",backViewController.view.tag);
            if (backViewController.view.tag == 10) {
                backViewController = (self.navigationController.viewControllers)[(index - 2)];
                [self.navigationController popToViewController:backViewController animated:YES];

            } else {
                [self.navigationController popViewControllerAnimated:YES];

            }
            // その、ひとつ前のビューコントローラーに戻ります。
        }
    
    
}


+(NSString*)getShopId {
    return importShopId;
}
+(NSString*)getPayment {
    return importPayment;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
