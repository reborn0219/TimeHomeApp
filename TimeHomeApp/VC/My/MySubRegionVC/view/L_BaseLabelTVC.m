//
//  L_BaseLabelTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BaseLabelTVC.h"

@implementation L_BaseLabelTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dotImageView.hidden = YES;
    _dotImageView.layer.cornerRadius = 2.5;
    
    _bottomLineView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
