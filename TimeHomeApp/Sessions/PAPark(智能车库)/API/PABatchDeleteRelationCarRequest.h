//
//  PABatchDeleteRelationCarRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/21.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PABatchDeleteRelationCarRequest : PABaseRequest

///批量删除车辆
-(instancetype)initWithCarNo:(NSString*)carno
                 communityID:(NSString*)communityId;

@end
