//
//  BSSelectThemeViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSSelectThemeViewController.h"

@interface BSSelectThemeViewController ()

@end

@implementation BSSelectThemeViewController{
    UIScrollView *scrollView;
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    apiUrl = [BSDefaultViewObject setApiUrl];
    
    NSString *session_id = [BSTutorialViewController sessions];
    NSLog(@"session_iddddddddd:%@",session_id);
    if (session_id) {
        /*
         NSString *url = [NSString stringWithFormat:@"%@design/get_theme?session_id=%@&=",apiUrl,session_id];
         NSLog(@"入っているセッションid%@",session_id);
         NSLog(@"geturl:%@",url);
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
         [NSURLConnection connectionWithRequest:request delegate:self ];
         */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *url = [NSString stringWithFormat:@"%@/design/get_theme?session_id=%@&=",apiUrl,session_id];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"getrequest%@",url);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
        //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                                   path:@""
                                                             parameters:nil];
        NSLog(@"getrequest%@",getRequest);
        //通信
        NSData *returnData = [NSURLConnection sendSynchronousRequest: getRequest returningResponse: nil error: nil];
        if (returnData) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"jsonデータ:%@",jsonObject);
            
            //jsonItemId = [jsonObject valueForKeyPath:@"result.Item.id"];
            NSDictionary *defaultView = [jsonObject valueForKeyPath:@"user.User.default_view"];
            defaultTheme = [NSString stringWithFormat:@"%@", defaultView];
            NSLog(@"jsonデータのその2%@",defaultTheme);
            [self addViewTheme];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"エラーになりました");
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //グーグルアナリティクス
    self.trackedViewName = @"selectTheme";
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }else{
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    //ナビゲーションバー
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        [BSDefaultViewObject setNavigationBar:navBar];


    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    }
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"テーマを選択"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"テーマを選択";
    [label sizeToFit];
    
    navItem.titleView = label;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"キャンセル"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(cancelTheme:)];
    navItem.leftBarButtonItem = backButton;
    
    //スクロール
    if ([BSDefaultViewObject isMoreIos7]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height - 64)];
    }else{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,320,self.view.bounds.size.height - 44)];
    }
    
    scrollView.contentSize = CGSizeMake(320, 1740);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    [self.view insertSubview:scrollView belowSubview:navBar];

    
    
    //下から出てくるセレクトビュー
    selectView = [[UIView alloc] init];
    selectView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200);
    selectView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [self.view addSubview:selectView];
    
    //セレクトビューのラベル
    UILabel *selectThemeLabel = [[UILabel alloc] init];
    //selectThemeLabel.frame = CGRectMake(selectView.center.x, selectView.center.y -60, 100, 50);
    selectThemeLabel.backgroundColor = [UIColor clearColor];
    selectThemeLabel.textColor = [UIColor whiteColor];
    selectThemeLabel.shadowColor = [UIColor blackColor];
    selectThemeLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    selectThemeLabel.font = [UIFont fontWithName:@"AppleGothic" size:14];
    selectThemeLabel.textAlignment = NSTextAlignmentCenter;
    selectThemeLabel.text = @"テーマを設定しますか？";
    [selectThemeLabel sizeToFit];
    selectThemeLabel.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y -70) toView:selectView];
    [selectView addSubview:selectThemeLabel];
    
    //ボタン
    UIImage *saveImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        saveImage = [UIImage imageNamed:@"btn_7_01"];
    }else{
        saveImage = [UIImage imageNamed:@"btn_01"];
    }
    UIButton *modalSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modalSaveButton.frame = CGRectMake( 0,  0, 280, 60);
    modalSaveButton.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y -10) toView:selectView];
    modalSaveButton.tag = 1;
    [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [modalSaveButton addTarget:self action:@selector(saveTheme:)forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:modalSaveButton];
    
    //ボタン
    UIImage *normalImage;
    if ([BSDefaultViewObject isMoreIos7]) {
        normalImage = [UIImage imageNamed:@"btn_7_03"];
    }else{
        normalImage = [UIImage imageNamed:@"btn_03"];
    }
    UIButton *itemButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton2.frame = CGRectMake( 0,  0, 280, 60);
    itemButton2.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y + 50) toView:selectView];
    itemButton2.tag = 1;
    [itemButton2 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton2 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton2 addTarget:self action:@selector(cancelTheme:)forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:itemButton2];
    
    
    //ボタンテキスト
    UILabel *modalSelectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    modalSelectLabel1.text = @"保存する";
    modalSelectLabel1.textAlignment = NSTextAlignmentCenter;
    modalSelectLabel1.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y -10) toView:selectView];
    modalSelectLabel1.font = [UIFont boldSystemFontOfSize:20];
    modalSelectLabel1.shadowColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    modalSelectLabel1.shadowOffset = CGSizeMake(0.f, -1.f);
    modalSelectLabel1.backgroundColor = [UIColor clearColor];
    modalSelectLabel1.textColor = [UIColor whiteColor];
    [selectView addSubview:modalSelectLabel1];
    
    
    UILabel *modalSelectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    modalSelectLabel2.text = @"キャンセル";
    modalSelectLabel2.textAlignment = NSTextAlignmentCenter;
    modalSelectLabel2.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y + 50) toView:selectView];
    modalSelectLabel2.font = [UIFont boldSystemFontOfSize:20];
    modalSelectLabel2.shadowColor = [UIColor whiteColor];
    modalSelectLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    modalSelectLabel2.backgroundColor = [UIColor clearColor];
    modalSelectLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [selectView addSubview:modalSelectLabel2];
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        modalSelectLabel1.shadowColor = nil;
        modalSelectLabel1.shadowOffset = CGSizeMake(0.f, 0.f);
        modalSelectLabel2.shadowColor = nil;
        modalSelectLabel2.shadowOffset = CGSizeMake(0.f, 0.f);
    }else{
    }
    
    
    int ySpace = 190;
    //画像
    //チェックイメージ
    UIImage *checkBase = [UIImage imageNamed:@"checkbase"];
    for (int n = 0; n < 9; n++) {
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkButton.frame = CGRectMake( 0,  0, 27, 27);
        checkButton.center = CGPointMake(20, 100 + n * 190);
        checkButton.tag = n + 1;
        [checkButton setBackgroundImage:checkBase forState:UIControlStateNormal];
        [checkButton setBackgroundImage:checkBase forState:UIControlStateHighlighted];
        [checkButton addTarget:self
                        action:@selector(selectTheme:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:checkButton];
    }
    
    checkImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage1.frame = CGRectMake( 0, 0, 27, 27);
    checkImage1.center = CGPointMake(20, 100);
    checkImage1.hidden = YES;
    [scrollView addSubview:checkImage1];
    
    checkImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage2.frame = CGRectMake( 0, 0, 27, 27);
    checkImage2.center = CGPointMake(20, checkImage1.center.y + ySpace);
    checkImage2.hidden = YES;
    [scrollView addSubview:checkImage2];
    
    checkImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage3.frame = CGRectMake( 0, 0, 27, 27);
    checkImage3.center = CGPointMake(20, checkImage2.center.y + ySpace);
    checkImage3.hidden = YES;
    [scrollView addSubview:checkImage3];
    
    checkImage4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage4.frame = CGRectMake( 0, 0, 27, 27);
    checkImage4.center = CGPointMake(20, checkImage3.center.y + ySpace);
    checkImage4.hidden = YES;
    [scrollView addSubview:checkImage4];
    
    checkImage5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage5.frame = CGRectMake( 0, 0, 27, 27);
    checkImage5.center = CGPointMake(20, checkImage4.center.y + ySpace);
    checkImage5.hidden = YES;
    [scrollView addSubview:checkImage5];
    
    checkImage6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage6.frame = CGRectMake( 0, 0, 27, 27);
    checkImage6.center = CGPointMake(20, checkImage5.center.y + ySpace);
    checkImage6.hidden = YES;
    [scrollView addSubview:checkImage6];
    
    checkImage7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage7.frame = CGRectMake( 0, 0, 27, 27);
    checkImage7.center = CGPointMake(20, checkImage6.center.y + ySpace);
    checkImage7.hidden = YES;
    [scrollView addSubview:checkImage7];
    
    
    checkImage8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage8.frame = CGRectMake( 0, 0, 27, 27);
    checkImage8.center = CGPointMake(20, checkImage7.center.y + ySpace);
    checkImage8.hidden = YES;
    [scrollView addSubview:checkImage8];
    
    checkImage9 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImage9.frame = CGRectMake( 0, 0, 27, 27);
    checkImage9.center = CGPointMake(20, checkImage8.center.y + ySpace);
    checkImage9.hidden = YES;
    [scrollView addSubview:checkImage9];
    
    
    
    themeImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_1.png"]];
    themeImage1.frame = CGRectMake( 0, 0, 230, 160);
    themeImage1.center = CGPointMake(160, 100);
    themeImage1.alpha = 0.8;
    [scrollView addSubview:themeImage1];
    UIButton *selectbutton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton1.tag = 1;
    selectbutton1.center = CGPointMake(160, 100);
    [selectbutton1 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton1];
    
    
    themeImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_2.png"]];
    themeImage2.frame = CGRectMake( 0, 0, 230, 160);
    themeImage2.center = CGPointMake(160, themeImage1.center.y + ySpace);
    themeImage2.alpha = 0.8;
    [scrollView addSubview:themeImage2];
    
    UIButton *selectbutton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton2.center = CGPointMake(160, themeImage1.center.y + ySpace);
    selectbutton2.tag = 2;
    [selectbutton2 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton2];
    
    
    themeImage3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_3.png"]];
    themeImage3.frame = CGRectMake( 0, 0, 230, 160);
    themeImage3.center = CGPointMake(160, themeImage2.center.y + ySpace);
    themeImage3.alpha = 0.8;
    [scrollView addSubview:themeImage3];
    UIButton *selectbutton3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton3.center = CGPointMake(160, themeImage2.center.y + ySpace);
    selectbutton3.tag = 3;
    [selectbutton3 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton3];
    
    themeImage4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_4.png"]];
    themeImage4.frame = CGRectMake( 0, 0, 230, 160);
    themeImage4.center = CGPointMake(160, themeImage3.center.y + ySpace);
    themeImage4.alpha = 0.8;
    [scrollView addSubview:themeImage4];
    UIButton *selectbutton4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton4.center = CGPointMake(160, themeImage3.center.y + ySpace);
    selectbutton4.tag = 4;
    [selectbutton4 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton4];
    
    themeImage5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_5.png"]];
    themeImage5.frame = CGRectMake( 0, 0, 230, 160);
    themeImage5.center = CGPointMake(160, themeImage4.center.y + ySpace);
    themeImage5.alpha = 0.8;
    [scrollView addSubview:themeImage5];
    
    UIButton *selectbutton5 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton5.center = CGPointMake(160, themeImage4.center.y + ySpace);
    selectbutton5.tag = 5;
    [selectbutton5 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton5];
    
    themeImage6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_6.png"]];
    themeImage6.frame = CGRectMake( 0, 0, 230, 160);
    themeImage6.center = CGPointMake(160, themeImage5.center.y + ySpace);
    themeImage6.alpha = 0.8;
    [scrollView addSubview:themeImage6];
    
    UIButton *selectbutton6 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton6.center = CGPointMake(160, themeImage5.center.y + ySpace);
    selectbutton6.tag = 6;
    [selectbutton6 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton6];
    
    themeImage7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_7.png"]];
    themeImage7.frame = CGRectMake( 0, 0, 230, 160);
    themeImage7.center = CGPointMake(160, themeImage6.center.y + ySpace);
    themeImage7.alpha = 0.8;
    [scrollView addSubview:themeImage7];
    
    UIButton *selectbutton7 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton7.center = CGPointMake(160, themeImage6.center.y + ySpace);
    selectbutton7.tag = 7;
    [selectbutton7 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton7];
    
    themeImage8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_8.png"]];
    themeImage8.frame = CGRectMake( 0, 0, 230, 160);
    themeImage8.center = CGPointMake(160, themeImage7.center.y + ySpace);
    themeImage8.alpha = 0.8;
    [scrollView addSubview:themeImage8];
    
    UIButton *selectbutton8 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton8.center = CGPointMake(160, themeImage7.center.y + ySpace);
    selectbutton8.tag = 8;
    [selectbutton8 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton8];
    
    
    themeImage9 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"originalTheme_9.png"]];
    themeImage9.frame = CGRectMake( 0, 0, 230, 160);
    themeImage9.center = CGPointMake(160, themeImage8.center.y + ySpace);
    themeImage9.alpha = 0.8;
    [scrollView addSubview:themeImage9];
    
    UIButton *selectbutton9 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 230, 160)];
    selectbutton9.center = CGPointMake(160, themeImage8.center.y + ySpace);
    selectbutton9.tag = 9;
    [selectbutton9 addTarget:self
                      action:@selector(selectTheme:)
            forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectbutton9];
  
    
    /*
    //ボタン
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake( 0,  0, 280, 60);
    saveButton.center = CGPointMake(160, themeImage9.center.y + 140);
    saveButton.tag = 1;
    [saveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveButton];
    
    //ボタン
    UIButton *itemButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton1.frame = CGRectMake( 0,  0, 280, 60);
    itemButton1.center = CGPointMake(160, saveButton.center.y + 70);
    itemButton1.tag = 1;
    [itemButton1 setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton1 setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton1 addTarget:self action:@selector(cancelTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton1];
    
    
    //ボタンテキスト
    UILabel *selectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel1.text = @"保存する";
    selectLabel1.textAlignment = NSTextAlignmentCenter;
    selectLabel1.center = CGPointMake(160, themeImage9.center.y + 140);
    selectLabel1.font = [UIFont boldSystemFontOfSize:20];
    selectLabel1.shadowColor = [UIColor whiteColor];
    selectLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel1.backgroundColor = [UIColor clearColor];
    selectLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel1];
    
    
    UILabel *selectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,40)];
    selectLabel2.text = @"キャンセル";
    selectLabel2.textAlignment = NSTextAlignmentCenter;
    selectLabel2.center = CGPointMake(160, saveButton.center.y + 70);
    selectLabel2.font = [UIFont boldSystemFontOfSize:20];
    selectLabel2.shadowColor = [UIColor whiteColor];
    selectLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    selectLabel2.backgroundColor = [UIColor clearColor];
    selectLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:selectLabel2];
    */
    

}


- (IBAction)selectTheme:(id)sender
{
    
    if ([sender tag] == 1 && !clearImageDone1) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             themeImage1.alpha = 1.0;
                             checkImage1.hidden = NO;
                             
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone1 = YES;
                         }];
        
    }else if ([sender tag] == 2 && !clearImageDone2){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage2.alpha = 1.0;
                             checkImage2.hidden = NO;
                             
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone2 = YES;
                             
                         }];
        
    }else if ([sender tag] == 3 && !clearImageDone3){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage3.alpha = 1.0;
                             checkImage3.hidden = NO;
                             
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone3 = YES;
                         }];
        
    }else if ([sender tag] == 4 && !clearImageDone4){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage4.alpha = 1.0;
                             checkImage4.hidden = NO;
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone4 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 5 && !clearImageDone5){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage5.alpha = 1.0;
                             checkImage5.hidden = NO;
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone5 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 6 && !clearImageDone6){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage6.alpha = 1.0;
                             checkImage6.hidden = NO;
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone6 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 7 && !clearImageDone7){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage7.alpha = 1.0;
                             checkImage7.hidden = NO;
                             
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone7 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 8 && !clearImageDone8){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage8.alpha = 1.0;
                             checkImage8.hidden = NO;
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage9.alpha = 0.8;
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone8 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 9 && !clearImageDone9){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage9.alpha = 1.0;
                             checkImage9.hidden = NO;
                             
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             themeImage2.alpha = 0.8;
                             checkImage2.hidden = YES;
                             themeImage3.alpha = 0.8;
                             checkImage3.hidden = YES;
                             themeImage4.alpha = 0.8;
                             checkImage4.hidden = YES;
                             themeImage5.alpha = 0.8;
                             checkImage5.hidden = YES;
                             themeImage6.alpha = 0.8;
                             checkImage6.hidden = YES;
                             themeImage7.alpha = 0.8;
                             checkImage7.hidden = YES;
                             themeImage8.alpha = 0.8;
                             checkImage8.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone9 = YES;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
    if ([sender tag] == 1 && clearImageDone1) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             themeImage1.alpha = 0.8;
                             checkImage1.hidden = YES;
                             
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone1 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 2 && clearImageDone2){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage2.alpha = 0.8;
                             
                             checkImage2.hidden = YES;
                             
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone2 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 3 && clearImageDone3){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage3.alpha = 0.8;
                             
                             checkImage3.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone3 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 4 && clearImageDone4){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage4.alpha = 0.8;
                             
                             checkImage4.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone4 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 5 && clearImageDone5){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage5.alpha = 0.8;
                             
                             checkImage5.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone5 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 6 && clearImageDone6){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage6.alpha = 0.8;
                             
                             checkImage6.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone6 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 7 && clearImageDone7){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage7.alpha = 0.8;
                             
                             checkImage7.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone7 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 8 && clearImageDone8){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage8.alpha = 0.8;
                             
                             checkImage8.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone8 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }else if ([sender tag] == 9 && clearImageDone9){
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void){
                             themeImage9.alpha = 0.8;
                             
                             checkImage9.hidden = YES;
                             
                         }
                         completion:^(BOOL finished){
                             clearImageDone9 = NO;
                         }];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}

- (void)addViewTheme{
    
    
    if ([defaultTheme isEqualToString:@"shop"]){
        themeImage1.alpha = 1.0;
        checkImage1.hidden = NO;
        
        
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        
        clearImageDone1 = YES;
    }else if([defaultTheme isEqualToString:@"shop_01"]){
        themeImage2.alpha = 1.0;
        checkImage2.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone2 = YES;
    }else if([defaultTheme isEqualToString:@"shop_02"]){
        themeImage3.alpha = 1.0;
        checkImage3.hidden = NO;
        
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone3 = YES;
    }else if([defaultTheme isEqualToString:@"shop_03"]){
        themeImage4.alpha = 1.0;
        checkImage4.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone4 = YES;
    }else if([defaultTheme isEqualToString:@"shop_04"]){
        themeImage5.alpha = 1.0;
        checkImage5.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone5 = YES;
    }else if([defaultTheme isEqualToString:@"shop_05"]){
        themeImage6.alpha = 1.0;
        checkImage6.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone6 = YES;
    }else if([defaultTheme isEqualToString:@"shop_06"]){
        themeImage7.alpha = 1.0;
        checkImage7.hidden = NO;
        
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone7 = YES;
    }else if([defaultTheme isEqualToString:@"shop_07"]){
        themeImage8.alpha = 1.0;
        checkImage8.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage9.alpha = 0.8;
        checkImage9.hidden = YES;
        
        clearImageDone8 = YES;
    }else if([defaultTheme isEqualToString:@"shop_08"]){
        themeImage9.alpha = 1.0;
        checkImage9.hidden = NO;
        
        themeImage1.alpha = 0.8;
        checkImage1.hidden = YES;
        themeImage2.alpha = 0.8;
        checkImage2.hidden = YES;
        themeImage3.alpha = 0.8;
        checkImage3.hidden = YES;
        themeImage4.alpha = 0.8;
        checkImage4.hidden = YES;
        themeImage5.alpha = 0.8;
        checkImage5.hidden = YES;
        themeImage6.alpha = 0.8;
        checkImage6.hidden = YES;
        themeImage7.alpha = 0.8;
        checkImage7.hidden = YES;
        themeImage8.alpha = 0.8;
        checkImage8.hidden = YES;
        
        clearImageDone9 = YES;
    }
}

- (IBAction)saveTheme:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"テーマを変更中" maskType:SVProgressHUDMaskTypeGradient];
    if (checkImage1.hidden == NO) {
        defaultTheme = @"shop";
    }else if (checkImage2.hidden == NO){
        defaultTheme = @"shop_01";
    }else if (checkImage3.hidden == NO){
        defaultTheme = @"shop_02";
    }else if (checkImage4.hidden == NO){
        defaultTheme = @"shop_03";
    }else if (checkImage5.hidden == NO){
        defaultTheme = @"shop_04";
    }else if (checkImage6.hidden == NO){
        defaultTheme = @"shop_05";
    }else if (checkImage7.hidden == NO){
        defaultTheme = @"shop_06";
    }else if (checkImage8.hidden == NO){
        defaultTheme = @"shop_07";
    }else if (checkImage9.hidden == NO){
        defaultTheme = @"shop_08";
    }else{
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"テーマが選択されていません" message:@""
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [SVProgressHUD dismiss];
        [alert show];
        
        return;
        
    }
    
    
    NSString *session_id = [BSTutorialViewController sessions];
    NSLog(@"session_iddddddddd:%@",session_id);
    if (session_id) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *url = [NSString stringWithFormat:@"%@/design/edit_theme?session_id=%@&default_view=%@",apiUrl,session_id,defaultTheme];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"getrequest%@",url);
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
        //NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                                path:@""
                                                          parameters:nil];
        NSLog(@"getrequest%@",getRequest);
        //通信
        NSData *returnData = [NSURLConnection sendSynchronousRequest: getRequest returningResponse: nil error: nil];
        if (returnData) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"jsonデータ:%@",jsonObject);
            //jsonItemId = [jsonObject valueForKeyPath:@"result.Item.id"];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [SVProgressHUD showSuccessWithStatus:@"テーマを変更しました！"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"エラーになりました");
        }
    }
    
    
    
}

//一番下まで行ったらビューを消す
- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    // UITableView only moves in one direction, y axis
    int currentOffset = scroll.contentOffset.y;
    int maximumOffset = scroll.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 30.0) {
        NSLog(@"したまでいっったよおおおお！！！！");
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             selectView.frame = CGRectMake(0, self.view.bounds.size.height, selectView.frame.size.width, selectView.frame.size.height);
                             
                             
                         }
                         completion:^(BOOL finished){
                         }];
        
    }
}

- (IBAction)cancelTheme:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
