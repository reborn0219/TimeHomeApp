//
//  PAParkingNoInCarListRquest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAParkingNoInCarListRquest.h"
#import "PAParkingSpaceUrl.h"

@implementation PAParkingNoInCarListRquest{

    NSString *_communityId;
}
-(instancetype)initWithCommunityId:(NSString*)communityId{
    self = [super init];
    if(self){

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
    return  [self paramDicWithMethodName:@"appfixedparkingspace.noInCarList"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"communityId" : _communityId,
                                           }];
    
}
@end
