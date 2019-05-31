//
//  PAWebViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWebViewController.h"
#import "SharePresenter.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface PAWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView * webView;
@property(nonatomic,strong) JSContext *context;

@end

@implementation PAWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *httpUrl=[NSURL URLWithString:self.url];
    NSMutableURLRequest *httpRequest=[NSMutableURLRequest requestWithURL:httpUrl];
    
    [self.webView loadRequest:httpRequest];
    
    if (!self.hideRightBarButtonItem) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)rightAction:(UIBarButtonItem *)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray * shareList= @[
                 @(SSDKPlatformTypeQQ),
                 @(SSDKPlatformSubTypeWechatSession),
                 @(SSDKPlatformSubTypeWechatTimeline),
                 @(SSDKPlatformSubTypeQQFriend),
                 @(SSDKPlatformSubTypeQZone)];

    [shareParams SSDKSetupShareParamsByText:self.noticeModel.noticeContent
                                     images:@[SHARE_LOGO_IMAGE]
                                        url:[NSURL URLWithString:self.shareUrl]
                                      title:self.title
                                       type:SSDKContentTypeWebPage];
    
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil
                             items:shareList
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   NSLog(@"%@",error);
               }
     ];
}

@end
