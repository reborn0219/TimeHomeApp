//
//  RoundButton.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RoundButton.h"

IB_DESIGNABLE
@implementation RoundButton

- (void)setBCornerRadius:(CGFloat)bCornerRadius {
    _bCornerRadius = bCornerRadius;
    self.layer.cornerRadius  = bCornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBcolor:(UIColor *)bcolor{
    _bcolor = bcolor;
    self.layer.borderColor = _bcolor.CGColor;
}

- (void)setBwidth:(CGFloat)bwidth {
    _bwidth = bwidth;
    self.layer.borderWidth = _bwidth;
}

@end
