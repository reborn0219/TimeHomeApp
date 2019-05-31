//
//  AppPayPresenter.h
//  TimeHomeApp
//
//  Created by 优思科技 on 16/10/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
///支付宝支付
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "AppPayPresenter.h"
#import "WXApi.h"

#define APPWXPAYMANAGER [AppPayPresenter sharePresenter]

typedef void(^AppAlipayCallBack)(NSDictionary *dict);

@interface AppPayPresenter : BasePresenters<WXApiDelegate>

/**
 微信回调
 */
@property (nonatomic, copy) void(^callBack)(enum WXErrCode errCode);

/**
 支付宝回调
 */
@property (nonatomic, copy) AppAlipayCallBack appAlipayCallBack;

/**
 单例支付类
 */
+ (instancetype)sharePresenter;
//------------------------微信支付封装 2016.12.5 by Shibo------------------------------
/**
 *  @author Clarence
 *
 *  跳转url
 */
- (BOOL)usPay_handleUrl:(NSURL *)url;
/**
 *  @author Clarence
 *
 *  第一次启动的时候需要注册微信
 */
- (BOOL)usPay_registerAppWithUrlSchemes:(NSString *)urlSchemes;
/**
 *  @author Clarence
 *
 *  发起支付
 */
- (BOOL)usPay_payWithPayReq:(PayReq *)req callBack:(void(^)(enum WXErrCode errCode))callBack;

//------------------------微信支付------------------------------

+(void)getOrderNo:(NSDictionary *)param callBack:(UpDateViewsBlock)updataViewBlock;

/**
 支付宝
 */
- (void)doAlipayPayWithOrderString:(NSString *)orderString CallBack:(AppAlipayCallBack)callBack;


@end
