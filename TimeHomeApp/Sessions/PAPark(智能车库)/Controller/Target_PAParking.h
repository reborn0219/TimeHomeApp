//
//  Target_PAParking.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_PAParking : NSObject

#warning 如果 Target_XXX 中的 Action_XXX 方法名变了。 CTMediator+XXXActions.m 中的字符串也必须得一起变


/**
 *  返回 PAParkingViewController 实例
 *
 *  @param params 要传给 PAParkingViewController 的参数
 */

- (UIViewController *)Action_NativeToPAParkingViewController:(NSDictionary *)params;

@end
