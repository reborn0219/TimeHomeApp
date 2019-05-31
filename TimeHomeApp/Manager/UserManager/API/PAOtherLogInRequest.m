//
//  PAOtherLogInRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAOtherLogInRequest.h"

@implementation PAOtherLogInRequest{
    NSString * _thirdToken;
    NSString * _thirdID;
    NSString * _account;
    NSString * _type;
}
-(instancetype)initWithToken:(NSString*)thirdToken
                     thirdID:(NSString *)thirdid
                     Account:(NSString *)account
                        Type:(NSString *)type{
    
    
    self = [super init];
    if(self){
        _thirdToken = thirdToken?thirdToken:@"";
        _thirdID = thirdid?thirdid:@"";
        _account = account?account:@"";
        _type = type?type:@"";
    }
    return self;
}
-(NSString*)baseUrl{
    return SERVER_URL_New;
}
- (NSString *)requestUrl{
    return @"bindinguser/newlogin";
}
- (id)requestArgument{
    
    return @{
             @"type":_type,
             @"thirdtoken":_thirdToken,
             @"account":_account,
             @"thirdid":_thirdID
             };
}

@end
