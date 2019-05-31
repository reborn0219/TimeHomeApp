//
//  PACarManagementController.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarManagementController.h"
#import "PACarMangementTableViewCell.h"
#import "PAAssociatedCarFooterView.h"
#import "PAAddCarInfoViewController.h"
#import "PATimingLockCarViewController.h"
#import "PAParkingSpaceService.h"
#import "PACarManagementModel.h"
#import "PABatchDeleteRelationCarRequest.h"

@interface PACarManagementController ()<UITableViewDelegate,UITableViewDataSource,PAServiceReqeustCompleteDelegate>

@property (nonatomic,strong) UITableView *carTableView;
@property (nonatomic, strong) PAParkingSpaceService *paService;

@end

@implementation PACarManagementController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
#pragma mark - initUI
-(void)initializeUI
{
    [self.view addSubview:self.carTableView];
    @WeakObj(self);
    self.carTableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak.paService loadNoInCarData];
    }];
    [self.paService loadNoInCarData];
    
}
-(PAParkingSpaceService *)paService
{
    if (!_paService) {
        
        _paService = [[PAParkingSpaceService alloc]init];
        _paService.delegagte = self;
    }
    return _paService;
}
-(UITableView *)carTableView
{
    if (!_carTableView) {
        
        _carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
        [_carTableView setBackgroundColor:BLACKGROUND_COLOR];
        [_carTableView registerNib:[UINib nibWithNibName:@"PACarMangementTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PACarMangementTableViewCell"];
        _carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _carTableView.delegate = self;
        _carTableView.dataSource = self;
        
    }
    return _carTableView;
}

#pragma mark - 网络请求回调
-(void)requestDataCompleted
{
    
    [self.carTableView.mj_header endRefreshing];
    
    if (self.paService.carDataArray == nil||self.paService.carDataArray.count == 0) {
        [self.carTableView setHidden:YES];
        [self showNothingnessViewWithType:NoAssociatedVehicle Msg:@"暂时没有未入库车辆" eventCallBack:nil];
    }else{
        [self.carTableView setHidden:NO];
        [self.carTableView reloadData];
    }
    
}

#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PACarMangementTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PACarMangementTableViewCell"];
    @WeakObj(self);
    cell.block = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
       
        if (index==1) {
            
            ///定时锁车
            [selfWeak timingLockTheCar:data];
            
        }else if(index == 2){
            ///修改
            PAAddCarInfoViewController * vehicleViewController = [[PAAddCarInfoViewController alloc]init];
            vehicleViewController.type = AddCarInfoControllerJumpTypeBatchUpdate;
            vehicleViewController.block = ^(id  _Nullable data, ResultCode resultCode) {
                [selfWeak.paService loadNoInCarData];
            };
            vehicleViewController.vehicleModel = data;
            [selfWeak.parentViewController.navigationController pushViewController:vehicleViewController animated:YES];
            
        }else{
            ///删除
            [selfWeak deleteCarAction:data];
        }
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id model_id = [self.paService.carDataArray objectAtIndex:indexPath.row];
    [cell assignmentWithModel:model_id];
    [cell limitedToEdit:self.paService.isLimited==-1?YES:NO];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paService.carDataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

#pragma mark - Actions

-(void)timingLockTheCar:(id)data
{
    PATimingLockCarViewController * palockCarVC = [[PATimingLockCarViewController alloc]init];
    palockCarVC.vehicleModel = data;
    [self.navigationController pushViewController:palockCarVC animated:YES];
}

-(void)deleteCarAction:(id)data{
    
    CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
    PACarManagementModel * model = data;
    @WeakObj(self);
    [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
     {
         if(index==ALERT_OK){
            
             AppDelegate * appdelegate = GetAppDelegates;
             PABatchDeleteRelationCarRequest * req = [[PABatchDeleteRelationCarRequest alloc] initWithCarNo:model.carNo communityID:appdelegate.userData.communityid];
             
             [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
                 
                 NSDictionary * responseData = responseModel.data;
                 
                 NSLog(@"___删除车辆：%@__",responseData);
                 [selfWeak showToastMsg:@"删除成功!" Duration:2.0f];
                 [selfWeak.paService.carDataArray removeObject:model];
                 [selfWeak.carTableView reloadData];
                 
             } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
                 NSLog(@"删除失败：%@",error);
                 [selfWeak showToastMsg:@"删除失败!" Duration:2.0f];
                 
             }];
         }         
     }];
    
    NSString *popMsg=[NSString stringWithFormat:@"删除车牌 %@ ,并解除其与所有车位的关联",model.carNo];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:popMsg];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x000000)
                          range:NSMakeRange(5, 7)];
    [alertVc ShowAlert:self Title:@"删除车牌" AttributeMsg:attributedStr oneBtn:@"取消" otherBtn:@"确定"];
    [alertVc.btn_Ok setBackgroundColor:PREPARE_MAIN_BLUE_COLOR];
    
}
@end
