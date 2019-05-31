//
//  UserInfoMotifyPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "THTags.h"

@interface UserInfoMotifyPresenters : BasePresenters

/**
 *  获得用户标签列表--
 */
+ (void)getUserSelfTagUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得系统标签列表--
 */
+ (void)getSystemSelfTagUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  添加用户系统标签--
 */
+ (void)addSelfTagName:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存用户设置的标签--
 */
+ (void)saveUserSelfTagids:(NSArray *)tagArray UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  修改用户备注
 */
+ (void)saveRemarkNameUserID:(NSString *)userid name:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  添加用户举报
 */
+ (void)addUserReportUserID:(NSString *)userid type:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
