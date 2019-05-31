//
//  YYProgressView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "YYProgressView.h"

@interface YYProgressView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YYProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        _shapeLayer = [CAShapeLayer layer];
//        _shapeLayer.frame = self.bounds;
//        
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
//        
//        _shapeLayer.path = path.CGPath;
//        
//        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
//        _shapeLayer.lineWidth = 1.f;
//        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
//        _shapeLayer.strokeEnd = 0.f;
//        
//        [self.layer addSublayer:_shapeLayer];
        
        self.backgroundColor = CLEARCOLOR;
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = CLEARCOLOR.CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, WidthSpace(236)-10, WidthSpace(236)-10)];
    
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath stroke];

    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.path = aPath.CGPath;
    shapeLayer.fillColor = CLEARCOLOR.CGColor;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1);
    shapeLayer.autoreverses = NO;
    animation.duration = 10.0;
    
    // 设置layer的animation
    [shapeLayer addAnimation:animation forKey:nil];
    
}

//@synthesize startValue = _startValue;
//- (void)setStartValue:(CGFloat)startValue {
//    _startValue = startValue;
//    _shapeLayer.strokeEnd = startValue;
//}
//- (CGFloat)startValue {
//    return _startValue;
//}
//@synthesize lineWidth = _lineWidth;
//- (void)setLineWidth:(CGFloat)lineWidth {
//    _lineWidth = lineWidth;
//    _shapeLayer.lineWidth = lineWidth;
//}
//-(CGFloat)lineWidth {
//    return _lineWidth;
//}
//@synthesize lineColor = _lineColor;
//-(void)setLineColor:(UIColor *)lineColor {
//    _lineColor = lineColor;
//    _shapeLayer.strokeColor = lineColor.CGColor;
//}
//-(UIColor *)lineColor {
//    return _lineColor;
//}
//@synthesize value = _value;
//- (void)setValue:(CGFloat)value {
//    _value = value;
//    _shapeLayer.strokeEnd = value;
//}
//-(CGFloat)value {
//    return _value;
//}

@end
