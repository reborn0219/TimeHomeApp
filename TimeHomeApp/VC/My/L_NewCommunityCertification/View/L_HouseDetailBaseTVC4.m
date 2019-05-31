//
//  L_HouseDetailBaseTVC4.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailBaseTVC4.h"

@implementation L_HouseDetailBaseTVC4

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    //1. 移除 2.续租
    if (self.selectBlock) {
        self.selectBlock(nil, nil, sender.tag);
    }
}

- (void)setModel:(L_PowerListModel *)model {
    
    _model = model;
    
    _name_Label.text = [XYString IsNotNull:model.remarkname];
    _phoneNum_Label.text = [XYString IsNotNull:model.phone];
    
    NSString *beginDate = @"";
    NSString *endDate = @"";
    
    if (model.rentbegindate.length > 10) {
        beginDate = [model.rentbegindate substringToIndex:10];
    }else {
        beginDate = [XYString IsNotNull:model.rentbegindate];
    }
    
    if (model.rentenddate.length > 10) {
        endDate = [model.rentenddate substringToIndex:10];
    }else {
        endDate = [XYString IsNotNull:model.rentenddate];
    }
    
    if ([XYString isBlankString:beginDate] && [XYString isBlankString:endDate]) {
        _rentTime_Label.text = @"";
    }else {
        _rentTime_Label.text = [NSString stringWithFormat:@"%@ 至 %@",beginDate,endDate];
    }

//    _rentTime_Label.text = @"2012-02-06 至 2018-08-06";
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_rentTime_Label.frame);
    
    model.height = rectY + 15;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _rentTime_Label.text = @"";
    _rentTime_Label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 31 - 22 - 20 - 35 - 12 - 38;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
