//
//  BSEditShopViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSDefaultViewObject.h"
#import "BSTutorialViewController.h"
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface BSEditShopViewController : GAITrackedViewController<UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UITextField *shopName;
    
    //テキストフィールドにフォーカスした時の座標
    CGPoint svos;
    
    BOOL validation;
    
    UIImageView *logoImage;
    NSMutableData *receivedData;
}

@end


