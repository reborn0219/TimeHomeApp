//
//  QuestionModel.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

/**
 帖子id
 */
@property (nonatomic, strong) NSString *theID;
/**
 帖子类型0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
 */
@property (nonatomic, strong) NSString *posttype;
/**
 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 内容
 */
@property (nonatomic, strong) NSString *content;
/**
 图片列表   picurl	图片地址
 */
@property (nonatomic, strong) NSArray *piclist;
/**
 奖励形势
 */
@property (nonatomic, strong) NSString *rewardtype;
/**
 奖励金额
 */
@property (nonatomic, strong) NSString *rewardmoney;
/**
 是否采纳
 */
@property (nonatomic, strong) NSString *isagree;
/**
 采纳答案
 */
@property (nonatomic, strong) NSDictionary *agreeanswer;
/**
 浏览量
 */
@property (nonatomic, strong) NSString *pvcount;
/**
 回答个数
 */
@property (nonatomic, strong) NSString *answercount;
/**
 发布时间
 */
@property (nonatomic, strong) NSString *releasetime;
/**
 是否我的帖子
 */
@property (nonatomic, strong) NSString *isme;
/**
 是否我收藏过
 */
@property (nonatomic, strong) NSString *iscollect;
/**
 发帖用户id
 */
@property (nonatomic, strong) NSString *userid;
/**
 用户头像
 */
@property (nonatomic, strong) NSString *userpicurl;
/**
 用户昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 性别 1 男  女
 */
@property (nonatomic, strong) NSString *sex;
/**
 年龄
 */
@property (nonatomic, strong) NSString *age;
/**
 是否关注该用户
 */
@property (nonatomic, strong) NSString *isuserfollow;
/**
 社区id
 */
@property (nonatomic, strong) NSString *communityid;
/**
 社区名称
 */
@property (nonatomic, strong) NSString *communityname;

//------------自定义---------------------------

/**
 内容高度，用于计算cell高度
 */
@property (nonatomic, assign) CGFloat contentHeight;

@end
