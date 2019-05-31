//
//  CommunityManagerPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/30.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "OwnerResidence.h"
#import "OwnerResidenceUser.h"

@interface CommunityManagerPresenters : BasePresenters

/**
 *  获得我的小区
 */
+ (void)getUserCommunityUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  提交认证审核
 */
+ (void)addCommcertificationName:(NSString *)name buiding:(NSString *)buiding number:(NSString *)number UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  切换社区
 */
+ (void)changeCommunityCommunityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  按照名称搜索社区
 */
+ (void)getSearchCommunityName:(NSString *)name cityid:(NSString *)cityid page:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得附近社区
 */
+ (void)getNearCommunityName:(NSString *)name cityid:(NSString *)cityid page:(NSString *)page positionx:(NSString *)positionx positiony:(NSString *)positiony UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得社区所有的物业列表
 */
+ (void)getCompropertyUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得社区物业联系电话
 */
+ (void)getPropertyPhoneUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得社区公告信息
 */
+ (void)getTopPropertyNoticeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  分页获得物业公告
 */
+ (void)getPropertyNoticePage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  设置公告已读
 */
+ (void)readNoticeID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得个人拥有住宅信息
 */
+ (void)getUserResidenceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得业主授权房产信息
 */
+ (void)getOwnerResidenceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存住宅授权信息
 */
+ (void)saveResidencePowerPowertype:(NSString *)powertype residenceid:(NSString *)residenceid phone:(NSString *)phone name:(NSString *)name rentbegindate:(NSString *)rentbegindate rentenddate:(NSString *)rentenddate UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  移除住宅授权信息
 */
+ (void)deleteResidencePowerPowerid:(NSString *)powerid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  续租住宅授权信息
 */
+ (void)renewResidencePowerID:(NSString *)theid begindate:(NSString *)begindate enddate:(NSString *)enddate UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得蓝牙权限信息
 */
+ (void)getUserBluetoothUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  验证选中车牌是否可以驶入
 */
+ (void)getCardCanIn:(NSString *)carid
     upDataViewBlock:(UpDateViewsBlock)updataViewBlock;;

/**
 *  获取关口的蓝牙权限
 */
+ (void)getGatBlueToothUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获取电梯定位之后的周围的人的权限
 */
+ (void)getLiftBlueToothWithAreaID:(NSString *)areaID
                   UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获取电梯定位连接操作成功返回
 */
+ (void)getLiftBlueToothWithPid:(NSString *)PID
                UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  根据社区id获得社区物业联系电话
 */
+ (void)getPropertyPhoneWithCommunityID:(NSString *)communityID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 添加摇一摇通行记录

 @param bluename 蓝牙名称
 @param type 摇一摇类型
 @param updataViewBlock 回调
 */
+(void)addTrafficlog:(NSString *)bluename withType:(NSString *)type Block:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得常出入社区
 */
+ (void)getUserCommonCommunityWithCityid:(NSString *)cityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
