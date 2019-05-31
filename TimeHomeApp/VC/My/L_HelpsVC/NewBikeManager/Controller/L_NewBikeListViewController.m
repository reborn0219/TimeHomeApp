//
//  L_NewBikeListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeListViewController.h"
#import "L_NewAddBikesViewController.h"
#import "L_NewBikeInfoViewController.h"

#import "L_BikeManagerPresenter.h"

#import "L_BikeManagerListTVC.h"

@interface L_NewBikeListViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 列表和数据源
 */
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation L_NewBikeListViewController

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
                
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 列表请求
- (void)httpRequestForList {
    
    _tableView.hidden = NO;
    [L_BikeManagerPresenter getBikeListUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
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
                
                [self noData];
                
            }else {
                /**
                 导航右按钮
                 */
                UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加二轮车" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
                rightButtonItem.tintColor = NEW_RED_COLOR;
                self.navigationItem.rightBarButtonItem = rightButtonItem;
                
                self.nothingnessView.hidden = YES;
            }
            
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;

    _dataSource = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [_tableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZXCFD];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZXCFD}];
}
/**
 没有数据情况
 */
- (void)noData {
    
    /**
     导航右按钮
     */
    self.navigationItem.rightBarButtonItem = nil;
    _tableView.hidden = YES;
    
    [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有添加二轮车，请先添加二轮车" SubMsg:@"" btnTitle:@"添加二轮车" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
        if (index == 0) {
            L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
            newAddBikesVC.completeBlock = ^{
                [_tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:newAddBikesVC animated:YES];
        }
        
    }];

    [self.view sendSubviewToBack:self.nothingnessView];

}

#pragma mark ------ 创建列表和数据源
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, SCREEN_HEIGHT - 16 - (44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_BikeManagerListTVC" bundle:nil] forCellReuseIdentifier:@"L_BikeManagerListTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForList];
    }];
    
}

#pragma mark --- 列表协议  UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BikeManagerListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BikeManagerListTVC"];

    L_BikeListModel *bikeModel = _dataSource[indexPath.section];
    cell.bikeModel = bikeModel;
    
    cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex) {
      //1.修改信息 2.锁定 3.添加感应条码 4.跳转详情
        NSLog(@"buttonIndex====%ld",(long)buttonIndex);
        
        if (buttonIndex == 1) {
            
            L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
            newAddBikesVC.isFromEditing = YES;
            newAddBikesVC.bikeListModel = bikeModel;
            newAddBikesVC.completeBlock = ^{
                [_tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:newAddBikesVC animated:YES];
            
        }
        
        if (buttonIndex == 2) {
            
            NSString *lockState = @"0";
            if (bikeModel.islock.integerValue == 1) {
                lockState = @"0";
            }
            if (bikeModel.islock.integerValue == 0) {
                lockState = @"1";
            }
            
            [self httpRequestForModel:bikeModel lockState:lockState indexPath:indexPath];
        }
        
        if (buttonIndex == 3) {
            
            L_NewAddBikesViewController *newAddBikesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewAddBikesViewController"];
            newAddBikesVC.isFromEditing = YES;
            newAddBikesVC.bikeListModel = bikeModel;
            newAddBikesVC.completeBlock = ^{
                [_tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:newAddBikesVC animated:YES];
            
        }
        
        if (buttonIndex == 4) {
            
            L_NewBikeInfoViewController *newInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
            newInfo.theID = bikeModel.theID;
            [self.navigationController pushViewController:newInfo animated:YES];
        }
        
    };

    return cell;
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

        CommonAlertVC *alertVC = [CommonAlertVC getInstance];
        [alertVC ShowAlert:self Title:@"删除二轮车" Msg:@"是否确定删除二轮车?" oneBtn:@"取消" otherBtn:@"确定"];

        alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
            
            if (index == 1000) {
                //确定
                
                L_BikeListModel *bikeModel = _dataSource[indexPath.section];
                
                if (bikeModel.islock.integerValue == 1) {
                    //已锁定 自行车是否锁定：0否1是
                    [self showToastMsg:@"已锁定车辆不能删除" Duration:3.0];
                    return ;
                }
                
                [self httpRequestForDeleteBikeWithID:bikeModel.theID withCallBack:^{
                   
                    [_dataSource removeObjectAtIndex:indexPath.section];
                    if (_dataSource.count <= 0) {
                        [self noData];
                    }
                    
                    [_tableView reloadData];
                    NSLog(@"删除");
                    
                }];
                

            }
            
        };
        
    }];
    
    deleBtn.backgroundColor = NEW_RED_COLOR;
    NSArray *arr = @[deleBtn];
    
    return arr;
    
}
#pragma mark - iOS11 新增左右侧滑方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        
        @WeakObj(self);
        
        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            [alertVC ShowAlert:self Title:@"删除二轮车" Msg:@"是否确定删除二轮车?" oneBtn:@"取消" otherBtn:@"确定"];
            
            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                
                if (index == 1000) {
                    //确定
                    
                    L_BikeListModel *bikeModel = _dataSource[indexPath.section];
                    
                    if (bikeModel.islock.integerValue == 1) {
                        //已锁定 自行车是否锁定：0否1是
                        [self showToastMsg:@"已锁定车辆不能删除" Duration:3.0];
                        return ;
                    }
                    
                    [selfWeak httpRequestForDeleteBikeWithID:bikeModel.theID withCallBack:^{
                        
                        [_dataSource removeObjectAtIndex:indexPath.section];
                        if (_dataSource.count <= 0) {
                            [selfWeak noData];
                        }
                        
                        [_tableView reloadData];
                        NSLog(@"删除");
                        
                    }];
                    
                    
                }
                
            };
            
        }];
        
        //        deleteRowAction.image = [UIImage imageNamed:@"删除图标"];
        deleteRowAction.backgroundColor = NEW_RED_COLOR;
        
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
        [_tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:newAddBikesVC animated:YES];

}
@end
