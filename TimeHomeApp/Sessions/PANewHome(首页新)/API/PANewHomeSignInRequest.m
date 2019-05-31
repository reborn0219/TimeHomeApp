//
//  PANewHomeSignInRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeSignInRequest.h"

@implementation PANewHomeSignInRequest
- (NSString *)baseUrl{
    return SERVER_URL;
}
- (NSString *)requestUrl{
    return @"signset/getusersignset";
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary * parameter = @{@"internettype":[AppDelegate getNetWorkStates],@"appsofttype":@"1"};
    return [self paramDicWithMethodName:@"" token:delegate.userData.token?:@"" originParams:parameter];
}
@end
