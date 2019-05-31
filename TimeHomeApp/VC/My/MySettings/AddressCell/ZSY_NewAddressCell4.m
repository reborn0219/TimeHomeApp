//
//  ZSY_NewAddressCell4.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_NewAddressCell4.h"

@implementation ZSY_NewAddressCell4

- (void)awakeFromNib {
    [super awakeFromNib];
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
