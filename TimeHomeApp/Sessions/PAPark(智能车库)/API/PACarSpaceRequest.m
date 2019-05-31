//
//  PACarportRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PACarSpaceRequest{
    NSString *_phone;
    NSString *_communityId;
}

-(instancetype)initWithCommunityId:(NSString*)communityId phone:(NSString*)phone{
    self = [super init];
    if(self){
        AppDelegate * appdelegate = GetAppDelegates;
        _phone = phone?phone:@"";
        _communityId = appdelegate.userData.communityid?appdelegate.userData.communityid:@"";
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"appfixedparkingspace.parkingSpaceList"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"communityId" : _communityId
                                           }];
    
    
}



@end
