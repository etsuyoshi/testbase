//
//  ViewController.m
//  BASE
//
//  Created by Takkun on 2013/04/11.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "ViewController.h"
#import "UICKeyChainStore.h"


@interface ViewController ()
@end

@implementation ViewController
bool isModaled = NO;




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];

    NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
    NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
    NSString *email = [store stringForKey:@"email"];
    
    
    // キーチェインに保存してるアイパスがない場合チュートリアルビューに飛ぶ
    if (!email) {
        NSLog(@"tutorial start");
            UIViewController *modalView =
        [self.storyboard instantiateViewControllerWithIdentifier:@"tutorial"];
            [self presentViewController:modalView animated:YES completion: ^{
                NSLog(@"完了");}];
        

    }else{

        NSLog(@"email not registered");
    }
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"itemAdmin"];
    
    NSLog(@"view did load");
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
