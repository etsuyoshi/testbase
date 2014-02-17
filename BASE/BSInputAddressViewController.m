//
//  BSInputAddressViewController.m
//  BASE
//
//  Created by Takkun on 2014/02/06.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSInputAddressViewController.h"

#import "BSInputAddressTableView.h"
#import "UICKeyChainStore.h"
#import "BSSelectPaymentTableViewController.h"



@interface BSInputAddressViewController ()

@end

@implementation BSInputAddressViewController{
    BSInputAddressTableView *inputAddressTable;
    
    int _editMode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(int)editMode        // 0:新規追加 1:一番目ユーザー情報を編集 2:２番目のユーザー情報を編集
{
    self = [super init];
    if (self) {
        // Custom initialization
        _editMode = editMode;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"お届け先を入力";
    inputAddressTable = [[BSInputAddressTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:inputAddressTable];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"決定" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton)];
    
    // ナビゲーションアイテムの右側に戻るボタンを設置
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (_editMode >= 1) {
        [self performSelector:@selector(setFormValue)
                   withObject:nil afterDelay:0.5];

    }
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}


- (void)setFormValue{
    
    NSLog(@"setFormValue");
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSDictionary *decodeDictionary;
    
    if (_editMode == 1) {
        decodeDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"firstUserAddress"]];
    } else {
        decodeDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"secondUserAddress"]];
    }
    
    inputAddressTable.lastNameTextField.text = decodeDictionary[@"lastName"];
    inputAddressTable.firstNameTextField.text = decodeDictionary[@"firstName"];
    inputAddressTable.zipcodeTextField.text = decodeDictionary[@"zipcode"];
    inputAddressTable.prefectureTextField.text = decodeDictionary[@"prefecture"];
    inputAddressTable.addressTextField.text = decodeDictionary[@"address"];
    inputAddressTable.detailAddressTextField.text = decodeDictionary[@"detailAddress"];
    inputAddressTable.inputTelephoneView.firstTelephoneTextField.text = decodeDictionary[@"firstTelephone"];
    inputAddressTable.inputTelephoneView.secondTelephoneTextField.text = decodeDictionary[@"secondTelephone"];
    inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text = decodeDictionary[@"thirdTelephone"];
    inputAddressTable.mailTextField.text = decodeDictionary[@"mail"];
    
    NSLog(@"[store stringForKeyFirstUserAddress:%@",decodeDictionary);

    
}


- (void)saveButton{
    
    if ([self validationCheck]) {
        if (_editMode >= 1) {
            [self editAddress];
        } else {
            [self saveAddress];

        }
    }
    
}

- (void)saveAddress{
    
    /*
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
    NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
    NSString *email = [store stringForKey:@"email"];
    NSString *password = [store stringForKey:@"password"];
     */
    
    // 電話番号は３つに分ける
    // "firstTelephone"-"secondTelephone"-"thirdTelephone"
    NSDictionary *userAddressDectionary = @{@"lastName"         : inputAddressTable.lastNameTextField.text,
                                            @"firstName"        : inputAddressTable.firstNameTextField.text,
                                            @"zipcode"          : inputAddressTable.zipcodeTextField.text,
                                            @"prefecture"       : inputAddressTable.prefectureTextField.text,
                                            @"address"          : inputAddressTable.addressTextField.text,
                                            @"detailAddress"    : inputAddressTable.detailAddressTextField.text,
                                            @"firstTelephone"   : inputAddressTable.inputTelephoneView.firstTelephoneTextField.text,
                                            @"secondTelephone"  : inputAddressTable.inputTelephoneView.secondTelephoneTextField.text,
                                            @"thirdTelephone"   : inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text,
                                            @"mail"             : inputAddressTable.mailTextField.text
                                            };
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userAddressDectionary];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    
    int userNumber;
    if (![store dataForKey:@"firstUserAddress"]) {
        NSLog(@"firstUserAddressないよ");
        [store setData:data forKey:@"firstUserAddress"];
        userNumber = 1;
    } else {
        [store setData:data forKey:@"secondUserAddress"];
        userNumber = 2;

    }
    [store synchronize];

    NSDictionary *decodeDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[store dataForKey:@"firstUserAddress"]];
    
    BSSelectPaymentTableViewController *vc = [[BSSelectPaymentTableViewController alloc] initWithStyle:UITableViewStyleGrouped savedUserNumber:userNumber];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"[store stringForKeyFirstUserAddress:%@",decodeDictionary);

}


- (void)editAddress{
    
    NSDictionary *userAddressDectionary = @{@"lastName"         : inputAddressTable.lastNameTextField.text,
                                            @"firstName"        : inputAddressTable.firstNameTextField.text,
                                            @"zipcode"          : inputAddressTable.zipcodeTextField.text,
                                            @"prefecture"       : inputAddressTable.prefectureTextField.text,
                                            @"address"          : inputAddressTable.addressTextField.text,
                                            @"detailAddress"    : inputAddressTable.detailAddressTextField.text,
                                            @"firstTelephone"   : inputAddressTable.inputTelephoneView.firstTelephoneTextField.text,
                                            @"secondTelephone"  : inputAddressTable.inputTelephoneView.secondTelephoneTextField.text,
                                            @"thirdTelephone"   : inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text,
                                            @"mail"             : inputAddressTable.mailTextField.text
                                            };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userAddressDectionary];
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    int userNumber;
    if (_editMode == 1) {
        [store setData:data forKey:@"firstUserAddress"];
        userNumber = 1;
    } else {
        [store setData:data forKey:@"secondUserAddress"];
        userNumber = 2;

    }
    [store synchronize];

    BSSelectPaymentTableViewController *vc = [[BSSelectPaymentTableViewController alloc] initWithStyle:UITableViewStyleGrouped savedUserNumber:userNumber];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)validationCheck{
    
    
    BOOL validation;
    NSMutableCharacterSet *checkCharSet = [[NSMutableCharacterSet alloc] init];
    [checkCharSet addCharactersInString:@"1234567890"];
    
    NSMutableCharacterSet *checkZipSet = [[NSMutableCharacterSet alloc] init];
    [checkZipSet addCharactersInString:@"1234567890-"];
    
    if (inputAddressTable.lastNameTextField.text == nil || [inputAddressTable.lastNameTextField.text isEqualToString:@""]) {
        [inputAddressTable.lastNameTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"名前(姓)の入力が正しくありません" message:@"名前(姓)を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (inputAddressTable.firstNameTextField.text == nil || [inputAddressTable.firstNameTextField.text isEqualToString:@""]) {
        [inputAddressTable.firstNameTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"名前(名)の入力が正しくありません" message:@"名前(名)を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if([[inputAddressTable.zipcodeTextField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || inputAddressTable.zipcodeTextField.text == nil || [inputAddressTable.zipcodeTextField.text isEqualToString:@""]){
        [inputAddressTable.zipcodeTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"郵便番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if (inputAddressTable.addressTextField.text == nil || [inputAddressTable.addressTextField.text isEqualToString:@""]){
        [inputAddressTable.addressTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"住所の入力が正しくありません" message:@"住所を入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if (inputAddressTable.detailAddressTextField.text == nil || [inputAddressTable.detailAddressTextField.text isEqualToString:@""]){
        [inputAddressTable.detailAddressTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"その他の住所の入力が正しくありません" message:@"その他の住所のをご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else if([[inputAddressTable.inputTelephoneView.firstTelephoneTextField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || inputAddressTable.inputTelephoneView.firstTelephoneTextField.text == nil || [inputAddressTable.inputTelephoneView.firstTelephoneTextField.text isEqualToString:@""]){
        [inputAddressTable.telephoneTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"電話番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if([[inputAddressTable.inputTelephoneView.secondTelephoneTextField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || inputAddressTable.inputTelephoneView.secondTelephoneTextField.text == nil || [inputAddressTable.inputTelephoneView.secondTelephoneTextField.text isEqualToString:@""]){
        [inputAddressTable.telephoneTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"電話番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if([[inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text stringByTrimmingCharactersInSet:checkZipSet] length] > 0 || inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text == nil || [inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text isEqualToString:@""]){
        [inputAddressTable.telephoneTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"電話番号の入力が正しくありません" message:@"数字（半角）でご入力ください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
        
    }else if (inputAddressTable.mailTextField.text == nil || [inputAddressTable.mailTextField.text isEqualToString:@""] || ![self NSStringIsValidEmail:inputAddressTable.mailTextField.text]){
        [inputAddressTable.mailTextField becomeFirstResponder];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"メールアドレスの入力が正しくありません" message:@"メールアドレスを入力してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        validation = NO;
    }else{
        validation = YES;
    }
    
    return validation;
    
}



-(NSString*)combineTelephoneNumber{
    
    NSString *combineTelephoneNumber = [NSString stringWithFormat:@"%@-%@-%@",inputAddressTable.inputTelephoneView.firstTelephoneTextField,inputAddressTable.inputTelephoneView.secondTelephoneTextField,inputAddressTable.inputTelephoneView.thirdTelephoneTextField.text];
    
    return combineTelephoneNumber;

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

// キーボードを隠す処理
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
