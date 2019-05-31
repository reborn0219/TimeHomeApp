//
//  PASuggestListRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestListRequest.h"

@implementation PASuggestListRequest
{
    NSInteger _page;
}
- (instancetype)initWithPage:(NSInteger)page{
    if (self = [super init]) {
        _page = page;
    }
    return self;
}
- (NSString *)baseUrl{
    return PA_NEW_NOTICE_URL;
}
- (NSString *)requestUrl{
    return @"api_entrance";
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary * parameter = @{@"userId":delegate.userData.userID,
                                 @"page":@(_page),
                                 @"limit":@(10)};
    return [self paramDicWithMethodName:@"ICustomerPasqAppService.queryWorkOrders" appid:@"APP_H5_WG" encrypt:@"APP_H5_WG_2018" token:delegate.userData.token originParams:parameter];
}
@end
