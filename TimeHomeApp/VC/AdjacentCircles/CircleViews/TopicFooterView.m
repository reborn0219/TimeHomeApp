//
//  TopicFooterView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "TopicFooterView.h"

@implementation TopicFooterView

- (IBAction)nextBtnAction:(id)sender {
    
    self.block(nil,SucceedCode);
    [self.nextBtn.imageView.layer removeAllAnimations];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    animation.duration = 0.8; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:-2 * M_PI]; // 终止角度
    
    // 添加动画
    [self.nextBtn.imageView.layer addAnimation:animation forKey:@"rotate-layer"];
}
- (void)awakeFromNib {
    [super awakeFromNib];

    
}

@end
