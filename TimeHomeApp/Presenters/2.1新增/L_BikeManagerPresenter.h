//
//  L_BikeManagerPresenter.h
//  TimeHomeApp
//
//  Created by 世博 on 16/9/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "L_BikeListModel.h"
#import "L_BikeShareInfoModel.h"
#import "L_TimeSetInfoModel.h"
#import "L_BikeAlermModel.h"

/**
 *  自行车管理相关接口
 */
@interface L_BikeManagerPresenter : BasePresenters

/**
 *  添加用户自行车设备（/bike/adduserbike）(已废弃，勿用)
 *
 *  @param alias           别名
 *  @param deviceno        设备号
 *  @param color           颜色
 *  @param brand           品牌
 *  @param purchasedate    购买日期
 *  @param resourceid      照片ID
 */
+ (void)addUserBikeWithAlias:(NSString *)alias deviceno:(NSString *)deviceno color:(NSString *)color brand:(NSString *)brand purchasedate:(NSString *)purchasedate resourceid:(NSString *)resourceid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得自行车设备列表（/bike/getbikelist）
 */
+ (void)getBikeListUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 *  设置自行车锁定状态（/bike/setlock）
 *
 *  @param theID           用户自行车设备id
 *  @param islock          锁车状态：0否1是
 */
+ (void)setLockWithID:(NSString *)theID islock:(NSString *)islock UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 *  修改自行车别名（/bike/changealias）
 *
 *  @param theID           用户自行车设备id
 *  @param alias           别名
 */
+ (void)changeAliasWithID:(NSString *)theID alias:(NSString *)alias UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  解除设备绑定（/bike/deletebike）
 *
 *  @param theID           用户自行车设备id
 */
+ (void)deleteBikeWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 *  二轮车共享（/bike/bikeshare）
 *
 *  @param theID           用户自行车设备id
 *  @param mobilephone     手机号
 *  @param sharename       联系人
 */
+ (void)shareBikeInfoWithID:(NSString *)theID mobilephone:(NSString *)mobilephone sharename:(NSString *)sharename UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 *  二轮车取消共享（/bike/delshare）
 *
 *  @param theID           用户自行车设备id
 */
+ (void)delshareBikeInfoWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 *  新版添加用户自行车设备（/bike/adduserbike）
 *
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-
 
 */
+ (void)newAddUserBikeWithDeviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 根据二轮车id获取二轮车被分享人的信息列表（/bike/getsharelist）
 
 @param theID 用户自行车id
 */
+ (void)getShareListWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 二轮车修改接口（/bike/changebike）
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-
 */
+ (void)changeBikeWithID:(NSString *)theID deviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 修改二轮车 解锁，开锁设置（/bike/changeopenclose）
 *  @param theID        用户自行车id
 *  @param isopen       总开关是否开启定时0未开启 1已开启
 *  @param opentype     解锁是否开启0:未开启 1已开启
 *  @param closetype    锁车是否开启0:未开启1已开启
 *  @param closesettime 锁车时间 22:00
 *  @param closesetweek 锁车的周期 逗号拼接 (1,3,5)
 *  @param opensettime  解锁的时间（07:00）
 *  @param opensetweek  解锁设置的周期(1,2,3) 逗号拼接 1代表周一  7代表周日
 */
+ (void)changeOpenCloseWithID:(NSString *)theID model:(L_TimeSetInfoModel *)model UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 二轮车定时详情（/bike/getbiketimeset）
 {
 "errcode": 0,
 "errmsg": "成功获取二轮车定时详情",
 "map": {
 "isopen": 1,
 "closeinfo": {
 "settime": "22:00",
 "isopen": 1,
 "setweek": "1,2,3,4,5,6,7"
 },
 "id": "b71d034152384c9cbf4f4aa992e226d5",
 "openinfo": {
 "settime": "07:05",
 "isopen": 1,
 "setweek": "1,2,3,4,5,6,7"
 }
 }
 }
 
 */
+ (void)getBikeTimeSetWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 获取二轮车详情

 @param theID id
 @param updataViewBlock
 */
+ (void)getNewBikeInfoWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存和锁定二轮车（/bike/saveandlock）
 *
 *  @param deviceno        设备号-设备号(可以为空)
 *  @param color           颜色-
 *  @param brand           品牌-
 *  @param resourceid      照片ID-照片ID(多个逗号分隔)
 *  @param communityid     社区id-
 *  @param defaultresourceid     默认的照片id-
 *  @param devicetype      二轮车类型 默认0：自行车 1电动车-
 
 */
+ (void)saveAndLockBikeWithDeviceno:(NSString *)deviceno devicetype:(NSString *)devicetype color:(NSString *)color brand:(NSString *)brand resourceid:(NSString *)resourceid  defaultresourceid:(NSString *)defaultresourceid communityid:(NSString *)communityid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得用户的报警记录
 
 @param updataViewBlock
 */
+ (void)getUserBikeAlermWith:(NSInteger)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 删除用户二轮车报警记录

 @param theID 记录id
 @param updataViewBlock
 */
+ (void)removeUserBikeAlermWithID:(NSString *)theID UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
