//
//  ZSY_CarAlarmCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_CarAlarmCell.h"

@implementation ZSY_CarAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lineView.layer.masksToBounds =YES;
    _lineView.layer.cornerRadius = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
