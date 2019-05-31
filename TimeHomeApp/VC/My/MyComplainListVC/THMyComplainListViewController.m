//
//  THMyComplainListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyComplainListViewController.h"
#import "THBaseTableViewCell.h"
#import "THMyrequiredTVCStyle1.h"
#import "THMyrequiredTVCStyle1-1.h"
#import "THComplainDetailsViewController.h"
#import "SuggestionsVC.h"
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

@interface THMyComplainListViewController () <UITableViewDelegate, UITableViewDataSource>
//数据
{
    NSInteger page;
    NSMutableArray *dataArray;
    /**
     *  投诉推送id数组
     */
    NSMutableArray *complainIDArray;
}
@property (nonatomic, strong) BaseTableView *tableView;

@end

@implementation THMyComplainListViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//    [TalkingData trackPageBegin:@"tousu"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:TouSu];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"tousu"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":TouSu}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投诉记录";
    page = 1;
    dataArray = [[NSMutableArray alloc]init];
    complainIDArray = [[NSMutableArray alloc]initWithArray:_IdArray];
    [self createTableView];

}
/**
 *  我的投诉列表请求
 */
- (void)httpRequestPullToRefreshOrNot:(BOOL)refresh {
    
    [self.tableView hiddenNothingView];

    if (refresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    @WeakObj(self);

    [ReservePresenter getUserComplaintForPage:[NSString stringWithFormat:@"%ld",(long)page] upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
                    
                    [selfWeak.tableView showNothingnessViewWithType:NoContentTypePublish Msg:@"没有投诉记录" SubMsg:@"如果需对物业提出您的建议可点下方按钮" btnTitle:@"投 诉 建 议" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        if (index == 1) {
                            return ;
                        }
                        
                        [selfWeak.tableView hiddenNothingView];
                        
                        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                        [indicator startAnimating:self.tabBarController];
                        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [indicator stopAnimating];
                                
                                if (resultCode == SucceedCode) {
                                    
                                    NSDictionary *dic = data[@"map"];
                                    
                                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                                    if ([resipower integerValue] == 0 ||[resipower integerValue]==9) {
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
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    [_tableView registerClass:[THMyrequiredTVCStyle1_1 class] forCellReuseIdentifier:NSStringFromClass([THMyrequiredTVCStyle1_1 class])];
    
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserComplaint *userComplaint = dataArray[indexPath.section];
        return [_tableView cellHeightForIndexPath:indexPath model:userComplaint keyPath:@"userComplaint" cellClass:[THMyrequiredTVCStyle1_1 class] contentViewWidth:[self cellContentViewWith]];
    }else {
        return 48;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        THMyrequiredTVCStyle1_1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMyrequiredTVCStyle1_1 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserComplaint *userComplaint = dataArray[indexPath.section];
        cell.userComplaint = userComplaint;

        return cell;
    }else {
        THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.baseTableViewCellStyle = BaseTableViewCellStyleValue3;

        UserComplaint *userComplaint = dataArray[indexPath.section];

        cell.leftLabel.textColor = TEXT_COLOR;
        cell.leftLabel.text = userComplaint.content;

        cell.infoImage.hidden = YES;
        for (NSString *theID in complainIDArray) {
            if ([theID isEqualToString:[NSString stringWithFormat:@"%@",userComplaint.theID]]) {
                cell.infoImage.hidden = NO;
                break;
            }
        }
        
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        UserComplaint *userComplaint = dataArray[indexPath.section];
        
        NSString *string = @"";
        for (NSString *theID in complainIDArray) {
            if ([theID isEqualToString:[NSString stringWithFormat:@"%@",userComplaint.theID]]) {
                string = theID;
                break;
            }
        }
        if (string.length > 0) {
            [complainIDArray removeObject:userComplaint.theID];
            NSString *content = [complainIDArray componentsJoinedByString:@","];
            AppDelegate *appDelegate = GetAppDelegates;
            PushMsgModel *pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.ComplainMsg];
            pushMsg.content = content;
            pushMsg.countMsg = [[NSNumber alloc]initWithInteger:complainIDArray.count];
//            if([XYString isBlankString:content])
//            {
//                pushMsg.countMsg=[NSNumber numberWithInt:0];
//            }
            [UserDefaultsStorage saveData:pushMsg forKey:appDelegate.ComplainMsg];
        }
        
        THComplainDetailsViewController *detailsVC = [[THComplainDetailsViewController alloc]init];
        detailsVC.userComplaint = userComplaint;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.row == 1) {
        width = SCREEN_WIDTH/2-7;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
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
