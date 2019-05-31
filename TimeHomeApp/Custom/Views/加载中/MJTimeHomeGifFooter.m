//
//  MJTimeHomeGifFooter.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MJTimeHomeGifFooter.h"

@implementation MJTimeHomeGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (int i = 6; i>=1; i--) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载汽车-%d", i]];
//        [refreshingImages addObject:image];
//    }
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    
//    // 设置文字
//    //    [self setTitle:@"加载中..." forState:MJRefreshStatePulling];
//    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    
//    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
//    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStatePulling];
//    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStateWillRefresh];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 指示器 gif图的frame
    
//    self.gifView.contentMode = UIViewContentModeScaleToFill;
//    
//    self.gifView.mj_x = self.mj_w/2 - 50 - 45;
//    self.gifView.mj_y = self.mj_h/2 - 14;
//    self.gifView.mj_w = 45;
//    self.gifView.mj_h = 28;
    
    //    self.gifView.mj_x = self.mj_w/2 - 5 - 45;
    //    self.gifView.mj_y = self.mj_h/2 - 14;
    //    self.gifView.mj_w = 45;
    //    self.gifView.mj_h = 28;
    //
    //    if (self.state == MJRefreshStatePulling || self.state == MJRefreshStateRefreshing) {
    //        self.stateLabel.mj_x = self.mj_w/2;
    //        self.stateLabel.textAlignment = NSTextAlignmentLeft;
    //    }else {
    //        self.stateLabel.textAlignment = NSTextAlignmentCenter;
    //        self.stateLabel.mj_x = 0;
    //    }
    
}

@end
