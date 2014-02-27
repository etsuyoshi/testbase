//
//  BSMainPagingScrollView.m
//  BASE
//
//  Created by Takkun on 2013/04/16.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import "BSMainPagingScrollView.h"

@implementation BSMainPagingScrollView

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 20) {
        NSLog(@"%@",scrollView);
    }
}




@end
