//
//  UserNoticeModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
 *  个人通知model
 */
@interface UserNoticeModel : NSObject
/**
 *  动态id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  类型 0 系统通知 1 物业公告
 */
@property (nonatomic, strong) NSString *type;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  内容标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  内容
 */
@property (nonatomic, strong) NSString *content;
/**
 *  时间
 */
@property (nonatomic, strong) NSString *systime;
///内容高度
@property(nonatomic, assign)CGFloat contentHeight;

//------2.4新增 2017.03.15-------我的票券，订单-------------

/**
 判断是否为兑换券消息
 {
     goodslogid  对应的兑换id
     isexchange 是否是赠予券
 }
 */
@property(nonatomic, strong) NSDictionary *jsondata;
//@property (nonatomic, strong) NSDictionary *jsonDic;

//------2.4新增 2017.02.21-------帖子相关-------------
/**
 帖子id
 */
@property (nonatomic, copy) NSString *postid;
/**
 帖子类型
 */
@property (nonatomic, copy) NSString *posttype;

//------2.3新增 01.10-------帖子链接-------------
@property (nonatomic, strong) NSString *gotourl;
@property (nonatomic, copy)   NSString *isclick;
@property (nonatomic, assign)   BOOL isSelect;
@end
