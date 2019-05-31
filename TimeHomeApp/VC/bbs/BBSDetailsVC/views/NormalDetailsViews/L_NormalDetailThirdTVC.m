//
//  L_NormalDetailThirdTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NormalDetailThirdTVC.h"

@implementation L_NormalDetailThirdTVC

- (void)setModel:(L_NormalInfoModel *)model {
    _model = model;
    
    if ([XYString isBlankString:model.pvcount]) {
        _liulanLabel.text = @"浏览 0";
    }else {
        _liulanLabel.text = [NSString stringWithFormat:@"浏览 %@",model.pvcount];
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
