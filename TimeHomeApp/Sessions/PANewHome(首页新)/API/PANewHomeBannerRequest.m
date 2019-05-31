//
//  PANewHomeBannerRequest.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeBannerRequest.h"

@implementation PANewHomeBannerRequest

-(NSString *)baseUrl{
    return SERVER_URL;
}

- (NSString *)requestUrl{
    return @"/banner/getbanner";
}

- (id)requestArgument{
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"NetGetDataCommand"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{}];
}

@end
