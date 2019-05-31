//
//  UserPublishCar.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我发布的车位model
 */
#import <Foundation/Foundation.h>

@interface UserPublishCar : NSObject

/**
 *  是否收藏
 */
@property(nonatomic,copy) NSString *isfollow;


/**
 *  发布用户id
 */
@property (nonatomic, strong) NSString *userid;
//------------------------------------------------
/**
 *  记录id
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
 *  是否固定车位：0否1是
 */
@property (nonatomic, strong) NSString *fixed;
/**
 *  是否地下车位：0否1 是
 */
@property (nonatomic, strong) NSString *underground;
/**
 *  金额
 */
@property (nonatomic, strong) NSString *money;
/**
 *  求租求购开始金额
 */
@property (nonatomic, strong) NSString *moneybegin;
/**
 *  求租求购结束金额
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

@end
