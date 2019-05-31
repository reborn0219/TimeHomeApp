//
//  PASubmitSuggstRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASubmitSuggstRequest.h"

@implementation PASubmitSuggstRequest
{
    NSString * _communityId;
    NSString * _createTime;
    NSString * _mobile;
    NSString * _complaintDetails;
    NSArray * _attachmentIds;
}
/**
 request 新增投诉建议request

 @param communityId 社区ID
 @param contactMobile 联系电话
 @param complaintDetails 投诉内容
 @param attachmentIds 附件列表
 @return request
 */
- (instancetype)initWithCommunityId:(NSString *)communityId
                      contactMobile:(NSString *)contactMobile
                   complaintDetails:(NSString *)complaintDetails
                      attachmentIds:(NSArray<NSString *>*)attachmentIds{
    if (self = [super init]) {
        _communityId = communityId;
        _mobile = contactMobile;
        _complaintDetails = complaintDetails;
        _attachmentIds = [NSArray arrayWithArray:attachmentIds];
        NSDate * currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        //NSDate转NSString
        _createTime = [dateFormatter stringFromDate:currentDate];
    }
    return self;
}
- (NSString *)baseUrl{
    return PA_NEW_NOTICE_URL;
}
- (NSString *)requestUrl{
    return @"api_entrance";
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary * parameter = @{@"workOrder":@{
                                         @"communityId":_communityId,
                                         @"createTime":_createTime,
                                         @"contactMobile":_mobile,
                                         @"complaintDetails":_complaintDetails,
                                         @"attachmentIds":_attachmentIds
                                         }};
    return [self paramDicWithMethodName:@"ICustomerPasqAppService.createWorkOrder"
                                  appid:@"APP_H5_WG"
                                encrypt:@"APP_H5_WG_2018"
                                  token:delegate.userData.token?:@""
                           originParams:parameter];
}
@end
