//
//  PANewHouseListRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHouseListRequest.h"

@implementation PANewHouseListRequest
- (instancetype)init{
    if (self = [super init]) {
        
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
    AppDelegate * delegate= GetAppDelegates;
    NSDictionary * parameter = @{@"contactMobile":delegate.userData.phone,
                                 @"page":@(1),
                                 @"limit":@(9999)
                                 };
    return [self paramDicWithMethodName:@"ICustomerPasqAppService.queryMyHouses" appid:@"APP_H5_WG" encrypt:@"APP_H5_WG_2018" token:delegate.userData.token?:@"" originParams:parameter];
}

@end
