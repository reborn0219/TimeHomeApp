//
//  L_AddHouseForCertifyCommunityVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 社区认证添加房产
 */
@interface L_AddHouseForCertifyCommunityVC : THBaseViewController

@property (nonatomic,copy)NSString *pushType;//0注册

/**
 社区名称
 */
@property (nonatomic, copy) NSString *communityName;
/**
 社区id
 */
@property (nonatomic, copy) NSString *communityID;

/**
   1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;

@end
