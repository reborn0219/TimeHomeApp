//
//  CTMediator+PASuggestMediatorActions.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/9/5.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CTMediator+PASuggestMediatorActions.h"

@implementation CTMediator (PASuggestMediatorActions)
- (UIViewController *)pa_mediator_PANewSuggestControllerWithParams:(NSDictionary *)dict{
    Class aVCClass = NSClassFromString(@"PANewSuggestViewController");
    //创建vc对象
    UIViewController * vc = [[aVCClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

@end
