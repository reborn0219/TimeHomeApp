//
//  PAUpdateRelationCarNoRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUpdateRelationCarNoRequest.h"
#import "PAParkingSpaceUrl.h"

@interface PAUpdateRelationCarNoRequest()
{
    NSString *_carNo;
    NSString *_ownerName;
    NSString *_spaceID;
    NSString *_carID;
}
@end

@implementation PAUpdateRelationCarNoRequest

///修改关联车牌
-(instancetype)initWithCarNo:(NSString*)carno
                   ownerName:(NSString*)owername
                     spaceID:(NSString *)spaceid
                          ID:(NSString *)carID
{
    self = [super init];
    if(self){
        
        _carNo = carno?carno:@"";
        _ownerName = owername?owername:@"";
        _spaceID = spaceid?spaceid:@"";
        _carID = carID?carID:@"";
        
    }
    return self;
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.updateRelationCarNo"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"carNo" : _carNo,
                                           @"ownerName" : _ownerName,
                                           @"spaceId" : _spaceID,
                                           @"id":_carID,
                                           }];
    
    
}

@end
