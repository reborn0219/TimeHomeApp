//
//  USConst.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved


#import "USConst.h"


///用户信息序列化Key
NSString * const USER_INFO_STORAGE_KEY =  @"user_info_storage_key";

//
NSString * const IOS_VERSION_UPGRADE = @"ios_version_upgrade";
NSString * const IOS_LAST_VERSION_NO = @"ios_last_version_no";

//升级地址
NSString * const APP_URL = @"https://itunes.apple.com/cn/lookup?id=1060999015";

///Widget--groupID
NSString * const WIDGET_GROUP_ID = @"group.com.TimeHome.todayNew";



//是否为新版二轮车 0否 1是
NSInteger const kIsNewBikeList = 1;

//首页UI及数据需要刷新
NSString * const kHomeUIInfoNeedRefresh = @"kHomeUIInfoNeedRefresh";

//房产详情需要刷新
NSString * const kHouseInfoNeedRefresh = @"kHouseInfoNeedRefresh";

//任务版签到
NSString * const kTaskBoardSign = @"kTaskBoardSign";

//社区认证需要刷新
NSString * const kCertifyCommunityNeedRefresh = @"kCertifyCommunityNeedRefresh";


//--------声音控制开关--------

//震动
NSString * const kCloseShakeOrNot = @"kCloseShakeOrNot";
//声音
NSString * const kCloseSoundOrNot = @"kCloseSoundOrNot";
//报警声音
NSString * const kAlertSoundOrNot = @"kAlertSoundOrNot";

//--------用户签到相关宏定义--------
NSString * const TankuangAlert = @"isOpenSignUp_pop-out";
NSString * const XuanfuBtn = @"isOpenSignUp_FloatView";

//通知刷新
NSString * const NOTICE_REFRESH_HOME_DATA = @"notice_refresh_home_data";
NSString * const NOTICE_REFRESH_ATTENTION_DATA = @"notice_refresh_attention_data";
NSString * const NOTICE_REFRESH_COLLECT_DATA = @"notice_refresh_collect_data";
NSString * const NOTICE_REFRESH_EDIT_DATA = @"notice_refresh_edit_data";
NSString * const DELETE_LIST_VALUE_OK = @"deleteListValueOK";

//--------默认车位出租出售图片以及ID--------

//出租
NSString * const Parking_rent_id = @"a623ee10aa18425e971e0e8c886eccaf";
NSString * const Parking_rent_url = @"http://timesres.usnoon.com/ext/images/2016-12-22/1482406306880.jpg";

//出售
NSString * const Parking_sell_id = @"a623ee10aa18425e971e0e8c886eccaf";
NSString * const Parking_sell_url = @"http://timesres.usnoon.com/ext/images/2016-12-22/1482406306880.jpg";

//--------默认房产出租出售图片以及ID--------

//出租
NSString * const House_rent_id = @"";
NSString * const House_rent_url = @"";

//出售
NSString * const House_sell_id = @"";
NSString * const House_sell_url = @"";


CGFloat const cell_interval = 0.1;
CGFloat const collection_interval = 20.f;
//头像图片压缩宽高
CGFloat const PIC_HEAD_WH = 240.0;
//图片压缩  比例
CGFloat const PIC_SCALING = 0.5;
///图片压缩  高
CGFloat const PIC_PIXEL_H = 1920.0;
///图片压缩  宽
CGFloat const PIC_PIXEL_W = 1080.0;

//邻趣列表字数显示
NSInteger const wordCount = 30;
NSString * const kHouseListTitle = @"房产列表";
NSString * const kCarListTitle = @"车位列表";
NSString * const kUrl_postsearchhouse = @"url_postsearchhouse";

////App统计Key
 NSString * const ShouYe           = @"shouye";
 NSString * const ZXCFD            = @"zixingchefangdao";//自行车防盗
 NSString * const ChePaiJiuCuo     = @"chepaijiucuo";//车牌纠错
 NSString * const DengLu           = @"denglu";
 NSString * const ZhuCeYe          = @"zhuceye";
 NSString * const CheWeiGuanLi     = @"cheweiguanli";
 NSString * const YaoYaoTongXing   = @"yaoyaotongxing";
 NSString * const FangKeTongXing   = @"fangketongxing";
 NSString * const ZaiXianBaoXiu    = @"zaixianbaoxiu";
 NSString * const JianYiTouSu      = @"jianyitousu";
 NSString * const SheQuGongGao     = @"shequgonggao";
 NSString * const QiCheGuanJia     = @"qicheguanjia";
 NSString * const ZhiNengJiaJu     = @"zhinengjiaju";
 NSString * const SheQuJingWu      = @"shequjingwu";
 NSString * const LinQu            = @"linqu";
 NSString * const LinQu_TieZi      = @"linqu_tiezi";
 NSString * const XiaoXi           = @"xiaoxi";
 NSString * const WoDe             = @"wode";
 NSString * const YuE              = @"yue";
 NSString * const JiFen            = @"jifen";
 NSString * const SheZhi           = @"shezhi";
 NSString * const HuoDong          = @"huodong";
 NSString * const ShouCang         = @"shoucang";
 NSString * const GerenZhuYe       = @"gerenzhuye";
 NSString * const XiaoQu           = @"xiaoqu";
 NSString * const FangKe           = @"fangke";
 NSString * const BaoXiu           = @"baoxiu";
 NSString * const TouSu            = @"tousu";
 NSString * const GeRenSheZhi      = @"gerenshezhi";
 NSString * const PingAnSheQu      = @"pinganshequ";
 NSString * const WoDeGuanZhu      = @"wodeguanzhu";
 NSString * const WoDePingLun      = @"wodepinglun";
 NSString * const JiFenShangCheng  = @"jifenshangcheng";
 NSString * const WoDeDingDan      = @"wodedingdan";
 NSString * const WoDePiaoQuan     = @"wodepiaoquan";
 NSString * const WoDeFaBu         = @"wodefabu";
 NSString * const QianDao          = @"qiandao";
 NSString * const ChouJang         = @"choujiang";

