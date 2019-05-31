//
//  NibCell.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NibCell.h"

@implementation NibCell


- (void)awakeFromNib {
    [super awakeFromNib];

    [self.iconImage.layer removeAllAnimations];
    
//    _textLabel.layer.masksToBounds =YES;
//    _textLabel.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
//    _textLabel.layer.borderWidth = 1.0f;
//    _textLabel.userInteractionEnabled = YES;
//    _textLabel.layer.cornerRadius = _textLabel.frame.size.height / 5;

    
}
#pragma mark ---  动画代理
-(CAKeyframeAnimation *)creatAnimation{
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.delegate =self;
    [keyAnimaion setBeginTime:CACurrentMediaTime()+5];
    keyAnimaion.keyPath = @"transform.translation";
    keyAnimaion.values = @[@(-2),@(2),@(0)];
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.2;
    keyAnimaion.repeatCount = 3;
    return keyAnimaion;
}
//动画结束回调
-(void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    if ([self.textLabel.text isEqualToString:@"摇摇通行"]) {
        [self.iconImage.layer removeAllAnimations];
        [self.iconImage.layer addAnimation:[self creatAnimation] forKey:nil];
    }
}
-(void)startAnimation{
    
    if ([self.textLabel.text isEqualToString:@"摇摇通行"]) {
        [self.iconImage.layer addAnimation:[self creatAnimation] forKey:nil];
    }
}
@end
