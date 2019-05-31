//
//  GoodsHeaderView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/10/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GoodsHeaderView.h"

@implementation GoodsHeaderView
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,126);

    }
    return self;
}
@end
