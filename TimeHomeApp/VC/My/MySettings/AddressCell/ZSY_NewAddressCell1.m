//
//  ZSY_NewAddressCell1.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_NewAddressCell1.h"

@implementation ZSY_NewAddressCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.textColor = TEXT_COLOR;
    _textField.textColor = TEXT_COLOR;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
