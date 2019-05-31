//
//  PAUserRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUserLogInRequest.h"

@implementation PAUserLogInRequest{
    
    NSString *_account;
    NSString *_password;
   
}

-(instancetype)initWithLogInAccout:(NSString *)account passWord:(NSString *)passWord{
    self = [super init];
    if(self){
        _account = account?account:@"";
        _password = passWord?passWord:@"";
    }
    return self;
}
-(NSString*)baseUrl{
    return SERVER_URL;
}
- (NSString *)requestUrl{
    return @"user/newlogin";
}
- (id)requestArgument{
    
    return @{
             @"phone":_account,
             @"password":_password
             };
    
}

@end
