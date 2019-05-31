//
//  PANoticeRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANoticeRequest.h"
#import "PANoticeUrl.h"
#import <JMessage/JMessage.h>
@implementation PANoticeRequest
{
    NSString * _registrationId;
    NSString * _userId;
    NSString * _userPhone;
}

/**
 初始化上传推送服务器信息
 
 @param registrationId registrationId description
 @param userId userId description
 @param userPhone userPhone description
 @return return value description
 */
- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (NSString *)baseUrl{
    return PA_NOTICE_SERVER_URL;
}
- (NSString *)requestUrl{
    return NoticeSaveDeviceInfoUrl;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

- (id)requestArgument{

    AppDelegate * delegate = GetAppDelegates;
    NSString * registrationId = JPUSHService.registrationID;
    NSString * userId = delegate.userData.userID;
    NSString * userPhone = delegate.userData.phone;

    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * opid = [userDefault objectForKey:@"PAUserOpId"];
    NSDictionary * parameter = @{@"userId"         :userPhone?:@"",
                                 @"userTypeId"     :@"1",
                                 @"registrationId" :registrationId,
                                 @"userPhone"      :userPhone,
                                 @"alias"          :@"",
                                 @"config"         :@""};

    return parameter;
}

- (NSURLRequest *)buildCustomUrlRequest {
    
    AppDelegate * delegate = GetAppDelegates;
    NSString * registrationId = JPUSHService.registrationID;
    NSString * userId = delegate.userData.userID;
    NSString * userPhone = delegate.userData.phone;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * opid = [userDefault objectForKey:@"PAUserOpId"];
    NSDictionary * parameter = @{@"userId"         :userPhone?:@"",
                                 @"userTypeId"     :@"1",
                                 @"registrationId" :registrationId,
                                 @"userPhone"      :userPhone?:@"",
                                 @"alias"          :@"",
                                 @"config"         :@""};
    
    NSData * requestData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PA_NOTICE_SERVER_URL,NoticeSaveDeviceInfoUrl]]];
    [request setHTTPMethod:@"POST"];
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    [request setHTTPBody:requestData];
    return request;
}

@end
