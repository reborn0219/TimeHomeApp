//
//  UserReserveInfo.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修model
 */
#import <Foundation/Foundation.h>

@interface UserReserveInfo : NSObject
/**
 *  预约id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  预约单号
 */
@property (nonatomic, strong) NSString *reserveno;
/**
 *  0 家用设施 1 公共设施
 */
@property(nonatomic,copy) NSString * type;
///选择的设备id
@property (nonatomic, strong) NSString *typeID;
/**
 *  设备名称
 */
@property (nonatomic, strong) NSString *typeName;
/**
 *  用户反馈的设备维修信息
 */
@property (nonatomic, strong) NSString *feedback;
/**
 *  选择的住宅id；
 */
@property (nonatomic, strong) NSString *residenceid;
/**
 *  公众维修地址id
 */
@property (nonatomic, strong) NSString *addressid;
/**
 *  显示的地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *  用户预留电话
 */
@property (nonatomic, strong) NSString *phone;
/**
 *  已经分配的物业名称
 */
@property (nonatomic, strong) NSString *propertyname;
/**
 *  分配日期
 */
@property (nonatomic, strong) NSString *processdate;
/**
 *  是否可修 1 可以 0不可以
 */
@property (nonatomic, strong) NSString *isok;
/**
 *  处理状态 0 创建 1 已分配 2 处理中 3 已完成 4 已评价
 */
@property (nonatomic, strong) NSString *state;
/**
 *  处理人名称
 */
@property (nonatomic, strong) NSString *visitlinkman;
/**
 *  处理人联系电话
 */
@property (nonatomic, strong) NSString *visitlinkphone;
/**
 *  处理意见
 */
@property (nonatomic, strong) NSString *views;
/**
 *  处理日期
 */
@property (nonatomic, strong) NSString *visitdate;
/**
 *  完成日期
 */
@property (nonatomic, strong) NSString *okdate;
/**
 *  评价级别
 */
@property (nonatomic, strong) NSString *evaluatelevel;
/**
 *  评价内容
 */
@property (nonatomic, strong) NSString *evaluate;
/**
 *  评价时间
 */
@property (nonatomic, strong) NSString *evaluatedate;
/**
 *  创建时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 *  价格描述
 */
@property (nonatomic, strong) NSString *pricedesc;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *piclist;

/**
 *  预约报修时间
 */
@property (nonatomic, strong) NSString *reservedate;
@end
