//
//  PAUserManager.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAUser.h"

@interface PAUserManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAUserManager)
///---暂未用到
-(PAUser *)user;
-(void)loginWithUserModel:(PAUser *)user;
-(void)logout;
///---暂未用到


/**
 *整合登录接口返回数据到PAUserData模型中
 @param user 登录接口对应的数据模型
 */
-(void)integrationUserData:(PAUser *)user;

/**
 *更新用户数据
 @param userinfo 用户基础信息模型
 */
-(void)updataUserInfo:(PAUserInfo *)userinfo;

/**
 *更新社区用户信息
 @param communityInfo 社区信息
 */
-(void)updataCommunityInfo:(PACommunityInfo *)communityInfo powerArr:(NSArray *)powerArr;

@end
