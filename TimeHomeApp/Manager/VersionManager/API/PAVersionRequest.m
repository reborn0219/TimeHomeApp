//
//  PAVersionRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVersionRequest.h"

@implementation PAVersionRequest

- (NSString *)requestUrl{
    return @"/user/isversionupd";
}
- (NSString *)baseUrl{
    return SERVER_URL;
}

- (id)requestArgument{
    
    NSString * version = kCurrentVersion;
    NSString * networkStates = [AppDelegate getNetWorkStates];
    return  @{@"version": version,@"internettype":networkStates,@"appsofttype":@"1",@"softtype":@"1"};
}

- (NSURLRequest *)buildCustomUrlRequest {
    
    NSString * version = @"1.0";//kCurrentVersion
    NSString * networkStates = [AppDelegate getNetWorkStates];
    NSDictionary * parameter =@{@"version": version,
                                @"internettype":networkStates,
                                @"appsofttype":@"1",
                                @"softtype":@"1",
                                @"internettype":networkStates
                                };
    
    NSData * requestData = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,@"/user/isversionupd"]]];
    [request setHTTPMethod:@"POST"];
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    [request setHTTPBody:requestData];
    
    return request;
}


@end
