//
//  L_BikeListModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/9/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "L_BikeImageResourceModel.h"
#import "L_BikeDeviceModel.h"
#import "L_BikeShareInfoModel.h"

/**
 *  自行车列表model
 */
@interface L_BikeListModel : NSObject

/**
 *  用户自行车设备ID
 */
@property (nonatomic, copy) NSString *theID;
/**
 *  自行车别名(废弃，勿用)
 */
@property (nonatomic, copy) NSString *alias;
/**
 *  设备号
 */
@property (nonatomic, copy) NSString *deviceno;
/**
 *  自行车是否锁定：0否1是
 */
@property (nonatomic, copy) NSString *islock;
/**
 *  车辆状态：是否入库:0否1是-1初始化
 */
@property (nonatomic, copy) NSString *state;
/**
 *  扫描时间（废弃）
 */
@property (nonatomic, copy) NSString *lasttime;

/**
 颜色
 */
@property (nonatomic, copy) NSString *color;
/**
 品牌
 */
@property (nonatomic, copy) NSString *brand;
/**
 购买日期
 */
@property (nonatomic, copy) NSString *purchasedate;
/**
 默认展示的照片url
 */
@property (nonatomic, copy) NSString *fileurl;

//-------------------2.3.1新增 edit by lsb 2017.01.19-------------------------
/**
 图片cell高度（自定义，添加页使用，其他页勿用）
 */
@property (nonatomic, assign) CGFloat imageRowHeight;
/**
 cell高度（自定义，详情页使用，其他页勿用）
 */
@property (nonatomic, assign) CGFloat infoFirstRowHeight;
/**
 cell高度（自定义，详情页使用，其他页勿用）
 */
@property (nonatomic, assign) CGFloat infoSecondRowHeight;
/**
 cell高度（自定义，修改页使用，其他页勿用）(车辆编码)
 */
@property (nonatomic, assign) CGFloat motifyBikenoRowHeight;
/**
 所属区域
 */
@property (nonatomic, strong) NSString *areaname;
/**
 小区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 小区id
 */
@property (nonatomic, strong) NSString *communityid;
//-----2.17.02.04新增-----------
/**
 城市名称
 */
@property (nonatomic, strong) NSString *cityname;
/**
 城市id
 */
@property (nonatomic, strong) NSString *cityid;

/**
 自行车类型 0 自行车 1电动车
 */
@property (nonatomic, strong) NSString *devicetype;
/**
 车辆编码
 */
@property (nonatomic, strong) NSString *bikeno;
/**
 物业电话
 */
@property (nonatomic, strong) NSString *communityPhone;

/**
 新扫描时间
 */
@property (nonatomic, strong) NSString *systime;

/**
 图片信息数组
 */
@property (nonatomic, strong) NSArray *resource;
/**
 感应条码信息数组
 */
@property (nonatomic, strong) NSArray *device;
/**
 共享信息数组
 */
@property (nonatomic, strong) NSArray *share;

/**
 是否共享 0未共享 1共享中 2来自共享
 */
@property (nonatomic, strong) NSString *isshare;


/**
 锁定所在车库
 */
@property (nonatomic, strong) NSString *parklotname;
/**
 锁定所在社区
 */
@property (nonatomic, strong) NSString *communitynamelock;

@end
