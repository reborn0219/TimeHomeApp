//
//  LS_PersonalNoticeVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_PersonalNoticeVC.h"
#import "LS_PersonalNoticeCell.h"
#import "ChatPresenter.h"
#import "UserNoticeModel.h"
#import "WebViewVC.h"
#import "EncryptUtils.h"
#import "THMaskingView.h"
#import "NoviceViewModel.h"
#import "PushMsgModel.h"

#import "THMyRepairedListsViewController.h"
#import "THMyComplainListViewController.h"
#import "AlertsListVC.h"
#import "NotificationVC.h"
#import "ReviewDetailVC.h"
#import "WebViewVC.h"

#import "L_MyMoneyViewController.h"
#import "L_MyPublishViewController.h"
#import "PraiseListVC.h"
#import "MessageAlert.h"

#import "UIImage+ImageRotate.h"

#import "L_NewBikeInfoViewController.h"
#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "CommunityManagerPresenters.h"
#import "L_MyGivenTicketsListViewController.h"
#import "L_MyExchangeListViewController.h"

#import "L_CarNumberErrorViewController.h"
#import "Ls_DataStatisticsPresenter.h"
#import "AppSystemSetPresenters.h"
#import "L_NewMyHouseListViewController.h"
#import "RaiN_VoucherDetailsVC.h"
#import "RaiN_RedPacketDetails.h"

#import "LS_BottomEditView.h"
#import "LS_AlertEditView.h"


@interface LS_PersonalNoticeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * page;
    BOOL isTheRefresh;
    
    BOOL isEditing;//编辑模式
    BOOL isSelectAll;//全部选择
    UIButton *bt2;
    LS_BottomEditView * bottomView;
    LS_AlertEditView * alertEditView;
    
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *noticeArr;
@end

@implementation LS_PersonalNoticeVC

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelectAll = NO;
    page = @"1";
    isEditing = NO;
    _noticeArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.view addSubview:self.table];
    @WeakObj(self);
    
    self.table.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        page = @"1";
        isTheRefresh = YES;
        [selfWeak getUserNotice:selfWeak.type isRefresh:isTheRefresh];
    }];
    
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page = [NSString stringWithFormat:@"%ld",(page.integerValue+1)];
        isTheRefresh = NO;
        [selfWeak getUserNotice:selfWeak.type isRefresh:isTheRefresh];
    }];
    
    [self.table.mj_footer setAutomaticallyHidden:YES];
    
    [self.table.mj_header beginRefreshing];

    
    
    bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt2 setFrame:CGRectMake(0, 0,50,60)];
    [bt2 setTitle:@"编辑" forState:UIControlStateNormal];
    bt2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [bt2 addTarget:self action:@selector(lsRightBarAction) forControlEvents:UIControlEventTouchUpInside];
    bt2.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [bt2 setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    UIBarButtonItem *rightBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt2];
    self.navigationItem.rightBarButtonItem = rightBarBt;
    
    
    bottomView = [[[NSBundle mainBundle]loadNibNamed:@"LS_BottomEditView" owner:self options:nil] lastObject];
    [self.view addSubview:bottomView];
    [bottomView setHidden:YES];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(selfWeak.view.mas_left).offset(0);
        make.right.equalTo(selfWeak.view.mas_right).offset(0);
        make.bottom.equalTo(selfWeak.view.mas_bottom).offset(0);
        make.height.equalTo(@55);
    }];
    
    alertEditView = [[LS_AlertEditView alloc]init];
    
    @WeakObj(alertEditView);
    [bottomView editBlock:^(NSInteger type) {
        
        if (type == 0) {
            
            //全选
            isSelectAll = !isSelectAll;
            [selfWeak loadMoreSelectAll:selfWeak.noticeArr andSelect:isSelectAll];
            [selfWeak.table reloadData];
            
        }else
        {
           
            NSString * lsids = [selfWeak screeningModelGetIDs:selfWeak.noticeArr andSelect:isSelectAll];
            if (!isSelectAll) {
                
                if ([XYString isBlankString:lsids]) {
                    [selfWeak showToastMsg:@"请先选中删除项" Duration:2.0f];
                    return ;
                }
            }
            
            //清空
            [alertEditViewWeak showEditDetermine:selfWeak andBlock:^(NSInteger type) {
                
                
                if (type == 0) {
                    
                }else
                {
                    
                
                        [selfWeak deleteMsgRequest];
                
                    
                }
            }];
            
        }
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    switch (_type.integerValue) {
        case 0:
        {
            self.navigationItem.title = @"系统通知";
        }
            break;
        case 1:
        {
            self.navigationItem.title = @"物业通知";

        }
            break;
        case 2:
        {
            self.navigationItem.title = @"个人通知";

        }
            break;
        case 6:
        {
            self.navigationItem.title = @"活动通知";

        }
            break;
        default:
            break;
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.block) {
        if (_noticeArr.count > 0) {
            UserNoticeModel * UNML = [_noticeArr objectAtIndex:0];
            self.block(UNML.content, nil, 0);
        }else {
            self.block(@"", nil, 0);
        }
    }
    
}

#pragma mark - 接口请求获取通知内容
-(void)getUserNotice:(NSString *)type isRefresh:(BOOL)isRefresh {
    
    _table.hidden = NO;
    [self hiddenNothingnessView];
    
    @WeakObj(self);
    [ChatPresenter getUserNoticeWithType:type andPage:page :^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.table.mj_header endRefreshing];
            [self.table.mj_footer endRefreshing];
            
            if (resultCode == SucceedCode) {
                
                if (isTheRefresh) {
                    [_noticeArr removeAllObjects];
                }
                NSArray * temparr = data;
                
                
                [_noticeArr addObjectsFromArray:[self loadMoreSelectAll:temparr andSelect:isSelectAll]];

              
                
                [selfWeak.table reloadData];
                
            }else {

                if (!isRefresh){
                    
                    page = [NSString stringWithFormat:@"%ld",(page.integerValue-1)];
                    
                }
                
            }
            
            if (_noticeArr.count == 0) {
                
                _table.hidden = YES;
                @WeakObj(self)

                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"没有记录  " eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    [selfWeak hiddenNothingnessView];
                    selfWeak.table.hidden = NO;
                    [selfWeak.table.mj_header beginRefreshing];
                    
                }];
            }
            
        });

    }];
    
}

#pragma mark - 初始化Table

-(UITableView *)table {
    
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
        _table.delegate =self;
        _table.dataSource =self;
        self.table.allowsMultipleSelectionDuringEditing = true;
        
        [_table registerNib:[UINib nibWithNibName:@"LS_PersonalNoticeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LS_PersonalNoticeCell"];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table setBackgroundColor:BLACKGROUND_COLOR];
        _table.showsVerticalScrollIndicator = NO;
    }
    
    return  _table;
}
#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LS_PersonalNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LS_PersonalNoticeCell"];
    UserNoticeModel * UNML = [_noticeArr objectAtIndex:indexPath.section];
    [cell assignmentWithModel:UNML];
    [cell wetherEditing:isEditing];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserNoticeModel * UNML = [_noticeArr objectAtIndex:indexPath.section];

    return 110+UNML.contentHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _noticeArr.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (isEditing) {
        ///编辑模式下 点击选中
        UserNoticeModel *ls_um = _noticeArr[indexPath.section];
        ls_um.isSelect = !ls_um.isSelect;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        return;
    }
    
    UserNoticeModel *UNML = _noticeArr[indexPath.section];
    NSDictionary * jsonData = UNML.jsondata;
    
    if(jsonData)
    {
        if (![XYString isBlankString: [NSString stringWithFormat:@"%@",jsonData[@"msgtype"]] ]) {

            NSDictionary * dic = @{@"type":[NSString stringWithFormat:@"%@",jsonData[@"msgtype"]]
                                   ,@"map":jsonData,@"isPush":@YES};
            [self jumpToVC:dic:UNML];
        }
    }
    
    //红包
//    L_MyRedBagViewController *redVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyRedBagViewController"];
//    [self.navigationController pushViewController:redVC animated:YES];
    
    //卡券
//    L_MyTicketsListViewController *ticketsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyTicketsListViewController"];
//    [self.navigationController pushViewController:ticketsVC animated:YES];
    
}
// MARK: - 兼容iOS 8方法需加上
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     删除按钮事件
     */
    @WeakObj(self);
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UserNoticeModel *UNML = _noticeArr[indexPath.section];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        
        [ChatPresenter clearOneNotice:UNML.theID withType:UNML.type andBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
           
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode==SucceedCode) {
                    
                    [selfWeak.noticeArr removeObject:UNML];
                    [selfWeak.table reloadData];

                }else {
                    [self showToastMsg:data Duration:3.0];
                }
                
                if (selfWeak.noticeArr.count == 0) {
                    _table.hidden = YES;
                    @WeakObj(self)
                    [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"没有记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        [selfWeak hiddenNothingnessView];
                        selfWeak.table.hidden = NO;
                        [selfWeak.table.mj_header beginRefreshing];
                        
                    }];

                }
                
            });
            
        }];
        
    }];
    action1.backgroundColor = [UIColor redColor];
    return @[action1];
    
}

#pragma mark - iOS11 新增左右侧滑方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        
        @WeakObj(self);

        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            UserNoticeModel *UNML = _noticeArr[indexPath.section];
            
            [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
            
            [ChatPresenter clearOneNotice:UNML.theID withType:UNML.type andBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    
                    if (resultCode==SucceedCode) {
                        
                        [selfWeak.noticeArr removeObject:UNML];
                        [selfWeak.table reloadData];
                        
                    }else {
                        [self showToastMsg:data Duration:3.0];
                    }
                    
                    if (selfWeak.noticeArr.count == 0) {
                        _table.hidden = YES;
                        @WeakObj(self)
                        [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"没有记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                            
                            [selfWeak hiddenNothingnessView];
                            selfWeak.table.hidden = NO;
                            [selfWeak.table.mj_header beginRefreshing];
                            
                        }];
                        
                    }
                    
                });
                
            }];
            
        }];
        
        deleteRowAction.image = [UIImage imageNamed:@"删除图标"];
        deleteRowAction.backgroundColor = kNewRedColor;
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
        
        return config;
        
        
    }else {
        return nil;
    }
    
};

#else

#endif

#pragma - MARK: 详情入口

// MARK: - 详情入口
-(void)gotoExchangeInfoWithID:(NSString *)theid {
    
    AppDelegate *appDlgt = GetAppDelegates;
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    NSString *url = [NSString stringWithFormat:@"%@/mobile/index.php?app=member&act=login&token=%@&userid=%@&allow=1&ret_url=%%2Fmobile%%2Findex.php%%3Fapp%%3Dbuyer_order%%26act%%3Dview%%26order_id%%3D",kShopSEVER_URL,appDlgt.userData.token,appDlgt.userData.userID];
    url = [url stringByAppendingString:theid];
    
    webVc.url = url;
    
    webVc.isNoRefresh = YES;
    webVc.isHiddenBar = YES;
    webVc.talkingName = JiFenShangCheng;
    
    webVc.title=@"商城";
    [self.navigationController pushViewController:webVc animated:YES];
    
}

#pragma mark - 消息跳转

-(void)jumpToVC:(NSDictionary *)dic :(UserNoticeModel*)UNML
{
    
        AppDelegate * appDlgt=GetAppDelegates;
        NSString * type = [dic objectForKey:@"type"];
        
        switch ([type integerValue]) {
                
            case 10001://10001	个人消息：你的账户被多次举报请不要再违规
            case 10002://后台为用户重置密码：您的账号密码已重置为此手机号的后六位，请使用登录
   //       case 10003://请下载时代社区App地址[下载地址],开启您的时代。账号为手机号，密码手机号后六位
   //            break;
            case 10101://获得车位权限：您已获得车位[车位名称]的使用权限
            case 10102://失去车位权限：您已失去车位[车位名称]的使用权限
            case 10103://获得房产权限：您已获得房产[门牌号]的操作权限
            case 10104://失去房产权限：您已失去房产[门牌号]的操作权限
            case 10105://业主变更后台审核通过：您已通过XX小区的业主认证，去试试业主专享功能吧~
            case 10106://业主变更审核不通过：您未通过XX小区的业主认证，请填写准确信息后再次提交申请
            {
                
            }
                break;
                
            case 10113:/** 车牌纠错 */
            {
                
                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                [AppSystemSetPresenters getCarCorrectionSetWithPlatform:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        
                        if (resultCode == SucceedCode) {
                            
                            if ([data[@"isset"] intValue] == 1) {
                                
                                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CarError" bundle:nil];
                                L_CarNumberErrorViewController *carErrorVC = [sb instantiateViewControllerWithIdentifier:@"L_CarNumberErrorViewController"];
                                carErrorVC.isFromPush = YES;
                                carErrorVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:carErrorVC animated:YES];
                                
                            }else {
                                
                                [self showToastMsg:@"所在小区暂未开通此功能" Duration:5.0];
                                
                            }
                            
                        }else {
                            [self showToastMsg:data Duration:5.0];
                        }
                        
                    });
                    
                }];
                
            }
                break;
                
            case 10121://社区认证审核成功 您在时代社区1栋2单元2908室的房产认证成功，恭喜您成为该社区的认证业主。 map{“id”:”123dfdf3er13df”,”state”:1}
            case 10122://社区认证审核失败 您在时代社区1栋2单元2908室的房产认证审核失败，失败原因：您提供的业主信息有误，房产信息不对。 map{“id”:”123dfdf3er13df”,”state”:2}
            {
                //我的房产
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                L_NewMyHouseListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                houseListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:houseListVC animated:YES];
            }
                break;
                
            case 60001://大赛：审核通过：恭喜，您上传的摄影大赛作品[作品名称]已经审核通过，作品编号
            case 60002://大赛：未审核通过：非常遗憾，您上传的摄影大赛作品[作品名称]未审核通过
            {
                
              
            }
                break;
            case 20001://社区公告
            case 20002://社区新闻
            {
               
            }
                break;
            case 20003://社区活动
            {
             
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    NSDictionary * map=[dic objectForKey:@"map"];
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
                break;
            case 20101://物业已接收：XX物业已接收您的报修申请，正在分派维修人员
            case 20102://维修处理中：维修人员[姓名]正在处理您的报修
            case 20103://物业驳回：您的报修因[驳回原因]被驳回，请完善信息后重新提交
            case 20104://暂不维修：XX物业暂时无法处理你的报修申请
            case 20105://已完成 待评价：您的报修已处理完成，给个评价吧
            {
                PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];
                            //我的报修
                THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
//                subVC.isFromMy = @"0";
                if (![XYString isBlankString:pushMsg.content]) {
                    subVC.IdArray = [pushMsg.content componentsSeparatedByString:@","];
                }
                subVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:subVC animated:YES];

            
            }
                break;
            case 20201://投诉回复：您的投诉XX物业已回复
            {
                
                //我的投诉
                PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.RepairMsg];

                THMyComplainListViewController *complainVC = [[THMyComplainListViewController alloc]init];
                complainVC.hidesBottomBarWhenPushed=YES;
                if (![XYString isBlankString:pushMsg.content]) {
                    complainVC.IdArray = [pushMsg.content componentsSeparatedByString:@","];
                }
                [self.navigationController pushViewController:complainVC animated:YES];

            }
                break;
            case 30001:///点赞
            case 30091:///帖子审核不通过
            case 30002:///评论
            case 30312:///问答帖(采纳后推送)
            {
                
                    NSString *postid = dic[@"map"][@"postid"];
                    NSString *posttype = dic[@"map"][@"posttype"];
                    
                    if (posttype.integerValue == 0) {//普通帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
                        normalDetailVC.postID = postid;
                       
                        normalDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:normalDetailVC animated:YES];
                        
                        
                    }
                    
                    if (posttype.integerValue == 4) {//房产车位帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
                        houseDetailVC.postID = postid;
                        
                        houseDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:houseDetailVC animated:YES];
                      
                    }
                    
                    if (posttype.integerValue == 3) {//问答帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
                        qusetion.postID = postid;
                      
                        qusetion.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:qusetion animated:YES];
                        
                    }
                
            }
                break;
            case 30003:///回复(已去掉，统一用评论的推送)
            case 30292:///投票贴(投票时间结束)
            {
                
            }
                break;
            case 30311:///问答帖(收到奖励后推送)
            case 30392:///问答帖(奖励退回的推送)
            case 30093:///带红包帖子审核不通过推送
            case 30999:///红包过期
            {
                ///跳转余额
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
                L_MyMoneyViewController *myMoneyVC = [sb instantiateViewControllerWithIdentifier:@"L_MyMoneyViewController"];
                myMoneyVC.isFromPush = YES;
                [myMoneyVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myMoneyVC animated:YES];

                
            }
                break;
            case 30092:///帖子(删除)
            case 30094:///用户禁言推送
            {

            }
                break;
            case 30492://房产贴(房产贴线上时间到期)(不做跳转 2017.02.22)
            {
                
                //我的发布
                L_MyPublishViewController *myPublishVC = [[UIStoryboard storyboardWithName:@"MyTab" bundle:nil] instantiateViewControllerWithIdentifier:@"L_MyPublishViewController"];
                myPublishVC.selectIndex = 2;
                [myPublishVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myPublishVC animated:YES];

                
            }
                break;
            case 30101://收到个人聊天消息
            {

            }
                break;
            case 50001://车辆锁定状态出库：车辆[车牌号]的防盗装置发出警报，请立即处理
            {
               
            }
                break;
            case 50002://车辆出入库推送
            case 50003://车辆出入库推送
            {
                NSDictionary * jsonData = UNML.jsondata;
                PARedBagModel *redBag = [PARedBagModel mj_objectWithKeyValues:jsonData];
                
                if(redBag.state ==0){
                    [self showRedBag:redBag];
                }
        
            }
            case 50209://后台删除自行车
            {
            }
                break;
            case 50202://二轮车共享接口推送
            case 50203://二轮车定时锁车解锁修改接口推送
            case 50201://个人消息：你的自行车疑似被盗
            {
                
                
                UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                
                L_NewBikeInfoViewController *newInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
                newInfoVC.theID = [dic[@"map"] objectForKey:@"bikeid"];
                newInfoVC.bikeListType = @"1";
                [self.navigationController pushViewController:newInfoVC animated:YES];

                
            }
                break;
            case 70001://摇摇通行电梯操作
            {
            }
                break;
            case 80001://赠送票券推送
            {
                
                //进入赠予券列表 推送返回页面为“我的票券列表”；
                UIStoryboard * myStoryboard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
                L_MyGivenTicketsListViewController *givenVC = [myStoryboard instantiateViewControllerWithIdentifier:@"L_MyGivenTicketsListViewController"];
                givenVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:givenVC animated:NO];

            }
                break;
            case 80002://即将到期兑换券推送
            {
                
                //进入订单列表页面 推送返回页面为“我的页面”
                
                if (![XYString isBlankString:UNML.jsondata[@"goodslogid"]]) {
                    
                    if (![XYString isBlankString:UNML.jsondata[@"convertid"]]) {
                        /** 进入订单详情 */
                        [self gotoExchangeInfoWithID:UNML.jsondata[@"convertid"]];
                    }
                    
                }

                
            }
                break;
        ////新增运营定制推送消息
            case 90101://跳转固定类型帖子详情推送
            {
                
                
                
                    NSString *postid =   dic[@"map"][@"urlkey"];
                    NSString *posttype = dic[@"map"][@"posttype"];
                    
                    if (posttype.integerValue == 0||posttype.integerValue == 9) {//普通帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
                        normalDetailVC.postID = postid;
                        //                    NSNumber * isPush =[dic objectForKey:@"isPush"] ;
                        //                    if (!isPush.boolValue) {
                        normalDetailVC.isFromCommentPush = YES;
                        
                        //                    }
                        normalDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:normalDetailVC animated:YES];
                        
                        
                    }
                    
                    if (posttype.integerValue == 4) {//房产车位帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
                        houseDetailVC.postID = postid;
                        
                        //                    NSNumber * isPush =[dic objectForKey:@"isPush"] ;
                        //                    if (!isPush.boolValue) {
                        houseDetailVC.isFromCommentPush = YES;
                        
                        //                    }
                        houseDetailVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:houseDetailVC animated:YES];
                        
                    }
                    
                    if (posttype.integerValue == 3) {//问答帖
                        
                        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
                        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
                        qusetion.postID = postid;
                        //                    NSNumber * isPush =[dic objectForKey:@"isPush"] ;
                        //                    if (!isPush.boolValue) {
                        qusetion.isFromCommentPush = YES;
                        
                        //                    }
                        qusetion.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:qusetion animated:YES];
                        
                    }
                
                

            }
                break;
                
            case 90201://跳转活动链接推送需要加token
            {
                
                
                ///击点通知跳转到相应的界面
                
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    NSDictionary * map=[dic objectForKey:@"map"];
                    
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

            }
                break;
                
            case 90202://跳转外部链接推送不需要加token
            {
                ///击点通知跳转到相应的界面
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                NSDictionary * map=[dic objectForKey:@"map"];
                webVc.url= [map objectForKey:@"urlkey"];
                webVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVc animated:YES];
                
            }
                break;
            default:
                break;
        }
    
        [self pushClickStatistics:UNML];

}
#pragma mark - 消息点击统计

-(void)pushClickStatistics:(UserNoticeModel *)UNML
{

    if (!UNML.isclick.boolValue) {
        
        [Ls_DataStatisticsPresenter addPushClickStatistics:UNML.theID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
        }];
        
    }
}

#pragma mark --  编辑按钮
-(void)lsRightBarAction
{
    if (isEditing == NO) {
        
        isEditing = YES;
        isSelectAll = NO;
        [bt2 setTitle:@"完成" forState:UIControlStateNormal];
        [bottomView setHidden:NO];
    }else
    {
        
        isSelectAll = NO;
        [bottomView.selImgView setImage:[UIImage imageNamed:@"ls_tuoyuan"]];
        isEditing = NO;
        [bt2 setTitle:@"编辑" forState:UIControlStateNormal];
        [bottomView setHidden:YES];

    }
    [self loadMoreSelectAll:_noticeArr andSelect:isSelectAll];
    [self.table reloadData];
    
}

#pragma mark - 当用户全选时将分页加载出来的数据全部置为全选
-(NSArray *)loadMoreSelectAll:(NSArray *)lstempArr andSelect:(BOOL) isSelect
{
    [lstempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UserNoticeModel * ls_umodel = (UserNoticeModel * )obj;
        ls_umodel.isSelect = isSelect;
    
    }];
    return lstempArr;
}

#pragma mark - 筛选那些数据需要删除或者不删除
-(NSString *)screeningModelGetIDs:(NSArray *)lstempArr andSelect:(BOOL) isSelect
{
    
    NSMutableString * lstemStr = [[NSMutableString alloc]initWithCapacity:0];
    
    [lstempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UserNoticeModel * ls_umodel = (UserNoticeModel * )obj;
        
        NSLog(@"--%ld----",(long)ls_umodel.isSelect);
        if (ls_umodel.isSelect == !isSelect) {
            
            [lstemStr appendString:[NSString stringWithFormat:@"%@,",ls_umodel.theID]];

        }
        
    }];
    if ([XYString isBlankString:lstemStr]) {
        return @"";
    }
    return [lstemStr substringToIndex:lstemStr.length-1];
}

#pragma mark - 数据删除接口调用
-(void)deleteMsgRequest
{
    NSString * lsids = [self screeningModelGetIDs:_noticeArr andSelect:isSelectAll];
    @WeakObj(self);
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    if (!isSelectAll) {
        
        [ChatPresenter batchdelNotice:lsids wihtBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
          
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if (resultCode == SucceedCode) {
                    
                    [selfWeak clearLocalData];
                    
                }else
                {
                    
                }
            });
        }];
        
    }else
    {
        
        [ChatPresenter clearNotice:self.type andNotIDs:lsids withBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                if (resultCode == SucceedCode) {
                    
                    [selfWeak clearLocalData];
                    
                }else
                {
                    
                }
            });
          
        }];
        
    }
    
}

-(void)clearLocalData
{
    
    
    NSMutableArray * temp_noticArr = [[NSMutableArray alloc]init];
    for (id obj in _noticeArr) {
        
        UserNoticeModel * ls_umodel = (UserNoticeModel * )obj;
        NSLog(@"--%ld----",(long)ls_umodel.isSelect);
        if(ls_umodel.isSelect != YES){
            
            [temp_noticArr addObject:ls_umodel];

        }
    }
    _noticeArr = temp_noticArr;
    [self.table reloadData];
    
}
@end
