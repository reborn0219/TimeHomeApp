//
//  UserTrafficPresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///访客通行网络数据处理部分
#import "BasePresenters.h"
#import "UserVisitor.h"

@interface UserTrafficPresenter : BasePresenters

///获得我设置的访客通信列表
///type  新增类型  0我发起的  1我收到的
+(void)getUserTrafficForupDataWithType:(NSString *)type ViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 获得访客通信详情信息（/traffic/getusertrafficinfo）
 trafficid	通行记录id

 */
+(void)getUserTrafficInfoForID:(NSString *)trafficid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**新增访客统计记录
 residenceid	到访住宅id
 visitdate	访客日期
 card	到访车辆
 power	0 进小区 1 单元门  2 电梯
 visitname	到访人
 visitphone	到访手机号
 leavemsg 留言
 */
+(void)addTrafficForResidenceid:(NSString *)residenceid visitdate:(NSString *)visitdate card:(NSString *)card power:(NSString *)power visitname:(NSString *)visitname visitphone:(NSString *)visitphone leavemsg:(NSString *)leavemsg upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**删除访客通行记录
 Id	住宅id
 */
+(void)removeTrafficForID:(NSString *)Id upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
