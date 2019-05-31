//
//  L_MoneyAndCountTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MoneyAndCountTVC.h"

@implementation L_MoneyAndCountTVC

- (IBAction)moneyAndCountButtonDidTouch:(UIButton *)sender {
    
    if (self.twoButtonClickCallBack) {
        self.twoButtonClickCallBack(sender.tag);
    }
//    if (sender.tag == 1) {
//        //余额
//
//    }else {
//        //积分
//    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
