//
//  L_NewBikeSharedViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeSharedViewController.h"
#import "L_SharedListFirstTVC.h"
#import "L_SharedListSecondTVC.h"

#import "L_NewBikeInfoShowViewController.h"
#import "L_NewBikeAddShowViewController.h"

#import "L_BikeManagerPresenter.h"

@interface L_NewBikeSharedViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation L_NewBikeSharedViewController

// MARK: - 取消共享
- (void)httpRequestForDeleteWithID:(NSString *)theID {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_BikeManagerPresenter delshareBikeInfoWithID:theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if (resultCode == SucceedCode) {
                
                [_tableView.mj_header beginRefreshing];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
           
            
        });
        
    }];
    
}

// MARK: - 分享列表请求
- (void)httpRequestForShareListWithID:(NSString *)theID {
    
    [L_BikeManagerPresenter getShareListWithID:theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:data];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            [_tableView reloadData];
            
        });
        
    }];
    
}

// MARK: - 添加共享人名称手机号
- (void)httpRequestForShareBikeWithID:(NSString *)theID name:(NSString *)name phone:(NSString *)phone {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_BikeManagerPresenter shareBikeInfoWithID:theID mobilephone:phone sharename:name UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                [self showToastMsg:data[@"errmsg"] Duration:3.0];
                
                [_tableView.mj_header beginRefreshing];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];

    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;

    [_tableView registerNib:[UINib nibWithNibName:@"L_SharedListFirstTVC" bundle:nil] forCellReuseIdentifier:@"L_SharedListFirstTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_SharedListSecondTVC" bundle:nil] forCellReuseIdentifier:@"L_SharedListSecondTVC"];

    @WeakObj(self)
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForShareListWithID:_bikeID];
    }];
    
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
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == _dataArray.count) {
        return 66;
    }else {
        return 114;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == _dataArray.count) {
        
        L_SharedListSecondTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_SharedListSecondTVC"];
        
        
        return cell;
        
    }else {
        
        L_SharedListFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_SharedListFirstTVC"];
        
        if (_dataArray.count > 0) {
            
            L_BikeShareInfoModel *shareModel = _dataArray[indexPath.section];
            cell.shareModel = shareModel;
            
            cell.deleteButtonTouchBlock = ^(){
                
                NSLog(@"删除====%ld",(long)indexPath.section);
                
                CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                [alertVC ShowAlert:self Title:@"提  示" Msg:[NSString stringWithFormat:@"确定要删除%@的二轮车的共享权限吗？",shareModel.sharename] oneBtn:@"取消" otherBtn:@"确定"];
                
                alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
                    
                    if (index == 1000) {
                        //确定
                        [self httpRequestForDeleteWithID:shareModel.theID];
                        
                    }
                    
                };
                
            };
            
        }
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == _dataArray.count) {
        
        L_NewBikeAddShowViewController *addVC = [L_NewBikeAddShowViewController getInstance];
        [addVC showVC:self cellEvent:^(NSString *peopleName, NSString *peoplePhoneNum) {
           
            NSLog(@"peopleName==%@===peoplePhoneNum===%@",peopleName,peoplePhoneNum);
            
            [self httpRequestForShareBikeWithID:_bikeID name:peopleName phone:peoplePhoneNum];
            
        }];
    }
}

/**
 右上角共享说明按钮
 */
- (IBAction)sharedDocButtonDidTouch:(UIBarButtonItem *)sender {
    NSLog(@"共享说明");
    L_NewBikeInfoShowViewController *showVC = [L_NewBikeInfoShowViewController getInstance];
    [showVC showVC:self withInfo:@"共享后的用户可以在本社区锁定和解锁二轮车" cellEvent:^{
        
    }];
    
}

@end
