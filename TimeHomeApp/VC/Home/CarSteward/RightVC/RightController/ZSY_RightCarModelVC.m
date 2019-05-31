//
//  ZSY_RightCarModelVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_RightCarModelVC.h"
#import "ZSY_CarModelCell.h"
#import "ZSY_RightCarStyleVC.h"
#import "CarManagerPresenter.h"
#import "ZSY_CarModelModel.h"
@interface ZSY_RightCarModelVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;


@end

@implementation ZSY_RightCarModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择车型";
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    self.view.backgroundColor = BLACKGROUND_COLOR;
//    self.view.backgroundColor = [UIColor blueColor];

    [self createTableViewDataSource];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
#pragma mark -- 创建列表
- (void)createTableView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 16 - (44+statuBar_Height))];
    bgView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width - 16, self.view.frame.size.height - 16 - (44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.tableHeaderView = [self createHaderView];
    [self.view addSubview:_tableView];
    
//    ZSY_CarModelCell.h
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_CarModelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}


- (UIView *)createHaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = [UIColor blackColor];
    if (SCREEN_WIDTH <= 320) {
        label.font = [UIFont boldSystemFontOfSize:12];
    }
    label.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:label];
    label.sd_layout.leftSpaceToView(headerView,8).topSpaceToView(headerView,8).heightIs(21).widthIs(300);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BLACKGROUND_COLOR;
    [headerView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(headerView,5).rightSpaceToView(headerView,5).topSpaceToView(label,5).heightIs(1);
    
    label.text = _headerStr;
    
    return headerView;

}


/**
 *tableView数据源
 **/
- (void)createTableViewDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CarManagerPresenter getAllCarModelWithCarBrandID:_brandID andBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                
                
                [_dataSource removeAllObjects];
                NSArray *array = [ZSY_CarModelModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                
               
                
                [_dataSource addObjectsFromArray:array];
                [selfWeak.tableView reloadData];
                
            }else {
                [self showToastMsg:@"暂无数据" Duration:3.0];
            }
            
        });
    }];

    
    
//    
//    for (int i = 0; i < 100; i++) {
//        [_dataSource addObject:[NSString stringWithFormat:@"斯柯达%d",i]];
//    }
    
    
}


#pragma mark -- tableViewDataSource And tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    return _dataSource.count;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    
    label.textColor = [UIColor blackColor];
    if (SCREEN_WIDTH <= 320) {
        label.font = [UIFont boldSystemFontOfSize:12];
    }
    label.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:label];
    label.sd_layout.leftSpaceToView(headerView,8).topSpaceToView(headerView,8).heightIs(21).widthIs(self.view.frame.size.width - 2 * 8);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BLACKGROUND_COLOR;
    [headerView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(headerView,5).rightSpaceToView(headerView,5).topSpaceToView(label,5).heightIs(1);
    
    label.text = _headerStr;
    return headerView;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSY_CarModelCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZSY_CarModelModel *model = _dataSource[indexPath.row];
    
    
    tableViewCell.leftLabel.text = model.name;
    
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ZSY_CarModelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ZSY_CarModelModel *model = _dataSource[indexPath.row];
    
    
    ZSY_RightCarStyleVC *carStyle = [[ZSY_RightCarStyleVC alloc] init];
    
    carStyle.model_headerStr = cell.leftLabel.text;
    carStyle.brand_headerStr = _headerStr;
    carStyle.modelID = model.ID;
    carStyle.brandID = _brandID;
    [self.navigationController pushViewController:carStyle animated:YES];
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
