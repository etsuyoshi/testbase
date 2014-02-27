//
//  BSFavoriteViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/29.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSFavoriteViewController.h"

#import "ItemTableViewCell.h"


@interface BSFavoriteViewController ()

@end

@implementation BSFavoriteViewController{
    NSArray *imageArray;
    
    NSMutableArray *imageIdArray;
    NSMutableArray *imageImageNameArray;
    NSMutableArray *imageTitleArray;
    NSMutableArray *itemPriceArray;
    UITableView *favoriteTable;
    
    NSString *imageUrl;
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
    apiUrl = [BSDefaultViewObject setApiUrl];
    //グーグルアナリティクス
    self.screenName = @"favorite";
	
    
    
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];

        favoriteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
        
        //ナビゲーションバー
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
        label.text = @"お気に入り";
        [label sizeToFit];
        
        self.navigationItem.titleView = label;
        
        

    }else{
        
        //バッググラウンド
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
        favoriteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44) style:UITableViewStylePlain];
        
        //ナビゲーションバー
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"お気に入り"];
        [navBar pushNavigationItem:navItem animated:YES];
        [self.view addSubview:navBar];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize: 20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:115.0/255.0 green:115.0/255.0 blue:115.0/255.0 alpha:1.0];
        label.text = @"お気に入り";
        [label sizeToFit];
        
        navItem.titleView = label;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] designedBackBarButtonItemWithTitle:@"店舗一覧" target:self action:@selector(backRoot) side:1];
        navItem.leftBarButtonItem = backButton;
    }
    favoriteTable.dataSource = self;
    favoriteTable.delegate = self;
    favoriteTable.scrollEnabled = YES;
    favoriteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    favoriteTable.rowHeight = 320.0;
    favoriteTable.backgroundColor = [UIColor clearColor];
    favoriteTable.tag = 10;
    [self.view addSubview:favoriteTable];
    
    UINib *nib = [UINib nibWithNibName:@"ItemTableViewCell" bundle:nil];
    [favoriteTable registerNib:nib forCellReuseIdentifier:@"itemCell"];
    
    //imageArray = [NSArray arrayWithObjects:@"ring.jpg", @"ring2.jpg", @"ring3.jpg",@"ring4.jpg", @"ring5.jpg", @"ring6.jpg",@"ring7.jpg",  nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    

    imageIdArray = [NSMutableArray array];
    imageImageNameArray = [NSMutableArray array];
    imageTitleArray = [NSMutableArray array];
    itemPriceArray = [NSMutableArray array];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSMutableArray* array = [NSMutableArray array];
    NSArray *favoriteArray = [userDefaults arrayForKey:@"favorite"];
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (int n = 0; n < favoriteArray.count; n++) {
        //NSString *variationString = [NSString stringWithFormat:@"variation_id[%d]=&variation[%d]=%@&variation_stock[%d]=%@",[variationNameArray objectAtIndex:n],[variationStockArray objectAtIndex:n];
        //[mdic setObject:@"" forKey:[NSString stringWithFormat:@"variation_id[%d]",n]];
        mdic[[NSString stringWithFormat:@"item_id[%d]",n]] = favoriteArray[n];
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/favorites/get_items",apiUrl]];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[url absoluteString] parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *error = [responseObject valueForKeyPath:@"error"];
        NSString *errormessage = [error valueForKeyPath:@"message"];
        if (errormessage) {
            [favoriteTable reloadData];
        }else{
            NSArray *itemArray = responseObject[@"result"];
            imageUrl = responseObject[@"image_url"];
            NSLog(@"itemArray.count: %d", itemArray.count);
            for (int n = 0; n < itemArray.count; n++) {
                NSDictionary *itemRoot = itemArray[n];
                NSDictionary *item = itemRoot[@"Item"];
                
                NSString *itemImageName = item[@"img"];
                NSString *itemTitle = item[@"title"];
                NSString *itemId = item[@"id"];
                NSString *price = item[@"price"];
                
                [imageIdArray addObject:itemId];
                [imageTitleArray addObject:itemTitle];
                [imageImageNameArray addObject:itemImageName];
                [itemPriceArray addObject:price];
            }
            [favoriteTable reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


#pragma mark - tableViewDelegate
/*************************************テーブルビュー*************************************/


//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    float row = (float)imageIdArray.count / 2;
    NSLog(@"rows%f",row);
    rows = ceil(row);
    NSLog(@"rows%d",rows);
    NSLog(@"imageArray.count%d",imageArray.count);
    return rows;
}

//セクションのヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([BSDefaultViewObject isMoreIos7]) {
        return 64;

    }else{
        return 10;

    }
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if ([BSDefaultViewObject isMoreIos7]) {
        height = 212;
    }else{
        height = 160;

    }
    
    return height;
}


//テーブルビューのカスタマイズ
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    
    if ([BSDefaultViewObject isMoreIos7]) {
        
        static NSString *CellIdentifier = @"itemCell";
        ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }

        
        [cell.leftItemButton addTarget:self
                        action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
        cell.leftItemButton.tag = [imageIdArray[indexPath.row * 2] intValue];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageImageNameArray[indexPath.row * 2]];
        NSLog(@"url%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
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
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                    //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                    
                    
                    
                    [cell.leftItemButton setBackgroundImage:getImage forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.6f
                                          delay:0.0f
                                        options:UIViewAnimationOptionAllowUserInteraction
                                     animations:^(void){
                                         cell.leftItemButton.alpha = 1.0;
                                     }
                     
                                     completion:^(BOOL finished){
                                         
                                     }];
                    
                    
                    
                }];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
    
        cell.leftTitleLabel.text = imageTitleArray[indexPath.row * 2];

        //お金表記
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        [nf setCurrencyCode:@"JPY"];
        NSNumber *numPrice = @([itemPriceArray[indexPath.row * 2] intValue]);
        NSString *strPrice = [nf stringFromNumber:numPrice];
    
        cell.leftPriceLabel.text = strPrice;
        
        
        if ([indexPath row] * 2 + 1 <imageIdArray.count) {
            //右側の商品画像

            [cell.rightItemButton addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
            cell.rightItemButton.tag = [imageIdArray[indexPath.row * 2 + 1] intValue];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageImageNameArray[indexPath.row * 2 + 1]];
            NSLog(@"url%@",urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
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
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self centerCroppingImageWithImage:getImage atSize:CGSizeMake(minSize, minSize)completion:^(UIImage *resultImg){
                        //[shopBtn setImage:trimmedImage forState:UIControlStateNormal];
                        
                        
                        
                        [cell.rightItemButton setBackgroundImage:resultImg forState:UIControlStateNormal];
                        [UIView animateWithDuration:0.6f
                                              delay:0.0f
                                            options:UIViewAnimationOptionAllowUserInteraction
                                         animations:^(void){
                                             cell.rightItemButton.alpha = 1.0;
                                         }
                         
                                         completion:^(BOOL finished){
                                             
                                         }];
                        
                        
                        
                    }];
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
            
            
            cell.rightTitleLabel.text = imageTitleArray[indexPath.row * 2 + 1];
            
            //お金表記
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([itemPriceArray[indexPath.row * 2 + 1] intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            
            

            cell.rightPriceLabel.text = strPrice;
            
        }
        

        
        return cell;

    }else{
        
        
        NSString *CellIdentifier = imageIdArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            if ([BSDefaultViewObject isMoreIos7]) {
                cell.backgroundColor = [UIColor whiteColor];
                
            }
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }

        
    
        for (UIView *subview in [cell subviews]) {
            [subview removeFromSuperview];
        }
        
        //左側の商品画像
        UIButton *leftItemBtn = [[UIButton alloc]
                                 initWithFrame:CGRectMake(5, 5, 150, 150)];
        [leftItemBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [leftItemBtn addTarget:self
                        action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
        leftItemBtn.tag = [imageIdArray[indexPath.row * 2] intValue];
        [cell addSubview:leftItemBtn];
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageImageNameArray[indexPath.row * 2]];
        NSLog(@"url%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            [leftItemBtn setBackgroundImage:responseObject forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
        
        
        
        
        UIImage *itemBg = [UIImage imageNamed:@"itemtitle_base.png"];
        itemBg = [self rotateImage:itemBg angle:180];
        UIImageView *itemImageView = [[UIImageView alloc] initWithImage:itemBg];
        itemImageView.frame = CGRectMake(0, 0, 300/2, 32);
        [leftItemBtn addSubview:itemImageView];
        
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,-5,148,40)];
        itemLabel.text = imageTitleArray[indexPath.row * 2];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.font = [UIFont boldSystemFontOfSize:10];
        itemLabel.numberOfLines = 2;
        [itemImageView addSubview:itemLabel];
        
        
        
        
        //お金表記
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        [nf setCurrencyCode:@"JPY"];
        NSNumber *numPrice = @([itemPriceArray[indexPath.row * 2] intValue]);
        NSString *strPrice = [nf stringFromNumber:numPrice];
        
        

        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(264, 130,52,28)];
        priceLabel.text = strPrice;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.layer.cornerRadius = 2;
        priceLabel.numberOfLines = 1;
        [itemImageView addSubview:priceLabel];
        CGSize textSize = [strPrice sizeWithFont: priceLabel.font
                               constrainedToSize:CGSizeMake(200, 28)
                                   lineBreakMode:priceLabel.lineBreakMode];
        priceLabel.frame = CGRectMake(150 - textSize.width, 130,textSize.width,20);
        
        
        
        
        if ([indexPath row] * 2 + 1 <imageIdArray.count) {
            //右側の商品画像
            UIButton *rightItemBtn = [[UIButton alloc]
                                      initWithFrame:CGRectMake(165, 5, 150, 150)];
            [rightItemBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [rightItemBtn addTarget:self
                             action:@selector(aboutItem:) forControlEvents:UIControlEventTouchUpInside];
            rightItemBtn.tag = [imageIdArray[indexPath.row * 2 + 1] intValue];
            [cell addSubview:rightItemBtn];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",imageUrl,imageImageNameArray[indexPath.row * 2 + 1]];
            NSLog(@"url%@",urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", responseObject);
                [rightItemBtn setBackgroundImage:responseObject forState:UIControlStateNormal];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
            UIImageView *rightItemImageView = [[UIImageView alloc] initWithImage:itemBg];
            rightItemImageView.frame = CGRectMake(0, 0, 300/2, 32);
            [rightItemBtn addSubview:rightItemImageView];
            
            
            UILabel *rightItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,-5,148,40)];
            rightItemLabel.text = imageTitleArray[indexPath.row * 2 + 1];
            rightItemLabel.textColor = [UIColor whiteColor];
            rightItemLabel.backgroundColor = [UIColor clearColor];
            rightItemLabel.font = [UIFont boldSystemFontOfSize:10];
            rightItemLabel.numberOfLines = 2;
            [rightItemImageView addSubview:rightItemLabel];
            
            
            //お金表記
            NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            [nf setCurrencyCode:@"JPY"];
            NSNumber *numPrice = @([itemPriceArray[indexPath.row * 2 + 1] intValue]);
            NSString *strPrice = [nf stringFromNumber:numPrice];
            

            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(264, 130,52,28)];
            priceLabel.text = strPrice;
            priceLabel.textColor = [UIColor whiteColor];
            priceLabel.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.60f];
            priceLabel.font = [UIFont systemFontOfSize:12];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.layer.cornerRadius = 2;
            priceLabel.numberOfLines = 1;
            [rightItemImageView addSubview:priceLabel];
            CGSize textSize = [strPrice sizeWithFont: priceLabel.font
                                   constrainedToSize:CGSizeMake(200, 28)
                                       lineBreakMode:priceLabel.lineBreakMode];
            priceLabel.frame = CGRectMake(150 - textSize.width, 130,textSize.width,20);
            
            
        }
        
        
        return cell;

    }
    
    
    //return cell;
    
}


- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}


//画像を回転させる
- (UIImage *) rotateImage:(UIImage *)img angle:(int)angle
{
    CGImageRef imgRef = [img CGImage];
    CGContextRef context;
    
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.height, img.size.width);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, M_PI/2.0);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, img.size.width, 0);
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(img.size.height, img.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextRotateCTM(context, -M_PI/2.0);
            break;
        default:
            NSLog(@"you can select an angle of 90, 180, 270");
            return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, img.size.width, img.size.height), imgRef);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}


#pragma mark - imageEdit
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


//アイテムIdを取得
+(NSString*)getItemId {
    return importItemId;
}

- (void)backRoot{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)aboutItem:(id)sender{
    importItemId = [NSString stringWithFormat:@"%d",[sender tag]];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutItem"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
