//
//  L_BalanceListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/11/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 分页获得我的余额记录model
 */
@interface L_BalanceListModel : NSObject

/**
 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 内容
 */
@property (nonatomic, strong) NSString *content;
/**
 类型 10001充值 10002提现
 */
@property (nonatomic, strong) NSString *type;
/**
 类型图标
 */
@property (nonatomic, strong) NSString *typepic;
/**
 金额
 */
@property (nonatomic, strong) NSString *money;
/**
 当前余额
 */
@property (nonatomic, strong) NSString *balance;
/**
 发送时间
 */
@property (nonatomic, strong) NSString *systime;

@end
