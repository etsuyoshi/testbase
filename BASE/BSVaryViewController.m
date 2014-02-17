//
//  BSVaryViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/22.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSVaryViewController.h"

@interface BSVaryViewController ()

@end

@implementation BSVaryViewController{
    UITableView *varyTable;
    NSMutableArray *variationArray;
    NSMutableArray *variationNameArray;
    NSMutableArray *variationStockArray;
    
    BOOL editMode;
    int variationArrayCount;
    
    int buttonTag;
    BOOL firstButton;
    UIActionSheet *stockActionSheet;
    UIPickerView *stockPicker;
    
    //選択されたボタンの親cell
    UITableViewCell *selectedCell;
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
    self.trackedViewName = @"changeVary";
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
    UINavigationItem *navItem;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
        label.text = @"バリエーション";
        [label sizeToFit];
        
        self.navigationItem.titleView = label;

    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        navItem = [[UINavigationItem alloc] initWithTitle:@"バリエーション"];
        [navBar pushNavigationItem:navItem animated:YES];
        [self.view addSubview:navBar];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
        label.text = @"バリエーション";
        [label sizeToFit];
        
        navItem.titleView = label;
    }
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(editVary)];
        self.navigationItem.rightBarButtonItem = rightItemButton;
        
    }else{
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"商品編集" target:self action:@selector(backRoot) side:0];
        navItem.leftBarButtonItem = backButton;
        UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(editVary)];
        navItem.rightBarButtonItem = rightItemButton;
    }
    
    
    
    
    
    
    //在庫テーブル
    if ([BSDefaultViewObject isMoreIos7]) {
        varyTable = [[UITableView alloc] initWithFrame:CGRectMake(0,64, 320, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    }else{
        varyTable = [[UITableView alloc] initWithFrame:CGRectMake(0,  44, 320, self.view.bounds.size.height -44) style:UITableViewStylePlain];
    }
    
    varyTable.dataSource = self;
    varyTable.delegate = self;
    varyTable.tag = 100000;
    varyTable.editing = YES;
    varyTable.backgroundView = nil;
    varyTable.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:varyTable];
    [self.view insertSubview:varyTable belowSubview:navBar];

    
    
    //バリエーション名の配列
    variationNameArray = [NSMutableArray array];
    variationStockArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *sessionId = [BSTutorialViewController sessions];
    NSLog(@"セッションid:%@",sessionId);
    NSString *itemId = [BSItemAdminViewController getItemId];
    NSString *url = [NSString stringWithFormat:@"%@/items/get_item?session_id=%@&item_id=%@",apiUrl,sessionId, itemId];
    NSLog(@"おせてます%@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:url];
    NSLog(@"URLあああああ%@",url1);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    NSDictionary *headerInfo = request.allHTTPHeaderFields;
    NSLog(@"リスエスト！: %@", headerInfo);
    NSLog(@"djkfalkjaslkd%@",request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *headerInfo = request.allHTTPHeaderFields;
        NSLog(@"リスエスト！: %@", request);
        NSLog(@"レスポンス！: %@", headerInfo);
        NSLog(@"バリエーション！: %@", JSON);
        NSDictionary *result = [JSON valueForKeyPath:@"result"];
        variationArray = [result valueForKeyPath:@"Variation"];
        variationArrayCount = variationArray.count;
        if (result) {
            for (int n = 0; n < variationArray.count; n++) {
                NSDictionary *variationNumber = variationArray[n];
                NSString *variation = [variationNumber valueForKeyPath:@"variation"];
                NSString *variationStock = [variationNumber valueForKeyPath:@"variationStock"];
                [variationNameArray addObject:variation];
                [variationStockArray addObject:variationStock];
            }
            NSLog(@"バリエーションの名前%@",variationNameArray);
            NSLog(@"バリエーションの数%@",variationStockArray);
        }
        [varyTable reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        
    }];
    [operation start];
    
    
}



/*************************************テーブルビュー*************************************/

//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (variationArray) {
        return variationArrayCount + 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    height = 50;
    return height;
}


//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"読み込まれているよ");
    //NSArray *identifiers = [NSArray arrayWithObjects:@"itemName",@"price",@"quantity",@"amount",@"payment",@"orderDay",@"purchaser",@"postcode",@"address",@"email",@"phone",@"remark",@"dispatch",nil];
    //NSString *CellIdentifier = [identifiers objectAtIndex:indexPath.row];
    //NSString *cellIdentifier = [NSString stringWithFormat:@"cell%d.%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = YES;
    }
    
    if (variationArray.count) {
        NSLog(@"すでにバリエーションあるよ");
        [self updateCell:cell atIndexPath:indexPath];
    }else{
        if (variationArrayCount == indexPath.row) {
            NSString *variationStock;
            variationStock = @"バリエーションを追加";
            UILabel *variationStockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,50)];
            variationStockLabel.text = variationStock;
            variationStockLabel.textAlignment = NSTextAlignmentRight;
            variationStockLabel.font = [UIFont boldSystemFontOfSize:18];
            variationStockLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:variationStockLabel];
            return  cell;
        }
        NSString *variationStock = variationStockArray[[indexPath row]];
        NSString *variation = variationNameArray[indexPath.row];
        
        UITextField *variationField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 160, 50)];
        variationField.borderStyle = UITextBorderStyleNone;
        variationField.textColor = [UIColor blackColor];
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        variationField.leftView = paddingView2;
        variationField.leftViewMode = UITextFieldViewModeAlways;
        variationField.placeholder = @"バリエーション";
        variationField.text = variation;
        variationField.keyboardType = UIKeyboardTypeEmailAddress;
        variationField.font = [UIFont systemFontOfSize:16];
        variationField.clearButtonMode = UITextFieldViewModeAlways;
        variationField.delegate = self;
        variationField.backgroundColor = [UIColor clearColor];
        variationField.tag = indexPath.row;
        //variationField.layer.borderWidth = 1.0;
        //ariationField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
        CALayer *rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake(159, 0, 1, 50);
        rightBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                        alpha:1.0f].CGColor;
        [variationField.layer addSublayer:rightBorder];
        CALayer *leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0, 0, 1, 50);
        leftBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                       alpha:1.0f].CGColor;
        [variationField.layer addSublayer:leftBorder];
        
        [variationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [variationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.contentView addSubview:variationField];
        
        variationStock = [NSString stringWithFormat:@"%@個",variationStock];
        UILabel *variationStockLabel = [[UILabel alloc] initWithFrame:CGRectMake(220,0,60,50)];
        variationStockLabel.text = variationStock;
        variationStockLabel.tag = indexPath.row;
        variationStockLabel.textAlignment = NSTextAlignmentRight;
        variationStockLabel.font = [UIFont boldSystemFontOfSize:20];
        variationStockLabel.shadowColor = [UIColor whiteColor];
        variationStockLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        variationStockLabel.backgroundColor = [UIColor clearColor];
        variationStockLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:variationStockLabel];
        
        UIButton *stockButton = [[UIButton alloc] initWithFrame:CGRectMake(162,0,130,50)];
        stockButton.backgroundColor = [UIColor clearColor];
        [stockButton addTarget:self
                        action:@selector(selectNumber:)
              forControlEvents:UIControlEventTouchDown];
        stockButton.tag = indexPath.row;
        [cell.contentView addSubview:stockButton];
    }
    
    
    return cell;
}


// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
  
    
    NSLog(@"あんまり飛ばないよ");
    if (variationArrayCount == indexPath.row) {
        NSString *variationStock;
        variationStock = @"バリエーションを追加";
        UILabel *variationStockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,50)];
        variationStockLabel.text = variationStock;
        variationStockLabel.textAlignment = NSTextAlignmentRight;
        variationStockLabel.font = [UIFont boldSystemFontOfSize:18];
        variationStockLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:variationStockLabel];
        return;
    }
    NSLog(@"とんだよ");
    NSString *variationStock = variationStockArray[[indexPath row]];
    NSString *variation = variationNameArray[indexPath.row];
    
    UITextField *variationField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 160, 50)];
    variationField.borderStyle = UITextBorderStyleNone;
    variationField.textColor = [UIColor blackColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    variationField.leftView = paddingView2;
    variationField.leftViewMode = UITextFieldViewModeAlways;
    variationField.placeholder = @"バリエーション";
    variationField.text = variation;
    variationField.keyboardType = UIKeyboardTypeEmailAddress;
    variationField.font = [UIFont systemFontOfSize:16];
    variationField.clearButtonMode = UITextFieldViewModeAlways;
    variationField.delegate = self;
    variationField.backgroundColor = [UIColor clearColor];
    variationField.tag = indexPath.row;
    //variationField.layer.borderWidth = 1.0;
    //ariationField.layer.borderColor = [[UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]CGColor];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(159, 0, 1, 50);
    rightBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                    alpha:1.0f].CGColor;
    [variationField.layer addSublayer:rightBorder];
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 0, 1, 50);
    leftBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                   alpha:1.0f].CGColor;
    [variationField.layer addSublayer:leftBorder];
    
    [variationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [variationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [cell.contentView addSubview:variationField];
    
    variationStock = [NSString stringWithFormat:@"%@個",variationStock];
    UILabel *variationStockLabel = [[UILabel alloc] initWithFrame:CGRectMake(180,0,100,50)];
    variationStockLabel.text = variationStock;
    variationStockLabel.tag = indexPath.row;
    variationStockLabel.textAlignment = NSTextAlignmentRight;
    variationStockLabel.font = [UIFont boldSystemFontOfSize:20];
    variationStockLabel.shadowColor = [UIColor whiteColor];
    variationStockLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    variationStockLabel.backgroundColor = [UIColor clearColor];
    variationStockLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:variationStockLabel];
    
    UIButton *stockButton = [[UIButton alloc] initWithFrame:CGRectMake(162,0,130,50)];
    stockButton.backgroundColor = [UIColor clearColor];
    [stockButton addTarget:self
                    action:@selector(selectNumber:)
          forControlEvents:UIControlEventTouchDown];
    stockButton.tag = indexPath.row;
    [cell.contentView addSubview:stockButton];
    
    
    
    
    // textLabel
    //NSString *text = [self.dataSource objectAtIndex:(NSUInteger) indexPath.row];
    //cell.textLabel.text = text;
    //NSString *detailText = @"詳細のtextLabel";
    //cell.textLabel.text = detailText;
}




//編集処理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        variationArrayCount--;
        [variationNameArray removeObjectAtIndex:indexPath.row];
        [variationStockArray removeObjectAtIndex:indexPath.row];
        NSLog(@"変更したバリエーション名%@",variationNameArray);
        NSLog(@"変更したバリエーション数%@",variationStockArray);
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }else if(UITableViewCellEditingStyleInsert == editingStyle)
    {
        [variationNameArray addObject:@""];
        [variationStockArray addObject:@"1"];
        NSLog(@"変更したバリエーション名%@",variationNameArray);
        NSLog(@"変更したバリエーション数%@",variationStockArray);
        variationArrayCount++;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
}

//編集スタイル
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing == NO )
        return UITableViewCellEditingStyleNone;
    
    if (indexPath.row >= variationArrayCount){
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
//リターンを押した時に挙動
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    int tag = textField.tag;
    variationNameArray[tag] = textField.text;
}

//数量のピッカー
- (IBAction)selectNumber:(id)sender
{
    
   
    //てすと
    NSLog(@"ボタンのタグ:%d",[sender tag]);
    buttonTag = [sender tag];
    
    UIButton *btn = (UIButton *)sender;
    selectedCell = (UITableViewCell *)[btn superview];
    
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
    
    variationStockArray[buttonTag] = [NSString stringWithFormat:@"%d",stock1];
    //取得したセル情報
    for (UIView *view in selectedCell.subviews) {
            if ([view isMemberOfClass:[UILabel class]]) {
                [(UILabel *)view setText:[NSString stringWithFormat:@"%d個",stock1]];
            }
            
    }
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

//バリデーションチェック
- (BOOL)validationCheck {
    for (int n = 0; n < variationNameArray.count; n++) {
        //タッチ位置からNSIndexPathを取得してセル情報を取得する
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:n inSection:0];
        UITableViewCell *cell = [varyTable cellForRowAtIndexPath:indexPath];
        //取得したセル情報
        for (UIView *view in cell.contentView.subviews) {
            NSLog(@"サブビュー図%@",view);
            if ([view isMemberOfClass:[UITextField class]]) {
                UITextField *checkTextField = (UITextField *)view;
                [checkTextField resignFirstResponder];
                if ([checkTextField.text isEqualToString:@""] || checkTextField.text == nil) {
                    [checkTextField becomeFirstResponder];
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:@"バリエーション名の入力が正しくありません" message:@"バリエーション名を入力してください"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return NO;
                }
            }
        }
    }
    return YES;

}

//商品編集に戻る
- (void)backRoot{
    [self.navigationController popViewControllerAnimated:YES];
}

//バリエーション保存する
- (void)editVary{
    BOOL validation = [self validationCheck];
    
    if (validation) {
        [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString *sessionId = [BSTutorialViewController sessions];
        NSString *itemId = [BSItemAdminViewController getItemId];
        NSLog(@"セッションid:%@",sessionId);
        
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        mdic[@"session_id"] = sessionId;
        mdic[@"item_id"] = itemId;
        
        for (int n = 0; n < variationNameArray.count; n++) {
            //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
            //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
            
            mdic[[NSString stringWithFormat:@"variation[%d]",n]] = variationNameArray[n];
            mdic[[NSString stringWithFormat:@"variation_stock[%d]",n]] = variationStockArray[n];
        
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/items/edit_variations",apiUrl]];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        // don't forget to set parameterEncoding!
        NSLog(@"＠あらめーた！: %@", mdic);
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:mdic];
        NSDictionary *headerInfo = request.allHTTPHeaderFields;
        NSLog(@"ヘッダーーー情報: %@", headerInfo);
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSLog(@"ログイン情報: %@", JSON);
            //NSDictionary *error = [JSON valueForKeyPath:@"error"];
            //NSString *errormessage = [error valueForKeyPath:@"message"];
            NSArray *errormessage1 = [JSON valueForKeyPath:@"error.validations.Variation.variation"];
            NSString *errorr = errormessage1[0];
            NSLog(@"エラー: %@", errorr);
            [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        /*
        NSLog(@"おせてます%@",urlString);
        
        NSURL *url1 = [NSURL URLWithString:urlString];
        NSLog(@"URLあああああ%@",url1);
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        NSLog(@"djkfalkjaslkd%@",request);
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"ログイン情報！: %@", JSON);
            [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"Error: %@", error);
            
        }];
        [operation start];
         */
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
