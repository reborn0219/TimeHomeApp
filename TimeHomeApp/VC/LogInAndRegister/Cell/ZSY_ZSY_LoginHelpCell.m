//
//  ZSY_ZSY_LoginHelpCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_ZSY_LoginHelpCell.h"

@implementation ZSY_ZSY_LoginHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    
    if (isSelected) {
        _stateImage.image = [UIImage imageNamed:@"选中图标"];
    }else {
        _stateImage.image = [UIImage imageNamed:@"未选中图标"];
    }
    
}

@end
