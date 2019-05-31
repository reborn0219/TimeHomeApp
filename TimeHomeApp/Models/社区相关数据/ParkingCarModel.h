//
//  ParkingCarModel.h
//  TimeHomeApp
//
//  Created by us on 16/4/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车位上车牌数据
#import <Foundation/Foundation.h>

@interface ParkingCarModel : NSObject
/**
 parkingcarid	车位车辆对应记录表id
 card	车辆车牌号
 position	车辆位置 0 未入库 其他车id
 state	是否锁定 0 否 1 是
 remaks	车辆备注信息
 isinit  0 未初始化 1.初始化
 carid	用户车牌记录id
 */

@property(nonatomic,copy) NSString * parkingcarid;
@property(nonatomic,copy) NSString * carid;
@property(nonatomic,copy) NSString * card;
@property(nonatomic,copy) NSString * remarks;
@property(nonatomic,copy) NSString * position;
@property(nonatomic,copy) NSString * state;
@property(nonatomic,copy) NSNumber * isinit;
//是否设置定时锁车 0为不设置 1为设置
@property (nonatomic, strong) NSNumber *lockstate;

///是否选中标记 YES选中    NO没有选中
@property(nonatomic,assign) BOOL isSelect;
////YES 新添加　　NO 已存在
@property(nonatomic,assign) BOOL isNews;
///是否修改  YES是  NO 不修改
@property(nonatomic,assign)BOOL isChange;

@end
