//
//  L_MyBikeListVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyBikeListVC.h"
#import "L_NewBikeInfoViewController.h"

#import "L_BikeManagerPresenter.h"

#import "L_MyBikeListTVC.h"
#import "L_NewAddBikesViewController.h"
#import "L_PopAlertView4.h"
#import "L_GarageTimeSetInfoViewController.h"

@interface L_MyBikeListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation L_MyBikeListVC

// MARK: - 删除二轮车请求
- (void)httpRequestForDeleteBikeWithID:(NSString *)theID withCallBack:(void(^)())callBack {
    
    if ([XYString isBlankString:theID]) {
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_BikeManagerPresenter deleteBikeWithID:theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                if (callBack) {
                    callBack();
                }
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 锁定，解锁请求
- (void)httpRequestForModel:(L_BikeListModel *)model lockState:(NSString *)state indexPath:(NSIndexPath *)indexPath {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    @WeakObj(self);
    /** 锁车状态：0否1是 */
    [L_BikeManagerPresenter setLockWithID:model.theID islock:state UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                model.islock = state;
                
                if (state.integerValue == 1) {
                    if (data[@"map"]) {
                        model.parklotname = [XYString IsNotNull:data[@"map"][@"parklotname"]];
                        model.communitynamelock = [XYString IsNotNull:data[@"map"][@"communityname"]];
                        
                        
                    }
                }else {
                    model.parklotname = @"";
                }
                
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                
                [selfWeak playSoundForLockCarOrNot];
                
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 列表请求
- (void)httpRequestForListIsRefresh:(BOOL)isRefresh {

    if (isRefresh) {
        THIndicatorVCStart
    }
    
    [L_BikeManagerPresenter getBikeListUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isRefresh) {
                THIndicatorVCStopAnimating
            }
            
            if (resultCode == SucceedCode) {
                
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:data];
                
            }else {
                
                [self showToastMsg:data Duration:3.0];
                
            }
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            [_tableView reloadData];
            
            if (_dataSource.count == 0) {
                
                [_tableView showNothingnessViewWithType:NoContentTypeBikeManager Msg:@"您还没有添加过任何二轮车" SubMsg:@"" btnTitle:@"添加二轮车" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                   
                    if (index == 0) {
                        //添加二轮车
                        L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
                        newAddBikesVC.isFromEditing = NO;
                    
                        newAddBikesVC.completeBlock = ^{
                            [_tableView hiddenNothingView];
                            [self httpRequestForListIsRefresh:YES];
                        };
                        
                        [self.navigationController pushViewController:newAddBikesVC animated:YES];
                    }
                    
                }];
                
            }
            
        });
        
    }];
    
}


/**
 *  锁车解锁声音
 */
- (void)playSoundForLockCarOrNot {
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_MyBikeListTVC" bundle:nil] forCellReuseIdentifier:@"L_MyBikeListTVC"];
    
    _dataSource = [[NSMutableArray alloc] init];

    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak.tableView hiddenNothingView];
        [selfWeak httpRequestForListIsRefresh:NO];
    }];
    
    [self httpRequestForListIsRefresh:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZXCFD];
    
//    [TalkingData trackPageBegin:@"biycleymanager"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZXCFD}];
    
//    [TalkingData trackPageEnd:@"biycleymanager"];
}

#pragma mark - 初始化配置

- (void)setup {
    
    if (_fromType == 1) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
    /**
     导航右按钮
     */
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"二轮车优化-添加"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
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
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_MyBikeListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_MyBikeListTVC"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    L_BikeListModel *bikeModel = _dataSource[indexPath.section];
    cell.model = bikeModel;
    
    cell.btnDidClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
      
        /** 感应条码 */
        if (bikeModel.device.count == 0) {
            //index 1.左边 2.中间 3.右边
            //感应条码
            if (index == 1) {
                
                //修改
                L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
                newAddBikesVC.isFromEditing = YES;
                newAddBikesVC.bikeListModel = bikeModel;
                newAddBikesVC.completeBlock = ^{
                    [self httpRequestForListIsRefresh:YES];
                };
                newAddBikesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newAddBikesVC animated:YES];
                
            }else {
                [self showToastMsg:@"您尚未添加感应条码，无法锁定车辆" Duration:3.0];
            }
            
        }else {
            
            if (index == 1) {
                //修改
                L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
                newAddBikesVC.isFromEditing = YES;
                newAddBikesVC.bikeListModel = bikeModel;
                newAddBikesVC.completeBlock = ^{
                    [self httpRequestForListIsRefresh:YES];
                };
                newAddBikesVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newAddBikesVC animated:YES];
                
            }
            
            if (index == 2) {
                
                /** 自行车是否锁定：0否1是 */
                NSString *lockState = @"0";
                if (bikeModel.islock.integerValue == 1) {
                    lockState = @"0";
                }
                if (bikeModel.islock.integerValue == 0) {
                    lockState = @"1";
                }
                
                [self httpRequestForModel:bikeModel lockState:lockState indexPath:indexPath];
                
            }
            
            if (index == 3) {
                //定时锁车
                UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                L_GarageTimeSetInfoViewController *timeInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"L_GarageTimeSetInfoViewController"];
                timeInfoVC.bikeID = bikeModel.theID;
                timeInfoVC.isFromBike = YES;
                [self.navigationController pushViewController:timeInfoVC animated:YES];
                
            }
 
        }

        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BikeListModel *bikeModel = _dataSource[indexPath.section];

    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
    L_NewBikeInfoViewController *newInfo = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
    newInfo.theID = bikeModel.theID;
    newInfo.bikeListType = @"1";
    newInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newInfo animated:YES];
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

// MARK: - Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// MARK: - 自定义左滑显示编辑按钮
- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        L_PopAlertView4 *popVC = [L_PopAlertView4 getInstance];
        [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
           
            if (index == 1) {
                
                L_BikeListModel *bikeModel = _dataSource[indexPath.section];
                
                if (bikeModel.islock.integerValue == 1) {
                    //已锁定 自行车是否锁定：0否1是
                    [self showToastMsg:@"已锁定车辆不能删除" Duration:3.0];
                    return ;
                }
                
                [self httpRequestForDeleteBikeWithID:bikeModel.theID withCallBack:^{
                    
                    [_dataSource removeObjectAtIndex:indexPath.section];
                    [_tableView reloadData];
                    
                    if (_dataSource.count == 0) {
                        
                        [_tableView showNothingnessViewWithType:NoContentTypeBikeManager Msg:@"您还没有添加过任何二轮车" SubMsg:@"" btnTitle:@"添加二轮车" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                            
                            if (index == 0) {
                                //添加二轮车
                                L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
                                newAddBikesVC.isFromEditing = NO;
                                
                                newAddBikesVC.completeBlock = ^{
                                    [_tableView hiddenNothingView];
                                    [self httpRequestForListIsRefresh:YES];
                                };
                                
                                [self.navigationController pushViewController:newAddBikesVC animated:YES];
                            }
                            
                        }];
                        
                    }
                    
                    NSLog(@"删除");
                    
                }];
                
            }
            
        }];
        popVC.title_Label.text = @"是否确定删除二轮车?";
        popVC.title_Label.font = DEFAULT_FONT(16);
        [popVC.left_Btn setTitle:@"确定" forState:UIControlStateNormal];

    }];
    
    deleBtn.backgroundColor = NEW_RED_COLOR;
    NSArray *arr = @[deleBtn];
    
    return arr;
    
}

#pragma mark - iOS11 新增左右侧滑方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        
        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            L_PopAlertView4 *popVC = [L_PopAlertView4 getInstance];
            [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                if (index == 1) {
                    
                    L_BikeListModel *bikeModel = _dataSource[indexPath.section];
                    
                    if (bikeModel.islock.integerValue == 1) {
                        //已锁定 自行车是否锁定：0否1是
                        [self showToastMsg:@"已锁定车辆不能删除" Duration:3.0];
                        return ;
                    }
                    
                    [self httpRequestForDeleteBikeWithID:bikeModel.theID withCallBack:^{
                        
                        [_dataSource removeObjectAtIndex:indexPath.section];
                        [_tableView reloadData];
                        
                        if (_dataSource.count == 0) {
                            
                            [_tableView showNothingnessViewWithType:NoContentTypeBikeManager Msg:@"您还没有添加过任何二轮车" SubMsg:@"" btnTitle:@"添加二轮车" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                
                                if (index == 0) {
                                    //添加二轮车
                                    L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
                                    newAddBikesVC.isFromEditing = NO;
                                    
                                    newAddBikesVC.completeBlock = ^{
                                        [_tableView hiddenNothingView];
                                        [self httpRequestForListIsRefresh:YES];
                                    };
                                    
                                    [self.navigationController pushViewController:newAddBikesVC animated:YES];
                                }
                                
                            }];
                            
                        }
                        
                        NSLog(@"删除");
                        
                    }];
                    
                }
                
            }];
            popVC.title_Label.text = @"是否确定删除二轮车?";
            popVC.title_Label.font = DEFAULT_FONT(16);
            [popVC.left_Btn setTitle:@"确定" forState:UIControlStateNormal];
            
        }];
        
        //        deleteRowAction.image = [UIImage imageNamed:@"删除图标"];
        deleteRowAction.backgroundColor = kNewRedColor;
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
        
        return config;
        
        
    }else {
        return nil;
    }
    
};

#else

#endif

// MARK: - 导航右按钮
- (void)rightItemClick:(UIBarButtonItem *)item {
    
    L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
    newAddBikesVC.isFromEditing = NO;
    
    newAddBikesVC.completeBlock = ^{
        [_tableView hiddenNothingView];
        [self httpRequestForListIsRefresh:YES];
    };
    
    [self.navigationController pushViewController:newAddBikesVC animated:YES];
    
}

@end
