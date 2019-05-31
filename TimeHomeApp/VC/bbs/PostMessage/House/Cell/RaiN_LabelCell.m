//
//  RaiN_LabelCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_LabelCell.h"

@implementation RaiN_LabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _bgView.layer.cornerRadius = (SCREEN_WIDTH - 16 - 12)/4/3/2;
//    _bgView.layer.borderWidth = 1.5f;
//    _bgView.layer.borderColor = NEW_RED_COLOR.CGColor;
//    _bgView.layer.cornerRadius = (SCREEN_WIDTH - 16 - 12)/4/3/2;

    _showLabel.textColor = NEW_RED_COLOR;
    _showLabel.layer.borderWidth = 1.5f;
    _showLabel.layer.borderColor = NEW_RED_COLOR.CGColor;
    _showLabel.layer.cornerRadius = 10.0f;
    
    
    _closeBtn.layer.cornerRadius = 15.f;
}

@end
