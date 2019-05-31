//
//  PANewHomeNavigationTitleView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeNavigationTitleView.h"
#import "UIButtonImageWithLable.h"
@implementation PANewHomeNavigationTitleView
{
    NSString *_title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        _title = title;
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.frame = CGRectMake(0, 0, 200, 44);
    [self setTitleColor:UIColorHex(0x595353) forState:UIControlStateNormal];
    [self addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickEvent{
    if (self.callback) {
        self.callback(nil, SucceedCode);
    }
}
- (void)reloadNavigationTitle:(NSString *)title{
    [self setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:title forState:UIControlStateNormal];
}

@end
