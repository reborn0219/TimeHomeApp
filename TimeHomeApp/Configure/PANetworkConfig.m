//
//  PANetworkConfig.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------网络地址------------------------------------------------

#if isProduction == 1

/***************************生产环境***************************/

#define SERVER_BASE_URL             @"http://api.usnoon.com"//平安社区App主域名
#define SERVER_BASE_PIC_URL         @"http://timesres.usnoon.com"//平安社区 图片服务器地址
#define SERVER_BASE_TOPIC_URL       @"http://gamapi.usnoon.com"//平安社区 帖子服务器地址
#define SERVER_BASE_SHOP_URL        @"http://shop.usnoon.com"//平安社区 商城 服务器地址
#define SERVER_BASE_CARERROR_URL    @"http://apis.usnoon.com"//平安社区 车牌纠错服务器地址
#define SERVER_BASE_H5_URL          @"https://actives.usnoon.com/Actives/achtml" //平安社区 H5 相关页面 服务器地址
#define SERVER_BASE_ROUTE_URL       @"http://apient.usnoon.com/api/api" //平安社区 红包 服务器地址
#define SERVER_BASE_PARK_URL        @"http://property.pasq.com/" //平安社区 新车库 主域名
#define SERVER_BASE_AUTH_URL        @"http://one.pasq.com/" //平安社区 App权限 域名
#define SERVER_BASE_PROPERTY_URL    @"http://preone.pasq.com/" //平安社区 新物管 服务器地址
#define SERVER_BASE_HTML_URL @"http://api.usnoon.com/apphtml2/"// 平安社区物管二期 html 地址
#elif isProduction == 2

/***************************准生产环境***************************/

#define SERVER_BASE_URL             @"http://59.110.51.79:8080/times/"//平安社区App主域名
#define SERVER_BASE_PIC_URL         @"http://59.110.29.224:9030/times"//平安社区 图片服务器地址
#define SERVER_BASE_TOPIC_URL       @"http://59.110.29.224:9030/times_gamapi"//平安社区 帖子服务器地址
#define SERVER_BASE_SHOP_URL        @"http://shop.usnoon.com"//平安社区 商城 服务器地址
#define SERVER_BASE_CARERROR_URL    @"http://test.usnoon.com/times"//平安社区 车牌纠错服务器地址
#define SERVER_BASE_H5_URL          @"https://actives.usnoon.com/Actives/achtml" //平安社区 H5 相关页面 服务器地址
#define SERVER_BASE_ROUTE_URL       @"http://newwg.usnoon.com/api_entrance/" //平安社区 红包 服务器地址
#define SERVER_BASE_PARK_URL        @"http://newwg.usnoon.com/" //平安社区 新车库 主域名
#define SERVER_BASE_AUTH_URL        @"http://preone.pasq.com/" //平安社区 App权限 域名
#define SERVER_BASE_PROPERTY_URL    @"http://preproperty.pasq.com/api" //平安社区 新物管 服务器地址
#define SERVER_BASE_HTML_URL @"http://test.usnoon.com:9030/times/apphtml/"// 平安社区物管二期 html 地址


#elif isProduction == 3

/***************************测试环境***************************/

#define SERVER_BASE_URL              @"http://test.usnoon.com/times"//平安社区App主域名
#define SERVER_BASE_PIC_URL         @"http://59.110.29.224:9030/times"//平安社区 图片服务器地址
#define SERVER_BASE_TOPIC_URL       @"http://59.110.29.224:9030/times_gamapi"//平安社区 帖子服务器地址
#define SERVER_BASE_SHOP_URL        @"http://shop.usnoon.com"//平安社区 商城 服务器地址
#define SERVER_BASE_CARERROR_URL    @"http://test.usnoon.com/times"//平安社区 车牌纠错服务器地址
#define SERVER_BASE_H5_URL          @"https://actives.usnoon.com/Actives/achtml" //平安社区 H5 相关页面 服务器地址
#define SERVER_BASE_ROUTE_URL       @"http://newwg.usnoon.com/api_entrance/" //平安社区 红包 服务器地址
#define SERVER_BASE_PARK_URL        @"http://newwg.usnoon.com/" //平安社区 新车库 主域名
#define SERVER_BASE_AUTH_URL        @"http://newwg.usnoon.com/" //平安社区 App权限 域名
#define SERVER_BASE_PROPERTY_URL    @"http://test.usnoon.com:9030/times/apphtml/" //平安社区 新物管 服务器地址
#define SERVER_BASE_HTML_URL @"http://test.usnoon.com:9030/times/apphtml/"// 平安社区物管二期 html 地址

#endif

NSString * const SERVER_URL             = SERVER_BASE_URL;
NSString * const SERVER_PIC_URL         = SERVER_BASE_URL;/** 图片使用 */
NSString * const SERVER_URL_New         = SERVER_BASE_TOPIC_URL;/** 帖子相关接口使用 */
NSString * const kShopSEVER_URL         = SERVER_BASE_SHOP_URL;//正式商城地址
NSString * const kCarError_SEVER_URL    = SERVER_BASE_CARERROR_URL;/** 车牌纠错 */
NSString * const kH5_SEVER_URL          = SERVER_BASE_H5_URL;/** h5相关 */
NSString * const kNewRedPaket_URL       = SERVER_BASE_ROUTE_URL;/*红包*/
NSString * const PA_NEW_SEVER_URL       = SERVER_BASE_PARK_URL;//新车库地址
NSString * const PA_NOTICE_SERVER_URL   = SERVER_BASE_PARK_URL;//车库消息注册
NSString * const PA_AUTH_URL            = SERVER_BASE_AUTH_URL;//app权限获取
NSString * const PA_NEW_NOTICE_URL      = SERVER_BASE_PARK_URL;//新投诉建议接口
NSString * const PA_NEW_NOTICEWEB_URL   = SERVER_BASE_HTML_URL;//新公告web url
/*
//TODO: 挪到对应接口请求的地方 拼接
NSString * const PA_NEW_NOTICEIMAGE_URL     = @"http://preone.pasq.com/oss?fileName=";//新投诉建议图片接口
NSString * const PA_NEW_NOTICEDETAIL_URL    = @"http://preone.pasq.com/times/apphtml/gonggaoxiangqing.html";//新投诉建议详情接口
NSString * const PA_NEW_NOTICESHARE_URL     = @"http://preone.pasq.com/times/apphtml/WX-gonggaoxiangqing.html";//新投诉详情分享URL
*/
//普通帖分享地址
NSString * const kSharePPTReleaseDetailUrl = @"/APP/pptReleaseDetailsShare.html?postid=";
//问答帖分享地址
NSString * const kShareQuestionDetailUrl = @"/APP/questionDetailsShare.html?postid=";
//房产车位帖分享地址
NSString * const kShareHouseOrCarDetailUrl = @"/APP/house_detailsShare.html?postid=";
// 汽车管家 标签地址
NSString * const kActivesCarHouseKeeperUrl = @"/20170720/Explain.html";
// 语音识别 帮助地址
NSString * const kVoiceSpeechRecognitionHelpUrl = @"/apphtml/voiceHelp.html";

