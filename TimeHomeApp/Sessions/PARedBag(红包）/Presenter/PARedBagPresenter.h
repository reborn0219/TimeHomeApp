//
//  PARedBagPresenter.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

typedef NS_ENUM(NSUInteger, AD_TYPE) {
    AD_TYPE_REDBAG = 0,//红包
    AD_TYPE_ENVELOPE//优惠券
};

typedef NS_ENUM(NSUInteger, AD_RECEIVE_TYPE) {
    AD_RECEIVE_TYPE_SHAKE = 0//摇一摇
};

@interface PARedBagPresenter : BasePresenters

 /*
  获取红包
  type:0摇摇通行
  communityid:社区id
  */
+ (void)getRedEnvelopeWithType:(AD_RECEIVE_TYPE)type andCommunityid:(NSString *)communityid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 抢(领取)红包
 userticketid:领取卡卷记录id
 */
+ (void)receiveRedEnvelopeWithOrderId:(NSString*)orderId Userticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 查看红包详情
 Userticketid:领取卡卷记录id
 type:卡券类型:0红包 1卡券
 */
+ (void)getRedEnvlopeinfoWithUserticketid:(NSString *)userticketid type:(AD_TYPE)type updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 查看红包广告信息
 Userticketid:领取卡卷记录id
 type:卡券类型:0红包 1卡券
 */
+ (void)showAdInfoWithUserticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 查看我的红包和优惠券
 type:卡券类型:0红包 1卡券
 */
+ (void)getRedEnvelopeListWithType:(AD_TYPE)type UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
