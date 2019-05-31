//
//  ChatPresenter.h
//  YouLifeApp
//
//  Created by UIOS on 15/10/17.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BasePresenters.h"
#import "UserNoticeModel.h"
#import "UserNoticeCountModel.h"

@interface ChatPresenter : BasePresenters


/**
 根据type获取消息通知
 
 @param types 消息类型
 @param block 请求回调
 */
+(void)getUserNoticeCountWithTypes:(NSString *)types :(UpDateViewsBlock)block;


/**
 根据type获取通知详情

 @param type 通知类型
 @param page 页码
 @param block 回调
 */
+(void)getUserNoticeWithType:(NSString *)type andPage: (NSString *)page :(UpDateViewsBlock)block;

/**
  删除单个通知

 @param noticeid 通知ID
 @param type 通知类型
 @param block 回调
 */

+(void)clearOneNotice:(NSString *)noticeid withType:(NSString *)type andBlock:(UpDateViewsBlock)block;

///获得消息个数（/usernotice/getusernoticecount）
+(void)getUserNoticeCount:(UpDateViewsBlock)block;
///获得个人通知（/usernotice/getusernotice）
+(void)getUserNotice:(UpDateViewsBlock)block withPage: (NSString *)page;

///获得未处理的群通知（/groupnotice/getdogroupnotice）
+(void)getDogroupNotice:(UpDateViewsBlock)block;
///获得聊天消息同步数据（/gamsync/getusergamsync）
+(void)getUserGamSync:(UpDateViewsBlock)block withMaxID: (NSString *)maxid;
///搜索社区内的邻友（/user/getappsearchuser）
+(void)getAppSearchuser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name;
///获得我关注的用户（/userfllow/getfllowuser）
+(void)getFllowUser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name andUerID:(NSString *)userid;
///获得我的粉丝用户（/userfllow/gettofllowuser）
+(void)getToFllowuser:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name andUerID:(NSString *)userid;
///获得我的黑名单用户（/userblacklist/getuserblacklist）
+(void)getUserBlackList:(UpDateViewsBlock)block withPage: (NSString *)page andName:(NSString *)name;
///添加黑名单用户（/userblacklist/adduserblacklist）
+(void)addUserBlackList:(UpDateViewsBlock)block withUserID: (NSString *)userid andType:(NSString *)type;
///删除黑名单用户（/userblacklist/removeuserblacklist）
+(void)removeUserBlackList:(UpDateViewsBlock)block withUserID: (NSString *)userid andType:(NSString *)type;
//查找本人关注粉丝和黑名单个数（/user/getrelatedme）
+(void)getAttentionFansBlack:(UpDateViewsBlock)block;
///获得最近在线的用户（/user/getcomlastuser）
+(void)getComLastUser:(UpDateViewsBlock)block withSex: (NSString *)sex andPage:(NSString *)page;
///发送聊天消息（/chat/sendmsg）
+(void)sendChatMsg:(UpDateViewsBlock)block withUserID:(NSString *)userid andMsgType:(NSString *)msgtype andContent:(NSString *)content andResourcesID:(NSString *)resourcesid;

/**
 添加或取消关注

 @param userid 关注用户的userID
 @param block 回调
 @param type 0增加关注 1 取消关注
 */
+(void)addUserFollow:(NSString *)userid withBlock:(UpDateViewsBlock)block withType:(NSString *)type;


///清空个人通知（/usernotice/clearnotice）
+(void)clearNotice:(UpDateViewsBlock)block;

///新版清空接口个人通知（/usernotice/clearnotice）
+(void)clearNotice:(NSString *)type andNotIDs:(NSString *)notIDs withBlock:(UpDateViewsBlock)block;

/**
 删除消息接口

 @param ids 消息id字符串逗号分隔
 @param block 回调
 
 */
+(void)batchdelNotice:(NSString *)ids wihtBlock:(UpDateViewsBlock)block;

@end
