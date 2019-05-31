//
//  L_HelpListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HelpListTVC.h"

@implementation L_HelpListTVC

- (void)setModel:(L_HelpModel *)model {
    _model = model;
    
    _titleLabel.text = [XYString IsNotNull:model.title];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
