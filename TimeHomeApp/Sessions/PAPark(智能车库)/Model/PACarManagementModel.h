//
//  PACarManagementModel.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/10.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"
@interface PACarManagementModel : NSObject

@property (nonatomic, copy) NSString *vehicleID;
@property (nonatomic, copy) NSString *carNo;
@property (nonatomic, copy) NSString *ownerName;
///是否在库 0 否 1是
@property (nonatomic, copy) NSString *isInLib;
@property (nonatomic, assign) BOOL isSelected;

@end
