//
//  PABatchDeleteRelationCarRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/21.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABatchDeleteRelationCarRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PABatchDeleteRelationCarRequest{
    
    NSString * _communityId;
    NSString * _carNo;
    
}

-(instancetype)initWithCarNo:(NSString*)carno
                 communityID:(NSString*)communityId{
    
    self = [super init];
    if(self){
        _carNo = carno?carno:@"";
        _communityId = communityId?communityId:@"";
        
    }
    return self;
    
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.deleteRelationCarNoBatch"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"carNo" : _carNo,
                                           @"communityId" : _communityId,
                                           }];
    
    
}


@end
