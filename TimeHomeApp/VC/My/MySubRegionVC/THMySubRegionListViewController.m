//
//  THMySubRegionListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMySubRegionListViewController.h"
#import "THBaseTableViewCell.h"
#import "THMySubRegionListTVC.h"

#import "THOwnerAuthViewController.h"

#import "UserCommunity.h"
#import "UserCertlistModel.h"
/**
 *  网络请求
 */
#import "CommunityManagerPresenters.h"

@interface THMySubRegionListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *sectionTitles;
    NSMutableArray *dataArray;//模拟数据
    /**
     *  当前社区
     */
    UserCommunity *user;
    /**
     *  已认证社区集合数组
     */
    NSMutableArray *certlistArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMySubRegionListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self httpRequest];
//    [TalkingData trackPageBegin:@"xiaoqu"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:XiaoQu];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"xiaoqu"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":XiaoQu}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"社区认证";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    sectionTitles = @[@"当前小区",@"已认证小区"];
    certlistArray = [[NSMutableArray alloc]init];

    [self createTableView];
}
/**
 *  我的小区列表请求
 */
- (void)httpRequest {
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CommunityManagerPresenters getUserCommunityUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                
                user = [UserCommunity mj_objectWithKeyValues:[dict objectForKey:@"current"]];
                [certlistArray removeAllObjects];
                NSArray *array = [UserCertlistModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"certlist"]];
                [certlistArray addObjectsFromArray:array];
                [selfWeak.tableView reloadData];
            }
            
        });
        
    }];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    [_tableView registerClass:[THMySubRegionListTVC class] forCellReuseIdentifier:NSStringFromClass([THMySubRegionListTVC class])];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (certlistArray.count == 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        if (certlistArray.count > 0) {
            return certlistArray.count + 1;
        }else {
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 45;
    }else {
        if (indexPath.section == 0) {
            return [self.tableView cellHeightForIndexPath:indexPath model:user keyPath:@"user" cellClass:[THMySubRegionListTVC class] contentViewWidth:[self cellContentViewWith]];
        }else {
            UserCertlistModel *certlistModel = certlistArray[indexPath.row-1];
            return [self.tableView cellHeightForIndexPath:indexPath model:certlistModel keyPath:@"certlistModel" cellClass:[THMySubRegionListTVC class] contentViewWidth:[self cellContentViewWith]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseTableViewCellStyle = BaseTableViewCellStyleValue2;
    cell.leftLabel.text = sectionTitles[indexPath.section];
    
    
    if (indexPath.row > 0) {
        THMySubRegionListTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMySubRegionListTVC class])];

        if (indexPath.section == 0) {
            
            cell.user = user;
            
        }else {
            UserCertlistModel *certlistModel = certlistArray[indexPath.row-1];
            cell.certlistModel = certlistModel;
        }

        return cell;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            if (user.iscert.boolValue == NO) {
                if (user.certstate.intValue == 0) {
                    [self showToastMsg:@"正在审核您的业主身份，请耐心等待~" Duration:3.0];
                    return;
                }else {
                    
                    if (user.certstate.intValue == 2) {
                        [self showToastMsg:@"认证失败，请重新填写认证信息" Duration:2.0];
                    }
                    
                    THOwnerAuthViewController *ownerVC = [[THOwnerAuthViewController alloc]init];
                    ownerVC.user = user;
                    [self.navigationController pushViewController:ownerVC animated:YES];
                }

            }
        }
    }else {
        
        if (indexPath.row != 0) {
            
            @WeakObj(self);
            /**
             *  切换社区
             */
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            UserCertlistModel *certlistModel = certlistArray[indexPath.row-1];
            
            [CommunityManagerPresenters changeCommunityCommunityid:certlistModel.theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(resultCode == SucceedCode)
                    {
                       
                        AppDelegate * appdgt=GetAppDelegates;
                        appdgt.userData.communityname=certlistModel.name;
                        appdgt.userData.communityid=certlistModel.theID;
                        appdgt.userData.communityaddress=certlistModel.address;

                        [CommunityManagerPresenters getUserCommunityUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [indicator stopAnimating];
                                if(resultCode == SucceedCode)
                                {
                    
                                     NSDictionary *dict = (NSDictionary *)data;
                                    user = [UserCommunity mj_objectWithKeyValues:[dict objectForKey:@"current"]];
                                    [certlistArray removeAllObjects];
                                    NSArray *array = [UserCertlistModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"certlist"]];
                                    [certlistArray addObjectsFromArray:array];
                                    [selfWeak.tableView reloadData];
                                }
                                
                            });
                            
                        }];
                        
                    }
                    else
                    {
                        [indicator stopAnimating];
                        [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                    }
                    
                });
                
            }];

        }
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.section == 0 && indexPath.row == 1) {
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




@end
