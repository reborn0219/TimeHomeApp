//
//  ZSY_NewAddressCell3.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_NewAddressCell3.h"

@implementation ZSY_NewAddressCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = TEXT_COLOR;
    _clickButton.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

@end
