//
//  BSSelectThemeViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSSelectThemeViewController.h"

#import "BSThemeTableViewCell.h"


@interface BSSelectThemeViewController ()

@end

@implementation BSSelectThemeViewController{
    UIScrollView *scrollView;
    NSString *apiUrl;
    
    NSDictionary *themeDictionary;
    
    UITableView *themeTableView;
    
    int selectedThemeInt;
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
    
    
    //グーグルアナリティクス
    self.screenName = @"selectTheme";
    
    //バッググラウンド
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"保存"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveTheme:)];
    navItem.rightBarButtonItem = rightButton;

    
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
    
    
    themeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,320,self.view.bounds.size.height - 64) style:UITableViewStyleGrouped];
    
    themeTableView.dataSource = self;
    themeTableView.delegate = self;
    themeTableView.tag = 1;
    UINib *nib = [UINib nibWithNibName:@"BSThemeTableViewCell" bundle:nil];
    [themeTableView registerNib:nib forCellReuseIdentifier:@"themeCell"];
    [self.view addSubview:themeTableView];



}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    [[BSSellerAPIClient sharedClient] getDesignThemesWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
        NSLog(@"テーマ一覧:%@",results);
        
        themeDictionary = results;
        
        [[BSSellerAPIClient sharedClient] getDesignThemeWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
            NSLog(@"jsonデータ:%@",results);
            
            //jsonItemId = [jsonObject valueForKeyPath:@"result.Item.id"];
            NSDictionary *defaultView = [results valueForKeyPath:@"user.User.default_view"];
            defaultTheme = [NSString stringWithFormat:@"%@", defaultView];
            NSArray *themeArray = themeDictionary[@"theme"];

            for (int i = 0; i < themeArray.count; i++) {
                
                if ([themeArray[i][@"name"] isEqualToString:defaultTheme]) {
                    selectedThemeInt = i;
                }
                
            }
            
            [themeTableView reloadData];

        }];
    }];
    
}


- (IBAction)saveTheme:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"テーマを変更中" maskType:SVProgressHUDMaskTypeGradient];
    
    NSArray *themeArray = themeDictionary[@"theme"];
    defaultTheme = themeArray[selectedThemeInt][@"name"];
    
    NSLog(@"defaultTheme:%@",defaultTheme);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[BSSellerAPIClient sharedClient] getDesignEditThemeWithSessionId:[BSUserManager sharedManager].sessionId defaultView:defaultTheme completion:^(NSDictionary *results, NSError *error) {
        NSLog(@"getDesignEditThemeWithSessionId:%@",results);
        //jsonItemId = [jsonObject valueForKeyPath:@"result.Item.id"];
        NSLog(@"getDesignEditThemeWithSessionId:error:%@",results[@"error"][@"validations"][@"User"][@"default_view"][0]);

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD showSuccessWithStatus:@"テーマを変更しました！"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    
}

//一番下まで行ったらビューを消す
- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    // UITableView only moves in one direction, y axis
    int currentOffset = scroll.contentOffset.y;
    int maximumOffset = scroll.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 30.0) {
        NSLog(@"一番下");
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




//========================================================================
#pragma mark - tableView

//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    NSArray *themeArray = themeDictionary[@"theme"];
    if (themeArray.count) {
        rows = themeArray.count;
    } else {
        rows = 3;
    }
    return rows;
}

//セクションフッターの高さ変更
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int height;
    height = 160;
    return height;
    
}



//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
    
    
}


//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
    
}

//セクションフッターの高さ変更

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"themeCell"];
    BSThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BSThemeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if (themeDictionary[@"theme"]) {
        
        NSArray *themeArray = themeDictionary[@"theme"];
        NSString *themeName = themeArray[indexPath.row][@"image"];
        NSString *themeBaseURL = themeDictionary[@"theme_url"];
        NSLog(@"%@%@", themeBaseURL, themeName);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", themeBaseURL, themeName]];
        [cell.themeImageView setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    }
    
    cell.checkImageView.hidden = YES;
    if (selectedThemeInt == indexPath.row) {
        cell.checkImageView.hidden = NO;
    }
    
    return cell;
    
    
}

//cellをタップ
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedThemeInt = indexPath.row;
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
