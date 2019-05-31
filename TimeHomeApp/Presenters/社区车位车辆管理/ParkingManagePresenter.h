//
//  ParkingManagePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///车位车辆管理
#import "BasePresenters.h"
#import "ParkingModel.h"
#import "ParkingCarModel.h"
#import "L_TimeSetInfoModel.h"

@interface ParkingManagePresenter : BasePresenters

///获得个人拥有车位信息（/parkingarea/getuserparkingarea）
-(void)getUserParkingareaForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**获得车位下的车辆列表（/car/getparkingareacar）
 parkingareaid 车位Id
 */
-(void)getParkingAreaCarForParkingareaid:(NSString *)parkingareaid  upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 获得未入库的车辆（/car/getoutcar）
 */
-(void)getOutCarForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 获得未加入到本车位中的车辆（/car/getnotparkingcar）
 token	登录令牌
 parkingareaid	车位id
 */
-(void)getNoParkingCarForID:(NSString *)parkingareaid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 添加车牌号（/car/addcar）
 parkingareaid	对应的车位
 carids	选中车牌id
 addjson	没有添加过的车牌，需要通过json数组传递过来
 */
-(void)addCarForParkingareaid:(NSString *)parkingareaid usercarids:(NSString *)usercarids addjson:(NSString *)addjson upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 修改车牌号（/car/changecar）
 parkingareaid	对应的车位
 card	车牌号
 remarks	车辆备注
 */
-(void)changeCarForUserCarID:(NSString *)parkingareaid card:(NSString *)card remarks:(NSString *)remarks upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 车库管理修改车牌号（/car/changeallcar）
 carid 修改的车牌id
 card 修改的车牌
 remarks 备注
 
 返回
 errocode
 errmsg
 carid 修改了车牌后的新carid
 */
-(void)changeallcarForUserCarID:(NSString *)carid card:(NSString *)card remarks:(NSString *)remarks upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 锁定、解锁车辆（/car/lockcar）
 parkingcarid	车辆车位记录表id
 state	解锁状态 1 锁定 0 解锁
 */
-(void)lockcarForParkingcarid:(NSString *)parkingcarid state:(NSString *)state upDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 通过用户车辆记录删除车牌（/car/removecarbycar）
 carid 车辆id
 */
-(void)removeCarByUserForCarid:(NSString *)carid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 通过车位车辆记录删除车牌（/car/removecarbyparking）
 parkingcarid 车辆id
 */
-(void)removeCarByParkingForParkingCarid:(NSString *)parkingcarid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得车辆定时设置详细信息（/locktimer/getlocktimesetinfo）
 parkingcarid 车辆id
 */
-(void)getLockTimeSetInfoForParkingCarid:(NSString *)parkingcarid upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 保存车辆定时设置详细信息（/locktimer/savelocktimesetinfo）
 token
 登录令牌
 parkingcarid
 车位车辆关联id
 state
 设置是否启动定时 0为关 1为开
 parkingcarid
 车位车辆关联
 openlockstate
 定时开车设定状态 0为关 1为开
 closelockstate
 定时锁车设定状态 0为关 1为开
 opentime
 开启时间
 closetime
 关闭时间
 opentimes
 开锁重复时间，如”1,2,3”则代表，周一，周二，周三
 closetimes
 锁定重复时间，如”1,2,3”则代表，周一，周二，周三
 
 */
-(void)saveLockTimeSetInfoForParkingModel:(L_TimeSetInfoModel *)model upDataViewBlock:(UpDateViewsBlock)updataViewBlock;

///parameters/isaddcard判断用户是否可以添加车牌
+(void)getIsAddCard:(NSString *)carid :(UpDateViewsBlock)updataViewBlock;

///获得个人拥有在库车辆和添加的自行车（parkingarea/getuserinparkinglotcarbike）
+(void)getUserinParkingLotCarBikeForupDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
