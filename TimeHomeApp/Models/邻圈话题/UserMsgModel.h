//
//  UserMsgModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  邻圈未读消息
 */
@interface UserMsgModel : NSObject
/**
 *  1 回复 2 赞 3删除
 */
@property (nonatomic, strong) NSString *msgtype;
/**
 *  内容
 */
@property (nonatomic, strong) NSString *msgcontent;
/**
 *  消息时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 *  消息id
 */
@property (nonatomic, strong) NSString *postsid;
/**
 *  内容
 */
@property (nonatomic, strong) NSString *postscontent;
/**
 *  首图 没有则为””
 */
@property (nonatomic, strong) NSString *postspic;
/**
 *  用户id
 */
@property (nonatomic, strong) NSString *userid;
/**
 *  昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 *  头像地址
 */
@property (nonatomic, strong) NSString *userpic;
/**
 *  超链接地址
 */
@property (nonatomic, strong) NSString *postsgotourl;
///
@property (nonatomic, assign)CGFloat cellHight;

///删除帖子消息标示
@property (nonatomic, strong)NSString * delposts;

@end
