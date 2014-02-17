//
//  BSSelectBgViewController.h
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "BSDefaultViewObject.h"

#import "SVProgressHUD.h"

#import "GAITrackedViewController.h"
#import "GAI.h"


@interface BSSelectBgViewController : GAITrackedViewController<UIScrollViewDelegate>{
    UIView *selectView;
    
    NSDictionary *backgroundsDict;
    
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    UIImageView *backgroundImage3;
    UIImageView *backgroundImage4;
    UIImageView *backgroundImage5;
    UIImageView *backgroundImage6;
    UIImageView *backgroundImage7;
    UIImageView *backgroundImage8;
    UIImageView *backgroundImage9;
    UIImageView *backgroundImage10;
    
    UIButton *selectBgButton;
    
    UIImageView *check;
    
    int imageNumber;
    
}

@end
