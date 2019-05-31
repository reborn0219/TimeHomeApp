//
//  CTMediator+PARecommendationActions.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CTMediator+PARecommendationActions.h"

//TODO: 这里的两个字符串必须 hard code

//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const kCTMediatorTarget_PARecommendation = @"PARecommendation";

//  2. 字符串是 Target_xxx.h 中 定义的 Action_xxxx 函数名的 xxx 部分
NSString * const kCTMediatorActionNativTo_PARecommendationController = @"NativeToPARecommendationController";

@implementation CTMediator (PARecommendationActions)

- (UIViewController *)pa_mediator_PARecommendationViewControllerWithParams:(NSDictionary *)dict {
    
    Class aVCClass = NSClassFromString(@"PARecommendationViewController");
    //创建vc对象
    UIViewController * vc = [[aVCClass alloc] init];

    vc.hidesBottomBarWhenPushed = YES;
    return vc;
    /*
    UIViewController *viewController = [self performTarget:kCTMediatorTarget_PARecommendation   action:kCTMediatorActionNativTo_PARecommendationController
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
     */
}


@end
