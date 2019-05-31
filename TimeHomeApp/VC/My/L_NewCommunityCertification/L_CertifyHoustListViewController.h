//
//  L_CertifyHoustListViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 社区认证 有房产车位列表
 */
@interface L_CertifyHoustListViewController : THBaseViewController

/**
 type == 1 从完善资料过来
 */
@property (nonatomic, assign) NSInteger type;

/**
 1.从“我的房产-选择小区”进来 从我的房产列表-未通过审核-重新认证-进来 2.从“我的房产列表-马上认证”进来 3.从“我的房产-特权”进来 4.首页banner跳转 5.从首页摇摇通行认证提交进来 从baseVC进来 6.任务版
 */
@property (nonatomic, assign) NSInteger fromType;

/**
 房产列表
 */
@property (nonatomic, strong) NSArray *houseArr;
/**
 车位列表
 */
@property (nonatomic, strong) NSArray *carArr;

/**
 社区名称
 */
@property (nonatomic, copy) NSString *communityName;
/**
 社区id
 */
@property (nonatomic, copy) NSString *communityID;

@end
