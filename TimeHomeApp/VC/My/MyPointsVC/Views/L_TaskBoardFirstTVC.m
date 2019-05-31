//
//  L_TaskBoardFirstTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_TaskBoardFirstTVC.h"

@implementation L_TaskBoardFirstTVC

- (void)setModel:(L_TaskModel *)model {
    
    _model = model;
    
    if (model.isfinished.integerValue == 1) {
        _buttonBgView.backgroundColor = NEW_GRAY_COLOR;
//        _buttonBottomLabel.text = @"已完成";
    }
    if (model.isfinished.integerValue == 0) {
        _buttonBgView.backgroundColor = NEW_BLUE_COLOR;
    }
    
//    if (model.type.integerValue == 1) {
//        if (![XYString isBlankString:model.todayinte]) {
//            self.countLabel.text = [NSString stringWithFormat:@"+%@",model.todayinte];
//        }
//    }
    
}

- (IBAction)buttonDidTouch:(UIButton *)sender {
    if (self.buttonDidTouchBlock) {
        self.buttonDidTouchBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _buttonBgView.layer.cornerRadius = 5.f;
    _buttonBgView.clipsToBounds = YES;
    
    _buttonBgView.backgroundColor = NEW_GRAY_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
