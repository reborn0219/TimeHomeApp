//
//  PAUpdateRelationCarNoRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"
@interface PAUpdateRelationCarNoRequest : PABaseRequest

///修改关联车牌
-(instancetype)initWithCarNo:(NSString*)carno
                   ownerName:(NSString*)owername
                     spaceID:(NSString *)spaceid
                          ID:(NSString *)carID;

@end
