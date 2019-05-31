//
//  PANewHomeService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PANewHomeNewsModel.h"
#import "PANewHomeActivityModel.h"
#import "PANewHomeMenuModel.h"
#import "PANewHomeBannerModel.h"
#import "PANewHomeNoticeModel.h"
#import "AppNoticeSet.h"
#import "L_ResiListModel.h"
#import "L_ResiCarListModel.h"
@interface PANewHomeService : PABaseRequestService

@property (nonatomic, strong)NSArray * newsArray;
@property (nonatomic, strong)NSArray * activityArray;
@property (nonatomic, strong)NSArray * menuArray;
//banner模型数组
@property (nonatomic,strong) NSMutableArray <__kindof PANewHomeBannerModel*> *bannerArray;
@property (nonatomic, strong)AppNoticeSet * noticeSet;
@property (nonatomic, assign)BOOL haveHouse;//是否拥有住宅
@property (nonatomic, assign)BOOL haveParking;//是否拥有车位
@property (nonatomic, assign)NSInteger resipower;//是否拥有房产操作权限
@property (nonatomic, assign)NSInteger proreserve;//是否开通在线报修功能
@property (nonatomic, strong)NSArray * waitHouseArray;//待认证房产列表
@property (nonatomic, strong)NSArray * waitParkingArray;//待认证车位列表
@property (nonatomic, assign)BOOL firshShowSignUp;//签到第一次加载
@property (nonatomic, assign)BOOL isSignUp; //是否签到
@property (nonatomic, strong)NSDictionary * signUpDic;//签到详情
//公告数据
@property (nonatomic,strong) NSMutableArray <__kindof PANewHomeNoticeModel*>*noticeArray;

//弹窗字典
@property (nonatomic,strong) NSDictionary *alertDict;

/**
 加载zaker新闻数据

 @param success 成功
 @param failed 失败
 */
- (void)loadNewsDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed;


/**
 加载活动数据

 @param success 成功
 @param failed 失败
 */
- (void)loadActivityDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed;


/**
 加载menuData

 @param success 成功
 @param failed 失败
 */
- (void)loadMenuDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed;





/**
 获取banner数据
 */
- (void)loadBannerSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取公告数据
 */
- (void)loadNoticeSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取弹窗数据
 */
- (void)loadAlertSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取消息设置类

 @param success success description
 @param failure failure description
 */
- (void)loadSettingInfoSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取个人住宅信息

 @param success success description
 @param failure failure description
 */
- (void)loadResidenceSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取个人车位信息

 @param success success description
 @param failure failure description
 */
- (void)loadParkingDataSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取个人权限信息

 @param success success description
 @param failure failure description
 */
- (void)loadUserAuthDataSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取用户签到设置

 @param success success description
 @param failure failure description
 */
- (void)loadUserSignSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获得当前社区的待认证房产与车位

 @param communityId 社区ID
 @param success success description
 @param failure failure description
 */
- (void)loadWaitCertInfoWithCommunityId:(NSString *)communityId success:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;

/**
 获取当前用户签到详情

 @param success success description
 @param failure failure description
 */
- (void)loadUserSignInfoSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;
@end
