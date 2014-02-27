//
//  BSCartViewController.m
//  BASE
//
//  Created by Takkun on 2013/05/07.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSCartViewController.h"

#import "BSSelectAddressTableViewController.h"


@interface BSCartViewController ()

@end

@implementation BSCartViewController{
    UITableView *cartTable;
    
    NSArray *cartArray;
    
    NSMutableArray *itemIdArray;
    
    NSMutableArray *shopInfo;
    NSString *shopId;
    UIImageView *backgroundImageView;
    
    NSMutableArray *itemRowsArray;
    
    NSString *imageRootUrl;
    
    UIActionSheet *stockActionSheet;
    UIPickerView *stockPicker;
    BOOL firstButton;
    
    //ストック
    NSMutableArray *stockArray;
    int buttonRow;
    int buttonSection;
    
    NSMutableArray *cartSelectedStockArray;
    
    NSMutableDictionary *orderItemDictionary;
    
    UIImageView *loadingImageView;
    
    NSString *apiUrl;
}
static NSDictionary *importCartDictionary = nil;

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
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.screenName = @"cart";
    
    //UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"cart"];
    //NSUInteger index = [self.navigationController.viewControllers indexOfObject:vc];
    //UIViewController* backViewController = [self.navigationController.viewControllers objectAtIndex:(index - 1)];
    
    int index = [self.navigationController.viewControllers count];
    UIViewController *parent = (self.navigationController.viewControllers)[index-2];
    
    NSLog(@"title:%@",parent.title);
    
    
    
	// Do any additional setup after loading the view.
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
    }
    
    
    /*
    //ナビゲーションバー
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ショッピングカート"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    */
    self.title = @"カート";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"ショッピングカート";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
        cartTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
        cartTable.scrollEnabled = YES;
        cartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        cartTable.backgroundColor = [UIColor clearColor];
        cartTable.tag = 1;
        cartTable.dataSource = self;
        cartTable.delegate = self;
        [self.view insertSubview:cartTable belowSubview:self.navigationController.navigationBar];
        

    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"商品詳細" target:self action:@selector(backRoot) side:1];
        self.navigationItem.leftBarButtonItem = backButton;
        
        cartTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44) style:UITableViewStylePlain];
        cartTable.scrollEnabled = YES;
        cartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        cartTable.backgroundColor = [UIColor clearColor];
        cartTable.tag = 1;
        cartTable.dataSource = self;
        cartTable.delegate = self;
        [self.view insertSubview:cartTable belowSubview:self.navigationController.navigationBar];
    }
    
    

    
    
    
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    cartArray = [userDefaults arrayForKey:@"cart"];
    NSLog(@"デバイス内のカート情報%@",cartArray);

    
    
    /*
    //カートの中身を店舗別に整理
    if (cartArray.count) {
        //すべてのカートの中身
        NSMutableArray *arrangeCartInfo = [NSMutableArray array];
        //ショップごとのカートの中身
        NSMutableArray *arrangeShopInfo = [NSMutableArray array];
        for (int n = 0; n < cartArray.count; n++) {
        
            NSDictionary *itemDict = [cartArray objectAtIndex:n];
            
            //最初の場合だけそのまま入れる
            if (n == 0) {
            
                
            }
        }
    }

     */
    
    
    
    
    
    itemIdArray = [NSMutableArray array];
    stockArray = [NSMutableArray array];
    cartSelectedStockArray = [NSMutableArray array];
    //アイテムIdの配列を作成
    for (int n = 0; n < cartArray.count; n++) {
        NSDictionary *itemInfo = cartArray[n];
        NSString *itemId = itemInfo[@"itemId"];
        [itemIdArray addObject:itemId];
    }
    
    //ポストするパラメータを作成
    NSMutableDictionary *itemIdParams = [NSMutableDictionary dictionary];
    for (int n = 0; n < itemIdArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        itemIdParams[[NSString stringWithFormat:@"item_id[%d]",n]] = itemIdArray[n];
    }
    
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    itemIdParams[@"version"] = version;

    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_items",apiUrl]];
    // don't forget to set parameterEncoding!
    NSLog(@"カートのアイテムパラメータ: %@", itemIdParams);
    
    NSDictionary *parameters = itemIdParams;
    NSLog(@"カートのアイテムパラメータparameters: %@", parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/cart/get_items",apiUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"cart/get_items:JSON: %@", responseObject);
        
        NSLog(@"カートアイテム情報: %@", responseObject);
        
        
        
        
        BOOL arranged = [self arrangeShopInfo:responseObject];
        imageRootUrl = responseObject[@"image_url"];
        
        // NSDictionary *error = [JSON valueForKeyPath:@"error"];
        NSString *errormessage = [responseObject valueForKeyPath:@"error.message"];
        if (errormessage) {
            NSLog(@"エラー: %@", errormessage);
        }else{
            if (arranged) {
                itemRowsArray = [NSMutableArray array];
                NSArray *itemIdsArray;
                for (int n = 0; n < shopInfo.count; n++) {
                    NSDictionary *item = shopInfo[n];
                    NSLog(@"セクションでぃｓくし%@",item);
                    itemIdsArray = item[@"itemInfo"];
                    [itemRowsArray addObject:[NSString stringWithFormat:@"%d",itemIdsArray.count]];
                    NSLog(@"セクションごとの行%@",itemRowsArray);
                }
                
                [cartTable reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}



/*************************************テーブルビュー*************************************/


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int shops = itemRowsArray.count;
    NSLog(@"セクション数%d",shops);
    return shops;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    
    if (itemRowsArray.count){
        rows = [itemRowsArray[section] intValue] + 2;
    }else{
        rows = 3;
    }
    
    return rows;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        if (section == 0) {
            return 64;
        }else{
            return 0.1;
        }
    }else{
        return 0.1;
    }
    
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

    if (itemRowsArray.count) {
        
        if (indexPath.row == 0) {
            NSLog(@"一行目");
            height = 42;
        }else if (indexPath.row == [itemRowsArray[indexPath.section] intValue]+1){
            NSLog(@"最後");
            height = 270;
        }else{
            NSLog(@"それ以外");
            height = 140;
        }
        
    }else{
        
        height = 160;
        
    }

    return height;
    
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%drows:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    /*
    
    for (UIView *subview in [cell subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            continue;
        }
        [subview removeFromSuperview];
    }

    */

    

            
        //取得したセル情報
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
        
    
    
    if (indexPath.row == 0) {
        
        //アイテム情報を整理
        NSLog(@"アイテム情報%@",shopInfo);
        NSDictionary *shopsDictionary = shopInfo[indexPath.section];
        NSString *shopName = shopsDictionary[@"shopName"];
        
        //お店のタイトル
        UILabel *shopTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,42)];
        shopTitle.text = shopName;
        shopTitle.textAlignment = NSTextAlignmentCenter;
        shopTitle.font = [UIFont boldSystemFontOfSize:18];
        shopTitle.textColor = [UIColor whiteColor];
        shopTitle.shadowColor = [UIColor blackColor];
        shopTitle.shadowOffset = CGSizeMake(0.f, 1.f);
        shopTitle.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:shopTitle];
        
        
        
    }else if (indexPath.row == [itemRowsArray[indexPath.section] intValue]+1) {
        //最後の行
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] init];
        ai.frame = CGRectMake(135, 20, 50, 50);
        ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [cell.contentView addSubview:ai];
        
        [ai startAnimating];
        
        
        //アイテム情報を整理
        NSLog(@"アイテム情報%@",shopInfo);
        NSDictionary *shopsDictionary = shopInfo[indexPath.section];
        NSString *shopNameId = shopsDictionary[@"shopNameId"];
        NSArray *itemsInfoArray = shopsDictionary[@"itemInfo"];
        
        

        
        //ポスト(カートに入ってるアイテム情報)するパラメータを作成
        orderItemDictionary = [NSMutableDictionary dictionary];
        orderItemDictionary[@"shop_id"] = shopNameId;
        
        
        int rows = 0;
        rows = rows + [itemRowsArray[indexPath.section] intValue];
        
        int presentRow = 0;
        for (int n = 0; n < indexPath.section; n++) {
            presentRow += [itemRowsArray[n] intValue];
        }
        NSString *incVariation;
        for (int n = 0; n < rows; n++) {
            NSDictionary *itemInfoDictionary = itemsInfoArray[n];
            incVariation = itemInfoDictionary[@"incVariation"];
            NSString *itemId = itemInfoDictionary[@"item"];
            if ([incVariation intValue] == 1) {
                NSArray *variationArray = itemInfoDictionary[@"variation"];
                for (int x = 0; x < cartArray.count; x++) {
                    NSLog(@"カートヴァリエーション%@",cartArray);
                    NSDictionary *cartItem = cartArray[x];
                    NSString *cartItemId = cartItem[@"itemId"];
                    NSLog(@"あいでぃ1%@そのに%@",itemId,cartItemId);
                    if ([itemId isEqualToString:cartItemId]) {
                        NSString *cartVariationName = cartItem[@"variationName"];
                        NSString *cartItemStock = cartItem[@"variationStock"];
                        
                        NSLog(@"カートのバリエージョン%@",cartVariationName);
                        for (int a = 0; a < variationArray.count ; a++) {
                            NSDictionary *itemDict = variationArray[a];
                            NSString *variationName = itemDict[@"variation"];
                            NSString *variationId = itemDict[@"id"];
                            if ([cartVariationName isEqualToString:variationName]) {
                                orderItemDictionary[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
                                orderItemDictionary[[NSString stringWithFormat:@"variation_id[%d]",n]] = variationId;
                                orderItemDictionary[[NSString stringWithFormat:@"amount[%d]",n]] = cartItemStock;
                            }
                        }
                    }
                }
            }else{
                orderItemDictionary[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
                NSString *stockString = cartSelectedStockArray[presentRow + n];
                orderItemDictionary[[NSString stringWithFormat:@"amount[%d]",n]] = stockString;
            }
        }
        NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        orderItemDictionary[@"version"] = version;
        /*
        for (int n = 0; n < itemIdArray.count; n++) {
            //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
            //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
            
        }
        */
        
        
        //商品内容を確認
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_order_details",apiUrl]];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[url absoluteString] parameters:orderItemDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            
            NSLog(@"注文内容の取得: %@", responseObject);
            
            [ai stopAnimating];
            NSDictionary *error = responseObject[@"error"];
            NSString *errormessage = error[@"message"];
            NSString *errormessage1 = [responseObject valueForKeyPath:@"result.Cart.1.error"];
            NSString *deliveryFee = @"0";
            NSLog(@"えあっっっっｒ%@",errormessage1);
            
            
            //アイテム情報を整理
            NSLog(@"アイテム情報%@",shopInfo);
            NSDictionary *shopsDictionary = shopInfo[indexPath.section];
            NSArray *itemsInfoArray = shopsDictionary[@"itemInfo"];
            
            deliveryFee = [responseObject valueForKeyPath:@"result.DeliveryFee.fee"];
            NSString *prefDelivery = [responseObject valueForKeyPath:@"result.DeliveryFee.prefSetting"];
            NSLog(@"送料詳細:%@",prefDelivery);
            
            int totalprice;
            
            for (int n = 0; n < itemsInfoArray.count; n++) {
                NSDictionary *itemInfoDictionary = itemsInfoArray[n];
                NSString *price = itemInfoDictionary[@"price"];
                totalprice = totalprice + [price intValue];
            }
            
            totalprice = [[responseObject valueForKeyPath:@"result.Cart.subtotal"] intValue];
            
            
            
            
            
            //お金表記変換
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @(totalprice);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            
            //購入金額
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,12,140,30)];
            priceLabel.text = @"購入金額";
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
            numPrice = @([deliveryFee intValue]);
            NSString *fee = [nf stringFromNumber:numPrice];
            UILabel *carriageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(priceLabel.frame.origin.y + priceLabel.frame.size.height) + 10,140,30)];
            carriageLabel.text = @"送料";
            carriageLabel.textAlignment = NSTextAlignmentLeft;
            carriageLabel.font = [UIFont boldSystemFontOfSize:18];
            carriageLabel.textColor = [UIColor darkGrayColor];
            carriageLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:carriageLabel];
            
            
            if ([prefDelivery intValue] == 1) {
                UILabel *carriage = [[UILabel alloc] initWithFrame:CGRectMake(104,(priceLabel.frame.origin.y + priceLabel.frame.size.height) + 10,200,30)];
                carriage.text = @"都道府県により異なります";
                carriage.textAlignment = NSTextAlignmentRight;
                carriage.font = [UIFont boldSystemFontOfSize:14];
                carriage.textColor = [UIColor darkGrayColor];
                carriage.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:carriage];
            }else{
                UILabel *carriage = [[UILabel alloc] initWithFrame:CGRectMake(164,(priceLabel.frame.origin.y + priceLabel.frame.size.height) + 10,140,30)];
                carriage.text = fee;
                carriage.textAlignment = NSTextAlignmentRight;
                carriage.font = [UIFont boldSystemFontOfSize:18];
                carriage.textColor = [UIColor darkGrayColor];
                carriage.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:carriage];
            }
            
            
            
            
            
            
            
            //合計金額のお金表記変換
            totalprice = totalprice + [deliveryFee intValue];
            numPrice = @(totalprice);
            NSString *strTotalPrice = [nf stringFromNumber:numPrice];
            
            //合計金額
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,(carriageLabel.frame.origin.y + carriageLabel.frame.size.height) + 10,140,30)];
            totalLabel.text = @"合計金額";
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
            
            //コメント欄
            
            /*
             //価格
             UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, (totalLabel.frame.origin.y + totalLabel.frame.size.height) + 10, 300, 40)];
             commentField.borderStyle = UITextBorderStyleNone;
             commentField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
             UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
             commentField.leftView = paddingView2;
             commentField.leftViewMode = UITextFieldViewModeAlways;
             commentField.textColor = [UIColor blackColor];
             commentField.placeholder = @"コメント欄:到着日の希望、ギフト希望など";
             commentField.layer.borderWidth = 1.0;
             commentField.layer.cornerRadius = 8.0f;
             commentField.clipsToBounds = YES;
             commentField.tag = 2;
             commentField.returnKeyType = UIReturnKeyDone;
             commentField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
             commentField.clearButtonMode = UITextFieldViewModeAlways;
             commentField.delegate = self;
             commentField.backgroundColor = [UIColor clearColor];
             [commentField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
             [commentField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
             [cell addSubview:commentField];
             */
            //購入ボタン
            UIImage *buyImage;
            BSTableCellButton *buyButton;
            if ([BSDefaultViewObject isMoreIos7]) {
                buyImage = [UIImage imageNamed:@"btn_7_04"];
                buyButton = [BSTableCellButton buttonWithType:UIButtonTypeCustom];
                buyButton.frame = CGRectMake( 10, (totalLabel.frame.origin.y + totalLabel.frame.size.height) + 10, 300, 50);
                buyButton.tag = 100000;
                [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
                [buyButton setTitle:@"購入する" forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [buyButton addTarget:self action:@selector(purchase:)forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buyButton];
            }else{
                buyImage = [UIImage imageNamed:@"btn_04"];
                buyButton = [BSTableCellButton buttonWithType:UIButtonTypeCustom];
                buyButton.frame = CGRectMake( 10, (totalLabel.frame.origin.y + totalLabel.frame.size.height) + 10, 300, 50);
                buyButton.tag = 100000;
                [buyButton setBackgroundImage:buyImage forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [buyButton addTarget:self action:@selector(purchase:)forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:buyButton];
                
                //ボタンテキスト
                UILabel *buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(totalLabel.frame.origin.y + totalLabel.frame.size.height) + 15,240,40)];
                buyLabel.text = @"購入する";
                buyLabel.center = CGPointMake(150, 25);
                buyLabel.textAlignment = NSTextAlignmentCenter;
                buyLabel.font = [UIFont boldSystemFontOfSize:20];
                buyLabel.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
                buyLabel.shadowOffset = CGSizeMake(0.f, -1.f);
                buyLabel.backgroundColor = [UIColor clearColor];
                buyLabel.textColor = [UIColor whiteColor];
                [buyButton addSubview:buyLabel];
            }
            
            
            BSTableCellButton *theButton = (BSTableCellButton *)[cell viewWithTag:100000];
            if (theButton) {
                theButton.section = [indexPath section];
                theButton.row = [indexPath row];
            }
            
            
            
            UIImage *continueImage;
            if ([BSDefaultViewObject isMoreIos7]) {
                continueImage = [UIImage imageNamed:@"btn_7_05"];
                UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
                continueButton.frame = CGRectMake( 10, (buyButton.frame.origin.y + buyButton.frame.size.height) + 10, 300, 50);
                continueButton.tag = 1;
                [continueButton setBackgroundImage:continueImage forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [continueButton addTarget:self action:@selector(continueBuy:)forControlEvents:UIControlEventTouchUpInside];
                [continueButton setTitle:@"買い物を続ける" forState:UIControlStateNormal];
                [continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:continueButton];
                
                
                
            }else{
                continueImage = [UIImage imageNamed:@"btn_05"];
                
                UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
                continueButton.frame = CGRectMake( 10, (buyButton.frame.origin.y + buyButton.frame.size.height) + 10, 300, 50);
                continueButton.tag = 1;
                [continueButton setBackgroundImage:continueImage forState:UIControlStateNormal];
                //[modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
                [continueButton addTarget:self action:@selector(continueBuy:)forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:continueButton];
                
                
                //ボタンテキスト
                UILabel *continueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,(buyButton.frame.origin.y + buyButton.frame.size.height) + 15,240,40)];
                continueLabel.text = @"買い物を続ける";
                continueLabel.textAlignment = NSTextAlignmentCenter;
                continueLabel.font = [UIFont boldSystemFontOfSize:20];
                continueLabel.shadowColor = [UIColor whiteColor];
                continueLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                continueLabel.backgroundColor = [UIColor clearColor];
                continueLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:continueLabel];
            }
            
            
            
            NSLog(@"Error message: %@", errormessage);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        

    }else{
        
        
        
        UIImageView *itemImageView = [[UIImageView alloc] initWithImage:nil];
        itemImageView.frame = CGRectMake(16, 13, 75, 75);
        itemImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:itemImageView];
        
        
    
         //デリートボタン
         
         UIImage *deleteImage = [UIImage imageNamed:@"delete"];
         
         BSTableCellButton *deleteButton = [BSTableCellButton buttonWithType:UIButtonTypeCustom];
         deleteButton.frame = CGRectMake( -2,  -4, 35, 35);
         deleteButton.tag = 200000;
         [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
         [deleteButton addTarget:self action:@selector(deleteCell:)forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:deleteButton];
         
         
         BSTableCellButton *theButton = (BSTableCellButton *)[cell viewWithTag:200000];
         if (theButton) {
         theButton.section = [indexPath section];
         theButton.row = [indexPath row];
         }
         
        
        
        if (shopInfo) {
            
            //アイテム情報を整理
            NSLog(@"アイテム情報%@",shopInfo);
            NSDictionary *shopsDictionary = shopInfo[indexPath.section];
            NSArray *itemsInfoArray = shopsDictionary[@"itemInfo"];
            NSDictionary *itemInfoDictionary = itemsInfoArray[indexPath.row - 1];
            NSString *title = itemInfoDictionary[@"title"];
            NSString *price = itemInfoDictionary[@"price"];
            NSString *imageUrl = itemInfoDictionary[@"img"];
            NSString *itemId = itemInfoDictionary[@"item"];
            int incVariation = [itemInfoDictionary[@"incVariation"] intValue];
            
            //個数取得
            NSString *stock;
            NSString *variation;
            for (int n = 0; n < cartArray.count; n++) {
                NSDictionary *cartItem = cartArray[n];
                NSString *cartItemId = cartItem[@"itemId"];
                if ([cartItemId isEqualToString:itemId]) {
                    stock = cartItem[@"variationStock"];
                    variation = cartItem[@"variationName"];
                    
                }
            }
            
            
            
            
            //お金表記変換
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([price intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            
            
            
            NSString *url = [NSString stringWithFormat:@"%@%@",imageRootUrl,imageUrl];
            NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSLog(@"画像のurl%@",url);
            if ([imageUrl isEqual:[NSNull null]]) {
                UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                [itemImageView setImage:noImage1];
                
                
                UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                [noImageView2 setFrame:CGRectMake(12.5, 12.5, 50, 50)];
                [itemImageView addSubview:noImageView2];
            }else{
          
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Response: %@", responseObject);
                    [itemImageView setImage:responseObject];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
            }
            
            
            
            // iOS Version
            NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([iosVersion floatValue] >= 6.0) {
                //商品名
                UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(103,10,100,100)];
                itemTitle.text = title;
                itemTitle.textAlignment = NSTextAlignmentLeft;
                itemTitle.font = [UIFont systemFontOfSize:16];
                itemTitle.textColor = [UIColor grayColor];
                itemTitle.backgroundColor = [UIColor clearColor];
                itemTitle.numberOfLines = 5;
                [itemTitle sizeToFit];
                [cell.contentView addSubview:itemTitle];
            }else if ([iosVersion floatValue] >= 5.0){
                CGFloat titleMaxWidth = 100;
                CGFloat titleMinHeight = 30;
                CGFloat titleMaxHeight = 100;
                
                //商品名
                UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(103,10,titleMaxWidth,titleMaxHeight)];
                itemTitle.text = title;
                itemTitle.numberOfLines = 0;
                itemTitle.textAlignment = NSTextAlignmentLeft;
                itemTitle.font = [UIFont systemFontOfSize:16];
                itemTitle.textColor = [UIColor grayColor];
                itemTitle.backgroundColor = [UIColor clearColor];
                [itemTitle sizeToFit];
                itemTitle.numberOfLines = 5;
                if (itemTitle.frame.size.height > titleMaxHeight)
                {
                    itemTitle.frame = CGRectMake(103,10,titleMaxWidth,titleMaxHeight);
                }
                else if (itemTitle.frame.size.height < titleMinHeight)
                {
                    itemTitle.frame = CGRectMake(103,10,titleMaxWidth,titleMinHeight);
                }
                [cell.contentView addSubview:itemTitle];
            
                
            }
            
            //値段
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(204,10,102,20)];
            priceLabel.text = strPrice;
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.font = [UIFont boldSystemFontOfSize:16];
            priceLabel.textColor = [UIColor grayColor];
            
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.numberOfLines = 1;
            [cell.contentView addSubview:priceLabel];
            
            
            
            NSLog(@"商品自体の個数%@",stockArray);
            
            
            UIImage *selectorImage = [UIImage imageNamed:@"selector"];
            // 左右 17px 固定で引き伸ばして利用する
            selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
            
            // 表示する文字に応じてボタンサイズを変更する
            int rows = 0;
            for (int n = 0; n < indexPath.section; n++) {
                rows = rows + [itemRowsArray[n] intValue];
            }
            NSLog(@"itemRowsArray:%@",itemRowsArray);
            NSLog(@"cartSelectedStockArray:%@",cartSelectedStockArray);
            NSString *stockString = @"0";
            if (rows + (indexPath.row - 1)<cartSelectedStockArray.count) {
                stockString = cartSelectedStockArray[rows + (indexPath.row - 1)];
            }
            UIFont *stockFont = [UIFont systemFontOfSize:12.f];
            //CGSize stockTextSize = [stockString sizeWithFont:stockFont];
            //CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
            
            /*
            // ボタンを用意する
            BSTableCellButton *varyStockButton = [[BSTableCellButton alloc] initWithFrame:CGRectMake(315 - stockButtonSize.width, (priceLabel.frame.size.height + priceLabel.frame.origin.y)  + 10, stockButtonSize.width, stockButtonSize.height)];
            [varyStockButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            varyStockButton.tag = 300000;
            [varyStockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
            */
            
            
            // ラベルを用意する
            UILabel *varyStocklabel = [[UILabel alloc] initWithFrame:CGRectMake(204,50,102,20)];
            varyStocklabel.text = [NSString stringWithFormat:@"%@個",stockString];
            varyStocklabel.textColor = [UIColor colorWithRed:3.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
            varyStocklabel.font = [UIFont boldSystemFontOfSize:16];
            varyStocklabel.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            varyStocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
            varyStocklabel.backgroundColor = [UIColor clearColor];
            varyStocklabel.textAlignment = NSTextAlignmentRight;
            varyStocklabel.tag = 300000;
            [cell.contentView addSubview:varyStocklabel];
            //[cell addSubview:varyStockButton];
            
            /*
            BSTableCellButton *theButton = (BSTableCellButton *)[cell viewWithTag:300000];
            if (theButton) {
                theButton.section = [indexPath section];
                theButton.row = [indexPath row];
            }
            */
            
            if ([stockArray[rows + indexPath.row - 1] intValue] == 0) {
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
                [cell.contentView addSubview:soldOutlabel];
            }
            
            
            
            
            
            
            if (incVariation) {
                
                //数量andバリエーション
                UIImage *image = [UIImage imageNamed:@"selector"];
                // 左右 17px 固定で引き伸ばして利用する
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
                
                // 表示する文字に応じてボタンサイズを変更する
                NSString *varyString = variation;
                //UIFont *font = [UIFont systemFontOfSize:12.f];
                //CGSize textSize2 = [varyString sizeWithFont:font];
                //CGSize buttonSize = CGSizeMake(textSize2.width +  60.f, image.size.height);
                
                /*
                // ボタンを用意する
                UIButton *varyNameButton = [[UIButton alloc] initWithFrame:CGRectMake(264, (varyStockButton.frame.size.height + varyStockButton.frame.origin.y) + 10, buttonSize.width, buttonSize.height)];
                [varyNameButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                
                [varyNameButton setBackgroundImage:image forState:UIControlStateNormal];
                */
                // ラベルを用意する
                UILabel *varyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(104,90,202,20)];
                varyNamelabel.text = varyString;
                varyNamelabel.textColor = [UIColor colorWithRed:3.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1.0];
                varyNamelabel.font = [UIFont boldSystemFontOfSize:14];
                varyNamelabel.shadowColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
                varyNamelabel.shadowOffset = CGSizeMake(0.f, 0.1f);
                varyNamelabel.backgroundColor = [UIColor clearColor];
                varyNamelabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:varyNamelabel];
                //[cell addSubview:varyNameButton];
                //varyNameButton.frame = CGRectMake(315 - buttonSize.width, (varyStockButton.frame.size.height + varyStockButton.frame.origin.y) + 10, buttonSize.width, buttonSize.height);
            }
            
            
            UIView *topLine1 = [[UIView alloc] init];
            topLine1.backgroundColor = [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
            topLine1.frame = CGRectMake(0, 138, 320, 1);
            UIView *bottomLine1 = [[UIView alloc] init];
            bottomLine1.backgroundColor = [UIColor whiteColor];
            bottomLine1.frame = CGRectMake(0, 139, 320, 1);
            [cell.contentView addSubview:topLine1];
            [cell.contentView addSubview:bottomLine1];
        }
        
        /*
         if (!variation.count) {
         // 表示する文字に応じてボタンサイズを変更する
         NSString *stockString = @"1";
         UIFont *stockFont = [UIFont systemFontOfSize:12.f];
         CGSize stockTextSize = [stockString sizeWithFont:stockFont];
         CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  43.0f, selectorImage.size.height);
         
         // ラベルを用意する
         stocklabel.frame = CGRectMake(5.f, 0.f, stockButtonSize.width, stockButtonSize.height);
         varyNameButton.hidden = YES;
         stocklabel.text = stockString;
         stockButton.frame = CGRectMake(13, itemImageView.frame.size.height + 44 + 6, stockButtonSize.width, stockButtonSize.height);
         }
         */
    }

    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BSDefaultViewObject isMoreIos7]) {
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor darkGrayColor];
            return;
        }
         
    }else{
        if (indexPath.row == 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"buy_shoptitle.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            return;
        }else if (indexPath.row % 2 == 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"background.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            //cell.backgroundColor = [UIColor grayColor];
        }else{
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"background.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];;
            //cell.backgroundColor = [UIColor lightGrayColor];
        }
        
    }
    
}

//カート情報をショップごとに表示するための関数
- (BOOL)arrangeShopInfo:(id)jsonData{
    
    shopInfo = [NSMutableArray array];
    
    NSArray *result = jsonData[@"result"];
    NSLog(@"アイテム情報の配列%@",result);
    //NSLog(@"アイテム情報の配列数%d",result.count);
    
    //全てのショップID
    //NSArray *shopIdArray = [self getShopIds:result];
    
    for (int n = 0; n < result.count; n++) {
        
        NSDictionary *shopItemInfo = result[n];
        NSDictionary *item = shopItemInfo[@"Item"];
        NSString *itemId = item[@"id"];
        NSString *stock = item[@"stock"];
        NSString *img = item[@"img"];
        NSString *title = item[@"title"];
        NSString *price = item[@"price"];
        NSString *incVariation = item[@"incVariation"];
        
        NSArray *variation = shopItemInfo[@"Variation"];
        
        
        
        NSDictionary *shop = shopItemInfo[@"Shop"];
        shopId = shop[@"id"];
        NSString *shopName = shop[@"shop_name"];
        NSString *shopNameId = shop[@"shop_id"];

    
        
        
        
        if (!shopInfo.count) {
            
            NSMutableDictionary *itemVariation = [NSMutableDictionary dictionary];
            itemVariation[@"item"] = itemId;
            itemVariation[@"stock"] = stock;
            itemVariation[@"img"] = img;
            itemVariation[@"title"] = title;
            itemVariation[@"price"] = price;
            itemVariation[@"incVariation"] = incVariation;
            itemVariation[@"variation"] = variation;
            
            NSMutableArray *itemArray = [NSMutableArray array];
            [itemArray addObject:itemVariation];
            
            NSMutableDictionary *itemInfo = [NSMutableDictionary dictionary];
            itemInfo[@"itemInfo"] = itemArray;
            itemInfo[@"shopId"] = shopId;
            itemInfo[@"shopName"] = shopName;
            itemInfo[@"shopNameId"] = shopNameId;

            
            [shopInfo addObject:itemInfo];
            NSLog(@"最初のショップ情報:%@",shopInfo);
            
        }else{
            
            
            BOOL sameId = NO;
            for (int n = 0; n < shopInfo.count; n++) {
                NSLog(@"n回目:%d",n);
                NSMutableDictionary *shopDict = shopInfo[n];
                NSString *getshopId = shopDict[@"shopId"];
                
                NSLog(@"getshopID:%@===shopID:%@",getshopId,shopId);
                if ([getshopId isEqualToString:shopId]) {
                    NSMutableArray *itemArray = shopDict[@"itemInfo"];
                    
                    NSMutableArray *itemCheckmArray = [NSMutableArray array];
                    for (int n = 0; n < itemArray.count; n++) {
                        NSDictionary *item = itemArray[n];
                        NSString *checkItemId = item[@"item"];
                        [itemCheckmArray addObject:checkItemId];
                    }
                    //
                    NSMutableDictionary *itemVariation = [NSMutableDictionary dictionary];
                    itemVariation[@"item"] = itemId;
                    itemVariation[@"stock"] = stock;
                    itemVariation[@"img"] = img;
                    itemVariation[@"title"] = title;
                    itemVariation[@"price"] = price;
                    itemVariation[@"incVariation"] = incVariation;
                    itemVariation[@"variation"] = variation;
                    
                    
                    if ([itemCheckmArray containsObject:itemId]) {
                        continue;
                    }
                    [itemArray addObject:itemVariation];
                    //
                    shopDict[@"itemInfo"] = itemArray;
                    shopInfo[n] = shopDict;
                    
                    NSLog(@"以降のショップ情報%@",shopInfo);
                    sameId = YES;
                    break;
                }
            }
            
            if (!sameId) {
                NSMutableArray *itemArray = [NSMutableArray array];
                //
                NSMutableDictionary *itemVariation = [NSMutableDictionary dictionary];
                itemVariation[@"item"] = itemId;
                itemVariation[@"stock"] = stock;
                itemVariation[@"img"] = img;
                itemVariation[@"title"] = title;
                itemVariation[@"price"] = price;
                itemVariation[@"incVariation"] = incVariation;
                itemVariation[@"variation"] = variation;
                [itemArray addObject:itemVariation];
                
                NSMutableDictionary *itemInfo = [NSMutableDictionary dictionary];
                itemInfo[@"itemInfo"] = itemArray;
                itemInfo[@"shopId"] = shopId;
                itemInfo[@"shopName"] = shopName;
                itemInfo[@"shopNameId"] = shopNameId;
                
                [shopInfo addObject:itemInfo];
                NSLog(@"以降のショップ情報%@",shopInfo);
            }
        }
    }
    
    [self arrangeSelectedStockInfo];
    
    NSLog(@"cartSelectedStockArray2:%@",cartSelectedStockArray);
    return YES;
}

- (NSArray*)getShopIds:(NSArray*)resultItemArray{
    
    NSMutableArray *shopIdMutableArray = [NSMutableArray array];
    
    if (resultItemArray.count) {
        for (int n = 0; n < resultItemArray.count; n++) {
            NSDictionary *itemInfo = resultItemArray[n];
            NSString *itemShopId = [itemInfo valueForKeyPath:@"Shop.id"];
            
            if (n == 0) {
                [shopIdMutableArray addObject:itemShopId];
            }
            
            
            NSLog(@"ショップid%@====shopId:%@",shopIdMutableArray,itemShopId);
            if ([shopIdMutableArray containsObject:itemShopId]) {
                continue;
            }else{
                [shopIdMutableArray addObject:itemShopId];
            }
            
        }
    }
    NSLog(@"ショップIDの配列:%@",shopIdMutableArray);
    NSArray *shopIdArray = [shopIdMutableArray copy];
    
    return shopIdArray;
}

//選択した個数と選択可能な個数を作成
- (void)arrangeSelectedStockInfo{
    
    
    
    //アイテム個数選択の配列を作成
    for (int n = 0; n < shopInfo.count; n++) {
        NSDictionary *itemInfoPath = shopInfo[n];
        NSArray *itemInfo = itemInfoPath[@"itemInfo"];
        NSLog(@"アイテム情報111%@",itemInfo);
        for (int s = 0; s < itemInfo.count; s++) {
            NSDictionary *item = itemInfo[s];
            NSString *incVariation = item[@"incVariation"];
            NSString *stock = item[@"stock"];
            NSString *itemId = item[@"item"];
            
            //NSString *variationName =
            if ([incVariation intValue] == 1) {
                NSArray *variationArray = item[@"variation"];
                
                
                for (int x = 0; x < cartArray.count; x++) {
                    NSLog(@"カートヴァリエーション%@",cartArray);
                    NSDictionary *cartItem = cartArray[x];
                    NSString *cartItemId = cartItem[@"itemId"];
                    NSLog(@"あいでぃ1%@そのに%@",itemId,cartItemId);
                    
                    if ([itemId isEqualToString:cartItemId]) {
                        NSString *cartVariationName = cartItem[@"variationName"];
                        NSString *cartItemStock = cartItem[@"variationStock"];
                        NSLog(@"カートのバリエージョン%@",cartVariationName);
                        for (int a = 0; a < variationArray.count ; a++) {
                            NSDictionary *itemDict = variationArray[a];
                            NSString *variationName = itemDict[@"variation"];
                            if ([cartVariationName isEqualToString:variationName]) {
                                [cartSelectedStockArray addObject:cartItemStock];
                                NSLog(@"ばりあり現在のストック一覧%@",cartSelectedStockArray);
                                
                                NSString *variationStock = itemDict[@"variationStock"];
                                [stockArray addObject:variationStock];
                                NSLog(@"こすううううう%@あんどおおおお%@",stockArray,variationStock);
                            }
                        }
                    }
                    
                }
                
            }else{
                [stockArray addObject:stock];
                NSLog(@"こすううううう%@",stockArray);
                
                for (int x = 0; x < cartArray.count; x++) {
                    NSLog(@"ばりなしカートヴァリエーション%@",cartArray);
                    NSDictionary *cartItem = cartArray[x];
                    NSString *cartItemId = cartItem[@"itemId"];
                    NSLog(@"ばりなしあいでぃ1%@そのに%@",itemId,cartItemId);
                    if ([itemId isEqualToString:cartItemId]) {
                        NSLog(@"ばり一覧%@",cartItem);
                        NSString *cartVariationStock = cartItem[@"variationStock"];
                        [cartSelectedStockArray addObject:cartVariationStock];
                        
                    }
                }
            }
        }
    }
    
    
    NSLog(@"cartSelectedStockArray2:%@",cartSelectedStockArray);
}

- (IBAction)deleteCell:(id)sender {
    BSTableCellButton *theButton = (BSTableCellButton *)sender;
    NSLog(@"Button[%d,%d] was pressed.", theButton.section, theButton.row);
    
    NSString *rows = [NSString stringWithFormat:@"%d",[itemRowsArray[theButton.section] intValue] - 1];
    
    
    
    
    NSLog(@"ショップ情報を変更する%@",shopInfo);
    if ([rows intValue] == 0) {
        int deleteRows = 0;
        for (int n = 0; n < theButton.section; n++) {
            deleteRows = deleteRows + [itemRowsArray[n] intValue];
        }
        [stockArray removeObjectAtIndex:deleteRows + (theButton.row - 1)];
        
        //カートのアイテム情報を削除
        NSMutableDictionary *shop = shopInfo[theButton.section];
        NSMutableArray *itemsArray = shop[@"itemInfo"];
        NSDictionary *itemInfo = itemsArray[theButton.row - 1];
        NSString *itemId = itemInfo[@"item"];
        //ショップ情報を変更
        [shopInfo removeObjectAtIndex:theButton.section];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray* array = [NSMutableArray array];
        cartArray = [userDefaults arrayForKey:@"cart"];
        NSMutableArray *newCartArray = [cartArray mutableCopy];
        NSLog(@"取得した配列%@",cartArray);
        for (int n = 0; n < cartArray.count; n++) {
            NSMutableDictionary *cartItem = cartArray[n];
            NSString *cartItemId = cartItem[@"itemId"];
            if ([itemId isEqualToString:cartItemId]) {
                [newCartArray removeObjectAtIndex:n];
                break;
            }
            
        }
        [userDefaults setObject:newCartArray forKey:@"cart"];
        
        
        
        [itemRowsArray removeObjectAtIndex:theButton.section];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theButton.row inSection:theButton.section];
        //[cartTable beginUpdates];
        [cartTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationLeft];
        //[cartTable endUpdates];
        
        [cartTable reloadData];
    }else{
        int deleteRows = 0;
        for (int n = 0; n < theButton.section; n++) {
            deleteRows = deleteRows + [itemRowsArray[n] intValue];
        }
        [stockArray removeObjectAtIndex:deleteRows + (theButton.row - 1)];
        
        [cartSelectedStockArray removeObjectAtIndex:deleteRows + (theButton.row - 1)];
        
        //ショップ情報を変更
        NSMutableDictionary *shop = shopInfo[theButton.section];
        NSMutableArray *itemsArray = shop[@"itemInfo"];
        NSDictionary *itemInfo = itemsArray[theButton.row - 1];
        NSString *itemId = itemInfo[@"item"];
        shop[@"itemInfo"] = itemsArray;
        shopInfo[theButton.section] = shop;
        [itemsArray removeObjectAtIndex:theButton.row - 1];
        
        
        
        //カートのアイテム情報を削除
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //NSMutableArray* array = [NSMutableArray array];
        cartArray = [userDefaults arrayForKey:@"cart"];
        NSMutableArray *newCartArray = [cartArray mutableCopy];
        NSLog(@"取得した配列%@",cartArray);
        NSLog(@"取得した配列コピー%@",newCartArray);
        for (int n = 0; n < cartArray.count; n++) {
            NSMutableDictionary *cartItem = cartArray[n];
            NSString *cartItemId = cartItem[@"itemId"];
            if ([itemId isEqualToString:cartItemId]) {
                [newCartArray removeObjectAtIndex:n];
                break;
            }
            
        }
        NSLog(@"変更したコピー%@",newCartArray);
        [userDefaults setObject:newCartArray forKey:@"cart"];
        
        itemRowsArray[theButton.section] = rows;
        
        NSLog(@"セクションごとのアイテム数%@",itemRowsArray);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theButton.row inSection:theButton.section];
        [cartTable beginUpdates];
        [cartTable deleteRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationLeft];
        [cartTable endUpdates];
        
        [cartTable reloadData];
    }
    
}



//数量のピッカー
- (IBAction)selectNumber:(id)sender
{
    
    
    //てすと
    NSLog(@"ボタンのタグ:%d",[sender tag]);
    //buttonTag = [sender tag];
    BSTableCellButton *theButton = (BSTableCellButton *)sender;
    NSLog(@"Button[%d,%d] was pressed.", theButton.section, theButton.row);
    
    buttonRow = theButton.row;
    buttonSection = theButton.section;
    
    [stockPicker reloadAllComponents];
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
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    int stock1 = [stockPicker selectedRowInComponent:0] + 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonRow inSection:buttonSection];
    UITableViewCell *cell = [cartTable cellForRowAtIndexPath:indexPath];
    
    
    int rows = 0;
    for (int n = 0; n < buttonSection; n++) {
        rows = rows + [itemRowsArray[n] intValue];
    }
    cartSelectedStockArray[rows + (buttonRow - 1)] = [NSString stringWithFormat:@"%d",stock1];
    
    
    for (UIView *subview in [cell subviews]) {
        if (subview.tag == 300000) {
            [subview removeFromSuperview];
            
            UIImage *selectorImage = [UIImage imageNamed:@"selector"];
            // 左右 17px 固定で引き伸ばして利用する
            selectorImage = [selectorImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 40.f)];
            
            // 表示する文字に応じてボタンサイズを変更する
            NSString *stockString = [NSString stringWithFormat:@"%d",stock1];
            UIFont *stockFont = [UIFont systemFontOfSize:12.f];
            CGSize stockTextSize = [stockString sizeWithFont:stockFont];
            CGSize stockButtonSize = CGSizeMake(stockTextSize.width +  60.f, selectorImage.size.height);
            
            // ボタンを用意する
            BSTableCellButton *varyStockButton = [[BSTableCellButton alloc] initWithFrame:CGRectMake(315 - stockButtonSize.width,  40, stockButtonSize.width, stockButtonSize.height)];
            [varyStockButton addTarget:self action:@selector(selectNumber:)forControlEvents:UIControlEventTouchUpInside];
            varyStockButton.tag = 300000;
            [varyStockButton setBackgroundImage:selectorImage forState:UIControlStateNormal];
            
            // ラベルを用意する
            UILabel *varyStocklabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 0.f, stockTextSize.width + 20, stockButtonSize.height)];
            varyStocklabel.text = stockString;
            varyStocklabel.textColor = [UIColor darkGrayColor];
            varyStocklabel.font = stockFont;
            varyStocklabel.shadowColor = [UIColor whiteColor];
            varyStocklabel.shadowOffset = CGSizeMake(0.f, 0.1f);
            varyStocklabel.backgroundColor = [UIColor clearColor];
            varyStocklabel.textAlignment = NSTextAlignmentCenter;
            varyStocklabel.tag = 300000;
            [varyStockButton addSubview:varyStocklabel];
            [cell.contentView addSubview:varyStockButton];
            
            BSTableCellButton *theButton = (BSTableCellButton *)[cell viewWithTag:300000];
            if (theButton) {
                theButton.section = [indexPath section];
                theButton.row = [indexPath row];
            }
            
        }
    }
    
}


//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"こすううううう%@",stockArray);
    int rows = 0;
    for (int n = 0; n < buttonSection; n++) {
        rows = rows + [itemRowsArray[n] intValue];
    }
    if (buttonRow) {
        return [stockArray[rows + (buttonRow - 1)] intValue];
    }else{
        return 50;
    }
    
}

//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d", row + 1];
    
}


- (void)backRoot{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)purchase:(id)sender{
    
    
    
    [SVProgressHUD showWithStatus:@"カートの中身を確認" maskType:SVProgressHUDMaskTypeGradient];
    
    BSTableCellButton *theButton = (BSTableCellButton *)sender;

    
    //アイテム情報を整理
    NSLog(@"アイテム情報%@",shopInfo);
    NSDictionary *shopsDictionary = shopInfo[theButton.section];
    NSString *shopNameId = shopsDictionary[@"shopNameId"];
    NSArray *itemsInfoArray = shopsDictionary[@"itemInfo"];
    
    
    
    
    //ポスト(カートに入ってるアイテム情報)するパラメータを作成
    orderItemDictionary = [NSMutableDictionary dictionary];
    orderItemDictionary[@"shop_id"] = shopNameId;
    
    
    int rows = 0;
    rows = rows + [itemRowsArray[theButton.section] intValue];
    
    int presentRow = 0;
    for (int n = 0; n < theButton.section; n++) {
        presentRow += [itemRowsArray[n] intValue];
    }
    NSString *incVariation;
    for (int n = 0; n < rows; n++) {
        NSDictionary *itemInfoDictionary = itemsInfoArray[n];
        incVariation = itemInfoDictionary[@"incVariation"];
        NSString *itemId = itemInfoDictionary[@"item"];
        if ([incVariation intValue] == 1) {
            NSArray *variationArray = itemInfoDictionary[@"variation"];
            for (int x = 0; x < cartArray.count; x++) {
                NSLog(@"カートヴァリエーション%@",cartArray);
                NSDictionary *cartItem = cartArray[x];
                NSString *cartItemId = cartItem[@"itemId"];
                NSLog(@"あいでぃ1%@そのに%@",itemId,cartItemId);
                if ([itemId isEqualToString:cartItemId]) {
                    NSString *cartVariationName = cartItem[@"variationName"];
                    NSString *cartItemStock = cartItem[@"variationStock"];
                    
                    NSLog(@"カートのバリエージョン%@",cartVariationName);
                    for (int a = 0; a < variationArray.count ; a++) {
                        NSDictionary *itemDict = variationArray[a];
                        NSString *variationName = itemDict[@"variation"];
                        NSString *variationId = itemDict[@"id"];
                        if ([cartVariationName isEqualToString:variationName]) {
                            orderItemDictionary[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
                            orderItemDictionary[[NSString stringWithFormat:@"variation_id[%d]",n]] = variationId;
                            orderItemDictionary[[NSString stringWithFormat:@"amount[%d]",n]] = cartItemStock;
                        }
                    }
                }
            }
        }else{
            orderItemDictionary[[NSString stringWithFormat:@"item_id[%d]",n]] = itemId;
            NSString *stockString = cartSelectedStockArray[presentRow + n];
            orderItemDictionary[[NSString stringWithFormat:@"amount[%d]",n]] = stockString;
        }
    }
    
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    orderItemDictionary[@"version"] = version;

    
    //商品内容を確認
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_order_details",apiUrl]];
    NSLog(@"orderItemDictionary: %@", orderItemDictionary);

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:orderItemDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"カートの中身の注文内容の取得: %@", responseObject);
        NSDictionary *error = responseObject[@"error"];
        NSString *errormessage = error[@"message"];
        NSString *errormessage1 = [responseObject valueForKeyPath:@"result.Cart.1.error"];
        //NSString *deliveryFee = @"0";
        NSLog(@"えあっっっっｒ%@",errormessage1);
        NSLog(@"Error message: %@", errormessage);
        NSString *versionError = [responseObject valueForKeyPath:@"error.versionError"];
        if ([versionError intValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"このバージョンでは購入することができません" message:@"アプリを最新のバージョンにしてください"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            return ;
        }
        /*
         UIAlertView *alert =
         [[UIAlertView alloc] initWithTitle:@"価格の入力が正しくありません" message:@"価格を数字（半角）でご入力ください"
         delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         */
        if (errormessage) {
            
            [SVProgressHUD showErrorWithStatus:@"売り切れの商品が含まれています..."];
            return ;
            
        }else{
            [SVProgressHUD dismiss];
            BSTableCellButton *theButton = (BSTableCellButton *)sender;
            NSLog(@"Button[%d,%d] was pressed.", theButton.section, theButton.row);
            
            //アイテム情報
            NSLog(@"アイテム情報%@",shopInfo);
            
            importCartDictionary = orderItemDictionary;
            
            
            BSSelectAddressTableViewController *vc = [[BSSelectAddressTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

+(NSDictionary*)getCartItem {
    return importCartDictionary;
}

- (void)continueBuy:(id)sender
{
        
    UIViewController *parent = (self.navigationController.viewControllers)[0];
    [self.navigationController  popToViewController:parent animated:YES];
    // Dispose of any resources that can be recreated.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
/*
void exceptionHandler(NSException *exception) {
    // ここで、例外発生時の情報を出力します。
    // NSLog関数でcallStackSymbolsを出力することで、
    // XCODE上で開発している際にも、役立つスタックトレースを取得できるようになります。
    NSLog(@"aaaaaa%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
    
    // ログをUserDefaultsに保存しておく。
    // 次の起動の際に存在チェックすれば、前の起動時に異常終了したことを検知できます。
    
    NSString *log = [NSString stringWithFormat:@"%@, %@, %@", exception.name, exception.reason, exception.callStackSymbols];
    [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"failLog"];
    NSString *failLog = [[NSUserDefaults standardUserDefaults] stringForKey:@"failLog"];
    NSLog(@"かーーーーとおちた%@",failLog);
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    [ud removeObjectForKey:@"cart"];
    [ud synchronize];
    
}
*/