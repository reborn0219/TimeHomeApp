//
//  L_HouseDetailViewController1.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"

/**
 已通过认证
 */
@interface L_HouseDetailViewController1 : THBaseViewController

/**
 0 已通过认证 1 审核中 2 未通过审核 3 已通过认证 共享 4 已通过认证 出租
 */
@property (nonatomic, assign) NSInteger type;

/**
 房产id
 */
@property (nonatomic, copy) NSString *theID;

/**
 小区id
 */
@property (nonatomic, copy) NSString *communityID;

/**
 社区名称
 */
@property (nonatomic, copy) NSString *communityName;

/**
 认证失败的原因
 */
@property (nonatomic, copy) NSString *remark;

/**
 社区地址
 */
@property (nonatomic, strong) NSString *address;
/**
 房间名称
 */
@property (nonatomic, strong) NSString *resiname;

@property (nonatomic, copy) NSString *todateshow;/** 物业费到期等原因 */
@property (nonatomic, copy) NSString *istodateshow;/** 为1时显示上面的字段 */
@property (nonatomic, assign) CertificationType certificationType;

@end
