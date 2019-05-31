//
//  SHAdInfoRequest.m
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PAAdInfoRequest.h"

@implementation PAAdInfoRequest

- (NSTimeInterval)requestTimeoutInterval{
    return 15.0;
}

-(NSString *)requestUrl{
    //return @"api";
    return @"api_entrance";
}

- (NSString *)baseUrl{
    return PA_NEW_SEVER_URL;
}

- (id)requestArgument {
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary *paramDictionary = @{@"token":delegate.userData.token?:@""};
    
    return [self paramDicWithMethodName:@"pasqadvertisement.advertisement" appid:@"APP_H5_PASQ" encrypt:@"APP_H5_PASQ_2018" token:delegate.userData.token?:@"" originParams:paramDictionary];
    //return [self paramDicWithMethodName:@"pasqadvertisement.advertisement" token:delegate.userData.token?:@"" originParams:paramDictionary];
}


@end
