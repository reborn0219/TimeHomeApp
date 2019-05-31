//
//  ReservePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///查看发布过的维修进度评论 投诉数据
#import "BasePresenters.h"
#import "UserReserveInfo.h"
#import "UserReserveLog.h"
#import "UserComplaint.h"

@interface ReservePresenter : BasePresenters

/**
 获得我的保修单（/reserve/getuserreserve）
 page	页码数
 */
+(void)getUserReserveForPage:(NSString *) page upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/** 查看维修进度日志
 获得我的保修单日志（/reserve/getreservelog）
 reserveid	维修记录id
 */
+(void)getReserveLogForReserveid:(NSString *) reserveid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 评价在线保修（/reserve/ evaluatereserve）
 reserveid	在线报修id
 evaluatelevel	评价等级 1 非常满意 2 满意 3 不满意
 evaluate	评价内容
 */
+(void)evaluateReserveForReserveid:(NSString *) reserveid evaluatelevel:(NSString *)evaluatelevel evaluate:(NSString *)evaluate upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 预约延期短信（/reserve/remindmsg）
 reserveid	在线报修id
 */
-(void)remindMsgForReserveid:(NSString *) reserveid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;



/**
 获得我的物业投诉（/complaint/getusercomplaint）
 page	页码数
 */
+(void)getUserComplaintForPage:(NSString *) page upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
