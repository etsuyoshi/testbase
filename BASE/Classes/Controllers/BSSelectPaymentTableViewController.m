//
//  BSSelectPaymentTableViewController.m
//  BASE
//
//  Created by Takkun on 2014/02/10.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSSelectPaymentTableViewController.h"

#import "AFNetworking.h"
#import "BSCartViewController.h"
#import "BSDefaultViewObject.h"
#import "BSInputFormTextField.h"
#import "UICKeyChainStore.h"
#import "BSConfirmCheckoutViewController.h"
#import "BSPaypalViewController.h"



@interface BSSelectPaymentTableViewController ()

@end

@implementation BSSelectPaymentTableViewController{
    NSString *baseURL;
    NSMutableArray *paymentArray;
    
    UILabel *paymentLabel;
    UIActionSheet *stockActionSheet;
    UIPickerView *stockPicker;
    
    BSInputFormTextField *cardNumberField;
    BSInputFormTextField *expireField;
    BSInputFormTextField *securityNumberField;
    
    UIToolbar *toolBar;

    
    NSDictionary *addressDictionary;

    
}
static NSDictionary *importOrderDictionary = nil;

- (id)initWithStyle:(UITableViewStyle)style savedUserNumber:(int)savedUserNumber
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.title = @"お支払い方法を選択";
        
        paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,3,290,40)];
        paymentLabel.text = @"";
        paymentLabel.textAlignment = NSTextAlignmentLeft;
        paymentLabel.font = [UIFont boldSystemFontOfSize:16];
        paymentLabel.backgroundColor = [UIColor clearColor];
        paymentLabel.textColor = [UIColor colorWithRed:111.0f/255.0f green:130.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        
        cardNumberField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        cardNumberField.placeholder = @"123456789";
        cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
        cardNumberField.tag = 1;
        cardNumberField.text = @"";
        
        expireField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        expireField.placeholder = @"MM/YY";
        expireField.keyboardType = UIKeyboardTypeNumberPad;
        expireField.tag = 2;
        expireField.delegate = self;
        expireField.text = @"";



        securityNumberField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        securityNumberField.placeholder = @"***";
        securityNumberField.keyboardType = UIKeyboardTypeNumberPad;
        securityNumberField.tag = 3;
        securityNumberField.text = @"";


        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"決定" style:UIBarButtonItemStyleDone target:self action:@selector(purchase:)];
        
        // ナビゲーションアイテムの右側に戻るボタンを設置
        self.navigationItem.rightBarButtonItem = doneButton;

        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
        //addressDictionary
        if(savedUserNumber == 1){
            addressDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"firstUserAddress"]];
        } else {
            addressDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"secondUserAddress"]];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];


    baseURL = [BSDefaultViewObject setApiUrl];
    NSMutableDictionary *orderItem = [[BSCartViewController getCartItem] mutableCopy];
    
    
    //商品内容を確認
    NSString *version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    [orderItem setValue:version forKey:@"version"];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/get_order_details/",baseURL]];
    // don't forget to set parameterEncoding!
    NSDictionary *cartParameters = [orderItem copy];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:cartParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"注文内容の取得: %@", responseObject);
        NSDictionary *error = responseObject[@"error"];
        NSString *errormessage = error[@"message"];
        //NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
        NSLog(@"Error message: %@", errormessage);
        [self setPayment:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)setPayment:(id)JSON
{
    paymentArray = [NSMutableArray array];
    if ([[JSON valueForKeyPath:@"result.Shop.creditcart_payment"] intValue] == 1) {
        
        
        NSMutableDictionary *orderItemDictionary = [[BSCartViewController getCartItem] mutableCopy];
        
        
        //商品内容を確認
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/payments/get_payment_service?shop_id=%@",baseURL,orderItemDictionary[@"shop_id"]]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager GET:[url absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"payments/get_payment_service: %@", responseObject);
            NSDictionary *error = responseObject[@"error"];
            NSString *errormessage = error[@"message"];
            //NSString *errormessage1 = [JSON valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"Error message: %@", errormessage);
            
            
            
            NSString *creditcardPayment = [responseObject valueForKeyPath:@"result.payment_service"];
            
            if ([creditcardPayment isEqualToString:@"SMCC"]) {
                [paymentArray addObject:@"クレジットカード決済"];
                paymentLabel.text = @"クレジットカード決済";
                
            } else {
                
                [paymentArray addObject:@"クレジットカード決済(PayPalお支払い)"];
                paymentLabel.text = @"クレジットカード決済(PayPalお支払い)";
                
            }
            
            if ([[JSON valueForKeyPath:@"result.Shop.bt_payment"] intValue] == 1) {
                [paymentArray addObject:@"銀行振込決済"];
                paymentLabel.text = @"銀行振込決済";
                
            }
            if ([[JSON valueForKeyPath:@"result.Shop.cod_payment"] intValue] == 1) {
                [paymentArray addObject: @"代金引換決済"];
                paymentLabel.text = @"代金引換決済";
                
            }
            
            if (!paymentArray.count) {
                NSLog(@"配列がないです%@",paymentArray);
                paymentLabel.text  = @"決済方法がありません";
            }else{
                NSLog(@"配列があります%@",paymentArray);
                paymentLabel.text  = paymentArray[0];
            }
            
            
            [stockPicker reloadAllComponents];
            
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
    } else {
        
        if ([[JSON valueForKeyPath:@"result.Shop.bt_payment"] intValue] == 1) {
            [paymentArray addObject:@"銀行振込決済"];
            paymentLabel.text = @"銀行振込決済";
            
        }
        if ([[JSON valueForKeyPath:@"result.Shop.cod_payment"] intValue] == 1) {
            [paymentArray addObject: @"代金引換決済"];
            paymentLabel.text = @"代金引換決済";
            
        }
        
        if (!paymentArray.count) {
            NSLog(@"配列がないです%@",paymentArray);
            paymentLabel.text  = @"決済方法がありません";
        }else{
            NSLog(@"配列があります%@",paymentArray);
            paymentLabel.text  = paymentArray[0];
        }
        [stockPicker reloadAllComponents];
        
        [self.tableView reloadData];
    }
    
    
    

    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([paymentLabel.text isEqualToString:@"クレジットカード決済"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%d,row:%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        //ツールバーを生成
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //スタイルの設定
        toolBar.barStyle = UIBarStyleDefault;
        //ツールバーを画面サイズに合わせる
        [toolBar sizeToFit];
        // 「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //　完了ボタンの生成
        UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc] initWithTitle:@"次へ" style:UIBarButtonItemStylePlain target:self action:@selector(closeKeyboard:)];
        _commitBtn.tag = indexPath.row;
        // ボタンをToolbarに設定
        NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
        // 表示・非表示の設定
        [toolBar setItems:toolBarItems animated:YES];
        
        switch (indexPath.section) {
            case 0:
                // 決済方法を選択
                paymentLabel.center = CGPointMake(cell.center.x, cell.center.y);
                [cell.contentView addSubview:paymentLabel];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                break;
            case 1:
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"カード番号";
                        cell.accessoryView = cardNumberField;
                        cardNumberField.inputAccessoryView = toolBar;

                        break;
                    case 1:
                        cell.textLabel.text = @"期限";
                        cell.accessoryView = expireField;
                        expireField.inputAccessoryView = toolBar;


                        break;
                    case 2:
                        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
                        cell.textLabel.text = @"セキュリティコード";
                        cell.accessoryView = securityNumberField;
                        _commitBtn.title = @"完了";
                        securityNumberField.inputAccessoryView = toolBar;


                        break;
                        
                    default:
                        break;
                }
                break;
            default:
                break;
        }    }
    
    // Configure the cell...
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"お支払い方法を選択";
            break;
        case 1: // 2個目のセクションの場合
            return @"クレジットカード情報を入力";
            break;
    }
    return nil; //ビルド警告回避用
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        [self selectNumber];
    } else {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UIView *cellScrollView = (UIView*)selectedCell.subviews[0];
        NSLog(@"%@", NSStringFromClass([cellScrollView class]));
        
        for (id view in cellScrollView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [view becomeFirstResponder];
            }
        }
    }
    
    
    // ハイライト解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    stockPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stockPicker.delegate = self; //自分自身をデリゲートに設定する。
    stockPicker.dataSource = self;
    stockPicker.showsSelectionIndicator = YES;
    
    // 配列から要素を検索する
    NSUInteger index = [paymentArray indexOfObject:paymentLabel.text];
    
    // 要素があったか?
    if (index != NSNotFound) { // yes
        [stockPicker selectRow:index inComponent:0 animated:NO];
        
    } else {
        NSLog(@"見つかりませんでした．");
        [stockPicker selectRow:0 inComponent:0 animated:NO];
    }
    
    [stockActionSheet addSubview:stockPicker];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:@[@"完了"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    [stockActionSheet addSubview:closeButton];
    
    [stockActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [stockActionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    NSLog(@"数量ボタンが押されたよ！");
    
}

//選択ピッカー
//ピッカーの列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//必須項目２：Pickerの行の数を返します。
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return paymentArray.count;
}
//表示する値
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    //paymentArray = [NSArray arrayWithObjects:@"クレジットカード決済", @"代金引換決済", @"銀行振込決済", nil];
    paymentLabel.text = paymentArray[row];
    return paymentArray[row];
    
}


- (void)dismissActionSheet {
    
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    [self.tableView reloadData];
}


# pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)inputText{
    NSMutableString *afterInputText = textField.text.mutableCopy;
    NSLog(@"textField.text.mutableCopy:%@",afterInputText);
    // 入力後の文字列を取得することはできないため、入力前の文字列と入力された文字列をつなげる
    [afterInputText replaceCharactersInRange:range withString:inputText];
    NSLog(@"afterInputText:%@",afterInputText);
    NSLog(@"inputText:%@",inputText);
    
    if (expireField.tag == 2) {
        if (!(afterInputText.length <= 5)) {
            return NO;
        }
        if (afterInputText.length == 2) {
            
            if (inputText.length == 0) {
                textField.text = [afterInputText substringToIndex:1];
            } else {
                textField.text = [NSString stringWithFormat:@"%@/",afterInputText];
            }
            return NO;
            
        }
        
        if (afterInputText.length == 3) {
            NSLog(@"afterInputText.length == 8:%@",afterInputText);
            return YES;
        }
    }
    
    return YES;
}


-(void)closeKeyboard:(id)sender{
    
    
    switch ([sender tag]) {
        case 0:
            [expireField becomeFirstResponder];
            break;
        case 1:
            [securityNumberField becomeFirstResponder];
            break;
        case 2:
            [securityNumberField resignFirstResponder];
            break;
            
        default:
            break;
    }
    
    
}




- (void)purchase:(id)sender{
    
    //商品内容を確認
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cart/confirm_checkout",baseURL]];
    // don't forget to set parameterEncoding!
    NSMutableDictionary *cartDict = [[BSCartViewController getCartItem] mutableCopy];
    
    NSString *tel = [NSString stringWithFormat:@"%@-%@-%@",addressDictionary[@"firstTelephone"],addressDictionary[@"secondTelephone"],addressDictionary[@"thirdTelephone"]];
    cartDict[@"last_name"] = addressDictionary[@"lastName"];
    cartDict[@"first_name"] = addressDictionary[@"firstName"];
    cartDict[@"zip_code"] = addressDictionary[@"zipcode"];
    cartDict[@"prefecture"] = addressDictionary[@"prefecture"];
    cartDict[@"address"] = addressDictionary[@"address"];
    cartDict[@"address2"] = addressDictionary[@"detailAddress"];
    cartDict[@"tel"] = tel;
    cartDict[@"mail_address"] = addressDictionary[@"mail"];
    cartDict[@"remark"] = @"";
    NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    cartDict[@"version"] = version;
    
    [SVProgressHUD showWithStatus:@"注文情報を確認中" maskType:SVProgressHUDMaskTypeGradient];
    
    NSLog(@"cartDict:%@", cartDict);
    //決済情報なし
    //決済情報を追加
    if ([paymentLabel.text isEqualToString:@"クレジットカード決済"]) {
        cartDict[@"payment"] = @"creditcard";
        
        // カード情報
        cartDict[@"card_no"] = cardNumberField.text;
        
        NSString *expireMM;
        NSString *expireYY;
        if (expireField.text == nil || [expireField.text isEqualToString:@""]) {
            
        } else {
            expireMM = [expireField.text substringToIndex:2];
            // 文字列の末尾から2文字を取り出す
            expireYY = [expireField.text substringFromIndex:3];
        }
        
        
        NSString *expireYYMM = [NSString stringWithFormat:@"%@%@",expireYY,expireMM];
        NSLog(@"expireYYMM:%@",expireYYMM);
        cartDict[@"expire"] = expireYYMM;
        cartDict[@"security_cd"] = securityNumberField.text;
        
        NSLog(@"クレジットカード決済cartDict:%@", cartDict);
        NSLog(@"クレジットカード決済");
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[url absoluteString] parameters:cartParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"注文内容の取得: %@", responseObject);
            NSDictionary *error = responseObject[@"error"];
            NSString *cardNOErrormessage = error[@"validations"][@"Order"][@"card_no"][0];
            NSString *expireErrormessage = error[@"validations"][@"Order"][@"expire"][0];
            NSString *securityErrormessage = error[@"validations"][@"Order"][@"security_cd"][0];
            
            NSString *errormessage1 = [responseObject valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"expire:error:%@",errormessage1);
            
            if (cardNOErrormessage) {
                [SVProgressHUD showErrorWithStatus:cardNOErrormessage];
                return ;
            }
            if (expireErrormessage) {
                [SVProgressHUD showErrorWithStatus:expireErrormessage];
                return ;
            }
            if (securityErrormessage) {
                [SVProgressHUD showErrorWithStatus:securityErrormessage];
                return ;
            }
            
            NSArray *zipcodeArray = [responseObject valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [responseObject valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [responseObject valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];
                
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"完了"];
                
                //ペイパル決済に飛ぶ
                BSConfirmCheckoutViewController *vc = [[BSConfirmCheckoutViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
    }else if ([paymentLabel.text isEqualToString:@"クレジットカード決済(PayPalお支払い)"]){
        cartDict[@"payment"] = @"creditcard";
        

        NSLog(@"クレジットカード決済(PayPalお支払い):%@", cartDict);
        NSLog(@"クレジットカード決済");
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[url absoluteString] parameters:cartParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"注文内容の取得: %@", responseObject);
            NSDictionary *error = responseObject[@"error"];
            NSString *errormessage = error[@"message"];
            NSString *errormessage1 = [responseObject valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"Error message: %@", errormessage);
            
            
            
            NSArray *zipcodeArray = [responseObject valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [responseObject valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [responseObject valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];
                
                
            }else{
                
                [SVProgressHUD showSuccessWithStatus:@"完了"];
                
                //ペイパル決済に飛ぶ
                BSPaypalViewController *vc = [[BSPaypalViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
        
        
        
        
        
        
    }else if ([paymentLabel.text isEqualToString:@"代金引換決済"]){
        cartDict[@"payment"] = @"cod";
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[url absoluteString] parameters:cartParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"注文内容の取得: %@", responseObject);
            NSDictionary *error = responseObject[@"error"];
            NSString *errormessage = error[@"message"];
            NSString *errormessage1 = [responseObject valueForKeyPath:@"result.Cart.1.error"];
            NSLog(@"エラーです%@",errormessage1);
            NSLog(@"Error message: %@", errormessage);
            
            
            NSArray *zipcodeArray = [responseObject valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [responseObject valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [responseObject valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.remark"];
            if (remarkErrorArray.count) {
                NSString *remark = remarkErrorArray[0];
                [SVProgressHUD showErrorWithStatus:remark];
                return ;
            }
            
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"注文情報が正しくありません"];
                return ;
            }else{
                
                BSConfirmCheckoutViewController *vc = [[BSConfirmCheckoutViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
        
        
        
        
        
    }else{
        //銀行決済
        cartDict[@"payment"] = @"bt";
        //決済情報あり
        importOrderDictionary = [cartDict copy];
        NSDictionary *cartParameters = [cartDict copy];

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:[url absoluteString] parameters:cartParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"注文内容の取得: %@", responseObject);
            NSDictionary *error = responseObject[@"error"];
            NSString *errormessage = [responseObject valueForKeyPath:@"error.message"];
            NSString *errormessage2 = [responseObject valueForKeyPath:@"result.Cart.0.error"];
            NSArray *errorArray = [responseObject valueForKeyPath:@"result.Cart"];
            NSLog(@"エラーの配列%@",errorArray);
            NSLog(@"アイテム数%d",errorArray.count);
            
            
            NSArray *zipcodeArray = [responseObject valueForKeyPath:@"error.validations.Order.zip_code"];
            if (zipcodeArray.count) {
                NSString *zipcode = zipcodeArray[0];
                [SVProgressHUD showErrorWithStatus:zipcode];
                return ;
            }
            NSArray *firstNameArray = [responseObject valueForKeyPath:@"error.validations.Order.first_name"];
            if (firstNameArray.count) {
                NSString *firstName = firstNameArray[0];
                [SVProgressHUD showErrorWithStatus:firstName];
                return ;
            }
            NSArray *lastNameArray = [responseObject valueForKeyPath:@"error.validations.Order.last_name"];
            if (lastNameArray.count) {
                NSString *lastName = lastNameArray[0];
                [SVProgressHUD showErrorWithStatus:lastName];
                return ;
            }
            NSArray *prefectureErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.prefecture"];
            if (prefectureErrorArray.count) {
                NSString *prefecture = prefectureErrorArray[0];
                [SVProgressHUD showErrorWithStatus:prefecture];
                return ;
            }
            NSArray *addressErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address"];
            if (addressErrorArray.count) {
                NSString *address = addressErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address];
                return ;
            }
            NSArray *address2ErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.address2"];
            if (addressErrorArray.count) {
                NSString *address2 = address2ErrorArray[0];
                [SVProgressHUD showErrorWithStatus:address2];
                return ;
            }
            NSArray *telErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.tel"];
            if (telErrorArray.count) {
                NSString *tel = telErrorArray[0];
                [SVProgressHUD showErrorWithStatus:tel];
                return ;
            }
            NSArray *mailErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.mail_address"];
            if (mailErrorArray.count) {
                NSString *mail = mailErrorArray[0];
                [SVProgressHUD showErrorWithStatus:mail];
                return ;
            }
            NSArray *remarkErrorArray = [responseObject valueForKeyPath:@"error.validations.Order.remark"];
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
                
                [SVProgressHUD showSuccessWithStatus:@"完了"];
                BSConfirmCheckoutViewController *vc = [[BSConfirmCheckoutViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
    }
    
}


+(NSDictionary*)getCartItem{
    return importOrderDictionary;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
