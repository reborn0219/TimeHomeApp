//
//  L_MyHouseListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 我的房产列表model
 */
@interface L_MyHouseListModel : NSObject

/**
 社区id
 */
@property (nonatomic, strong) NSString *communityid;
/**
 社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 社区地址
 */
@property (nonatomic, strong) NSString *address;
/**
 房产id 或者申请id
 */
@property (nonatomic, strong) NSString *theID;
/**
 房间名称
 */
@property (nonatomic, strong) NSString *resiname;
/**
 业主手机号
 */
@property (nonatomic, strong) NSString *phone;
/**
 是否业主 1 当前房产业主 0 被授权人
 */
@property (nonatomic, strong) NSString *isowner;
/**
 认证类型：1 房产 0 业主申请
 */
@property (nonatomic, strong) NSString *certtype;
/**
 授权类型 0 业主 1 共享 2 出租
 */
@property (nonatomic, strong) NSString *type;
/**
 0 未认证 1 认证成功 2 认证失败 90 审核中
 */
@property (nonatomic, strong) NSString *state;
/**
 认证失败的原因
 */
@property (nonatomic, strong) NSString *remark;

@property (nonatomic, assign) BOOL isNew; // 判断是否为新社区
@property (nonatomic, copy) NSString *todateshow;/** 物业费到期等原因 */
@property (nonatomic, copy) NSString *istodateshow;/** 为1时显示上面的字段 */

@end
