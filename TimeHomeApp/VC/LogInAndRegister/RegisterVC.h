//
//  RegisterVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 注册界面
 **/
#import "BaseViewController.h"

@interface RegisterVC : THBaseViewController
///0.第一步 1.第二步 2.第三步
@property(nonatomic,assign) int setup;
/**
 *  要注册的手机号
 */
@property(nonatomic,strong) NSString * phoneNum;
/**
 *  输入的验证码
 */
@property(nonatomic,strong) NSString * verifiCode;

@end
