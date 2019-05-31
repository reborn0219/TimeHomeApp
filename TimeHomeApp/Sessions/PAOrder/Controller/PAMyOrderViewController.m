//
//  PAMyOrderViewController.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMyOrderViewController.h"
#import "PAMyOrderCell.h"
#import "L_MyExchangeListViewController.h"
#import "PAWaterOrderController.h"
@interface PAMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *contentArray;
@end

@implementation PAMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI{
     self.title = @"我的订单";
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
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        UINib *cellNib = [UINib nibWithNibName:@"PAMyOrderCell" bundle:nil];
        [_tableView registerNib:cellNib forCellReuseIdentifier:@"PAMyOrderCell"];
    }
    return _tableView;
}

-(NSArray *)contentArray{
    if (!_contentArray) {
        _contentArray = @[@{@"image":@"water.png",@"title":@"取水订单"},@{@"image":@"图层 18.png",@"title":@"积分订单"}];
    }
    return _contentArray;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PAMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PAMyOrderCell"];
    cell.dataDict = self.contentArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PAWaterOrderController *waterVC = [[PAWaterOrderController alloc]init];
        [self.navigationController pushViewController:waterVC animated:YES];
    }else if (indexPath.row == 1) {
        UIStoryboard *tabStoryboard = [UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
        L_MyExchangeListViewController *exchangeVC = [tabStoryboard instantiateViewControllerWithIdentifier:@"L_MyExchangeListViewController"];
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }
}

@end
