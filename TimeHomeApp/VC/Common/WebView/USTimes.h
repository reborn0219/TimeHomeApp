//
//  USTimes.h
//  TimeHomeApp
//
//  Created by us on 16/4/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WebViewVC.h"

@protocol  JSPortocol <JSExport>

-(void)delpost:(id)param;
-(void)pubpost:(id)param;
-(void)addinte:(id)param;
-(void)showpersonal:(id)param;
-(void)share:(id)param;
-(void)showimg:(id)param;
-(void)checkfollow:(id)param;
-(void)getversion:(id)param;
-(void)setTitle:(id)param;
-(void)share_posts:(id)param;

-(void)passValue:(id)param;

-(float)getKeyBoardHeight;

/** 一下为2.2新增，传值均为json解析 */

/**
 上传图片
 */
-(void)upLoadImg:(id)param;
/**
 分享
 */
- (void)shareFromh5:(id)param;

/**
 私信
 */
- (void)sixin:(id)param;

/**
 点击放大图片
 */
- (void)showimage:(id)param;

/**
 点赞列表
 */
- (void)dianzanlist:(id)param;
/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ;

///token失效判断
-(void)relogin;

/**
 收藏回调
 */
- (void)refreshCollect;

/**
 关注回调
 */
- (void)refreshAttention;

/**
 编辑发布成功回调
 */
- (void)refreshEdit;

/**
 帖子详情举报分享发布
 */
- (void)reportAction:(id)param;

/**
 跳转到微信支付
 */
- (void)jumpToWXPay:(id)param;

/**
 展示h5弹窗提示
 */
- (void)showH5MsgInfo:(id)param;
///粉丝关注
-(void)fensi:(id)param;
-(void)guanzhu:(id)param;

/**
 点赞
 */
- (void)praiseClick:(id)param;
/**
 评论
 */
- (void)commentClick:(id)param;
/**
 更新分享
 */
- (void)updateShareMessage:(id)param;
//-------------------------------------
/**
 复制到剪切板
 */
- (void)pasteMsg:(id)param;

/**
 H5返回App
 */
-(void)popView;

/**
 隐藏或显示右上角分享按钮
 */
- (void)hiddenOrShowRightBarButton:(id)param;

/**
 隐藏导航栏
 */
- (void)hideNavigationBarHTML:(id)param;

/**
 支付宝支付
 */
- (void)jumpToAliPay:(id)param;
/**
 跳转商城
 */
- (void)gotoShopWebView;

/**
 打电话
 */
-(void)callphone;

@end

@interface USTimes : NSObject<JSPortocol>

@property(nonatomic,retain)WebViewVC *webVC;

-(void)share_posts:(id)param;
-(void)setTitle:(id)param;
-(void)getversion:(id)param;
-(void)delpost:(id)param;
-(void)pubpost:(id)param;
-(void)addinte:(id)param;
-(void)showpersonal:(id)param;
-(void)share:(id)param;
-(void)showimg:(id)param;
-(void)checkfollow:(id)param;
-(float)getKeyBoardHeight;
///token失效判断
-(void)relogin;

/** 一下为2.2新增，传值均为json解析 */
/**
 上传图片
 */
-(void)upLoadImg:(id)param;
/**
 分享
 */
- (void)shareFromh5:(id)param;
/**
 私信
 */
- (void)sixin:(id)param;
/**
 点击放大图片
 */
- (void)showimage:(id)param;
/**
 点赞列表
 */
- (void)dianzanlist:(id)param;
/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ;

/**
 收藏回调
 */
- (void)refreshCollect;

/**
 关注回调
 */
- (void)refreshAttention;

/**
 编辑发布成功回调
 */
- (void)refreshEdit;

/**
 帖子详情举报分享发布
 */
- (void)reportAction:(id)param;
/**
 跳转到微信支付
 */
- (void)jumpToWXPay:(id)param;
/**
 展示h5弹窗提示
 */
- (void)showH5MsgInfo:(id)param;

///粉丝关注
-(void)fensi:(id)param;
-(void)guanzhu:(id)param;

/**
 点赞
 */
- (void)praiseClick:(id)param;
/**
 评论
 */
- (void)commentClick:(id)param;

/**
 更新分享
 */
- (void)updateShareMessage:(id)param;
//-------------------------------------
/**
 复制到剪切板
 */
- (void)pasteMsg:(id)param;
/**
 H5返回App
 */
-(void)popView;

/**
 隐藏或显示右上角分享按钮
 */
- (void)hiddenOrShowRightBarButton:(id)param;

/**
 隐藏导航栏
 */
- (void)hideNavigationBarHTML:(id)param;

/**
 支付宝支付
 */
- (void)jumpToAliPay:(id)param;
/**
 跳转商城
 */
- (void)gotoShopWebView;

/**
 打电话
 */
-(void)callphone;

@end
