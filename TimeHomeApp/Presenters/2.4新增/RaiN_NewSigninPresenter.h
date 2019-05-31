//
//  RaiN_NewSigninPresenter.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/7/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface RaiN_NewSigninPresenter : BasePresenters


/**
 获得用户签到详情（/signlog/getusersign）
 */
+ (void)getUserSignWithupdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得用户的签到设置（/signset/getusersignset）
 */
+ (void)getUserSignsetWithupdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 保存用户签到设置（/signset/saveusersignset）

 @param isdailypopups 是否悬浮设置0否1是
 @param issuspendremind 是否每日弹窗 0否1是
 */
+ (void)saveUsersignsetWithIsdailypopups:(NSString *)isdailypopups andIssuspendremind:(NSString *)issuspendremind updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 签到规则（/signset/getsignrule）
 */
+ (void)getSignruleWithupdataViewBlock:(UpDateViewsBlock)updataViewBlock;
@end
