//
//  PAParkingSpaceRequest.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.


#import "PAParkingSpaceRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PAParkingSpaceRequest{
    NSString *_phone;
    NSString *_communityId;
}

-(instancetype)initWithCommunityId:(NSString*)communityId phone:(NSString*)phone{
    self = [super init];
    if(self){
        
        _phone = phone?phone:@"";
        _communityId = communityId?communityId:@"";
        
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}
- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
//    _communityId = @"10000002084";
    return  [self paramDicWithMethodName:@"appfixedparkingspace.parkingSpaceList"
                           token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"communityId" : _communityId,
                                           }];
    
}
@end
