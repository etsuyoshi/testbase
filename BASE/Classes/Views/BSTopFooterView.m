//
//  BSTopFooterView.m
//  BASE
//
//  Created by Takkun on 2013/09/17.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BSTopFooterView.h"

@implementation BSTopFooterView
/*
@synthesize favoriteButton;
@synthesize cartButton;
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
        [[favoriteButton layer] setBorderWidth:0.25f];
        [[favoriteButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[cartButton layer] setBorderWidth:0.25f];
        [[cartButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
         */
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (id)setView
{
    // nib ファイルから読み込む
    UINib *nib = [UINib nibWithNibName:@"BSTopFooterView" bundle:nil];
    BSTopFooterView *view = [nib instantiateWithOwner:self options:nil][0];
    return view;
}

@end
