//
//  CarLocationPresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface CarLocationPresenter : BasePresenters

/**
 车辆定位列表（/carposition/getusercarposition）
 page    分页页码

 */
-(void)getUserCarPositionForPage:(NSString*) page  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 新增车辆定位列表（/carposition/addusercarposition）
 card   车牌号
 imei  设备IMEI号
 */
-(void)addUserCarPositionForCard:(NSString*) card imei:(NSString *)imei upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 修改车辆定位车牌号（/carposition/changeusercard）
 card   车牌号
 id  车辆Id
 */
-(void)changeUserCardForCard:(NSString*) card ID:(NSString *)ID upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 删除车辆定位信息（/carposition/removeusercarposition）
 id  删车辆id
 */
-(void)removeusercarpositionForID:(NSString *)ID upDataViewBlock:(UpDateViewsBlock)updataViewBlock;


///获取登录认证
-(void ) GetAccessForAcc:(NSString *) acc  pw:(NSString *)pwd upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
///获取车定位信息
-(void) getCarInfo;
///定时刷新车定位信息
-(void) startCarTimeTorefresh:(NSString *)imei upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
///取消定时器
-(void)cancalTimer;

///获取当前定位车辆地址
-(void)getCarAddrForAcc:(NSString *) acc  pw:(NSString *)pwd imei:(NSString *)aIMEI upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
