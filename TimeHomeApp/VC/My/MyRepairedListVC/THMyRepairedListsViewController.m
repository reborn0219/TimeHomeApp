//
//  THMyRepairedListsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRepairedListsViewController.h"
#import "THMyRequiredListTVC.h"
#import "RaiN_NewMyRequiredListTCell.h"
#import "THMyRequiredDetailsViewController.h"

#import "THRequiredCommentViewController.h"
#import "OnlineServiceVC.h"
/**
 *  网络请求
 */
#import "ReservePresenter.h"
#import "UserDefaultsStorage.h"
#import "PushMsgModel.h"

#import "THMyInfoPresenter.h"
#import "MessageAlert.h"
#import "THOwnerAuthViewController.h"
#import "L_CommunityAuthoryPresenters.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "RaiN_NewServiceTempVC.h"
#import "RaiN_NewOnlineServiceVC.h"
@interface THMyRepairedListsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;
    NSMutableArray *dataArray;//模拟数据
    /**
     *  维修通知数组
     */
    NSMutableArray *requiredIDArray;
}
@property (nonatomic, strong) BaseTableView *tableView;

@end

@implementation THMyRepairedListsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;

//    [TalkingData trackPageBegin:@"baoxiu"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:BaoXiu];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView.mj_header beginRefreshing];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"baoxiu"];
    //数据统计
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":BaoXiu}];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"报修记录";
    page = 1;
    dataArray = [[NSMutableArray alloc]init];
    requiredIDArray = [[NSMutableArray alloc]init];
    [requiredIDArray addObjectsFromArray:_IdArray];
    [self createTableView];
    
    
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[RaiN_NewOnlineServiceVC class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    UIViewController *lastVC = marr[marr.count - 2];
//    // 返回到倒数第二个控制器
//    if ([lastVC isKindOfClass:[RaiN_NewOnlineServiceVC class]]) {
//        [marr removeObjectAtIndex:marr.count - 2];
//    }
//    self.navigationController.viewControllers = marr;
}

///返回处理
-(void)backButtonClick
{
    
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    for (UIViewController *vc in marr) {
//        if ([vc isKindOfClass:[RaiN_NewOnlineServiceVC class]]) {
//            [marr removeObject:vc];
//            break;
//        }
//    }
//    self.navigationController.viewControllers = marr;
    
    
    
//    if(self.isFromRelease)
//    {
//        [super backButtonClick];
////        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [super backButtonClick];
//    }
    [super backButtonClick];
}



/**
 *  我的报修列表请求 refresh是否为刷新
 */
- (void)httpRequestPullToRefreshOrNot:(BOOL)refresh {
    
    [self.tableView hiddenNothingView];

    if (refresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    @WeakObj(self);

    [ReservePresenter getUserReserveForPage:[NSString stringWithFormat:@"%ld",(long)page] upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{

            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if(resultCode == SucceedCode)
            {
                if (refresh) {

                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }

                    NSArray * tmparr = (NSArray *)data;
                    NSInteger count = dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [selfWeak.tableView beginUpdates];
                    for (int i = 0; i < tmparr.count; i++) {
                        [selfWeak.tableView insertSections:[NSIndexSet indexSetWithIndex:count + i] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    [selfWeak.tableView endUpdates];

                }

                if (dataArray.count == 0) {
                    
                    [selfWeak.tableView showNothingnessViewWithType:NoContentTypeOnlineService Msg:@"您还没有在线报修过设施,如果有需要报修的设施可点击下方按钮去报修" SubMsg:@"" btnTitle:@"去报修" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        if (index == 1) {
                            return ;
                        }
                        
                        [selfWeak.tableView hiddenNothingView];
                        
                        THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];//加载动画
                        [indicator startAnimating:self.tabBarController];
                        
                        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [indicator stopAnimating];
                                
                                if (resultCode == SucceedCode) {
                                    
                                    NSDictionary *dic = data[@"map"];
                                    
                                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                                    if ([resipower integerValue] == 0||[resipower integerValue]==9) {
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
                                    }else {
                                        ///已认证
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
                                        
                                        if ([_isFromMy integerValue] == 0) {
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }else {
                                            
                                            NSArray*arrController =self.navigationController.viewControllers;
                                            UIViewController *lastVC = arrController[arrController.count - 2];
                                            // 返回到倒数第二个控制器
                                            if ([lastVC isKindOfClass:[RaiN_NewServiceTempVC class]]) {
                                                [self.navigationController popToViewController:lastVC animated:YES];
                                            }else {
                                                RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                                                newOnline.hidesBottomBarWhenPushed = YES;
                                                newOnline.isFormMy = _isFromMy;
                                                [self.navigationController pushViewController:newOnline animated:YES];
                                            }
                                            
                                            
                                        }
//                                        RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
//                                        newOnline.hidesBottomBarWhenPushed = YES;
//                                        [self.navigationController pushViewController:newOnline animated:YES];

                                    }
                                }
                            });
                        }];
                        
                    }];
                    
                }
                
            }else {
                if (refresh) {
                    page = 1;
                }else {
                    page --;
                }
                
                if (dataArray.count == 0) {
                    
                    [self.tableView showNothingnessViewWithType:NoContentTypeNetwork Msg:@"加载失败 请下拉刷新" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                    }];
                }
                
            }
            
        });
        
    }];

}

- (void)createTableView {
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THMyRequiredListTVC class] forCellReuseIdentifier:NSStringFromClass([THMyRequiredListTVC class])];
    [_tableView registerNib:[UINib nibWithNibName:@"RaiN_NewMyRequiredListTCell" bundle:nil] forCellReuseIdentifier:@"RaiN_NewMyRequiredListTCell"];
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestPullToRefreshOrNot:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {        
    return 80;
//     UserReserveInfo *model = dataArray[indexPath.section];
//    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[RaiN_NewMyRequiredListTCell class] contentViewWidth:[self cellContentViewWith]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RaiN_NewMyRequiredListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RaiN_NewMyRequiredListTCell"];
//    THMyRequiredListTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMyRequiredListTVC class])];

    if (dataArray.count > 0) {
        UserReserveInfo *model = dataArray[indexPath.section];
        cell.model = model;
        
//        cell.infoImage.hidden = YES;
        for (NSString *theID in requiredIDArray) {
            if ([theID isEqualToString:[NSString stringWithFormat:@"%@",model.theID]]) {
//                cell.infoImage.hidden = NO;
                break;
            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserReserveInfo *model = dataArray[indexPath.section];
    
    NSString *string = @"";
    for (NSString *theID in requiredIDArray) {
        if ([theID isEqualToString:[NSString stringWithFormat:@"%@",model.theID]]) {
            string = theID;
            break;
        }
    }
    if (string.length > 0) {
        [requiredIDArray removeObject:model.theID];

        AppDelegate *appDelegate = GetAppDelegates;
        NSString *content = [requiredIDArray componentsJoinedByString:@","];
        PushMsgModel *pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.RepairMsg];
        pushMsg.content = content;
        pushMsg.countMsg = [[NSNumber alloc]initWithInteger:requiredIDArray.count];

        [UserDefaultsStorage saveData:pushMsg forKey:appDelegate.RepairMsg];

    }
    
    if ([model.state intValue] == 3) {
        //去评价
        THRequiredCommentViewController *commentlVC = [[THRequiredCommentViewController alloc]init];
        commentlVC.userInfo = model;
        [self.navigationController pushViewController:commentlVC animated:YES];
        
    }else {
        
        //查看进度
        THMyRequiredDetailsViewController *detailVC = [[THMyRequiredDetailsViewController alloc]init];
        detailVC.userInfo = model;
        detailVC.isFormMy = _isFromMy;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

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
                    AppDelegate *appDlgt = GetAppDelegates;
                    if (houseArr.count > 0) {
                        
                        //---有房产----
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                        L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                        houseListVC.fromType = 5;
                        houseListVC.houseArr = houseArr;
                        houseListVC.carArr = carArr;
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

//                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

@end
