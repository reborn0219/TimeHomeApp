//
//  L_MyInfoThreeButtonTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyInfoThreeButtonTVC.h"

@implementation L_MyInfoThreeButtonTVC


/**
 我的发布点击
 */
- (IBAction)threeButtonDidTouch:(UIButton *)sender {

    if (self.threeButtonDidTouchCallBack) {
        self.threeButtonDidTouchCallBack(sender.tag);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
