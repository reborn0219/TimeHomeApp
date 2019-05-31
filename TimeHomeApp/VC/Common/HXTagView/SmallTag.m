//
//  SmallTag.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SmallTag.h"

@implementation SmallTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _smallTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallTagButton.frame = CGRectMake(0, 10, self.frame.size.width-10, self.frame.size.height-10);
        [self addSubview:_smallTagButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"我的_个人设置_标签_删除标签"] forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
    }
    return self;
}

@end
