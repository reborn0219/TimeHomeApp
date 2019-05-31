//
//  ParkingModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车位数据
#import <Foundation/Foundation.h>

@interface ParkingModel : NSObject
/**
 id	住宅id
 communityname	社区名称
 propertyname	物业名称
 name	车位名称
 expiretime	服务到期时间
 state	是否驶入 1 是  0 否
 type	车位状态0 自用，1共享，2出租，3待销售，99被冻结
 parkingcarid	车位车辆对应记录表id
 carid	驶入车辆id
 card	驶入车辆车牌
 carremarks	车辆备注
 islock	车辆锁定状态
 rentbegindate	租用开始日期
 rentenddate	租用到期日期
 */
@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString * communityname;
@property(nonatomic,copy) NSString * propertyname;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * expiretime;
@property(nonatomic,copy) NSString * state;
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * parkingcarid;
@property(nonatomic,copy) NSString * carid;
@property(nonatomic,copy) NSString * card;
@property(nonatomic,copy) NSString * carremarks;
@property(nonatomic,copy) NSString * islock;
@property (nonatomic, copy) NSString *ownername;
@property(nonatomic,copy) NSString * rentbegindate;
@property(nonatomic,copy) NSString * rentenddate;
///入库时间
@property(nonatomic,copy) NSString * carindate;
/**
 *  驶入门口名称
 */
@property (nonatomic, copy) NSString *ingatename;

@end
