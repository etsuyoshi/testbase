//
//  BSItemAdminViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSItemAdminViewController.h"

#import "BSTutorialViewController.h"
#import "UICKeyChainStore.h"
#import "BSImportantMessageWebViewController.h"


@interface BSItemAdminViewController ()

@end

@implementation BSItemAdminViewController{
    NSMutableArray *itemsArray;
    UITableView *itemListTable;
    BOOL isAdded;
    NSMutableArray *itemsImageArray;
    NSMutableArray *itemIdArray;
    
    NSMutableArray *itemTitleArray;
    
    //編集ページヘ
    NSString* importId;
    
    //画像url
    NSString *s3Url;
    BOOL goBuy;
    
    NSString *apiUrl;

}
static NSString *importItemId = nil;

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
    //グーグルアナリティクス
    self.screenName = @"admin";
    
    apiUrl = [BSDefaultViewObject setApiUrl];


    
    [BSDefaultViewObject customNavigationBar:0];
	// Do any additional setup after loading the view.
        
    
    
    
    UINavigationBar *navBar;
    if ([BSDefaultViewObject isMoreIos7]) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,64)];
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        //navBar.barTintColor = [UIColor grayColor];
        //navBar.backgroundColor = [UIColor grayColor];
        [BSDefaultViewObject setNavigationBar:navBar];
        
    }else{
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];

    }
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:232.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    label.text = @"商品管理";
    
    navItem.titleView = label;
    
    /*
    UIBarButtonItem *rightItemButton = [[UIBarButtonItem alloc] initWithTitle:@"買う" style:UIBarButtonItemStyleBordered target:self action:@selector(goBuy)];
    navItem.rightBarButtonItem = rightItemButton;
    
     */
    UIButton *menuButton1;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 70, 42)];
        [menuButton1 setImage:[UIImage imageNamed:@"icon_7_buy.png"] forState:UIControlStateNormal];
        [menuButton1 setImage:[UIImage imageNamed:@"icon_7_buy.png"] forState:UIControlStateHighlighted];
        [menuButton1 setImage:[UIImage imageNamed:@"icon_7_buy.png"] forState:UIControlStateSelected];
    }else{
        menuButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 42)];
        [menuButton1 setImage:[UIImage imageNamed:@"icon_buy.png"] forState:UIControlStateNormal];
    }
    
    [menuButton1 addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchDown];
    UIView * menuButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, 50, 40.0f)];
    [menuButtonView1 addSubview:menuButton1];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView1];
    
    
    UIButton *menuButton;
    if ([BSDefaultViewObject isMoreIos7]) {
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, -2, 50, 42)];
        menuButton.backgroundColor = [UIColor clearColor];
        [menuButton setImage:[UIImage imageNamed:@"icon_7_menu"] forState:UIControlStateNormal];
        

        
    }else{
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, -2, 50, 42)];
        [menuButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];

        
    }
    [menuButton addTarget:self action:@selector(slideMenu) forControlEvents:UIControlEventTouchDown];
    UIView * menuButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50, 40.0f)];
    [menuButtonView addSubview:menuButton];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButtonView];
    
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        //商品リスト
        itemListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStylePlain];
        itemListTable.dataSource = self;
        itemListTable.delegate = self;
        itemListTable.tag = 1;
        itemListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //orderListTable.backgroundView = nil;
        itemListTable.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:itemListTable belowSubview:navBar];
    }else{
        //商品リスト
        itemListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
        itemListTable.dataSource = self;
        itemListTable.delegate = self;
        itemListTable.tag = 1;
        itemListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //orderListTable.backgroundView = nil;
        itemListTable.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:itemListTable belowSubview:navBar];
    }
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [BSDefaultViewObject customNavigationBar:0];
    

    if ([BSDefaultViewObject isMoreIos7]) {
        [UINavigationBar appearance].tintColor =  [UIColor darkGrayColor];

    }
    NSLog(@"更新しているよ！");
    itemsArray = [NSMutableArray array];
    itemsImageArray = [NSMutableArray array];
    itemIdArray = [NSMutableArray array];
    itemTitleArray = [NSMutableArray array];
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[BSMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    

    
    NSLog(@"getItemsWithSessionId:session:%@",[BSUserManager sharedManager].sessionId);
    
    
    if ([BSUserManager sharedManager].sessionId) {
        
        [[BSSellerAPIClient sharedClient] getItemsWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
            
            NSLog(@"getItemsWithSessionId%@",results);
            
            itemsArray = [results valueForKeyPath:@"result"];
            NSLog(@"%d:個itemがあるよ！",itemsArray.count);
            s3Url = [results valueForKeyPath:@"image_url"];
            
            for (int n=0; n<itemsArray.count; n++) {
                NSDictionary *itemRoot = itemsArray[n];
                NSArray *item = itemRoot[@"Item"];
                NSString *itemTitle = [item valueForKeyPath:@"title"];
                NSString *image = [item valueForKeyPath:@"img1"];
                NSString *itemId = [item valueForKeyPath:@"id"];
                
                [itemsImageArray addObject:image];
                [itemIdArray addObject:itemId];
                [itemTitleArray addObject:itemTitle];
            }
            
            [itemListTable reloadData];
            
            
        }];
    } else {
        
    }
    

    
}




/*************************************テーブルビュー*************************************/




//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if (itemsArray.count) {
        rows = itemsArray.count + 1;
    }else{
        rows = 1;
    }
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if (indexPath.row == 0) {
        height = 65;
    }else{
        height = 315;
    }
    
    return height;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        if ([BSDefaultViewObject isMoreIos7]) {
            return 64;

        }
        return 0.1;
    } else {
        return tableView.sectionHeaderHeight;
    }
    
}
//セクションフッターの高さ変更
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 0) {
        return zeroSizeView;
    } else {
        return nil;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *zeroSizeView = [[UIView alloc] initWithFrame:CGRectZero];
    return zeroSizeView;
}




//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSArray *identifiers;
    NSString *CellIdentifier;
    
    if (itemsArray.count) {
        if (indexPath.row == 0) {
            CellIdentifier = @"a";
        }else{
            CellIdentifier = @"cell";
            NSLog(@"%@るよ！",CellIdentifier);
        }
        
    }else{
        identifiers = @[@"a"];
        //ここで落ちた
        CellIdentifier = identifiers[0];
    }
    
    
    
    
    //NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = YES;
        
        if (indexPath.row == 0 && !isAdded) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImage *normalButton;
            if ([BSDefaultViewObject isMoreIos7]) {
                normalButton = [UIImage imageNamed:@"btn_7_newitem"];

            }else{
                normalButton = [UIImage imageNamed:@"btn_newitem"];

            }
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.frame = CGRectMake( 7.5,  10, 305, 50);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [itemButton setBackgroundImage:normalButton forState:UIControlStateNormal];
            //[itemButton setBackgroundImage:normalButton forState:UIControlStateHighlighted];
            [itemButton addTarget:self action:@selector(addItem)forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:itemButton];
            isAdded = YES;
        }
    
    }
    
    
    
    if (itemsArray.count) {
        [self updateCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}



- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (int n = 1; n <= itemsArray.count; n++) {
        NSString *imageUrl = itemsImageArray[n - 1];
        NSString *itemTitle = itemTitleArray[n - 1];
        if (indexPath.row == n) {
            if (imageUrl == nil || [imageUrl isEqual:[NSNull null]])
            {
                for (UIView *subview in [cell.contentView subviews]) {
                    [subview removeFromSuperview];
                }
                
                UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                UIImageView *noImageView1 = [[UIImageView alloc] initWithImage:noImage1];
                [noImageView1 setFrame:CGRectMake( 7.5, 5, 305, 305)];
                
                [cell.contentView addSubview:noImageView1];
                
                UIImage *noImage2 = [UIImage imageNamed:@"no_image"];
                UIImageView *noImageView2 = [[UIImageView alloc] initWithImage:noImage2];
                [noImageView2 setFrame:CGRectMake(102.5, 102.5, 100, 100)];
                [noImageView1 addSubview:noImageView2];
                
                UIImage *titleImage = [UIImage imageNamed:@"shoptitle_base"];
                UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
                
                [titleImageView setFrame:CGRectMake( 0, 246, 300, 56)];
                [noImageView1 addSubview:titleImageView];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,280,20)];
                titleLabel.text = itemTitle;
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [titleImageView addSubview:titleLabel];
                
                
                /*
                UIImage *editImage = [UIImage imageNamed:@"edit_item"];
                UIImageView *editImageView = [[UIImageView alloc] initWithImage:editImage];
                [editImageView setFrame:CGRectMake( 243, -20, 40, 40)];
                [noImageView1 addSubview:editImageView];
                */
                
            }else{

                
                for (UIView *subview in [cell.contentView subviews]) {
                    [subview removeFromSuperview];
                }
                UIImage *noImage1 = [UIImage imageNamed:@"bgi_item"];
                UIImageView *noImageView1 = [[UIImageView alloc] initWithImage:noImage1];
                [noImageView1 setFrame:CGRectMake( 7.5, 5, 305, 305)];
                
                [cell.contentView addSubview:noImageView1];

                /*
                UIImage *editImage = [UIImage imageNamed:@"edit_item"];
                UIImageView *editImageView = [[UIImageView alloc] initWithImage:editImage];
                [editImageView setFrame:CGRectMake( 274, -20, 40, 40)];
                */
                 
                UIImage *titleImage = [UIImage imageNamed:@"shoptitle_base"];
                UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
                
                [titleImageView setFrame:CGRectMake( 2, 246, 301, 57)];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,280,20)];
                titleLabel.text = itemTitle;
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [titleImageView addSubview:titleLabel];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 2.5, 2.5, 300, 300)];
                imageView.alpha = 0.0;
                if ([BSDefaultViewObject isMoreIos7]) {
                    
                }else{
                    imageView.layer.shadowOffset = CGSizeMake(0, 0);
                    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
                    imageView.layer.shadowRadius = 2.0f;
                    imageView.layer.shadowOpacity = 0.60f;
                    imageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:imageView.layer.bounds] CGPath];
                }
                
                NSString *url1 = [NSString stringWithFormat:@"%@%@",s3Url,imageUrl];
                NSURLRequest *getImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
                
            [noImageView1 addSubview:imageView];

            //[noImageView1 addSubview:editImageView];
                
            [noImageView1 addSubview:titleImageView];
                
                AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getImageRequest];
                requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"Response: %@", responseObject);
                    UIImage *getImage = responseObject;
                    int imageW = getImage.size.width;
                    int imageH = getImage.size.height;
                    
                    int minSize = 0;
                    if (imageH <= imageW) {
                        //横長の場合
                        minSize = imageH;
                    } else {
                        //縦長の場合
                        minSize = imageW;
                    }
                    NSLog(@"オリジナルサイズw:%d:h%d",imageW,imageH);
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                            //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                            
                            int imageW = resultImg.size.width;
                            int imageH = resultImg.size.height;
                            
                            NSLog(@"画像サイズw:%d:w%d",imageW,imageH);
                            
                            [imageView setImage:resultImg];
                            resultImg = nil;
                            [UIView animateWithDuration:0.6f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionAllowUserInteraction
                                             animations:^(void){
                                                 imageView.alpha = 1.0;
                                             }
                             
                                             completion:^(BOOL finished){
                                                 
                                             }];
                            
                        }];
                    });
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Image error: %@", error);
                }];
                [requestOperation start];
                
    
            }
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    
    
    
    if ([BSUserManager sharedManager].sessionId) {
        [[BSSellerAPIClient sharedClient] getUsersDisplayWebViewWithSessionId:[BSUserManager sharedManager].sessionId completion:^(NSDictionary *results, NSError *error) {
            
            
            
            NSLog(@"users/display_webview: %@", results);
            
            int display = [results[@"result"][@"display"] intValue];
            NSLog(@"users/display_webviewdisplay: %d", display);
            
            if (display == 1) {
                static dispatch_once_t token;
                dispatch_once(&token, ^{
                    NSLog(@"実行");
                    BSImportantMessageWebViewController *vc = [[BSImportantMessageWebViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:^{
                        
                    }];
                });
                
            }
            
        }];
    }
    
    

}


//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return;
    }
    
    importId = itemIdArray[indexPath.row - 1];
    NSLog(@"%@",importId);
    importItemId = importId;
    //EditViewController *editViewController = [[EditViewController alloc] init];
    //BSEditItemViewController *editItemViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editItem"];
    
    UIViewController *editNavViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editNav"];
    
    [self presentViewController:editNavViewController animated:YES completion: ^{
    
        NSLog(@"完了");}];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


+(NSString*)getItemId {
    return importItemId;
}
+(void)setItemId:(NSString*)str {
    importItemId = [str copy];
}

- (void)addItem
{
    UIViewController *modalView = [self.storyboard instantiateViewControllerWithIdentifier:@"addItem"];
    
    [self presentViewController:modalView animated:YES completion: ^{
        
        NSLog(@"完了");}];
}

- (void)goBuy
{
    goBuy = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    itemsArray = nil;
    itemsImageArray = nil;
    itemIdArray = nil;
    itemTitleArray = nil;
    if (goBuy) {
        if ([BSDefaultViewObject isMoreIos7]) {
            [UINavigationBar appearance].tintColor =  [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];
        }
        [BSDefaultViewObject customNavigationBar:1];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

     /*
     if (indexPath.row % 2 == 0) {
     cell.backgroundColor = [UIColor grayColor];
     //cell.backgroundColor = [UIColor grayColor];
     }else{
     cell.backgroundColor = [UIColor whiteColor];
     }
      */
     
}

- (void)centerCroppingImageWithImage:(UIImage*)img atSize:(CGSize)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    /* 画像のサイズ */
    CGSize imgSize = CGSizeMake(img.size.width * img.scale,
                                img.size.height * img.scale);
    /* トリミングするサイズ */
    CGSize croppingSize = CGSizeMake(size.width * [UIScreen mainScreen].scale,
                                     size.height * [UIScreen mainScreen].scale);
    /* 中央でトリミング */
    CIImage *filteredImage = [ciImage imageByCroppingToRect:CGRectMake(imgSize.width/2.f - croppingSize.width/2.f,
                                                                       imgSize.height/2.f - croppingSize.height/2.f,
                                                                       croppingSize.width,
                                                                       croppingSize.height)];
    /* UIImageに変換する */
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

- (UIImage*)uiImageFromCIImage:(CIImage*)ciImage
{
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO }];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}


- (void)slideMenu
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
-(void)helloDelegate
{
    NSLog(@"hello,Delegate");
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

/*
void exceptionHandler(NSException *exception) {
    // ここで、例外発生時の情報を出力します。
    // NSLog関数でcallStackSymbolsを出力することで、
    // XCODE上で開発している際にも、役立つスタックトレースを取得できるようになります。
    NSLog(@"exceptionHandler:%@", exception.name);
    NSLog(@"%@", exception.reason);
    NSLog(@"%@", exception.callStackSymbols);
    
    // ログをUserDefaultsに保存しておく。
    // 次の起動の際に存在チェックすれば、前の起動時に異常終了したことを検知できます。
    
     NSString *log = [NSString stringWithFormat:@"%@, %@, %@", exception.name, exception.reason, exception.callStackSymbols];
     [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"failLog"];
     NSString *failLog = [[NSUserDefaults standardUserDefaults] stringForKey:@"failLog"];
     NSLog(@"かーーーーとおちた%@",failLog);
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    [ud removeObjectForKey:@"cart"];
    [ud synchronize];
    
}
 */
