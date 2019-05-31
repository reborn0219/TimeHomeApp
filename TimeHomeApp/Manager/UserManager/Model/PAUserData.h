//
//  PAUserData.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/7/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAUserData : NSObject
//----------------------------------------------------------

/**
 社区帖子主页
 */
@property (nonatomic, strong) NSString *url_gamcommindex;

/**
 房产贴发布
 */
@property (nonatomic, strong) NSString *url_posthouse;

/**
 个人主页
 */
@property (nonatomic, strong) NSString *url_gamuserindex;

/**
 商品帖发布
 */
@property (nonatomic, strong) NSString *url_postaddgoods;

/**
 普通帖发布
 */
@property (nonatomic, strong) NSString *url_postadd;

/**
 问答贴发布
 */
@property (nonatomic, strong) NSString *url_postaddasn;

/**
 投票贴发布
 */
@property (nonatomic, strong) NSString *url_postaddvoto;

/**
 车位贴发布
 */
@property (nonatomic, strong) NSString *url_postparkingarea;

/**
 车位，房产列表地址
 */
@property (nonatomic, strong) NSString *url_postsearchhouse;

//----------------------------------------------------------

/**
 业主认证 0否1是
 */
@property (nonatomic, strong) NSString *isowner;
/**
 实名认证 0否1是
 */
@property (nonatomic, strong) NSString *isvaverified;

//----------------------------------------------------------
///是否显示开始引导图 YES 不显示，NO 显示
@property(nonatomic,strong)NSNumber * isGuide;

///是否记住密码 YES 记住，NO 不记住
@property(nonatomic,strong)NSNumber * isRememberPw;

///是否登录 YES 是，NO 没有登录
@property(nonatomic,strong)NSNumber * isLogIn;
/**
 *  账号(登录保存)
 */
@property(nonatomic, strong) NSString *accPhone;
/**
 *  密码(登录保存，用于设置新密码本地判断)
 */
@property(nonatomic, strong) NSString *passWord;
/**
 *  令牌
 */
@property(nonatomic, strong) NSString *token;
//--------------------我的界面用户信息-------------------------
/**
 *  用户id
 */
@property(nonatomic, strong) NSString *userID;
/**
 *  手机号
 */
@property(nonatomic, strong) NSString *phone;
/**
 *  图像地址
 */
@property(nonatomic, copy) NSString *userpic;
/**
 *  用户昵称
 */
@property(nonatomic, strong) NSString *nickname;
/**
 *  用户真实姓名
 */
@property(nonatomic, strong) NSString *name;
/**
 *  积分
 */
@property(nonatomic, strong) NSString *integral;
/**
 *  余额
 */
@property(nonatomic, strong) NSString *balance;
/**
 *  用户级别
 */
@property(nonatomic, strong) NSString *level;
/**
 *  性别 1 男 2 女 9其他
 */
@property(nonatomic, strong) NSString *sex;
/**
 *  生日   1990-01-01
 */
@property(nonatomic, copy) NSString *birthday;
/**
 *  岁数
 */
@property(nonatomic, strong) NSString *age;
/**
 *  星座
 */
@property(nonatomic, copy) NSString *constellation;
/**
 *  个性名称
 */
@property(nonatomic, copy) NSString *signature;
/**
 *  个性标签
 */
@property(nonatomic, copy) NSString *selftag;
/**
 *  楼栋号
 */
@property(nonatomic, copy) NSString *building;
/**
 *  是否显示真实名称 1 是 0 否
 */
@property(nonatomic, strong) NSString *isshowname;
/**
 *  是否显示楼栋号   1 是 0 否
 */
@property(nonatomic, strong) NSString *isshowbuilding;

//----------------------登录返回增加的信息-----------------------------
/**
 *  社区Id
 */
@property(nonatomic, strong) NSString *communityid;
/**
 *  社区名称
 */
@property(nonatomic, copy) NSString *communityname;
/**
 *  社区地址
 */
@property(nonatomic, copy) NSString *communityaddress;
/**
 *  住宅Id 默认智能家居住宅id
 */
@property(nonatomic, copy) NSString *residenceid;
/**
 *  住宅名称
 */
@property(nonatomic, copy) NSString *residencename;

/**
 *  城市id
 */
@property(nonatomic, strong) NSString *cityid;
/**
 *  城市名称
 */
@property(nonatomic, copy) NSString *cityname;
/// 区域id
@property(nonatomic, copy) NSString * countyid;
/// 区域名称
@property(nonatomic, copy) NSString * countyname;

//------------商城---------
///商城URL
@property(nonatomic,copy) NSString * mallindexurl;
///商城搜索URL
@property(nonatomic,copy) NSString * mallsearchurl;
///商城附近
@property(nonatomic,copy) NSString * mallnearurl;

//---------------党建----------------
///党建
@property(nonatomic,copy) NSString * partyurl;

//--------------新闻URL--------------
///新闻地址
@property(nonatomic,copy) NSString * urlnewslist;

/**
 *   policeurl 警务信息链接地址
 */
@property (nonatomic, strong) NSString *policeurl;

//-----------------功能限制标志----------------
/** 字典当前社区 开通情况 如果社区id为空 则返回“”   。1 为开通0 为未开通
 procar    智能门禁
 protraffic    访客通行
 proreserve    在线保修
 pronotice    物业公告
 procomplaint    物业投诉
 serresi    二手房产
 serparking    二手车位
 serused    二手置换
 cmmparty  社区
 police是否开通警务信息
 */
@property(nonatomic,copy) NSDictionary * openmap;

//---------------------------------------------------
/**
 *  活跃天数
 */
@property(nonatomic, copy) NSString *activedays;
/**
 *  相差天数
 */
@property(nonatomic, copy) NSString *upgradedays;
/**
 *  上一等级所需的天数
 */
@property (nonatomic, strong) NSString *leveldays;
//----------------------登录返回增加的信息-----------------------------

//----------推要绑定的标签--------

@property(nonatomic,copy) NSArray * taglist;
///智能家居
@property(nonatomic,copy) NSString * homeintrourl;

///车牌省字母跟据社区默认值
@property(nonatomic,copy) NSString * carprefix;

///当前社区纬度
@property(nonatomic,copy) NSString * lat;
///当前社区经度
@property(nonatomic,copy) NSString * lng;

/**
 消防URL
 */
@property (nonatomic, copy) NSString *firedescurl;

/**
 拓展数据
 */
@property (nonatomic, copy) NSDictionary *expandata;

/**
 平安社区URL
 */
@property (nonatomic, copy) NSString *safehomeurl;

@end
