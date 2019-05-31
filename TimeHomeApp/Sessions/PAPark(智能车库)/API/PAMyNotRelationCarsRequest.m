//
//  PAMyNotRelationCarsRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMyNotRelationCarsRequest.h"
#import "PAParkingSpaceUrl.h"


@implementation PAMyNotRelationCarsRequest{
    
    NSString *_communityId;
    NSString *_spaceID;
}

-(instancetype)initWithCommunityId:(NSString*)communityId
                           spaceID:(NSString *)spaceid{
    
    
    self = [super init];
    if(self){
        
        _communityId = communityId ?communityId:@"";
        _spaceID = spaceid?spaceid:@"";
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}



- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
//    _communityId = @"10000002084";
    return  [self paramDicWithMethodName:@"appfixedparkingspace.queryMyNotRelationCars"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"communityId" : _communityId,
                                           @"spaceId":_spaceID,
                                           }];
    
}

@end
