//
//  PACarportDetailViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//
// 车位详情
#import "PACarSpaceDetailViewController.h"
#import "PACarSpaceDetailTableViewCell.h"
#import "PACarMangementTableViewCell.h"
#import "PACarSpaceDetialHeaderView.h"
#import "PACarportRentViewController.h"
#import "PAAddCarInfoViewController.h"
#import "PACarSpaceInfoService.h"
#import "PACarSpaceModel.h"
#import "PACarSpaceInfoModel.h"
#import "PACarManagementModel.h"
#import "PATimingLockCarViewController.h"
#import "PADeleteRelationCarNoRequest.h"
#import "PACarSpaceLockService.h"

@interface PACarSpaceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PABaseServiceDelegate>
@property (nonatomic, strong)UITableView * rootView;
@property (nonatomic, strong)PACarSpaceInfoService * service;
@end

@implementation PACarSpaceDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 当前车位类型不属于租用状态情况 不展示出租 barButtonItem
    if (self.parkingSpace.type != 3) {
        [self setRightBarbuttonItem];
    }
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (void)setRightBarbuttonItem{
    //导航-车位出租
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    rightButton.tag = 2;
    rightButton.titleLabel.font = DEFAULT_FONT(17);
    [rightButton setTitle:@"出租" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rentItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rentItem;

}

- (UITableView *)rootView{
    if (!_rootView) {
        _rootView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _rootView.delegate = self;
        _rootView.dataSource = self;
        _rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rootView registerNib:[UINib nibWithNibName:@"PACarMangementTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PACarMangementTableViewCell"];
        _rootView.backgroundColor = UIColorHex(0xF5F5F5);
    }
    return _rootView;
}

#pragma mark - IBActions/Event Response
- (void)loadData{
    
    self.service = [[PACarSpaceInfoService alloc]init];
    self.service.parkingSpace = self.parkingSpace;
    [self.service loadParkingSpaceInfo:self.parkingSpace.spaceId Success:^(id data) {
        [self.rootView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}
/**
 出租车位

 @param sender 传入按钮
 */
- (void)rentItemClicked:(id)sender{
 
    if (self.parkingSpace.inLibCarNo && self.parkingSpace.inLibCarNo.length >4) {
        [self showAlertMessage:@"当前车位被占用,暂无法出租" Duration:3];
        return;
    }
    
    PACarportRentViewController * rent = [[PACarportRentViewController alloc]init];
    rent.spaceModel = self.parkingSpace;
    
    @WeakObj(self);
    rent.rentSuccessBlock = ^(id  _Nullable data, ResultCode resultCode) {
        if (self.rentSuccessBlock) {
            self.rentSuccessBlock(nil, 0);
        }
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:rent animated:YES];
}


/**
 锁车事件

 @param lock 是否锁车
 */
- (void)lockCarAction:(BOOL)lock{
    
    
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
    
    PACarSpaceLockService * lockCarService = [[PACarSpaceLockService alloc]init];
    [lockCarService lockCarWithParkingSpaceId:self.parkingSpace.spaceId carNo:self.parkingSpace.inLibCarNo lockState:lock];
    
    lockCarService.successBlock = ^(PABaseRequestService *service) {
        //[self loadData];
        
        self.parkingSpace.carLockState= lock;
        [self.rootView reloadData];
        if (self.rentSuccessBlock) {
            self.rentSuccessBlock(nil, SucceedCode);
        }
    };
    
}
/**
 添加关联车辆
 */
- (void)interrelatedCarEvent{
    
    PAAddCarInfoViewController * vehicleViewController = [[PAAddCarInfoViewController alloc]init];
    vehicleViewController.type = AddCarInfoControllerJumpTypeRelation;
    vehicleViewController.spaceModel = self.parkingSpace;
    @WeakObj(self);
    vehicleViewController.block = ^(id  _Nullable data, ResultCode resultCode) {
        [selfWeak loadData];
    };
    [self.navigationController pushViewController:vehicleViewController animated:YES];
}
#pragma mark - 定时锁车
-(void)timingLockTheCar:(id)data
{
    PATimingLockCarViewController * palockCarVC = [[PATimingLockCarViewController alloc]init];
    palockCarVC.vehicleModel = data;
    [self.navigationController pushViewController:palockCarVC animated:YES];
}
#pragma mark - 删除车辆
-(void)deleteCarAction:(id)data{
    
    CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
    PACarManagementModel * model = data;
    @WeakObj(self);
    [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
     {
         if(index==ALERT_OK){
             
             PADeleteRelationCarNoRequest * req = [[PADeleteRelationCarNoRequest alloc]initWithCarID:model.vehicleID];
             [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
                 
                 NSDictionary * responseData = responseModel.data;
                 
                 NSLog(@"___删除车辆：%@__",responseData);
                 [selfWeak showToastMsg:@"删除成功!" Duration:2.0f];
                 [self.service.parkingSpaceInfo.carNos removeObject:model];
                 [self.rootView reloadSection:1
                             withRowAnimation:UITableViewRowAnimationNone];
                 
             } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
                 NSLog(@"删除失败：%@",error);
                 [selfWeak showToastMsg:@"删除失败!" Duration:2.0f];
                 
             }];
             
         }
         
     }];
    ;
    [alertVc ShowAlert:self Title:@"删除车牌" Msg:[NSString stringWithFormat:@"是否删除车牌 %@?",model.carNo] oneBtn:@"取消" otherBtn:@"确定"];
    [alertVc.btn_Ok setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
    
}

#pragma mark - Request
- (void)loadDataSuccess{
    [self.rootView reloadData];
}

#pragma mark TableView Delegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section!=0) {
        return self.service.parkingSpaceInfo.carNos.count;
    }
    return self.service.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 1 ? 47:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section == 1 ? 70 : 47;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        PACarSpaceDetialHeaderView * header = [[PACarSpaceDetialHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 47)];
        [header showAddCarNo:self.limitapp==0?YES:NO];
        @WeakObj(self);
        header.interrelatedCarBlock = ^(id  _Nullable data, ResultCode resultCode) {
            // 关联车辆
            [selfWeak interrelatedCarEvent];
        };
        return header;
    }
    return [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = tableView.backgroundColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * infoCellIdentifier = @"PACarSpaceDetailTableViewCell";
        PACarSpaceDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        if (!cell) {
            cell = [[PACarSpaceDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                reuseIdentifier:infoCellIdentifier];
        }
    
        NSString * parkingInfoString = self.service.parkingInfoArray[indexPath.row]?:@"";
        cell.infoString = [self.service.titleArray[indexPath.row] stringByAppendingString:parkingInfoString];
        
        // 当前车位类型不属于租用状态情况 锁车按钮位置
        if (self.parkingSpace.type != 3) {
            if (parkingInfoString.length >1 && indexPath.row == 1) {
                [cell showLockCar:YES];
            } else {
                [cell showLockCar:NO];
            }
            
        } else {
            
            if (parkingInfoString.length >1&& indexPath.row == 2) {
                [cell showLockCar:YES];
            } else {
                [cell showLockCar:NO];
            }
        }
        // 锁车按钮状态
        if (self.parkingSpace.carLockState == YES) {
            [cell showLockCarStateSelected:YES];
        } else{
            [cell showLockCarStateSelected:NO];
        }
        
        @WeakObj(self);
        cell.lockCarBlock = ^(id  _Nullable data, ResultCode resultCode) {
            
            [selfWeak lockCarAction:resultCode];
        };
        
        return cell;
        
    } else {
        static NSString * carManagerIdentifier = @"PACarMangementTableViewCell";
        PACarMangementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:carManagerIdentifier];
        PACarManagementModel * carInfo =  self.service.parkingSpaceInfo.carNos[indexPath.row];
        [cell assignmentWithModel:carInfo];
        [cell limitedToEdit:self.limitapp==-1?YES:NO];

        @WeakObj(self);
        cell.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            
            if (index==1) {
                ///定时锁车
                [selfWeak timingLockTheCar:data];
                
            }else if(index == 2){
                ///修改
                PAAddCarInfoViewController * vehicleViewController = [[PAAddCarInfoViewController alloc]init];
                vehicleViewController.type = AddCarInfoControllerJumpTypeUpdate;
                vehicleViewController.vehicleModel = data;
                vehicleViewController.spaceModel = selfWeak.parkingSpace;
                [selfWeak.navigationController pushViewController:vehicleViewController animated:YES];
                
                // 修改当前页面
                @WeakObj(self);
                vehicleViewController.block = ^(id  _Nullable data, ResultCode resultCode) {
                    [selfWeak loadData];
                };
                
            }else{
                ///删除
                [selfWeak deleteCarAction:data];
            }
        };
        
        return cell;
    }
    return nil;
}

@end
