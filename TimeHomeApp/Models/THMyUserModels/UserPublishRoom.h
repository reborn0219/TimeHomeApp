//
//  UserPublishRoom.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我发布的房源和我发布的二手物品共用
 */
#import <Foundation/Foundation.h>

@interface UserPublishRoom : NSObject

/**
 *  是否收藏
 */
@property(nonatomic,copy) NSString *isfollow;

//------------我发布的二手物品独有的属性---------------------------------
/**
 *  物品名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  新旧程度 0 全部 4 五成新一下 5 成新 6、7、8、9、10全新
 */
@property (nonatomic, strong) NSString *newness;

///物品类型id
@property(nonatomic,copy) NSString *  typeId;
///物品类型名称
@property(nonatomic,copy) NSString *  typeName;
//---------------------------------------------
/**
 *  信息id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  信息类型：0 出租 1 买卖 2 求租 3 求购
 */
@property (nonatomic, strong) NSString *sertype;
/**
 *  区域id
 */
@property (nonatomic, strong) NSString *countyid;
/**
 *  区域名称
 */
@property (nonatomic, strong) NSString *countyname;
/**
 *  社区名称
 */
@property (nonatomic, strong) NSString *communityname;
/**
 *  坐标X
 */
@property (nonatomic, strong) NSString *mapx;
/**
 *  坐标Y
 */
@property (nonatomic, strong) NSString *mapy;
/**
 *  地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *descriptionString;
/**
 *  面积
 */
@property (nonatomic, strong) NSString *area;
/**
 *  楼层
 */
@property (nonatomic, strong) NSString *floornum;
/**
 *  总楼层数
 */
@property (nonatomic, strong) NSString *allfloornum;
/**
 *  卧室数
 */
@property (nonatomic, strong) NSString *bedroom;
/**
 *  客厅数 如果为出租 则 1 2 3 4 99 分别表示 整租一室，整租两室，整租三室，整租四室及以上，单间合租
 */
@property (nonatomic, strong) NSString *livingroom;
/**
 *  卫数
 */
@property (nonatomic, strong) NSString *toilef;
/**
 *  装修类型：1 毛坯 2 简装 3 中等装修 4 精装 5 豪装
 */
@property (nonatomic, strong) NSString *decorattype;
/**
 *  建造年份
 */
@property (nonatomic, strong) NSString *buildyear;
/**
 *  房间朝向：1 南北通透 2 东西通透 3 东向 4 西向 5 南向 6 北向 7 东北向 8 东南向 9 西北向 10 西南向
 */
@property (nonatomic, strong) NSString *facetype;
/**
 *  房间类型：1普通住宅2经济适用房3公寓4商住楼5酒店式公寓
 */
@property (nonatomic, strong) NSString *housetype;
/**
 *  产权年份
 */
@property (nonatomic, strong) NSString *propertyyear;
/**
 *  产证是否在手 1 是 0 否
 */
@property (nonatomic, strong) NSString *isinhand;
/**
 *  金额
 */
@property (nonatomic, strong) NSString *money;
/**
 *  金额区间开始 求购求组使用
 */
@property (nonatomic, strong) NSString *moneybegin;
/**
 *  金额区间结束 求购求租使用
 */
@property (nonatomic, strong) NSString *moneyend;
/**
 *  联系人
 */
@property (nonatomic, strong) NSString *linkman;
/**
 *  联系电话
 */
@property (nonatomic, strong) NSString *linkphone;
/**
 *  发布日期
 */
@property (nonatomic, strong) NSString *releasedate;
/**
 *  创建时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 *  0 已发布 1 已保存
 */
@property (nonatomic, strong) NSString *flag;
/**
 *  照片集合
 */
@property (nonatomic, strong) NSArray *piclist;

///发布用户id 用于聊天
@property(nonatomic,copy) NSString *userid;

@end
