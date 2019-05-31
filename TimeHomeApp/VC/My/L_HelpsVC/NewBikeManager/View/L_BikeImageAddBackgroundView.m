//
//  L_BikeImageAddBackgroundView.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/12.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeImageAddBackgroundView.h"

@interface L_BikeImageAddBackgroundView ()
{
    CAShapeLayer *border;
}

@end

@implementation L_BikeImageAddBackgroundView

- (void)drawRect:(CGRect)rect {

    border = [CAShapeLayer layer];
    
    border.strokeColor = LINE_COLOR.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"square";
    
    border.lineDashPattern = @[@4, @3];
    
    [self.layer addSublayer:border];

}


@end
