//
//  BSAddItemViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "BSDefaultViewObject.h"
#import "BSTutorialViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"




@interface BSAddItemViewController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end
