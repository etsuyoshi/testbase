//
//  BSAccountViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSAccountViewController.h"

#import "BSMenuViewController.h"
#import "BSTutorialViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+DesignedButton.h"
#import "UICKeyChainStore.h"


@interface BSAccountViewController ()

@end

@implementation BSAccountViewController{
    UITableView *accountTable;
    
    UITextField *newEmail;
    UITextField *newPassword;
    
    NSString *apiUrl;
}

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
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.screenName = @"settingAccount";
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        self.navigationController.navigationBar.tag = 100;
        [BSDefaultViewObject setNavigationBar:self.navigationController.navigationBar];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
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
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"アカウント設定";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    
    accountTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 299, 240) style:UITableViewStyleGrouped];
    if ([BSDefaultViewObject isMoreIos7]) {
        accountTable.center =  CGPointMake(160, 170);
        accountTable.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);

        
    }else{
        accountTable.center =  CGPointMake(160, 140);

    }
    accountTable.dataSource = self;
    accountTable.delegate = self;
    accountTable.backgroundView = nil;
    accountTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:accountTable];
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //「ログイン」ボタン
        UIImage *loginImage = [UIImage imageNamed:@"btn_7_03.png"];
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, 0, 288, 55);
        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(changeAccountInfo:)forControlEvents:UIControlEventTouchUpInside];
        loginButton.center = CGPointMake(160, 200);
        [self.view addSubview:loginButton];
        
        //「ログイン」ラベル
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
        loginLabel.text = @"保存する";
        loginLabel.textAlignment = NSTextAlignmentCenter;
        loginLabel.center = loginButton.center;
        loginLabel.font = [UIFont boldSystemFontOfSize:18];
        loginLabel.backgroundColor = [UIColor clearColor];
        loginLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [self.view addSubview:loginLabel];
    }else{
        //「ログイン」ボタン
        UIImage *loginImage = [UIImage imageNamed:@"btn_03.png"];
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(0, 0, 288, 55);
        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(changeAccountInfo:)forControlEvents:UIControlEventTouchUpInside];
        loginButton.center = CGPointMake(160, 170 );
        [self.view addSubview:loginButton];
        
        //「ログイン」ラベル
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
        loginLabel.text = @"保存する";
        loginLabel.textAlignment = NSTextAlignmentCenter;
        loginLabel.center = CGPointMake(160, 170);
        loginLabel.font = [UIFont boldSystemFontOfSize:18];
        loginLabel.shadowColor = [UIColor whiteColor];
        loginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
        loginLabel.backgroundColor = [UIColor clearColor];
        loginLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
        [self.view addSubview:loginLabel];
        
    }
    
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
        NSString *email = [store stringForKey:@"email"];
        if (indexPath.row == 0) {
            newEmail = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
            if ([BSDefaultViewObject isMoreIos7]) {
                newEmail.center = CGPointMake(newEmail.center.x, cell.center.y);
            }
            newEmail.returnKeyType = UIReturnKeyDone;
            newEmail.keyboardType = UIKeyboardTypeEmailAddress;
            newEmail.placeholder = @"メールアドレス";
            newEmail.font = [UIFont systemFontOfSize:17];
            newEmail.tag = 1;
            newEmail.text = email;
            newEmail.delegate = self;
            //email.text = [store stringForKey:@"email"];
            [cell addSubview:newEmail];
            if ([newEmail resignFirstResponder]) {
                [newEmail becomeFirstResponder];
            }
        } else if (indexPath.row == 1) {
            newPassword = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
            if ([BSDefaultViewObject isMoreIos7]) {
                newPassword.center = CGPointMake(newEmail.center.x, cell.center.y);
            }
            newPassword.font = [UIFont systemFontOfSize:17];
            newPassword.returnKeyType = UIReturnKeyDone;
            newPassword.placeholder = @"パスワード(6文字以上)";
            newPassword.secureTextEntry = YES;
            newPassword.tag = 2;
            newPassword.delegate = self;
            newPassword.text = @"";
            //password.text = [store stringForKey:@"password"];
            [cell addSubview:newPassword];

        }
    }
    return cell;
}

- (void)changeAccountInfo:(id)sender{
    [SVProgressHUD showWithStatus:@"送信中..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *sessionId = [BSUserManager sharedManager].sessionId;
    NSLog(@"セッションid:%@",sessionId);
    
    /*
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) newEmail.text,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
     */
    
    NSString *urlString;
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    
    if (newPassword.text) {
        urlString = [NSString stringWithFormat:@"%@/users/edit_user",apiUrl];
        parameter[@"session_id"] = sessionId;
        parameter[@"mail_address"] = newEmail.text;
        parameter[@"password"] = newPassword.text;
    }
    
    /*
    NSLog(@"GETurl%@",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    */
    
    
    [[BSSellerAPIClient sharedClient] postUsersEditUserWithSessionId:[BSUserManager sharedManager].sessionId mailAddress:newEmail.text password:newPassword.text completion:^(NSDictionary *results, NSError *error) {
        
        
        NSLog(@"ユーザー情報変更！: %@", results);
        NSArray *mailValidationArray = [results valueForKeyPath:@"error.validations.User.mail_address"];
        if (mailValidationArray.count) {
            NSString *mailValidation = mailValidationArray[0];
            [SVProgressHUD showErrorWithStatus:mailValidation];
            return ;
        }
        NSArray *passwordValidationArray = [results valueForKeyPath:@"error.validations.User.pre_password"];
        if (passwordValidationArray.count) {
            NSString *passwordValidation = passwordValidationArray[0];
            [SVProgressHUD showErrorWithStatus:passwordValidation];
            return ;
        }
        
        [UICKeyChainStore setString:newEmail.text forKey:@"email" service:@"in.thebase"];
        if (newPassword.text) {
            [UICKeyChainStore setString:newPassword.text forKey:@"password" service:@"in.thebase"];
        }
        [SVProgressHUD showSuccessWithStatus:@"送信完了！"];
        
        
    }];
}

//エンターを押した時のアクション
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
