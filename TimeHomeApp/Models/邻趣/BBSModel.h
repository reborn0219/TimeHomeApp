//
//  BBSModel.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/11/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSModel : NSObject

/**
 是否置顶
 */
@property (nonatomic, copy) NSString *istop;
/**
 帖子序列id
 */
@property (nonatomic, copy) NSString *pkid;
/**
 帖子id
 */
@property (nonatomic, copy) NSString *theid;
/**
 广告id
 */
@property (nonatomic, copy) NSString *advid;
/**
 广告类型
 */
@property (nonatomic, copy) NSString *advtype;
/**
 广告插入位置
 */
@property (nonatomic, copy) NSString *shownumber;
/**
 通栏广告图片
 */
@property (nonatomic, copy) NSString *picurl;
/**
 广告跳转类型
 */
@property (nonatomic, copy) NSString *gototype;
/**
 帖子类型
 */
@property (nonatomic, copy) NSString *posttype;
/**
 帖子标题
 */
@property (nonatomic, copy) NSString *title;
/**
 帖子内容
 */
@property (nonatomic, copy) NSString *content;
/**
 红包类型
 */
@property (nonatomic, copy) NSString *redtype;
/**
 红包id
 */
@property (nonatomic, copy) NSString *redid;
/**
 图片列表
 */
@property (nonatomic, copy) NSArray *piclist;
/**
 奖励类型（问答）
 */
@property (nonatomic, copy) NSString *rewardtype;
/**
 奖励金额（问答）
 */
@property (nonatomic, copy) NSString *rewardmoney;
/**
 商品价格
 */
@property (nonatomic, copy) NSString *goodsprice;
/**
 金额（房产车位）
 */
@property (nonatomic, copy) NSString *money;
/**
 单价（房产车位）
 */
@property (nonatomic, assign) float price;
/**
 房产贴类型（房产车位）
 */
@property (nonatomic, copy) NSString *housetype;
/**
 房产面积平米（房产车位）
 */
@property (nonatomic, assign) float area;
/**
 卧室数（房产车位）
 */
@property (nonatomic, copy) NSString *bedroom;
/**
 客厅数（房产车位）
 */
@property (nonatomic, copy) NSString *livingroom;
/**
 卫生间数（房产车位）
 */
@property (nonatomic, copy) NSString *toilef;
/**
 总楼层（房产车位）
 */
@property (nonatomic, copy) NSString *allfloornum;
/**
 楼层（房产车位）
 */
@property (nonatomic, copy) NSString *floornum;
/**
 装修程度（房产车位）
 */
@property (nonatomic, copy) NSString *decorattype;
/**
 是否地下车位（房产车位）
 */
@property (nonatomic, copy) NSString *underground;
/**
 是否固定车位（房产车位）
 */
@property (nonatomic, copy) NSString *fixed;
/**
 投票项（投票）
 */
@property (nonatomic, copy) NSArray *itemlist;
/**
 投票类型（图片或文字）（投票）
 */
@property (nonatomic, copy) NSString *pictype;
/**
 投票状态（投票）
 */
@property (nonatomic, copy) NSString *votostate;
/**
 投票项数量（投票）
 */
@property (nonatomic, assign) NSString *itemcount;
/**
 用户id
 */
@property (nonatomic, copy) NSString *userid;
/**
 用户头像
 */
@property (nonatomic, copy) NSString *userpicurl;
/**
 用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 用户社区id
 */
@property (nonatomic, copy) NSString *communityid;
/**
 用户社区名称
 */
@property (nonatomic, copy) NSString *communityname;
/**
 评论个数
 */
@property (nonatomic, copy) NSString *commentcount;
/**
 点赞个数
 */
@property (nonatomic, copy) NSString *praisecount;
/**
 详情页地址
 */
@property (nonatomic, copy) NSString *gotourl;
/**
 帖子高度
 */
@property (nonatomic, assign) float height;

/**
 几天后下架
 */
@property (nonatomic, strong) NSString *tonow;

/**
 分享链接url
 */
@property (nonatomic, strong) NSString *sharegotourl;

/**
 发布时间
 */
@property (nonatomic, strong) NSString *releasetime;

/**
 是否点赞
 */
@property (nonatomic, strong) NSString *ispraise;

/**
 车位房产列表url
 */
@property (nonatomic, strong) NSString *url_postsearchhouse;

//------------02.07 自定义---------------------------

/**
 内容高度，用于计算cell高度
 */
@property (nonatomic, assign) CGFloat contentHeight;


@end
