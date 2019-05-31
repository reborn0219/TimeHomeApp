//
//  PASubmitSuggstRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PASubmitSuggstRequest : PABaseRequest
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
                      attachmentIds:(NSArray<NSString *>*)attachmentIds;
@end
