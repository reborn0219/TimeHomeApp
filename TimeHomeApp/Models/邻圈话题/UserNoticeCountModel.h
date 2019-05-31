//
//  UserNoticeCountModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNoticeCountModel : NSObject<NSCopying,NSCoding>
/**
 *  个人通知总个数
 */
@property (nonatomic, copy) NSString *userallcount;
/**
 *  个人未读个数
 */

@property (nonatomic, copy) NSString *usercount;
/**
 *  最后一条消息内容
 */

@property (nonatomic, copy) NSString *usernotice;
/**
 *  最后一条时间
 */

@property (nonatomic, copy) NSString *userlasttime;


/**
 *  消息类型 0 系统通知 1 物业公告 2 个人消息 4帖子评论 5帖子赞 6活动通知
 */
@property (nonatomic, copy) NSString *type;

/**
 *  消息标题 title
 */

@property (nonatomic, copy) NSString *title;

/**
 *  是否置顶
 */
@property (nonatomic, copy) NSNumber * istop;

/**
 *  标志位
 */
@property (nonatomic, copy) NSDate *  subscript;

/**
 *  头像
 */
@property (nonatomic, copy) NSString * picurl;

/**
 * 对话ID
 */
@property (nonatomic, copy) NSString *receiveID;

@end
