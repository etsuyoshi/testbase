//
//  BSSelectBgViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/14.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSSelectBgViewController.h"

@interface BSSelectBgViewController ()

@end

@implementation BSSelectBgViewController{
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    apiUrl = [BSDefaultViewObject setApiUrl];
    NSString *session_id = [BSTutorialViewController sessions];
    NSLog(@"session_iddddddddd:%@",session_id);
    if (session_id) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSString *url = [NSString stringWithFormat:@"%@/design/get_backgrounds?session_id=%@&=",apiUrl,session_id];
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
            NSArray *backgroundsArray = [jsonObject valueForKeyPath:@"background"];
            backgroundsDict = [jsonObject valueForKeyPath:@"background"];
            NSLog(@"jsonデータ:%@",backgroundsArray);
            int row = 1;
            int imagePoint = 0;
            NSLog(@"画像数:%d",backgroundsArray.count);
            for (int n = 0; n < backgroundsArray.count; n++) {
                
                UIImage *noImage = [UIImage imageNamed:@"bgi_item"];
                UIImageView *noImageView = [[UIImageView alloc] initWithImage:noImage];
                [noImageView setFrame:CGRectMake( 50/6 + (54 + 50/6) * imagePoint, 15 + (54 + 50/6) * (row - 1), 54, 54 )];
                [scrollView addSubview:noImageView];
                
                NSString *imageUrl = backgroundsDict[[NSString stringWithFormat:@"%d", n + 1]];
                NSString *url1 = [NSString stringWithFormat:@"https://baseecdev2.s3.amazonaws.com/images/user/bg/%@",imageUrl];
                NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                NSLog(@"ゆーあーるえる%@",url1);
                AFImageRequestOperation *operation = [AFImageRequestOperation
                                                      imageRequestOperationWithRequest: getImageRequest
                                                      imageProcessingBlock: nil
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                          selectBgButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                          selectBgButton.frame = CGRectMake( 50/6 + (54 + 50/6) * imagePoint, 15 + (54 + 50/6) * (row - 1), 54, 54 );
                                                          selectBgButton.tag = n;
                                                          [selectBgButton setBackgroundImage:image forState:UIControlStateNormal];
                                                          [selectBgButton setBackgroundImage:image forState:UIControlStateHighlighted];
                                                          selectBgButton.alpha = 0.8;
                                                          [selectBgButton addTarget:self action:@selector(selectBackground:)forControlEvents: UIControlEventTouchUpInside];
                                                          [scrollView addSubview:selectBgButton];
                                                          
                                                          //チェックボタン
                                                          UIImageView *checkBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbase"]];
                                                          checkBox.tag = n;
                                                          checkBox.frame = CGRectMake( 50/6 + (54 + 50/6) * imagePoint + 27, 15 + (54 + 50/6) * (row - 1) + 27, 27, 27 );
                                                          [scrollView addSubview:checkBox];
                                                          
                                                      }
                                                      failure: nil];
                [operation start];
                
                /*
                 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 50/6 + (54 + 50/6) * imagePoint, 15 + (54 + 50/6) * (row - 1), 54, 54 )];
                 [imageView setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"商品画像"]];
                 imageView.alpha = 0.8;
                 
                 [scrollView addSubview:imageView];
                 
                 UIButton *selectbutton = [[UIButton alloc] initWithFrame:CGRectMake( 50/6 + (54 + 50/6) * imagePoint, 15 + (54 + 50/6) * (row - 1), 54, 54 )];
                 selectbutton.tag = n;
                 [selectbutton addTarget:self
                 action:@selector(selectBackground:)
                 forControlEvents:UIControlEventTouchUpInside];
                 [scrollView addSubview:selectbutton];
                 */
                
                imagePoint++;
                if (imagePoint == 5) {
                    row++;
                    imagePoint = 0;
                }
                
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            int last = [scrollView.subviews count] - 1;
            UIView *hoge = (scrollView.subviews)[last];
            
            NSLog(@"最後のビュー%@フレーム%f",hoge,hoge.frame.origin.x);
            [scrollView setContentSize:(CGSizeMake(320, hoge.frame.origin.y + hoge.frame.size.height + 5))];
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"エラーになりました");
        }
    }
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //グーグルアナリティクス
    self.trackedViewName = @"selectBg";
    
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
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"背景画像を選択"];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"背景画像を選択";
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
    
    scrollView.contentSize = CGSizeMake(320, 1500);
    scrollView.scrollsToTop = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
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
    UIImage *saveImage = [UIImage imageNamed:@"btn_01"];
    UIButton *modalSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modalSaveButton.frame = CGRectMake( 0,  0, 280, 60);
    modalSaveButton.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y -10) toView:selectView];
    modalSaveButton.tag = 1000000;
    [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [modalSaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [modalSaveButton addTarget:self action:@selector(saveTheme:)forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:modalSaveButton];
    
    //ボタン
    UIImage *normalImage = [UIImage imageNamed:@"btn_03"];
    UIButton *itemButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton2.frame = CGRectMake( 0,  0, 280, 60);
    itemButton2.center = [self.view convertPoint:CGPointMake(selectView.center.x , selectView.center.y + 50) toView:selectView];
    itemButton2.tag = 1000000;
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
    
 
    /*
    //ボタン
    UIButton *SaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SaveButton.frame = CGRectMake( 0,  0, 280, 60);
    SaveButton.center = CGPointMake(self.view.center.x , 1250);
    SaveButton.tag = 100;
    [SaveButton setBackgroundImage:saveImage forState:UIControlStateNormal];
    [SaveButton setBackgroundImage:saveImage forState:UIControlStateHighlighted];
    [SaveButton addTarget:self action:@selector(saveTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:SaveButton];
    
    //ボタン
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake( 0,  0, 280, 60);
    itemButton.center = CGPointMake(self.view.center.x , 1320);
    itemButton.tag = 100;
    [itemButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [itemButton setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    [itemButton addTarget:self action:@selector(cancelTheme:)forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:itemButton];
    
    //ボタンテキスト
    UILabel *SelectLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,40)];
    SelectLabel1.text = @"保存する";
    SelectLabel1.textAlignment = NSTextAlignmentCenter;
    SelectLabel1.center = CGPointMake(self.view.center.x , 1250);
    SelectLabel1.font = [UIFont boldSystemFontOfSize:20];
    SelectLabel1.shadowColor = [UIColor whiteColor];
    SelectLabel1.shadowOffset = CGSizeMake(0.f, 1.f);
    SelectLabel1.backgroundColor = [UIColor clearColor];
    SelectLabel1.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:SelectLabel1];
    
    
    UILabel *SelectLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,40)];
    SelectLabel2.text = @"キャンセル";
    SelectLabel2.textAlignment = NSTextAlignmentCenter;
    SelectLabel2.center = CGPointMake(self.view.center.x , 1320);
    SelectLabel2.font = [UIFont boldSystemFontOfSize:20];
    SelectLabel2.shadowColor = [UIColor whiteColor];
    SelectLabel2.shadowOffset = CGSizeMake(0.f, 1.f);
    SelectLabel2.backgroundColor = [UIColor clearColor];
    SelectLabel2.textColor = [UIColor colorWithRed:162.0f/255.0f green:162.0f/255.0f blue:162.0f/255.0f alpha:1.0f];
    [scrollView addSubview:SelectLabel2];
     
     */
}


- (IBAction)selectBackground:(id)sender
{
    for(UIView *removeView in [scrollView subviews]){
        if (removeView.tag < 1000) {
            removeView.alpha = 0.8;
        }
    }
    imageNumber = [sender tag] + 1;
    NSLog(@"%d番目のボタンが押されてるよ！",[sender tag]);
    UIButton *senderBtn = (UIButton *)sender;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void){
                         senderBtn.alpha = 1.0;
                         selectView.frame = CGRectMake(0, self.view.bounds.size.height - 200, selectView.frame.size.width, selectView.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
    //チェックボタン
    [check removeFromSuperview];
    check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    check.frame = CGRectMake(senderBtn.frame.origin.x + 27, senderBtn.frame.origin.y + 27, 27, 27 );
    [scrollView addSubview:check];
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



- (IBAction)saveTheme:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"テーマを変更中" maskType:SVProgressHUDMaskTypeGradient];
    NSString *session_id = [BSTutorialViewController sessions];
    NSLog(@"session_iddddddddd:%@",session_id);
    if (session_id) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *imageUrl = backgroundsDict[[NSString stringWithFormat:@"%d",imageNumber]];
        NSString *url = [NSString stringWithFormat:@"%@/design/edit_background?session_id=%@&background=%@",apiUrl,session_id,imageUrl];
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
            [SVProgressHUD showSuccessWithStatus:@"背景を変更しました！"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"エラーになりました");
        }
    }
    
    
    
}

- (IBAction)cancelTheme:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
