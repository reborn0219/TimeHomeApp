//
//  LogInPresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///登录、获取验证码、验证验证码事件、注册、找回密码处理、修改用户密码接口
#import "BasePresenters.h"

@interface LogInPresenter : BasePresenters

/**
 用户登录接口--
 */
-(void)logInForAcc:(NSString*)acc Pw:(NSString*) passWord upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 发送短信验证码--
 */
-(void)getCAPTCHAForPhoneNum:(NSString*)PhoneNum type:(NSString *) Type andPlatform:(NSString *)platform andAccount:(NSString *)account upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 验证短信验证码接口--
 */
-(void)checkVerificodeForPhoneNum:(NSString*)PhoneNum verificode:(NSString *) verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 用户注册接口--
 */
-(void)registerForPhoneNum:(NSString*)PhoneNum Pw:(NSString*) passWord verificode:(NSString *)verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 用户密码找回接口
 */
-(void)findPWForPhoneNum:(NSString*)PhoneNum Pw:(NSString*) passWord verificode:(NSString *) verificode upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 修改用户密码接口
 */
-(void)changePassword:(NSString*)password upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

///重新登录断判
+(void)ReLogInFor:(NSData *)data;

//TEMP:适配YTKNetwork 重新登录
+(void)ReLogInForYTKNetwork;


-(void)getNewCAPTCHAForPhoneNum:(NSString*)PhoneNum type:(NSString *) Type andPlatform:(NSString *)platform andAccount:(NSString *)account upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
