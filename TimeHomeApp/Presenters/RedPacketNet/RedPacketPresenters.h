//
//  RedPacketPresenters.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/11/3.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface RedPacketPresenters : BasePresenters

/**
 获取广告（红包）
 */
+ (void)getRedEnvelopeWithType:(NSString *)type andCommunityid:(NSString *)communityid updataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 展现广告（车库消息需要调用）
 */
+ (void)showAdvertWithUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 抢(领取)红包
 */
+ (void)receiveRedEnvelopeWithUserticketid:(NSString *)userticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 查看红包详情
 */
+ (void)getRedEnvlopeinfoWithUserticketid:(NSString *)ticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 分享红包
 */
+ (void)shareRedEnvelopeWithUserticketid:(NSString *)advid andTicketid:(NSString *)ticketid updataViewBlock:(UpDateViewsBlock)updataViewBlock;
@end
