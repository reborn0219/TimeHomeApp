//
//  PANewHomeWaitcertinfoRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeWaitcertinfoRequest.h"

@implementation PANewHomeWaitcertinfoRequest{
    NSString *_communityId;
}
- (instancetype)initWithCommunityId:(NSString *)communityId{
    if (self = [super init]) {
        _communityId = communityId;
    }
    return self;
}
- (NSString *)baseUrl{
    return kCarError_SEVER_URL;
}
- (NSString *)requestUrl{
    return @"community/getwaitcertinfo";
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary * parameter = @{@"internettype":[AppDelegate getNetWorkStates],
                                 @"appsofttype":@"1",
                                 @"communityid":_communityId?:@""};

    return  [self paramDicWithMethodName:@"" token:delegate.userData.token?:@"" originParams:parameter];
}
@end
