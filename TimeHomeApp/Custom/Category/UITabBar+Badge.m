//
//  UITabBar+Badge.m
//  YouLifeApp
//
//  Created by us on 15/9/9.
//  Copyright © 2015年 us. All rights reserved.
//

#import "UITabBar+Badge.h"

@implementation UITabBar (Badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 1000 + index;
    badgeView.layer.cornerRadius = 3;//圆形
    badgeView.backgroundColor = UIColorFromRGB(0xab2121);//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.7) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 6, 6);//圆形大小为10
    [self addSubview:badgeView];
    
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}


//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 1000+index) {
            [subView removeFromSuperview];
        }
    }
}


@end
