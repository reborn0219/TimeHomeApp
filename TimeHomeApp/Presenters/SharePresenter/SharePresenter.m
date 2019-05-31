//
//  SharePresenter.m
//  YouLifeApp
//
//  Created by us on 15/9/8.
//  Copyright © 2015年 us. All rights reserved.
//

#import "SharePresenter.h"
#import "AppSystemSetPresenters.h"
#import "BaseViewController.h"
#import "AppPayPresenter.h"

#import "L_NewPointPresenters.h"

#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

#import "BBSMainPresenters.h"

#import "ZG_shareBBSViewController.h"

#import "L_ShareToBBSViewController.h"

@implementation ShareContentModel

@end

@implementation SharePresenter

#pragma mark - 单例初始化
+(instancetype)getInstance
{
    static SharePresenter * sharepresenter = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharepresenter = [[self alloc] init];
        
    });
    return sharepresenter;
}

///第三方登录
+(void)thirdPartLogin:(ShareContentModel *)SCML withType: (thirdPartType)type
{

    switch (type) {
        case QQtype:
        {
            
            [ShareSDK getUserInfo:SSDKPlatformTypeQQ
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
             {
                 
                 
                 if (state == SSDKResponseStateSuccess)
                 {
                     
                     NSLog(@"uid=%@",user.uid);
                     NSLog(@"%@",user.credential);
                     NSLog(@"token=%@",user.credential.token);
                     NSLog(@"nickname=%@",user.nickname);
                 }
                 
                 else
                 {
                     NSLog(@"%@",error);
                 }
                 
             }];

            
        }
            break;
            
        default:
            break;
    }

}


+(void)creatShareSDKPic:(ShareContentModel *)SCML {
    
}

//shareSDK
+(void)creatShareSDKcontent:(ShareContentModel *)SCML
{
    //创建自定义分享列表
    NSArray *shareList = SCML.shareList;
    
    if([XYString isBlankString:SCML.shareTitle]) {
        SCML.shareTitle = @"平安社区";
    }
    
    if([XYString isBlankString:SCML.shareContext]) {
        SCML.shareContext = @"我已入驻未来星球，你想来吗？";
    }
    
    if (SCML.shareList==nil) {
        shareList= @[
                     @(SSDKPlatformTypeQQ),
                     @(SSDKPlatformSubTypeWechatSession),
                     @(SSDKPlatformSubTypeWechatTimeline),
                     @(SSDKPlatformSubTypeQQFriend),
                     @(SSDKPlatformSubTypeQZone)];

    }
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                     images:SCML.shareImg
                                        url:[NSURL URLWithString:SCML.shareUrl]
                                      title:SCML.shareTitle
                                       type:SCML.shareType];
    
    
    //添加一个自定义的平台
    
    NSMutableArray * platforms = [shareList mutableCopy];
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(infoDictionary));
//    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    [shareParams SSDKSetupWeChatParamsByText:SCML.shareTitle title:appCurName url:[NSURL URLWithString:SCML.shareUrl] thumbImage:nil image:SCML.shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    
    [ShareSDK showShareActionSheet:SCML.shareSuperView items:platforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        switch (state) {
                
            case SSDKResponseStateBegin:
            {
                if (SCML.type == 4 || SCML.type == 5) {
                    //18分享帖子 19分享活动
                    NSInteger shareTypeNum = 18;
                    NSString *contentStr = @"分享贴子";
                    //SCML.type 4 帖子 5 活动
                    if (SCML.type == 4) {
                        shareTypeNum = 18;
                        contentStr = @"分享贴子";
                    }
                    if (SCML.type == 5) {
                        shareTypeNum = 19;
                        contentStr = @"分享活动";
                    }
                    
                    [L_NewPointPresenters updUserIntebyTypeWithType:shareTypeNum content:contentStr costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                    }];
                    
                }
                
            }
                break ;
                
            case SSDKResponseStateSuccess:
            {
                
                NSString *totype = @"";
                switch (platformType) {
                    case SSDKPlatformSubTypeWechatSession:
                    {
                        totype = @"1";
                    }
                        break;
                    case SSDKPlatformSubTypeWechatTimeline:
                    {
                        totype = @"2";
                    }
                        break;
                    case SSDKPlatformSubTypeQQFriend:
                    {
                        totype = @"3";
                    }
                        break;
                    case SSDKPlatformSubTypeQZone:
                    {
                        totype = @"4";
                    }
                        break;
                    default:
                        break;
                }
                
                /**
                 *  分享统计请求
                 */
                [AppSystemSetPresenters sharedDoforwardType:[NSString stringWithFormat:@"%ld",(long)SCML.type] totype:totype gotourl:SCML.shareUrl sourceid:[XYString IsNotNull:SCML.sourceid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultCode == SucceedCode) {
                            NSLog(@"分享统计请求成功");
                            NSDictionary *dic=(NSDictionary *)data;
                            NSInteger integral=[[dic objectForKey:@"dicJson"] integerValue];
                            if(integral>0)
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"首次分享成功,增加%ld积分",(long)integral] Duration:5.0];
                            }else
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"分享成功"] Duration:0.5];
                                
                            }
                            
                        }else {
                            NSLog(@"分享统计请求失败");
                        }
                    });
                }];
                
            }
                break;

            case SSDKResponseStateFail:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
                break;

            case SSDKResponseStateCancel:
            {

            }
                break;

            default:
                break;
        }
        
    }];
    
}

///shareSDK
- (void)creatShareSDKcontent:(ShareContentModel *) SCML withCallBack:(AcitivityCallBack)acitivityCallBack {
    
    //创建自定义分享列表
    NSArray *shareList = SCML.shareList;
    
    if([XYString isBlankString:SCML.shareTitle]) {
        SCML.shareTitle = @"平安社区";
    }
    
    if([XYString isBlankString:SCML.shareContext]) {
        SCML.shareContext = @"我已入驻未来星球，你想来吗？";
    }
    
    if (SCML.shareList==nil) {
        shareList= @[
                     @(SSDKPlatformTypeQQ),
                     @(SSDKPlatformSubTypeWechatSession),
                     @(SSDKPlatformSubTypeWechatTimeline),
                     @(SSDKPlatformSubTypeQQFriend),
                     @(SSDKPlatformSubTypeQZone)];
    }
    
    
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                     images:SCML.shareImg
                                        url:[NSURL URLWithString:SCML.shareUrl]
                                      title:SCML.shareTitle
                                       type:SCML.shareType];
    

    
    //添加一个自定义的平台
    
    NSMutableArray *platforms = [shareList mutableCopy];
    
    APPWXPAYMANAGER.callBack = ^(enum WXErrCode errCode){
        NSLog(@"%d",errCode);
        
        if (errCode == WXSuccess) {
            
            if (acitivityCallBack) {
                acitivityCallBack(1,1);
            }
            
        }else {
            
            if (acitivityCallBack) {
                acitivityCallBack(0,0);
            }
            
        }

    };
    
    [ShareSDK showShareActionSheet:SCML.shareSuperView items:platforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        switch (state) {
                
            case SSDKResponseStateBegin:
            {
                NSString *totype = @"";
                switch (platformType) {
                    case SSDKPlatformSubTypeWechatSession:
                    {
                        totype = @"1";
                    }
                        break;
                    case SSDKPlatformSubTypeWechatTimeline:
                    {
                        totype = @"2";
                    }
                        break;
                    case SSDKPlatformSubTypeQQFriend:
                    {
                        totype = @"3";
                    }
                        break;
                    case SSDKPlatformSubTypeQZone:
                    {
                        totype = @"4";
                    }
                        break;
                    default:
                        break;
                }
                if (acitivityCallBack) {
                    acitivityCallBack(1,totype.integerValue);
                }
                
                if (SCML.type == 4 || SCML.type == 5) {
                    //18分享帖子 19分享活动
                    NSInteger shareTypeNum = 18;
                    NSString *contentStr = @"分享贴子";
                    //SCML.type 4 帖子 5 活动
                    if (SCML.type == 4) {
                        shareTypeNum = 18;
                        contentStr = @"分享贴子";
                    }
                    if (SCML.type == 5) {
                        shareTypeNum = 19;
                        contentStr = @"分享活动";
                    }
                    
                    [L_NewPointPresenters updUserIntebyTypeWithType:shareTypeNum content:contentStr costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                    }];
                    
                }

            }
                break ;
                
            case SSDKResponseStateSuccess:
            {
                NSString *totype = @"";
                switch (platformType) {
                    case SSDKPlatformSubTypeWechatSession:
                    {
                        totype = @"1";
                    }
                        break;
                    case SSDKPlatformSubTypeWechatTimeline:
                    {
                        totype = @"2";
                    }
                        break;
                    case SSDKPlatformSubTypeQQFriend:
                    {
                        totype = @"3";
                    }
                        break;
                    case SSDKPlatformSubTypeQZone:
                    {
                        totype = @"4";
                    }
                        break;
                    default:
                        break;
                }

                /**
                 *  分享统计请求
                 */
                [AppSystemSetPresenters sharedDoforwardType:[NSString stringWithFormat:@"%ld",(long)SCML.type] totype:totype gotourl:SCML.shareUrl sourceid:[XYString IsNotNull:SCML.sourceid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultCode == SucceedCode) {
                            NSLog(@"分享统计请求成功");
                            NSDictionary *dic=(NSDictionary *)data;
                            NSInteger integral=[[dic objectForKey:@"dicJson"] integerValue];
                            if(integral>0)
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"首次分享成功,增加%ld积分",(long)integral] Duration:5.0];
                            }else
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"分享成功"] Duration:0.5];

                            }
                            
                        }else {
                            NSLog(@"分享统计请求失败");
                        }
                    });
                }];
                
            }
                break;
                
            case SSDKResponseStateFail:
            {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
                break;
                
            case SSDKResponseStateCancel:
            {

            }
                break;
                
            default:
                break;
        }
        
    }];
    
}


////分享图片
+(void)creatShareSDKPiccontent:(ShareContentModel *)SCML
{
    //创建自定义分享列表
    NSArray *shareList = SCML.shareList;
    
    if([XYString isBlankString:SCML.shareTitle]) {
        SCML.shareTitle = @"平安社区";
    }
    
    if([XYString isBlankString:SCML.shareContext]) {
        SCML.shareContext = @"我已入驻未来星球，你想来吗？";
    }
    
    if (SCML.shareList==nil) {
        shareList= @[
                     
                     @(SSDKPlatformSubTypeWechatSession),
                     @(SSDKPlatformSubTypeWechatTimeline),
                     @(SSDKPlatformSubTypeQQFriend)];
        
    }
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                     images:SCML.shareImg
                                        url:[NSURL URLWithString:SCML.shareUrl]
                                      title:SCML.shareTitle
                                       type:SCML.shareType];
    
    
    //添加一个自定义的平台
    
    NSMutableArray * platforms = [shareList mutableCopy];
    
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    //    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    //    [shareParams SSDKSetupWeChatParamsByText:SCML.shareTitle title:appCurName url:[NSURL URLWithString:SCML.shareUrl] thumbImage:nil image:SCML.shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    
    [ShareSDK showShareActionSheet:SCML.shareSuperView items:platforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        switch (state) {
                
            case SSDKResponseStateBegin:
            {
                if (SCML.type == 4 || SCML.type == 5) {
                    //18分享帖子 19分享活动
                    NSInteger shareTypeNum = 18;
                    NSString *contentStr = @"分享贴子";
                    //SCML.type 4 帖子 5 活动
                    if (SCML.type == 4) {
                        shareTypeNum = 18;
                        contentStr = @"分享贴子";
                    }
                    if (SCML.type == 5) {
                        shareTypeNum = 19;
                        contentStr = @"分享活动";
                    }
                    
                    [L_NewPointPresenters updUserIntebyTypeWithType:shareTypeNum content:contentStr costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                    }];
                    
                }
                
            }
                break ;
                
            case SSDKResponseStateSuccess:
            {
                
                NSString *totype = @"";
                switch (platformType) {
                    case SSDKPlatformSubTypeWechatSession:
                    {
                        totype = @"1";
                    }
                        break;
                    case SSDKPlatformSubTypeWechatTimeline:
                    {
                        totype = @"2";
                    }
                        break;
                    case SSDKPlatformSubTypeQQFriend:
                    {
                        totype = @"3";
                    }
                        break;
                    case SSDKPlatformSubTypeQZone:
                    {
                        totype = @"4";
                    }
                        break;
                    default:
                        break;
                }
                
                /**
                 *  分享统计请求
                 */
                [AppSystemSetPresenters sharedDoforwardType:[NSString stringWithFormat:@"%ld",(long)SCML.type] totype:totype gotourl:SCML.shareUrl sourceid:[XYString IsNotNull:SCML.sourceid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultCode == SucceedCode) {
                            NSLog(@"分享统计请求成功");
                            NSDictionary *dic=(NSDictionary *)data;
                            NSInteger integral=[[dic objectForKey:@"dicJson"] integerValue];
                            if(integral>0)
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"首次分享成功,增加%ld积分",(long)integral] Duration:5.0];
                            }else
                            {
                                [AppDelegate showToastMsg:[NSString stringWithFormat:@"分享成功"] Duration:0.5];
                                
                            }
                            
                        }else {
                            NSLog(@"分享统计请求失败");
                        }
                    });
                }];
                
            }
                break;
                
            case SSDKResponseStateFail:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
                break;
                
            case SSDKResponseStateCancel:
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

@end
