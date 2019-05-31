
#import "BaseViewController.h"
#import "EncryptUtils.h"
#import "THMaskingView.h"
#import "NoviceViewModel.h"
#import "LoginVC.h"
#import "PushMsgModel.h"
#import "LogInPresenter.h"
#import "THMyInfoPresenter.h"
#import "AppSystemSetPresenters.h"
#import "AppDelegate+JPush.h"

#import "LS_PersonalNoticeVC.h"
#import "L_NewBikeInfoViewController.h"

#import "WebViewVC.h"
#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "AlertsListVC.h"
#import "ChatViewController.h"
#import "NotificationVC.h"
#import "ReviewDetailVC.h"
#import "ShakePassageVC.h"
#import "LoginVC.h"
#import "WebViewVC.h"

#import "L_MyMoneyViewController.h"
#import "L_MyPublishViewController.h"
#import "PraiseListVC.h"
#import <AVFoundation/AVFoundation.h>
#import "YYPlaySound.h"
#import "MessageAlert.h"

#import "UIImage+ImageRotate.h"

#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "CommunityManagerPresenters.h"
#import "L_MyGivenTicketsListViewController.h"

#import "L_MyExchangeListViewController.h"
#import "Ls_DataStatisticsPresenter.h"

#import "L_CarNumberErrorViewController.h"
#import "ScreenshotsView.h"//截图反馈view
#import "GraffitiViewController.h"//涂鸦页面
#import "L_CommunityAuthoryPresenters.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_NewMyHouseListViewController.h"
#import "MainTabBars.h"
#import "IntelligentGarageVC.h"

#import "CTMediator.h"
#import "CTMediator+PAParkingActions.h"
#import "AppDelegate+Route.h"
#import "PAParkingViewController.h"
#import "PANewNoticeViewController.h"
#import "PANewSuggestViewController.h"
#import "PASuggestDetailViewController.h"
#import "PAWebViewController.h"
#import "PANewNoticeURL.h"

@interface BaseViewController ()
{
    UIAlertView *logInAlert;
    /**
     *  新手引导图背景
     */
    UIButton *bgButton;
    NSInteger imageCount;
    NSArray *imageNames;
    NSArray *imageFrames;
    UIImageView *maskingView;
    ScreenshotsView *imgvPhoto;//截图View
}
@property (nonatomic, copy) YYPlaySound *yyObj;

@end

@implementation BaseViewController

@synthesize ls_typeStr;
@synthesize typesArr;
@synthesize saveKey;

/**
 *  显示新手引导图
 *
 *  @param imageNameArray 引导图片名字数组
 *  @param frameArray     引导图片位置数组（一张图片时可传空,传数组时若无特定位置可传 @"" 默认为全屏位置）,当为最后一张图时点击自动隐藏
 */
/*
 - (void)showMaskingViewArrays:(NSArray *)imageNameArray frameArray:(NSArray *)frameArray {
 
 //当前的版本号
 NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
 NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
 
 NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
 NSString *string1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
 //当本类名字或版本号不相同时，表示是第一次进来，调用此方法
 if (![string isEqualToString:NSStringFromClass([self class])] || ![currentVersion isEqualToString:string1]) {
 [[NSUserDefaults standardUserDefaults]setObject:NSStringFromClass([self class]) forKey:NSStringFromClass([self class])];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"currentVersion"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 UIWindow *window = [[UIApplication sharedApplication].delegate window];
 imageCount = imageNameArray.count;
 
 imageNames = [[NSArray alloc]init];
 imageNames = imageNameArray;
 
 imageFrames = [[NSArray alloc]init];
 imageFrames = frameArray;
 
 if (!bgButton) {
 bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
 bgButton.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
 bgButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
 [window addSubview:bgButton];
 }
 [bgButton addTarget:self action:@selector(hiddenMaskingView) forControlEvents:UIControlEventTouchUpInside];
 
 maskingView = [[UIImageView alloc]init];
 [bgButton addSubview:maskingView];
 maskingView.image = [UIImage imageNamed:imageNameArray[0]];
 maskingView.contentMode=UIViewContentModeScaleAspectFit;
 maskingView.frame = CGRectMake(0, 0, bgButton.frame.size.width, bgButton.frame.size.height);
 
 if (frameArray.count > 0) {
 if (![frameArray[0] isEqualToString:@""]) {
 CGRect frame=CGRectFromString(frameArray[0]);
 maskingView.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) ;
 }
 }
 
 }
 
 }
 
 - (void)hiddenMaskingView {
 imageCount --;
 if (imageCount == 0) {
 [UIView animateWithDuration:0.5 animations:^{
 bgButton.alpha = 0;
 } completion:^(BOOL finished) {
 bgButton.hidden = YES;
 }];
 }else {
 maskingView.image = [UIImage imageNamed:imageNames[imageNames.count - imageCount]];
 maskingView.contentMode=UIViewContentModeScaleAspectFit;
 if (imageFrames.count > 0) {
 if (![imageFrames[imageNames.count - imageCount] isEqualToString:@""]) {
 CGRect frame=CGRectFromString(imageFrames[imageNames.count - imageCount]);
 maskingView.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) ;
 }else {
 maskingView.frame = CGRectMake(0, 0, bgButton.frame.size.width, bgButton.frame.size.height);
 }
 }
 
 }
 
 }
 */
#pragma mark - 初始化消息类型

-(void)setMsgType
{
    AppDelegate * appDelegate = GetAppDelegates;
    ls_typeStr = @"0,2,4,5,6";
    
    typesArr = [[NSMutableArray alloc]initWithCapacity:0];
    saveKey = [NSString stringWithFormat:@"saveTypes_%@",appDelegate.userData.userID];
    NSString * saveTypes = [[NSUserDefaults standardUserDefaults]objectForKey:saveKey];
    if ([XYString isBlankString:saveTypes]) {
        [[NSUserDefaults standardUserDefaults]setObject:ls_typeStr forKey:saveKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else
    {
        ls_typeStr = saveTypes;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //----------新手引导图默认点击屏幕消失设置---------------------
    //[[MMPopupWindow sharedWindow] cacheWindow];
    //[MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    [self setMsgType];
    [self initViewBase];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    AppDelegate *appdeleGate = GetAppDelegates;
    if ([appdeleGate.iphoneType isEqualToString:@"iPhone X"]) {
        //        [self hiddeniPhoneXLine];
    }
}
- (void)hiddeniPhoneXLine {
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBarController.tabBar setBackgroundImage:img];
    [self.tabBarController.tabBar setShadowImage:img];
    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"---当前页面所在控制器：%@--",[self class]);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_Msg" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushMessages:) name:@"Notification_Msg" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"noticeToLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeToLogin) name:@"noticeToLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Notification_Parking" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoParkingViewController) name:@"Notification_Parking" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_NewNotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoNewNoticeViewController:) name:@"Notification_NewNotice" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_NewSuggest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoNewSuggestViewController:) name:@"Notification_NewSuggest" object:nil];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    ///无网络状态启动APP的时候 当有网络以后重新调用登录接口
    NSNumber * netState = [[NSUserDefaults standardUserDefaults]objectForKey:@"netState"];
    
    if (netState.boolValue==NO) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"netState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self noticeToLogin];
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_Msg" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeToLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Notification_Parking" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_NewNotice" object:nil];
     
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_NewSuggest" object:nil];
    
    //注册通知  截图反馈
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_Msg" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeToLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Notification_Parking" object:nil];
    
}


/**
 *  初始化
 */
-(void) initViewBase {
    
    self.isToakenNone=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    ///背景色
    [[UINavigationBar appearance] setBarTintColor:NABAR_COLOR];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage createImageWithColor:NABAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    ///左右item字体颜色
    [UINavigationBar appearance].tintColor = TITLE_TEXT_COLOR;
    
    //    ///标题字体颜色
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_TEXT_COLOR}];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : TITLE_TEXT_COLOR}];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


#pragma mark ------无数据或加载失败视图显示------
/**
 *  显示无数据或加载失改视图
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg     msg  显示无数据提示
 */
-(void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg eventCallBack:(ViewsEventBlock) callBack {
    
    if(self.nothingnessView==nil) {
        self.nothingnessView=[NothingnessView getInstanceView];
        self.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height));
    }
    self.nothingnessView.view_SubBg.hidden=YES;
    [self.view addSubview:self.nothingnessView];
    [self.view bringSubviewToFront:self.nothingnessView];
    self.nothingnessView.lab_Clues.text = [XYString IsNotNull:msg];
    self.nothingnessView.eventCallBack  = callBack;
    
    switch (type) {
        case NoContentTypeNetwork:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"链接失败，请检查网络"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-加载失败"]];
        }
            break;
        case NoContentTypeData:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"暂无数据"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-暂无数据"]];
            
        }
            break;
        case NoContentTypePublish:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"暂未发表"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无帖子"]];
            
        }
            break;
        case NoContentTypeBikeManager:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"二轮车管理--默认图标"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-二轮车无数据"]];
            
        }
            break;
        case NoContentTypeCarManager:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"车位详情_没有可管理的车位"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无车位"]];
            
        }
            break;
        case NoContentTypeCertify:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"业主认证--空视图"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-授予房产权限"]];
            
        }
            break;
            
        case NoContentTypeShopExchange:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"您还没有兑换任何商品图标"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-优惠券"]];
            
        }
            break;
        case NoContentTypeAttentionFriends:
        {
            //            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"还没有关注朋友图标"]];
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无新关注"]];
            
        }
            break;
        case NoContentTypeHouseManager:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无房产"]];
            
        }
            break;
        case NoContentTypeVisitors:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无访客"]];
            
        }
            break;
        case NoContentTypeCollections:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-无收藏"]];
            
        }
            break;
        case NoContentTypeSpeedyLock:
        {
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"新版-一键锁车无数据"]];
            
        }
            break;
        case NoAssociatedVehicle:{
            
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"clgl_img_kzt_n.png"]];
        }
            break;
        case NoNewNoticeData:{
             [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"tsjl_img_empty_n"]];
            break;
        }
        case NoNewHouseData:{
            [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"wdfc_img_empty_n"]];
            break;
        }
            
        default:
            break;
    }
}
/**
 *  显示无数据或加载失改视图有按钮和事件处理
 *
 *  @param NoContentType type 无数据占位图的类型
 *  @param msg      msg 显示无数据提示
 *  @param subMsg   subMsg 显示无数据子提示
 *  @param title    title 按钮文字
 *  @param callBack callBack 事件回调
 */
-(void)showNothingnessViewWithType:(NoContentType)type Msg:(NSString *)msg SubMsg:(NSString *) subMsg btnTitle:(NSString *)title eventCallBack:(ViewsEventBlock) callBack {
    
    [self showNothingnessViewWithType:type Msg:msg eventCallBack:callBack];
    self.nothingnessView.view_SubBg.hidden = NO;
    self.nothingnessView.lab_subClues.text = [XYString IsNotNull:subMsg];
    self.nothingnessView.lab_subClues.textAlignment = NSTextAlignmentCenter;
    [self.nothingnessView.btn_Go setTitle:title forState:UIControlStateNormal];
    if ([XYString isBlankString:title]) {
        self.nothingnessView.btn_Go.hidden = YES;
    }else {
        self.nothingnessView.btn_Go.hidden = NO;
    }
    
}

/**
 *  隐藏数据或加载失改视图
 */
-(void)hiddenNothingnessView
{
    [self.nothingnessView removeFromSuperview];
    self.nothingnessView = nil;
}




//------------------提示显示-----------------

///UIAlertView自动消失事件
- (void) dimissAlert:(UIAlertView *)alert {
    
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    
}

//显示UIAlertView消息提示并自动消失
- (void)showAlertMessage:(NSString *)message Duration:(float)duration{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5f];
}


/**
 显示消息提示并自动消失
 */
-(void)showToastMsg:(NSString *)message Duration:(float)duration {
    
    if ([XYString isBlankString:message]) {
        return;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView *showview = [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    
    label.frame = CGRectMake(10, 10, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0; //
    
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width)/2-10, SCREEN_HEIGHT/2-50, LabelSize.width+20, LabelSize.height+20);
    
    //    [UIView animateWithDuration:duration animations:^{
    //        showview.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        [showview removeFromSuperview];
    //    }];
    
    //    window.userInteractionEnabled = NO;
    
    // 第一步：将view宽高缩至无限小（点）
    showview.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                0.9, 0.9);
    [UIView animateWithDuration:0.2 animations:^{
        // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
        showview.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            // 第三步： 以动画的形式将view恢复至原始大小
            showview.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration / 2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                    showview.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                        showview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        
                    } completion:^(BOOL finished) {
                        
                        // 第三步： 移除
                        [showview removeFromSuperview];
                        
                        //                            window.userInteractionEnabled = YES;
                        
                    }];
                    
                }];
                
            });
            
        }];
        
    }];
    
}

//--------------处理通知消息-----------------

-(void)receivePushMessages:(NSNotification*) aNotification
{
    [self NotitficGoToVC:aNotification];
    
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"ls_isNewPush"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    NSDictionary * dic = aNotification.object;
    NSString * typestr_ls = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    
    if ([XYString isBlankString:@"type"]) {
        typestr_ls = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"cjson"] objectForKey:@"type"]];
    }
    NSInteger type = typestr_ls.integerValue;
    
    //90201 90202 90101
    ///0 系统通知 1 物业公告 2 个人消息 4帖子评论 5帖子赞 6活动通知  3聊天
    if(type==50001||type==50002||type==50003||type==10101||type==10102||type==10103||type==10104||type==50201
       ||type==50202||type==50209||type==50203||type==30311||type==30312||type==10107||type==10108||type==80001||type==80002||type==10113 ||type==10121 ||type==10122){
        
        typestr_ls = @"2";
        
    }else if(type==30492||type==30392||type==30999||type==30093||type==30092||type==30094||type==30091||type==10002||type==90201||type==90202||type==90101){
        
        typestr_ls = @"0";
        
    }else if(type==30002||type==30003||type==30006){
        
        typestr_ls = @"4";
        
    } else if(type==30001||type==30005){
        
        typestr_ls = @"5";
        
    } else if(type==20003){
        
        typestr_ls = @"6";
        
    }
    //    else if(type==20101||type==20102||type==20103||type==20104||type==20105||type==20201){
    //
    //        typestr_ls = @"1";
    //    }
    
    if (![XYString isBlankString:typestr_ls]) {
        
        [self setUpTheTypes:typestr_ls AddOrDelete:YES];
    }
    
    [self subReceivePushMessages:aNotification];
    
    
}

-(void)subReceivePushMessages:(NSNotification*) aNotification
{
    
}

#pragma mark - 报警声音
-(void)alertViewAction
{
    
    MessageAlert * msgAlert = [[MessageAlert alloc]init];
    msgAlert.isHiddLeftBtn = YES;
    [msgAlert showInVC:self withTitle:@"车辆防盗装置发出警报，请立即处理！" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
    @WeakObj(self);
    msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [selfWeak.yyObj stopAudioWithSystemSoundID:selfWeak.yyObj.thesoundID];
            
        });
    };
    
}

#pragma mark -///懒加载初始化YYPlaySound
-(YYPlaySound *)yyObj
{
    if (!_yyObj) {
        _yyObj = [[YYPlaySound alloc]init];
    }
    return _yyObj;
}

#pragma mark -//警报提示音
-(void)baojingVoice
{
    [self becomeFirstResponder];
    
    [self.yyObj playSoundWithResourceName:@"fangdaobaojing" ofType:@"wav" isRepeat:NO];
    [self alertViewAction];
}

#pragma mark - 极光透传消息

-(void) NotitficGoToVC:(NSNotification *)aNotification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserauthory];
        AppDelegate * appDlgt=GetAppDelegates;
        
        if(aNotification.object == nil)
        {
            return ;
        }
        
        /**
         *  判断是否已登录(未登陆或记住密码则返回) - 性别，小区为空跳转到完善资料界面
         */
        if(!(appDlgt.userData.isLogIn.boolValue && appDlgt.userData.sex.intValue != 0 && ![appDlgt.userData.communityid isEqualToString:@"0"] && ![XYString isBlankString:appDlgt.userData.communityid])) {
           // return;
        }
        
        NSDictionary *dic = [NullPointerUtils toDealWithNullPointer:(NSDictionary *)aNotification.object];
        /** 消息类型 */
        NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
        
        switch ([type integerValue]) {
                
            case 10001://10001	个人消息：你的账户被多次举报请不要再违规
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10002://后台为用户重置密码：您的账号密码已重置为此手机号的后六位，请使用登录
                //        case 10003://请下载时代社区App地址[下载地址],开启您的时代。账号为手机号，密码手机号后六位
                //            break;
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"0";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10101://获得车位权限：您已获得车位[车位名称]的使用权限
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10102://失去车位权限：您已失去车位[车位名称]的使用权限
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10103://获得房产权限：您已获得房产[门牌号]的操作权限
            {
                
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10104://失去房产权限：您已失去房产[门牌号]的操作权限
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10105://业主变更后台审核通过：您已通过XX小区的业主认证，去试试业主专享功能吧~
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"0";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 10106://业主变更审核不通过：您未通过XX小区的业主认证，请填写准确信息后再次提交申请
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"0";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
                
            case 10113://车牌纠错推送
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    if ([self isKindOfClass:[L_CarNumberErrorViewController class]]) {
                        [(L_CarNumberErrorViewController *)self secondBtnDidTouch];
                        return;
                    }
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CarError" bundle:nil];
                    L_CarNumberErrorViewController *carErrorVC = [sb instantiateViewControllerWithIdentifier:@"L_CarNumberErrorViewController"];
                    carErrorVC.isFromPush = YES;
                    carErrorVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:carErrorVC animated:YES];
                    
                    
                }
                
            }
                break;
                
            case 10121://社区认证审核成功 您在时代社区1栋2单元2908室的房产认证成功，恭喜您成为该社区的认证业主。 map{“id”:”123dfdf3er13df”,”state”:1}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    //我的房产
                    
                    if ([self isKindOfClass:[L_NewMyHouseListViewController class]]) {
                        
                        [(L_NewMyHouseListViewController *)self needRefreshData];
                        
                    }else {
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                        L_NewMyHouseListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                        houseListVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:houseListVC animated:YES];
                        
                    }
                    
                }
                
            }
                break;
            case 10122://社区认证审核失败 您在时代社区1栋2单元2908室的房产认证审核失败，失败原因：您提供的业主信息有误，房产信息不对。 map{“id”:”123dfdf3er13df”,”state”:2}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    //我的房产
                    
                    if ([self isKindOfClass:[L_NewMyHouseListViewController class]]) {
                        
                        [(L_NewMyHouseListViewController *)self needRefreshData];
                        
                    }else {
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                        L_NewMyHouseListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                        houseListVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:houseListVC animated:YES];
                        
                    }
                    
                }
                
            }
                break;
                
            case 60001://大赛：审核通过：恭喜，您上传的摄影大赛作品[作品名称]已经审核通过，作品编号XX
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 60002://大赛：未审核通过：非常遗憾，您上传的摄影大赛作品[作品名称]未审核通过
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
                /////-----------------------------以上跳个人消息----------------------------------
            case 20001://社区公告：[公告]公告标题 map:{“id”:”2323”,”gotourl”:”http://...”}
            {
                
                NSLog(@"-------%@-------",dic);
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        NSDictionary *map = [cjson objectForKey:@"map"];
                        NSString * communityid = [map objectForKey:@"communityid"];
                        
                        /** 切换小区数据提交 */
                        
                        NSLog(@"-------id=%@----map=%@---",communityid,map);
                        
                        if (![XYString isBlankString:communityid]) {
                            
                            [CommunityManagerPresenters changeCommunityCommunityid:communityid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                
                            }];
                        }
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        NotificationVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
                        pmvc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:pmvc animated:YES];
                        
                    }
                    
                }
                
            }
                
                break;
            case 20002://社区新闻：[新闻]新闻标题 map:{“id”:”2323”,”gotourl”:”http://...”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        NSDictionary * map=[cjson objectForKey:@"map"];
                        if([[map objectForKey:@"gotourl"] hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@",[map objectForKey:@"gotourl"],appDlgt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@",[map objectForKey:@"gotourl"],appDlgt.userData.token];
                        }
                        webVc.title=@"社区新闻";
                        webVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }
                    
                }
                
            }
                break;
            case 20003://社区活动：[活动]活动标题 map:{“id”:”2323”,”gotourl”:”http://...”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        NSDictionary * map=[cjson objectForKey:@"map"];
                        if([[map objectForKey:@"gotourl"] hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@",[map objectForKey:@"gotourl"],appDlgt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@",[map objectForKey:@"gotourl"],appDlgt.userData.token];
                        }
                        
                        webVc.title=@"社区活动";
                        webVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }
                    
                }
                
            }
                break;
            case 20101://物业已接收：XX物业已接收您的报修申请，正在分派维修人员 map:{“id”:”2323”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                    
                    //我的报修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    //                    subVC.isFromMy = @"0";
                    subVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    subVC.IdArray = aArray;
                    [self.navigationController pushViewController:subVC animated:YES];
                    
                }
                
            }
                break;
            case 20102://维修处理中：维修人员[姓名]正在处理您的报修  map:{“id”:”2323”,“visitlinkman”:”张三”,”visitlinkphone”:”1232323232”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                    
                    //我的报修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    subVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    subVC.IdArray=aArray;
                    [self.navigationController pushViewController:subVC animated:YES];
                    
                }
                
            }
                break;
            case 20103://物业驳回：您的报修因[驳回原因]被驳回，请完善信息后重新提交 map:{“id”:”2323”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                    
                    //我的报修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    //                    subVC.isFromMy = @"0";
                    subVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    subVC.IdArray=aArray;
                    
                    [self.navigationController pushViewController:subVC animated:YES];
                    
                }
                
            }
                break;
            case 20104://暂不维修：XX物业暂时无法处理你的报修申请 map:{“id”:”2323”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                    
                    //我的报修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    //                    subVC.isFromMy = @"0";
                    subVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    subVC.IdArray=aArray;
                    [self.navigationController pushViewController:subVC animated:YES];
                    
                }
                
            }
                break;
            case 20105://已完成 待评价：您的报修已处理完成，给个评价吧  map:{“id”:”2323”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                    //我的报修
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    //                    subVC.isFromMy = @"0";
                    subVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    subVC.IdArray=aArray;
                    [self.navigationController pushViewController:subVC animated:YES];
                    
                }
                
            }
                break;
            case 20201://投诉回复：您的投诉XX物业已回复 map:{“id”:”2323”}
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.ComplainMsg];
                    
                    //我的投诉
                    THMyComplainListViewController *complainVC = [[THMyComplainListViewController alloc]init];
                    complainVC.hidesBottomBarWhenPushed=YES;
                    NSArray *aArray=nil;
                    if(pushMsg.content!=nil)
                    {
                        aArray = [pushMsg.content componentsSeparatedByString:@","];
                    }
                    complainVC.IdArray=aArray;
                    [self.navigationController pushViewController:complainVC animated:YES];
                    
                }
                
            }
                break;
                
            case 20301://反馈回复
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    //系统消息列表
                    LS_PersonalNoticeVC * ls_pnVC = [[LS_PersonalNoticeVC alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"0";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
                
            case 30001:///点赞
            case 30002:///评论
            case 30003:///回复(已去掉，统一用评论的推送)
            case 30091:///帖子审核不通过
            case 30092:///帖子(删除)
            case 30999:///红包过期
            case 30292:///投票贴(投票时间结束)
            case 30311:///问答帖(收到奖励后推送)
            case 30312:///问答帖(采纳后推送)
            case 30392:///问答帖(奖励退回的推送)
            case 30093:///带红包帖子审核不通过推送
            case 30094:///用户禁言推送
            {
                [self InterfaceJump:dic withType:type];
            }
                break;
                
            case 30492:///房产贴(房产贴线上时间到期)
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    //我的发布
                    L_MyPublishViewController *myPublishVC = [[UIStoryboard storyboardWithName:@"MyTab" bundle:nil] instantiateViewControllerWithIdentifier:@"L_MyPublishViewController"];
                    myPublishVC.selectIndex = 2;
                    [myPublishVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:myPublishVC animated:YES];
                    
                }
                
            }
                break;
            case 30101:
                ///收到个人聊天消息：“昵称：内容” 滑动查看，最多显示两行 map:{“maxid”:1221,”userid”:”dsfd”,”userpic”:”http://...”,”nickname”:””,”msgtype”:”1”}
            {
                NSString * title=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sendtime"]];
                
                ///击点通知跳转到相应的界面
                
                if([appDlgt.pushMsgType isEqualToString:type]&&[appDlgt.pushMsgTime isEqualToString:title])
                {
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.ChatMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.ChatMsg];
                    }
                    
                    NSDictionary * map=[dic objectForKey:@"map"];
                    
                    if ([self isKindOfClass:[ChatViewController class]]) {
                        
                        if ([((ChatViewController *)self).ReceiveID isEqualToString:[map objectForKey:@"userid"]]) {
                            return;
                        }
                        
                    }
                    
                    ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
                    chatC.hidesBottomBarWhenPushed=YES;
                    chatC.navigationItem.title = @"";
                    chatC.ReceiveID = [map objectForKey:@"userid"];
                    chatC.chatterThumb = @"";
                    [self.navigationController pushViewController:chatC animated:YES];
                    
                }
                
            }
                break;
                
            case 50001://车辆锁定状态出库：车辆[车牌号]的防盗装置发出警报，请立即处理
            {
                
                if (![dic[@"isclick"] boolValue]) {/** 透传时收到消息 */
                    
                    [self baojingVoice];/** 报警 */
                    
                }else {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
                
            case 50201://个人消息：你的自行车疑似被盗
            {
                
                if (![dic[@"isclick"] boolValue]) {/** 透传时收到消息 */
                    
                    [self baojingVoice];/** 报警 */
                    
                }else {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        L_NewBikeInfoViewController *newInfo = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
                        newInfo.theID = [[cjson objectForKey:@"map"] objectForKey:@"bikeid"];
                        newInfo.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:newInfo animated:YES];
                        
                    }
                    
                }
                
            }
                break;
                
            case 50202://二轮车共享接口推送
            case 50203://二轮车定时锁车解锁修改接口推送
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        L_NewBikeInfoViewController *newInfo = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
                        newInfo.theID = [[cjson objectForKey:@"map"] objectForKey:@"bikeid"];
                        newInfo.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:newInfo animated:YES];
                        
                    }
                    
                }
                
            }
                break;
            case 50002://车辆出入库推送
            case 50003://车辆出入库推送
            {
                
                /*****************构建红包实体*****************/
                
                if ([dic[@"isclick"] boolValue]) {//应用关闭收到出入库消息
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    NSDictionary *mapDic = [cjson objectForKey:@"map"];
                    
                    NSString *userticketids = mapDic[@"userticketids"];
                    NSString *logoUrl = mapDic[@"logourl"];
                    NSString *bagType = mapDic[@"type"];
                    NSString *orderId = mapDic[@"orderid"];
                    
                    PARedBagModel *redBag = [PARedBagModel redBagWithUserticketids:userticketids];
                    redBag.logo = logoUrl;
                    redBag.type= [bagType integerValue];
                    redBag.orderid = orderId;
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    if(redBag){
                        
                        LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                        ls_pnVC.hidesBottomBarWhenPushed = YES;
                        ls_pnVC.type = @"2";
                        [self.navigationController pushViewController:ls_pnVC animated:YES];
                    }else{
                        
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        IntelligentGarageVC *detailvc = [storyBoard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
                        [self.navigationController pushViewController:detailvc animated:YES];
                    }
                    
                }else{//应用开启 收到出入库消息
                    
                    NSDictionary *mapDic = [dic objectForKey:@"map"];
                    
                    NSString *userticketids = mapDic[@"userticketids"];
                    NSString *logoUrl = mapDic[@"logourl"];
                    NSString *bagType = mapDic[@"type"];
                    NSString *orderId = mapDic[@"orderid"];
                    
                    PARedBagModel *redBag = [PARedBagModel redBagWithUserticketids:userticketids];
                    redBag.logo = logoUrl;
                    redBag.type= [bagType integerValue];
                    redBag.orderid = orderId;
                    
                    if(redBag){
                        [self showRedBag:redBag];
                    }
                }
            }
                
                break;
            case 50209://后台删除自行车
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    PushMsgModel *pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.PersonalMsg];
                    if(pushMsg!=nil)
                    {
                        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                        [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.PersonalMsg];
                    }
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    LS_PersonalNoticeVC  * ls_pnVC = [[LS_PersonalNoticeVC  alloc]init];
                    ls_pnVC.hidesBottomBarWhenPushed = YES;
                    ls_pnVC.type = @"2";
                    [self.navigationController pushViewController:ls_pnVC animated:YES];
                    
                }
                
            }
                break;
            case 70001://摇摇通行电梯操作
            {
                
            }
                break;
            case 80001://赠送票券推送
            case 80002://即将到期兑换券推送
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
        
                }
                
            }
                break;
                ////新增运营定制推送消息
            case 90101://跳转固定类型帖子详情推送
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    ///击点通知跳转到相应的界面
                    if(cjson)
                    {
                        
                        NSString *postid =   cjson[@"map"][@"urlkey"];
                        NSString *posttype = cjson[@"map"][@"posttype"];
                        NSString * pushid =  [NSString stringWithFormat:@"%@",cjson[@"map"][@"pushid"]];
                        
                        if (posttype.integerValue == 0) {//普通帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
                            normalDetailVC.postID = postid;
                            normalDetailVC.isFromCommentPush = YES;
                            normalDetailVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:normalDetailVC animated:YES];
                            
                        }
                        
                        if (posttype.integerValue == 4) {//房产车位帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
                            houseDetailVC.postID = postid;
                            houseDetailVC.isFromCommentPush = YES;
                            houseDetailVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseDetailVC animated:YES];
                            
                        }
                        
                        if (posttype.integerValue == 3) {//问答帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
                            qusetion.postID = postid;
                            qusetion.isFromCommentPush = YES;
                            qusetion.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:qusetion animated:YES];
                    
                            
                        }
                        
                        [self addPushTongJi:pushid];
                        
                    }
                    
                }
                
            }
                break;
                
            case 90201://跳转活动链接推送需要加token
            {
                
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        NSString * pushid =  [NSString stringWithFormat:@"%@",cjson[@"map"][@"pushid"]];
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        NSDictionary * map=[cjson objectForKey:@"map"];
                        
                        if([[map objectForKey:@"urlkey"] hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@",[map objectForKey:@"urlkey"],appDlgt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@",[map objectForKey:@"urlkey"],appDlgt.userData.token];
                        }
                        webVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        [self addPushTongJi:pushid];
                    }
                    
                }
                
            }
                break;
                
            case 90202://跳转外部链接推送不需要加token
            {
                if ([dic[@"isclick"] boolValue]) {
                    
                    appDlgt.pushMsgTime=@"";
                    appDlgt.pushMsgType=@"0";
                    
                    NSDictionary * cjson = [dic objectForKey:@"cjson"];
                    
                    if (cjson) {
                        
                        NSString * pushid = [NSString stringWithFormat:@"%@",cjson[@"map"][@"pushid"]];
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        NSDictionary * map =[cjson objectForKey:@"map"];
                        webVc.url = [map objectForKey:@"urlkey"];
                        webVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        [self addPushTongJi:pushid];
                        
                    }
                    
                }
            }

                //给未注册手机号添加车位
            case 200309:{
                break;
            }
                //给未注册手机号关联车牌号
            case 200310:{
                break;
            }

                
                break;
                
            default:
                break;
        }
        
    });
}


#pragma mark - 平安社区车位管理通知跳转

/**
 跳转至车位管理Controller

 @param dic 通知的notification.info
 @param type info.type
 */
- (void)pushInCarManagerViewControllerWithDic:(NSDictionary *)dic type:(NSString *)type{
    
}

#pragma mark - 平安社区2.2新增推送跳转
-(void)InterfaceJump:(NSDictionary *)dic withType:(NSString *)type {
    
    AppDelegate *appDlgt = GetAppDelegates;
    appDlgt.pushMsgTime=@"";
    appDlgt.pushMsgType=@"0";
    
    switch (type.integerValue) {
        case 30092:/** 帖子被后台操作员删除推送 */
        case 30094:/** 用户禁言推送 */
        {
            
        }
            break;
        case 30999:/** 红包过期 */
        case 30311:/** 问答帖(收到奖励后推送) */
        case 30392:/** 问答帖(奖励退回的推送) */
        case 30093:/** 带红包帖子审核不通过推送 */
        {
            
            if ([dic[@"isclick"] boolValue]) {
                
                NSDictionary * cjson = [dic objectForKey:@"cjson"];
                
                if (cjson) {
                    
                    NSString * mapType = [[cjson objectForKey:@"map"] objectForKey:@"rewardtype"];
                    
                    if (mapType.integerValue == 0) {
                        ///跳转余额
                        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
                        L_MyMoneyViewController *myMoneyVC = [sb instantiateViewControllerWithIdentifier:@"L_MyMoneyViewController"];
                        myMoneyVC.isFromPush = YES;
                        [myMoneyVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myMoneyVC animated:YES];
                        
                    }
                }
                
            }
            
        }
            break;
            //11.28增加推送点赞列表跳转
        case 30001:/** 点赞 */
        {
            
            if ([dic[@"isclick"] boolValue]) {
                
                NSDictionary * cjson = [dic objectForKey:@"cjson"];
                
                if (cjson) {
                    
                    NSString * gotourl = [[cjson objectForKey:@"map"] objectForKey:@"gotourl"];
                    
                    PraiseListVC * plVC = [[PraiseListVC alloc]init];
                    plVC.isFromPushMessage = YES;
                    plVC.urlString = gotourl;
                    plVC.postid =  [NSString stringWithFormat:@"%@",cjson[@"map"][@"postid"]];
                    plVC.praisecount = [NSString stringWithFormat:@"%@",cjson[@"map"][@"praisecount"]];
                    plVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:plVC animated:YES];
                    
                    NSString *postid = cjson[@"map"][@"postid"];
                    NSString *posttype = cjson[@"map"][@"posttype"];
                    
                    NSMutableArray*tempMarr =[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    
                    if (tempMarr.count > 0) {
                        
                        if (posttype.integerValue == 0) {//普通帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
                            normalDetailVC.postID = postid;
                            normalDetailVC.isFromCommentPush = YES;
                            
                            [tempMarr insertObject:normalDetailVC atIndex:tempMarr.count- 1];
                            
                            [self.navigationController setViewControllers:tempMarr animated:YES];
                            return;
                            
                        }
                        
                        if (posttype.integerValue == 4) {//房产车位帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
                            houseDetailVC.postID = postid;
                            houseDetailVC.isFromCommentPush = YES;
                            
                            [tempMarr insertObject:houseDetailVC atIndex:tempMarr.count- 1];
                            
                            [self.navigationController setViewControllers:tempMarr animated:YES];
                            return;
                        }
                        
                        if (posttype.integerValue == 3) {//问答帖
                            
                            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                            BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
                            qusetion.postID = postid;
                            qusetion.isFromCommentPush = YES;
                            
                            [tempMarr insertObject:qusetion atIndex:tempMarr.count- 1];
                            
                            [self.navigationController setViewControllers:tempMarr animated:YES];
                            return;
                        }
                    }
                    
                }
                
            }
            
        }
            break;
        case 30312:/** 问答帖(采纳后推送) */
        case 30002:/** 评论 */
        case 30091:/** 帖子审核不通过 */
        {
            
            if ([dic[@"isclick"] boolValue]) {
                
                NSDictionary * cjson = [dic objectForKey:@"cjson"];
                
                if (cjson) {
                    
                    NSString *postid = cjson[@"map"][@"postid"];
                    NSString *posttype = cjson[@"map"][@"posttype"];
                    
                    if (posttype.integerValue == 0) {//普通帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
                        normalDetailVC.postID = postid;
                        normalDetailVC.isFromCommentPush = YES;
                        normalDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:normalDetailVC animated:YES];
                        return;
                        
                    }
                    
                    if (posttype.integerValue == 4) {//房产车位帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
                        houseDetailVC.postID = postid;
                        houseDetailVC.isFromCommentPush = YES;
                        houseDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:houseDetailVC animated:YES];
                        
                        return;
                        
                    }
                    
                    if (posttype.integerValue == 3) {//问答帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
                        qusetion.postID = postid;
                        qusetion.isFromCommentPush = YES;
                        qusetion.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:qusetion animated:YES];
                        return;
                        
                    }
                    
                }
                
            }
            
        }
            
            break;
            
        default:
            break;
            
    }
    
}

#pragma mark - 相关权限判断

///--------------相机权限判断-----------
/**
 相机授权判断
 */
- (BOOL)canOpenCamera {
    
    __block BOOL isCanOpen = YES;
    
    /** 判断设备是否有摄像头 */
    [self isCameraAvailable];
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        // 用户明确地拒绝授权，或者相机设备无法访问
        [self showToastMsg:@"应用相机权限受限,请在设置中启用" Duration:3.0];
        isCanOpen = NO;
    }
    
    if (status == AVAuthorizationStatusNotDetermined) {
        
        // 许可对话没有出现，发起授权许可
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (granted) {
                    //第一次用户接受
                }else{
                    //用户拒绝
                    [self showToastMsg:@"应用相机权限受限,请在设置中启用" Duration:3.0];
                    isCanOpen = NO;
                }
                
            });
            
        }];
        
    }
    
    return isCanOpen;
}
// 判断设备是否有摄像头
- (void) isCameraAvailable{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showToastMsg:@"未检查到设备摄像头" Duration:3.0];
        return ;
    }
    
}

//----------------定位权限-------------------
- (BOOL)isUseLocation {
    
    BOOL isCanUse = NO;
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        isCanUse = YES;
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        [self showToastMsg:@"定位权限未开启" Duration:3.0];
        isCanUse = NO;
        
    }
    
    return isCanUse;
}



/**
 麦克风权限判断
 */
- (BOOL)isUseMicrophone {
    __block BOOL isCanUse = YES;
    
    @WeakObj(self);
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            
            // 用户同意获取麦克风
            isCanUse = YES;
        } else {
            
            // 用户不同意获取麦克风
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [selfWeak showToastMsg:@"应用麦克风权限受限,请在设置中启用" Duration:3.0];
                isCanUse = NO;
                
            });
            
        }
        
    }];
    
    return isCanUse;
}

/**
 判断当前栈中是否有某个控制器
 @param subscript 堆栈数组下标
 @param viewController 控制器
 */
- (BOOL)isHaveTheStack:(int)subscript andViewController:(Class)viewController {
    if ([self.navigationController.childViewControllers[subscript] isKindOfClass:viewController]) {
        return YES;
        
    }
    return NO;
}

#pragma mark - 商城入口
-(void)comeingoodsWithCallBack:(void(^)())callBack {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    webVc.url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    webVc.isNoRefresh = YES;
    webVc.isHiddenBar = YES;
    
    webVc.talkingName = JiFenShangCheng;
    
    webVc.shopCallBack = ^() {
        
        if (callBack) {
            callBack();
        }
        
    };
    
    webVc.title=@"商城";
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
    
}

#pragma mark - 重新登录

-(void)noticeToLogin
{
    
    AppDelegate * appDlt = GetAppDelegates;
    
    if([self checkVersionNeedLogin])
    {
        if (appDlt.userData.isRememberPw.boolValue&&(appDlt.userData.isLogIn.boolValue)) {
            
            LogInPresenter *logInPresenter=[LogInPresenter new];
            
            [logInPresenter logInForAcc:appDlt.userData.accPhone Pw:appDlt.userData.passWord upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(resultCode==SucceedCode)
                    {
                        [appDlt  getBlueTouchData];
                        
                        AppDelegate *appDelegate = GetAppDelegates;
                        NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                        [shared setObject:appDelegate.userData.token forKey:@"widget"];
                        [shared synchronize];
                        AppDelegate * appdelegate = GetAppDelegates;
                        [AppSystemSetPresenters getBindingTag];
                        [appdelegate saveContext];
                        
                      
                    }else
                    {
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
            
        }
        
    }else
    {
        if (appDlt.userData.isLogIn.boolValue){
            
            [appDlt  getBlueTouchData];
        }
    }
    
}
-(BOOL)checkVersionNeedLogin
{
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * lastVsersion = [[NSUserDefaults standardUserDefaults]objectForKey:IOS_LAST_VERSION_NO];
    if (![XYString isBlankString:lastVsersion]) {
        
        if (lastVsersion.integerValue<currentVersion.integerValue) {
            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return YES;
        }else
        {
            return NO;
            
        }
    }
    else
    {
        return NO;
    }
}
#pragma mark - 新增推送统计

-(void)addPushTongJi:(NSString *)pushid
{
    
    [Ls_DataStatisticsPresenter addPushStatistics:pushid updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        
    }];
    
}

#pragma mark - 跳转app的系统设置中
/*
- (void)gotoAppSystemSettings {
    
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    
    NSString * urlString = [NSString stringWithFormat:@"App-Prefs:root=%@",bundleID];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            
        }else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }
        
    }
    
}
*/

#pragma mark - 未读消息请求类型处理逻辑
-(void)setUpTheTypes:(NSString *)type AddOrDelete:(BOOL)isAdd
{
    ls_typeStr = [[NSUserDefaults standardUserDefaults]objectForKey:saveKey];
    [typesArr removeAllObjects];
    NSArray * types = [ls_typeStr componentsSeparatedByString:@","];
    
    if (types.count>0) {
        [typesArr addObjectsFromArray:types];
    }
    
    if (isAdd) {
        
        if ([typesArr containsObject:type]) {
            return;
        }
        [typesArr addObject:type];
        ls_typeStr = [typesArr componentsJoinedByString:@","];
    }else
    {
        if (types.count<=0) {
            return;
        }
        if ([typesArr containsObject:type]) {
            [typesArr removeObject:type];
        }
        ls_typeStr = [typesArr componentsJoinedByString:@","];
    }
    [[NSUserDefaults standardUserDefaults]setObject:ls_typeStr forKey:saveKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


#pragma mark ------ 截图反馈相关
/**
 *系统截屏获取
 *
 */
//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    NSLog(@"检测到截屏");
    //注册通知  截图反馈
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"needTheView"] integerValue] == 1) {
        return;
    }
    //删除之前的view(当前的tabbar页面中)
    if (imgvPhoto) {
        [imgvPhoto removeFromSuperview];
        ///取消延时操作
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerFunction:) object:@{@"isDelay":@"YES"}];
    }
    
    //不同的tabbar页面中
    NSMutableArray *viewsArr = [[NSMutableArray alloc] initWithArray:[[UIApplication  sharedApplication] keyWindow].subviews];
    for (UIView *view in viewsArr) {
        if ([view isKindOfClass:[ScreenshotsView class]]) {
            [view removeFromSuperview];
            ///取消延时操作
            //            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerFunction:) object:@{@"isDelay":@"YES"}];
        }
    }
    imgvPhoto = [ScreenshotsView instanceScreenshotsView];
    imgvPhoto.frame = CGRectMake(SCREEN_WIDTH - 90 - 8, SCREEN_HEIGHT/2 - 180/2, 90, 180);
    imgvPhoto.showImageView.image = [self imageWithScreenshot];
    imgvPhoto.backgroundColor = [UIColor clearColor];
    //添加边框 切角
    imgvPhoto.borderView.layer.cornerRadius = 5.0f;
    imgvPhoto.borderView.layer.masksToBounds = YES;
    imgvPhoto.borderView.layer.borderColor = [UIColor colorWithRed:((float)((0x151759 & 0xFF0000) >> 16))/255.0 green:((float)((0x151759 & 0xFF00) >> 8))/255.0 blue:((float)(0x151759 & 0xFF))/255.0 alpha:0.8].CGColor;
    imgvPhoto.borderView.layer.borderWidth = 2.5f;
    
    [[[UIApplication  sharedApplication] keyWindow ] addSubview:imgvPhoto];
    [self performSelector:@selector(timerFunction:) withObject:@{@"isDelay":@"YES"} afterDelay:3];
    
    @WeakObj(self)
    @WeakObj(imgvPhoto)
    imgvPhoto.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (imgvPhotoWeak) {
            [imgvPhotoWeak removeFromSuperview];
        }
        if (index == 0) {
            //问题反馈
            [imgvPhotoWeak removeFromSuperview];
            
            GraffitiViewController *view = [[GraffitiViewController alloc] init];
            view.image = [selfWeak imageWithScreenshot];
            view.type = @"0";
            view.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:view animated:NO];
            
        }else {
            //问题反馈
            [imgvPhotoWeak removeFromSuperview];
            GraffitiViewController *view = [[GraffitiViewController alloc] init];
            view.image = [selfWeak imageWithScreenshot];
            view.type = @"1";
            view.hidesBottomBarWhenPushed = YES;
            [selfWeak.navigationController pushViewController:view animated:NO];
        }
    };
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

#pragma mark ---- 定时器事件
- (void)timerFunction:(NSTimer *)timer {
    [imgvPhoto removeFromSuperview];
}


/**
 跳转认证页
 */
- (void)goToCertification {
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            AppDelegate *appDlgt = GetAppDelegates;
            
            if (resultCode == SucceedCode) {
                
                //                NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                //
                //                if (isownercert.intValue == 1) {
                //
                //                    [self showToastMsg:@"当前社区已认证" Duration:3.0];
                //                    return ;
                //
                //                }else {
                
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
                    houseListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseListVC animated:YES];
                    
                }else {
                    
                    
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.communityID = appDlgt.userData.communityid;
                    addVC.communityName = appDlgt.userData.communityname;
                    addVC.fromType = 5;
                    addVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
                //                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
}






//判断是否有emoji
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark -- 获取用户权限
/**
 获取用户权限
 */
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

#pragma mark - 推送跳转
/**
 跳转车位管理controller
 */
- (void)gotoParkingViewController{
 
    PAParkingViewController * paparkingVC = [[PAParkingViewController alloc]init];
    paparkingVC.hidesBottomBarWhenPushed = YES;
    
    NSArray * controllers = self.navigationController.viewControllers;
    
    for (UIViewController * controller in controllers) {
        
        if ([controller.className isEqualToString:@"PAParkingViewController"]) {
            NSLog(@"当前界面已处于新车库Controller下");
            return;
        }
    }
    
    [self.navigationController pushViewController:paparkingVC animated:YES];
}

- (void)gotoNewNoticeViewController:(NSNotification *)notification{
    NSString * code = notification.object;

    PAWebViewController * webview = [[PAWebViewController alloc]init];
    webview.hidesBottomBarWhenPushed = YES;
    AppDelegate * delegate = GetAppDelegates;
    webview.url = [NSString stringWithFormat:@"%@%@?token=%@&noticeCode=%@&userId=%@&communityId=%@",PA_NEW_NOTICEWEB_URL,PANewNoticeWebPath,delegate.userData.token,code,delegate.userData.userID,delegate.userData.communityid];
    webview.shareUrl = [NSString stringWithFormat:@"%@%@?noticeCode=%@",PA_NEW_NOTICEWEB_URL,PANewNoticeWebSharePath,code];

    NSArray * controllers = self.navigationController.viewControllers;
    
    for (UIViewController * controller in controllers) {
        
        if ([controller.className isEqualToString:@"PAWebViewController"]) {
            NSLog(@"当前界面已处于新公告Controller下");
            return;
        }
    }
    [self.navigationController pushViewController:webview animated:YES];
}
- (void)gotoNewSuggestViewController:(NSNotification *)notification{
    //
    
    NSString * code = notification.object;
    
    PASuggestDetailViewController * suggest = [[PASuggestDetailViewController alloc]init];
    suggest.orderId = code;
    suggest.hidesBottomBarWhenPushed = YES;
    NSArray * controllers = self.navigationController.viewControllers;
    
    for (UIViewController * controller in controllers) {
        
        if ([controller.className isEqualToString:@"PASuggestDetailViewController"]) {
            NSLog(@"当前界面已处于新公告Controller下");
            return;
        }
    }
    [self.navigationController pushViewController:suggest animated:YES];
}

/**
 通过storyboardName 和 identifier 加载出controller
 
 @param name storyboardName
 @param identifier identifier description
 @return viewController
 */
- (id)viewControllerWithStoryboardName:(NSString *)name identifier:(NSString *)identifier{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    BaseViewController * controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return controller;
}

@end
