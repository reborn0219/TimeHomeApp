//
//  L_AddBikeFooterView.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_AddBikeFooterView.h"

@implementation L_AddBikeFooterView

+(L_AddBikeFooterView *)instanceAddBikeFooterView {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"L_AddBikeFooterView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)twoButtonsDidTouch:(UIButton *)sender {
    
    //1.添加感应条码 2.提交
    if (self.twoButtonDidTouchCallBack) {
        self.twoButtonDidTouchCallBack(sender.tag);
    }
}

@end
