//
//  BSSelectPaymentTableViewController.h
//  BASE
//
//  Created by Takkun on 2014/02/10.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSSelectPaymentTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

- (id)initWithStyle:(UITableViewStyle)style savedUserNumber:(int)savedUserNumber;

+(NSDictionary*)getCartItem;

@end
