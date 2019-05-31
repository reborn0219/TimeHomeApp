//
//  PAParkingSpaceModel.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACarSpaceModel : NSObject

@property (strong, nonatomic) NSString *spaceId;//车位ID
@property (strong, nonatomic) NSString *parkingSpaceName;//车位名称
@property (assign, nonatomic) NSInteger parkingSpaceState;//车位状态
@property (strong, nonatomic) NSString *inLibCarNo;//入库车辆号牌
@property (assign, nonatomic) NSInteger type;//车位自用/车位出租
@property (assign, nonatomic) NSInteger tenantLockState; //物业锁车
@property (assign, nonatomic) NSInteger carLockState;//用户锁车
@property (strong, nonatomic) NSString *communityId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPhone;
@property (strong, nonatomic) NSString *useStartDate;
@property (strong, nonatomic) NSString *useEndDate;
@property (strong, nonatomic) NSString *parkingServiceStartDate;
@property (strong, nonatomic) NSString *parkingServiceEndDate;
@property (strong, nonatomic) NSString *carId;

@end
