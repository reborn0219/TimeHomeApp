//
//  PAParkingSpaceRevokeRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRevokeRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PACarSpaceRevokeRequest
{
    NSString * _spaceId;
}
- (instancetype) initWithSpaceId:(NSString *)spaceId {
    if (self = [super init]) {
        _spaceId = spaceId;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.revocationLease4App"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"id":_spaceId
                                           }];
}


@end
