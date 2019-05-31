//
//  CTMediator+PAParkingActions.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CTMediator+PAParkingActions.h"

// ******************** NOTE  ************************

//TODO: 这里的两个字符串必须 hard code

//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_PAParking = @"PAParking";

//  2. 字符串是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_PAParkingViewController = @"NativeToPAParkingViewController";

// ******************** NOTE  ************************


@implementation CTMediator (PAParkingActions)

- (UIViewController *)pa_mediator_PAParkingViewControllerWithParams:(NSDictionary *)dict{
   
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_PAParking
                                                    action:kCTMediatorActionNativTo_PAParkingViewController
                                                    params:dict
                                         shouldCacheTarget:NO];
    
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}

@end
