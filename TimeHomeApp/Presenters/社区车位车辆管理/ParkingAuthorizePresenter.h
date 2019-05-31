//
//  ParkingAuthorizePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车位授权管理
#import "BasePresenters.h"
#import "ParkingOwner.h"

@interface ParkingAuthorizePresenter : BasePresenters

/**
 获得业主授权车位信息（/parkingarea/getownerparkingarea）
 */
+(void)getOwnerParkingAreaForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 保存车位授权信息（/parkingarea/saveparkingareapower）
 powertype	授权方式 0 共享 1 租用
 parkingareaid	需要分配的车位id
 phone	需要分配的用户的手机号
 name	用户备注名
 rentbegindate	租用时开始时间
 rentenddate	租用时结束时间
 */
+(void)saveParkingPowerForType:(NSString *) powertype parkingareaid:(NSString *)parkingareaid phone:(NSString *)phone name:(NSString *)name rentbegindate:(NSString *)rentbegindate rentenddate:(NSString *)rentenddate upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 移除车位授权信息（/parkingarea/deleteparkingareapower）
 powerid	权限记录id
 */
+(void)deleteParkingareaPowerForPowerid:(NSString *)powerid  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 续租车位授权信息（/parkingarea/renewparkingareapower）
 id	车位id
 begindate	租用开始时间
 enddate	租用到期时间
 */
+(void)renewParkingareaPowerForID:(NSString *)ID begindate:(NSString *)begindate enddate:(NSString *)enddate upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
