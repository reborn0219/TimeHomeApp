//
//  CTMediator+PAParkingActions.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CTMediator.h"

//* PAParkingViewController 相关的路由跳转 */
//CTMediator+PAParkingActions. 这个Category利用Runtime调用我们刚刚生成的Target_News。

@interface CTMediator (PAParkingActions)

- (UIViewController *)pa_mediator_PAParkingViewControllerWithParams:(NSDictionary *)dict;

@end
