//
//  ZSY_BindingCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_BindingCell.h"

@implementation ZSY_BindingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftLabel.textColor = TEXT_COLOR;
    _centerLabel.textColor = TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
