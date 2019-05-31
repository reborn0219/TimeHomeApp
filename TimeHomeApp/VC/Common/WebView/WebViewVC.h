//
//  WebViewVC.h
//  TimeHomeApp
//
//  Created by us on 16/1/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 用于加载网页显示
 **/


#import "BaseViewController.h"
#import "TopicPostModel.h"

#import "UserActivity.h"

#import "AppPayPresenter.h"

#import "SharePresenter.h"

#import <JavaScriptCore/JavaScriptCore.h>

/**
 *  点赞评论回调
 *  praise点赞数
 *  comment评论数
 *  PostID帖子id
 *  type 0已点赞 1 未点赞
 */
typedef void (^PraiseAndCommentCallBack)(NSString *praise,NSString *comment,NSString *PostID,NSString *type);

typedef void(^DeleteRefreshBlock)(void);

typedef void(^ShopCallBack)(void);//商城返回回调

@interface WebViewVC : THBaseViewController<UIWebViewDelegate>

//通过storyboard加载webViewController
- (instancetype)initFromStoryboard;

@property(nonatomic,strong) JSContext *context;

@property (nonatomic, copy) ShopCallBack shopCallBack;

/**
 从评论推送过来
 */
@property (nonatomic, assign) BOOL isFromCommentPush;

/**
 *  点赞评论回调block
 */
@property (nonatomic, copy) PraiseAndCommentCallBack praiseAndCommentCallBack;

/**
 删除帖子回调
 */
@property (nonatomic, copy) DeleteRefreshBlock deleteRefreshBlock;

@property (nonatomic, copy)   NSArray        *sharePostArr;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, assign) NSInteger       currentIndex;
@property (nonatomic, assign) NSInteger       type;//3公告详情 4社区警务 5活动 9新闻分享
@property (nonatomic, assign) NSInteger       isnoHaveQQ; // 0 带QQ分享  1不分享QQ
@property (nonatomic, copy)   NSString       *topicid;
@property (nonatomic, strong) TopicPostModel *TPML;
@property (nonatomic, copy)   NSString       *postsid;
@property (weak, nonatomic)   IBOutlet UIWebView *webView;
@property(nonatomic,strong)   NSString       *url;
@property(nonatomic,strong)   NSString       *htmltext;
@property(nonatomic,assign)   BOOL           isHtml;
@property (nonatomic, assign) BOOL isHiddenBar;
@property(nonatomic,strong)   NSURL       *weburl;

/**
 是否带有下拉刷新
 */
@property(nonatomic,assign)BOOL isNoRefresh;
/**
 是否显示导航条右连按钮
 */
@property(nonatomic,assign) BOOL isShowRightBtn;
//分享类型
/**
 *  0 app下载 1 社区公告 2 社区新闻 3 访客通行 4 帖子 5 活动 6 关于我们 9活动分享到邻趣
 */
@property(nonatomic,assign) int shareTypes;
@property(nonatomic,copy)NSString * shareUr;
/**
 *  公告分享标题
 */
@property (nonatomic, strong) NSString *noticeTitle;
/**
 *  公告分享内容
 */
@property (nonatomic, strong) NSString *noticeContent;

//============================== ********** 公共传入model，参考之前的活动，公告，ZAKER等传入方式 ********** =============================================
/**
 公共传入model，参考之前的活动，公告，ZAKER等传入方式
 */
@property (nonatomic, strong) UserActivity *userActivityModel;
//============================== ********** 公共传入model，参考之前的活动，公告，ZAKER等传入方式 ********** =============================================

/**
 *  新闻分享内容
 */
//@property (nonatomic, strong) ShareContentModel * SCML;
/**
 是否获取当前网页的title为导航的标题
 */
@property (nonatomic, assign) BOOL isGetCurrentTitle;
@property (nonatomic, copy)NSString * talkingName;
/** 是否是小区导航栏 */
@property (nonatomic, assign) BOOL isCommunityNavOrNot;
/** 一下为2.2新增，传值均为json解析 */
///打开相册上传图片
-(void)upLoadImg:(id)param;
/** h5分享 */
- (void)shareFromh5:(id)param;
/** 私信 */
- (void)sixin:(id)param;
/** 点击放大图片 */
- (void)showimage:(id)param;
/**
 点赞列表
 */
- (void)dianzanlist:(id)param;
/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ;
/** token失效判断,重新登录 */
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
//----------------------------
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
 支付宝支付
 */
- (void)jumpToAliPay:(id)param;

/**
 跳转商城
 */
- (void)gotoShopWebView;

/**
 隐藏导航栏
 */
- (void)hideNavigationBarHTML:(id)param;


@end
