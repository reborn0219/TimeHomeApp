//
//  PANewNoticeListRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewNoticeListRequest.h"

@implementation PANewNoticeListRequest
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
    NSDictionary * parameter = @{@"page":@(_page),
                                 @"limit":@(10),
                                 @"communityId":delegate.userData.communityid,
                                 @"UserId":delegate.userData.userID
                                 };
    return [self paramDicWithMethodName:@"ICustomerPasqAppService.queryNotices" appid:@"APP_H5_WG" encrypt:@"APP_H5_WG_2018" token:delegate.userData.token originParams:parameter];
}

@end

