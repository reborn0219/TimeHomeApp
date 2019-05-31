//
//  L_ShopTicketListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/18.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ShopTicketListTVC.h"

@implementation L_ShopTicketListTVC

- (void)setModel:(L_CouponListModel *)model {
    
    _model = model;
    
    _name_Label.text = [XYString IsNotNull:model.couponname];
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    
    if (![XYString isBlankString:model.starttime]) {
        
        if (model.starttime.length >= 10) {
            startTime = [model.starttime substringToIndex:10];
        }else {
            startTime = model.starttime;
        }
        
    }
    if (![XYString isBlankString:model.endtime]) {
        
        if (model.endtime.length >= 10) {
            endTime = [model.endtime substringToIndex:10];
        }else {
            endTime = model.endtime;
        }
        
    }
    
    NSDate *startDate = [XYString NSStringToDate:startTime withFormat:@"YYYY-MM-dd"];
    startTime = [XYString NSDateToString:startDate withFormat:@"YYYY.MM.dd"];
    
    NSDate *endDate = [XYString NSStringToDate:endTime withFormat:@"YYYY-MM-dd"];
    endTime = [XYString NSDateToString:endDate withFormat:@"YYYY.MM.dd"];
    
    _time_Label.text = [NSString stringWithFormat:@"有效时间:%@-%@",[XYString IsNotNull:startTime],[XYString IsNotNull:endTime]];
    
    //可使用0      商城已使用 1      未生效 2     已失效 3
    if (model.couponstate.intValue == 0) {
        [_use_Button setTitle:@"去使用" forState:UIControlStateNormal];
        [_use_Button setBackgroundImage:[UIImage imageNamed:@"使用券-红"] forState:UIControlStateNormal];
    }
    if (model.couponstate.intValue == 1) {
        [_use_Button setTitle:@"已使用" forState:UIControlStateNormal];
        [_use_Button setBackgroundImage:[UIImage imageNamed:@"使用券-灰"] forState:UIControlStateNormal];
    }
    if (model.couponstate.intValue == 2) {
        [_use_Button setTitle:@"未生效" forState:UIControlStateNormal];
        [_use_Button setBackgroundImage:[UIImage imageNamed:@"使用券-灰"] forState:UIControlStateNormal];
    }
    if (model.couponstate.intValue == 3) {
        [_use_Button setTitle:@"已失效" forState:UIControlStateNormal];
        [_use_Button setBackgroundImage:[UIImage imageNamed:@"使用券-灰"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    if (sender.tag == 2) {
        if (_model.couponstate.intValue != 0) {
            return;
        }
    }
    
    //1.详情 2.去使用
    if (self.buttonsCallBack) {
        self.buttonsCallBack(nil, nil, sender.tag);
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
