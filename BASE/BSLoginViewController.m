//
//  BSLoginViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSLoginViewController.h"



@interface BSLoginViewController ()


@end

@implementation BSLoginViewController{
    UITextField *email;
    UITextField *password;

    UIScrollView *scrollView;
    
    CGPoint svos;
    
    int testHeight;
    int testLineHeight;
    int testLabelHeight;
    int testLabelHeight2;
    
    UITableView *signInTable;
    
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
    
    //背景
    UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    //配置を変更
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        //iphone5
        testHeight = 0;
        NSLog(@"iPhone５起動しているよ！");
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        
    }
    else
    {
        testHeight =  -40;
        testLineHeight  = 10;
        testLabelHeight = 20;
        testLabelHeight2 = 15;
        scrollView.scrollsToTop = YES;
        scrollView.delegate = self;
        scrollView.bounces = NO;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:scrollView];
    
    
    signInTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 299, 240) style:UITableViewStyleGrouped];
    signInTable.center =  CGPointMake(160, 320);
    signInTable.dataSource = self;
    signInTable.delegate = self;
    signInTable.backgroundView = nil;
    signInTable.backgroundColor = [UIColor clearColor];
    
    
    
    int height = 10;    
    
    //barImage
    UIImageView* barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
    barImage.image = [UIImage imageNamed:@"bar_login"];
    //[self.view addSubview:barImage];
    
    //logoimage
    UIImageView* logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_login_test.png"]];
    logoImage.frame = CGRectMake(18.5, 100 + height, 110, 46);
    //[self.view addSubview:logoImage];
    
    //「wellcome」ラベル
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,150 + height,200,50)];
    welcomeLabel.text = @"Welcome to BASE";
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    welcomeLabel.shadowColor = [UIColor whiteColor];
    welcomeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    //[self.view addSubview:welcomeLabel];
    
    //「ログイン」ボタン
    UIImage *loginImage = [UIImage imageNamed:@"btn_03.png"];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, 288, 55);
    [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    //[loginButton setBackgroundImage:loginImage forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(btnLoginOnClicked:)forControlEvents:UIControlEventTouchUpInside];
    loginButton.center = CGPointMake(160, 325 + height );
    //[self.view addSubview:loginButton];
    
    //「ログイン」ラベル
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,50)];
    loginLabel.text = @"ログイン";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.center = CGPointMake(160, 325 + height);
    loginLabel.font = [UIFont boldSystemFontOfSize:18];
    loginLabel.shadowColor = [UIColor whiteColor];
    loginLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    //[self.view addSubview:loginLabel];
    
    
    
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
    
            // iPhone5
            [scrollView addSubview:signInTable];
            
            [scrollView addSubview:barImage];
            
            [scrollView addSubview:logoImage];
            
            [scrollView addSubview:welcomeLabel];
            
            [scrollView addSubview:loginButton];
            
            [scrollView addSubview:loginLabel];
            
            [scrollView addSubview:line1];
            
            [scrollView addSubview:line2];
            
            [scrollView addSubview:signUpButton];
            
            [scrollView addSubview:singUpLabel];
            
            [scrollView addSubview:signUpLabel1];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    NSLog(@"キーチェイン情報:%@",store);
    NSLog(@"キーチェイン情報:%@",[store stringForKey:@"email"]);
    if ([store stringForKey:@"email"]) {
        [signInTable reloadData];
    }
    
    
    
    
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
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    email = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                    email.returnKeyType = UIReturnKeyNext;
                    email.keyboardType = UIKeyboardTypeEmailAddress;
                    email.placeholder = @"メールアドレス";
                    email.font = [UIFont systemFontOfSize:17];
                    email.tag = 1;
                    email.delegate = self;
                    email.text = [store stringForKey:@"email"];
                    [cell addSubview:email];
                    if ([email resignFirstResponder]) {
                        [email becomeFirstResponder];
                    }
                } else if (indexPath.row == 1) {
                    password = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 12.0, 260.0, 50.0)];
                    password.font = [UIFont systemFontOfSize:17];
                    password.returnKeyType = UIReturnKeyGo;
                    password.placeholder = @"パスワード";
                    password.secureTextEntry = YES;
                    password.tag = 2;
                    password.delegate = self;
                    password.text = [store stringForKey:@"password"];
                    [cell addSubview:password];
                    
                }
                break;
                
        }
    }
    return cell;
}


//テキストフィールドにフォーカスした時スクロールする
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [email bounds];
    rc = [email convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];
}


//エンターを押した時のアクション
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CGPoint offset;
    offset.x = 0.0f;
    offset.y = 0.0f;
    [scrollView setContentOffset:offset animated:YES];
    [textField resignFirstResponder];
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    NSLog(@"%@",nextResponder);
    if (nextTag == 2) {
        [password becomeFirstResponder];
    }else{
    }
    return YES;
}

- (void)btnLoginOnClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"ロード中です" maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = NULL;
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@&=",self.email.text,self.password.text];
    url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=%@&password=%@",email.text,password.text];
    
    
    
    /*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"loginRequest:%@",request);
    
    [NSURLConnection connectionWithRequest:request delegate:self ];
     */
    
    //url = [NSString stringWithFormat:@"http://api.base0.info/users/sign_in?mail_address=gittaku@ezweb.ne.jp&password=basebase&="];
    NSURL *url1 = [NSURL URLWithString:url];
    NSURL *cookieUrl = [NSURL URLWithString:@"http://api.base0.info/users/sign_in"];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:cookieUrl];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url1];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@""
                                                      parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
            
            
            [self dismissViewControllerAnimated:NO completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
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



+ (NSString*)sessions {
    NSLog(@"セッション%@",myStaticPassword);
    return myStaticPassword;
}
+ (NSString*)importShopId {
    return myShopId;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    email.text = NULL;
    password.text = NULL;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
