//
//  ZSY_NewAddressCell2.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_NewAddressCell2.h"

@implementation ZSY_NewAddressCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = TEXT_COLOR;
    _textField.enabled = NO;
    if (_textField.text.length > 0) {
        _showLabel.hidden = YES;
    }
    _textField.minimumFontSize= 1;
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.textColor = TEXT_COLOR;
}
- (IBAction)clickButton:(id)sender {
    if(self.block)
    {
        self.block(nil,nil,2);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
