//
//  RepairDevTypeModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///维修设备类型数据
#import <Foundation/Foundation.h>

@interface RepairDevTypeModel : NSObject
/**
 “id”:”12122”
 ,”name”:”梯子”
 ,”remarks”:”描述”
 ,”type”:1
 ,”pricedesc”:”100元一次”
 */

///设备Id
@property(nonatomic,copy)NSString *ID;
///设备名称
@property(nonatomic,copy)NSString *name;
///描述
@property(nonatomic,copy)NSString *remarks;
///设备类型
@property(nonatomic,copy)NSString *type;
///价格
@property(nonatomic,copy) NSString * pricedesc;
@end
