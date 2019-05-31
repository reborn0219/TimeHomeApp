//
//  PAAuthorityRequest.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAAuthorityRequest.h"

@implementation PAAuthorityRequest{    
    NSString *_communityId;
}

-(instancetype)initWithCommunityId:(NSString*)communityId{
    self = [super init];
    if(self){
        _communityId = communityId?communityId:@"";
    }
    return self;
}

-(NSString*)baseUrl{
    return PA_AUTH_URL;
}

- (NSString *)requestUrl{
    return @"api_entrance"; 
}


- (id)requestArgument{
 
    AppDelegate * delegate = GetAppDelegates
    
    return [self paramDicWithMethodName:@"main.getPrivsByCommunity"
                                  token:delegate.userData.token?:@""
                           originParams:@{@"id" : _communityId}];
}

@end
