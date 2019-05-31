//
//  L_BBSVisitorsListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BBSVisitorsListViewController.h"
#import "L_BBSVisitorListTVC.h"
#import "BBSMainPresenters.h"

#import "personListViewController.h"

@interface L_BBSVisitorsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@end

@implementation L_BBSVisitorsListViewController

// MARK: - 删除所有访客用户信息
- (void)httpRequestForDeleteAllUser {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters deleteAllAccessUserInfoUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                [_dataArray removeAllObjects];
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

// MARK: - 删除访客用户信息
/**
 删除访客用户信息

 @param userid 用户id
 */
- (void)httpRequestForDeleteUserWithAccessid:(NSString *)accessid withIndex:(NSInteger)index {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

    [BBSMainPresenters deleteAccessUserWithAccessid:accessid UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                
                [_dataArray removeObjectAtIndex:index];
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
    }];
    
}

// MARK: - 获得访客用户信息
- (void)httpRequestForAccessUserInfoIsRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        _page = 1;
    }else {
        _page ++;
    }
    [BBSMainPresenters getAccessUserInfoWithUserid:_userid page:[NSString stringWithFormat:@"%ld",(long)_page] UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if (isRefresh) {
                    [_dataArray removeAllObjects];
                }
                
                if (((NSArray *)data).count > 0) {
                    [_dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                }
                
            }else {
                
                if (isRefresh) {
                    _page = 1;
                }else {
                    _page --;
                }
                
                [self showToastMsg:data Duration:3.0];
            }
            
        });

        
    }];

}

// MARK: - 清空
- (void)deleteAllInfoButtonDidTouch:(UIBarButtonItem *)sender {
    
    NSLog(@"清空");
    
    if (_dataArray.count == 0) {
        return;
    }
    
    CommonAlertVC *alertVC = [CommonAlertVC getInstance];
    [alertVC ShowAlert:self Title:@"提 示" Msg:@"确定要清空当前访客的数据吗?" oneBtn:@"取消" otherBtn:@"确定"];
    
    alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
        
        if (index == 1000) {
            //确定
            [self httpRequestForDeleteAllUser];
            
        }
        
    };

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _page = 1;
    
    AppDelegate *appDlgt = GetAppDelegates;
    if ([appDlgt.userData.userID isEqualToString:_userid]) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllInfoButtonDidTouch:)];
        _rightBarButton.tintColor = kNewRedColor;
        self.navigationItem.rightBarButtonItem = _rightBarButton;
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    _dataArray = [[NSMutableArray alloc] init];
    _tableView.backgroundColor = CLEARCOLOR;

    [_tableView registerNib:[UINib nibWithNibName:@"L_BBSVisitorListTVC" bundle:nil] forCellReuseIdentifier:@"L_BBSVisitorListTVC"];
    
    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForAccessUserInfoIsRefresh:YES];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForAccessUserInfoIsRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = CLEARCOLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BBSVisitorListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BBSVisitorListTVC"];

    L_BBSVisitorsModel *model = _dataArray[indexPath.section];
    cell.model = model;
    
    cell.headerDidTouchBlock = ^() {
      
        if ([XYString isBlankString:model.userid]) {
            return;
        }
        
        //点赞头像点击
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:model.userid];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];
        
    };
    
    return cell;
}

// MARK: - 兼容iOS 8方法需加上
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { }
// MARK: - Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDlgt = GetAppDelegates;
    if ([appDlgt.userData.userID isEqualToString:_userid]) {
        return YES;
    }else {
        return NO;
    }

}
// MARK: - 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// MARK: - 自定义左滑显示编辑按钮
- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        CommonAlertVC *alertVC = [CommonAlertVC getInstance];
        [alertVC ShowAlert:self Title:@"提 示" Msg:@"确定要删除当前访客的数据吗?" oneBtn:@"取消" otherBtn:@"确定"];
        
        alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index )  {
            
            if (index == 1000) {
                //确定
                L_BBSVisitorsModel *model = _dataArray[indexPath.section];
                
                [self httpRequestForDeleteUserWithAccessid:model.accessid withIndex:indexPath.section];
                
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
            [alertVC ShowAlert:self Title:@"提 示" Msg:@"确定要删除当前访客的数据吗?" oneBtn:@"取消" otherBtn:@"确定"];
            
            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index )  {
                
                if (index == 1000) {
                    //确定
                    L_BBSVisitorsModel *model = _dataArray[indexPath.section];
                    
                    [selfWeak httpRequestForDeleteUserWithAccessid:model.accessid withIndex:indexPath.section];
                    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BBSVisitorsModel *model = _dataArray[indexPath.section];

    if ([XYString isBlankString:model.userid]) {
        return;
    }
    
    //点赞头像点击
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:model.userid];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
    
}


@end
