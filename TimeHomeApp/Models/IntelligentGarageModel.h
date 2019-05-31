//
//  IntelligentGarageModel.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  车库数据
 */
@interface IntelligentGarageModel : NSObject

/**
 *  车库名称
 */
@property(nonatomic,strong) NSString * strGarageName;
/**
 *  所属物业名称
 */
@property(nonatomic,strong) NSString * strPropertyName;

/**
 *  入库日期
 */
@property(nonatomic,strong) NSString * strInToDate;
/**
 *  进库车牌号
 */
@property(nonatomic,strong) NSString * strCarNum;
/**
 *  进库车牌号备注
 */
@property(nonatomic,strong) NSString * strCarNumRemarks;
/**
 *  手机号
 */
@property(nonatomic,strong) NSString * strPhoneNum;
/**
 *  到期日期
 */
@property(nonatomic,strong) NSString * strEndDate;
/**
 *  锁车状态
 */
@property(nonatomic,strong) NSNumber * numLockState;
/**
 *  拥有状态
 */
@property(nonatomic,strong) NSNumber * numOwnState;

@end

/**
 *  车辆数据
 */

@interface GarageCarModel : NSObject
/**
 *  进库车牌号
 */
@property(nonatomic,strong) NSString * strCarNum;
/**
 *  进库车牌号备注
 */
@property(nonatomic,strong) NSString * strCarNumRemarks;
/**
 *  状态
 */
@property(nonatomic,strong) NSNumber * numState;
@end