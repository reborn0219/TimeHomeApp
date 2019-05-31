//
//  L_OrderTimeTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_OrderTimeTVC.h"

@implementation L_OrderTimeTVC

- (void)setModel:(L_ExchangeModel *)model {
    _model = model;
    
    _timeLabel.text = [NSString stringWithFormat:@"赠予时间：%@",[XYString IsNotNull:model.systime]];
    
    _nickName.text = [XYString IsNotNull:model.preusername];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeLabel.text = @"";
    _nickName.text = @"";
    
    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
