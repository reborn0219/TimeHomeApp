//
//  PANewHouseViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHouseViewController.h"
#import "PANewHouseTableViewCell.h"
#import "PANewHouseService.h"
@interface PANewHouseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * rootView;
@property (nonatomic, strong)PANewHouseService * houseService;
@end

@implementation PANewHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"我的房产";
    [self loadHouseData];
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
        _rootView.backgroundColor =UIColorHex(0xF5F5F5);
        _rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rootView.rowHeight = 114;
    }
    return _rootView;
}
- (PANewHouseService *)houseService{
    if (!_houseService) {
        _houseService = [[PANewHouseService alloc]init];
    }
    return _houseService;
}

#pragma mark - Request
- (void)loadHouseData{
    [self.houseService loadMyHouseListSuccess:^(PABaseRequestService *service) {
        [self.rootView reloadData];
        if (self.houseService.houseArray.count == 0) {
            [self showNoDataView];
        }
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}
#pragma mark - Actions
- (void)showNoDataView{
    [self showNothingnessViewWithType:NoNewHouseData Msg:@"暂无房产信息" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseService.houseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"PANewHouseTableViewCell";
    PANewHouseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PANewHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.houseModel = self.houseService.houseArray[indexPath.row];
    return cell;
}



@end
