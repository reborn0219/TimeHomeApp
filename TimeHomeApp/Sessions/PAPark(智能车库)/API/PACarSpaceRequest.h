//
//  PACarportRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PACarSpaceRequest : PABaseRequest

/*根据社区ID和手机号查询业主的车位*/
-(instancetype)initWithCommunityId:(NSString*)communityId phone:(NSString*)phone;


@end
