//
//  BSAboutAppViewController.m
//  BASE
//
//  Created by Takkun on 2013/06/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSAboutAppViewController.h"

#import "BSDefaultViewObject.h"

@interface BSAboutAppViewController ()

@end

@implementation BSAboutAppViewController{
    UITableView *menuTable;
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
    self.trackedViewName = @"aboutApp";
    
    
    //バッググラウンド
    if ([BSDefaultViewObject isMoreIos7]) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        //navBar.barTintColor = [UIColor grayColor];
        //navBar.backgroundColor = [UIColor grayColor];
    }else{
        UIImageView *backgroundImageView = [BSDefaultViewObject setBackground];
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        
    }
    
    UIButton *leftButton;
    if ([BSDefaultViewObject isMoreIos7]) {
        leftButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 50, 42)];
    }else{
        leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 42)];

    }
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"icon_close1.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    UIView * leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 50, 40.0f)];
    leftButtonView.backgroundColor = [UIColor clearColor];
    leftButton.tag = 1;
    [leftButtonView addSubview:leftButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    
    if ([BSDefaultViewObject isMoreIos7]) {
        menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) style:UITableViewStyleGrouped];
        menuTable.center =  CGPointMake(160, 220);

    }else{
        menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 299, 280) style:UITableViewStyleGrouped];
        menuTable.center =  CGPointMake(160, 140);

    }
    menuTable.dataSource = self;
    menuTable.delegate = self;
    menuTable.backgroundView = nil;
    menuTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:menuTable];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize: 20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0];
    label.text = @"アプリについて";
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = NO;
        
        if (indexPath.row == 0) {
            NSString* version =  [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
            cell.textLabel.text = [NSString stringWithFormat:@"version %@",version];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"利用規約";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"著作権情報";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"ヘルプ";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        }else if (indexPath.row == 4) {
            cell.textLabel.text = @"お問い合わせ";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        }else if (indexPath.row == 5) {
            cell.textLabel.text = @"通知設定";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
        }
    }
    return cell;
}

//セルデリゲートメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d:番目が押されているよ！",indexPath.row);
    if (indexPath.row == 2) {
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"copy"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"policy"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 3){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"buyHelp"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 4){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"buyContact"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 5){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"pushSetting"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    /*
     UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"orderDtails"];
     [self.navigationController pushViewController:vc animated:YES];
     */
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
