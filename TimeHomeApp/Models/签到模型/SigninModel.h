//
//  SigninModel.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/24.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigninModel : NSObject


/**
 
	issign = 1,
	isactset = 1,
	useropentimes = "",
	remainingdays = 0,
	monthdays = 31,
	remainluckdrawtimes = 5,
	readytime = 1,
	positions = "1,2,",
	monthsignnum = 1,
	frequency = 1
*/
//是否签到
@property (nonatomic, copy) NSString * issign;
//累计签到天数
@property (nonatomic, copy) NSString * monthsignnum;
//当月天数
@property (nonatomic, copy) NSString * monthdays;
//是否有抽奖
@property (nonatomic, copy) NSString * isactset;
//当月宝盒位置
@property (nonatomic, copy) NSString * positions;
//当前可用抽奖次数
@property (nonatomic, copy) NSString * remainluckdrawtimes;
//抽奖剩余天数
@property (nonatomic, copy) NSString * remainingdays;
//用户打开当月的那几个宝箱
@property (nonatomic, copy) NSString * useropentimes;
//准备抽奖的宝箱位置-第几个宝箱
@property (nonatomic, copy) NSString * readytime;
//抽奖对应签到的累计天数 默认为0
@property (nonatomic, copy) NSString * frequency;
//每天的第一次签到
@property (nonatomic, copy) NSString * isfirst;

@end
