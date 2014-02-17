//
//  BSVaryViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/22.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDefaultViewObject.h"
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "BSEditItemViewController.h"
#import "UIBarButtonItem+DesignedButton.h"

#import "GAITrackedViewController.h"
#import "GAI.h"



@interface BSVaryViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end
