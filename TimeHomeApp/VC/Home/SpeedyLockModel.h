//
//  SpeedyLockModel.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/9/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeedyLockModel : NSObject

@property (nonatomic, copy) NSString *parkingcarid;//车辆车位关系id

@property (nonatomic, copy) NSString *type;//车辆类型 1汽车 2二轮车

@property (nonatomic, copy) NSString *card;//车辆名称

@property (nonatomic, copy) NSString *cmmareaname;//社区车位名称

@property (nonatomic, copy) NSString *islock;//是否锁定

@property (nonatomic, copy) NSString *isalert;//是否报警

@property (nonatomic, copy) NSString *communityname;//社区名称

@end
