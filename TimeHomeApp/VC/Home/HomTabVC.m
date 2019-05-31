
//
//  HomTabVC.m
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "FYLPageViewController.h"
#import "HomTabVC.h"
#import "MyBigPictureFlowLayout.h"//////
#import "UIButtonImageWithLable.h"
#import "PropertyManagementVC.h"
#import "IntelligentGarageVC.h"
#import "ShakePassageVC.h"
#import "VisitorVC.h"
#import "NotificationVC.h"
#import "OnlineServiceVC.h"
#import "SuggestionsVC.h"
#import "NewsVC.h"
#import "ActivitysVC.h"
#import "ContactServiceVC.h"
#import "ChangAreaVC.h"
#import "VoicePopVC.h"
#import "HouseFunctionVC.h"
#import "HouseTableVC.h"
#import "WebViewVC.h"
#import "AppSystemSetPresenters.h"
#import "CommunityManagerPresenters.h"
#import "NewsPresenter.h"
#import "HDActivityPresenter.h"
#import "ChatMessageMainVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SignatureView.h"
#import "UserPointAndMoneyPresenters.h"
#import "NoviceViewModel.h"
#import "MessageAlert.h"
#import "PushMsgModel.h"
#import "PersonalNoticeVC.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "AlertsListVC.h"
#import "ChatViewController.h"
#import "DataOperation.h"
#import "MsgAlertView.h"
#import "UITabBar+Badge.h"
#import "DateUitls.h"
#import "MainTabBars.h"
#import "THIndicatorVC.h"
#import "THMyInfoPresenter.h"
#import "THOwnerAuthViewController.h"
#import "UserActivity.h"
#import "NotificationVC.h"
#import "NibCell.h"
#import "CarStewardFirstVC.h"
#import "PropertyIcon.h"
#import "HomePropertyIconModel.h"
#import "YYNoticeSetPresent.h"
#import "NetWorks.h"
#import "THCommitSuggestionsViewController.h"
#import "Ls_ActiveCell.h"
#import "Ls_NewsCell.h"
#import "ZakerNewsTableViewCell.h"//热门新闻
#import "SharePresenter.h"
#import "RedPacketsVC.h"
#import "RedPacketsAlertVC.h"
#import "ParkingManagePresenter.h"
#import "PeaceChinaVC.h"
#import "SigninPopVC.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "RaiN_NewServiceTempVC.h"
#import "PAMoreMenuViewController.h"
#import "PAParkingViewController.h"
#import "PAHomeNoticeLabel.h"
#import "L_NewMyHouseListViewController.h"
#import "PANewHomeViewController.h"
#define UNIT_LENTH self.view.frame.size.width / 640
#define news_cell_h    67+30+85+((SCREEN_WIDTH-20)/2.2)-3
#define active_cell_h  (SCREEN_WIDTH-20)/2.2+120.0f-3
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kHomeAnimationDuration 0.4 //动画时间

#import "L_NewBikeListViewController.h"
#import "L_CarNumberErrorViewController.h"
#import "RaiN_NewSigninPresenter.h"//新版本签到接口相关

#import "L_AppNotificationPopVC.h"
#import "L_CommunityAuthoryPresenters.h"//新业主认证接口
#import "CommunityCertificationVC.h"

#import "L_BikeGuardListVC.h"
#import "RaiN_NewOnlineServiceVC.h"
#import "SpeedyLockViewController.h"//一键锁定
#import "PACarSpaceService.h"

#import "L_UpdateVC.h"
#import "SDCycleScrollView.h"

#import "PAWaterScanViewController.h"
@interface HomTabVC ()<SDCycleScrollViewDelegate,SignatureViewDelegate,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,CustomViewFlowLayoutDelegate,UICollectionViewDelegateFlowLayout,PABaseServiceDelegate>
{
    AppDelegate *appDlgt;
    ///轮播图数据
    NSArray * bannerArray;
    ///通知公告数据
    NSArray * notificArray;
    ///声音
    SystemSoundID soundID;
    ///活动内容高度
    float activityHeight;
    ///新闻内容高度
    float newsHeight;
    NSInteger contentHeight;
    
    ///活动详情地址
    NSString * activityUrl;
    ///新闻详情地址
    NSString *newsUrl;
    
    ///首页弹窗背景
    UIView *alertBack;
    ///AppStore地址
    NSString *trackViewURL;
    ///首页弹窗app反馈模式
    UIView *alertView;
    ///首页弹窗文字模式
    UIView *alertView1;
    ///首页弹窗文字内容
    UILabel *textLal;
    ///首页弹窗活动模式
    UIView *alertView2;
    ///首页弹窗活动图片
    UIImageView *urlImg;
    ///活动马上参加按钮
    UIButton *joinBt;
    ///参加活动网址
    NSString *goToUrl;
    ///是否弹出积分弹窗
    BOOL ispopjifen;
    
    ///活动数组
    NSArray * zakerNewsArr;
    ///活动数组
    NSArray * activeArr;
    ///新闻数组
    NSArray * newsArr;
    ///约束初始值
    CGFloat  save_contentsize_h;
    ///新闻字典
    NSDictionary * newsDic;
    ///判断是否有活动
    
    BOOL isHaveHouse;
    ///是否有房产
    BOOL isHaveParking;
    ///是否有车位
    
    NSUserDefaults *userDefaults;
    NSInteger isredenvelope;//是否有红包
    SigninPopVC * shareSigninPopVC;
}

//UI
@property (weak, nonatomic) IBOutlet UIButton *NavigationTitleButton;//标题栏
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;//页面容器滚动视图
@property (weak, nonatomic) IBOutlet UIView *partOneView;//固定高度容器视图
@property (weak, nonatomic) IBOutlet UIView *bannerSV_Banner;//滚动视图
@property (nonatomic,strong) SDCycleScrollView *cycleBannerView;
@property (weak, nonatomic) IBOutlet UIView *functionView;//功能菜单容器
@property (strong,nonatomic) UICollectionView *fuctionCollectionView;//功能菜单
@property (weak, nonatomic) IBOutlet UIView *noticeContainerView;//通知ViewBg，用于隐藏
@property (weak, nonatomic) IBOutlet UIImageView *noticeIconImageView;//通知图标
@property (weak, nonatomic) IBOutlet PAHomeNoticeLabel *noticeLabel;///通知显示
@property (weak, nonatomic) IBOutlet UITableView *activeTable;//Zaker新闻
@property (weak, nonatomic) IBOutlet UIView *signUpBgView;//签到按钮容器视图

@property (nonatomic, strong) PACarSpaceService * service;


///通知视图高度，用于隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_noticBgViewHeight;
///通顶部距离，用于隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_noticTop;
///contentView 约束高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_ContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionVConstraint;

@property (nonatomic,strong)NSMutableArray *dataSource;///首页展示图标
@property (nonatomic,strong)NSMutableArray *iconArray;///全部服务图标

///首页下方活动model
@property (nonatomic, strong) UserActivity *userActivityModel;
@property (nonatomic, strong) HomePropertyIconModel *homeIconModel;
@property (nonatomic, assign) BOOL isYES;

@end

@implementation HomTabVC

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self createCollectionView];
    [self createAlertShow];
    
    isHaveHouse = NO;
    shareSigninPopVC =  [SigninPopVC shareSigninPopVC];
    
    //判断是否显示悬浮提醒以及签到弹窗
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self getAlertData];
    _isYES = YES;
    
    [self isSignup];//判断是否签到
    
    [self topRefresh];
    
    @WeakObj(self)
    self.containerScrollView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak topRefresh];
    }];
    
#warning NewHome Test
    UIButton * newHome = [UIButton buttonWithType:UIButtonTypeCustom];
    [newHome setTitle:@"NEWHOME" forState:UIControlStateNormal];
    [self.view addSubview:newHome];
    newHome.backgroundColor = UIColor.blueColor;
    [newHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [newHome addTarget:self action:@selector(newHomeTest) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)newHomeTest{
    PAWaterScanViewController * newHome = [[PAWaterScanViewController alloc]init];
    newHome.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newHome animated:YES];
}

-(PACarSpaceService *)service
{
    if (!_service) {
        _service = [[PACarSpaceService alloc]init];
        _service.delegate = self;
    }
    return _service;
}

- (void)goCheck:(UIButton *)button {
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:11];
    if (view) {
        [view removeFromSuperview];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"needTheView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    SpeedyLockViewController *speedy = [[SpeedyLockViewController alloc]init];
    speedy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:speedy animated:YES];
}

/**
 获取签到设置
 */
-(void)getUserSiginInfo {
    
    [RaiN_NewSigninPresenter getUserSignsetWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                [userDefaults setObject:data[@"map"][@"issuspendremind"] forKey:[DataDealUitls getSetingKey:XuanfuBtn]];
                [userDefaults setObject:data[@"map"][@"isdailypopups"] forKey:[DataDealUitls getSetingKey:TankuangAlert]];
                [userDefaults synchronize];
                
            }else {
                
                [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:TankuangAlert]];
                [userDefaults setObject:@"0" forKey:[DataDealUitls getSetingKey:XuanfuBtn]];
                [userDefaults synchronize];
            }
            
            [self newSigninNet:NO];//获取用户签到详情
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置消息标记
    [self setBadges];
    
    self.tabBarController.tabBar.hidden = NO;
    
//    [TalkingData trackPageBegin:@"shouye"];
    
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    
    [self.NavigationTitleButton setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:appDlgt.userData.communityname forState:UIControlStateNormal];
    
    NSNumber *isNeedToRefresh = [UserDefaultsStorage getDataforKey:kHomeUIInfoNeedRefresh];
    
    if (isNeedToRefresh.boolValue) {
        
        
        [UserDefaultsStorage saveData:@NO forKey:kHomeUIInfoNeedRefresh];
        
        //======edit 2017-09-01===================
        //--------------UI初始化------------------------
        [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        [_activeTable setHidden:YES];
        _activeTable.alpha = 0;
        if (save_contentsize_h==0) {
            save_contentsize_h = _partOneView.frame.size.height;
        }
        
        _nsLay_ContentHeight.constant = 800;
        
        [UIView animateWithDuration:kHomeAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
        //--------------UI初始化------------------------
        [self topRefresh];
        [self topRefreshForInfo];
        
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"needTheView"] integerValue] != 1) {
        [self getUserSiginInfo];//获取用户签到设置并且保存
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self topRefreshForInfo];/** 数据权限刷新 */
    
    [self isSignup];//判断是否签到
    
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [shareSigninPopVC dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [TalkingData trackPageEnd:@"shouye"];
}

#pragma mark - Actions

-(void)jumpToLock:(id)sender{
    
    SpeedyLockViewController *speedy = [[SpeedyLockViewController alloc]init];
    speedy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:speedy animated:YES];
}

//弹窗点击马上好评
-(void)goToAppStore:(id)sender{
    
    alertBack.hidden = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:APP_URL]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NetWorks NSURLSessionVersionForRequst:request CompleteBlock:^(id  _Nullable data, ResultCode resultCode, NSError * _Nullable Error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                if (data) {
                    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"==%@",aString);
                    NSDictionary * jsonDic=[DataController dictionaryWithJsonData:data];
                    NSNumber * resultCount=[jsonDic objectForKey:@"resultCount"];
                    if (resultCount.integerValue==1) {
                        NSArray* infoArray = [jsonDic objectForKey:@"results"];
                        if (infoArray.count>0) {
                            {
                                NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
                                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                                UIApplication *application = [UIApplication sharedApplication];
                                [application openURL:[NSURL URLWithString:trackViewURL]];
                            }
                        }
                    }
                }
            }
            else
            {
                //[self showToastMsg:data Duration:5.0];
            }
        });
    }];
}
//弹窗点击去提意见按钮
-(void)opinion:(id)sender{
    
    alertBack.hidden = YES;
    
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            THCommitSuggestionsViewController *commitVC = [[THCommitSuggestionsViewController alloc]init];
            [self.navigationController pushViewController:commitVC animated:YES];
        }];
    }];
}

//弹窗点击以后再说按钮
-(void)lastTime:(id)sender{
    
    alertBack.hidden = YES;
}
//弹窗点击关闭按钮
-(void)tapClose:(id)sender{
    
    alertBack.hidden = YES;
}

-(void)joinBt:(id)sender{
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if (goToUrl.length > 0) {
        
        alertBack.hidden = YES;
        webVc.url = goToUrl;
        webVc.title = @"活动详情";
        webVc.isNoRefresh = YES;
        webVc.type = 5;
        webVc.shareTypes = 5;
        webVc.isGetCurrentTitle = YES;
        
        webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UserActivity *userModel = [[UserActivity alloc]init];
        userModel.gotourl = goToUrl;
        
        webVc.userActivityModel = userModel;
        
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

//社区公告点击事件
- (IBAction)btn_NoticeClike:(UIButton *)sender {
    
    AppDelegate * appDlt = GetAppDelegates;
    if(appDlt.userData.openmap!=nil)
    {
        NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
        if(flag==0)
        {
            [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
            return;
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
    NotificationVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
    [self.navigationController pushViewController:pmvc animated:YES];
}

//平安中国
-(IBAction)btn_Property:(UIButton *)sender {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    PeaceChinaVC *pVC = [sb instantiateViewControllerWithIdentifier:@"PeaceChinaVC"];
    [pVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:pVC animated:YES];
    pVC.navigationItem.title = appDlgt.userData.communityname;
    
}

//社区警务
- (IBAction)btn_PartyClike:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    if(appDlgt.userData.openmap!=nil)
    {
        NSInteger flag=[[appDlgt.userData.openmap objectForKey:@"police"] integerValue];
        if(flag==0)
        {
            [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
            return;
        }
    }
    
    if([appDlgt.userData.policeurl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@",appDlgt.userData.policeurl,appDlgt.userData.token];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@",appDlgt.userData.policeurl,appDlgt.userData.token];
    }
    
    webVc.type = 4;
    webVc.title = @"社区警务";
    webVc.isShowRightBtn = NO;
    webVc.isNoRefresh = YES;
    webVc.talkingName = SheQuJingWu;
    [self.navigationController pushViewController:webVc animated:YES];
}

//智能家居界面跳转
- (IBAction)btn_SmatHomeClike:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url=appDlgt.userData.homeintrourl;
    
    webVc.talkingName = ZhiNengJiaJu;
    webVc.title=@"智能家居";
    [self.navigationController pushViewController:webVc animated:YES];
}

//汽车管家
- (IBAction)btn_PensionClike:(UIButton *)sender {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = @"http://actives.usnoon.com/Actives/achtml/20170720/Explain.html";
    webVc.talkingName = QiCheGuanJia;
    webVc.title=@"汽车管家";
    [self.navigationController pushViewController:webVc animated:YES];
}

/**
 *  左事件处理（联系物业）
 *
 *  @param sender UIBarButtonItem
 */
- (IBAction)NavBtn_LeftClike:(UIBarButtonItem *)sender {
    
    ContactServiceVC * contactsVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
    [self.navigationController pushViewController:contactsVC animated:YES];
}
/**
 *  标题事件处理
 *
 *  @param sender UIBarButtonItem
 */
- (IBAction)NavBtn_TitleClike:(UIButton *)sender {
    NSLog(@"NavBtn_TitleClike=====切换小区");
    
    ChangAreaVC * areaVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
    [self.navigationController pushViewController:areaVC animated:YES];
}

-(void)jumpToZakerList:(UITapGestureRecognizer *)tap{
    
    FYLPageViewController * lsZVC = [[FYLPageViewController alloc]init];
    lsZVC.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:lsZVC animated:YES];
}

-(void)headerViewTouch:(UIGestureRecognizer *)tapGest
{
    [self gotoactiveListVC];
}
//签到悬浮按钮点击事件
- (IBAction)signUpClick:(id)sender {
    
    [self newSigninNet:YES];
}

// 跳转活动
-(void)gotoactiveListVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ActivityNews" bundle:nil];
    ActivitysVC  *pmvc       = [storyboard instantiateViewControllerWithIdentifier:@"ActivitysVC"];
    [self.navigationController pushViewController:pmvc animated:YES];
    
}
//跳转新闻
-(void)gotonewsWebVC
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.url = @"http://actives.usnoon.com/Actives/achtml/20170811/index.html";
    
    webVc.title=@"社区新闻";
    [self.navigationController pushViewController:webVc animated:YES];
}

//进入社区活动详情
- (void)toActivityAction:(UserActivity *)model {
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    
    NSLog(@"kCurrentVersion====%@",kCurrentVersion);
    
    if([model.gotourl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model.gotourl,appDlgt.userData.token,kCurrentVersion];
    }else{
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model.gotourl,appDlgt.userData.token,kCurrentVersion];
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"webVc.url===%@",webVc.url);
    
    webVc.type = 5;
    webVc.shareTypes = 5;
    webVc.userActivityModel = model;
    if (![XYString isBlankString:model.title]) {
        
        webVc.title = model.title;
        
    }else {
        
        webVc.title = @"活动详情";
    }
    webVc.isGetCurrentTitle = YES;
    
    webVc.talkingName = @"shequhuodong";
    
    [self.navigationController pushViewController:webVc animated:YES];
}

//跳转更多菜单页面
-(void)jumpToMoreMenuViewController
{
    PAMoreMenuViewController * paMoreViewController = [[PAMoreMenuViewController alloc]init];
    paMoreViewController.isHaveParking = isHaveParking;
    paMoreViewController.isHaveHouse = isHaveHouse;
    paMoreViewController.dataSource = self.iconArray;
    paMoreViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paMoreViewController animated:YES];
}
///跳转H5
-(void)jumpToWebViewWithURL:(NSString *)urlStr andTitle:(NSString *)title;
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    
    NSLog(@"kCurrentVersion====%@",kCurrentVersion);
    
    if([urlStr hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",urlStr,appDlgt.userData.token,kCurrentVersion];
    }else{
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",urlStr,appDlgt.userData.token,kCurrentVersion];
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"webVc.url===%@",webVc.url);
    webVc.type = 5;
    webVc.shareTypes = 5;
    
    if (![XYString isBlankString:title]) {
        webVc.title = title;
        
    }else {
        webVc.title = @"活动详情";
    }
    
    webVc.isGetCurrentTitle = YES;
    webVc.talkingName = @"shequhuodong";
    [self.navigationController pushViewController:webVc animated:YES];
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (bannerArray == nil||bannerArray.count==0 || [XYString isBlankString:[bannerArray[index] objectForKey:@"gotourl"]]) {
        return;
    }
    NSDictionary * dic=[bannerArray objectAtIndex:index];
    NSLog(@"活动===%@",dic);
    
    UserActivity *userModel = [[UserActivity alloc]init];
    userModel.picurl = [dic objectForKey:@"fileurl"];
    userModel.gotourl = [dic objectForKey:@"gotourl"];
    userModel.title = [dic objectForKey:@"title"];
    //    userModel.gototype = [dic objectForKey:@"gototype"];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    
    if([[dic objectForKey:@"gotourl"] hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",[dic objectForKey:@"gotourl"],appDlgt.userData.token,kCurrentVersion];
    }
    else if([[dic objectForKey:@"gotourl"] isEqualToString:@"certresi"]) {
        CommunityCertificationVC *certifi = [[CommunityCertificationVC alloc] init];
        certifi.pushType = @"1";
        certifi.fromType = 4;
        [certifi setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:certifi animated:YES];
        return;
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",[dic objectForKey:@"gotourl"],appDlgt.userData.token,kCurrentVersion];
        
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    webVc.type = 5;
    webVc.shareTypes = 5;
    
    webVc.userActivityModel = userModel;
    if (![XYString isBlankString:userModel.title]) {
        webVc.title = userModel.title;
    }else {
        webVc.title = @"活动详情";
    }
    webVc.isGetCurrentTitle = YES;
    
    webVc.talkingName = @"shequhuodong";
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - 初始化UI

-(void)initView {
    
    appDlgt = GetAppDelegates;
    
    //配置顶部社区名称
     [self.NavigationTitleButton setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:appDlgt.userData.communityname forState:UIControlStateNormal];
    
    //配置锁车按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"锁定icon"] forState:UIControlStateNormal];
    rightButton.sourceId = @"901000000002";
    
    [rightButton addTarget:self action:@selector(jumpToLock:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //社区公告通知栏
    [self.noticeIconImageView setImage:[UIImage imageNamed:@"首页_社区公告_公告"]];
    
    contentHeight = self.nsLay_ContentHeight.constant;
    _noticeIconImageView.contentMode=UIViewContentModeCenter;
    _noticeContainerView.hidden=YES;
    _nsLay_noticBgViewHeight.constant=0;
    _nsLay_noticTop.constant=0;
    
    //Zaker新闻列表
    [_activeTable setDelegate:self];
    [_activeTable setDataSource:self];
    [_activeTable registerNib:[UINib nibWithNibName:@"Ls_ActiveCell" bundle:nil] forCellReuseIdentifier:@"Ls_ActiveCell"];
    [_activeTable registerNib:[UINib nibWithNibName:@"ZakerNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZakerNewsTableViewCell"];
    _activeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_activeTable setScrollEnabled:NO];
    
    //Other
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [_activeTable setHidden:YES];
    _activeTable.alpha = 0;
    if (save_contentsize_h==0) {
        save_contentsize_h = _partOneView.frame.size.height;
    }
    
    _nsLay_ContentHeight.constant = 800;
    
    //配置滚动视图
    [self.bannerSV_Banner addSubview:self.cycleBannerView];
    
    [UIView animateWithDuration:kHomeAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.fuctionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 ,0,SCREEN_WIDTH - 20 , _functionVConstraint.constant) collectionViewLayout:viewFlowLayout];
    self.fuctionCollectionView.backgroundColor = [UIColor whiteColor];
    self.fuctionCollectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
    self.fuctionCollectionView.delegate = self;
    self.fuctionCollectionView.dataSource = self;
    [self.fuctionCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_functionView addSubview:self.fuctionCollectionView];
    self.fuctionCollectionView.alpha = 0;
}

- (void)createAlertShow {
    
    alertBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    alertBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    alertBack.userInteractionEnabled = YES;
    
    alertBack.hidden = YES;
    
    [self.tabBarController.view addSubview:alertBack];
    alertView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, UNIT_LENTH * 475)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.alpha = 1.0;
    alertView.center = CGPointMake(alertView.center.x, self.view.frame.size.height / 2);
    
    alertView.hidden = YES;
    
    [alertBack addSubview:alertView];
    
    UIButton *closeAlert = [[UIButton alloc]initWithFrame:CGRectMake(alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert.backgroundColor = [UIColor clearColor];
    [closeAlert setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeAlert];
    
    UIButton *lastTime = [[UIButton alloc]initWithFrame:CGRectMake(UNIT_LENTH * 50, alertView.frame.size.height - UNIT_LENTH * 90, alertView.frame.size.width - UNIT_LENTH * 50 * 2, UNIT_LENTH * 50)];
    lastTime.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [lastTime setTitle:@"以后再说" forState:UIControlStateNormal];
    [lastTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lastTime.titleLabel.font = [UIFont systemFontOfSize:15];
    [lastTime addTarget:self action:@selector(lastTime:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:lastTime];
    
    UIButton *opinion = [[UIButton alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x, alertView.frame.size.height - UNIT_LENTH * 190, lastTime.frame.size.width, lastTime.frame.size.height)];
    opinion.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [opinion setTitle:@"去提意见" forState:UIControlStateNormal];
    [opinion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    opinion.titleLabel.font = [UIFont systemFontOfSize:15];
    [opinion addTarget:self action:@selector(opinion:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:opinion];
    
    UIButton *goToAppStore = [[UIButton alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x, alertView.frame.size.height - UNIT_LENTH * 290, lastTime.frame.size.width, lastTime.frame.size.height)];
    goToAppStore.backgroundColor = RGBACOLOR(159, 30, 31, 1);
    [goToAppStore setTitle:@"马上好评" forState:UIControlStateNormal];
    [goToAppStore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goToAppStore.titleLabel.font = [UIFont systemFontOfSize:15];
    [goToAppStore addTarget:self action:@selector(goToAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:goToAppStore];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, (lastTime.frame.origin.y + opinion.frame.origin.y + opinion.frame.size.height) / 2, lastTime.frame.size.width + 10, 1)];
    line1.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, (opinion.frame.origin.y + goToAppStore.frame.origin.y + goToAppStore.frame.size.height) / 2, lastTime.frame.size.width + 10, 1)];
    line2.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, goToAppStore.frame.origin.y - UNIT_LENTH * 35, lastTime.frame.size.width + 10, 1)];
    line3.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView addSubview:line3];
    
    UILabel *alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, closeAlert.frame.origin.y + closeAlert.frame.size.height, alertView.frame.size.width, UNIT_LENTH * 70)];
    alertTitle.textColor = [UIColor blackColor];
    alertTitle.textAlignment = NSTextAlignmentCenter;
    alertTitle.text = @"您对平安社区满意吗？";
    alertTitle.font = [UIFont systemFontOfSize:17];
    
    [alertView addSubview:alertTitle];
    
    alertView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, UNIT_LENTH * 475)];
    alertView1.backgroundColor = [UIColor whiteColor];
    alertView1.alpha = 1.0;
    alertView1.center = CGPointMake(alertView.center.x, self.view.frame.size.height / 2);
    
    alertView1.hidden = YES;
    
    [alertBack addSubview:alertView1];
    
    UIButton *closeAlert1 = [[UIButton alloc]initWithFrame:CGRectMake(alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert1.tintColor = [UIColor redColor];
    [closeAlert1 setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert1 addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView1 addSubview:closeAlert1];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(lastTime.frame.origin.x - 5, closeAlert1.frame.origin.y + closeAlert1.frame.size.height + UNIT_LENTH * 30, lastTime.frame.size.width + 10, 1)];
    line4.backgroundColor = RGBACOLOR(142, 143, 144, 0.5);
    [alertView1 addSubview:line4];
    
    textLal = [[UILabel alloc]initWithFrame:CGRectMake(line4.frame.origin.x, line4.frame.origin.y + line4.frame.size.height + 10, line4.frame.size.width, alertView1.frame.size.height - line4.frame.origin.y - line4.frame.size.height + 20)];
    textLal.textColor = [UIColor blackColor];
    textLal.textAlignment = NSTextAlignmentLeft;
    textLal.font = [UIFont systemFontOfSize:13];
    
    [alertView1 addSubview:textLal];
    
    alertView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, UNIT_LENTH * 475)];
    alertView2.backgroundColor = [UIColor whiteColor];
    alertView2.alpha = 1.0;
    alertView2.center = CGPointMake(alertView.center.x, self.view.frame.size.height / 2);
    
    alertView2.hidden = YES;
    
    [alertBack addSubview:alertView2];
    
    UIButton *closeAlert2 = [[UIButton alloc]initWithFrame:CGRectMake(alertView.frame.size.width - 5 - UNIT_LENTH * 50, 5, UNIT_LENTH * 50, UNIT_LENTH * 50)];
    closeAlert2.tintColor = [UIColor redColor];
    [closeAlert2 setImage: [UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
    
    [closeAlert2 addTarget:self action:@selector(tapClose:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView2 addSubview:closeAlert2];
    
    UIButton *laterBt = [[UIButton alloc]initWithFrame:CGRectMake(UNIT_LENTH * 20, alertView.frame.size.height - UNIT_LENTH * 90, (alertView.frame.size.width - UNIT_LENTH * 20 * 4) / 2 , UNIT_LENTH * 50)];
    laterBt.backgroundColor = RGBACOLOR(142, 143, 144, 1);
    [laterBt setTitle:@"以后再说" forState:UIControlStateNormal];
    [laterBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    laterBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [laterBt addTarget:self action:@selector(lastTime:) forControlEvents:UIControlEventTouchUpInside];
    [alertView2 addSubview:laterBt];
    
    joinBt = [[UIButton alloc]initWithFrame:CGRectMake(laterBt.frame.origin.x + laterBt.frame.size.width + 2 * UNIT_LENTH * 20, laterBt.frame.origin.y, laterBt.frame.size.width , laterBt.frame.size.height)];
    joinBt.backgroundColor = UIColorFromRGB(0x9f1e1f);
    [joinBt setTitle:@"马上参加" forState:UIControlStateNormal];
    [joinBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    joinBt.titleLabel.font = [UIFont systemFontOfSize:15];
    joinBt.userInteractionEnabled = NO;
    [joinBt addTarget:self action:@selector(joinBt:) forControlEvents:UIControlEventTouchUpInside];
    [alertView2 addSubview:joinBt];
    
    urlImg = [[UIImageView alloc]initWithFrame:CGRectMake(laterBt.frame.origin.x, closeAlert2.frame.origin.y + closeAlert2.frame.size.height + UNIT_LENTH * 30, alertView2.frame.size.width - 2 * UNIT_LENTH * 20, joinBt.frame.origin.y - closeAlert2.frame.origin.y - closeAlert2.frame.size.height - UNIT_LENTH * 60)];
    urlImg.backgroundColor = [UIColor clearColor];
    
    [alertView2 addSubview:urlImg];
}

-(SDCycleScrollView *)cycleBannerView{
    if (!_cycleBannerView) {
        _cycleBannerView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-20, (kScreenWidth-20)/2.2) imageNamesGroup:nil];
        _cycleBannerView.delegate = self;
        _cycleBannerView.autoScroll = NO;
        _cycleBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerView.placeholderImage = [UIImage imageNamed:@"图片加载失败@2x.png"];
    }
    return _cycleBannerView;
}

#pragma mark - Network

- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    if (!_iconArray) {
        
        _iconArray = [NSMutableArray array];
    }
    @WeakObj(self);
    [PropertyIcon getPropertyIconUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                
                NSDictionary *dict = (NSDictionary *)data;
                
                ////edit by ls 2018.4.10 取出返回数据整合到一个数组
                [_dataSource removeAllObjects];
                NSArray *dataArray = [dict objectForKey:@"list"];
                [_dataSource addObjectsFromArray:dataArray];
                [self mergeIconArray];
                ////edit by ls 2018.4.10
                
                ///判断是否有红包
                for (int i = 0; i < _dataSource.count; i++) {
                    if ([[_dataSource[i] objectForKey:@"key"] isEqualToString:@"shake"]) {
                        
                        isredenvelope=[[_dataSource[i] objectForKey:@"isredenvelope"] intValue];
                        
                        break;
                    }
                }
                
                ///将处理过的数据转模型
                NSArray *array = [HomePropertyIconModel mj_objectArrayWithKeyValuesArray:_dataSource];
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:array];
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    _fuctionCollectionView.alpha = 1;
                }];
                
                if(_dataSource.count>4){
                    
                    selfWeak.functionVConstraint.constant = 180;
                    [selfWeak.fuctionCollectionView setFrame:CGRectMake(0 ,0 ,SCREEN_WIDTH - 20 , _functionVConstraint.constant)];
                    
#warning mark - 当数组大于 8 个的时候需要将最后一个图标模型变成 显示全部服务样式
                    if(_dataSource.count>=7){
                        HomePropertyIconModel * homeModel = [[HomePropertyIconModel alloc]init];
                        homeModel.key = @"more";
                        [_dataSource insertObject:homeModel atIndex:7];
                    }
                    
                    
                }else{
                    
                    selfWeak.functionVConstraint.constant = 90;
                    [selfWeak.fuctionCollectionView setFrame:CGRectMake(0 ,0 ,SCREEN_WIDTH - 20 , _functionVConstraint.constant)];
                    
                    
                }
                [selfWeak.fuctionCollectionView reloadData];
                
            }else {
                
            }
            
        });
        
    }];
}

/**
 刷新数据UI
 */
-(void)topRefresh {
    
    //-------------UI相关类------------
    ///获取轮播图
    [self createDataSource];
    [self getBannerData];
    [self getBlueTouchData];
    [self getNotificData];
    
}
/**
 刷新数据data
 */
- (void)topRefreshForInfo {
    //-----------信息设置类--------------
    [self httpRequestForSettingInfos];//获得推送消息的设置
    [self getHomeAddress];//获得房产信息
    [self getParkingData];//获得车位信息
    [self getUserauthory];//获取用户权限
    //    [self getNewsData];
}

-(void)getActivityData {
    
    [HDActivityPresenter getTopactivitingList:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                
                NSArray * array=(NSArray *)data;
                activeArr = [UserActivity mj_objectArrayWithKeyValuesArray:array];
                
                [_activeTable reloadData];
                
                self.nsLay_ContentHeight.constant = save_contentsize_h;
                self.nsLay_ContentHeight.constant += _activeTable.contentSize.height;
                self.nsLay_ContentHeight.constant -= active_cell_h;
                self.nsLay_ContentHeight.constant += ((SCREEN_WIDTH - 320)*(SCREEN_WIDTH/320.0f));
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    
                    [_activeTable setHidden:NO];
                    _activeTable.alpha = 1;
                    
                    [self.view layoutIfNeeded];
                    
                }];
                
            }else {
                
                //self.nsLay_ContentHeight.constant -= 65;
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    [self.view layoutIfNeeded];
                }];
                
            }
            
            [self.containerScrollView.mj_header endRefreshing];
            
        });
    }];
}
///获取新闻数据
-(void)getNewsData
{
    NewsPresenter * nPresener=[NewsPresenter new];
    
    [nPresener getTopComNewsForType:@"1" page:@"1" upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSArray * array=(NSArray *)data;
                if(array!=nil&&array.count>0)
                {
                    newsDic = [array objectAtIndex:0];
                }else
                {
                    newsDic = nil;
                }
                
            }else
            {
                newsDic = nil;
            }
            
        });
    }];
    
}
///获取蓝牙设备权限数据
-(void)getBlueTouchData
{
    [CommunityManagerPresenters getUserBluetoothUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSArray *array=(NSArray *)data;
                if([data isKindOfClass:[NSArray class]])
                {
                    if(array==nil||array.count==0)
                    {
                        return ;
                    }
                    [UserDefaultsStorage saveData:array forKey:@"UserUnitKeyArray"];
                }
            }
            else
            {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *errmessage = data[@"errmsg"];
                    
                    [UserDefaultsStorage saveData:@[] forKey:@"UserUnitKeyArray"];
                    [UserDefaultsStorage saveData:errmessage forKey:@"Blue_errmessage"];
                }
            }
        });
        
    }];
}

///签到
-(void)getSignature {
    
    return;
    [UserPointAndMoneyPresenters isSignUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SignatureView * sv=[[SignatureView alloc]initWithFrame:self.view.frame];
            
            if(resultCode==SucceedCode)
            {
                [UserPointAndMoneyPresenters addSignLogUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(resultCode==SucceedCode)
                        {
                            NSDictionary * dic=(NSDictionary *)data;
                            NSString * srt = @"";
                            if (![XYString isBlankString:[[dic objectForKey:@"continuitydays"] stringValue]]) {
                                
                                if ([[dic objectForKey:@"continuitydays"] intValue] == 0) {
                                    srt=[NSString stringWithFormat:@"欢迎登录平安社区"];
                                }else {
                                    srt=[NSString stringWithFormat:@"已连续登录  %@日",[[dic objectForKey:@"continuitydays"] stringValue]];
                                }
                                
                            }else {
                                srt=[NSString stringWithFormat:@"欢迎登录平安社区"];
                            }
                            NSString * tmp=[NSString stringWithFormat:@"+%@分",[[dic objectForKey:@"integral"] stringValue]];
                            
                            sv.delegate = self;
                            
                            if (ispopjifen) {
                                
                                if(![XYString isBlankString:appDlgt.isupgrade]&&[appDlgt.isupgrade integerValue]==1)
                                {
                                    
                                    [sv showViewForText:srt Integral:tmp flag:1];
                                    
                                }else
                                {
                                    [sv showViewForText:srt Integral:tmp flag:0];
                                    
                                }
                            }
                            
                        }else
                        {
                            
                        }
                        
                    });
                    
                }];
            }
            else
            {
                NSLog(@"已签到！");
                if (ispopjifen) {
                    
                    if(![XYString isBlankString:appDlgt.isupgrade]&&[appDlgt.isupgrade integerValue]==1)
                    {
                        [sv showShengJi];
                        appDlgt.isupgrade = @"0";
                    }
                    
                    sv.delegate = self;
                }
            }
        });
        
    }];
}

-(void)getNotificData {
    
    [CommunityManagerPresenters getTopPropertyNoticeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                self.noticeContainerView.hidden=NO;
                _nsLay_noticBgViewHeight.constant=50;
                _nsLay_noticTop.constant=8;
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    
                    [self.view layoutIfNeeded];
                    
                }];
                
                notificArray=(NSArray *)data;
                if(notificArray!=nil&&notificArray.count>0) {
                    
                    [_noticeLabel setNotificArray:notificArray];
                }
                
            }else {
                
                self.noticeContainerView.hidden=YES;
                _nsLay_noticBgViewHeight.constant=0;
                _nsLay_noticTop.constant=0;
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    
                    [self.view layoutIfNeeded];
                    
                }];
            }
            
            [self getNewsForZakerData];
            [self setBadges];
            
        });
        
    }];
}

-(void)getNewsForZakerData {
    
    NewsPresenter * newsPresenter=[NewsPresenter new];
    [newsPresenter getZakerNewsForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                zakerNewsArr=(NSArray *)data;
                
                [_activeTable reloadData];
                self.nsLay_ContentHeight.constant = save_contentsize_h;
                self.nsLay_ContentHeight.constant += _activeTable.contentSize.height+10;
                self.nsLay_ContentHeight.constant -= active_cell_h;
                self.nsLay_ContentHeight.constant += ((SCREEN_WIDTH - 320)*(SCREEN_WIDTH/320.0f));
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    
                    [_activeTable setHidden:NO];
                    _activeTable.alpha = 1;
                    
                    [self.view layoutIfNeeded];
                    
                }];
                
            }else {
                
                self.nsLay_ContentHeight.constant = save_contentsize_h - 65;
                
                [UIView animateWithDuration:kHomeAnimationDuration animations:^{
                    [self.view layoutIfNeeded];
                }];
                
            }
            
            [self getActivityData];
        });
    }];
}


- (void)getUserauthory {
    [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSDictionary *dic = data[@"map"];
                NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
            }else {
                NSLog(@"");
            }
            
        });
    }];
}
///个人地址
-(void)getHomeAddress
{
    [CommunityManagerPresenters getUserResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSMutableArray * arr = [NSMutableArray arrayWithArray:data];
                if(arr!=nil||arr.count>0)//显示房产选择
                {
                    isHaveHouse = YES;
                }
                
            }else{
                
                isHaveHouse = NO;
            }
            
        });
        
    }];
}
///获取我的车位信息
-(void)getParkingData

{
    isHaveParking = NO;
    
    [self.service loadData];
    ParkingManagePresenter * parkingPresenter=[ParkingManagePresenter new];
    [parkingPresenter getUserParkingareaForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode){
                
                NSDictionary * parking=(NSDictionary *)data;
                NSArray * citylist=[parking objectForKey:@"list"];
                NSArray * listdata=[ParkingModel mj_objectArrayWithKeyValuesArray:citylist];
                if(listdata!=nil&&listdata.count>0)//显示车牌输入
                {
                    
                    isHaveParking = YES;
                }
            }
        });
    }];
}

//获取首页弹窗
-(void)getAlertData{
    
    ispopjifen = NO;
    
    [AppSystemSetPresenters getAlertUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSDictionary *map = (NSDictionary *)data;
                NSLog(@"%@",map);
                NSString *type = [NSString stringWithFormat:@"%@",map[@"type"]];
                if ([type isEqualToString:@"0"]){
                    
                    alertBack.hidden = NO;
                    alertView.hidden = NO;
                }else if ([type isEqualToString:@"1"]){
                    
                    alertBack.hidden = NO;
                    alertView1.hidden = NO;
                    textLal.text = [NSString stringWithFormat:@"%@",map[@"content"]];
                    [textLal setNumberOfLines:0];
                    [textLal sizeToFit];
                    
                    [alertView1 addSubview:textLal];
                    
                }else if ([type isEqualToString:@"2"]){
                    
                    alertBack.hidden = NO;
                    alertView2.hidden = NO;
                    
                    NSString *picUrl = [NSString stringWithFormat:@"%@",map[@"picurl"]];
                    NSURL *url = [NSURL URLWithString:picUrl];
                    [urlImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
                    goToUrl = [NSString stringWithFormat:@"%@",map[@"gotourl"]];
                    joinBt.userInteractionEnabled = YES;
                }else{
                    ///设置弹出没有弹出的情况 需要将积分弹框弹出
                    ispopjifen = YES;
                }
                
            }else{
                ispopjifen = YES;
            }
        });
    }];
}

//新车库获取车位接口
-(void)loadDataSuccess{
    
    if (self.service.personalCarportArray.count>0&&self.service.personalCarportArray!=nil){
        isHaveParking = YES;
    }
}

- (void)httpRequestForSettingInfos {
    
    [YYNoticeSetPresent getAppMsgsetUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                AppNoticeSet *appNoticeSet = data;
                
                if ([appNoticeSet.shockopen isEqualToString:@"0"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseShakeOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }else {
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseShakeOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
                if ([appNoticeSet.voiceopen isEqualToString:@"0"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }else {
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
                if ([appNoticeSet.carremind isEqualToString:@"0"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kAlertSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }else {
                    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kAlertSoundOrNot];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
            }
        });
    }];
}
// 获取轮播图数据
-(void)getBannerData {
    
    [AppSystemSetPresenters getBannerUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            bannerArray = nil;
            
            if(resultCode==SucceedCode)
            {
                bannerArray=(NSArray *)data;
                NSURL *url;
                NSDictionary * dic;
                NSMutableArray *urlArray = [NSMutableArray array];
                if (bannerArray.count > 0) {
                    for(int i=0;i<bannerArray.count;i++){
                        dic=[bannerArray objectAtIndex:i];
                        url = [NSURL URLWithString:[dic objectForKey:@"fileurl"]];
                        [urlArray addObject:url];
                    }
                    if (bannerArray.count>1) {
                        self.cycleBannerView.autoScroll = YES;
                    }
                    self.cycleBannerView.imageURLStringsGroup = urlArray;
                }else{
                    NSArray *images = @[
                                        @"社区轮播图@2x.png",
                                        ];
                    self.cycleBannerView.autoScroll = NO;
                    self.cycleBannerView.localizationImageNamesGroup = images;
                }
            }else{
                NSArray *images = @[
                                    @"社区轮播图@2x.png",
                                    ];
                self.cycleBannerView.autoScroll = NO;
                self.cycleBannerView.localizationImageNamesGroup = images;
            }
        });
    }];
}

- (void)newSigninNet:(BOOL)isClick {
    
    @WeakObj(self);
    @WeakObj(shareSigninPopVC);
    [RaiN_NewSigninPresenter getUserSignWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                NSDictionary *dic = data[@"map"];
                NSString * isfirst = [dic objectForKey:@"isfirst"];
                
                if (isClick) {
                    isfirst = @"1";
                }
                if (isfirst.boolValue) {
                    
                    if ([dic[@"issign"] integerValue] == 0) {
                        //没签到
                        [userDefaults setObject:@"0" forKey:@"isSignup"];//设置签到状态为0
                        NSString * str = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:[DataDealUitls getSetingKey:TankuangAlert]]];
                        
                        if ([XYString isBlankString:[userDefaults objectForKey:[DataDealUitls getSetingKey:TankuangAlert]]] || ![str isEqualToString:@"0"]) {
                            
                            
                            shareSigninPopVCWeak.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                
                                
                                NSNumber * datanum = data;
                                NSLog(@"__%d___",datanum.boolValue);
                                if (datanum.boolValue==NO) {
                                    [userDefaults setObject:@"1" forKey:@"isSignup"];//设置签到状态为1
                                    [userDefaults synchronize];
                                    [selfWeak.signUpBgView setHidden:YES];
                                }
                                
                            };
                            [shareSigninPopVCWeak showInVC:self with:dic];
                        }
                        
                    }else {
                        //已签到
                        [userDefaults setObject:@"1" forKey:@"isSignup"];//设置签到状态为1
                        [userDefaults synchronize];
                        selfWeak.signUpBgView.hidden = YES;
                        
                    }
                    
                }else {
                    
                    if ([dic[@"issign"] integerValue] == 0) {
                        //没签到
                        [userDefaults setObject:@"0" forKey:@"isSignup"];//设置签到状态为0
                    }else {
                        [userDefaults setObject:@"1" forKey:@"isSignup"];//设置签到状态为0
                    }
                    NSLog(@"第N次登录");
                }
                [selfWeak isSignup];//判断是否签到
            }else {
                selfWeak.signUpBgView.hidden = YES;
            }
        });
    }];
}

/**
 跳转认证页
 */
- (void)goToCertification {
    
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                
                if (houseArr.count > 0) {
                    
                    //---有房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                    houseListVC.fromType = 5;
                    houseListVC.houseArr = houseArr;
                    houseListVC.carArr = carArr;
                    houseListVC.communityID = appDlgt.userData.communityid;
                    houseListVC.communityName = appDlgt.userData.communityname;
                    [houseListVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:houseListVC animated:YES];
                    
                }else {
                    
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.fromType = 5;
                    addVC.communityID = appDlgt.userData.communityid;
                    addVC.communityName = appDlgt.userData.communityname;
                    [addVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
}

#pragma mark - UICollectionViewDataSource

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-20)/4.0f,80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count<8 ? _dataSource.count : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NibCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    HomePropertyIconModel *homeIconModel = _dataSource[indexPath.row];
    cell.textLabel.text = @"";
    cell.iconImage.image = [UIImage imageNamed:@""];
    cell.iconImage.image = [UIImage imageNamed:@""];
    cell.sourceId = homeIconModel.keynum;//控制权限的资源ID
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:homeIconModel.picurl] placeholderImage:[UIImage imageNamed:@"homepage_button_none_n"]];
    cell.textLabel.text  = homeIconModel.title;
    if([homeIconModel.key isEqualToString:@"shake"]) {
        
        if (isredenvelope == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"homepage_button_yytxhd_n"];
            [cell startAnimation];
        }else {
            cell.iconImage.image = [UIImage imageNamed:@"homepage_button_yytx_n"];
        }
        
    }else if ([homeIconModel.key isEqualToString:@"more"]){
        
        cell.iconImage.image = [UIImage imageNamed:@"homepage_button_more_n"];
        cell.textLabel.text  = @"全部服务";
    }
    
    return cell;
}

#pragma mark - Collection Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePropertyIconModel *homeIconModel = _dataSource[indexPath.row];
    if ([homeIconModel.key isEqualToString:@"car"]) {
        
        /**
         * 智能车库
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap != nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procar"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
            }
            
        }
        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        IntelligentGarageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    } else if ([homeIconModel.key isEqualToString:@"shake"]) {
        
        [self getUserauthory];
        /**
         * 摇摇通行
         **/
        NSString *resipower = [UserDefaultsStorage getDataforKey:@"resipower"];
        if ([resipower integerValue] == 1) {
            NSArray * blueTooths = (NSArray *)[UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
            if (blueTooths.count==0||blueTooths==nil) {
                
                NSString * blueErrmessage = (NSString *)[UserDefaultsStorage getDataforKey:@"Blue_errmessage"];
                if ([XYString isBlankString:blueErrmessage]) {
                    
                    [self showToastMsg:@"请联系物业开通摇一摇通行服务" Duration:3.f];
                }else{
                    
                    [self showToastMsg:blueErrmessage Duration:3.f];
                }
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                ShakePassageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"ShakePassageVC"];
                pmvc.isStart=YES;
                pmvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pmvc animated:YES];
            }
            
        }else {
            
            
            [self certificationPopupType:resipower.integerValue];
            
        }
        
    } else if ([homeIconModel.key isEqualToString:@"traffic"]) {
        
        /**
         * 访客通行
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap!=nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"protraffic"] integerValue];
            if(flag==0){
                
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
                
            }
        }
        
        if(!isHaveParking&&!isHaveHouse) {
            
            MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
            msgAlert.isHiddLeftBtn = YES;
            [msgAlert showInVC:self withTitle:@"您所在小区没有房产和可使用的车位，没有权限邀请访客哦~" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
            return;
            
            
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            VisitorVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"VisitorVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
        
        
    }else if ([homeIconModel.key isEqualToString:@"reserve"]) {
        
        /**
         * 在线报修
         **/
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    NSDictionary *dic = data[@"map"];
                    
                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                    [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                    
                    if ([resipower integerValue] == 0||[resipower integerValue] == 9) {
                        
                        [self certificationPopupType:resipower.integerValue];
                        
                    }else {
                        ///认证
                        AppDelegate * appDlt=GetAppDelegates;
                        if(appDlt.userData.openmap!=nil)
                        {
                            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"proreserve"] integerValue];
                            if(flag==0)
                            {
                                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                                return;
                            }
                        }
                        
                        RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                        newOnline.hidesBottomBarWhenPushed = YES;
                        newOnline.isFormMy = @"0";
                        [self.navigationController pushViewController:newOnline animated:YES];
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0f];
                }
            });
        }];
        
    }else if ([homeIconModel.key isEqualToString:@"complaint"]) {
        
        /*
         *建议投诉
         **/
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    NSDictionary *dic = data[@"map"];
                    
                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                    [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                    if ([resipower integerValue] == 0||[resipower integerValue]==9) {
                        
                        [self certificationPopupType:resipower.integerValue];
                        
                    }else {
                        ///认证
                        AppDelegate * appDlt=GetAppDelegates;
                        if(appDlt.userData.openmap!=nil)
                        {
                            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procomplaint"] integerValue];
                            if(flag==0)
                            {
                                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                                return;
                            }
                            
                        }
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        
                        SuggestionsVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"SuggestionsVC"];
                        [self.navigationController pushViewController:pmvc animated:YES];
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0f];
                }
                
            });
        }];
        
    }else if ([homeIconModel.key isEqualToString:@"notice"]) {
        
        /**
         * 社区公告
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap!=nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        NotificationVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    }else if([homeIconModel.key isEqualToString:@"water"]){
        
        PAWaterScanViewController * newHome = [[PAWaterScanViewController alloc]init];
        newHome.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newHome animated:YES];
        
    }else if([homeIconModel.key isEqualToString:@"bicycle"]) {
        
        if (kIsNewBikeList == 0) {
            
            /** 自行车管理 */
            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            L_NewBikeListViewController *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeListViewController"];
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }else {
            
            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            
            L_BikeGuardListVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_BikeGuardListVC"];
            pmvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }
        
    }else if([homeIconModel.key isEqualToString:@"more"]){
        
        [self jumpToMoreMenuViewController];
        
    }else {
        
        [self jumpToWebViewWithURL:homeIconModel.gotourl andTitle:homeIconModel.title];
        if (indexPath.item==self.dataSource.count-1) {
            
        }
        NSLog(@"error:not't find this");
    }
}

#pragma mark - TableView DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        if(zakerNewsArr.count == 0){
            
            return 0;
        }
    }else if(section == 1){
        
        if(activeArr.count == 0){
            
            return 0;
        }
    }
    return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return zakerNewsArr.count>3?3:zakerNewsArr.count;
    }
    return activeArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 90;
    }
    return  active_cell_h;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]init];
    [headerView setBackgroundColor:UIColorFromRGB(0XF1F1F1)];
    headerView.tag = section;
    UIView * g_lineV = [[UIView alloc]initWithFrame:CGRectMake(0,15,SCREEN_WIDTH,1)];
    [g_lineV setBackgroundColor:LINE_COLOR];
    
    UIView * r_lineV = [[UIView alloc]initWithFrame:CGRectMake(0,30,4,30)];
    r_lineV.layer.cornerRadius = 2.0f;
    [r_lineV setBackgroundColor:UIColorFromRGB(0xAB2121)];
    UILabel * titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:18.0f];
    [titleLb setFrame:CGRectMake(8,33,80,20)];
    
    [titleLb setTextColor:UIColorFromRGB(0x595353)];
    
    if (section == 0) {
        
        titleLb.text = @"热门新闻";
    }else{
        
        titleLb.text = @"社区活动";
    }
    
    UIImageView * imgV = [[UIImageView alloc]init];
    if (section == 0) {
        
        [imgV setFrame:CGRectMake(titleLb.frame.size.width+8,40,111 * 12 / 19,12)];
        [imgV setImage:[UIImage imageNamed:@"首页_热门新闻"]];
    }else{
        
        [imgV setFrame:CGRectMake(titleLb.frame.size.width+8,40,120,12)];
        [imgV setImage:[UIImage imageNamed:@"首页_社区活动e"]];
    }
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(SCREEN_WIDTH-10-70,28,60,30)];
    [moreBtn setTitleColor:UIColorFromRGB(0x595353) forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
    [moreBtn setEnabled:NO];
    
    [headerView addSubview:moreBtn];
    [headerView addSubview:imgV];
    [headerView addSubview:titleLb];
    [headerView addSubview:r_lineV];
    [headerView addSubview:g_lineV];
    
    if (section == 0) {
        
        UITapGestureRecognizer * headerTapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToZakerList:)];
        [headerView addGestureRecognizer:headerTapGest];
    }else{
        
        UITapGestureRecognizer * headerTapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTouch:)];
        [headerView addGestureRecognizer:headerTapGest];
    }
    
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        NSDictionary *dict = zakerNewsArr[indexPath.row];
        
        ZakerNewsTableViewCell * newsCell =  [tableView dequeueReusableCellWithIdentifier:@"ZakerNewsTableViewCell"];
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setNewsCell:dict cell:newsCell];
        return newsCell;
        
    }else{
        
        UserActivity * UAML = [activeArr objectAtIndex:indexPath.row];
        Ls_ActiveCell * activeCell =  [tableView dequeueReusableCellWithIdentifier:@"Ls_ActiveCell"];
        [self setCellModel:UAML withCell:activeCell];
        activeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return activeCell;
    }
    
}

-(void)setCellModel:(UserActivity *)UAML withCell:(Ls_ActiveCell *)cell {
    
    cell.activeLb.text = UAML.title;
    
    NSString *beginString = [UAML.begindate substringToIndex:10];
    NSString *endString = [UAML.enddate substringToIndex:10];
    
    beginString = [XYString NSDateToString:[XYString NSStringToDate:beginString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    endString = [XYString NSDateToString:[XYString NSStringToDate:endString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    NSInteger endtype=[UAML.endtype integerValue];
    if(endtype==0)
    {
        cell.endBtn.hidden=YES;
    }else
    {
        cell.endBtn.hidden=NO;
    }
    
    cell.timeLb.text = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:UAML.picurl] placeholderImage:PLACEHOLDER_IMAGE];
    
}

-(void)setNewsCell:(NSDictionary *)newDict cell:(ZakerNewsTableViewCell *)cell
{
    
    cell.titleLal.text   = [newDict objectForKey:@"title"];
    
    cell.timeLal.text = [DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:[newDict objectForKey:@"date"]]];
    
    cell.fromLal.text = [newDict objectForKey:@"author"];
    
    NSString * picStr = [newDict objectForKey:@"thumbnail_pic_m"];
    
    if(![XYString isBlankString:picStr])
    {
        [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"默认图"]];
    }else
    {
        [cell.logoImg setImage:[UIImage imageNamed:@"默认图"]];
    }
    newsUrl=[newsDic objectForKey:@"gotourl"];
    
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        //.//..........
        
        NSDictionary *dict = zakerNewsArr[indexPath.row];
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
        NSString * newsUrl = [NSString stringWithFormat:@"%@",dict[@"infourl"]];
        
        if([newsUrl hasSuffix:@".html"])
        {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@",newsUrl,appDlgt.userData.token];
        }
        else
        {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@",newsUrl,appDlgt.userData.token];
        }
        
        webVc.talkingName = @"xinwen";
        webVc.type = 10;
        webVc.isnoHaveQQ = 1;
        webVc.isNoRefresh = YES;
        webVc.isGetCurrentTitle = YES;
        webVc.isShowRightBtn = YES;
        
        UserActivity *userActivityModel = [[UserActivity alloc] init];
        userActivityModel.title = [XYString IsNotNull:dict[@"title"]];
        userActivityModel.content = @"点击查看全部内容";
        userActivityModel.gotourl = [XYString IsNotNull:[NSString stringWithFormat:@"%@",dict[@"infourl"]]];
        userActivityModel.picurl = [XYString isBlankString:dict[@"thumbnailpic"]] ? SHARE_LOGO_IMAGE : [NSString stringWithFormat:@"%@",dict[@"thumbnailpic"]];
        
        webVc.userActivityModel = userActivityModel;
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else{
        
        UserActivity * UA = [activeArr objectAtIndex:indexPath.row];
        [self toActivityAction:UA];
    }
}
#pragma mark - 推送消息
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [self setBadges];
}
///设置消息标记
-(void)setBadges {
    
    ///社区公告
    appDlgt.CommunityNotification = [NSString stringWithFormat:@"CommunityNotification%@%@",appDlgt.userData.userID,appDlgt.userData.communityid];
    ///社区新闻
    appDlgt.CommunityNews=[NSString stringWithFormat:@"CommunityNews%@%@",appDlgt.userData.communityid,appDlgt.userData.userID];
    ///社区活动
    appDlgt.CommunityActivitys=[NSString stringWithFormat:@"CommunityActivitys%@%@",appDlgt.userData.communityid,appDlgt.userData.userID];
    ///维修
    appDlgt.RepairMsg=[NSString stringWithFormat:@"RepairMsg%@%@",appDlgt.userData.communityid,appDlgt.userData.userID];
    ///投诉
    appDlgt.ComplainMsg=[NSString stringWithFormat:@"ComplainMsg%@%@",appDlgt.userData.communityid,appDlgt.userData.userID];
    
    PushMsgModel * pushMsg;
    [self.noticeIconImageView setImage:[UIImage imageNamed:@"首页_社区公告_公告"]];
    ///社区公告标记
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.CommunityNotification];
    if(pushMsg!=nil)
    {
        if([pushMsg.countMsg integerValue]>0)
        {
            [self.noticeIconImageView setImage:[UIImage imageNamed:@"首页_社区公告_有公告"]];
        }
        else
        {
            [self.noticeIconImageView setImage:[UIImage imageNamed:@"首页_社区公告_公告"]];
            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
        }
    }
    MainTabBars *tab=(MainTabBars *)self.tabBarController;
    [tab setTabBarBadges];
    
}

#pragma mark - 语音事件处理
/**
 *  语音识别点击事件
 *2.7.1与硬件交互
 智能家居：动作（打开、关闭、停止）+房间名称+设备名称
 智能车库：开锁、解锁
 智能门禁：开门
 2.7.2软件内部功能交互
 社区公告：语音发送“公告”，进入公告列表页
 在线报修：语音发送“报修”“维修”，进入在线报修页
 社区新闻：语音发送“新闻”，进入社区新闻主页面
 党建服务：语音发送“党建”，进入党建服务主页面
 房屋租售：语音发送“房屋租售”“房屋”“租房”“出租房屋”“买房”“卖房”“二手房”，进入房屋租售主页面
 车位租售：语音发送“车位租售”“车位”“租车位”“出租车位”“买车位”“卖车位”，进入车位租售主页面
 跳蚤市场：语音发送“跳蚤市场”“二手市场”“二手物品”，进入跳蚤市场主页面
 违章查询：语音发送“违章查询”，进入违章查询主页面
 周边：语音发送“附近花店”“周边花店”，进入周边主页并搜索“花店”关键字
 商城：语音发送“商城”“购物”“买XX”，进入商城主页并搜索“XX”关键字
 *  @param sender Button对象
 */
- (IBAction)btn_SpeechRecognitionClike:(UIButton *)sender{
    
    if (![self isUseMicrophone]) {
        return;
    }
    
    VoicePopVC * voiceVC=[VoicePopVC sharedVoicePopVC];
    [voiceVC ShowVoicePopVC:self.tabBarController voiceCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        [voiceVC dismissAlert];
        if(index==119)
        {
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            webVc.url=@"http://api.usnoon.com/apphtml/voiceHelp.html";
            webVc.title=@"语音帮助";
            [self.navigationController pushViewController:webVc animated:YES];
            return ;
        }
        NSLog(@"voiceString==========%@",data);
        NSString *hanziText = (NSString *)data;
        if ([hanziText length]) {
            NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                NSLog(@"pinyin: %@", ms);
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                NSLog(@"pinyin12121: %@", ms);
                if([ms hasPrefix:@"suo che"]||[ms hasPrefix:@"jie suo"])// 智能车库：锁车、解锁
                {
                    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                    IntelligentGarageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
                    [self.navigationController pushViewController:pmvc animated:YES];
                }
                else if ([ms hasPrefix:@"gong gao"]) {//社区公告：语音发送“公告”，进入公告列表页
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                    NotificationVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
                    [self.navigationController pushViewController:pmvc animated:YES];
                }
                if ([ms containsString:@"bao xiu"] ) {//在线报修：语音发送“报修”“维修”，进入在线报修页
                    
                    /**
                     * 在线报修
                     **/
                    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                    [indicator startAnimating:self.tabBarController];
                    [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        @WeakObj(self)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [indicator stopAnimating];
                            
                            if (resultCode == SucceedCode) {
                                
                                NSDictionary *dic = data[@"map"];
                                
                                NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                                [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                                
                                if ([resipower integerValue] == 0||[resipower integerValue]==9) {
                                    [self certificationPopupType:resipower.integerValue];
                                    
                                }else {
                                    ///认证
                                    AppDelegate * appDlt=GetAppDelegates;
                                    if(appDlt.userData.openmap!=nil)
                                    {
                                        NSInteger flag=[[appDlt.userData.openmap objectForKey:@"proreserve"] integerValue];
                                        if(flag==0)
                                        {
                                            [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                                            return;
                                        }
                                    }
                                    
                                    RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                                    newOnline.hidesBottomBarWhenPushed = YES;
                                    newOnline.isFormMy = @"0";
                                    [self.navigationController pushViewController:newOnline animated:YES];
                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0f];
                            }
                        });
                    }];
                    
                }
                // 社区新闻：语音发送“新闻”，进入社区新闻主页面
                else if ([ms containsString:@"xin wen"]||[ms containsString:@"zi xun"] ) {
                    
                    
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    if([appDlgt.userData.urlnewslist hasSuffix:@".html"])
                    {
                        webVc.url=[NSString stringWithFormat:@"%@?token=%@",appDlgt.userData.urlnewslist,appDlgt.userData.token];
                    }
                    else
                    {
                        webVc.url=[NSString stringWithFormat:@"%@&token=%@",appDlgt.userData.urlnewslist,appDlgt.userData.token];
                    }
                    
                    webVc.title=@"社区新闻";
                    [self.navigationController pushViewController:webVc animated:YES];
                }
                else if ([ms containsString:@"dang jian"])//党建服务：语音发送“党建”，进入党建服务主页面
                {
                    AppDelegate * appDlt=GetAppDelegates;
                    if(appDlt.userData.openmap!=nil)
                    {
                        NSInteger flag=[[appDlt.userData.openmap objectForKey:@"cmmparty"] integerValue];
                        if(flag==0)
                        {
                            [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
                            return;
                        }
                    }
                    
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    if([appDlgt.userData.partyurl hasSuffix:@".html"])
                    {
                        webVc.url=[NSString stringWithFormat:@"%@?token=%@",appDlgt.userData.partyurl,appDlgt.userData.token];
                    }
                    else
                    {
                        webVc.url=[NSString stringWithFormat:@"%@&token=%@",appDlgt.userData.partyurl,appDlgt.userData.token];
                    }
                    
                    webVc.title = @"党建服务";
                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }
                // 违章查询：语音发送“违章查询”，进入违章查询主页面
                else if ([ms containsString:@"wei zhang cha xun"] ) {
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    webVc.url=@"http://m.cheshouye.com/api/weizhang/";
                    webVc.title=@"车辆违章查询";
                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }
            }
        }
        
    }];
}


#pragma mark - 主页图标数组整合
-(void)mergeIconArray
{
    [_iconArray removeAllObjects];
    NSMutableArray * tempDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary * dic = obj;
        NSArray * arr = [dic objectForKey:@"list"];
        //全部服务升序
        NSArray *allResult = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            NSNumber * topsort2 = obj2[@"allsort"];
            NSNumber * topsort1 = obj1[@"allsort"];
            
            return [topsort1 compare:topsort2];
            
        }];
        NSMutableDictionary * iconItem = [[NSMutableDictionary alloc]initWithCapacity:0];
        [iconItem setObject:dic[@"classname"]?:@"" forKey:@"classname"];
        [iconItem setObject:allResult forKey:@"list"];
        [_iconArray addObject:iconItem];
        //分组数组整合到一个数组
        for (int i = 0; i<arr.count; i++) {
            
            [tempDataArr addObject:[arr objectAtIndex:i]];
        }
    }];
    
    //首页图标升序
    NSArray *topResult = [tempDataArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSNumber * topsort2 = obj2[@"topsort"];
        NSNumber * topsort1 = obj1[@"topsort"];
        
        return [topsort1 compare:topsort2];
        
    }];
    [tempDataArr removeAllObjects];
    [tempDataArr addObjectsFromArray:topResult];
    
    //整合后数组赋值
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:tempDataArr];
    
}
#pragma mark - 权限提示框 审核中 9 未认证 0

-(void)certificationPopupType:(NSInteger)type
{
    @WeakObj(self);
    if (type == 0) {
        
        ///未认证
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        
        [msgAlert showInVC:self withTitle:@"请先认证为本小区的业主，您才可以使用此功能" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            if (index==Ok_Type) {
                NSLog(@"---跳转认证");
                [selfWeak goToCertification];
            }
        };
        
    }else if (type == 9) {
        
        ///审核中
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        [msgAlert showInVC:self withTitle:@"当前社区已提交过认证，请耐心等待物业为您审核通过后即可正常使用" andCancelBtnTitle:@"" andOtherBtnTitle:@"去我的房产"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            if (index==Ok_Type) {
                NSLog(@"---跳转我的房产");
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                houseListVC.iscurrentVC = @"1";
                [selfWeak.navigationController pushViewController:houseListVC animated:YES];
            }
        };
    }
}

#pragma mark -

- (void)isSignup {
    
    NSString *isSignp = [userDefaults objectForKey:@"isSignup"];//是否签到 0否 1是
    
    if (![XYString isBlankString:isSignp] && [[NSString stringWithFormat:@"%@",isSignp] isEqualToString:@"0"]) {
        NSString *str = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:[DataDealUitls getSetingKey:XuanfuBtn]]];
        if ([str isEqualToString:@"0"]) {
            self.signUpBgView.hidden = YES;
        }else {
            self.signUpBgView.hidden = NO;
        }
    }else {
        ///已签到
        self.signUpBgView.hidden = YES;
    }
}

@end
