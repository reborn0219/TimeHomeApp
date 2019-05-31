//
//  PANewNoticeTopRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/9/5.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewNoticeTopRequest.h"

@implementation PANewNoticeTopRequest
- (NSString *)baseUrl{
    return PA_NEW_NOTICE_URL;
}
- (NSString *)requestUrl{
    return @"api_entrance";
}

- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary *parameter = @{@"communityId":delegate.userData.communityid,
                                @"userId":delegate.userData.userID,
                                @"topNum":@(5)
                                };
    return  [self paramDicWithMethodName:@"ICustomerPasqAppService.queryNoticesTop" appid:@"" encrypt:@"" token:delegate.userData.token originParams:parameter];
}

@end
