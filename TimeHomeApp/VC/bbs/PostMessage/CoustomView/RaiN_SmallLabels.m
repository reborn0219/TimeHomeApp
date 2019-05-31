//
//  RaiN_SmallLabels.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_SmallLabels.h"
#import "UIImage+ImageEffects.h"
@implementation RaiN_SmallLabels

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _smallTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallTagButton.frame = CGRectMake(0, 10, self.frame.size.width-10, self.frame.size.height-10);
        [self addSubview:_smallTagButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.frame.size.width-20, 0, 20, 20);
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"邻趣-发布-关闭按钮"] forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
    }
    return self;
}
@end
