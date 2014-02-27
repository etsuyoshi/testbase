//
//  BSInputTelephoneView.h
//  BASE
//
//  Created by Takkun on 2014/02/04.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSInputTelephoneView : UIView
@property (weak, nonatomic) IBOutlet UITextField *firstTelephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTelephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdTelephoneTextField;

+ (id)inputTelephoneView;

@end
