//
//  RaiN_LineXuXianView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/2.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_LineXuXianView.h"

@implementation RaiN_LineXuXianView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();//获取绘图用的图形上下文
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充色设置成
    CGFloat lengths[] = {4};
    CGContextSetLineDash(context, 4, lengths,1);
    
    CGContextFillRect(context,self.bounds);//把整个空间用刚设置的颜色填充
    //上面是准备工作，下面开始画线了
    
    CGContextSetStrokeColorWithColor(context, (UIColorFromRGB(0xfe3f3e)).CGColor);//设置线的颜色
    CGContextMoveToPoint(context,0,0);//画线的起始点位置
    CGContextAddLineToPoint(context,self.frame.size.width,0);//画第一条线的终点位置
    
    CGContextStrokePath(context);//把线在界面上绘制出来
}


@end
