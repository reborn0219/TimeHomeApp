//
//  L_HouseDetailModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 房产，车位model
 */
@interface L_HouseDetailModel : NSObject

/**
 帖子id
 */
@property (nonatomic, strong) NSString *theID;
/**
 帖子类型0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
 */
@property (nonatomic, strong) NSString *posttype;
/**
 10 房产出售 11 房产出租30 车位出售 31 车位出租
 */
@property (nonatomic, strong) NSString *housetype;
/**
 红包类型 0 红包 1 粉包 -1无红包
 */
@property (nonatomic, strong) NSString *redtype;
/**
 红包id
 */
@property (nonatomic, strong) NSString *redid;
/**
 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 内容
 */
@property (nonatomic, strong) NSString *content;
/**
 图片列表
 picurl
 */
@property (nonatomic, strong) NSArray *piclist;
/**
 房产面积
 */
@property (nonatomic, strong) NSString *area;
/**
 金额
 */
@property (nonatomic, strong) NSString *money;
/**
 单价：房产时使用
 */
@property (nonatomic, strong) NSString *price;
/**
 卧室数
 */
@property (nonatomic, strong) NSString *bedroom;
/**
 客厅数
 */
@property (nonatomic, strong) NSString *livingroom;
/**
 卫数
 */
@property (nonatomic, strong) NSString *toilef;
/**
 总楼层
 */
@property (nonatomic, strong) NSString *allfloornum;
/**
 楼层
 */
@property (nonatomic, strong) NSString *floornum;
/**
 装修程度：1领包 2 简装
 */
@property (nonatomic, strong) NSString *decorattype;
/**
 是否地下车位 0 否 1 是
 */
@property (nonatomic, strong) NSString *underground;
/**
 是否固定车位 0 否 1 是
 */
@property (nonatomic, strong) NSString *fixed;
/**
 浏览量
 */
@property (nonatomic, strong) NSString *pvcount;
/**
 点赞个数
 */
@property (nonatomic, strong) NSString *praisecount;
/**
 评论个数
 */
@property (nonatomic, strong) NSString *commentcount;
/**
 最新点赞用户
 userid	用户id
 userpicurl	用户图片url
 nickname	用户昵称

 */
@property (nonatomic, strong) NSArray *praiselist;
/**
 发布时间
 */
@property (nonatomic, strong) NSString *releasetime;
/**
 是否我的帖子
 */
@property (nonatomic, strong) NSString *isme;
/**
 是否我点赞过
 */
@property (nonatomic, strong) NSString *ispraise;
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
 社区id
 */
@property (nonatomic, strong) NSString *communityid;
/**
 社区名称
 */
@property (nonatomic, strong) NSString *communityname;

//------------自定义-----------------------
@property (nonatomic, assign) float firstHeight;

@property (nonatomic, assign) float secondHeight;


@end
