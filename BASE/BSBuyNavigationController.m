//
//  BSBuyNavigationController.m
//  BASE
//
//  Created by Takkun on 2013/04/23.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSBuyNavigationController.h"

@interface BSBuyNavigationController ()

@end

@implementation BSBuyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
