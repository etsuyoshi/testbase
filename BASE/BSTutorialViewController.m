//
//  BSTutorialViewController.m
//  BASE
//
//  Created by Takkun on 2013/05/25.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSTutorialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BSDefaultViewObject.h"
#import "AFNetworking.h"
#import "BSMainPagingScrollView.h"
#import "SVProgressHUD.h"
#import "UICKeyChainStore.h"
#import "AppDelegate.h"



@interface BSTutorialViewController ()

@end

@implementation BSTutorialViewController{
    UIPageControl *pc;
    
    
    
    UITextField *email;
    UITextField *password;
    
    
    UITextField *signUpShopName;
    UITextField *signUpemail;
    UITextField *signUpPassword;
        
    CGPoint svos;
    
    int testHeight;
    int testLineHeight;
    int testLabelHeight;
    int testLabelHeight2;
    
    UIScrollView *pagingScrollView;
    
    UIView *loginView;
    UIView *signUpView;
    
    UITableView *signInTable;
    
    UITableView *shopNameTable;
    UITableView *signUpTable;
    
    
    UITextField *forgetEmail;
    
    NSString *apiUrl;
    
}

static NSString* myStaticPassword = nil;
static NSString* myShopId = nil;

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
    //グーグルアナリティクス
    self.trackedViewName = @"tutorial";
 
    /*
    //バッググラウンド
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
     */
    self.view.backgroundColor = [UIColor colorWithRed:92.0/255.0 green:92.0/255.0 blue:90.0/255.0 alpha:1.0];
    
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    
     
    pagingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320.0f,self.view.frame.size.height)];
    pagingScrollView.contentSize = CGSizeMake(320.0f * 5 , [[UIScreen mainScreen] bounds].size.height - 20);
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.bounces = YES;
    pagingScrollView.alwaysBounceHorizontal = YES;
    pagingScrollView.alwaysBounceVertical = NO;
    pagingScrollView.backgroundColor = [UIColor clearColor];
    pagingScrollView.delegate = self;
    pagingScrollView.scrollsToTop = NO;
    pagingScrollView.tag = 1;
    pagingScrollView.scrollEnabled = YES;
    [self.view addSubview:pagingScrollView];
    
    
    //ログイン画面実装
    loginView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 54, 300, 460)];
    //loginView.backgroundColor = [UIColor yellowColor];
    loginView.layer.cornerRadius = 7;
    loginView.layer.masksToBounds = YES;
    loginView.userInteractionEnabled = YES;
    loginView.hidden = YES;
    //[menuButtonView addSubview:menuButton];
    
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [loginView addSubview:backgroundImageView];
    [loginView sendSubviewToBack:backgroundImageView];
    
    

    
    
    
    
    signInTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 299, 240) style:UITableViewStyleGrouped];
    signInTable.center =  CGPointMake(150, 340);
    signInTable.dataSource = self;
    signInTable.delegate = self;
    signInTable.backgroundView = nil;
    signInTable.backgroundColor = [UIColor clearColor];
    
    
    
    int height = 10;
    
    //barImage
    NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"bar_login" ofType:@"png"];
    UIImageView* barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
    barImage.image = [UIImage imageWithContentsOfFile:aImagePath];
    //[self.view addSubview:barImage];
    
    //logoimage
    aImagePath = [[NSBundle mainBundle] pathForResource:@"logo_login_test" ofType:@"png"];
    UIImageView* logoImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:aImagePath]];
    logoImage.frame = CGRectMake(13.5, 100 + height, 110, 46);
    //[self.view addSubview:logoImage];
    
    //「wellcome」ラベル
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,170 + height,200,50)];
    welcomeLabel.text = @"Welcome to BASE";
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        welcomeLabel.shadowColor = [UIColor whiteColor];
        welcomeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    //[self.view addSubview:welcomeLabel];
    
    //「ログイン」ボタン
    UIImage *loginImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        //NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"btn_7_03" ofType:@"png"];
        //aImageView.image = [UIImage imageWithContentsOfFile:aImagePath];
        loginImage = [UIImage imageNamed:@"btn_7_03"];
    }else{
        NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"btn_03" ofType:@"png"];
        loginImage = [UIImage imageWithContentsOfFile:aImagePath];
    }
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, 288, 55);
    [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(login:)forControlEvents:UIControlEventTouchUpInside];
    loginButton.center = CGPointMake(150, 360 + height );
    //[self.view addSubview:loginButton];
    
    //「ログイン」ラベル
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    loginLabel.text = @"ログイン";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.center = CGPointMake(150, 360 + height);
    loginLabel.font = [UIFont boldSystemFontOfSize:18];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        loginLabel.shadowColor = [UIColor whiteColor];
        loginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    //[self.view addSubview:loginLabel];
    

    
    
    //パスワードを忘れた場合ラベル
    UILabel *forgetPassword = [[UILabel alloc] initWithFrame:CGRectMake(130,400,200,30)];
    forgetPassword.text = @"パスワードを忘れた場合";
    forgetPassword.textAlignment = NSTextAlignmentLeft;
    forgetPassword.font = [UIFont boldSystemFontOfSize:14];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        forgetPassword.shadowColor = [UIColor whiteColor];
        forgetPassword.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    forgetPassword.backgroundColor = [UIColor clearColor];
    forgetPassword.alpha = 0.6;
    forgetPassword.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    //[forgetPassword setAttributedText:attrStr];
    [loginView addSubview:forgetPassword];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,24,154,1)];
    line1.backgroundColor = [UIColor darkGrayColor];
    [forgetPassword addSubview:line1];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(130,400,160,30);
    forgetButton.backgroundColor = [UIColor clearColor];
    forgetButton.alpha = 0.6;
    [forgetButton addTarget:self action:@selector(forgetPassword:)forControlEvents:UIControlEventTouchUpInside];
    
    
    /*
    //横線
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,380 + height + testHeight + testLineHeight,320,1)];
    line1.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    //[self.view addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,381 + height + testHeight + testLineHeight,320,1)];
    line2.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:line2];
    
    
    
    //「signUp」ラベル
    UILabel *signUpLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20,400 + height + testHeight - testLabelHeight2,250,50)];
    signUpLabel1.text = @"無料で新規登録する方はこちら";
    signUpLabel1.textAlignment = NSTextAlignmentLeft;
    signUpLabel1.font = [UIFont boldSystemFontOfSize:16];
    signUpLabel1.shadowColor = [UIColor whiteColor];
    signUpLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
    signUpLabel1.backgroundColor = [UIColor clearColor];
    signUpLabel1.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    
    
    //「新規登録」ボタン
    
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame = CGRectMake(0, 0, 288, 55);
    [signUpButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    [signUpButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
    [signUpButton addTarget:self action:@selector(btnLoginOnClicked:)forControlEvents:UIControlEventTouchUpInside];
    signUpButton.center = CGPointMake(160, 480 + height - 5 + testHeight - testLabelHeight);
    //[self.view addSubview:signUpButton];
    
    //「新規登録」ラベル
    UILabel *singUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    singUpLabel.text = @"新規登録";
    singUpLabel.textAlignment = NSTextAlignmentCenter;
    singUpLabel.center = CGPointMake(160, 480 + height - 5 + testHeight - testLabelHeight);
    singUpLabel.font = [UIFont boldSystemFontOfSize:18];
    singUpLabel.shadowColor = [UIColor whiteColor];
    singUpLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    singUpLabel.backgroundColor = [UIColor clearColor];
    singUpLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    //[self.view addSubview:singUpLabel];
    
    //[self.view addSubview:signUpLabel1];
    */
     
    // iPhone5
    [loginView addSubview:signInTable];
    
    [loginView addSubview:barImage];
    
    [loginView addSubview:logoImage];
    
    [loginView addSubview:welcomeLabel];
    
    [loginView addSubview:loginButton];
    
    [loginView addSubview:loginLabel];
    
    [loginView addSubview:forgetButton];

    /*
    [loginView addSubview:line1];
    
    [loginView addSubview:line2];
    
    [loginView addSubview:signUpButton];
    
    [loginView addSubview:singUpLabel];
    [loginView addSubview:signUpLabel1];
    */
    //
    
    
    
    
    //新規登録
    signUpView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 54, 310, 460)];
    //loginView.backgroundColor = [UIColor yellowColor];
    signUpView.layer.cornerRadius = 7;
    signUpView.layer.masksToBounds = YES;
    signUpView.userInteractionEnabled = YES;
    signUpView.hidden =YES;
    //[menuButtonView addSubview:menuButton];
    
    UIImageView *backgroundImageView2 = [BSDefaultViewObject setBackground];
    [signUpView addSubview:backgroundImageView2];
    [signUpView sendSubviewToBack:backgroundImageView2];
    
    
    shopNameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 210, 60) style:UITableViewStyleGrouped];
    shopNameTable.center =  CGPointMake(105, 205);
    if ([BSDefaultViewObject isMoreIos7]) {
        shopNameTable.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
    }
    shopNameTable.dataSource = self;
    shopNameTable.delegate = self;
    shopNameTable.backgroundView = nil;
    shopNameTable.backgroundColor = [UIColor clearColor];
    
    UILabel *urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(205,196,200,50)];
    urlLabel.text = @".thebase.in";
    urlLabel.textAlignment = NSTextAlignmentLeft;
    urlLabel.font = [UIFont boldSystemFontOfSize:16];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        urlLabel.shadowColor = [UIColor whiteColor];
        urlLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    [signUpView addSubview:urlLabel];
    
    
    signUpTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 240) style:UITableViewStyleGrouped];
    signUpTable.center =  CGPointMake(150, 350);
    signUpTable.dataSource = self;
    signUpTable.delegate = self;
    signUpTable.backgroundView = nil;
    signUpTable.backgroundColor = [UIColor clearColor];
    
    
    
    //barImage
    aImagePath = [[NSBundle mainBundle] pathForResource:@"bar_login" ofType:@"png"];
    UIImageView* barImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
    barImage2.image = [UIImage imageWithContentsOfFile:aImagePath];
    //[self.view addSubview:barImage];
    
    //logoimage
    aImagePath = [[NSBundle mainBundle] pathForResource:@"logo_login_test" ofType:@"png"];
    //aImageView.image = [UIImage imageWithContentsOfFile:aImagePath];
    UIImageView* logoImage2 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:aImagePath]];
    logoImage2.frame = CGRectMake(13.5, 100 + height, 110, 46);
    
    
    //「wellcome」ラベル
    UILabel *welcomeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10,160 + height,200,50)];
    welcomeLabel2.text = @"Welcome to BASE";
    welcomeLabel2.textAlignment = NSTextAlignmentLeft;
    welcomeLabel2.font = [UIFont boldSystemFontOfSize:18];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        welcomeLabel2.shadowColor = [UIColor whiteColor];
        welcomeLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    welcomeLabel2.backgroundColor = [UIColor clearColor];
    welcomeLabel2.hidden = YES;
    welcomeLabel2.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    //[self.view addSubview:welcomeLabel];
    
    //「新規登録」ボタン
    UIImage *signUpImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        signUpImage = [UIImage imageNamed:@"btn_7_03.png"];
    }else{
        signUpImage = [UIImage imageNamed:@"btn_03.png"];
    }
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame = CGRectMake(0, 0, 288, 55);
    [signUpButton setBackgroundImage:signUpImage forState:UIControlStateNormal];
    //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
    [signUpButton addTarget:self action:@selector(signUp:)forControlEvents:UIControlEventTouchUpInside];
    signUpButton.center = CGPointMake(150, 370 + height );
    //[self.view addSubview:loginButton];
    
    //「新規登録」ラベル
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,50)];
    signUpLabel.text = @"利用規約に同意して新規登録する";
    signUpLabel.textAlignment = NSTextAlignmentCenter;
    signUpLabel.center = CGPointMake(150, 370 + height);
    signUpLabel.font = [UIFont boldSystemFontOfSize:16];
    if ([BSDefaultViewObject isMoreIos7]) {
    }else{
        signUpLabel.shadowColor = [UIColor whiteColor];
        signUpLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    }
    
    signUpLabel.backgroundColor = [UIColor clearColor];
    signUpLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    //[self.view addSubview:loginLabel];
    
    
    
    
    //利用規約ラベル
    UILabel *checkPolicyLabel = [[UILabel alloc] initWithFrame:CGRectMake(240,404,60,30)];
    checkPolicyLabel.text = @"利用規約";
    checkPolicyLabel.textAlignment = NSTextAlignmentLeft;
    checkPolicyLabel.font = [UIFont boldSystemFontOfSize:12];
    checkPolicyLabel.shadowColor = [UIColor whiteColor];
    checkPolicyLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    checkPolicyLabel.backgroundColor = [UIColor clearColor];
    checkPolicyLabel.alpha = 0.6;
    checkPolicyLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    //[forgetPassword setAttributedText:attrStr];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0,24,48,1)];
    underLine.backgroundColor = [UIColor darkGrayColor];
    [checkPolicyLabel addSubview:underLine];
    
    UIButton *checkPolicyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkPolicyButton.frame = CGRectMake(240,404,100,30);
    checkPolicyButton.backgroundColor = [UIColor clearColor];
    //checkPolicyButton.alpha = 0.6;
    [checkPolicyButton addTarget:self action:@selector(checkView:)forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    /*
     //横線
     UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,380 + height + testHeight + testLineHeight,320,1)];
     line1.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
     //[self.view addSubview:line1];
     UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,381 + height + testHeight + testLineHeight,320,1)];
     line2.backgroundColor = [UIColor whiteColor];
     //[self.view addSubview:line2];
     
     
     
     //「signUp」ラベル
     UILabel *signUpLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20,400 + height + testHeight - testLabelHeight2,250,50)];
     signUpLabel1.text = @"無料で新規登録する方はこちら";
     signUpLabel1.textAlignment = NSTextAlignmentLeft;
     signUpLabel1.font = [UIFont boldSystemFontOfSize:16];
     signUpLabel1.shadowColor = [UIColor whiteColor];
     signUpLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
     signUpLabel1.backgroundColor = [UIColor clearColor];
     signUpLabel1.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
     
     
     //「新規登録」ボタン
     
     UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
     signUpButton.frame = CGRectMake(0, 0, 288, 55);
     [signUpButton setBackgroundImage:loginImage forState:UIControlStateNormal];
     [signUpButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
     [signUpButton addTarget:self action:@selector(btnLoginOnClicked:)forControlEvents:UIControlEventTouchUpInside];
     signUpButton.center = CGPointMake(160, 480 + height - 5 + testHeight - testLabelHeight);
     //[self.view addSubview:signUpButton];
     
     //「新規登録」ラベル
     UILabel *singUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
     singUpLabel.text = @"新規登録";
     singUpLabel.textAlignment = NSTextAlignmentCenter;
     singUpLabel.center = CGPointMake(160, 480 + height - 5 + testHeight - testLabelHeight);
     singUpLabel.font = [UIFont boldSystemFontOfSize:18];
     singUpLabel.shadowColor = [UIColor whiteColor];
     singUpLabel.shadowOffset = CGSizeMake(0.f, 1.f);
     singUpLabel.backgroundColor = [UIColor clearColor];
     singUpLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
     //[self.view addSubview:singUpLabel];
     
     //[self.view addSubview:signUpLabel1];
     */
    
    // iPhone5
    [signUpView addSubview:shopNameTable];
    
    [signUpView addSubview:signUpTable];
    
    [signUpView addSubview:barImage2];
    
    [signUpView addSubview:logoImage2];
    
    [signUpView addSubview:welcomeLabel2];
    
    [signUpView addSubview:signUpButton];
    
    [signUpView addSubview:signUpLabel];
    
    [signUpView addSubview:checkPolicyLabel];
    
    [signUpView addSubview:checkPolicyButton];
    
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        for (int n = 0; n < 6; n++) {
            NSString *imageName = [NSString stringWithFormat:@"walkthroughs%d-568h@2x.png",n+1];

            
            if (n == 5) {
                loginView.frame = CGRectMake(n * 320 + 10, 10,300.0f,self.view.frame.size.height - 20);
                [pagingScrollView addSubview:loginView];
    
                signUpView.frame = CGRectMake(n * 320 + 10, 10,300.0f,self.view.frame.size.height - 20);
                [pagingScrollView addSubview:signUpView];
                continue;
            }
            UIImage * backgroundImage = [UIImage imageNamed:imageName];
            /*
            CGSize newBackgroundSize;
            newBackgroundSize = CGSizeMake(320, 548);
            UIGraphicsBeginImageContext(newBackgroundSize);
            [backgroundImage drawInRect:CGRectMake(0, 0, newBackgroundSize.width, newBackgroundSize.height)];
            backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
             */
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
            backgroundImageView.frame = CGRectMake(n * 320,0,320.0f,self.view.frame.size.height);
            backgroundImageView.userInteractionEnabled = YES;
            [pagingScrollView addSubview:backgroundImageView];
            
            
            if (n == 4) {
                
                
                //「新規登録」ボタン
                UIImage *moveSignUpImage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveSignUpImage = [UIImage imageNamed:@"btn_7_03.png"];
                }else{
                    moveSignUpImage = [UIImage imageNamed:@"btn_03.png"];
                }
                UIButton *moveSignUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moveSignUpButton.frame = CGRectMake(0, 0, 288, 55);
                [moveSignUpButton setBackgroundImage:moveSignUpImage forState:UIControlStateNormal];
                //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                [moveSignUpButton addTarget:self action:@selector(moveSignUpView:)forControlEvents:UIControlEventTouchUpInside];
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveSignUpImage = [UIImage imageNamed:@"btn_7_03.png"];
                    moveSignUpButton.center = CGPointMake(160, 445);

                }else{
                    moveSignUpImage = [UIImage imageNamed:@"btn_03.png"];
                    moveSignUpButton.center = CGPointMake(160, 435);

                }
                [backgroundImageView addSubview:moveSignUpButton];
                //[self.view addSubview:loginButton];
                
                //「新規登録」ラベル
                UILabel *moveSignUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,30)];
                moveSignUpLabel.text = @"新規に開店する";
                moveSignUpLabel.textAlignment = NSTextAlignmentCenter;
                moveSignUpLabel.font = [UIFont boldSystemFontOfSize:20];
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveSignUpLabel.center = CGPointMake(144, 27.5);

                }else{
                    
                    moveSignUpLabel.shadowColor = [UIColor whiteColor];
                    moveSignUpLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                }
                
                moveSignUpLabel.backgroundColor = [UIColor clearColor];
                moveSignUpLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:164.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
                [moveSignUpButton addSubview:moveSignUpLabel];
                
                
                
                
                //「新規登録」ボタン
                UIImage *moveLoginImage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveLoginImage = [UIImage imageNamed:@"btn_7_03.png"];
                }else{
                    moveLoginImage = [UIImage imageNamed:@"btn_03.png"];
                }
                UIButton *moveLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moveLoginButton.frame = CGRectMake(0, 0, 288, 55);
                [moveLoginButton setBackgroundImage:moveLoginImage forState:UIControlStateNormal];
                //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                [moveLoginButton addTarget:self action:@selector(moveLoginView:)forControlEvents:UIControlEventTouchUpInside];
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveLoginButton.center = CGPointMake(160, 500);
                    
                }else{
                    moveLoginButton.center = CGPointMake(160, 490);
                    
                }
                [backgroundImageView addSubview:moveLoginButton];
                //[self.view addSubview:loginButton];
                
                //「新規登録」ラベル
                UILabel *moveLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,30)];
                moveLoginLabel.text = @"ログイン";
                moveLoginLabel.textAlignment = NSTextAlignmentCenter;
                moveLoginLabel.center = CGPointMake(144, 27.5);
                moveLoginLabel.font = [UIFont boldSystemFontOfSize:20];
                if ([BSDefaultViewObject isMoreIos7]) {
                }else{
                    moveLoginLabel.shadowColor = [UIColor whiteColor];
                    moveLoginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                }
                
                moveLoginLabel.backgroundColor = [UIColor clearColor];
                moveLoginLabel.textColor = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
                [moveLoginButton addSubview:moveLoginLabel];
                
                
    

            }
           
            
        }

    }
    else
    {
        for (int n = 0; n < 6; n++) {
            aImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"walkthroughs%d@2x",n+1] ofType:@"png"];
            //aImageView.image = [UIImage imageWithContentsOfFile:aImagePath];
            //NSString *imageName = [NSString stringWithFormat:@"walkthroughs%d@2x.png",n+1];
            
            
            if (n == 5) {
                loginView.frame = CGRectMake(n * 320 + 10, 10,300.0f,self.view.frame.size.height - 20);
                [pagingScrollView addSubview:loginView];
                
                signUpView.frame = CGRectMake(n * 320 + 10, 10,300.0f,self.view.frame.size.height - 20);
                [pagingScrollView addSubview:signUpView];
                continue;
            }
            UIImage * backgroundImage = [UIImage imageWithContentsOfFile:aImagePath];
            /*
             CGSize newBackgroundSize;
             newBackgroundSize = CGSizeMake(320, 548);
             UIGraphicsBeginImageContext(newBackgroundSize);
             [backgroundImage drawInRect:CGRectMake(0, 0, newBackgroundSize.width, newBackgroundSize.height)];
             backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             */
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
            backgroundImageView.frame = CGRectMake(n * 320,0,320.0f,self.view.frame.size.height);
            backgroundImageView.userInteractionEnabled = YES;
            [pagingScrollView addSubview:backgroundImageView];
            
            
            if (n == 4) {
                
                
                //「新規登録」ボタン
                UIImage *moveSignUpImage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveSignUpImage = [UIImage imageNamed:@"btn_7_03.png"];
                }else{
                    moveSignUpImage = [UIImage imageNamed:@"btn_03.png"];
                }
                UIButton *moveSignUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moveSignUpButton.frame = CGRectMake(0, 0, 288, 55);
                [moveSignUpButton setBackgroundImage:moveSignUpImage forState:UIControlStateNormal];
                //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                [moveSignUpButton addTarget:self action:@selector(moveSignUpView:)forControlEvents:UIControlEventTouchUpInside];
                moveSignUpButton.center = CGPointMake(160, 355);
                [backgroundImageView addSubview:moveSignUpButton];
                //[self.view addSubview:loginButton];
                
                //「新規登録」ラベル
                UILabel *moveSignUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,30)];
                moveSignUpLabel.text = @"新規に開店する";
                moveSignUpLabel.textAlignment = NSTextAlignmentCenter;
                moveSignUpLabel.center = CGPointMake(144, 27.5);
                moveSignUpLabel.font = [UIFont boldSystemFontOfSize:20];
                if ([BSDefaultViewObject isMoreIos7]) {
                }else{
                    moveSignUpLabel.shadowColor = [UIColor whiteColor];
                    moveSignUpLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                }
                
                moveSignUpLabel.backgroundColor = [UIColor clearColor];
                moveSignUpLabel.textColor = [UIColor colorWithRed:2.0f/255.0f green:164.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
                [moveSignUpButton addSubview:moveSignUpLabel];
                
                
                
                
                //「新規登録」ボタン
                UIImage *moveLoginImage;
                if ([BSDefaultViewObject isMoreIos7]) {
                    moveLoginImage = [UIImage imageNamed:@"btn_7_03.png"];
                }else{
                    moveLoginImage = [UIImage imageNamed:@"btn_03.png"];
                }
                UIButton *moveLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                moveLoginButton.frame = CGRectMake(0, 0, 288, 55);
                [moveLoginButton setBackgroundImage:moveLoginImage forState:UIControlStateNormal];
                //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
                [moveLoginButton addTarget:self action:@selector(moveLoginView:)forControlEvents:UIControlEventTouchUpInside];
                moveLoginButton.center = CGPointMake(160, 405);
                [backgroundImageView addSubview:moveLoginButton];
                //[self.view addSubview:loginButton];
                
                //「新規登録」ラベル
                UILabel *moveLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,180,30)];
                moveLoginLabel.text = @"ログイン";
                moveLoginLabel.textAlignment = NSTextAlignmentCenter;
                moveLoginLabel.center = CGPointMake(144, 27.5);
                moveLoginLabel.font = [UIFont boldSystemFontOfSize:20];
                if ([BSDefaultViewObject isMoreIos7]) {
                }else{
                    moveLoginLabel.shadowColor = [UIColor whiteColor];
                    moveLoginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
                }
                
                moveLoginLabel.backgroundColor = [UIColor clearColor];
                moveLoginLabel.textColor = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0f];
                [moveLoginButton addSubview:moveLoginLabel];
                
                
                
                
            }
            
        }
    }
    
    pc = [[UIPageControl alloc] init];
    pc.frame = CGRectMake(100, self.view.frame.size.height - 50, 160, 30);
    pc.center = CGPointMake(160, self.view.frame.size.height - 24);
    pc.numberOfPages = 5;
    pc.currentPage = 0;
    [self.view insertSubview:pc aboveSubview:pagingScrollView];
    
    
    /*
    //dismissラベル
    UILabel *dismissLabel = [[UILabel alloc] initWithFrame:CGRectMake(276,14,30,30)];
    dismissLabel.text = @"×";
    dismissLabel.textAlignment = NSTextAlignmentLeft;
    dismissLabel.font = [UIFont boldSystemFontOfSize:40];
    dismissLabel.shadowColor = [UIColor blackColor];
    dismissLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    dismissLabel.backgroundColor = [UIColor clearColor];
    dismissLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:dismissLabel];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(274,14,30,30);
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.alpha = 0.6;
    [dismissButton addTarget:self action:@selector(dismissModal:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton]
     */
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(262,12, 50, 42)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"icon_close2.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismissModal:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = 1;
    [self.view addSubview:leftButton];
    
    
    
    //一度チュートリアルを見た場合
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    BOOL finishedTutorial = [ud boolForKey:@"tutorialed"];
    if (finishedTutorial) {
        pagingScrollView.contentSize = CGSizeMake(320.0f * 6 , [[UIScreen mainScreen] bounds].size.height - 20);
        signUpView.hidden = YES;
        loginView.hidden = NO;
        CGRect frame = pagingScrollView.frame;
        frame.origin.x = 320 * 4;
        frame.origin.y = 0;
        
        [pagingScrollView scrollRectToVisible:frame animated:YES];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    pc.currentPage = scrollView.contentOffset.x / 320;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == signUpTable) {
        return 2;
    }else if (tableView == shopNameTable){
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.scrollEnabled = NO;
        //UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
        
        if (tableView == signUpTable) {
            switch (indexPath.section) {
                case 0:
                    if (indexPath.row == 0) {
                        signUpemail = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                        if ([BSDefaultViewObject isMoreIos7]) {
                            signUpemail.center = CGPointMake(signUpemail.center.x, cell.center.y);
                        }else{
                            
                        }
                        signUpemail.returnKeyType = UIReturnKeyNext;
                        signUpemail.keyboardType = UIKeyboardTypeEmailAddress;
                        signUpemail.placeholder = @"メールアドレス";
                        signUpemail.font = [UIFont systemFontOfSize:17];
                        signUpemail.tag = 2;
                        signUpemail.delegate = self;
                        signUpemail.text = @"";
                        //email.text = [store stringForKey:@"email"];
                        [cell addSubview:signUpemail];
                        if ([signUpemail resignFirstResponder]) {
                            [signUpemail becomeFirstResponder];
                        }
                    } else if (indexPath.row == 1) {
                        signUpPassword = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                        signUpPassword.font = [UIFont systemFontOfSize:17];
                        signUpPassword.returnKeyType = UIReturnKeyGo;
                        signUpPassword.placeholder = @"パスワード";
                        if ([BSDefaultViewObject isMoreIos7]) {
                            signUpPassword.center = CGPointMake(signUpPassword.center.x, cell.center.y);
                        }else{
                            
                        }
                        signUpPassword.secureTextEntry = YES;
                        signUpPassword.tag = 3;
                        signUpPassword.delegate = self;
                        signUpPassword.text = @"";
                        //password.text = [store stringForKey:@"password"];
                        [cell addSubview:signUpPassword];
                        
                    }
                    break;
                    
            }
        }else if (tableView == shopNameTable) {
            switch (indexPath.section) {
                case 0:
                    if (indexPath.row == 0) {
                        signUpShopName = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                        signUpShopName.returnKeyType = UIReturnKeyNext;
                        signUpShopName.keyboardType = UIKeyboardTypeEmailAddress;
                        if ([BSDefaultViewObject isMoreIos7]) {
                            signUpShopName.center = CGPointMake(signUpShopName.center.x, cell.center.y);
                        }else{
                            
                        }
                        signUpShopName.placeholder = @"ショップURL(3文字以上)";
                        signUpShopName.font = [UIFont systemFontOfSize:15];
                        signUpShopName.tag = 1;
                        signUpShopName.text = @"";
                        signUpShopName.delegate = self;
                        //email.text = [store stringForKey:@"email"];
                        [cell addSubview:signUpShopName];
                        if ([signUpShopName resignFirstResponder]) {
                            [signUpShopName becomeFirstResponder];
                        }
                    } 
                    break;
                    
            }
        }else{
            switch (indexPath.section) {
                case 0:
                    if (indexPath.row == 0) {
                        email = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                        if ([BSDefaultViewObject isMoreIos7]) {
                            email.center = CGPointMake(email.center.x, cell.center.y);
                        }else{
                            
                        }
                        email.returnKeyType = UIReturnKeyNext;
                        email.keyboardType = UIKeyboardTypeEmailAddress;
                        email.placeholder = @"メールアドレス";
                        email.font = [UIFont systemFontOfSize:17];
                        email.tag = 5;
                        email.delegate = self;
                        email.text = @"";
                        [cell addSubview:email];
                        if ([email resignFirstResponder]) {
                            [email becomeFirstResponder];
                        }
                    } else if (indexPath.row == 1) {
                        password = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                        if ([BSDefaultViewObject isMoreIos7]) {
                            password.center = CGPointMake(password.center.x, cell.center.y);
                        }else{
                            
                        }
                        password.font = [UIFont systemFontOfSize:17];
                        password.returnKeyType = UIReturnKeyGo;
                        password.placeholder = @"パスワード";
                        password.secureTextEntry = YES;
                        password.tag = 6;
                        password.delegate = self;
                        password.text = @"";
                        [cell addSubview:password];
                        
                    }
                    break;
                    
            }
        }
        
    }
    return cell;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	svos = pagingScrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [email bounds];
    rc = [email convertRect:rc toView:pagingScrollView];
    pt = rc.origin;
    pt.x = pagingScrollView.contentOffset.x;
    pt.y -= 60;
    [pagingScrollView setContentOffset:pt animated:YES];
    
	return YES;
}
//テキストフィールドにフォーカスした時スクロールする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = pagingScrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [email bounds];
    rc = [email convertRect:rc toView:pagingScrollView];
    pt = rc.origin;
    pt.x = pagingScrollView.contentOffset.x;
    pt.y -= 60;
    [pagingScrollView setContentOffset:pt animated:YES];
}


//エンターを押した時のアクション
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CGPoint offset;
    offset.x = pagingScrollView.contentOffset.x;
    offset.y = 0.0f;
    [pagingScrollView setContentOffset:offset animated:YES];
    [textField resignFirstResponder];
    
    /*
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:(textField.tag + 1)];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
        return NO;

        // Your code for checking it.
    }
     */
    switch (textField.tag + 1) {
        case 2:
            [signUpemail becomeFirstResponder];
            break;
        case 3:
            [signUpPassword becomeFirstResponder];

            break;
        case 6:
            [password becomeFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}



- (void)moveLoginView:(id)sender{
    
    pagingScrollView.contentSize = CGSizeMake(320.0f * 6 , [[UIScreen mainScreen] bounds].size.height - 20);
    signUpView.hidden = YES;
    loginView.hidden = NO;
    CGRect frame = pagingScrollView.frame;
    frame.origin.x = 320 * 5;
    frame.origin.y = 0;
    
    [pagingScrollView scrollRectToVisible:frame animated:YES];
    
    
        
}


- (void)moveSignUpView:(id)sender{
    
    pagingScrollView.contentSize = CGSizeMake(320.0f * 6 , [[UIScreen mainScreen] bounds].size.height - 20);
    loginView.hidden = YES;
    signUpView.hidden = NO;
    CGRect frame = pagingScrollView.frame;
    frame.origin.x = 320 * 5;
    frame.origin.y = 0;
    
    [pagingScrollView scrollRectToVisible:frame animated:YES];
    return;
    
}


- (void)login:(id)sender{
    
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSTutorialViewController"
                                                     withAction:@"login"
                                                      withLabel:nil
                                                      withValue:@100];
    
    [SVProgressHUD showWithStatus:@"ロード中です" maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = @"";
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@&=",self.email.text,self.password.text];
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@",email.text,password.text];
    
    
    
    /*
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
     NSLog(@"loginRequest:%@",request);
     
     [NSURLConnection connectionWithRequest:request delegate:self ];
     */
    /*
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) email.text,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
     */
    url = [NSString stringWithFormat:@"%@/users/sign_in",apiUrl];
    NSURL *url1 = [NSURL URLWithString:url];
    //url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url！: %@", url1);

    NSURL *cookieUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_in",apiUrl]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieUrl];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    if (!password.text) {
    
    }
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mail_address"] = email.text;
    parameter[@"password"] = password.text;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:parameter];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ログイン情報！: %@", JSON);
        
        NSDictionary *result = JSON[@"result"];
        if (result) {
            [UICKeyChainStore setString:email.text forKey:@"email" service:@"in.thebase"];
            [UICKeyChainStore setString:password.text forKey:@"password" service:@"in.thebase"];
        }
        
        
        NSDictionary *Auth = result[@"Auth"];
        NSLog(@"%@",Auth[@"session_id"]);
        NSLog(@"%@",result);
        NSString *session = Auth[@"session_id"];
        NSString *shopId = [JSON valueForKeyPath:@"result.User.shop_id"];
        
        myShopId = shopId;
        myStaticPassword = session;
        if (!Auth[@"session_id"]){
            [SVProgressHUD showErrorWithStatus:@"パスワードかメールアドレスが正しくありません"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"ログイン完了！"];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?session_id=%@&token=%@",apiUrl,session,[AppDelegate getDeviceToken]];
            NSLog(@"おせてます%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url1 = [NSURL URLWithString:urlString];
            NSLog(@"URLあああああ%@",url1);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
            //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:@""
                                                              parameters:nil];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"ログイン情報！2: %@", JSON);
                NSString *error = [JSON valueForKeyPath:@"error.message"];
                NSLog(@"えら０００００%@",error);
                /*
                 NSArray *nameArray = [JSON valueForKeyPath:@"error.validations.Inquiry.name"];
                 if (nameArray.count) {
                 NSString *name = [nameArray objectAtIndex:0];
                 [SVProgressHUD showErrorWithStatus:name];
                 return ;
                 }
                 */
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                NSLog(@"Error: %@", error);
                
            }];
            [operation start];
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
                [ud setBool:YES forKey:@"tutorialed"];
                [ud synchronize];
            }];
            
            //[self dismissViewControllerAnimated:YES completion:NULL];
        }
        result = NULL;
        Auth = NULL;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"ログイン失敗..."];
        
        
    }];
    [operation start];
}

- (void)signUp:(id)sender{
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSTutorialViewController"
                                                     withAction:@"signUp"
                                                      withLabel:nil
                                                      withValue:@100];
    
    
    [SVProgressHUD showWithStatus:@"ロード中です" maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = @"";
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@&=",self.email.text,self.password.text];
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=

    
    /*
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) signUpemail.text,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    */
    
    url = [NSString stringWithFormat:@"%@/users/sign_up",apiUrl];
    NSURL *url1 = [NSURL URLWithString:url];
    NSURL *cookieUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_up",apiUrl]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieUrl];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mail_address"] = signUpemail.text;
    parameter[@"password"] = signUpPassword.text;
    parameter[@"shop_id"] = signUpShopName.text;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:parameter];
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ログイン情報！: %@", JSON);
        NSArray *shopIdErrorArray = [JSON valueForKeyPath:@"error.validations.User.shop_id"];
        NSArray *passwordErrorArray = [JSON valueForKeyPath:@"error.validations.User.pre_password"];
        NSArray *emailErrorArray = [JSON valueForKeyPath:@"error.validations.User.mail_address"];
        NSLog(@"配列%@数%d",shopIdErrorArray,shopIdErrorArray.count);
        if (shopIdErrorArray.count) {
            [SVProgressHUD showErrorWithStatus:shopIdErrorArray[0]];
            return ;
        }
        if (passwordErrorArray.count) {
            [SVProgressHUD showErrorWithStatus:passwordErrorArray[0]];
            return ;
        }
        if (emailErrorArray.count) {
            [SVProgressHUD showErrorWithStatus:emailErrorArray[0]];
            return ;
        }
        
        NSDictionary *result = JSON[@"result"];
        if (result) {
            [UICKeyChainStore setString:signUpemail.text forKey:@"email" service:@"in.thebase"];
            [UICKeyChainStore setString:signUpPassword.text forKey:@"password" service:@"in.thebase"];
        }
        

        NSDictionary *Auth = result[@"Auth"];
        NSLog(@"%@",Auth[@"session_id"]);
        NSLog(@"%@",result);
        NSString *session = Auth[@"session_id"];
        NSString *shopId = [JSON valueForKeyPath:@"result.User.shop_id"];
    
        
        myShopId = shopId;
        myStaticPassword = session;
        if (!Auth[@"session_id"]){
            [SVProgressHUD showErrorWithStatus:@"パスワードかメールアドレスが正しくありません"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"ショップが出来ました！"];
            
            NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?session_id=%@&token=%@",apiUrl,session,[AppDelegate getDeviceToken]];
            NSLog(@"おせてます%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url1 = [NSURL URLWithString:urlString];
            NSLog(@"URLあああああ%@",url1);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
            //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:@""
                                                              parameters:nil];            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"ログイン情報！: %@", JSON);
                
                /*
                NSArray *nameArray = [JSON valueForKeyPath:@"error.validations.Inquiry.name"];
                if (nameArray.count) {
                    NSString *name = [nameArray objectAtIndex:0];
                    [SVProgressHUD showErrorWithStatus:name];
                    return ;
                }
                 */
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                NSLog(@"Error: %@", error);
                
            }];
            [operation start];
            
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
                [ud setBool:YES forKey:@"tutorialed"];
                [ud synchronize];
            }];
            
            //[self dismissViewControllerAnimated:YES completion:NULL];
        }
        result = NULL;
        Auth = NULL;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"通信に失敗しました..."];
        
        
    }];
    [operation start];
}

- (void)forgetPassword:(id)sender{
    
    
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSTutorialViewController"
                                                     withAction:@"forgetPassword"
                                                      withLabel:nil
                                                      withValue:@100];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ご登録されているメールアドレスをご入力ください。"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"送信する", nil];
    /*
    if ([BSDefaultViewObject isMoreIos7]) {
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;

    }
    */
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    
    /*
    //Alertに乗せる入力テキストを作成
    forgetEmail = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 60.0, 245.0, 24.0)];
    forgetEmail.backgroundColor=[UIColor whiteColor];
    forgetEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [alert addSubview:forgetEmail];
     */
    //Alertを表示
    [alert show];
    //Responderをセット
    //[forgetEmail becomeFirstResponder];

}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dismissModal:(id)sender{
    

    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];    
    
    //[_baseViewController dismissViewControllerAnimated:YES completion:nil];

    
    /*
    [self dismissModalViewControllerAnimated:NO];
     BSItemAdminViewController *itemAdmin = [self.storyboard instantiateViewControllerWithIdentifier:@"itemAdmin"];
    [itemAdmin dismissModalViewControllerAnimated:YES];
    */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
    
    
    NSString *url = [NSString stringWithFormat:@"%@/users/reset_password",apiUrl];
    url =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"ゆあるえる:%@",url);
    NSURL *url1 = [NSURL URLWithString:url];
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        /*
        if ([BSDefaultViewObject isMoreIos7]) {
            parameter[@"mail_address"] = [[alertView textFieldAtIndex:0] text];

        }else{
            parameter[@"mail_address"] = forgetEmail.text;

        }
        */
        parameter[@"mail_address"] = [[alertView textFieldAtIndex:0] text];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"" parameters:parameter];
        AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"メールアドレス確認！: %@", JSON);
        NSDictionary *error = [JSON valueForKey:@"error"];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"入力が正しくありません"];
            NSString *errorMessage = [error valueForKey:@"message"];
            NSLog(@"エラーメッセージ%@",errorMessage);
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:@"確認メールを送信しました"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"通信に失敗しました..."];
        
    }];
    [operation start];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    
    [BSDefaultViewObject customNavigationBar:1];
    
}

+ (NSString*)sessions {
    NSLog(@"セッションaaaaaaa%@",myStaticPassword);
    return myStaticPassword;
}

+ (BOOL)autoLogin:(NSString*)view {
   
    [[GAI sharedInstance].defaultTracker trackEventWithCategory:@"BSTutorialViewController"
                                                     withAction:@"autoLogin"
                                                      withLabel:nil
                                                      withValue:@100];
    
    if ([view isEqualToString:@"buy"]) {
        
    }else{
        
        [SVProgressHUD showWithStatus:@"ロード中です" maskType:SVProgressHUDMaskTypeGradient];
    }
    NSString *url = @"";
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@&=",self.email.text,self.password.text];
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@",email.text,password.text];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
    NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
    NSString *email = [store stringForKey:@"email"];
    NSString *password = [store stringForKey:@"password"];
    /*
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
     NSLog(@"loginRequest:%@",request);
     
     [NSURLConnection connectionWithRequest:request delegate:self ];
     */
    /*
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) email,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
     */
    url = [NSString stringWithFormat:@"%@/users/sign_in",[BSDefaultViewObject setApiUrl]];
    NSURL *url1 = [NSURL URLWithString:url];
    NSURL *cookieUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_in",[BSDefaultViewObject setApiUrl]]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieUrl];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"mail_address"] = email;
    parameter[@"password"] = password;
    
    
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@""
                                                      parameters:parameter];
    
    
   // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.json"]];
    
    // URLからJSONデータを取得(NSData)
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // JSONで解析するために、NSDataをNSStringに変換。
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *result = JSON[@"result"];
    
    NSDictionary *Auth = result[@"Auth"];
    NSLog(@"%@",Auth[@"session_id"]);
    NSLog(@"%@",result);
    NSString *session = Auth[@"session_id"];
    NSString *shopId = [JSON valueForKeyPath:@"result.User.shop_id"];
    
    myShopId = shopId;
    myStaticPassword = session;
    if (!Auth[@"session_id"]){
        [SVProgressHUD showErrorWithStatus:@"パスワードかメールアドレスが正しくありません"];
        [store removeItemForKey:@"email"];
        [store removeItemForKey:@"password"];
        [store synchronize];
        
    }else{
        if ([view isEqualToString:@"buy"]) {
            
        }else{
            [SVProgressHUD showSuccessWithStatus:@"ログイン完了！"];
            NSString *urlString = [NSString stringWithFormat:@"%@/push_notifications/settings?session_id=%@&token=%@",[BSDefaultViewObject setApiUrl],session,[AppDelegate getDeviceToken]];
            NSLog(@"おせてます%@",urlString);
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url1 = [NSURL URLWithString:urlString];
            NSLog(@"URLあああああ%@",url1);
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
            //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                    path:@""
                                                              parameters:nil];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"ログイン情報！: %@", JSON);
                
                /*
                 NSArray *nameArray = [JSON valueForKeyPath:@"error.validations.Inquiry.name"];
                 if (nameArray.count) {
                 NSString *name = [nameArray objectAtIndex:0];
                 [SVProgressHUD showErrorWithStatus:name];
                 return ;
                 }
                 */
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                NSLog(@"Error: %@", error);
                
            }];
            [operation start];
        }
        
    }
    
    
    /*
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"ログイン情報！: %@", JSON);
        
        NSDictionary *result = [JSON objectForKey:@"result"];

        
        
        NSDictionary *Auth = [result objectForKey:@"Auth"];
        NSLog(@"%@",[Auth objectForKey:@"session_id"]);
        NSLog(@"%@",result);
        NSString *session = [Auth objectForKey:@"session_id"];
        NSString *shopId = [JSON valueForKeyPath:@"result.User.shop_id"];
        
        myShopId = shopId;
        myStaticPassword = session;
        if (![Auth objectForKey:@"session_id"]){
            [SVProgressHUD showErrorWithStatus:@"パスワードかメールアドレスが正しくありません"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"ログイン完了！"];
            
        }
        result = NULL;
        Auth = NULL;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"ログイン失敗..."];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation: operation];
    [operation start];
    [operation waitUntilFinished];
    */
     
    NSLog(@"おわた:");
    return YES;
    
    
}
- (void)checkView:(id)sender{
    NSLog(@"完了");
    UIViewController *modalView = [self.storyboard instantiateViewControllerWithIdentifier:@"transaction"];
    [self presentViewController:modalView animated:YES completion: ^{
        NSLog(@"完了");}];
}

+ (NSString*)importShopId {
    return myShopId;
}


- (void)openWebView
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
