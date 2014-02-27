//
//  BSInputAddressTableView.m
//  BASE
//
//  Created by Takkun on 2014/02/04.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSInputAddressTableView.h"

#import "BSDefaultViewObject.h"
#import "AFNetworking.h"



@implementation BSInputAddressTableView{
    
    UIToolbar *toolBar;                             // キーボードの上のバー
    

    

    UITextField *activeField;                       // フォーカスされているフォーム
    
    BOOL pickerIsOpened;
    UIPickerView *stockPicker;
    UIActionSheet *stockActionSheet;
    
    NSArray *prefectureArray;                       // 47都道府県
    NSString *prefectureString;

}
@synthesize inputTelephoneView;
@synthesize lastNameTextField;
@synthesize firstNameTextField;
@synthesize zipcodeTextField;
@synthesize prefectureTextField;
@synthesize addressTextField;
@synthesize detailAddressTextField;
@synthesize telephoneTextField;
@synthesize mailTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        // Initialization code
        
        self.dataSource = self;
        self.delegate = self;
        self.contentInset = UIEdgeInsetsMake(0, 0, -40, 0);
        
        lastNameTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        firstNameTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        zipcodeTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        prefectureTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        addressTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        detailAddressTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        inputTelephoneView = [[BSInputTelephoneView alloc] init];
        mailTextField = [[BSInputFormTextField alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
        
    }
    return self;
}


# pragma mark - tableViewDataSource
//テーブルに含まれるセクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//セクションに含まれる行の数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rows;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 6;
            break;
            
        default:
            rows = 2;
            break;
    }
    return rows;

}
//行に表示するデータの生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"section:%d,row:%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        
        //http://api.zipaddress.net/?zipcode=8620941&lang=ja
        
        
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
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        
        // ToolbarをTextViewのinputAccessoryViewに設定
        
        if (indexPath.section == 0) {
            _commitBtn.tag = indexPath.row + 1;
            cell.tag = indexPath.row + 1;
            switch (indexPath.row) {
                case 0:
                    
                    lastNameTextField.delegate = self;
                    lastNameTextField.placeholder = @"田中";
                    lastNameTextField.tag = indexPath.row + 1;
                    lastNameTextField.inputAccessoryView = toolBar;


                    
                    cell.accessoryView = lastNameTextField;
                    cell.textLabel.text = @"姓";
                    
                    
                    break;
                case 1:
                    
                    firstNameTextField.delegate = self;
                    firstNameTextField.placeholder = @"太郎";
                    firstNameTextField.tag = indexPath.row + 1;
                    firstNameTextField.inputAccessoryView = toolBar;

                    cell.textLabel.text = @"名";
                    cell.accessoryView = firstNameTextField;
                    break;
                default:
                    break;
            }
        } else {
            _commitBtn.tag = indexPath.row + 3;
            cell.tag = indexPath.row + 3;

            switch (indexPath.row) {
                case 0:
                    
                    zipcodeTextField.inputAccessoryView = toolBar;
                    zipcodeTextField.delegate = self;
                    zipcodeTextField.placeholder = @"123-4567";
                    zipcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
                    zipcodeTextField.tag = indexPath.row + 3;

                    
                    cell.textLabel.text = @"郵便番号";
                    cell.accessoryView = zipcodeTextField;

                    
                    break;
                case 1:
                    
                    prefectureTextField.inputAccessoryView = toolBar;
                    prefectureTextField.delegate = self;
                    prefectureTextField.placeholder = @"東京都";
                    prefectureTextField.tag = indexPath.row + 3;

                    
                    cell.textLabel.text = @"都道府県";
                    cell.accessoryView = prefectureTextField;
                    
                    break;
                case 2:
                    
                    addressTextField.inputAccessoryView = toolBar;
                    addressTextField.delegate = self;
                    addressTextField.placeholder = @"〇〇市△△町";
                    addressTextField.tag = indexPath.row + 3;

                    
                    cell.textLabel.text = @"住所";
                    cell.accessoryView = addressTextField;
                    break;
                case 3:
                    
                    detailAddressTextField.delegate = self;
                    detailAddressTextField.inputAccessoryView = toolBar;
                    detailAddressTextField.placeholder = @"〇〇丁目△-△ BASEタワー 〇〇号室";
                    detailAddressTextField.tag = indexPath.row + 3;

                    
                    cell.textLabel.text = @"以降の住所";
                    cell.accessoryView = detailAddressTextField;
                    break;
                case 4:
                    
                    inputTelephoneView.firstTelephoneTextField.inputAccessoryView = toolBar;
                    inputTelephoneView.secondTelephoneTextField.inputAccessoryView = toolBar;
                    inputTelephoneView.thirdTelephoneTextField.inputAccessoryView = toolBar;
                    
                    inputTelephoneView.firstTelephoneTextField.delegate = self;
                    inputTelephoneView.secondTelephoneTextField.delegate = self;
                    inputTelephoneView.thirdTelephoneTextField.delegate = self;
                    
                    inputTelephoneView.firstTelephoneTextField.keyboardType = UIKeyboardTypeNumberPad;
                    inputTelephoneView.secondTelephoneTextField.keyboardType = UIKeyboardTypeNumberPad;
                    inputTelephoneView.thirdTelephoneTextField.keyboardType = UIKeyboardTypeNumberPad;



                    cell.textLabel.text = @"電話番号";
                    cell.accessoryView = inputTelephoneView;
                    
                    break;
                case 5:
                    
                    _commitBtn.title = @"完了";
                    
                    mailTextField.delegate = self;
                    mailTextField.inputAccessoryView = toolBar;
                    mailTextField.placeholder = @"example@example.com";
                    mailTextField.tag = indexPath.row + 3;
                    mailTextField.keyboardType = UIKeyboardTypeURL;

                    
                    cell.textLabel.text = @"メールアドレス";
                    cell.accessoryView = mailTextField;
                    break;
                default:
                    break;
            }
        }
        

    }
    
    
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"名前";
            break;
        case 1: // 2個目のセクションの場合
            return @"住所";
            break;
    }
    return nil; //ビルド警告回避用
}

# pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)inputText{
    NSMutableString *afterInputText = textField.text.mutableCopy;
    NSLog(@"textField.text.mutableCopy:%@",afterInputText);
    // 入力後の文字列を取得することはできないため、入力前の文字列と入力された文字列をつなげる
    [afterInputText replaceCharactersInRange:range withString:inputText];
    NSLog(@"afterInputText:%@",afterInputText);
    NSLog(@"inputText:%@",inputText);
    
    // 郵便番号のみ
    if (textField.tag == 3) {
        if (!(afterInputText.length <= 8)) {
            return NO;
        }
        if (afterInputText.length == 3) {
            
            if (inputText.length == 0) {
                textField.text = [afterInputText substringToIndex:2];
            } else {
                textField.text = [NSString stringWithFormat:@"%@-",afterInputText];
            }
            return NO;
            
        }
        
        if (afterInputText.length == 8) {
            NSLog(@"afterInputText.length == 8:%@",afterInputText);
            [self importAddressInfo:afterInputText];
            return YES;
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    
    activeField = textField;
    if (activeField.tag == 4) {
        [self showPicker];
        return NO;
    }
    return YES;
}



-(void)closeKeyboard:(id)sender{
    
    
    // 電話番号のtextView
    if (activeField == inputTelephoneView.firstTelephoneTextField || activeField == inputTelephoneView.secondTelephoneTextField || activeField == inputTelephoneView.thirdTelephoneTextField) {
        
        if (activeField == inputTelephoneView.firstTelephoneTextField) {
            [inputTelephoneView.secondTelephoneTextField becomeFirstResponder];
        } else if (activeField == inputTelephoneView.secondTelephoneTextField) {
            [inputTelephoneView.thirdTelephoneTextField becomeFirstResponder];
        } else {
            [mailTextField becomeFirstResponder];
        }
    } else {
        NSLog(@"フォーム番号:%d",[sender tag]);
        switch ([sender tag]) {
            case 1:
                [firstNameTextField becomeFirstResponder];
                break;
            case 2:
                [zipcodeTextField becomeFirstResponder];
                break;
            case 3:
                if (addressTextField.text == nil) {
                    [prefectureTextField becomeFirstResponder];
                } else {
                    [detailAddressTextField becomeFirstResponder];

                }
                break;
            case 4:
                [addressTextField becomeFirstResponder];
                break;
            case 5:
                [detailAddressTextField becomeFirstResponder];
                break;
            case 6:
                //[self importAddressInfo:zipcodeTextField.text];
                [inputTelephoneView.firstTelephoneTextField becomeFirstResponder];
                break;
            case 8:
                //[self importAddressInfo:zipcodeTextField.text];
                [mailTextField resignFirstResponder];
                break;
                
            default:
                break;
        }
    }
    
    
}

-(void)importAddressInfo:(NSString*)zipcode{
    
    
    
    [[BSPublicAPIClient sharedClient] getAddressWithZipcode:zipcode completion:^(NSDictionary *results, NSError *error) {
       
        NSLog(@"getAddressWithZipcode: %@", results);
        prefectureTextField.text = [results valueForKeyPath:@"data.pref"];
        addressTextField.text = [results valueForKeyPath:@"data.address"];
        
        
        if (error) {
            [prefectureTextField becomeFirstResponder];

        }
        
        
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
    
    
    if (textField == inputTelephoneView.firstTelephoneTextField || textField == inputTelephoneView.secondTelephoneTextField || textField == inputTelephoneView.thirdTelephoneTextField) {
        
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview.superview;
        
        NSLog(@"%@", NSStringFromClass([cell class]));
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        if (textField.tag == 3) {
            self.contentOffset = CGPointMake(self.contentOffset.x, cell.frame.origin.y - 44);
            
        } else {
            self.contentOffset = CGPointMake(self.contentOffset.x, cell.frame.origin.y - 44);
            
        }
        
        [UIView commitAnimations];
    } else {
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
        
        NSLog(@"%@", NSStringFromClass([cell class]));
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        if (textField.tag == 3) {
            self.contentOffset = CGPointMake(self.contentOffset.x, cell.frame.origin.y - 44);
            
        } else {
            self.contentOffset = CGPointMake(self.contentOffset.x, cell.frame.origin.y - 44);
            
        }
        
        [UIView commitAnimations];
    }
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField*)textField {
    if (textField.tag == 8) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
        [UIView commitAnimations];

    }
}


- (void)showPicker {
    
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
        
        prefectureArray = @[@"北海道", @"青森県", @"岩手県",@"宮城県", @"秋田県", @"山形県",@"福島県", @"茨城県", @"栃木県",@"群馬県", @"埼玉県", @"千葉県",@"東京都", @"神奈川県", @"新潟県",@"富山県", @"石川県", @"福井県",@"山梨県", @"長野県", @"岐阜県",@"静岡県", @"愛知県", @"三重県",@"滋賀県", @"京都府", @"大阪府",@"兵庫県", @"奈良県", @"和歌山県",@"鳥取県", @"島根県", @"岡山県",@"広島県", @"山口県", @"徳島県",@"香川県", @"愛媛県", @"高知県",@"福岡県", @"佐賀県", @"長崎県",@"熊本県", @"大分県", @"宮崎県",@"鹿児島県", @"沖縄県"];
    }
    
    
    
    
    // 配列から要素を検索する
    NSUInteger index = [prefectureArray indexOfObject:prefectureTextField.text];
    
    // 要素があったか?
    if (index != NSNotFound) { // yes
        [stockPicker selectRow:index inComponent:0 animated:NO];

    } else {
        NSLog(@"見つかりませんでした．");
        [stockPicker selectRow:12 inComponent:0 animated:NO];
    }
    [stockPicker reloadAllComponents];

    
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
}


- (void)dismissActionSheet {
    prefectureTextField.text = prefectureString;
    [stockActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    [addressTextField becomeFirstResponder];
}



//選択ピッカー
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
    
    
    //paymentArray = [NSArray arrayWithObjects:@"クレジットカード決済", @"代金引換決済", @"銀行振込決済", nil];
    prefectureString = prefectureArray[row];
    return prefectureArray[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    prefectureString = prefectureArray[row];
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"tableview");
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *cellScrollView = (UIView*)selectedCell.subviews[0];
    NSLog(@"%@", NSStringFromClass([cellScrollView class]));

    for (id view in cellScrollView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view becomeFirstResponder];
        }
    }
    //UITextField *focusTextField = (UITextField*)cellScrollView.subviews[4];
    //NSLog(@"[focusTextField class]:%@", NSStringFromClass([focusTextField class]));

    
    // ハイライト解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
