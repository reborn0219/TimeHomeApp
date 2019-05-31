//
//  PAWaterOrderController.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterOrderController.h"
#import "PAWaterOrderCell.h"
#import "PAWaterOrderNotFinishCell.h"
#import "PAWaterOrderService.h"
#import "PAWaterOrderModel.h"
#import "PAWaterScanViewController.h"
@interface PAWaterOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PAWaterOrderService *orderService;
@end

@implementation PAWaterOrderController

#pragma mark - Lifecyele
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadOrderList];
}

-(PAWaterOrderService *)orderService{
    if (!_orderService) {
        _orderService = [[PAWaterOrderService alloc]init];
    }
    return _orderService;
}

#pragma mark - initUI
- (void)initUI{
    self.title = @"取水订单";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 314;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UINib *cellNib = [UINib nibWithNibName:@"PAWaterOrderCell" bundle:nil];
        [_tableView registerNib:cellNib forCellReuseIdentifier:@"PAWaterOrderCell"];
        UINib *cellNotNib = [UINib nibWithNibName:@"PAWaterOrderNotFinishCell" bundle:nil];
        [_tableView registerNib:cellNotNib forCellReuseIdentifier:@"PAWaterOrderNotFinishCell"];
    }
    return _tableView;
}

#pragma mark - Requst
- (void)loadOrderList{
    @weakify(self)
    [self.orderService loadWaterOrderInfoWithWaterStatus:0 success:^(PABaseRequestService *service) {
        @strongify(self)
        [self.tableView reloadData];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderService.orderDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PAWaterOrderModel *model = self.orderService.orderDataArray[indexPath.row];
    if (model.takeWaterTime.length > 0) {
        PAWaterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAWaterOrderCell"];
        cell.orderModelData = model;
        return cell;
    }else{
        PAWaterOrderNotFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAWaterOrderNotFinishCell"];
        cell.orderModelData = model;
        @weakify(self)
        cell.gotoWaterBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            @strongify(self)
            PAWaterScanViewController *vc = [[PAWaterScanViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
