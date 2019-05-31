//
//  CTMediator+PANewNoticeMediator.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/9/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CTMediator+PANewNoticeMediator.h"

@implementation CTMediator (PANewNoticeMediator)
- (UIViewController *)pa_mediator_PANewNoticeControllerWithParams:(NSDictionary *)dict{
    
    Class aVCClass = NSClassFromString(@"PANewNoticeViewController");
    //创建vc对象
    UIViewController * vc = [[aVCClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    return vc;
}
@end
