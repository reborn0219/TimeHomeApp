//
//  CarStewardCell5.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarStewardCell5.h"

@implementation CarStewardCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    _littleView.backgroundColor = BLACKGROUND_COLOR;
    _littleView.layer.cornerRadius = 4.f;
//    _littleView.sd_layout.leftSpaceToView(_leftLabel,9).topSpaceToView(self.contentView,34).widthIs(8).heightIs(21);

    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _rightButton.layer.masksToBounds =YES;
    _rightButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _rightButton.layer.borderWidth = 1.0f;
    
    _rightButton.layer.cornerRadius = _rightButton.frame.size.height / 2;
    
}


- (void)viewHidden {
    
    _littleView.hidden = YES;
    _stateLabel.hidden = YES;
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.userInteractionEnabled = NO;
}
- (void)viewShow {
    
    _littleView.hidden = NO;
    _stateLabel.hidden = NO;
    [_rightButton setTitleColor:PURPLE_COLOR forState:UIControlStateNormal];
    _rightButton.userInteractionEnabled = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
