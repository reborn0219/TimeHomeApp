//
//  PAParkingRentDetailViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRentDetailViewController.h"
#import "PACarSpaceDetailTableViewCell.h"
#import "PACarSpaceRentDetailView.h"
#import "PACarSpaceModel.h"
#import "PACarSpaceRevokeService.h"
#import "PACarportRentViewController.h"

@interface PACarSpaceRentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView * rootView;
@property (nonatomic, strong)NSArray * titleArray;
@property (nonatomic, strong)NSArray * contentArray;

@end

@implementation PACarSpaceRentDetailViewController

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = @[@"使用状态:",@"租期:"];
    NSString * date = [NSString stringWithFormat:@"%@至%@",self.parkingSpace.useStartDate?:@"",self.parkingSpace.useEndDate?:@""];
    self.contentArray = @[@"已出租",date];
    [self.view addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)rootView{
    if (!_rootView) {
        _rootView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _rootView.delegate = self;
        _rootView.dataSource = self;
        _rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rootView;
}

#pragma mark - IBActions/Event Response

/**
 撤租车位
 */
- (void)revokeParkingSpace{
    
    if (self.parkingSpace.inLibCarNo) {
        [self showToastMsg:@"当前有入库车辆,不允许撤租" Duration:1.35];
        return;
    }
    [PACarSpaceRevokeService revokeParkingSpaceWithSpaceId:self.parkingSpace.spaceId success:^(id responseObject) {
        
        [self showToastMsg:@"撤租成功" Duration:1.35];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.reloadParkingSpaceBlock) {
            self.reloadParkingSpaceBlock(nil, 0);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showToastMsg:@"撤租失败" Duration:1.35];

    }];
}

/**
 续租车位
 */
- (void)renewParkingSpace{
    PACarportRentViewController * rent = [[PACarportRentViewController alloc]init];
    rent.rentType = PAParkingSpaceRenew;
    rent.spaceModel = self.parkingSpace;
    [self.navigationController pushViewController:rent animated:YES];
}

#pragma mark TableView Delegate/Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 99;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * infoCellIdentifier = @"CARPORTINFOCELLID";
    PACarSpaceDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
    if (!cell) {
        cell = [[PACarSpaceDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCellIdentifier];
    }
    
    [cell showLockCar:NO];
    cell.infoString = [self.titleArray[indexPath.row] stringByAppendingString:self.contentArray[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 99)];
    view.backgroundColor = UIColorHex(0xF5F5F5);
    PACarSpaceRentDetailView * footView = [[PACarSpaceRentDetailView alloc]initWithFrame:CGRectMake(0, 8, tableView.frame.size.width, 91)];
    [view addSubview:footView];
    footView.spaceModel = self.parkingSpace;
    
    @WeakObj(self);
    footView.eventBlock = ^(id  _Nullable data, ResultCode resultCode) {
        if ([data isEqualToString:@"1"]) {
            [selfWeak revokeParkingSpace];
        } else {
            [selfWeak renewParkingSpace];
        }
    };
    return view;
}
@end
