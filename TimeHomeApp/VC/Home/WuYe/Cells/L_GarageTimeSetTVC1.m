//
//  L_GarageTimeSetTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_GarageTimeSetTVC1.h"

@implementation L_GarageTimeSetTVC1

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (IBAction)switchValueChangedTouch:(UISwitch *)sender {
    
    if (self.switchOnCallBack) {
        self.switchOnCallBack(sender.isOn);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
