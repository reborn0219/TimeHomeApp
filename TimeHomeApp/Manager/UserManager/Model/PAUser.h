//
//  PAUser.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAH5Url.h"

@interface PAUserInfo : NSObject
///令牌
@property(nonatomic, strong) NSString *token;
///用户id
@property(nonatomic, strong) NSString *userID;
///新平台用户ID
@property(nonatomic, copy) NSString * opid;
/// 生日   1990-01-01
@property(nonatomic, copy) NSString *birthday;
///用户昵称
@property(nonatomic, copy) NSString *nickname;
///性别 1 男 2 女 9 其他
@property(nonatomic, copy) NSString *sex;
///用户真实姓名
@property(nonatomic, copy) NSString *name;
///年龄
@property(nonatomic, copy) NSString *age;
/// 手机号
@property(nonatomic, copy) NSString *phone;
///是否显示楼号：0否 1是
@property(nonatomic, copy) NSString *isshowbuilding;
///是不是业主 0为否 1为是
@property(nonatomic, copy) NSString *isowner;
///实名认证
@property(nonatomic, copy) NSString *isvaverified;
///星座
@property(nonatomic, copy) NSString *constellation;
///用户修改签名
@property(nonatomic, copy) NSString *signature;
///账户余额
@property(nonatomic, copy) NSString *balance;
///是否显示真实姓名：0 否 1 是
@property(nonatomic, copy) NSString *isshowname;
///用户等级
@property(nonatomic, copy) NSString *level;
///用户可用积分
@property(nonatomic, copy) NSString *integral;
///图片资源ID
@property(nonatomic, copy) NSString *picid;
///是否升级 默认0 1推送
@property(nonatomic, copy) NSString *isupgrade;
/// 头像地址
@property(nonatomic, copy) NSString *userpic;
@end

#pragma mark - 社区功能开通情况
@interface PAPowerInfo : NSObject
///警务信息 0：未开通 1：已开通
@property(nonatomic, copy) NSString * police;
///社区党政 0：未开通 1：已开通
@property(nonatomic, copy) NSString * cmmparty;
///物业投诉 0：未开通 1：已开通
@property(nonatomic, copy) NSString * procomplaint;
///二手房产 0：未开通 1：已开通
@property(nonatomic, copy) NSString * serresi;
///收费管理
@property(nonatomic, copy) NSString * charge;
///是否开通车牌纠错：0否1是
@property(nonatomic, copy) NSString * correctioncar_comm;
///二手车位 0：未开通 1：已开通
@property(nonatomic, copy) NSString * serparking;
///平安泊车车牌纠错：0否1是
@property(nonatomic, copy) NSString * correctioncar_park;
///物业公告 0：未开通 1：已开通
@property(nonatomic, copy) NSString * pronotice;
///商库后台管理：0否1是
@property(nonatomic, copy) NSString * parkinglotbackstage;
///二手置换 0：未开通 1：已开通
@property(nonatomic, copy) NSString * serused;
///无
@property(nonatomic, copy) NSString * caroperation;
///智能门禁 0：未开通 1：已开通
@property(nonatomic, copy) NSString * procar;
///导入车牌：0否1是
@property(nonatomic, copy) NSString * addcars;
///在线保修 0：未开通 1：已开通
@property(nonatomic, copy) NSString * proreserve;
///访客通行 0：未开通 1：已开通
@property(nonatomic, copy) NSString * protraffic;
///是否是新社区：0否1是
@property(nonatomic, copy) NSString * isnew;
///房产是否认证 1：认证 0：未认证
@property(nonatomic, copy) NSString * isownercert;
///社区权限
@property(nonatomic, copy) NSString * isresipower;
///用户在社区下角色类型 1 业主 2 家人 3 租户
@property(nonatomic, copy) NSString * ownerpowertype;
@end

@interface PACommunityInfo : NSObject
///楼栋号
@property(nonatomic, copy) NSString *building;
/// 社区Id
@property(nonatomic, strong) NSString *communityid;
///社区名称
@property(nonatomic, copy) NSString *communityname;
///社区地址
@property(nonatomic, copy) NSString *communityaddress;
///住宅Id 默认智能家居住宅id
@property(nonatomic, copy) NSString *residenceid;
/// 住宅名称
@property(nonatomic, copy) NSString *residencename;
/// 城市id
@property(nonatomic, strong) NSString *cityid;
/// 城市名称
@property(nonatomic, copy) NSString *cityname;
/// 区域id
@property(nonatomic, copy) NSString * countyid;
/// 区域名称
@property(nonatomic, copy) NSString * countyname;
///当前社区默认车牌首字
@property(nonatomic, copy) NSString * carprefix;
/// 城市维度
@property(nonatomic, copy) NSString * lat;
/// 城市经度
@property(nonatomic, copy) NSString * lng;
@property(nonatomic, strong) NSDictionary * openmap;
@property (nonatomic,strong) PAPowerInfo *powerInfo;

@end

@interface PAUser : NSObject

#pragma mark -- 用户基础信息
@property(nonatomic, strong) PAUserInfo *userinfo;
#pragma mark -- 社区信息
@property(nonatomic, strong) PACommunityInfo *communityInfo;
#pragma mark -- url链接
@property(nonatomic, strong) PAH5Url *urllink;
#pragma mark --标签
@property(nonatomic, strong) NSArray *taglist;

#pragma mark - 用户权限
@property(nonatomic, copy) NSString * resipower;
@property(nonatomic, copy) NSString * complaint;
@property(nonatomic, copy) NSString * shake;
@property(nonatomic, copy) NSString * reserve;

#pragma mark - 权限配置
@property (nonatomic,strong) NSDictionary *ownerpower;

///用户权限配置
@property (nonatomic,strong) NSArray *powerConfig;
@property(nonatomic, copy) NSString * sourceId;
@property(nonatomic, copy) NSString * configname;
@property(nonatomic, copy) NSString * enable;
@property(nonatomic, copy) NSString * nextSourceId;

@end
