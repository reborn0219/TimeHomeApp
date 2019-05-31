//
//  ChangCityHreadCell.m
//  TimeHomeApp
//
//  Created by us on 16/3/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ChangCityHreadCell.h"

@implementation ChangCityHreadCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ------事件处理------
- (IBAction)btn_OneEvent:(UIButton *)sender {
    if(_eventBlock)
    {
        _eventBlock(nil,sender,0);
    }
}
- (IBAction)btn_TwoEvent:(UIButton *)sender {
    if(_eventBlock)
    {
        _eventBlock(nil,sender,1);
    }
}
- (IBAction)btn_ThreeEvent:(UIButton *)sender {
    if(_eventBlock)
    {
        _eventBlock(nil,sender,2);
    }
}
- (IBAction)btn_FourEvent:(UIButton *)sender {
    if(_eventBlock)
    {
        _eventBlock(nil,sender,3);
    }
}

@end
