//
//  PALockCarModel.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@interface PALockCarModel : NSObject

@property (nonatomic, copy) NSString *tenantId;//租户ID
@property (nonatomic, copy) NSString *communityId;//社区ID
@property (nonatomic, copy) NSString *spaceId;//车位ID
@property (nonatomic, copy) NSString *carId;//关联车牌ID
@property (nonatomic, copy) NSString *carNo;//关联车牌
@property (nonatomic, copy) NSString *ownerName;//车主姓名
@property (nonatomic, copy) NSString *isInLib;//是否在库 0否 1是
@property (nonatomic, copy) NSString *inTime;//入口时间
@property (nonatomic, copy) NSString *autoLockCarSwitch;//自动锁车开关 0 关 1 开启
@property (nonatomic, copy) NSString *autoLockCarTime;//自动锁车时间
@property (nonatomic, copy) NSString *autoLockCarRule;//自动锁车重复规则
@property (nonatomic, copy) NSString *autoUnlockCarSwitch;//自动解锁开关 0 关 1 开启
@property (nonatomic, copy) NSString *autoUnlockCarTime;//自动解锁时间
@property (nonatomic, copy) NSString *autoUnlockCarRule;//自动解锁重复规则
@property (nonatomic, copy) NSString *createTime;//添加时间
@property (nonatomic, copy) NSString *times;//时间戳
@property (nonatomic, copy) NSString *flag;//状态 0正常 -1删除 9未激活
@property (nonatomic, copy) NSString *opId;//添加人
@property (nonatomic, copy) NSString *isVisitor;//是否为访客车辆 0否，1是
@property (nonatomic, copy) NSString *state;//该车辆对应的车位的状态 0 空闲 1占用 2 停放
@property (nonatomic, copy) NSString *lockstate;///锁车状态




@end
