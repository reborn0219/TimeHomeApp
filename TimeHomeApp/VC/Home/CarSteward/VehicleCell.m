//
//  VehicleCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VehicleCell.h"

@implementation VehicleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.cornerRadius = 25;
    self.btn.layer.borderWidth = 3;
    self.btn.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
}
-(void)binding:(BOOL)b
{
    if (b) {
        self.btn.backgroundColor = UIColorFromRGB(0x2B85C7);
        self.titleLb.textColor = UIColorFromRGB(0x2B85C7);
        [self.btn setTitle:@"已绑定" forState:UIControlStateNormal];
    }else
    {
        self.btn.backgroundColor = UIColorFromRGB(0xC2203C);
        self.titleLb.textColor = UIColorFromRGB(0xC2203C);
        [self.btn setTitle:@"未绑定" forState:UIControlStateNormal];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
