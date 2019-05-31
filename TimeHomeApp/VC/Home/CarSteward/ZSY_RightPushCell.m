//
//  ZSY_RightPushCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_RightPushCell.h"

@implementation ZSY_RightPushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.masksToBounds =YES;
    _bgView.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _bgView.layer.borderWidth = 1.0f;
    
//    _bgView.layer.cornerRadius = _rightButton.frame.size.height / 2;
//    if (SCREEN_WIDTH <= 320) {
//        _bgView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(60).heightIs(60);
//        _carIcon.sd_layout.centerXEqualToView(_bgView).topSpaceToView(_bgView,8).widthIs(50).heightIs(50);
//        _carNumber.sd_layout.centerXEqualToView(_bgView).topSpaceToView(_carIcon,8).heightIs(15);
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
