//
//  MJTimeHomeGifHeader.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MJTimeHomeGifHeader.h"

@implementation MJTimeHomeGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"新版刷新加载图片%d", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"新版刷新加载图片%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:idleImages duration:0.4 forState:MJRefreshStatePulling];
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:0.4 forState:MJRefreshStateRefreshing];

    // 设置文字
    [self setTitle:@"别报警，放开我" forState:MJRefreshStateIdle];
    [self setTitle:@"别报警，放开我" forState:MJRefreshStatePulling];
    [self setTitle:@"我们正在赶来..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"别报警，放开我" forState:MJRefreshStateWillRefresh];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    
}
//- (void)layoutSubviews {
//    
//    [super layoutSubviews];

    // 指示器 gif图的frame
    
//    self.gifView.contentMode = UIViewContentModeScaleToFill;
    
    //    self.gifView.mj_x = self.mj_w/2 - 5 - 45;
    //    self.gifView.mj_y = self.mj_h/2 - 14;
    //    self.gifView.mj_w = 45;
    //    self.gifView.mj_h = 28;
    
    //    self.stateLabel.mj_x = self.mj_w/2;
    //    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    
//    self.gifView.mj_x = self.mj_w/2 - 50 - 45;
//    self.gifView.mj_y = self.mj_h/2 - 14;
//    self.gifView.mj_w = 45;
//    self.gifView.mj_h = 28;
    
//}

@end
