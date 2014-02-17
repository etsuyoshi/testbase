//
//  BSMyShopViewController.h
//  BASE
//
//  Created by Takkun on 2013/07/01.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BSMyShopViewController : UIViewController <MFMailComposeViewControllerDelegate>


+(NSString*)getViewMode;
@end
