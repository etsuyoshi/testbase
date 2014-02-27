//
//  BSInputAddressTableView.h
//  BASE
//
//  Created by Takkun on 2014/02/04.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BSInputTelephoneView.h"
#import "BSInputFormTextField.h"

@interface BSInputAddressTableView : UITableView <UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) BSInputTelephoneView *inputTelephoneView;
@property (nonatomic,strong) BSInputFormTextField *lastNameTextField;
@property (nonatomic,strong) BSInputFormTextField *firstNameTextField;
@property (nonatomic,strong) BSInputFormTextField *zipcodeTextField;
@property (nonatomic,strong) BSInputFormTextField *prefectureTextField;
@property (nonatomic,strong) BSInputFormTextField *addressTextField;
@property (nonatomic,strong) BSInputFormTextField *detailAddressTextField;
@property (nonatomic,strong) BSInputFormTextField *telephoneTextField;
@property (nonatomic,strong) BSInputFormTextField *mailTextField;
@end
