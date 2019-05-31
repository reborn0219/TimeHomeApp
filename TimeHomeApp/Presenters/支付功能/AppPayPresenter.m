//
//  AppPayPresenter.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/10/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///支付宝支付

#define SP_URL           @"http://wxpay.wxutil.com/pub_v2/app/app_pay.php"

#import "AppPayPresenter.h"
#import "WXApi.h"

@interface AppPayPresenter ()


@end

@implementation AppPayPresenter
#pragma mark - 单例支付类
/**
 单例支付类
 */
+ (instancetype)sharePresenter {
    static AppPayPresenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
//------------------------微信支付------------------------------
#pragma mark - 跳转url
/**
 *  跳转url
 */
- (BOOL)usPay_handleUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark - 第一次启动的时候需要注册微信
/**
 *  第一次启动的时候需要注册微信
 */
- (BOOL)usPay_registerAppWithUrlSchemes:(NSString *)urlSchemes {
    return [WXApi registerApp:urlSchemes];
}
#pragma mark - 发起支付
/**
 *  发起支付
 */
- (BOOL)usPay_payWithPayReq:(PayReq *)req callBack:(void(^)(enum WXErrCode errCode))callBack {
    // 存储回调
    self.callBack = callBack;
    // 发起支付
    return [WXApi sendReq:req];
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if (self.callBack) {
            self.callBack(resp.errCode);
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.callBack) {
            self.callBack(resp.errCode);
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (self.callBack) {
            self.callBack(resp.errCode);
        }
    }
}
#pragma mark ----注册微信支付-----
+(void)registWXPay:(NSString *)appid {
    [WXApi registerApp:appid withDescription:@"平安社区"];
}

#pragma mark   ==============支付宝点击订单支付==============
- (void)doAlipayPayWithOrderString:(NSString *)orderString CallBack:(AppAlipayCallBack)callBack {
    
    self.appAlipayCallBack = callBack;
    
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"TimeHomeApp";
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
        if (self.appAlipayCallBack) {
            self.appAlipayCallBack(resultDic);
        }
        
    }];
    
    
//    重要说明
//    这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
//    真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
//    防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
//    ============================================================================
//    =======================需要填写商户app申请的===================================
//    ============================================================================
//    NSString *appID = PARTNER;
//     如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
//     如果商户两个都设置了，优先使用 rsa2PrivateKey
//     rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
//     获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
//     工具地址：https:doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
//    NSString *rsa2PrivateKey = PRIVATE_KEY;
//    
//    /*
//     *生成订单信息及签名
//     */
//    将商品信息赋予AlixPayOrder的成员变量
//    Order* order = [Order new];
//    
//     NOTE: app_id设置
//    order.app_id = appID;
//    
//     NOTE: 支付接口名称
//    order.method = @"alipay.trade.app.pay";
//    
//     NOTE: 参数编码格式
//    order.charset = @"utf-8";
//    
//     NOTE: 当前时间点
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    order.timestamp = [formatter stringFromDate:[NSDate date]];
//    
//     NOTE: 支付版本
//    order.version = @"1.0";
//    
//     NOTE: sign_type 根据商户设置的私钥来决定
//    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
//    
//     NOTE: 商品数据
//    order.biz_content = [BizContent new];
//    order.biz_content.body = @"我是测试数据";
//    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = [self generateTradeNO]; 订单ID（由商家自行制定）
//    order.biz_content.timeout_express = @"30m"; 超时时间设置
//    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; 商品价格
//    
//    将商品信息拼接成字符串
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
//    
//     NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//           需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    NSString *signedString = nil;
//        RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
//    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:rsa2PrivateKey];
//    
//    if ((rsa2PrivateKey.length > 1)) {
//        signedString = [signer signString:orderInfo withRSA2:YES];
//    } else {
//        signedString = [signer signString:orderInfo withRSA2:NO];
//    }
//    
//    
//    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = @"TimeHomeApp";
//
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
    
//        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            
//            if (self.appAlipayCallBack) {
//                self.appAlipayCallBack(resultDic);
//            }
//            
//        }];
//    }
}
- (NSString *)generateTradeNO {
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


+(void)getOrderNo:(NSDictionary *)param callBack:(UpDateViewsBlock)updataViewBlock {
    
    NSString * url=[NSString stringWithFormat:@"http://api.uspay.usnoon.com/wechat/unifiedorder"];
    
    CommandModel *command=[[CommandModel alloc]init];
    command.commandUrl=url;
    command.paramDict=[[NSMutableDictionary alloc]initWithDictionary:param];
    DataController * dataController=[DataController sharedDataController];
    
    [dataController executeCommand:command className:@"NetGetDataCommand" CompleteBlock:^(id data,ResultCode resultCode,NSError *Error) {
        
        if(resultCode==NONetWorkCode)//无网络处理
        {
            updataViewBlock(@"您的网络太慢或无网络,请检查网络设置!",resultCode);
        }else if(resultCode==SucceedCode)//成功返回数据
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            updataViewBlock(dicJson,resultCode);
            
        }else if(resultCode==FailureCode)//返回数据失败
        {
            NSDictionary * dicJson=[DataController dictionaryWithJsonData:data];
            updataViewBlock(dicJson,resultCode);

        }
        
    }];

}
@end
