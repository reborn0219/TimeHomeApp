//
//  PANewHomeViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeViewController.h"
#import "PANewHomeService.h"
#import "PANewHomeBannerView.h"
#import "ZakerNewsTableViewCell.h"
#import "Ls_ActiveCell.h"
#import "PAHomeMenuCell.h"
#import "UserActivity.h"
#import "PANewHomeSectionHeaderView.h"
#import "WebViewVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PANewHomeNavigationTitleView.h"
#import "PANewHomeNoticeCell.h"
#import "PANewHomeAlertView.h"
#import "ChangAreaVC.h"
#import "SpeedyLockViewController.h"
#import "ContactServiceVC.h"
#import "FYLPageViewController.h"
#import "ActivitysVC.h"
#import "HomePropertyIconModel.h"
#import "IntelligentGarageVC.h"
#import "MessageAlert.h"
#import "ShakePassageVC.h"
#import "MessageAlert.h"
#import "RaiN_NewServiceTempVC.h"
#import "L_BikeGuardListVC.h"
#import "VisitorVC.h"
#import "L_CommunityAuthoryPresenters.h"
#import "SuggestionsVC.h"
#import "NotificationVC.h"
#import "L_NewBikeListViewController.h"
#import "PAMoreMenuViewController.h"
#import "L_NewMyHouseListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_CertifyHoustListViewController.h"
#import "HomeCentralMenuCell.h"
#import "PeaceChinaVC.h"
#import "VoicePopVC.h"
#import "PAWaterScanViewController.h"
#import "SigninPopVC.h"
#import "PANewSuggestViewController.h"
#import "PANewNoticeViewController.h"
#import "PANewHouseViewController.h"
#import "PAWebViewController.h"
#import "PANewNoticeViewController.h"
#import "PANewNoticeService.h"
@interface PANewHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)PANewHomeService * homeService;
@property (nonatomic, strong)UITableView * homeTableView;
@property (nonatomic, strong)PANewHomeBannerView * bannerView;
@property (nonatomic, strong)PANewHomeNavigationTitleView * navigationTitleView;
@property (nonatomic, strong)PANewHomeAlertView * alertView;
@property (nonatomic, assign)NSInteger networkCount;//并发数
@property (nonatomic, strong)UIButton * signUpView;//签到按钮
@property (nonatomic, strong)SigninPopVC * signInfoView;//签到详情
@property (nonatomic, strong)PANewNoticeService * noticeService;
@end

@implementation PANewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"社区";
    
    //初始化UI
    [self initView];
    [self initNavigationView];
    
    //初始化数据
    [self loadBasicsData];
    [self loadUserData];
    
    //初始化模块block集中回调
    [self subViewsCallback];
    
    // 监听网络并发数
    [self addObserver:self forKeyPath:@"networkCount" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    AppDelegate * delegate = GetAppDelegates;
    [self.navigationTitleView reloadNavigationTitle:delegate.userData.communityname];
    
    NSNumber *isNeedToRefresh = [UserDefaultsStorage getDataforKey:kHomeUIInfoNeedRefresh];
    // 根据用户状态判断是否需要刷新页面数据
    if (isNeedToRefresh.boolValue) {
        [UserDefaultsStorage saveData:@NO forKey:kHomeUIInfoNeedRefresh];
        [self loadUserData];
    }    
}

/**
 初始化主界面
 */
- (void)initView{
    [self.view addSubview:self.homeTableView];
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.homeTableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        self.networkCount = 5;
        [self loadUserData];
        [self loadBasicsData];
    }];
    
    // 增加Banner
    UIView * banner = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (kScreenWidth-20)/2.2+20)];
    banner.backgroundColor = UIColorHex(0xF1F1F1);
    self.homeTableView.tableHeaderView = banner;
    [banner addSubview:self.bannerView];
    //增加alert
    [self.view addSubview:self.alertView];
    
    //增加签到框
    [self.view addSubview:self.signUpView];
    [self.signUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-30);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
}


/**
 初始化navigationView
 */
- (void)initNavigationView{
    // navigationTitle
    self.navigationItem.titleView = self.navigationTitleView;
    // 联系物业
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"首页_联系物业"] style:UIBarButtonItemStyleDone target:self action:@selector(contactTenement)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //配置锁车按钮
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"锁定icon"] forState:UIControlStateNormal];
    rightButton.sourceId = @"901000000002";
    
    [rightButton addTarget:self action:@selector(jumpToLock:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

/**
 block 回调
 */
- (void)subViewsCallback{
    @WeakObj(self);
    //选择社区
    self.navigationTitleView.callback = ^(id  _Nullable data, ResultCode resultCode) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ChangAreaVC * areaVC=[storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
        [selfWeak.navigationController pushViewController:areaVC animated:YES];
    };
    //banner跳转
    self.bannerView.callback = ^(UIViewController *controller) {
        [selfWeak.navigationController pushViewController:controller animated:YES];
    };
    //弹框跳转
    self.alertView.callback = ^(UIViewController *controller) {
        [selfWeak.navigationController pushViewController:controller animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (SigninPopVC *)signInfoView{
    if (!_signInfoView) {
        _signInfoView = [SigninPopVC shareSigninPopVC];
    }
    return _signInfoView;
}
- (UIButton *)signUpView{
    if (!_signUpView) {
        _signUpView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUpView setImage:[UIImage imageNamed:@"签到钮"] forState:UIControlStateNormal];
        [_signUpView addTarget:self action:@selector(showSignUpCalender) forControlEvents:UIControlEventTouchUpInside];
        _signUpView.hidden = YES;
    }
    return _signUpView;
}
-(PANewHomeAlertView *)alertView{
    if (!_alertView) {
        _alertView = [[PANewHomeAlertView alloc]init];
    }
    return _alertView;
}

- (PANewHomeService *)homeService{
    if (!_homeService) {
        _homeService = [[PANewHomeService alloc]init];
    }
    return _homeService;
}
- (PANewNoticeService *)noticeService{
    if (!_noticeService) {
        _noticeService = [[PANewNoticeService alloc]init];
    }
    return _noticeService;
}
- (UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        //活动Cell
        [_homeTableView registerNib:[UINib nibWithNibName:@"Ls_ActiveCell" bundle:nil] forCellReuseIdentifier:@"Ls_ActiveCell"];
        //新闻Cell
        [_homeTableView registerNib:[UINib nibWithNibName:@"ZakerNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZakerNewsTableViewCell"];
        //menuCell
        [_homeTableView registerNib:[UINib nibWithNibName:@"PAHomeMenuCell" bundle:nil] forCellReuseIdentifier:@"PAHomeMenuCell"];
        //增加公告
        [_homeTableView registerNib:[UINib nibWithNibName:@"PANewHomeNoticeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PANewHomeNoticeCell"];
        //中控菜单
        [_homeTableView registerNib:[UINib nibWithNibName:@"HomeCentralMenuCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCentralMenuCell"];
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _homeTableView;
}
- (PANewHomeBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[PANewHomeBannerView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, (kScreenWidth-20)/2.2)];
    }
    return _bannerView;
}

- (PANewHomeNavigationTitleView *)navigationTitleView{
    
    if (!_navigationTitleView) {
        AppDelegate * delegate = GetAppDelegates;
        _navigationTitleView = [[PANewHomeNavigationTitleView alloc]initWithTitle:delegate.userData.communityname?:@""];
    }
    return _navigationTitleView;
}

#pragma mark -Actions

/**
 是否展示签到页面

 @param show yes
 */
- (void)showSignUpView:(BOOL)show{
    
    [self.homeService loadUserSignInfoSuccess:^(PABaseRequestService *service) {
        //当为第一次展示时 hidden为no
        // 获取主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.signUpView.hidden = self.homeService.isSignUp;
        });
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}

/**
 展示签到日历
 */
- (void)showSignUpCalender{
    [self.signInfoView showInVC:self with:self.homeService.signUpDic];
    @weakify(self);
    self.signInfoView.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        NSNumber * datanum = data;
            weak_self.signUpView.hidden = !datanum.boolValue;
    };
}
/**
 future 功能菜单跳转

 @param index index
 */
- (void)futureFunctionTouched:(NSInteger)index{
    AppDelegate * delegate = GetAppDelegates;
    if (index == 0) {
        PeaceChinaVC *pVC = [self viewControllerWithStoryboardName:@"HomeTab" identifier:@"PeaceChinaVC"];
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
        pVC.navigationItem.title = delegate.userData.communityname;
    } else if (index == 1){
        WebViewVC * webVC = [[WebViewVC alloc]initFromStoryboard];
        if(delegate.userData.openmap!=nil)  {
            NSInteger flag=[[delegate.userData.openmap objectForKey:@"police"] integerValue];
            if(flag==0) {
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
                return;
            }
        }
        if([delegate.userData.policeurl hasSuffix:@".html"]) {
            webVC.url=[NSString stringWithFormat:@"%@?token=%@",delegate.userData.policeurl,delegate.userData.token];
        } else {
            webVC.url=[NSString stringWithFormat:@"%@&token=%@",delegate.userData.policeurl,delegate.userData.token];
        }
        
        webVC.type = 4;
        webVC.title = @"社区警务";
        webVC.isShowRightBtn = NO;
        webVC.isNoRefresh = YES;
        webVC.talkingName = SheQuJingWu;
        [self.navigationController pushViewController:webVC animated:YES];
    } else if (index == 2){
        WebViewVC * webVC = [[WebViewVC alloc]initFromStoryboard];
        webVC.url=delegate.userData.homeintrourl;
        webVC.talkingName = ZhiNengJiaJu;
        webVC.title=@"智能家居";
        [self.navigationController pushViewController:webVC animated:YES];
    } else if(index == 3){
        WebViewVC * webVC = [[WebViewVC alloc]initFromStoryboard];
        webVC.url =  [NSString stringWithFormat:@"%@%@",kH5_SEVER_URL,kActivesCarHouseKeeperUrl];
        webVC.talkingName = QiCheGuanJia;
        webVC.title=@"汽车管家";
        [self.navigationController pushViewController:webVC animated:YES];
    } else{
        // 语音识别
        [self automaticSpeechRecognition];
    }
}

/**
 语音识别
 */
- (void)automaticSpeechRecognition{
    if (![self isUseMicrophone]) {
        return;
    }
    AppDelegate * delegte = GetAppDelegates;
    @weakify(self);
    VoicePopVC * voiceVC=[VoicePopVC sharedVoicePopVC];
    [voiceVC ShowVoicePopVC:self.tabBarController voiceCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        [voiceVC dismissAlert];
        
        VoiceDisposeType type = index;
        
        switch (type) {
            case VoiceMaintain:{
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                [self.homeService loadUserAuthDataSuccess:^(PABaseRequestService *service) {
                    [indicator stopAnimating];
                    if (weak_self.homeService.resipower==0||weak_self.homeService.resipower==9) {
                        [self certificationPopupType:weak_self.homeService.resipower];
                    } else {
                        //认证功能
                        if (delegte.userData.openmap) {
                            NSInteger flag = [delegte.userData.openmap[@"proreserve"] integerValue];
                            if (flag==0) {
                                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                                return;
                            }
                            RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                            newOnline.hidesBottomBarWhenPushed = YES;
                            newOnline.isFormMy = @"0";
                            [self.navigationController pushViewController:newOnline animated:YES];
                        }
                    }
                } failure:^(PABaseRequestService *service, NSString *errorMsg) {
                    
                }];
                
                break;
            }
            case VoiceNotice:{
                NotificationVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"NotificationVC"];
                [self.navigationController pushViewController:pmvc animated:YES];
                break;
            }
            case VoiceNews:{
                WebViewVC * webVc = [[WebViewVC alloc]initFromStoryboard];
                if([delegte.userData.urlnewslist hasSuffix:@".html"]) {
                    webVc.url=[NSString stringWithFormat:@"%@?token=%@",delegte.userData.urlnewslist,delegte.userData.token];
                } else {
                    webVc.url=[NSString stringWithFormat:@"%@&token=%@",delegte.userData.urlnewslist,delegte.userData.token];
                }
                
                webVc.title=@"社区新闻";
                [self.navigationController pushViewController:webVc animated:YES];

                break;
            }
            case VoiceBreakRules:{
                WebViewVC * webVC = [[WebViewVC alloc]initFromStoryboard];
                webVC.url=@"http://m.cheshouye.com/api/weizhang/";
                webVC.title=@"车辆违章查询";
                [self.navigationController pushViewController:webVC animated:YES];
                break;
            }
            case VoiceParking:{
                IntelligentGarageVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"IntelligentGarageVC"];
                [self.navigationController pushViewController:pmvc animated:YES];
                break;
            }
            case VoicePartyBuilding:{
                if(delegte.userData.openmap!=nil)
                {
                    NSInteger flag=[[delegte.userData.openmap objectForKey:@"cmmparty"] integerValue];
                    if(flag==0)
                    {
                        [self showToastMsg:@"您的社区暂未开通该服务" Duration:5];
                        return;
                    }
                }
                
                WebViewVC * webVc = [[WebViewVC alloc]initFromStoryboard];
                if([delegte.userData.partyurl hasSuffix:@".html"])
                {
                    webVc.url=[NSString stringWithFormat:@"%@?token=%@",delegte.userData.partyurl,delegte.userData.token];
                }
                else
                {
                    webVc.url=[NSString stringWithFormat:@"%@&token=%@",delegte.userData.partyurl,delegte.userData.token];
                }
                
                webVc.title = @"党建服务";
                [self.navigationController pushViewController:webVc animated:YES];
                break;
            }
            case VoiceHelp:{
                WebViewVC * webVc = [[WebViewVC alloc]initFromStoryboard];
                webVc.url = [NSString stringWithFormat:@"%@,%@",SERVER_URL,kVoiceSpeechRecognitionHelpUrl];
                webVc.title=@"语音帮助";
                [self.navigationController pushViewController:webVc animated:YES];

                break;
            }
                
            default:
                break;
        }
        
    }];

}
/**
 跳转认证页
 */
- (void)goToCertification {
    @weakify(self);
    AppDelegate * delegate = GetAppDelegates;
    THIndicatorVCStart
    [self.homeService loadWaitCertInfoWithCommunityId:nil success:^(PABaseRequestService *service) {
        THIndicatorVCStopAnimating
        if (weak_self.homeService.waitHouseArray.count>0) {
            L_CertifyHoustListViewController *houseListVC = [self viewControllerWithStoryboardName:@"CommunityCertify" identifier:@"L_CertifyHoustListViewController"];
            houseListVC.fromType = 5;
            houseListVC.houseArr = weak_self.homeService.waitHouseArray;
            houseListVC.carArr = weak_self.homeService.waitParkingArray;
            houseListVC.communityID = delegate.userData.communityid;
            houseListVC.communityName = delegate.userData.communityname;
            [houseListVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:houseListVC animated:YES];
        } else {
            L_AddHouseForCertifyCommunityVC *addVC = [self viewControllerWithStoryboardName:@"CommunityCertify" identifier:@"L_AddHouseForCertifyCommunityVC"];
            addVC.fromType = 5;
            addVC.communityID = delegate.userData.communityid;
            addVC.communityName = delegate.userData.communityname;
            [addVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:addVC animated:YES];
        }
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        THIndicatorVCStopAnimating
        [self showToastMsg:errorMsg Duration:3.0];
    }];
}


/**
 获取权限
 */
- (void)getUserauthory{
    
    [self.homeService loadUserAuthDataSuccess:^(PABaseRequestService *service) {
        
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}
-(void)certificationPopupType:(NSInteger)type {
    @WeakObj(self);
    if (type == 0) {
        ///未认证
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        
        [msgAlert showInVC:self withTitle:@"请先认证为本小区的业主，您才可以使用此功能" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
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
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
            if (index==Ok_Type) {
                NSLog(@"---跳转我的房产");
                L_NewMyHouseListViewController *houseListVC = [self viewControllerWithStoryboardName:@"CommunityCertify" identifier:@"L_NewMyHouseListViewController"];
                houseListVC.iscurrentVC = @"1";
                [selfWeak.navigationController pushViewController:houseListVC animated:YES];
            }
        };
    }
}

/**
 快速锁车

 @param sender sender description
 */
-(void)jumpToLock:(id)sender{
    SpeedyLockViewController *speedy = [[SpeedyLockViewController alloc]init];
    speedy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:speedy animated:YES];
}

/**
 联系物业
 */
- (void)contactTenement{
    ContactServiceVC * contactsVC = [self viewControllerWithStoryboardName:@"HomeTab" identifier:@"ContactServiceVC"];
    [self.navigationController pushViewController:contactsVC animated:YES];
}

/**
 collecitonView 跳转

 @param iconModel  HomePropertyIconModel
 */
- (void)collectionViewDidSelectedWithModel:(HomePropertyIconModel *)homeIconModel indexPath:(NSIndexPath *)indexPath{
    AppDelegate * delegate = GetAppDelegates;
    @weakify(self);
    if ([homeIconModel.key isEqualToString:@"car"]) {
        /**
         * 智能车库
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap != nil) {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procar"] integerValue];
            if(flag==0){
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
            }
        }
        IntelligentGarageVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"IntelligentGarageVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    }else if([homeIconModel.key isEqualToString:@"water"]){
        
        PAWaterScanViewController * newHome = [[PAWaterScanViewController alloc]init];
        newHome.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newHome animated:YES];
        
    }else if ([homeIconModel.key isEqualToString:@"shake"]) {
        
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
                ShakePassageVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"ShakePassageVC"];
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
        if(appDlt.userData.openmap!=nil) {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"protraffic"] integerValue];
            if(flag==0){
                
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
            }
        }
        
        if(!self.homeService.haveParking&&!self.homeService.haveHouse) {
            
            MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
            msgAlert.isHiddLeftBtn = YES;
            [msgAlert showInVC:self withTitle:@"您所在小区没有房产和可使用的车位，没有权限邀请访客哦~" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
            return;
            
        }else {
            
            VisitorVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"VisitorVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
        
    }else if ([homeIconModel.key isEqualToString:@"reserve"]) {
        
        /**
         * 在线报修
         **/
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
       
        [self.homeService loadUserAuthDataSuccess:^(PABaseRequestService *service) {
            [indicator stopAnimating];
            if (weak_self.homeService.resipower==0||weak_self.homeService.resipower==9) {
                [self certificationPopupType:weak_self.homeService.resipower];
            } else {
                //认证功能
                if (delegate.userData.openmap) {
                    NSInteger flag = [delegate.userData.openmap[@"proreserve"] integerValue];
                    if (flag==0) {
                        [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                        return;
                    }
                    RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                    newOnline.hidesBottomBarWhenPushed = YES;
                    newOnline.isFormMy = @"0";
                    [self.navigationController pushViewController:newOnline animated:YES];
                }
            }
        } failure:^(PABaseRequestService *service, NSString *errorMsg) {
            
        }];
        
    }else if ([homeIconModel.key isEqualToString:@"complaint"]) {
        
        /*
         *建议投诉
         **/
        
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        
        [self.homeService loadUserAuthDataSuccess:^(PABaseRequestService *service) {
            THIndicatorVCStopAnimating
            if (weak_self.homeService.resipower==0 || weak_self.homeService.resipower==9) {
                [self certificationPopupType:weak_self.homeService.resipower];
            } else{
                if (delegate.userData.openmap) {
                    NSInteger flag=[[delegate.userData.openmap objectForKey:@"procomplaint"] integerValue];
                    if(flag==0) {
                        [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                        return;
                    }
                    SuggestionsVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"SuggestionsVC"];
                    [self.navigationController pushViewController:pmvc animated:YES];
                }
            }
        } failure:^(PABaseRequestService *service, NSString *errorMsg) {
            THIndicatorVCStopAnimating
        }];
        
        
    }else if ([homeIconModel.key isEqualToString:@"notice"]) {
        
        /**
         * 社区公告
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap!=nil) {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
            if(flag==0) {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        NotificationVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"NotificationVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    }else if([homeIconModel.key isEqualToString:@"bicycle"]) {
        
        if (kIsNewBikeList == 0) {
            /** 自行车管理 */
            L_NewBikeListViewController *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"L_NewBikeListViewController"];
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }else {
            L_BikeGuardListVC *pmvc = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"L_BikeGuardListVC"];
            pmvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pmvc animated:YES];
        }
        
    }else if([homeIconModel.key isEqualToString:@"more"]){
        PAMoreMenuViewController * paMoreViewController = [[PAMoreMenuViewController alloc]init];
        paMoreViewController.isHaveParking = self.homeService.haveParking;
        paMoreViewController.isHaveHouse = self.homeService.haveHouse;
        paMoreViewController.dataSource = self.homeService.menuArray;
        paMoreViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:paMoreViewController animated:YES];
    }else if ([homeIconModel.key isEqualToString:@"newnotice"]){
        //新社区公告
        PANewNoticeViewController * notice = [[PANewNoticeViewController alloc]init];
        notice.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notice animated:YES];
        
    } else if ([homeIconModel.key isEqualToString:@"newcomplaint"]){
        //新投诉建议
        PANewSuggestViewController * suggest = [[PANewSuggestViewController alloc]init];
        suggest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:suggest animated:YES];
    } else if ([homeIconModel.key isEqualToString:@"myhouse"]){
        PANewHouseViewController * house = [[PANewHouseViewController alloc]init];
        house.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:house animated:YES];
    } else {
        NSString * urlStr = homeIconModel.gotourl;
        NSString * title = homeIconModel.title;
        AppDelegate * appDlgt = GetAppDelegates;
        WebViewVC * webVc = [[WebViewVC alloc]initFromStoryboard];
        webVc.isNoRefresh = YES;
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

}

#pragma mark - Request

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"networkCount"]) {
        NSLog(@"%@",change);
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *count = [numberFormatter stringFromNumber:[change objectForKey:@"new"]];
        if ([count isEqualToString:@"0"]) {
            [self.homeTableView.mj_header endRefreshing];
        }
    }
}

/**
 加载用户数据
 */
- (void)loadUserData{
    @WeakObj(self);
    [self.homeService loadSettingInfoSuccess:^(PABaseRequestService *service) {
        
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
    
    [self.homeService loadParkingDataSuccess:^(PABaseRequestService *service) {
    
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
    
    [self showSignUpView:YES];
    [self getUserauthory];
    AppDelegate * delegate = GetAppDelegates;
    [delegate getBlueTouchData];
}

/**
 加载基础数据
 */
- (void)loadBasicsData{
    @weakify(self);
    [self.homeService loadBannerSuccess:^(PABaseRequestService *service) {
        @strongify(self);
        [self.bannerView updateWithBannerArray:self.homeService.bannerArray];
        weak_self.networkCount-=1;
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        @strongify(self);
        [self.bannerView updateWithBannerArray:self.homeService.bannerArray];
        weak_self.networkCount-=1;

    }];

    [self.homeService loadNewsDataSuccess:^(PABaseRequestService *service) {
        [weak_self.homeTableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
        weak_self.networkCount-=1;

    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        weak_self.networkCount-=1;

    }];
    
    [self.homeService loadActivityDataSuccess:^(PABaseRequestService *service) {
        [weak_self.homeTableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        weak_self.networkCount-=1;
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        weak_self.networkCount-=1;
    }];
    
    [self.homeService loadMenuDataSuccess:^(PABaseRequestService *service) {
        [weak_self.homeTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        weak_self.networkCount-=1;

    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        weak_self.networkCount-=1;
    }];
    /*
    [self.noticeService loadNewNoticeListWithPage:1 success:^(PABaseRequestService *service) {
        [weak_self.homeTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        weak_self.networkCount-=1;

    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        weak_self.networkCount-=1;

    }];
     */
    
    [self.homeService loadNoticeSuccess:^(PABaseRequestService *service) {
        [weak_self.homeTableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        weak_self.networkCount-=1;
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        weak_self.networkCount-=1;
    }];
}

#pragma mark - TableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return self.homeService.newsArray.count >3?3:self.homeService.newsArray.count;
    }
    if (section == 4) {
        return self.homeService.activityArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 70;
    }
    if (section == 4 && self.homeService.activityArray.count!=0) {
        return 70;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3 || section == 4) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        PANewHomeSectionHeaderView * header = [[PANewHomeSectionHeaderView alloc]init];
        [headerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        header.showActivity = section== 4 ?YES:NO;
        
        header.callback = ^(id  _Nullable data, ResultCode resultCode) {
            if (section == 3) {
                // 更多新闻
                FYLPageViewController * lsZVC = [[FYLPageViewController alloc]init];
                lsZVC.hidesBottomBarWhenPushed  = YES;
                [self.navigationController pushViewController:lsZVC animated:YES];
            } else {
                //更多活动
                ActivitysVC  *pmvc = [self viewControllerWithStoryboardName:@"ActivityNews" identifier:@"ActivitysVC"];
                [self.navigationController pushViewController:pmvc animated:YES];
            }
        };
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1){
        return 60;
    }else if (indexPath.section == 2){
        return ((SCREEN_WIDTH-20-6)/2.0f)+16+6 ;
    } else if (indexPath.section == 4){
       return (SCREEN_WIDTH-20)/2.2+120.0f-3;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    if (indexPath.section == 0) {
        PAHomeMenuCell * menuCell = [tableView dequeueReusableCellWithIdentifier:@"PAHomeMenuCell"];
        menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        menuCell.menuArray = self.homeService.menuArray;
        menuCell.callback = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            [weak_self collectionViewDidSelectedWithModel:data indexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        };
        return menuCell;
        
    } else if (indexPath.section == 1){
        PANewHomeNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PANewHomeNoticeCell"];
        cell.sourceId = @"906000000000";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setNotificArray:self.homeService.noticeArray];
        return cell;
    }else if(indexPath.section == 2){
        HomeCentralMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCentralMenuCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.block = ^(NSInteger index) {
            [weak_self futureFunctionTouched:index];
        };
        return cell;
    }else if (indexPath.section==3){
        
        ZakerNewsTableViewCell * newsCell =  [tableView dequeueReusableCellWithIdentifier:@"ZakerNewsTableViewCell"];
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        newsCell.newsModel = self.homeService.newsArray[indexPath.row];
        return newsCell;
    }else if(indexPath.section == 4){
        Ls_ActiveCell * activeCell =  [tableView dequeueReusableCellWithIdentifier:@"Ls_ActiveCell"];
        activeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        activeCell.activity = self.homeService.activityArray[indexPath.row];
        return activeCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        // 跳转新闻详情页
        PANewHomeNewsModel * news = self.homeService.newsArray[indexPath.row];
        WebViewVC * webVC = [[WebViewVC alloc]initFromStoryboard];
        NSString * newsUrl = [NSString stringWithFormat:@"%@",news.infourl];
        AppDelegate * delegate = GetAppDelegates;

        if([newsUrl hasSuffix:@".html"]){
            webVC.url=[NSString stringWithFormat:@"%@?token=%@",newsUrl,delegate.userData.token];
        } else {
            webVC.url=[NSString stringWithFormat:@"%@&token=%@",newsUrl,delegate.userData.token];
        }
        webVC.talkingName = @"xinwen";
        webVC.type = 10;
        webVC.isnoHaveQQ = 1;
        webVC.isNoRefresh = YES;
        webVC.isGetCurrentTitle = YES;
        webVC.isShowRightBtn = YES;
        
        UserActivity *userActivityModel = [[UserActivity alloc] init];
        userActivityModel.title = news.title?:@"";
        userActivityModel.content = @"点击查看全部内容";
        userActivityModel.gotourl = news.infourl?:@"";
        userActivityModel.picurl = [XYString isBlankString:news.thumbnailpic] ? SHARE_LOGO_IMAGE : [NSString stringWithFormat:@"%@",news.thumbnailpic];
        webVC.userActivityModel = userActivityModel;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    } else if(indexPath.section == 4) {
        UserActivity * model = self.homeService.activityArray[indexPath.row];
        
        WebViewVC * webVc = [[WebViewVC alloc]initFromStoryboard];
        webVc.isNoRefresh = YES;
        AppDelegate * delegate = GetAppDelegates;
        if([model.gotourl hasSuffix:@".html"]) {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model.gotourl,delegate.userData.token,kCurrentVersion];
        }else{
            webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model.gotourl,delegate.userData.token,kCurrentVersion];
        }
        
        webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webVc.type = 5;
        webVc.shareTypes = 5;
        webVc.userActivityModel = model;
        webVc.title = [model.title isNotBlank]?model.title:@"活动详情";
        webVc.isGetCurrentTitle = YES;
        webVc.talkingName = @"shequhuodong";
        [self.navigationController pushViewController:webVc animated:YES];
    } else if (indexPath.section == 1){
        AppDelegate * appDlt = GetAppDelegates;
        if(appDlt.userData.openmap!=nil){
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
            if(flag==0){
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showErrorWithStatus:@"您的社区暂未开通该服务"];
                [SVProgressHUD dismissWithDelay:5.0];
                return;
            }
        }
        NotificationVC * notice = [self viewControllerWithStoryboardName:@"PropertyManagement" identifier:@"NotificationVC"];
        [self.navigationController pushViewController:notice animated:YES];
    }
}

@end
