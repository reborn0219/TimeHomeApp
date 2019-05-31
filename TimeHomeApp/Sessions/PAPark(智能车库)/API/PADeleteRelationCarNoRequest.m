//
//  PADeleteRelationCarNoRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/18.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PADeleteRelationCarNoRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PADeleteRelationCarNoRequest{
    NSString * _carID;
}

-(instancetype)initWithCarID:(NSString*)carID
{
    
    self = [super init];
    if(self){
        
        _carID = carID?carID:@"";
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.deleteRelationCarNo"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"id" : _carID,
                                           }];
    
    
}

@end
