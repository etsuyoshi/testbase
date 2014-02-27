//
//  BSMyShopViewController.m
//  BASE
//
//  Created by Takkun on 2013/07/01.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMyShopViewController.h"

#import "ECSlidingViewController.h"
#import "BSMenuViewController.h"
#import "BSDefaultViewObject.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "UIBarButtonItem+DesignedButton.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>



@interface BSMyShopViewController ()

@end

@implementation BSMyShopViewController{
    UILabel *urlLabel;
    NSString *shopName;
    
    UIImage *shareImage;
    UIButton *copyButton;
    
    NSString *apiUrl;

}
static NSString *viewMode = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"お店情報";
    apiUrl = [BSDefaultViewObject setApiUrl];

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[BSMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"お店情報";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.tag = 100;
    [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];
    
    UIButton *menuButton;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, -2, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_7_menu"] forState:UIControlStateNormal];
    }else{
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, -2, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    }
    [menuButton addTarget:self action:@selector(slideMenu) forControlEvents:UIControlEventTouchUpInside];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
    [menuButtonView addSubview:menuButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
 
    
    
    UIButton *mobileViewButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 50, 142, 188)];
    [mobileViewButton setImage:[UIImage imageNamed:@"btn_bw_sp"] forState:UIControlStateNormal];
    [mobileViewButton addTarget:self action:@selector(webView:) forControlEvents:UIControlEventTouchUpInside];
    mobileViewButton.tag = 1;
    //mobileViewButton.layer.cornerRadius = 7;
    [self.view addSubview:mobileViewButton];
    
    
    UIButton *pcViewButton = [[UIButton alloc] initWithFrame:CGRectMake(166, 50, 142, 188)];
    [pcViewButton setImage:[UIImage imageNamed:@"btn_bw_pc"] forState:UIControlStateNormal];
    [pcViewButton addTarget:self action:@selector(webView:) forControlEvents:UIControlEventTouchUpInside];
    pcViewButton.tag = 2;
    [self.view addSubview:pcViewButton];
    
    
    
    urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,80)];
    urlLabel.textColor = [UIColor darkGrayColor];
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.font = [UIFont boldSystemFontOfSize:16];
    [urlLabel setText:@"ショップURL"];
    [urlLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [urlLabel setNumberOfLines:1];
    [urlLabel sizeToFit];
    urlLabel.textAlignment = NSTextAlignmentCenter;
    urlLabel.center = CGPointMake(160,30);
    [self.view addSubview:urlLabel];
    
    copyButton = [[UIButton alloc] initWithFrame:CGRectMake(urlLabel.frame.origin.x + urlLabel.frame.size.width,  urlLabel.frame.origin.y, 30, 30)];
    [copyButton setImage:[UIImage imageNamed:@"btn_url_copy"] forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyUrl:) forControlEvents:UIControlEventTouchUpInside];
    //mobileViewButton.layer.cornerRadius = 7;
    [self.view addSubview:copyButton];
    
    
    /*
    urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    urlButton.frame = CGRectMake(10, 160, 300, 40);
    [urlButton setImage:nil forState:UIControlStateNormal];
    [urlButton addTarget:self action:@selector(copyUrl:) forControlEvents:UIControlEventTouchUpInside];
    [urlButton setTitle:@"ショップURL" forState:UIControlStateNormal];
    [urlButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    urlButton.tag = 2;
    urlButton.backgroundColor = [UIColor blackColor];
    urlButton.alpha = 0.2;
    urlButton.layer.cornerRadius = 3;
    [self.view addSubview:urlButton];
    */
    
    
    UIView *topLine1 = [[UIView alloc] init];
    topLine1.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    topLine1.frame = CGRectMake(0, 250, 320, 1);
    UIView *bottomLine1 = [[UIView alloc] init];
    bottomLine1.backgroundColor = [UIColor whiteColor];
    bottomLine1.frame = CGRectMake(0, 251, 320, 1);
    [self.view addSubview:topLine1];
    [self.view addSubview:bottomLine1];
    
    UILabel *socialLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,300,80)];
    socialLabel.textColor = [UIColor darkGrayColor];
    socialLabel.backgroundColor = [UIColor clearColor];
    socialLabel.font = [UIFont boldSystemFontOfSize:16];
    [socialLabel setText:@"ショップ情報を共有する"];
    [socialLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [socialLabel setNumberOfLines:0];
    [socialLabel sizeToFit];
    socialLabel.center = CGPointMake(160,272);
    [self.view addSubview:socialLabel];
    
    
    UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    socialButton.frame = CGRectMake(14, 290, 145, 42);
    [socialButton setImage:[UIImage imageNamed:@"btn_sns_nfb"] forState:UIControlStateNormal];
    [socialButton addTarget:self action:@selector(social:) forControlEvents:UIControlEventTouchUpInside];
    //[socialButton setTitle:@"ショップURL" forState:UIControlStateNormal];
    [socialButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    socialButton.tag = 1;
    [self.view addSubview:socialButton];
    
    UIButton *socialButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    socialButton2.frame = CGRectMake(161, 290, 145, 42);
    [socialButton2 setImage:[UIImage imageNamed:@"btn_sns_ntw"] forState:UIControlStateNormal];
    [socialButton2 addTarget:self action:@selector(social:) forControlEvents:UIControlEventTouchUpInside];
    //[socialButton setTitle:@"ショップURL" forState:UIControlStateNormal];
    [socialButton2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    socialButton2.tag = 2;
    [self.view addSubview:socialButton2];
    
    
    UIButton *socialButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    socialButton3.frame = CGRectMake(14, 340, 145, 42);
    [socialButton3 setImage:[UIImage imageNamed:@"btn_sns_li"] forState:UIControlStateNormal];
    [socialButton3 addTarget:self action:@selector(social:) forControlEvents:UIControlEventTouchUpInside];
    //[socialButton setTitle:@"ショップURL" forState:UIControlStateNormal];
    [socialButton3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    socialButton3.tag = 3;
    [self.view addSubview:socialButton3];
    
    UIButton *socialButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    socialButton4.frame = CGRectMake(161, 340, 145, 42);
    [socialButton4 setImage:[UIImage imageNamed:@"btn_sns_ma"] forState:UIControlStateNormal];
    [socialButton4 addTarget:self action:@selector(social:) forControlEvents:UIControlEventTouchUpInside];
    //[socialButton setTitle:@"ショップURL" forState:UIControlStateNormal];
    [socialButton4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    socialButton4.tag = 4;
    [self.view addSubview:socialButton4];

    
    NSString *sessionId = [BSUserManager sharedManager].sessionId;
    NSString *urlString = [NSString stringWithFormat:@"%@/users/get_shop?session_id=%@",apiUrl,sessionId];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:urlString];
    [[BSSellerAPIClient sharedClient] getUsersShopWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        
        NSLog(@"getUsersShopWithSessionId: %@", results);
        NSDictionary *shopInfo = [results valueForKeyPath:@"result.Shop"];
        //shopUrl.text = [shopInfo objectForKey:@"shop_url"];
        
        [urlLabel setText:shopInfo[@"shop_url"]];
        [urlLabel sizeToFit];
        if ([BSDefaultViewObject isMoreIos7]) {
            
            urlLabel.center = CGPointMake(160,urlLabel.center.y);
            copyButton.center = CGPointMake(160,urlLabel.center.y);
            copyButton.frame = CGRectMake(urlLabel.frame.origin.x + urlLabel.frame.size.width,copyButton.frame.origin.y, 30, 30);
            
        }else{
            urlLabel.center = CGPointMake(160,30);
            copyButton.center = CGPointMake(160,30);
            copyButton.frame = CGRectMake(urlLabel.frame.origin.x + urlLabel.frame.size.width,copyButton.frame.origin.y, 30, 30);
            
        }
        
        
        shopName = @"";
        shopName = shopInfo[@"shop_name"];
        NSLog(@"ショップ名%@",shopName);
        [UIView animateWithDuration:0.6f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             
                         }
         
                         completion:^(BOOL finished){
                             
                         }];
    }];
    
    
    
    [[BSSellerAPIClient sharedClient] getDesignLogoWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSURLSessionDataTask *task,NSError *error) {
       
        NSLog(@"注文詳細！: %@", results);


        NSString *logoUrl = [results valueForKeyPath:@"logo_url"];
        NSDictionary *rootUser = [results valueForKeyPath:@"user"];
        NSDictionary *user = [rootUser valueForKeyPath:@"User"];
        NSString *logoImageUrl = [user valueForKeyPath:@"logo"];
        
        if ([logoImageUrl isEqual:[NSNull null]] || [logoImageUrl isEqualToString:@""]) {
            shareImage = nil;
        }
        
        NSString *url1 = [NSString stringWithFormat:@"%@%@",logoUrl,logoImageUrl];
        NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];

        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            shareImage = responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
        
    }];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        for (UIView *view in [self.view subviews]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 64, view.frame.size.width, view.frame.size.height);
        }
    }
    
}



- (void)webView:(id)sender
{
    
    if ([sender tag] == 1) {
        viewMode = @"mobile";
    }else{
        viewMode = @"pc";
    }
    UIViewController *uv = [self.storyboard instantiateViewControllerWithIdentifier:@"shopWeb"];
    [self.navigationController pushViewController:uv animated:YES];
}
- (void)copyUrl:(id)sender
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setValue:urlLabel.text forPasteboardType:@"public.utf8-plain-text"];
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"URLをコピーしました" message:@""
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}
- (void)social:(id)sender
{
    if ([sender tag] == 1) {
        [self sendFacebook:shareImage title:[NSString stringWithFormat:@"%@",shopName] url:urlLabel.text];
    }else if ([sender tag] == 2){
        [self sendTwitter];
    }else if ([sender tag] == 3){
        [self postToLine];
    }else if ([sender tag] == 4){
        [self mailsousin];
    }
}


-(void)mailsousin{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //メールタイトル設定
    [picker setSubject:[NSString stringWithFormat:@"%@を開設しました",shopName]];
    // 添付ファイルをつけたい場合(画像の場合)
    //メールの本文を設定
    NSString *emailBody = [NSString stringWithFormat:@"ネットショップを開設しました。 %@",urlLabel.text];
    [picker setMessageBody:emailBody isHTML:NO];
    NSData *data  = [[NSData alloc] initWithData:UIImagePNGRepresentation(shareImage)];
    [picker addAttachmentData:data mimeType:@"image/jpg" fileName:@"image"];
    [self presentViewController:picker animated:YES completion: ^{
        
        NSLog(@"完了");}];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result){
        case MFMailComposeResultCancelled:
            //キャンセルした場合
            break;
        case MFMailComposeResultSaved:
            //保存した場合
            [SVProgressHUD showSuccessWithStatus:@"メールを保存しました"];
            break;
        case MFMailComposeResultSent:
            //送信した場合
            [SVProgressHUD showSuccessWithStatus:@"メール送信完了"];
            break;
        case MFMailComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"メール送信出来ませんでした..."];
            break;
        default:
            [SVProgressHUD dismiss];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (UIImage *)imageFromView:(UIView *)view{
    // 必要なUIImageサイズ分のコンテキスト確保
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画像化する部分の位置を調整
    CGContextTranslateCTM(context, -view.frame.origin.x, -view.frame.origin.y);
    
    // 画像出力
    [view.layer renderInContext:context];
    
    // uiimage化
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // コンテキスト破棄
    UIGraphicsEndImageContext();
    
    return renderedImage;
}

- (void)postToLine {
    /*
     // この例ではUIImageクラスの_resultImageを送る
     UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
     [pasteboard setData:UIImagePNGRepresentation(shareImage) forPasteboardType:@"public.png"];
     */
    
    // pasteboardを使ってパスを生成
    NSString *content = [NSString stringWithFormat:@"%@",shopName];
    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/text/%@%@",content,urlLabel.text];
    
    // URLスキームを使ってLINEを起動
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LineUrlString]];
}

- (void)sendTwitter{
    NSString* postContent = [NSString stringWithFormat:@"%@ %@ \n#BASEec",shopName,urlLabel.text];
    NSURL* appURL = [NSURL URLWithString:@"https://thebase.in/"];
    // =========== iOSバージョンで、処理を分岐 ============
    // iOS Version
    NSString *iosVersion = [[[UIDevice currentDevice] systemVersion] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Social.frameworkを使う
    if ([iosVersion floatValue] >= 6.0) {
        SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterPostVC setInitialText:postContent];
        [twitterPostVC addURL:appURL]; // アプリURL
        [self presentViewController:twitterPostVC animated:YES completion:nil];
    }
    // Twitter.frameworkを使う
    else if ([iosVersion floatValue] >= 5.0) {
        // Twitter画面を保持するViewControllerを作成する。
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
        // 初期表示する文字列を指定する。
        [twitter setInitialText:postContent];
        // TweetにURLを追加することが出来ます。
        [twitter addURL:appURL];
        // Tweet後のコールバック処理を記述します。
        // ブロックでの記載となり、引数にTweet結果が渡されます。
        twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
            if (res == TWTweetComposeViewControllerResultDone)
                NSLog(@"tweet done.");
            else if (res == TWTweetComposeViewControllerResultCancelled)
                NSLog(@"tweet canceled.");
        };
        // Tweet画面を表示します。
        [self presentViewController:twitter animated:YES completion: ^{
            
            NSLog(@"完了");}];
    }
}


- (NSString *)encode:(NSString *)string
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}


- (void)sendFacebook:(UIImage *)image title:(NSString *)title url:(NSString *)urlString
{
    if(NSClassFromString(@"SLComposeViewController")) {
        
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController setInitialText:[NSString stringWithFormat:@"%@ %@", title, urlString]];
        [composeViewController addImage:image];
        [self.navigationController presentViewController:composeViewController
                                                animated:YES
                                              completion:nil];
    } else {
        // iOS 5 以下はブラウザに移動してシェア機能を起動する
        NSString *escapedMessage = [self encode:title];
        NSString *escapedUrlString = [self encode:urlString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@&t=%@", escapedUrlString, escapedMessage]]];
        
    }
}

+(NSString*)getViewMode{
    return viewMode;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
