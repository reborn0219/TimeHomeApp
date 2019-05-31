//
//  MainTabBars.h
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
  UITabBarController，用于处理各tab视图
 **/

#import <UIKit/UIKit.h>
#import "PAWebViewController.h"

@interface MainTabBars : UITabBarController

/** 统计使用 */
@property (nonatomic, copy) NSString *viewKey;

///底部设置消息标记
-(void)setTabBarBadges;
@property (nonatomic, assign)BOOL showAd;//是否展示广告
@property (nonatomic, strong)PAWebViewController * adWebview;

@end
