//
//  L_NewMyHouseListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 2.5.0 我的房产
 */
@interface L_NewMyHouseListViewController : THBaseViewController

@property (nonatomic,copy)NSString *iscurrentVC;

/**
 需要刷新
 */
- (void)needRefreshData;

/**
 1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;

@end
