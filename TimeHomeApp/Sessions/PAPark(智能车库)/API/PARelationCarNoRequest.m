//
//  PARelationCarNoRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PARelationCarNoRequest.h"
#import "PAParkingSpaceUrl.h"
@interface PARelationCarNoRequest()
{
    NSArray *_carNoArr;
    NSString *_spaceID;
}

@end

@implementation PARelationCarNoRequest

-(instancetype)initWithCarNoEntities:(NSArray*)carNoArr
                     spaceID:(NSString *)spaceid{
    
    self = [super init];
    if(self){
        
        _carNoArr = carNoArr?carNoArr:@[];
        _spaceID = spaceid?spaceid:@"";
     
        
        
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}



- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.relationCarNo"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"carNoEntities" : _carNoArr,
                                           @"spaceId" : _spaceID,
                                           
                                           }];
    
    
}

@end
