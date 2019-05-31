//
//  PABatchUpdateRelationCarRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/21.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABatchUpdateRelationCarRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PABatchUpdateRelationCarRequest{
    
    NSString * _communityId;
    NSString * _carNo;
    NSString *_updateCarNo;

}

-(instancetype)initWithCarNo:(NSString*)carno
                 updateCarNo:(NSString *)updateCarNo
                 communityID:(NSString*)communityId{
    
    self = [super init];
    if(self){
        _carNo = carno?carno:@"";
        _communityId = communityId?communityId:@"";
        _updateCarNo = updateCarNo?updateCarNo:@"";

    }
    return self;
    
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}


- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"appfixedparkingspace.updateRelationCarNoBatch"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"carNo" : _carNo,
                                           @"communityId" : _communityId,
                                           @"updateCarNo":_updateCarNo,
                                           }];
}
@end
