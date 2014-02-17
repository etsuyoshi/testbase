//
//  BSItemsView.m
//  BASE
//
//  Created by Takkun on 2013/11/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSItemsView.h"

#import "BSItemButton.h"


@implementation BSItemsView

@synthesize leftButton;
@synthesize centerLeftButton;
@synthesize centerButton;
@synthesize centerRightButton;
@synthesize rightButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
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
- (void)initialize
{
    
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    centerLeftButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    centerButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    centerRightButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    rightButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

+ (id)itemView
{
    // nib ファイルから読み込む
    UINib *nib = [UINib nibWithNibName:@"BSItemsView" bundle:nil];
    BSItemsView *view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    if (view) {
        // Initialization code
        [self initialize];
    }
    return view;
}

@end
