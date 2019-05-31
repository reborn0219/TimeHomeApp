//
//  WebViewVC.m
//  TimeHomeApp
//
//  Created by us on 16/1/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "WebViewVC.h"
#import "USTimes.h"
#import "SharePresenter.h"
#import "THIndicatorVC.h"
#import "PostPresenter.h"
#import "RecommendTopicModel.h"
#import <WebKit/WebKit.h>
#import "TZImagePickerController.h"
#import "TOCropViewController.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"
#import "ImageUitls.h"
#import "AppSystemSetPresenters.h"
#import "TZImagePickerController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "PraiseListVC.h"
#import "ActionSheetVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "ChatViewController.h"
#import "LogInPresenter.h"
#import "MessageAlert.h"
#import "MsgAlertView.h"
#import "THMyInfoPresenter.h"
#import "MainTabBars.h"
#import "BBSModel.h"
#import "L_NewMinePresenters.h"
#import "AppDelegate+JPush.h"

#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"

#import "ZG_shareBBSViewController.h"
#import "L_ShareToBBSViewController.h"

@interface WebViewVC ()<UIWebViewDelegate, SDPhotoBrowserDelegate,WKNavigationDelegate,TZImagePickerControllerDelegate, TOCropViewControllerDelegate ,NJKWebViewProgressDelegate>
{
    
    USTimes *ustimes;///JS 交互对象
    NSString *maxPhotos;/** 最大选择图片数 */
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString * passback;
    BOOL isHiddenRightBarButton;
    BOOL isHiddenNavigationBar;
    NSString *_selectImageWidth;/** h5选中图片的宽 */
    NSString *_selectImageHeight;/** h5选中图片的高 */
}

/**
 选择图片所在的数组
 */
@property (nonatomic, strong) NSMutableArray *selectedPhotosArray;


/**
 相册选择器
 */
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;

@property (nonatomic, strong) NSDictionary *reportDictionary;

@property (nonatomic, strong) NSString *praisecount;

@property (nonatomic, strong) NSString *commentcount;

@property (nonatomic, strong) NSString *theID;

@end

@implementation WebViewVC

//通过storyboard加载webViewController
- (instancetype)initFromStoryboard{
    if (self = [super init]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        self = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    }
    return self;
}

/**
 删除帖子
 
 @param model
 */
- (void)httpRequestForDeleteWithPostid:(NSString *)postid {
    
    if ([XYString isBlankString:postid]) {
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_NewMinePresenters deletePostWithPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                if (self.deleteRefreshBlock) {
                    self.deleteRefreshBlock();
                }
                
                [self showToastMsg:@"贴子删除成功!" Duration:3.0];
                
                if([self.webView canGoBack]) {
                    [self.webView goBack];
                }else {
                    [super backButtonClick];
                }
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
        });
        
    }];
    
}



- (void)setImageList:(NSArray *)imageList {
    
    if (!_imageList) {
        _imageList = [[NSMutableArray alloc] init];
    }
    [_imageList removeAllObjects];
    [_imageList addObjectsFromArray:imageList];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
        browser.sourceImagesContainerView = self.webView;
        browser.imageCount = imageList.count;
        browser.currentImageIndex = _currentIndex;
        browser.delegate = self;
        [browser show]; // 展示图片浏览器
    });
    
}
- (NSMutableArray *)selectedPhotosArray {
    if (!_selectedPhotosArray) {
        _selectedPhotosArray = [[NSMutableArray alloc] init];
    }
    return _selectedPhotosArray;
}

/**
 设置小区导航
 */

- (void)setupCommunityNavWithTitle:(NSString *)title {
    
    self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 0, 0, SCREEN_WIDTH - 50 , 40);
    [button setImage:[UIImage imageNamed:@"邻趣-首页-顶部定位图标"] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = DEFAULT_BOLDFONT(18);
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button.imageEdgeInsets = UIEdgeInsetsMake( 0, 10,  0, 40);
    //button标题的偏移量，这个偏移量是相对于图片的
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.titleView = button;
    
}

/**
 设置详情页导航title
 */
- (void)setupDetailsNavWithTitle:(NSString *)title {
    
    if (_type == 3) {
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
    }
    
    if (_type == 5) {
        
        if (isHiddenRightBarButton) {
            
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
            
        }else {
            //活动
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
            self.navigationItem.rightBarButtonItem = right;
        }
        
    }
    
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = title;
    navTitleLabel.textColor = TITLE_TEXT_COLOR;
    navTitleLabel.font = DEFAULT_BOLDFONT(18);
    self.navigationItem.titleView = navTitleLabel;
    
}
// MARK: - 右上角按钮为空占位时使用
- (UIBarButtonItem *)normalRightBarButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    return backButton;
}

#pragma  mark - LifeCircle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    if (SCREEN_HEIGHT == 812) {
    //
    //        [self.webView setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64-24)];
    //
    //    }else
    //    {
    //        [self.webView setFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //
    //    }
    
    //    if (@available(iOS 11.0, *)) {
    //
    //        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //
    //    }
    
    isHiddenRightBarButton = NO;
    isHiddenNavigationBar = NO;
    //    /** 设置详情页导航栏标题 */
    //    [self setupDetailsNavWithTitle:self.title];
    
    [self insertRowToTop];
    passback = @"";
    maxPhotos = @"1";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ustimes=[[USTimes alloc]init];
        ustimes.webVC = self;
        self.webView.dataDetectorTypes = UIDataDetectorTypeNone;//禁止自动检测网页上的电话号码，单机可以拨打
        
        self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        if (self.url==nil) {
            self.url=@"";
        }
        
        self.webView.allowsInlineMediaPlayback = YES;
        
        //        self.url = @"https://view.inews.qq.com/w/WXN201710260336600G1?refer=nwx&bat_id=1118001599&cur_pos=0&grp_index=0&grp_id=1318001602&rate=0&_rp=2&pushid=2017102818&bkt=0&openid=o04IBAERXbFEKgP1MBf_xlaaBeoc&tbkt=A&groupid=1509169511&msgid=0&from=message&isappinstalled=0";
        
        //        self.url = @"http://test.usnoon.com/Actives/achtml/20171028/index2.html";
        
        if(![self.url hasPrefix:@"http://"] && ![self.url hasPrefix:@"https://"])
        {
            self.url=[NSString stringWithFormat: @"http://%@",self.url];
        }
        
        NSURL *httpUrl=[NSURL URLWithString:self.url];
        if (_weburl) {
            httpUrl=_weburl;
        }
        NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
        [self.webView loadRequest:httpRequest];
        
        if (!_isNoRefresh) {
            
            @WeakObj(self);
            
            self.webView.scrollView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
                [selfWeak insertRowToTop];
            }];
            
        }
        
    });
    
    /** 加载进度条 */
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    if (_isHiddenBar) {
        
        CGFloat progressBarHeight = 2.f;
        
        if (IOS_VERSION >= 11.0) {
            CGRect barFrame = CGRectMake(0, -44, SCREEN_WIDTH, progressBarHeight);
            _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        }else {
            CGRect barFrame = CGRectMake(0, 20, SCREEN_WIDTH, progressBarHeight);
            _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        }
        //        if (@available(iOS 11.0, *)) {
        //            CGRect barFrame = CGRectMake(0, -44, SCREEN_WIDTH, progressBarHeight);
        //            _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        //        }else {
        
        //        }
        
    }else {
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        
    }
    
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0];
    
    /** 小区导航栏标题 */
    if (self.isCommunityNavOrNot) {
        [self setupCommunityNavWithTitle:self.title];
    }
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    /** 设置详情页导航栏标题 */
    [self setupDetailsNavWithTitle:self.title];
    
    [self.navigationController setNavigationBarHidden:_isHiddenBar animated:YES];
    
    if(![XYString isBlankString:_talkingName])
    {
        AppDelegate *appdele = GetAppDelegates;
        [appdele markStatistics:_talkingName];
        //        [TalkingData trackVCBegin:_talkingName];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_awakeFormActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAwakeFormActive:) name:@"Notification_awakeFormActive" object:nil];
    
    if (_isHiddenBar) {
        [self.view addSubview:_progressView];
        [self.view bringSubviewToFront:_progressView];
    }else {
        [self.navigationController.navigationBar addSubview:_progressView];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isPush"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationItem.titleView = nil;
    
    JSValue *add = self.context[@"webViewWillDisappear"];
    NSLog(@"Func==webViewWillDisappear: %@", add);
    NSDictionary *callBackDict = @{@"version":kCurrentVersion};
    [add callWithArguments:@[[callBackDict mj_JSONString]]];
    
    if(![XYString isBlankString:_talkingName])
    {
        //        [TalkingData trackVCEnd:_talkingName];
        AppDelegate *appdele = GetAppDelegates;
        [appdele addStatistics:@{@"viewkey":_talkingName}];
        
    }
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
    NSLog(@"---self.url == %@---",self.url);
    ///20180213/communityPoliceWork
    
    NSString * str = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    
    if (![str containsString:@"writeMessage.html"]) {
        
        [self insertRowToTop];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_awakeFormActive" object:nil];
}

//--------------处理通知消息-----------------
-(void)receiveAwakeFormActive:(NSNotification*) aNotification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @WeakObj(self);
        JSValue *add = selfWeak.context[@"backtoapp"];
        NSLog(@"Func==add: %@", add);
        [add callWithArguments:@[[@{@"errmsg":@"awake",@"errcode":[NSString stringWithFormat:@"99"]} mj_JSONString]]];
        
    });
    
}

#pragma  mark - 刷新WebView

-(void)insertRowToTop
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [self.webView reload];
    
}
#pragma mark - 清楚WebView缓存
//-(void)clearcache
//{
//    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    //清除UIWebView的缓存
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
//}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *currenturl = request.URL.absoluteString;
    NSLog(@"currenturl===%@",currenturl);
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSLog(@"cookies====%@",[storage cookies]);
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.navigationController setNavigationBarHidden:_isHiddenBar animated:YES];
    
    /**
     *  禁止长按系统弹出框
     */
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    ///edit by ls 2017.7.25  不设置标题的时候显示网页自带标题
    if ([XYString isBlankString:self.title]) {
        self.title= [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [self setupDetailsNavWithTitle:self.title];
    ///edit by ls 2017.7.25
    
    
    
    NSLog(@"-----%ld",(long)_type);
    //    [self.webView.scrollView.pullToRefreshView stopAnimating];
    if (self.webView.scrollView.mj_header.isRefreshing) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
    
    if (_type == 4) {
        if ([_webView.request.URL.absoluteString isEqualToString:_url]) {
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
        }else {
            //            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
            //            self.navigationItem.rightBarButtonItem = right;
        }
        
    }else if (_type==3) {
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
    }else if (_type == 5) {
        
        if (isHiddenRightBarButton) {
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
        }else {
            //活动
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
            self.navigationItem.rightBarButtonItem = right;
        }
        
    }else if(_type == 9){
        
        self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
        
        //        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
        //        self.navigationItem.rightBarButtonItem = right;
        
        
    }else if (_type == 10) {
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
    }
    
    if(webView.isLoading) {
        return;
    }
    
    if (_isGetCurrentTitle) {
        //获取网页title
        NSString *htmlTitle = @"document.title";
        NSString *currentTitle = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];//获取当前页面的title
        if (![XYString isBlankString:currentTitle]) {
            self.title = currentTitle;
            /** 设置详情页导航栏标题 */
            [self setupDetailsNavWithTitle:self.title];
        }
    }
    
    _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _context[@"ustimes"] = ustimes;
    
    _context[@"test1"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    
    /** 异常处理 */
    _context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"webView异常=====%@", exception);
        con.exception = exception;
    };
    
    JSValue *add = self.context[@"webviewLoadComplete"];
    NSLog(@"Func==add: %@", add);
    NSDictionary *callBackDict = @{@"version":kCurrentVersion};
    [add callWithArguments:@[[callBackDict mj_JSONString]]];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.webView.scrollView.mj_header.isRefreshing) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}
#pragma mark - BackButtonAction
-(void)backButtonClick {
    
    if([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if (_isFromCommentPush) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            [super backButtonClick];
        }
    }
}

#pragma mark - rightAction

- (void)rightAction:(UIBarButtonItem *)sender {
    
    ///分享
    //分享应用
    //http://timesres.usnoon.com/logo/applogo.png
    
    ShareContentModel * SCML = [[ShareContentModel alloc]init];
    SCML.shareImg = SHARE_LOGO_IMAGE;
    SCML.shareUrl = self.shareUr;
    SCML.shareContext = @" ";
    SCML.shareSuperView = self.view;
    SCML.type = self.shareTypes;
    SCML.shareType = SSDKContentTypeAuto;
    
    if (_type == 3) {
        
        //公告
        SCML.shareUrl = _userActivityModel.gotourl;
        SCML.shareTitle = _userActivityModel.title;
        SCML.shareContext = _userActivityModel.content;
        SCML.shareImg = _userActivityModel.picurl;
        SCML.type = 1;
        
        [[SharePresenter getInstance] creatShareSDKcontent:SCML withCallBack:^(NSInteger isShareSuccess, NSInteger platformType) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JSValue *add = self.context[@"shareCallBack"];
                NSLog(@"Func==add: %@", add);
                
                NSDictionary *shareDict = @{
                                            @"isSuccess":[NSString stringWithFormat:@"%ld",(long)isShareSuccess],
                                            @"platformType":[NSString stringWithFormat:@"%ld",(long)platformType]
                                            };
                [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                
            });
            
        }];
        
        //        SCML.shareTitle = _noticeTitle;
        //        SCML.shareContext = _noticeContent;
        //        [SharePresenter creatShareSDKcontent:SCML];
        
    }else if (_type == 4) {
        
        //社区警务
        SCML.shareTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        SCML.shareUrl = _webView.request.URL.absoluteString;
        [SharePresenter creatShareSDKcontent:SCML];
        
        
    }else if (_type == 5) {
        
        NSString *title = [XYString IsNotNull:_userActivityModel.title];
        NSString *content = [XYString IsNotNull:_userActivityModel.content];
        
        if ([XYString isBlankString:_userActivityModel.gotourl]) {
            [self showToastMsg:@"分享的链接未获取到" Duration:3.0];
            return;
        }
        
        //社区活动
        SCML.shareTitle = title;
        SCML.shareUrl = _userActivityModel.gotourl;
        SCML.shareImg = [XYString isBlankString:_userActivityModel.picurl] ? SHARE_LOGO_IMAGE : _userActivityModel.picurl;
        SCML.shareContext = content;
        
        if([XYString isBlankString:SCML.shareTitle]) {
            SCML.shareTitle = @"皇冠社区";
        }
        
        if([XYString isBlankString:SCML.shareContext]) {
            SCML.shareContext = @"我已入驻未来星球，你想来吗？";
        }
        
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                         images:SCML.shareImg
                                            url:[NSURL URLWithString:SCML.shareUrl]
                                          title:SCML.shareTitle
                                           type:SCML.shareType];
        
        if (self.shareTypes == 9) {
            
            ZG_shareBBSViewController *share = [ZG_shareBBSViewController shareZG_shareBBSVC];
            [share showInVC:self with:@""];
            
            share.buttonDidClickBlock= ^(NSString *type){
                
                NSString *toType;
                
                if ([type isEqualToString:@"weChatFriendClick"]) {
                    
                    toType = @"1";
                    
                    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                         
                     }];
                }else if ([type isEqualToString:@"weChatListClick"]) {
                    
                    toType = @"2";
                    
                    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                         
                     }];
                    
                }else if ([type isEqualToString:@"BBSClick"]) {
                    
                    toType = @"5";
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                    L_ShareToBBSViewController *shareToBBSVC = [storyboard instantiateViewControllerWithIdentifier:@"L_ShareToBBSViewController"];
                    shareToBBSVC.shareTitle = SCML.shareTitle;
                    shareToBBSVC.shareImg = SCML.shareImg;
                    shareToBBSVC.shareUrl = SCML.shareUrl;
                    [self.navigationController pushViewController:shareToBBSVC animated:YES];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JSValue *add = self.context[@"shareCallBack"];
                    NSLog(@"Func==add: %@", add);
                    
                    NSDictionary *shareDict = @{
                                                @"isSuccess":@"1",
                                                @"platformType":toType
                                                };
                    [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                    
                });
                
            };
            
        }else {
            
            [[SharePresenter getInstance] creatShareSDKcontent:SCML withCallBack:^(NSInteger isShareSuccess, NSInteger platformType) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JSValue *add = self.context[@"shareCallBack"];
                    NSLog(@"Func==add: %@", add);
                    
                    NSDictionary *shareDict = @{
                                                @"isSuccess":[NSString stringWithFormat:@"%ld",(long)isShareSuccess],
                                                @"platformType":[NSString stringWithFormat:@"%ld",(long)platformType]
                                                };
                    [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                    
                });
                
            }];
            
        }
        
    }else if (_type == 10) {//zaker新闻
        
        //        _SCML.shareSuperVC = self;
        //        _SCML.shareSuperView = self.view;
        //        _SCML.type = 5;
        //        _SCML.shareType = SSDKContentTypeAuto;
        
        SCML.shareUrl = _userActivityModel.gotourl;
        SCML.shareTitle = _userActivityModel.title;
        SCML.shareContext = _userActivityModel.content;
        SCML.shareImg = _userActivityModel.picurl;
        SCML.type = 5;
        
        
        
        
        
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                         images:SCML.shareImg
                                            url:[NSURL URLWithString:SCML.shareUrl]
                                          title:SCML.shareTitle
                                           type:SCML.shareType];
        
        
        ZG_shareBBSViewController *share = [ZG_shareBBSViewController shareZG_shareBBSVC];
        [share showInVC:self with:@""];
        
        share.buttonDidClickBlock= ^(NSString *type){
            
            NSString *toType;
            
            if ([type isEqualToString:@"weChatFriendClick"]) {
                
                toType = @"1";
                
                [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                     
                 }];
            }else if ([type isEqualToString:@"weChatListClick"]) {
                
                toType = @"2";
                
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                     
                 }];
                
            }else if ([type isEqualToString:@"BBSClick"]) {
                
                toType = @"5";
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                L_ShareToBBSViewController *shareToBBSVC = [storyboard instantiateViewControllerWithIdentifier:@"L_ShareToBBSViewController"];
                shareToBBSVC.shareTitle = SCML.shareTitle;
                shareToBBSVC.shareImg = SCML.shareImg;
                shareToBBSVC.shareUrl = SCML.shareUrl;
                [self.navigationController pushViewController:shareToBBSVC animated:YES];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JSValue *add = self.context[@"shareCallBack"];
                NSLog(@"Func==add: %@", add);
                
                NSDictionary *shareDict = @{
                                            @"isSuccess":@"1",
                                            @"platformType":toType
                                            };
                [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                
            });
            
        };
        
        //        @WeakObj(self);
        //        [[SharePresenter getInstance] creatShareSDKcontent:SCML withCallBack:^(NSInteger isShareSuccess, NSInteger platformType) {
        //
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                JSValue *add = self.context[@"shareCallBack"];
        //                NSLog(@"Func==add: %@", add);
        //
        //                NSDictionary *shareDict = @{
        //                                            @"isSuccess":[NSString stringWithFormat:@"%ld",(long)isShareSuccess],
        //                                            @"platformType":[NSString stringWithFormat:@"%ld",(long)platformType]
        //                                            };
        //                [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
        //
        //
        //
        //
        //            });
        //
        //        }];
        
    }
}

/**
 更新分享
 */
- (void)updateShareMessage:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        
        //        JSValue *add = self.context[@"shareCallBack"];
        
        NSLog(@"dict===%@",dict);
        NSString *content = [NSString stringWithFormat:@"%@",dict[@"context"]];
        NSString *title = [NSString stringWithFormat:@"%@",dict[@"title"]];
        
        _userActivityModel.title = [XYString IsNotNull:title];
        _userActivityModel.content = [XYString IsNotNull:content];
        if (![XYString isBlankString:[NSString stringWithFormat:@"%@",dict[@"url"]]]) {
            _userActivityModel.gotourl = [NSString stringWithFormat:@"%@",dict[@"url"]];
            NSLog(@"%@",dict[@"url"]);
            
        }
        if (![XYString isBlankString:[NSString stringWithFormat:@"%@",dict[@"picurl"]]]) {
            _userActivityModel.picurl = [NSString stringWithFormat:@"%@",dict[@"picurl"]];
        }
        self.shareTypes = [[NSString stringWithFormat:@"%@",dict[@"type"]] intValue];
        
    });
    
}
// MARK: - 隐藏或显示右上角分享按钮
- (void)hiddenOrShowRightBarButton:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        
        //flag 0禁用 1可用
        NSLog(@"dict===%@",dict);
        if ([dict[@"flag"] integerValue] == 0) {
            isHiddenRightBarButton = YES;
        }else if ([dict[@"flag"] integerValue] == 1) {
            isHiddenRightBarButton = NO;
        }
        
        if (isHiddenRightBarButton) {
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
        }else {
            //活动
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
            self.navigationItem.rightBarButtonItem = right;
        }
        
    });
    
}

#pragma mark - TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker { }
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    _imagePickerVC = nil;
    
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:photos[0]];
            cropController.delegate = self;
            
            cropController.imageWidth = _selectImageWidth;
            cropController.imageHeight = _selectImageHeight;
            
            cropController.defaultAspectRatio = TOCropViewControllerAspectRatioCustom;
            
            cropController.rotateClockwiseButtonHidden = YES;
            cropController.rotateButtonsHidden = YES;
            cropController.aspectRatioLocked = YES;
            
            [self presentViewController:cropController animated:YES completion:nil];
            
        }];
        
    }];
    
    //    [self.selectedPhotosArray removeAllObjects];
    //    [self.selectedPhotosArray addObjectsFromArray:photos];
    //
    //    for (int i = 0; i < self.selectedPhotosArray.count; i++) {
    //
    //        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    //
    //        [AppSystemSetPresenters upLoadPicFile:[self.selectedPhotosArray objectAtIndex:i] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
    //
    //                if(resultCode == SucceedCode) {
    //                    ///图片上传成功
    //                    NSDictionary * dic = data;
    //
    //                    //@"id"
    //                    //@"url"
    //
    //                    JSValue *add =self.context[@"photoValus"];
    //                    NSLog(@"Func==add: %@", add);
    //                    [add callWithArguments:@[[dic mj_JSONString]]];
    //
    //                }else {
    //
    //                    /** 图片上传失败 */
    //                    if (![XYString isBlankString:data]) {
    //                        [self showToastMsg:(NSString *)data Duration:3.0];
    //                    }else {
    //                        [self showToastMsg:@"图片上传失败" Duration:3.0];
    //                    }
    //
    //                }
    //
    //            });
    //
    //        }];
    //
    //    }
    
}
#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:^{
        
        UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        
        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if(resultCode == SucceedCode) {
                    ///图片上传成功
                    NSDictionary * dic = data;
                    
                    //@"id"
                    //@"url"
                    
                    JSValue *add =self.context[@"photoValus"];
                    NSLog(@"Func==add: %@", add);
                    [add callWithArguments:@[[dic mj_JSONString]]];
                    
                }else {
                    
                    /** 图片上传失败 */
                    if (![XYString isBlankString:data]) {
                        [self showToastMsg:(NSString *)data Duration:3.0];
                    }else {
                        [self showToastMsg:@"图片上传失败" Duration:3.0];
                    }
                    
                }
                
            });
            
        }];
        
        
    }];
}
// MARK: - 取消编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:nil];
    
}

#pragma mark - JS选择相册方法
-(void)upLoadImg:(id)param {
    
    NSDictionary *dict = [XYString getObjectFromJsonString:param];
    
    if (dict == nil) {
        return;
    }
    
    NSLog(@"param==%@dict===%@",param,dict);
    if ([dict isKindOfClass:[NSDictionary class]]) {
        //        maxPhotos = [NSString stringWithFormat:@"%ld",[dict[@"total"] integerValue] - [[NSString stringWithFormat:@"%@",dict[@"curcount"]] integerValue]];
        
        _selectImageWidth = [NSString stringWithFormat:@"%@",dict[@"width"]];
        _selectImageHeight = [NSString stringWithFormat:@"%@",dict[@"height"]];
        
        if ([XYString isBlankString:_selectImageWidth] && [XYString isBlankString:_selectImageHeight]) {
            return;
        }
        
    }else {
        return;
    }
    
    //    if ([XYString isBlankString:maxPhotos]) {
    //        return;
    //    }
    //
    //    if ([maxPhotos isEqualToString:@"0"]) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self showToastMsg:[NSString stringWithFormat:@"图片最多选择%@张",dict[@"total"]] Duration:3.0];
    //        });
    //        return;
    //    }
    
    @WeakObj(self);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 类方法
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
            if(buttonIndex==0)//拍照
            {
                /** 相机授权判断 */
                if (![self canOpenCamera]) {
                    return ;
                };
                
                /**
                 *  最多能选择数
                 */
                ZZCameraController *cameraController = [[ZZCameraController alloc]init];
                //                cameraController.takePhotoOfMax = maxPhotos.integerValue;
                cameraController.isSaveLocal = NO;
                //                cameraController.cameraSourceType = ZZImageSourceForMutable;
                
                cameraController.selectImageWidth = _selectImageWidth;
                cameraController.selectImageHeight = _selectImageHeight;
                cameraController.imageAspectRatio = CameraImageAspectRatioCustom;
                
                cameraController.takePhotoOfMax = 1;
                cameraController.cameraSourceType = ZZImageSourceForSingle;
                
                cameraController.rotateClockwiseButtonHidden = YES;
                cameraController.rotateButtonsHidden = YES;
                cameraController.aspectRatioLocked = YES;
                
                cameraController.isCanCustom = YES;
                [cameraController showIn:self result:^(id responseObject){
                    
                    NSLog(@"responseObject==%@",responseObject);
                    
                    //                    [selfWeak.selectedPhotosArray removeAllObjects];
                    //
                    //                    [selfWeak.selectedPhotosArray addObjectsFromArray:responseObject];
                    
                    //                    for (int i = 0; i < selfWeak.selectedPhotosArray.count; i++) {
                    
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:selfWeak.tabBarController];
                    
                    //                        [AppSystemSetPresenters upLoadPicFile:[selfWeak.selectedPhotosArray objectAtIndex:i] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    [AppSystemSetPresenters upLoadPicFile:responseObject UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            ///图片上传失败
                            if(resultCode == SucceedCode) {
                                ///图片上传成功
                                NSDictionary * dic = data;
                                JSValue *add =selfWeak.context[@"photoValus"];
                                NSLog(@"Func==add: %@", add);
                                //                                JSValue *sum = [add callWithArguments:@[dic[@"id"], dic[@"fileurl"]]];
                                //                                JSValue *sum = [add callWithArguments:@[[dic mj_JSONString]]];
                                //                                NSLog(@"Func==sum: %@", sum);
                                
                                [add callWithArguments:@[[dic mj_JSONString]]];
                                
                            }else {
                                
                                /** 图片上传失败 */
                                if (![XYString isBlankString:data]) {
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }else {
                                    [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                                }
                                
                            }
                            
                        });
                        
                    }];
                    
                    //                    }
                    
                }];
                
            }else if (buttonIndex==1) {//相册
                
                //                _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotos.integerValue delegate:selfWeak];
                _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:selfWeak];
                _imagePickerVC.pickerDelegate = selfWeak;
                [selfWeak presentViewController:_imagePickerVC animated:YES completion:^{
                    
                }];
            }else if (buttonIndex == 2){
                
                JSValue *add = self.context[@"webViewPhotoCancel"];
                NSLog(@"Func==add: %@", add);
                NSDictionary *callBackDict = @{@"version":kCurrentVersion};
                [add callWithArguments:@[[callBackDict mj_JSONString]]];
            }
        }];
        [sheet setTextColor:UIColorFromRGB(0xffffff)];
        [sheet show];
        
    });
    
}
#pragma mark - h5分享
- (void)shareFromh5:(id)param {
    
    NSLog(@"h5分享==%@",param);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        /** 分享链接 */
        NSString *shareUrlString = [NSString stringWithFormat:@"%@",dict[@"url"]];
        /** 分享内容 */
        NSString *shareContextString = [NSString stringWithFormat:@"%@",dict[@"context"]];
        /** 来源id */
        NSString *shareIDString = [NSString stringWithFormat:@"%@",dict[@"id"]];
        /** 分享图片链接 */
        NSString *sharePicurlString = [NSString stringWithFormat:@"%@",dict[@"picurl"]];
        /** 分享类型type */
        NSString *shareTypeString = [NSString stringWithFormat:@"%@",dict[@"type"]];
        /** 分享标题title */
        NSString *shareTitleString = [NSString stringWithFormat:@"%@",dict[@"title"]];
        
        NSString *context = [XYString IsNotNull:shareContextString];
        NSString *title = [XYString IsNotNull:shareTitleString];
        
        if ([XYString isBlankString:shareUrlString]) {
            [self showToastMsg:@"分享的链接未获取到" Duration:3.0];
            return;
        }
        
        //分享应用
        ShareContentModel * SCML = [[ShareContentModel alloc]init];
        SCML.sourceid            = shareIDString;
        SCML.shareTitle          = title;
        SCML.shareImg            = [XYString isBlankString:sharePicurlString] ? SHARE_LOGO_IMAGE : sharePicurlString;
        SCML.shareContext        = context;
        SCML.shareUrl            = shareUrlString;
        SCML.type                = shareTypeString.integerValue;
        SCML.shareSuperView      = self.view;
        SCML.shareType           = SSDKContentTypeAuto;
        //[SharePresenter creatShareSDKcontent:SCML];
        SCML.shareSuperVC = self;
        
        if([XYString isBlankString:SCML.shareTitle]) {
            SCML.shareTitle = @"皇冠社区";
        }
        
        if([XYString isBlankString:SCML.shareContext]) {
            SCML.shareContext = @"我已入驻未来星球，你想来吗？";
        }
        
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:SCML.shareContext
                                         images:SCML.shareImg
                                            url:[NSURL URLWithString:SCML.shareUrl]
                                          title:SCML.shareTitle
                                           type:SCML.shareType];
        
        if (shareTypeString.integerValue == 9) {
            
            ZG_shareBBSViewController *share = [ZG_shareBBSViewController shareZG_shareBBSVC];
            [share showInVC:self with:@""];
            
            share.buttonDidClickBlock= ^(NSString *type){
                
                NSString *toType;
                
                if ([type isEqualToString:@"weChatFriendClick"]) {
                    
                    toType = @"1";
                    
                    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                         
                     }];
                }else if ([type isEqualToString:@"weChatListClick"]) {
                    
                    toType = @"2";
                    
                    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处
                         
                     }];
                    
                }else if ([type isEqualToString:@"BBSClick"]) {
                    
                    toType = @"5";
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                    L_ShareToBBSViewController *shareToBBSVC = [storyboard instantiateViewControllerWithIdentifier:@"L_ShareToBBSViewController"];
                    shareToBBSVC.shareTitle = SCML.shareTitle;
                    shareToBBSVC.shareImg = SCML.shareImg;
                    shareToBBSVC.shareUrl = SCML.shareUrl;
                    [self.navigationController pushViewController:shareToBBSVC animated:YES];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JSValue *add = self.context[@"shareCallBack"];
                    NSLog(@"Func==add: %@", add);
                    
                    NSDictionary *shareDict = @{
                                                @"isSuccess":@"1",
                                                @"platformType":toType
                                                };
                    [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                    
                });
                
            };
            
        }else {
            
            [[SharePresenter getInstance] creatShareSDKcontent:SCML withCallBack:^(NSInteger isShareSuccess, NSInteger platformType) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    JSValue *add = self.context[@"shareCallBack"];
                    NSLog(@"Func==add: %@", add);
                    
                    NSDictionary *shareDict = @{
                                                @"isSuccess":[NSString stringWithFormat:@"%ld",(long)isShareSuccess],
                                                @"platformType":[NSString stringWithFormat:@"%ld",(long)platformType]
                                                };
                    [add callWithArguments:@[[XYString getJsonStringFromObject:shareDict]]];
                    
                });
                
            }];
            
        }
        
    });
    
}
#pragma mark - 私信
/** 私信 */
- (void)sixin:(id)param {
    
    NSLog(@"聊天param==%@",param);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSString *userid = [NSString stringWithFormat:@"%@",dict[@"userid"]];
        NSLog(@"聊天dict==%@",dict);
        if ([XYString isBlankString:userid]) {
            [self showToastMsg:@"获得用户信息失败" Duration:3.0];
            return;
        }
        AppDelegate *appDelegate = GetAppDelegates;
        if ([userid isEqualToString:appDelegate.userData.userID]) {
            [self showToastMsg:@"不能和自己聊天" Duration:3.0];
            return;
        }
        
        ChatViewController *chatC =[[ChatViewController alloc]initWithChatType:XMMessageChatSingle];
        chatC.navigationItem.title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",dict[@"nickname"]]];
        chatC.ReceiveID = userid;
        
        NSDictionary * contentDic = [dict objectForKey:@"content"];
        
        if (contentDic) {
            
            chatC.isGoods = YES;
            chatC.goodsDic = contentDic;
            
        }
        
        //    chatC.chatterThumb = [XYString IsNotNull:[NSString stringWithFormat:@"%@",dict[@"headImg"]]];
        //    chatC.chatterName = [XYString IsNotNull:[NSString stringWithFormat:@"%@",dict[@"nickname"]]];
        [self.navigationController pushViewController:chatC animated:YES];
        
    });
    
    
}
#pragma mark - 点击放大图片
/** 点击放大图片 */
- (void)showimage:(id)param {
    
    NSLog(@"点击放大图片===%@",param);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        
        NSArray *picListArray = dict[@"piclist"];
        _currentIndex = ([NSString stringWithFormat:@"%@",dict[@"currentIndex"]]).integerValue;
        
        if (picListArray.count == 0) {
            return;
        }
        if (_currentIndex < 0 || _currentIndex > picListArray.count-1) {
            return;
        }
        
        _imageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < picListArray.count; i++) {
            [_imageList addObject:[NSString stringWithFormat:@"%@",[picListArray[i] objectForKey:@"picurl"]]];
        }
        
        SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
        browser.sourceImagesContainerView = self.webView;
        browser.imageCount = self.imageList.count;
        browser.currentImageIndex = _currentIndex;
        browser.delegate = self;
        [browser show]; // 展示图片浏览器
        
    });
    
}
#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return PLACEHOLDER_IMAGE;
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:self.imageList[index]];
}

#pragma mark - 点赞列表
/**
 点赞列表
 */
- (void)dianzanlist:(id)param {
    
    NSLog(@"点赞列表===%@",param);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSString *personNum = [NSString stringWithFormat:@"%@",dict[@"personNum"]];
        
        if ([XYString isBlankString:[NSString stringWithFormat:@"%@",dict[@"postid"]]] || [XYString isBlankString:personNum] || personNum.integerValue <= 0) {
            return;
        }
        
        PraiseListVC * plVC = [[PraiseListVC alloc]init];
        plVC.postid =  [NSString stringWithFormat:@"%@",dict[@"postid"]];
        plVC.praisecount = personNum;
        [self.navigationController pushViewController:plVC animated:YES];
        //    dict[@"postid"]     帖子id
        //    dict[@"personNum"]  点赞总人数
    });
    
}
#pragma mark - 跳转邻趣首页
/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ {
    NSLog(@"跳转邻趣首页");
    
    [USER_DEFAULT setObject:@"yes" forKey:DELETE_LIST_VALUE_OK];
    [USER_DEFAULT synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showToastMsg:@"贴子发布成功!" Duration:3.0];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
}
#pragma mark - token失效重新登录
-(void)relogin {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //[LogInPresenter ReLogInFor:param];
        AppDelegate *appDlt=GetAppDelegates;
        // [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        MsgAlertView * alertView=[MsgAlertView sharedMsgAlertView];
        @WeakObj(self);
        
        [alertView showMsgViewForMsg:@"登录失效了,请重新登录" btnOk:@"重新登录" btnCancel:@"返回登录页" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            if(index==100)
            {
                if (appDlt.userData.isRememberPw.boolValue) {
                    
                    LogInPresenter *logInPresenter=[LogInPresenter new];
                    [logInPresenter logInForAcc:appDlt.userData.accPhone Pw:appDlt.userData.passWord upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(resultCode==SucceedCode)
                            {
                                
                                AppDelegate *appDelegate = GetAppDelegates;
                                
                                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                                [shared synchronize];
                                
                                [AppDelegate showToastMsg:@"登录成功!" Duration:5.0];
                                AppDelegate * appdelegate = GetAppDelegates;
                                
                                JSValue *add = selfWeak.context[@"freshToken"];
                                NSLog(@"Func==add: %@", add);
                                [add callWithArguments:@[[@{@"token":appdelegate.userData.token} mj_JSONString]]];
                                
                                [AppSystemSetPresenters getBindingTag];
                                
                                [appdelegate saveContext];
                                
                            }else{
                                
                                [AppDelegate showToastMsg:@"登录失败了!" Duration:5.0];
                                //退出登录
                                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                                UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                                AppDelegate * appdelegate = GetAppDelegates;
                                [appdelegate setTags:nil error:nil];
                                appdelegate.userData.token = @"";
                                
                                [appdelegate saveContext];
                                appdelegate.window.rootViewController = loginVC;
                                
                                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                                [loginVC.view.window.layer addAnimation:animation forKey:nil];
                                
                            }
                            
                        });
                    }];
                    
                }else {
                    
                    //未记住密码
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                    UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                    
                    AppDelegate * appdelegate = GetAppDelegates;
                    [appdelegate setTags:nil error:nil];
                    appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                    appdelegate.userData.token = @"";
                    
                    [appdelegate saveContext];
                    
                    appdelegate.window.rootViewController = loginVC;
                    
                    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                    [loginVC.view.window.layer addAnimation:animation forKey:nil];
                    
                }
                
            }
            else
            {
                //退出登录
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                //                    LoginVC *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                
                AppDelegate * appdelegate = GetAppDelegates;
                [appdelegate setTags:nil error:nil];
                appdelegate.userData.isLogIn=[[NSNumber alloc]initWithBool:NO];
                appdelegate.userData.token = @"";
                
                [appdelegate saveContext];
                
                appdelegate.window.rootViewController = loginVC;
                
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
                [loginVC.view.window.layer addAnimation:animation forKey:nil];
            }
            
        }];
        
    });
    
}

#pragma mark - 收藏回调
/**
 收藏回调
 */
- (void)refreshCollect {
    NSLog(@"收藏回调");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REFRESH_COLLECT_DATA object:nil];
}
#pragma mark - 关注回调
/**
 关注回调
 */
- (void)refreshAttention {
    NSLog(@"关注回调");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REFRESH_ATTENTION_DATA object:nil];
    
}
#pragma mark - 编辑发布成功回调
/**
 编辑发布成功回调
 */
- (void)refreshEdit {
    NSLog(@"编辑发布成功回调");
    
    [USER_DEFAULT setObject:@"yes" forKey:NOTICE_REFRESH_EDIT_DATA];
    [USER_DEFAULT synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showToastMsg:@"贴子发布成功!" Duration:3.0];
        //        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    });
    
}

#pragma mark - 删除举报分享
/**
 帖子详情举报分享发布h5回调
 */
- (void)reportAction:(id)param {
    
    //发布帖 posttype = 0 普通帖详情 posttype = 1 投票帖详情 posttype = 2 问答帖详情 posttype = 3  房产帖详情 posttype = 5 个人主页 posttype = 6 社区帖子列表 posttype = 7 房产列表 posttype = 8
    NSLog(@"param==%@",param);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _reportDictionary = [XYString getObjectFromJsonString:param];
        
        NSString *postType = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"posttype"]];
        
        NSLog(@"h5回调数据==%@",_reportDictionary);
        
        if ([postType isEqualToString:@"6"]) {
            
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
            
            if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]]]) {
                self.title = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]];
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:self.title];
            }else {
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:@"个人主页"];
            }
            
        }else if ([postType isEqualToString:@"7"]) {
            
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
            
            if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]]]) {
                self.title = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]];
                /** 设置社区帖子列表页导航栏标题 */
                [self setupCommunityNavWithTitle:self.title];
            }else {
                //                self.title = @"社区帖子列表";
                /** 设置社区帖子列表页导航栏标题 */
                if (![XYString isBlankString:[_reportDictionary[@"map"] objectForKey:@"name"]]) {
                    self.title = [NSString stringWithFormat:@"%@",[_reportDictionary[@"map"] objectForKey:@"name"]];
                }
                
                [self setupCommunityNavWithTitle:self.title];
            }
            
        }else if([postType isEqualToString:@"1"] || [postType isEqualToString:@"2"] || [postType isEqualToString:@"3"] || [postType isEqualToString:@"5"]) {
            
            if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]]]) {
                self.title = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]];
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:self.title];
            }else {
                
                if ([postType isEqualToString:@"1"]) {
                    self.title = @"普通贴详情";
                }
                if ([postType isEqualToString:@"2"]) {
                    self.title = @"投票贴详情";
                }
                if ([postType isEqualToString:@"3"]) {
                    self.title = @"问答贴详情";
                }
                
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:self.title];
            }
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0, 0, 25, 25);
            [rightButton setBackgroundImage:[UIImage imageNamed:@"邻圈_群_群设置_举报-退出"] forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightNavBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = rightNavBarButton;
            
        }else {
            
            self.navigationItem.rightBarButtonItem = [self normalRightBarButton];
            if (![XYString isBlankString:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]]]) {
                self.title = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"title"]];
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:self.title];
            }else {
                /** 设置详情页导航栏标题 */
                [self setupDetailsNavWithTitle:self.title];
            }
            
        }
        
    });
    
}
/**
 帖子详情举报分享发布点击方法
 */
- (void)rightBarButtonAction {
    
    NSDictionary *mapDict = [_reportDictionary objectForKey:@"map"];
    
    NSString *userID = [NSString stringWithFormat:@"%@",[mapDict objectForKey:@"userid"]];
    NSString *postID = [NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"postid"]];
    
    if ([XYString isBlankString:userID] || [XYString isBlankString:postID]) {
        return;
    }
    
    AppDelegate * appDlgt = GetAppDelegates;
    if ([appDlgt.userData.userID isEqualToString:userID]) {
        
        MMPopupItemHandler block = ^(NSInteger index){
            NSLog(@"clickd %@ button",@(index));
            
            switch (index) {
                case 0:
                {
                    NSString *title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[mapDict objectForKey:@"title"]]];
                    NSString *content = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[mapDict objectForKey:@"content"]]];
                    NSArray *picArray = [mapDict objectForKey:@"piclist"];
                    NSString *gotourl = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"shareUrl"]]];
                    
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.shareTitle          = title;
                    SCML.shareImg            = SHARE_LOGO_IMAGE;
                    if ([picArray isKindOfClass:[NSArray class]]) {
                        if(picArray.count > 0) {
                            NSString * url = [[picArray firstObject] objectForKey:@"picurl"];;
                            SCML.shareImg = url;
                        }
                    }
                    SCML.shareContext = content;
                    SCML.shareUrl = gotourl;
                    SCML.type = 4;
                    SCML.sourceid = postID;
                    SCML.shareSuperView = self.view;
                    //          SCML.shareType = SSDKContentTypeWebVC;
                    SCML.shareType = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];
                    
                }
                    break;
                case 1:
                {
                    /** 判断是否是自己的帖子 */
                    if([appDlgt.userData.userID isEqualToString:userID]) {
                        
                        [[ActionSheetVC shareActionSheet] dismiss];
                        
                        [[MessageAlert shareMessageAlert] showInVC:self withTitle:@"确定删除此条贴子吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
                        [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                NSLog(@"---点击删除");
                                
                                [self httpRequestForDeleteWithPostid:postID];
                                
                            }
                        };
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        };
        
        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
            NSLog(@"animation complete");
        };
        
        NSArray *items =
        @[MMItemMake(@"分享", MMItemTypeNormal, block),
          MMItemMake(@"删除", MMItemTypeNormal, block)];
        
        [[[MMSheetView alloc] initWithTitle:@""
                                      items:items] showWithBlock:completeBlock];
        
    }else {
        
        MMPopupItemHandler block = ^(NSInteger index){
            NSLog(@"clickd %@ button",@(index));
            
            switch (index) {
                case 0:
                {
                    NSString *title = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[mapDict objectForKey:@"title"]]];
                    NSString *content = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[mapDict objectForKey:@"content"]]];
                    NSArray *picArray = [mapDict objectForKey:@"piclist"];
                    NSString *gotourl = [XYString IsNotNull:[NSString stringWithFormat:@"%@",[_reportDictionary objectForKey:@"shareUrl"]]];
                    
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.shareTitle          = title;
                    SCML.shareImg            = SHARE_LOGO_IMAGE;
                    if ([picArray isKindOfClass:[NSArray class]]) {
                        if(picArray.count > 0) {
                            NSString * url = [[picArray firstObject] objectForKey:@"picurl"];;
                            SCML.shareImg = url;
                        }
                    }
                    SCML.shareContext = content;
                    SCML.shareUrl = gotourl;
                    SCML.type = 4;
                    SCML.sourceid = postID;
                    SCML.shareSuperView = self.view;
                    //          SCML.shareType = SSDKContentTypeWebVC;
                    SCML.shareType = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];
                    
                }
                    break;
                case 1:
                {
                    if (![XYString isBlankString:userID]) {
                        
                        MMPopupItemHandler block = ^(NSInteger index){
                            NSLog(@"clickd %@ button",@(index));
                            
                            [PostPresenter addPostsReport:postID withType:[NSString stringWithFormat:@"%ld",index] andSource:@"1" andCallBack:^(id  _Nullable data, ResultCode resultCode) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if(resultCode == SucceedCode) {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self showToastMsg:@"举报成功" Duration:3.0];
                                            
                                        });
                                        
                                    }
                                    else {
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            if ([XYString isBlankString:data]) {
                                                [self showToastMsg:@"举报失败" Duration:3.0];
                                            }else {
                                                [self showToastMsg:data Duration:3.0];
                                            }
                                            
                                        });
                                        
                                    }
                                    
                                });
                                
                            }];
                            
                        };
                        
                        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
                            NSLog(@"animation complete");
                        };
                        
                        NSArray *items =
                        @[MMItemMake(@"骚扰信息", MMItemTypeNormal, block),
                          MMItemMake(@"虚假身份", MMItemTypeNormal, block),
                          MMItemMake(@"广告欺诈", MMItemTypeNormal, block),
                          MMItemMake(@"不当发言", MMItemTypeNormal, block),];
                        
                        [[[MMSheetView alloc] initWithTitle:@""
                                                      items:items] showWithBlock:completeBlock];
                        
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        };
        
        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
            NSLog(@"animation complete");
        };
        
        NSArray *items =
        @[MMItemMake(@"分享", MMItemTypeNormal, block),
          MMItemMake(@"举报", MMItemTypeNormal, block)];
        
        [[[MMSheetView alloc] initWithTitle:@""
                                      items:items] showWithBlock:completeBlock];
    }
    return;
    
}
#pragma mark - 跳转到微信支付
/**
 跳转到微信支付
 */
- (void)jumpToWXPay:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSLog(@"dict===%@",dict);
        NSDictionary * tempDic = [dict objectForKey:@"thirdpay"];
        NSString * type = [dict objectForKey:@"type"];/** 用于商城支付判断 */
        passback = [dict objectForKey:@"passback"];/** 用于商城支付回调 */
        NSString * timerStr = [tempDic objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"appid"]];
        req.partnerId           = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"partnerid"]];
        req.prepayId            = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"prepayid"]];
        req.nonceStr            = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"noncestr"]];
        req.timeStamp           = timerStr.intValue;
        req.package             = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"package"]];
        req.sign                = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"sign"]];
        
        @WeakObj(self);
        [APPWXPAYMANAGER usPay_payWithPayReq:req callBack:^(enum WXErrCode errCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"errorCode = %zd",errCode);
                if (errCode == WXSuccess) {
                    NSLog(@"支付成功");
                    
                    JSValue *add = selfWeak.context[@"replyWXPay"];
                    NSLog(@"Func==add: %@", add);
                    
                    //passback，和type
                    
                    NSArray * callbackArr;
                    
                    if([XYString isBlankString:type]&&type.integerValue!=1){
                        
                        [self showToastMsg:@"贴子发布成功!" Duration:3.0];
                        callbackArr = @[[@{@"errmsg":@"成功",@"errcode":@"0"} mj_JSONString]];
                        [add callWithArguments:callbackArr];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }else {
                        
                        callbackArr = @[[@{@"errmsg":@"成功",@"errcode":@"0",@"passback":passback} mj_JSONString]];
                        
                        [add callWithArguments:callbackArr];
                        
                    }
                    
                    
                }else {
                    
                    NSLog(@"支付失败：errCode=%d",errCode);
                    
                    NSString *errmsg = @"";
                    
                    switch (errCode) {
                        case WXErrCodeCommon:
                        {
                            errmsg = @"普通错误类型";
                        }
                            break;
                        case WXErrCodeUserCancel:
                        {
                            errmsg = @"支付取消";
                        }
                            break;
                        case WXErrCodeSentFail:
                        {
                            errmsg = @"发送失败";
                        }
                            break;
                        case WXErrCodeAuthDeny:
                        {
                            errmsg = @"授权失败";
                        }
                            break;
                        case WXErrCodeUnsupport:
                        {
                            errmsg = @"微信不支持";
                        }
                            break;
                        default:
                            break;
                    }
                    
                    [self showToastMsg:errmsg Duration:3.0];
                    JSValue *add = selfWeak.context[@"replyWXPay"];
                    NSLog(@"Func==add: %@", add);
                    [add callWithArguments:@[[@{@"errmsg":errmsg,@"errcode":[NSString stringWithFormat:@"%d",errCode]} mj_JSONString]]];
                }
                
            });
            
        }];
        
    });
    
}
#pragma mark - 跳转到支付宝支付
- (void)jumpToAliPay:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSLog(@"dict===%@",dict);
        
        NSString * type = [XYString IsNotNull:[dict objectForKey:@"type"]];/** 用于商城支付判断 */
        passback = [XYString IsNotNull:[dict objectForKey:@"passback"]];/** 用于商城支付回调 */
        
        NSString *thirdPay = [dict objectForKey:@"thirdpay"];
        if ([XYString isBlankString:thirdPay]) {
            return ;
        }
        
        [APPWXPAYMANAGER doAlipayPayWithOrderString:thirdPay CallBack:^(NSDictionary *dict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"支付宝支付结果====%@",dict);
                
                NSInteger resultStatus = [dict[@"resultStatus"] integerValue];
                switch (resultStatus) {
                    case 9000:
                    {
                        JSValue *add = self.context[@"replyWXPay"];
                        NSLog(@"Func==add: %@", add);
                        NSArray * callbackArr;
                        
                        if([XYString isBlankString:type] && type.integerValue!=1){
                            
                            [self showToastMsg:@"贴子发布成功!" Duration:3.0];
                            callbackArr = @[[@{@"errmsg":@"成功",@"errcode":@"0"} mj_JSONString]];
                            [add callWithArguments:callbackArr];
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        }else {
                            
                            callbackArr = @[[@{@"errmsg":@"成功",@"errcode":@"0",@"passback":passback} mj_JSONString]];
                            
                            [add callWithArguments:callbackArr];
                            
                        }
                        
                    }
                        break;
                    case 6001:
                    {
                        [self showToastMsg:@"支付取消" Duration:3.0];
                        JSValue *add = self.context[@"replyWXPay"];
                        [add callWithArguments:@[[@{@"errmsg":@"支付取消",@"errcode":@"6001"} mj_JSONString]]];
                        NSLog(@"Func==add: %@", add);
                        
                    }
                        break;
                    default:
                    {
                        [self showToastMsg:dict[@"memo"] Duration:3.0];
                        JSValue *add = self.context[@"replyWXPay"];
                        [add callWithArguments:@[[@{@"errmsg":[XYString IsNotNull:dict[@"memo"]],@"errcode":[NSString stringWithFormat:@"%ld",(long)resultStatus]} mj_JSONString]]];
                        NSLog(@"Func==add: %@", add);
                        
                    }
                        break;
                }
                
            });
            
        }];
        
    });
    
    
    //            9000    订单支付成功
    //            8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    //            4000    订单支付失败
    //            5000    重复请求
    //            6001    用户中途取消
    //            6002    网络连接出错
    //            6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    //            其它    其它支付错误
    //            {
    //                "memo" : "xxxxx",
    //                "result" : "{
    //                        \"alipay_trade_app_pay_response\":{
    //                        \"code\":\"10000\",
    //                        \"msg\":\"Success\",
    //                        \"app_id\":\"2014072300007148\",
    //                        \"out_trade_no\":\"081622560194853\",
    //                        \"trade_no\":\"2016081621001004400236957647\",
    //                        \"total_amount\":\"0.01\",
    //                        \"seller_id\":\"2088702849871851\",
    //                        \"charset\":\"utf-8\",
    //                        \"timestamp\":\"2016-10-11 17:43:36\"
    //                    },
    //                    \"sign\":\"NGfStJf3i3ooWBuCDIQSumOpaGBcQz+aoAqyGh3W6EqA/gmyPYwLJ2REFijY9XPTApI9YglZyMw+ZMhd3kb0mh4RAXMrb6mekX4Zu8Nf6geOwIa9kLOnw0IMCjxi4abDIfXhxrXyj********\",
    //                    \"sign_type\":\"RSA2\"
    //                }",
    //         "resultStatus" : "9000"
    //         }
}

// MARK: - 展示h5弹窗提示
- (void)showH5MsgInfo:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        
        [self showToastMsg:dict[@"msg"] Duration:3.0];
        
    });
    
}
// MARK: - 点赞
- (void)praiseClick:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSLog(@"dict====%@",dict);
        
        if (self.praiseAndCommentCallBack) {
            //type 0已点赞 1 未点赞
            self.praiseAndCommentCallBack([NSString stringWithFormat:@"%@",dict[@"praisecount"]],nil,nil,[NSString stringWithFormat:@"%@",dict[@"type"]]);
            
        }
        
    });
    
}
// MARK: - 评论
- (void)commentClick:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        NSLog(@"dict====%@",dict);
        if (self.praiseAndCommentCallBack) {
            
            self.praiseAndCommentCallBack(nil,[NSString stringWithFormat:@"%@",dict[@"commentcount"]],nil,nil);
        }
    });
}
//-----------------------
// MARK: - 复制到剪切板
- (void)pasteMsg:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = dict[@"msg"];
        
    });
    
}

// MARK: - 回到社区
- (void)popView {
    if (self.shopCallBack) {
        self.shopCallBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController.navigationBar setHidden:NO];
}

// MARK: - 跳转商城
- (void)gotoShopWebView {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    webVC.url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    webVC.isNoRefresh = YES;
    webVC.isHiddenBar = YES;
    webVC.talkingName = JiFenShangCheng;
    
    webVC.title=@"商城";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

// MARK: - 隐藏导航栏
- (void)hideNavigationBarHTML:(id)param{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [XYString getObjectFromJsonString:param];
        
        //flag 0禁用 1可用
        NSLog(@"dict===%@",dict);
        if ([dict[@"flag"] integerValue] == 0) {
            isHiddenNavigationBar = YES;
        }else if ([dict[@"flag"] integerValue] == 1) {
            isHiddenNavigationBar = NO;
        }
        _isHiddenBar = isHiddenNavigationBar;
        [self.navigationController setNavigationBarHidden:_isHiddenBar animated:NO];
    });
}
- (IBAction)homeBtnAction:(id)sender {
    
    if(![self.url hasPrefix:@"http://"] && ![self.url hasPrefix:@"https://"])
    {
        self.url=[NSString stringWithFormat: @"http://%@",self.url];
    }
    
    NSURL *httpUrl=[NSURL URLWithString:self.url];
    if (_weburl) {
        httpUrl=_weburl;
    }
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.webView loadRequest:httpRequest];
    
}
- (IBAction)backBtnAction:(id)sender {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (IBAction)forwardBtnAction:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
        
    }
}
- (IBAction)refreashBtnAction:(id)sender {
    //    [self.webView reload];
    [self.webView.scrollView.mj_header beginRefreshing];
    
}
- (IBAction)clearBtnAction:(id)sender {
    [self insertRowToTop];
    
    if(![self.url hasPrefix:@"http://"] && ![self.url hasPrefix:@"https://"])
    {
        self.url=[NSString stringWithFormat: @"http://%@",self.url];
    }
    
    NSURL *httpUrl=[NSURL URLWithString:self.url];
    if (_weburl) {
        httpUrl=_weburl;
    }
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.webView loadRequest:httpRequest];
}
//// 设备支持方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}
//// 默认方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
//}
- (BOOL)shouldAutorotate {
    return YES;
}
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
//-(void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
//    }
//}

@end
