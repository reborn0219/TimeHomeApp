//
//  SignUpCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/7/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SignUpCell.h"

@implementation SignUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _rightSwitch.onTintColor = kNewRedColor;
}
- (IBAction)switchValueChange:(id)sender {
    UISwitch *theSwitch = sender;
    if (self.switchBlock) {
        self.switchBlock(theSwitch.isOn);
        
    }
}



@end
