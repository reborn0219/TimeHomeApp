//
//  PAChangeCommunityRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAChangeCommunityRequest.h"

@implementation PAChangeCommunityRequest{
    NSString * _communityid;
    NSString * _token;
}

-(instancetype)initWithCommunityID:(NSString *)communityid Token:(NSString *)token{
    
    
    
    self = [super init];
    if(self){
        _communityid = communityid?communityid:@"";
        _token = token?token:@"";
       
    }
    return self;
}
-(NSString*)baseUrl{
    return SERVER_URL;
}
- (NSString *)requestUrl{
    return @"user/newchangecommunity";
}
- (id)requestArgument{
    
    return @{
             @"token":_token,
             @"communityid":_communityid
             };
}
@end
