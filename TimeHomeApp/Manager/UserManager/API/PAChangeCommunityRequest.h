//
//  PAChangeCommunityRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PAChangeCommunityRequest : PABaseRequest
-(instancetype)initWithCommunityID:(NSString *)communityid Token:(NSString *)token;
@end