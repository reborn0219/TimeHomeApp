//
//  L_TaskBoardListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_TaskBoardListViewController.h"
#import "L_TaskBoardSectionHeaderView.h"
#import "L_TaskBoardFirstTVC.h"
#import "L_HelpsViewController.h"
#import "L_NewBikeListViewController.h"
#import "PerfectInforVC.h"
#import "L_NewPointPresenters.h"
#import "RaiN_NewSigninPresenter.h"
#import "SigninPopVC.h"

#import "L_CommunityAuthoryPresenters.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"

#import "L_MyBikeListVC.h"

@interface L_TaskBoardListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) L_TaskBoardSectionHeaderView *sectionHeaderView;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *contentArr;
@property (nonatomic, strong) NSArray *countArr;
@property (nonatomic, strong) NSArray *buttonTitleArr;

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation L_TaskBoardListViewController

#pragma mark - 获得个人每日任务和首次任务状态列表
/**
 获得个人每日任务和首次任务状态列表
 */
- (void)httpRequestForGetTaskStateIsRefresh:(BOOL)isRefresh {
    
    if (!isRefresh) {
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    }
    [L_NewPointPresenters getTaskStateWithTypes:@"1,201,18,2,12,20,13" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!isRefresh) {
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            }else {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                _modelArray = [L_TaskModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":JiFen}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self httpRequestForGetTaskStateIsRefresh:NO];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:JiFen];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _titleArr = @[@[@"每日签到",@"发表帖子",@"分享帖子"],@[@"完善资料",@"完善二轮车防盗资料",@"新帖发布",@"查看新手指南"]];
//    _contentArr = @[@[@"总有些志趣相同的人在等你",@"让你的思想影响更多的人",@"好东西，怎能独享？"],@[@"我要交更多的朋友",@"二轮车更安全",@"新手报到快来混脸熟",@"小伙伴么是怎么使用的"]];
//    _countArr = @[@[@"+2",@"+2",@"+5"],@[@"+50",@"+50",@"+50",@"+30"]];
//    _buttonTitleArr = @[@[@"已完成",@"去发表",@"去分享"],@[@"去完善",@"去完善",@"去发表",@"去查看"]];
    
    _titleArr = @[@[@"每日签到",@"发表帖子",@"分享帖子"],@[@"社区认证",@"完善资料",@"完善二轮车防盗资料",@"新帖发布",@"查看新手指南"]];
    _contentArr = @[@[@"总有些志趣相同的人在等你",@"让你的思想影响更多的人",@"好东西，怎能独享？"],@[@"马上进行社区认证，享受认证业主特权",@"我要交更多的朋友",@"二轮车更安全",@"新手报到快来混脸熟",@"小伙伴么是怎么使用的"]];
    _countArr = @[@[@"+2",@"+2",@"+5"],@[@"+50",@"+50",@"+50",@"+50",@"+30"]];
    _buttonTitleArr = @[@[@"已完成",@"去发表",@"去分享"],@[@"去认证",@"去完善",@"去完善",@"去发表",@"去查看"]];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_TaskBoardFirstTVC" bundle:nil] forCellReuseIdentifier:@"L_TaskBoardFirstTVC"];
    
//    [self httpRequestForGetTaskStateIsRefresh:NO];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetTaskStateIsRefresh:YES];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    L_TaskBoardSectionHeaderView *sectionHeaderView = [L_TaskBoardSectionHeaderView getInstance];
    
    if (section == 0) {
        sectionHeaderView.sectionTitleLabel.text = @"每日任务";
    }else {
        sectionHeaderView.sectionTitleLabel.text = @"新手任务";
    }
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_TaskBoardFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_TaskBoardFirstTVC"];

    cell.topLabel.text = [XYString IsNotNull:_titleArr[indexPath.section][indexPath.row]];
    cell.bottomLabel.text = [XYString IsNotNull:_contentArr[indexPath.section][indexPath.row]];
    cell.countLabel.text = [XYString IsNotNull:_countArr[indexPath.section][indexPath.row]];
    cell.buttonBottomLabel.text = [XYString IsNotNull:_buttonTitleArr[indexPath.section][indexPath.row]];
    
    if (_modelArray.count > 0) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row > 0) {
                
                cell.model = _modelArray[indexPath.row];
                
            }else {
                
                L_TaskModel *taskModel = _modelArray[0];
                if (taskModel.isfinished.integerValue == 1) {
                    cell.buttonBgView.backgroundColor = NEW_GRAY_COLOR;
                    cell.buttonBottomLabel.text = @"已完成";
                }
                if (taskModel.isfinished.integerValue == 0) {
                    cell.buttonBgView.backgroundColor = NEW_BLUE_COLOR;
                    cell.buttonBottomLabel.text = @"去签到";
                }
                
                if (taskModel.type.integerValue == 1) {
                    if (![XYString isBlankString:taskModel.todayinte]) {
                        cell.countLabel.text = [NSString stringWithFormat:@"+%@",taskModel.todayinte];
                    }
                }
                
            }
            
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                L_TaskModel *taskModel = [[L_TaskModel alloc] init];
                taskModel.isfinished = @"0";
                cell.model = taskModel;
            }else {
                cell.model = _modelArray[indexPath.row+2];
            }
        }
    }
    
    cell.buttonDidTouchBlock = ^() {
      
        if (_modelArray.count > 0) {

            if (indexPath.section == 0) {
                
                if (indexPath.row == 0) {
                    //每日签到
                    L_TaskModel *taskModel = _modelArray[0];
                    if (taskModel.isfinished.integerValue == 1) {
                        return ;
                    }
                    if (taskModel.isfinished.integerValue == 0) {
                        //签到弹窗
//                        [self newSigninNet];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTaskBoardSign object:nil];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                    
                }
                if (indexPath.row == 1) {
                    //发表帖子
                    L_TaskModel *model = _modelArray[indexPath.row];

                    if (model.isfinished.integerValue == 0) {
                        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }else {
                        return;
                    }

                }
                if (indexPath.row == 2) {
                    //分享帖子
                    L_TaskModel *model = _modelArray[indexPath.row];
                    
                    if (model.isfinished.integerValue == 0) {
                        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }else {
                        return;
                    }

                }
                
            }
            if (indexPath.section == 1) {
                
                if (indexPath.row == 0) {
                    //社区认证
                    
                    AppDelegate *appDlgt = GetAppDelegates;
                    
                    THIndicatorVCStart
                    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:appDlgt.userData.communityid UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            THIndicatorVCStopAnimating
                            
                            if (resultCode == SucceedCode) {
                                
//                                NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                                
//                                if (isownercert.intValue == 1) {
//                                    
//                                    [self showToastMsg:@"当前社区已认证" Duration:3.0];
//                                    return ;
//                                    
//                                }else {
                                
                                    NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                                    NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                                    
                                    if (houseArr.count > 0) {
                                        
                                        //---有房产----
                                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                        L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                                        houseListVC.fromType = 6;
                                        houseListVC.houseArr = houseArr;
                                        houseListVC.carArr = carArr;
                                        houseListVC.communityID = appDlgt.userData.communityid;
                                        houseListVC.communityName = appDlgt.userData.communityname;
                                        [self.navigationController pushViewController:houseListVC animated:YES];
                                        
                                    }else {
                                        
                                        //---无房产----
                                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                                        L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                                        addVC.communityID = appDlgt.userData.communityid;
                                        addVC.communityName = appDlgt.userData.communityname;
                                        addVC.fromType = 6;
                                        [self.navigationController pushViewController:addVC animated:YES];
                                        
                                    }

//                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0];
                            }
                            
                        });
                        
                    }];
                    
                }
                
                if (indexPath.row == 1) {
                    //完善个人资料
                    L_TaskModel *model = _modelArray[indexPath.row+2];
                    
                    if (model.isfinished.integerValue == 0) {
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                        PerfectInforVC * regVC = [storyBoard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
                        regVC.fromVCType = 1;
                        [self.navigationController pushViewController:regVC animated:YES];
                    }else {
                        return;
                    }

                    
                }
                if (indexPath.row == 2) {
                    //完善二轮车防盗资料
                    L_TaskModel *model = _modelArray[indexPath.row+2];
                    
                    if (model.isfinished.integerValue == 0) {
                        
                        if (kIsNewBikeList == 1) {
                            
                            /** 自行车管理 */
                            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                            L_MyBikeListVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_MyBikeListVC"];
                            pmvc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:pmvc animated:YES];
                            
                        }else {
                            
                            /** 自行车管理 */
                            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                            L_NewBikeListViewController *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeListViewController"];
                            pmvc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:pmvc animated:YES];
                            
                        }

                        
                    }else {
                        return;
                    }


                }
                if (indexPath.row == 3) {
                    //新帖发布
                    L_TaskModel *model = _modelArray[indexPath.row+2];
                    
                    if (model.isfinished.integerValue == 0) {
                        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }else {
                        return;
                    }

                }
                
                if (indexPath.row == 4) {
                    //查看新手指南
                    L_TaskModel *model = _modelArray[indexPath.row+2];
                    
                    if (model.isfinished.integerValue == 0) {
                        /** 帮助意见与反馈 */
                        L_HelpsViewController *helpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_HelpsViewController"];
                        [helpVC setHidesBottomBarWhenPushed:YES];
                        
                        [self.navigationController pushViewController:helpVC animated:YES];
                    }else {
                        return;
                    }

                }
            }

        }
        
    };
    
    return cell;
    
}

//MARK: - ------------新版本签到相关
//- (void)newSigninNet {
//    
//    [RaiN_NewSigninPresenter getUserSignWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if(resultCode==SucceedCode)
//            {
//                NSDictionary *dic = data[@"map"];
//                
//                SigninPopVC * shareSigninPopVC =  [SigninPopVC shareSigninPopVC];
//                [shareSigninPopVC showInVC:self with:dic];
//                shareSigninPopVC.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
//                    
//                    NSNumber * datanum = data;
//                    NSLog(@"__%d___",datanum.boolValue);
//                    if (datanum.boolValue==NO) {
//                        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//                        [userDefaults setObject:@"1" forKey:@"isSignup"];//设置签到状态为1
//                        [userDefaults synchronize];
//                        
//                        [_tableView.mj_header beginRefreshing];
//                    }
//                    
//                };
//            }else {
//                
//            }
//        });
//    }];
//}

@end
