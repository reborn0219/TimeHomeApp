//
//  PANoticeUnBindRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANoticeUnBindRequest.h"
#import "PANoticeUrl.h"
#import <JMessage/JMessage.h>

@implementation PANoticeUnBindRequest


- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
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
                                 };
    NSData * requestData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PA_NEW_SEVER_URL,NoticeUnBindDeviceUrl]]];
    [request setHTTPMethod:@"POST"];
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    [request setHTTPBody:requestData];
    
    return request;
}

@end
