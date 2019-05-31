//
//  PAUserInfoRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUserInfoRequest.h"

@implementation PAUserInfoRequest{
    NSString * _token;
}

-(instancetype)initWithToken:(NSString *)token{
    self = [super init];
    if(self){
        _token = token?token:@"";
    }
    return self;
}
-(NSString*)baseUrl{
    return SERVER_URL;
}
- (NSString *)requestUrl{
    return @"user/newgetmyuserinfo";
}
- (id)requestArgument{
    
    return @{
             @"token":_token,
             };
    
}

@end
