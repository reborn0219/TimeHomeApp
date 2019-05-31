//
//  GetDefaultAddress.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 获得默认收货地址
 */
@interface GetDefaultAddress : NSObject
/**
 map	信息
 id	收货记录id
 provinceid	省id
 provincename	省名称
 cityid	市id
 cityname	市区名称
 areaid	区域id
 areaname	区域名称
 address	详细地址
 linkman	联系人
 linkphone	联系电话
 */

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *provinceid;
@property (nonatomic,copy)NSString *provincename;
@property (nonatomic,copy)NSString *cityid;
@property (nonatomic,copy)NSString *cityname;
@property (nonatomic,copy)NSString *areaid;
@property (nonatomic,copy)NSString *areaname;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *linkman;
@property (nonatomic,copy)NSString *linkphone;
@end
