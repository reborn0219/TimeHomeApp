//
//  L_BikeWarningRecordVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeWarningRecordVC.h"
#import "L_NewBikeInfoViewController.h"
#import "ContactServiceVC.h"
#import "L_BikeWarningTVC.h"

#import "L_BikeManagerPresenter.h"
#import "L_PopAlertView4.h"

@interface L_BikeWarningRecordVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger page;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 联系物业背景view
 */
@property (weak, nonatomic) IBOutlet UIView *contactPropertyBgView;

@end

@implementation L_BikeWarningRecordVC

#pragma mark - 删除二轮车警报记录

- (void)httpRequestForRemoveUserBikeAlermWithModel:(L_BikeAlermModel *)model {
    
    if ([XYString isBlankString:model.theID]) {
        return;
    }
    
    THIndicatorVCStart
    
    [L_BikeManagerPresenter removeUserBikeAlermWithID:model.theID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                [_dataArray removeObject:model];
                [_tableView reloadData];
                
                if (_dataArray.count == 0) {
                    
                    _contactPropertyBgView.hidden = YES;
                    
                    @WeakObj(self)
                    [_tableView showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有任何二轮车警报记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                        
                        [selfWeak.tableView hiddenNothingView];
                        [selfWeak httpRequestForWarningListRefresh:YES];
                        
                    }];
                    
                }else {
                    _contactPropertyBgView.hidden = NO;
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

#pragma mark - 报警记录列表

- (void)httpRequestForWarningListRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        THIndicatorVCStart
    }
    
    [L_BikeManagerPresenter getUserBikeAlermWith:_page UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isRefresh) {
                THIndicatorVCStopAnimating
            }

            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {

                if (_page == 1) {
                    [_dataArray removeAllObjects];
                }
                
                [_dataArray addObjectsFromArray:data];
                
                [_tableView reloadData];
                
            }else {
                
                if (_page > 1) {
                    _page--;
                }
                
                //[self showToastMsg:data Duration:3.0];
            }
            
            if (_dataArray.count == 0) {
                
                _contactPropertyBgView.hidden = YES;
                
                @WeakObj(self)
                [_tableView showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有任何二轮车警报记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    [selfWeak.tableView hiddenNothingView];
                    [selfWeak httpRequestForWarningListRefresh:YES];
                    
                }];
                
            }else {
                _contactPropertyBgView.hidden = NO;
            }
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [TalkingData trackPageBegin:@"biyclealert"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [TalkingData trackPageEnd:@"biyclealert"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _contactPropertyBgView.hidden = YES;

    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_BikeWarningTVC" bundle:nil] forCellReuseIdentifier:@"L_BikeWarningTVC"];

    _tableView.estimatedRowHeight = 100;
    
    @WeakObj(self)
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        
        selfWeak.page = 1;
        [selfWeak.tableView hiddenNothingView];
        [selfWeak httpRequestForWarningListRefresh:NO];
        
    }];
    
    _tableView.mj_footer = [MJTimeHomeGifFooter footerWithRefreshingBlock:^{
        
        selfWeak.page ++;
        [selfWeak httpRequestForWarningListRefresh:NO];
        
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
    [self httpRequestForWarningListRefresh:YES];
    
}

#pragma mark - 联系物业

- (IBAction)contactPorpertyBtnClick:(UIButton *)sender {
    
    NSLog(@"联系物业");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    ContactServiceVC * contactsVC = [storyboard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
    [self.navigationController pushViewController:contactsVC animated:YES];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
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
    
    L_BikeAlermModel *model = _dataArray[indexPath.section];

    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_BikeWarningTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BikeWarningTVC"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > 0) {
        L_BikeAlermModel *model = _dataArray[indexPath.section];
        cell.model = model;
    }
    
    return cell;
    
}

// MARK: - 兼容iOS 8方法需加上
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { }

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    /**
     删除按钮事件
     */
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删 除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        L_PopAlertView4 *popVC = [L_PopAlertView4 getInstance];
        [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            if (index == 1) {
                
                L_BikeAlermModel *model = _dataArray[indexPath.section];
                [self httpRequestForRemoveUserBikeAlermWithModel:model];
                
            }
            
        }];
        popVC.title_Label.text = @"确定要删除此条记录吗？";
        popVC.title_Label.font = DEFAULT_FONT(16);
        [popVC.left_Btn setTitle:@"确定" forState:UIControlStateNormal];
        
    }];
    action1.backgroundColor = kNewRedColor;

    return @[action1];
}

#pragma mark - iOS11 新增左右侧滑方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        
        @WeakObj(self);
        
        //删除
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删 除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            L_PopAlertView4 *popVC = [L_PopAlertView4 getInstance];
            [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                if (index == 1) {
                    
                    L_BikeAlermModel *model = _dataArray[indexPath.section];
                    [selfWeak httpRequestForRemoveUserBikeAlermWithModel:model];
                    
                }
                
            }];
            popVC.title_Label.text = @"确定要删除此条记录吗？";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_BikeAlermModel *model = _dataArray[indexPath.section];

    L_NewBikeInfoViewController *bikeInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeInfoViewController"];
    bikeInfoVC.hidesBottomBarWhenPushed = YES;
    
    bikeInfoVC.theID = model.theID;
    bikeInfoVC.bikeID = model.bikeid;
    bikeInfoVC.bikeListType = @"0";
    [self.navigationController pushViewController:bikeInfoVC animated:YES];
    
}



@end
