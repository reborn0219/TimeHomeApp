//
//  AppSystemSetPresenters.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface AppSystemSetPresenters : BasePresenters

/**
    获得系统中的区域
 */
+(void)getCityAreasUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    通过城市名称获得城市id
 */
+(void)getCityIDName:(NSString *)name UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    获得系统资源中的图片接口
 */
+(void)getSysPicType:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    图片上传接口
 */
+(void)upLoadPicFile:(id)objc UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
+(void)upLoadPicFile:(id)objc withUsedtype:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    语音上传接口
 */
+(void)upLoadVoiceFile:(id)file UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得首页弹窗接口
 */

+(void)getAlertUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    获得首页轮播图接口
 */
+(void)getBannerUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    保存系统错误日志
 */
+(void)addErrorLogTitle:(NSString *)title content:(NSString *)content UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
    保存用户反馈
 */
+(void)addFeedBackContent:(NSString *)content UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

///获得需要绑定的标签（/system/getbindingtag）
+(void)getBindingTag;
/**
 *  分享统计
 *  新增sourceid 来源id      postid 和活动id
 *  @param type            0 app下载 1 社区公告 2 社区新闻 3 访客通行 4 帖子 5 活动 6 关于我们
 *  @param totype          1 微信好友 2 微信朋友圈 3 qq好友 4 qq空间
 *  @param gotourl         分享地址
 */
+ (void)sharedDoforwardType:(NSString *)type totype:(NSString *)totype gotourl:(NSString *)gotourl sourceid:(NSString *)sourceid UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
/**
 *  获取服务器当前时间
 */
+ (void)getSystemTimeUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 2.3版本增加 是否需要强制更新App
 
 @param version App传入的版本号 返回参数为errcode ,errmsg,updstate, updstate 1为强制更新，2为普通更新，3为不更新，errcode统一返回0
 @param updataViewBlock
 */
+ (void)isVersionUpdWithVersion:(NSString *)version UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得当前登录社区是否开通车牌纠错设置（/carcorrection/iscorrectionset）
 
 @param updataViewBlock
 */
+ (void)getCarCorrectionSetWithPlatform:(NSString *)platform UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


@end
