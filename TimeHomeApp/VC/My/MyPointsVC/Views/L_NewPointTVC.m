//
//  L_NewPointTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewPointTVC.h"

@implementation L_NewPointTVC

- (void)setModel:(UserIntergralLog *)model {
    
    _model = model;
    
    NSString *dateString = @"";
    if (![XYString isBlankString:model.systime]) {
        if (model.systime.length > 19) {
            dateString = [model.systime substringToIndex:19];
        }else {
            dateString = model.systime;
        }
    }
    _timeLabel.text = dateString;
    
    NSString *intergralString = [NSString stringWithFormat:@"%@",model.integral];
    
    if (intergralString.floatValue < 0) {
        _pointLabel.text = [NSString stringWithFormat:@"%@",model.integral];
        _pointLabel.textColor = kNewRedColor;
    }else {
        _pointLabel.text = [NSString stringWithFormat:@"+%@",model.integral];
        _pointLabel.textColor = NEW_BLUE_COLOR;
    }
    
    _contentLabel.text = [XYString IsNotNull:model.remarks];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_timeLabel.frame);
    
    model.height = rectY + 17;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
