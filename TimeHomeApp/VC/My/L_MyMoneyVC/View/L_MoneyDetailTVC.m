//
//  L_MoneyDetailTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "L_MoneyDetailTVC.h"

@implementation L_MoneyDetailTVC

- (void)setModel:(L_BalanceListModel *)model {
    _model = model;
    
    /** 标题 */
    _titleLabel.text = [XYString IsNotNull:model.title];
   
    
    /** 类型 10001充值 10002提现 金额*/
    NSString *moneyString = [NSString stringWithFormat:@"%@",model.money];
    if (![XYString isBlankString:moneyString]) {
        if (moneyString.floatValue > 0) {
            _minusMoney.text = [NSString stringWithFormat:@"+%.2f元",moneyString.doubleValue];
        }else {
            _minusMoney.text = [NSString stringWithFormat:@"%.2f元",moneyString.doubleValue];
        }
    }else {
        _minusMoney.text = @"";
    }
    
    /** 时间 */
    _timeLabel.text = model.systime;

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
