//
//  CarStewardCell3.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarStewardCell3.h"

@implementation CarStewardCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    _rightButton.hidden = YES;
}



- (void)setButton {
    
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _leftButton.userInteractionEnabled = NO;
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.userInteractionEnabled = NO;
}
- (void)setButtonYes{
    

    _leftButton.userInteractionEnabled = YES;
//    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _rightButton.userInteractionEnabled = YES;
    [_leftButton setTitleColor:PURPLE_COLOR forState:UIControlStateNormal];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
