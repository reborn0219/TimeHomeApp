//
//  graphView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/8/12.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "graphView.h"

#define PI 3.14159265358979323846

@implementation graphView

// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//


//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        //[self setNeedsDisplay];
//        
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.lineCap = @"round";
//        shapeLayer.lineJoin = @"round";
//        shapeLayer.lineWidth = 6;
//        shapeLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
//        shapeLayer.strokeStart = 0;
//        shapeLayer.strokeEnd = 1;
//        shapeLayer.path = aPath.CGPath;
//        [self.layer addSublayer:shapeLayer];
//        
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect {
    
    for (int i=0; i<[_pointXArray count]; i++) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGPoint point = CGPointMake([_pointXArray[i] floatValue], [_pointYArray1[i] floatValue]);
//        CGContextFillEllipseInRect(ctx, CGRectMake(point.x-3.5, point.y-3.5, 7, 7));
//        CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0x007bc4).CGColor);
//        CGContextFillPath(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x007bc4).CGColor);//画笔线的颜色
        CGContextSetLineWidth(ctx, 0.5);//线的宽度
        //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(ctx, point.x, point.y, 3.5, 0, 2*PI, 0); //添加一个环
        CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
        
        CGContextSetFillColorWithColor(ctx, UIColorFromRGB(0x007bc4).CGColor);//填充颜色
        CGContextAddArc(ctx, point.x, point.y, 2.0, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(ctx, kCGPathFill);//绘制填充
        
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor) ;//设置填充颜色
        
        UIFont  *font = [UIFont boldSystemFontOfSize:10.0];//设置
        //[[NSString stringWithFormat:@"%@",_pointYArray1[i]] drawInRect:CGRectMake(point.x - 7.5, point.y - 20, 15, 10) withFont:font];
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.alignment = NSTextAlignmentCenter;//居中
        
        [[NSString stringWithFormat:@"%@",_pointValueArray[i]] drawInRect:CGRectMake(point.x - 7.5, point.y - 20, 15, 15) withAttributes: @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph}];
    }
    
    UIColor *color = UIColorFromRGB(0x007bc4);
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
 
    for(int i=0; i<[_pointXArray count]-1; i++){
        
        CGPoint firstPoint = CGPointMake([_pointXArray[i] floatValue], [_pointYArray1[i] floatValue]);
        
        CGPoint secondPoint = CGPointMake([_pointXArray[i+1] floatValue], [_pointYArray1[i+1] floatValue]);
        [aPath moveToPoint:firstPoint];
        
        //   核心方法ios <wbr>如何根据坐标点画曲线
        [aPath addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
    }
    [aPath stroke];
}

@end
