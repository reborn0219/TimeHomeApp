//
//  L_MyOrderTwoButtonTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyOrderTwoButtonTVC.h"

@interface L_MyOrderTwoButtonTVC ()

@end

@implementation L_MyOrderTwoButtonTVC
- (IBAction)twoButtonDidTouch:(UIButton *)sender {
    
    if (self.twoButtonDidClickBlock) {
        self.twoButtonDidClickBlock(sender.tag);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
