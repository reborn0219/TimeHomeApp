//
//  PANewHouseService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PANewHouseModel.h"
@interface PANewHouseService : PABaseRequestService
@property (nonatomic, strong)NSArray * houseArray;
/**
 加载新房产列表

 @param success success description
 @param failed failed description
 */
- (void)loadMyHouseListSuccess:(ServiceSuccessBlock)success
                        failed:(ServiceFailedBlock)failed;
@end
