//
//  PANewHomeBannerView.m
//  TimeHomeApp
//
//  Created by ning on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeBannerView.h"
#import "SDCycleScrollView.h"
#import "UserActivity.h"
#import "WebViewVC.h"
#import "CommunityCertificationVC.h"
#import "PANewHomeBannerModel.h"

@interface PANewHomeBannerView()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleBannerView;
@property (nonatomic,strong) NSArray *bannerArray;
@end

@implementation PANewHomeBannerView

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cycleBannerView];
    }
    return self;
}

-(SDCycleScrollView *)cycleBannerView{
    if (!_cycleBannerView) {
        _cycleBannerView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-20, (kScreenWidth-20)/2.2) imageNamesGroup:nil];
        _cycleBannerView.delegate = self;
        _cycleBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerView.placeholderImage = [UIImage imageNamed:@"图片加载失败@2x.png"];
    }
    return _cycleBannerView;
}

-(NSArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}

- (void)updateWithBannerArray:(NSArray *)bannerArray {
    if (bannerArray.count>1) {
        self.cycleBannerView.autoScroll = YES;
    }else{
        self.cycleBannerView.autoScroll = NO;
    }
    NSMutableArray *imageURLArray = [NSMutableArray array];
    if (bannerArray.count>0) {
        for (NSInteger i = 0; i<bannerArray.count; i++) {
            PANewHomeBannerModel *bannerModel = bannerArray[i];
            [imageURLArray addObject:bannerModel.fileurl];
        }
        self.cycleBannerView.imageURLStringsGroup = imageURLArray;
    }else{
        NSString *imageUrl = @"社区轮播图@2x.png";
        [imageURLArray addObject:imageUrl];
        self.cycleBannerView.localizationImageNamesGroup = imageURLArray;
    }
    self.bannerArray = bannerArray;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerArray == nil||self.bannerArray.count==0 ) {
        return;
    }
    
    PANewHomeBannerModel * bannerModel = [self.bannerArray objectAtIndex:index];
    if ([XYString isBlankString:bannerModel.gotourl]) {
        return;
    }
    UserActivity *userModel = [[UserActivity alloc]init];
    userModel.picurl = bannerModel.fileurl;
    userModel.gotourl = bannerModel.gotourl;
    userModel.title = bannerModel.title;
    AppDelegate *appDlgt = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    if([bannerModel.gotourl hasSuffix:@".html"]){
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",bannerModel.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    else if([bannerModel.gotourl isEqualToString:@"certresi"]) {
        CommunityCertificationVC *certifi = [[CommunityCertificationVC alloc] init];
        certifi.pushType = @"1";
        certifi.fromType = 4;
        [certifi setHidesBottomBarWhenPushed:YES];
        if (self.callback) {
            self.callback(certifi);
        }
        return;
    }else{
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",bannerModel.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    webVc.type = 5;
    webVc.shareTypes = 5;
    webVc.userActivityModel = userModel;
    if (![XYString isBlankString:userModel.title]) {
        webVc.title = userModel.title;
    }else{
        webVc.title = @"活动详情";
    }
    webVc.isGetCurrentTitle = YES;
    webVc.talkingName = @"shequhuodong";
    if (self.callback) {
        self.callback(webVc);
    }
}

@end
