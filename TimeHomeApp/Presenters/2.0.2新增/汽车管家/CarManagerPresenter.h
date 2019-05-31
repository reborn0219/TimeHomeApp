//
//  CarManagerPresenter.h
//  TimeHomeApp
//
//  Created by 世博 on 16/8/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"



/**
 *  汽车管家相关接口
 */
@interface CarManagerPresenter : BasePresenters

/**
 *  获得最后一次检测的结果（/cartest/getlasttesting）
 */
+ (void)getLastTestingWithUcarid:(NSString *)ucarid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  开始检测（/cartest/starttesting）
 */
+ (void)startTestingWithUcarid:(NSString *)ucarid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  里程油耗（/caroil/getmonthstat）
 */
+ (void)fuelConsumptionWithUcarid:(NSString *)ucarid
                             date:(NSString *)date
                  UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;



#pragma mark -- 赵思雨
/**
 * 获得所有车辆品牌 /carsystem/getbrandlist
 **/
+ (void)getAllCarBrandWithBlock:(UpDateViewsBlock)updataViewBlock;

/**
 * 获得某品牌下的车系 /carsystem/getserieslist
 **/
+ (void)getAllCarModelWithCarBrandID:(NSString *)brandID andBlock:(UpDateViewsBlock)updataViewBlock;

/**
 * 获得某车系下的车型 /carsystem/getmodelslist
 **/
+ (void)getAllCarStyleWithCarModelID:(NSString *)styleID andBlock:(UpDateViewsBlock)updataViewBlock;


/**
 * 首页切换车辆展示  /usercar/getindexcar  (首页展示)
 **/
+ (void)getChangeCarWithBlock:(UpDateViewsBlock)updataViewBlock;

/**
 * 切换车辆展示  /usercar/setindexcar  (右边展示)
 **/
+ (void)getChangeCarWithYourCarID:(NSString *)uCarID Block:(UpDateViewsBlock)updataViewBlock;

/**
 *获得我的绑定设备成功的车辆列表（/usercar/getbindingcarlist）
 **/
+ (void)getMyCarListWithBlcok:(UpDateViewsBlock)updataViewBlock;
/**
 * OBD详情 /cartest/getobdinfo
 **/
+ (void)getOBDInfoWithYourCarID:(NSString *)uCarID andBlock:(UpDateViewsBlock)updataViewBlock;

/**
 * 获得我的坐标  /ucarposition/getnowposition
 **/
+ (void)getMyGPSWithCarID:(NSString *)uCarID andBlock:(UpDateViewsBlock)updataViewBlock;


/**
 * 获得车辆警告信息 /carwarn/getcarwarnlist
 **/
+ (void)getCarAlarmInfoWithYourCarID:(NSString *)uCarID andPage:(NSString *)page andBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *清楚单条报警信息/carwarn/deletecarwarn
 **/
+ (void)clearOneAlarmInfoWithWarnID:(NSString *)warnID andBlock:(UpDateViewsBlock)updataViewBlock;

/**
 * 清除报警信息/carwarn/clearcarwarn
 **/
+ (void)clearAllAlarmInfoWithBlock:(UpDateViewsBlock)updataViewBlock;


#pragma mark -- 卡娜娜

///获得我的车辆列表（/usercar/getcarlist）
+(void)getCarlist:(UpDateViewsBlock)updataViewBlock;

///获得我的车辆信息（/usercar/getcarinfo）
+(void)getCarInfoWithID:(NSString * )ucarid AndBlock:(UpDateViewsBlock)updataViewBlock;

///新增要开通的车辆（/usercar/addcar）
+(void)addCarWithParameter:(NSDictionary *)parameter AndBlock:(UpDateViewsBlock)updataViewBlock;

///编辑车辆（/usercar/changecar）
+(void)changeCarWithParameter:(NSDictionary *)parameter AndBlock:(UpDateViewsBlock)updataViewBlock;

///删除车辆（/usercar/deletecar）
+(void)deleteCarInfoWithID:(NSString * )ucarid AndBlock:(UpDateViewsBlock)updataViewBlock;

///绑定设备（/usercar/bindingcar）
+(void)bindingCarInfoWithID:(NSString * )ucarid withStr:(NSString *)deviceno AndBlock:(UpDateViewsBlock)updataViewBlock;

///解除绑定（/usercar/clearbindingcar）
+(void)clearbindingCarInfoWithID:(NSString * )ucarid AndBlock:(UpDateViewsBlock)updataViewBlock;

///更新仪表信息usercar/getrunstate
+(void)updataCarInfoWithID:(NSString * )ucarid AndBlock:(UpDateViewsBlock)updataViewBlock;

@end
