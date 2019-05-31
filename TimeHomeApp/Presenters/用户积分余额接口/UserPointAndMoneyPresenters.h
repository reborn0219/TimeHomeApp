//
//  UserPointAndMoneyPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserIntergralLog.h"

@interface UserPointAndMoneyPresenters : BasePresenters

/**
 *  获得用户的积分和余额--
 */
+ (void)getIntegralBalanceUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得积分和等级规则
 */
+ (void)getIntegralRuleUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  用户签到
 */
+ (void)addSignLogUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得今天是否可签到
 */
+ (void)isSignUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  用户签到日志
 */
+ (void)getMonthSignLogMonth:(NSString *)month UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  用户积分日志--
 */
+ (void)getIntegralLogPage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
@end
