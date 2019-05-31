//
//  ChatPresenter.h
//  YouLifeApp
//
//  Created by UIOS on 15/10/17.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BasePresenters.h"

@interface ChatPresenter : BasePresenters

///邻友列表
-(void)getFriendList:(NSInteger) PageNo ;
///搜索邻友
-(void)findFriend:(NSString *) phoneNo;
///发消息
-(void)sendMsg:(NSArray *)msgArr;
///获取聊天记录
-(void)getMsgLog:(NSString *)UserID WithPage:(NSString *)PageNo;
///获取黑名单
-(void)getBlacklist:(NSString *)PageNo;
///加入黑名单
-(void)saveBlacklist:(NSString *)UserID;
///删除黑名单
-(void)delBlacklist:(NSString *)UserID;
///获取未读消息
-(void)getUnreadMsg:(NSString *)UserID;
///获得聊天好友列表
-(void)getFriendMsg:(NSString *)PageNo;
///获得邻友信息
-(void)getFriendInfo:(NSString *)UserID;


@end
