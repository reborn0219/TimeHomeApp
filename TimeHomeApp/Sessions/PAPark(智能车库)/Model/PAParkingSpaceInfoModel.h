//
//  PAParkingSpaceInfo.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACarManagementModel.h"


@interface PACarSpaceInfoModel : NSObject
/*
 "id": 195,
 "type": 0,
 "ownerName": "测试",
 "inLibCarNo": "冀A03043",
 "inTime": null,
 "inSpace": "暂无"
 */
@property (strong, nonatomic)NSString * parkingSpaceInfoId;
@property (assign, nonatomic)NSInteger type;
@property (strong, nonatomic)NSString *ownerName;
@property (strong, nonatomic)NSString *inLibCarNo;
@property (strong, nonatomic)NSString *inTime;
@property (strong, nonatomic)NSString *inSpace;
@property (strong, nonatomic)NSMutableArray * carNos;

@end
