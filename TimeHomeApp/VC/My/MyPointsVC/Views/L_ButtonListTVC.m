//
//  L_ButtonListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ButtonListTVC.h"

@implementation L_ButtonListTVC

- (IBAction)buttonDidTouch:(UIButton *)sender {
    
    if (self.buttonDidBlock) {
        self.buttonDidBlock();
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = CLEARCOLOR;
    self.contentView.backgroundColor = CLEARCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
