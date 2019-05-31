//
//  THMyCarAuthorityListVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyCarAuthorityListVC.h"
#import "THMyCarAuthorityViewController.h"

#import "THHouseAuthoriedTVC.h"
#import "THCarAuthoriedTVC1.h"
#import "THCarAuthoriedTVC2.h"
#import "THCarAuthoriedDetailsTVC.h"
#import "THCarAuthoriedDetailsTVC2.h"

#import "THHouseAuthorityDetailsTVC.h"
#import "THHouseReletViewController.h"

#import "HouseReletDateSelectButton.h"
#import "PACarportRentViewController.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"
#import "THRentAlertView.h"
#import "PACarSpaceRevokeService.h"
#import "ParkingOwner.h"
#import "OwnerResidenceUser.h"
#import "PACarSpaceModel.h"
/**
 *  网络请求
 */
#import "ParkingAuthorizePresenter.h"
#import "LogInPresenter.h"
//#import "SysPresenter.h"
//#import "RegularUtils.h"

@interface THMyCarAuthorityListVC () <UITableViewDelegate, UITableViewDataSource>
{
    /**
     *  请求数据
     */
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) NSString *beginDateString;
@property (nonatomic, strong) NSString *endDateString;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THRentAlertView *selectView;

@end

@implementation THMyCarAuthorityListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的车位";
    dataArray = [[NSMutableArray alloc]init];
    [self httpRequest];
    [self createTableView];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:CheWeiGuanLi];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":CheWeiGuanLi}];
}
/**
 *  我的车位权限列表请求
 */
- (void)httpRequest {
    
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [ParkingAuthorizePresenter getOwnerParkingAreaForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                [dataArray removeAllObjects];
                [dataArray addObjectsFromArray:(NSArray *)data];
                [selfWeak.tableView reloadData];
            }
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeCarManager Msg:@"您没有可授权的车位" eventCallBack:nil];
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
    
    [_tableView registerClass:[THCarAuthoriedTVC1 class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedTVC1 class])];
    [_tableView registerClass:[THCarAuthoriedTVC2 class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedTVC2 class])];
    [_tableView registerClass:[THCarAuthoriedDetailsTVC class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC class])];
    [_tableView registerClass:[THCarAuthoriedDetailsTVC2 class] forCellReuseIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC2 class])];
    
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ParkingOwner *owner = dataArray[section];
    if (owner.type.intValue == 0) {
        //出租
        return 1;
    }else if (owner.type.intValue == 2) {
        //已出租
        return 3;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingOwner *owner = dataArray[indexPath.section];
    if (owner.type.intValue == 0) {
        ParkingOwner *owner = dataArray[indexPath.section];
        return [_tableView cellHeightForIndexPath:indexPath model:owner keyPath:@"parkingOwner" cellClass:[THCarAuthoriedTVC1 class] contentViewWidth:[self cellContentViewWith]];
    }else if (owner.type.intValue == 2) {
        ParkingOwner *owner = dataArray[indexPath.section];
        if (indexPath.row == 0) {
            return [_tableView cellHeightForIndexPath:indexPath model:owner keyPath:@"parkingOwner" cellClass:[THCarAuthoriedTVC2 class] contentViewWidth:[self cellContentViewWith]];
        }else if (indexPath.row == 1){
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
    
    ParkingOwner *owner = dataArray[indexPath.section];
    if (owner.type.intValue == 0) {
        
        THCarAuthoriedTVC1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedTVC1 class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //出租
        cell.parkingOwner = owner;
        
        return cell;
        
    }else if (owner.type.intValue == 2) {
        //已出租
        if (indexPath.row == 0) {
            
            THCarAuthoriedTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedTVC2 class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.parkingOwner = owner;
            
            return cell;
            
        }else {
            if (indexPath.row % 2 == 1) {
                OwnerResidenceUser *user = owner.userlist[(indexPath.row+1)/2 - 1];
                THCarAuthoriedDetailsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC class])];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.ownerResidenceUser = user;
                return cell;
                
            }else {
                
                OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
                THCarAuthoriedDetailsTVC2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THCarAuthoriedDetailsTVC2 class])];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
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
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @WeakObj(self);
    ParkingOwner *owner = dataArray[indexPath.section];
    if (owner.type.intValue == 0) {
        
        if (!owner.isnew.boolValue) {
            
            //出租
            THMyCarAuthorityViewController *carVC = [[THMyCarAuthorityViewController alloc]init];
            carVC.callBack = ^{
                
                [selfWeak httpRequest];
                
            };
            carVC.owner = owner;
            [self.navigationController pushViewController:carVC animated:YES];
            
            
        }else{
            
            PACarportRentViewController * paRentVC = [[PACarportRentViewController alloc]init];
            PACarSpaceModel * model = [[PACarSpaceModel alloc]init];
            model.spaceId = owner.theID;
            model.parkingSpaceName = owner.name;
            paRentVC.rentType = PAParkingSpaceRent;
            paRentVC.spaceModel = model;
            [self.navigationController pushViewController:paRentVC animated:YES];
            paRentVC.rentSuccessBlock = ^(id  _Nullable data, ResultCode resultCode) {
                [selfWeak httpRequest];
            };
            
        }
        
        
    }else if (owner.type.intValue == 2) {
        //已出租
        if (indexPath.row == 0) {
            return;
        }else {
            
            if (indexPath.row % 2 == 1) {
                
                
                OwnerResidenceUser *user = owner.userlist[(indexPath.row+1)/2 - 1];
                //移除
                CommonAlertVC *alertVC = [CommonAlertVC getInstance];
                NSString *string = [NSString stringWithFormat:@"是否移除%@  %@  的车位权限?",user.name,user.phone];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:DEFAULT_FONT(14)}];
                //                [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x276DDC) range:NSMakeRange(4,string.length-10)];
                [attributeString addAttribute:NSForegroundColorAttributeName value:BLUE_TEXT_COLOR range:NSMakeRange(4,string.length-10)];
               
                [alertVC ShowAlert:self Title:@"移除" AttributeMsg:attributeString oneBtn:@"取消" otherBtn:@"确定"];
                [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                 {
                     
                     if (index == 1000) {
                         
                         
                         if (owner.isnew.boolValue) {
                             
                             [selfWeak revokeParkingSpace:user.powerid];
                             
                         }else{
                             
                             //确定
                             /**
                              *  移除住宅授权信息
                              */
                             THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
                             [indicator startAnimating:selfWeak.tabBarController];
                             [ParkingAuthorizePresenter deleteParkingareaPowerForPowerid:user.powerid upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if(resultCode == SucceedCode)
                                     {
                                         [selfWeak showToastMsg:@"移除成功" Duration:2.0];
                                         [ParkingAuthorizePresenter getOwnerParkingAreaForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [indicator stopAnimating];
                                                 if(resultCode == SucceedCode)
                                                 {
                                                     [dataArray removeAllObjects];
                                                     [dataArray addObjectsFromArray:(NSArray *)data];
                                                     [selfWeak.tableView reloadData];
                                                 }
                                                 if (dataArray.count == 0) {
                                                     [self showNothingnessViewWithType:NoContentTypeData Msg:@"您没有可授权的车位" eventCallBack:nil];
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
                     
                 }];
                
                
                if (owner.isnew.boolValue) {
                    [alertVC.btn_Ok setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
                }else{
                    [alertVC.btn_Ok setBackgroundColor:NEW_RED_COLOR];
                    
                }
                
            }else {
                
                
                if (owner.isnew.boolValue) {
                    
                    
                    OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
                    
                    PACarportRentViewController * paRentVC = [[PACarportRentViewController alloc]init];
                    PACarSpaceModel * model = [[PACarSpaceModel alloc]init];
                    model.spaceId = owner.theID;
                    model.parkingSpaceName = owner.name;
                    model.type = owner.type.integerValue;
                    model.inLibCarNo = owner.card;
                    paRentVC.rentType = PAParkingSpaceRenew;
                    
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",user.rentenddate] withFormat:@"yyyy-MM-dd hh:mm:ss"];
                    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
                    NSDate *nextDate2 = [NSDate dateWithTimeInterval:24*60*60*2 sinceDate:date];//后二天
                    
                    NSString *nextDateString = [XYString NSDateToString:nextDate withFormat:@"yyyy-MM-dd"];
                    NSString *nextDate2String = [XYString NSDateToString:nextDate2 withFormat:@"yyyy-MM-dd"];
                    model.useStartDate = nextDateString;
                    model.useEndDate = nextDate2String;
                    paRentVC.spaceModel = model;
                    
                    [self.navigationController pushViewController:paRentVC animated:YES];
                    paRentVC.rentSuccessBlock = ^(id  _Nullable data, ResultCode resultCode) {
                        
                        [selfWeak httpRequest];
                        
                    };
                    
                }else{
                    
                    OwnerResidenceUser *user = owner.userlist[indexPath.row/2 - 1];
                    THHouseReletViewController *reletVC = [[THHouseReletViewController alloc]init];
                    
                    reletVC.type = 1;
                    /**
                     *  回调刷新数据
                     */
                    reletVC.callBack = ^(){
                        
                        [selfWeak httpRequest];
                        
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
    
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = 13;
    if (!(indexPath.row == 0)) {
        width = SCREEN_WIDTH/2-7;
    }
    ParkingOwner *owner = dataArray[indexPath.section];
    if (owner.type.intValue == 0) {
        //出租
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
 撤租车位
 */
- (void)revokeParkingSpace:(NSString *)spaceID{
    
    @WeakObj(self);
    [PACarSpaceRevokeService revokeParkingSpaceWithSpaceId:spaceID success:^(id responseObject) {
        
        [selfWeak showToastMsg:@"撤租成功" Duration:1.35];
        [selfWeak httpRequest];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self showToastMsg:@"撤租失败" Duration:1.35];
        
    }];
}

@end
