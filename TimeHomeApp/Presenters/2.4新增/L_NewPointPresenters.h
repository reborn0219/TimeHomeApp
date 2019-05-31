//
//  L_NewPointPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "L_RecordListModel.h"
#import "L_CouponListModel.h"

/**
 新版积分相关接口
 */
@interface L_NewPointPresenters : BasePresenters

/**
 上传积分信息（/integral/upduserintebytype）
 
 @param type 18分享帖子 19分享活动 20发帖子 21删除帖子
 @param content 18分享帖子 19分享活动 20发帖子 21删除帖子
 @param costinte 消耗积分，默认为0；因type为14，15，16没有规划，暂定用该字段为积分消耗分数，其他类型都为0
 @param updataViewBlock
 */
+ (void)updUserIntebyTypeWithType:(NSInteger)type content:(NSString *)content costinte:(NSString *)costinte updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得个人每日任务和首次任务状态列表（/integral/gettaskstate）
 
 @param types ”1,201,18,2,12,13,20,”类型，每日任务：对应的types 1每日签到 201发表帖子（每日任务的） 18分享帖子
 新手任务：
 2完善个人资料 12完善二轮车防盗资料 13查看新手指南 20新帖发布（新手任务的）
 
 @param updataViewBlock
 */
+ (void)getTaskStateWithTypes:(NSString *)types updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得用户兑换的所有的兑换券（/merchantgoodslog/getgoodsloglist）
 
 @param state 状态 0为已兑换但是没有使用的 -1过期  （1已使用即已核销的）
 @param isexchange 是否赠予 0否 1是
 @param updataViewBlock
 */
+ (void)getGoodsLoglistWithState:(NSString *)state isexchange:(NSInteger)isexchange updataViewBlock:(UpDateViewsBlock)updataViewBlock ;

/**
 赠予礼券（/merchantgoodslog/presentcertificate）
 
 @param userid  要赠予的用户id
 @param id      赠予券id
 @param message 内容
 @param updataViewBlock
 */
+ (void)persentCertificateWithUserid:(NSString *)userid theid:(NSString *)theid message:(NSString *)message updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得我的票券信息（/merchantgoodslog/getmycertificate）
 
 @param type  类型 2的时候为赠予券 coupontype 9代表商城兑换券
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getMyCertificateWithType:(NSString *)type coupontype:(NSString *)coupontype updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得我的中奖记录（/drawrecord/getuserrecordlist）
 
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getUserRecordListUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得用户商城兑换券记录（/signset/getusercouponlist）
 
 @param token 登录令牌
 @param updataViewBlock
 */
+ (void)getUserCouponListUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
