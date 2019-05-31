//
//  PAWaterPayQueryRequest.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/10.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterPayQueryRequest.h"

@implementation PAWaterPayQueryRequest{
    NSString *_merOrderId;
}

- (instancetype)initWithMerOrderId:(NSString *)merOrderId{
    if (self = [super init]) {
        _merOrderId = merOrderId;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    NSDictionary *paramDict = @{
                                @"merOrderId":_merOrderId,
                                };
    return  [self paramDicWithMethodName:@"orderinfo.payQuery"
                                   token:appdelgate.userData.token?:@""
                            originParams:paramDict];
}
@end
