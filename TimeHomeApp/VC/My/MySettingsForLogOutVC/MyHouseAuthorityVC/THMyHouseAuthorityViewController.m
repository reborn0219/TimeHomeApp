//
//  THMyHouseAuthorityViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyHouseAuthorityViewController.h"
#import "THHouseAuthoriedTVC.h"
#import "THHouseAuthorityDetailsTVC.h"
#import "THHouseAuthoriedTVC1.h"
#import "THCarAuthoriedDetailsTVC.h"
#import "THCarAuthoriedTVC2.h"
#import "THCarAuthoriedDetailsTVC2.h"

#import "THHouseReletViewController.h"
#import "THHouseAuthorityViewController.h"

/**
 *  网络请求
 */
#import "CommunityManagerPresenters.h"
#import "LogInPresenter.h"
//#import "SysPresenter.h"
//#import "RegularUtils.h"

@interface THMyHouseAuthorityViewController () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  请求数据
     */
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMyHouseAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的房产";
    dataArray = [[NSMutableArray alloc]init];
//    [self httpRequest];
    
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView.mj_header beginRefreshing];

}
/**
 *  我的房产权限列表请求
 */
- (void)httpRequest {
    
    [CommunityManagerPresenters getOwnerResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if(resultCode == SucceedCode)
            {
                [dataArray removeAllObjects];
                [dataArray addObjectsFromArray:(NSArray *)data];
                [self.tableView reloadData];
            }
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeHouseManager Msg:@"您还没有被授权的房产" eventCallBack:nil];
            }
        });
        
    }];

}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.tableFooterView = [[UIView alloc]init];

    [_tableView registerClass:[THHouseAuthoriedTVC1 class] forCellReuseIdentifier:NSStringFromClass([THHouseAuthoriedTVC1 class])];
    [_tableView registerClass:[THCarAuthoriedDetailsTVC class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC class])];
    [_tableView registerClass:[THCarAuthoriedTVC2 class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedTVC2 class])];
    [_tableView registerClass:[THCarAuthoriedDetailsTVC2 class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC2 class])];

    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequest];
    }];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OwnerResidence *owner = dataArray[section];
    if ([owner.type intValue] == 0) {
        return 1;
    }else if ([owner.type intValue] == 1) {
        return owner.userlist.count + 1;
    }else if ([owner.type intValue] == 2) {
        return 3;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OwnerResidence *owner = dataArray[indexPath.section];
    if ([owner.type intValue] == 0) {
        return [_tableView cellHeightForIndexPath:indexPath model:owner keyPath:@"ownerResidence" cellClass:[THHouseAuthoriedTVC1 class] contentViewWidth:[self cellContentViewWith]];
    }else if ([owner.type intValue] == 1) {
        if (indexPath.row == 0) {
            return [_tableView cellHeightForIndexPath:indexPath model:owner keyPath:@"ownerResidence" cellClass:[THHouseAuthoriedTVC1 class] contentViewWidth:[self cellContentViewWith]];
        }else {
            OwnerResidenceUser *user = owner.userlist[indexPath.row - 1];
            return [_tableView cellHeightForIndexPath:indexPath model:user keyPath:@"ownerResidenceUser" cellClass:[THCarAuthoriedDetailsTVC class] contentViewWidth:[self cellContentViewWith]];
        }
    }else if ([owner.type intValue] == 2) {
        if (indexPath.row == 0) {
            return [_tableView cellHeightForIndexPath:indexPath model:owner keyPath:@"ownerResidence" cellClass:[THCarAuthoriedTVC2 class] contentViewWidth:[self cellContentViewWith]];
        }else if (indexPath.row == 1) {
            OwnerResidenceUser *user = owner.userlist[(indexPath.row+1)/2 - 1];
            return [_tableView cellHeightForIndexPath:indexPath model:user keyPath:@"ownerResidenceUser" cellClass:[THCarAuthoriedDetailsTVC class] contentViewWidth:[self cellContentViewWith]];

        }else {
            OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
            return [_tableView cellHeightForIndexPath:indexPath model:user keyPath:@"ownerResidenceUser" cellClass:[THCarAuthoriedDetailsTVC2 class] contentViewWidth:[self cellContentViewWith]];
        }
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OwnerResidence *owner = dataArray[indexPath.section];
    if ([owner.type intValue] == 0) {
        THHouseAuthoriedTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THHouseAuthoriedTVC1 class])];

        //未授权
        cell.type = 0;
        cell.ownerResidence = owner;
        return cell;
        
    }else if ([owner.type intValue] == 1) {
        //已共享
        if (indexPath.row == 0) {
            THHouseAuthoriedTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THHouseAuthoriedTVC1 class])];
            
            cell.type = 1;
            cell.ownerResidence = owner;
            
            return cell;

        }else {
            THCarAuthoriedDetailsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC class])];
            
            OwnerResidenceUser *user = owner.userlist[indexPath.row - 1];

            cell.ownerResidenceUser = user;
            
            return cell;
        }

    }else if ([owner.type intValue] == 2) {
        //已出租
        if (indexPath.row == 0) {
            THCarAuthoriedTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedTVC2 class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.ownerResidence = owner;
            return cell;
        }else {
            
            if (indexPath.row % 2 == 1) {
                OwnerResidenceUser *user = owner.userlist[(indexPath.row+1)/2 - 1];
                THCarAuthoriedDetailsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC class])];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.ownerResidenceUser = user;
                return cell;

            }else {
                OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
                THCarAuthoriedDetailsTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC2 class])];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.ownerResidenceUser = user;
                return cell;
            }
            
        }
        

    }else {
        return nil;
    }

}
//- (void)mobileWithIt:(UITapGestureRecognizer *)recognizer {
//    
//    UILabel *label = (UILabel*)recognizer.view;
//    NSString *phone = [[label.attributedText string] substringToIndex:11];
//    
//    if ([RegularUtils isPhoneNum:phone]) {
//        SysPresenter * sysPresenter=[SysPresenter new];
//        [sysPresenter callMobileNum:phone superview:self.view];
//    }
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    @WeakObj(self);
    OwnerResidence *owner = dataArray[indexPath.section];
    
    if ([owner.type intValue] == 0) {
        
        if (owner.istodateshow.intValue == 1) {
            [self showToastMsg:[XYString IsNotNull:owner.todateshow] Duration:3.0];
            return;
        }
        
        //未授权
        THHouseAuthorityViewController *authVC = [[THHouseAuthorityViewController alloc]init];
        authVC.callBack = ^{
            [selfWeak httpRequest];
        };
        authVC.owner = owner;
        [self.navigationController pushViewController:authVC animated:YES];
        
    }else if ([owner.type intValue] == 1) {
        //已共享
        if (indexPath.row == 0) {
            
            if (owner.istodateshow.intValue == 1) {
                [self showToastMsg:[XYString IsNotNull:owner.todateshow] Duration:3.0];
                return;
            }
            
            THHouseAuthorityViewController *authVC = [[THHouseAuthorityViewController alloc]init];
            authVC.callBack = ^{
                [selfWeak httpRequest];
            };
            authVC.owner = owner;
            [self.navigationController pushViewController:authVC animated:YES];
        }else {
            
            //-------------------------
            
            //移除
            OwnerResidenceUser *user = owner.userlist[indexPath.row - 1];
            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
            NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的房产权限?",user.name,user.phone];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(14)}];
            //            [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x276DDC) range:NSMakeRange(4,string.length-10)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(4,string.length-10)];
            
            [alertVC ShowAlert:self Title:@"移除" AttributeMsg:attributeString oneBtn:@"取消" otherBtn:@"确定"];
            [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
             {
                 NSLog(@"index=%ld",(long)index);
                 if (index == 1000) {
                     //确定
                     /**
                      *  移除住宅授权信息
                      */
                     THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                     [indicator startAnimating:selfWeak.tabBarController];
                     [CommunityManagerPresenters deleteResidencePowerPowerid:user.powerid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if(resultCode == SucceedCode)
                             {
                                 [selfWeak showToastMsg:@"移除成功" Duration:2.0];
                                 [CommunityManagerPresenters getOwnerResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [indicator stopAnimating];
                                         
                                         if(resultCode == SucceedCode)
                                         {
                                             [dataArray removeAllObjects];
                                             [dataArray addObjectsFromArray:(NSArray *)data];
                                             [selfWeak.tableView reloadData];
                                         }
                                         else
                                         {
                                             //                                             [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                                         }
                                         if (dataArray.count == 0) {
                                             [self showNothingnessViewWithType:NoContentTypeHouseManager Msg:@"您还没有被授权的房产" eventCallBack:nil];
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
                 
             }];
            
        }
        
    }else if ([owner.type intValue] == 2) {
        //已出租
        if (indexPath.row == 0) {
            return;
        }else {

            if (indexPath.row % 2 == 1) {
                
                //-------------------------

                OwnerResidenceUser *user = owner.userlist[(indexPath.row+1)/2 - 1];
                //移除
                CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的房产权限?",user.name,user.phone];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(14)}];
                //                [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x276DDC) range:NSMakeRange(4,string.length-10)];
                [attributeString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(4,string.length-10)];
                
                [alertVC ShowAlert:self Title:@"移除" AttributeMsg:attributeString oneBtn:@"取消" otherBtn:@"确定"];
                [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                 {
                     NSLog(@"index=%ld",(long)index);
                     if (index == 1000) {
                         //确定
                         /**
                          *  移除住宅授权信息
                          */
                         THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                         [indicator startAnimating:selfWeak.tabBarController];
                         [CommunityManagerPresenters deleteResidencePowerPowerid:user.powerid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if(resultCode == SucceedCode)
                                 {
                                     [selfWeak showToastMsg:@"移除成功" Duration:2.0];
                                     [CommunityManagerPresenters getOwnerResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [indicator stopAnimating];
                                             
                                             if(resultCode == SucceedCode) {
                                                 
                                                 [dataArray removeAllObjects];
                                                 [dataArray addObjectsFromArray:(NSArray *)data];
                                                 [selfWeak.tableView reloadData];
                                                 
                                             }else {
                                                 
                                                 [self showNothingnessViewWithType:NoContentTypeHouseManager Msg:@"您还没有被授权的房产" eventCallBack:nil];
                                                 
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
                     
                 }];
                
            }else {
                
                if (owner.istodateshow.intValue == 1) {
                    [self showToastMsg:[XYString IsNotNull:owner.todateshow] Duration:3.0];
                    return;
                }
                
                OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
                THHouseReletViewController *reletVC = [[THHouseReletViewController alloc]init];
                reletVC.type = 0;
                /**
                 *  回调刷新数据
                 */
                reletVC.callBack = ^(){
                    
//                    [selfWeak httpRequest];
                    
                };
                reletVC.theID = owner.theID;
                
                NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",user.rentenddate] withFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
                NSDate *nextDate2 = [NSDate dateWithTimeInterval:24*60*60*2 sinceDate:date];//后二天
                
                NSString *nextDateString = [XYString NSDateToString:nextDate withFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString *nextDate2String = [XYString NSDateToString:nextDate2 withFormat:@"yyyy-MM-dd hh:mm:ss"];
                
                reletVC.rentbegindate = nextDateString;
                reletVC.rentenddate = nextDate2String;
                [self.navigationController pushViewController:reletVC animated:YES];
            }
            
            
        }
        
        
    }

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    OwnerResidence *owner = dataArray[indexPath.section];
    if ([owner.type intValue] == 0) {
        //未授权
        width = SCREEN_WIDTH/2-7;
    }
    
    if (!(indexPath.row == 0)) {
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
