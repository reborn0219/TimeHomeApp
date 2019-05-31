//
//  PADeleteRelationCarNoRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/18.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PADeleteRelationCarNoRequest : PABaseRequest
///删除车辆
-(instancetype)initWithCarID:(NSString*)carID;

@end
