//
//  ZSY_RightCarStyleVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_RightCarStyleVC.h"
#import "ZSY_CarModelCell.h"
#import "AddCarController.h"
#import "CarManagerPresenter.h"
#import "ZSY_CarStyleModel.h"

@interface ZSY_RightCarStyleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation ZSY_RightCarStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择车款";
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
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
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, bgView.frame.size.width - 16, bgView.frame.size.height - 36 - 20 - 26) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.tableHeaderView = [self createHaderView];
    [bgView addSubview:_tableView];
    
    //    ZSY_CarModelCell.h
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_CarModelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"提 交 确 认" forState:UIControlStateNormal];
    button.backgroundColor = PURPLE_COLOR;
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(confirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
     button.sd_layout.leftSpaceToView(bgView,20).rightSpaceToView(bgView,20).bottomSpaceToView(bgView,20).heightIs(36);
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
    label.sd_layout.leftSpaceToView(headerView,8).topSpaceToView(headerView,8).heightIs(21).widthIs(50);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BLACKGROUND_COLOR;
    [headerView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(headerView,5).rightSpaceToView(headerView,5).topSpaceToView(label,5).heightIs(1);
    
    label.text = [NSString stringWithFormat:@"%@ - %@",_brand_headerStr,_model_headerStr];
    
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
    
    [CarManagerPresenter getAllCarStyleWithCarModelID:_modelID andBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                
                
                [_dataSource removeAllObjects];
                NSArray *array = [ZSY_CarStyleModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                
                
                
                [_dataSource addObjectsFromArray:array];
                [selfWeak.tableView reloadData];
                
            }else {
                [self showToastMsg:@"暂无数据" Duration:3.0];
            }
            
        });

    }];
    
    
    
//    _modelID
//    for (int i = 0; i < 100; i++) {
//        [_dataSource addObject:[NSString stringWithFormat:@"X款%d版",i]];
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
    label.sd_layout.leftSpaceToView(headerView,8).topSpaceToView(headerView,8).heightIs(21).widthIs(300);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BLACKGROUND_COLOR;
    [headerView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(headerView,5).rightSpaceToView(headerView,5).topSpaceToView(label,5).heightIs(1);
    
    label.text = [NSString stringWithFormat:@"%@ - %@",_brand_headerStr,_model_headerStr];
    return headerView;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSY_CarModelCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZSY_CarStyleModel *model = _dataSource[indexPath.row];
    tableViewCell.leftLabel.text = model.name;
    
//    tableViewCell.leftLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
//    ZSY_CarModelCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ZSY_CarStyleModel *model = _dataSource[indexPath.row];
   
    _style_headerStr = model.name;
    _stytleID = model.ID;
    
}

#pragma mark -- 按钮点击事件
//确认按钮
- (void)confirmButton:(UIButton *)button {
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_brand_headerStr,@"1" ,nil];
    NSNotification * notice = [NSNotification notificationWithName:@"T1" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    
    
    
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:_model_headerStr,@"1" ,nil];
    NSNotification * notice1 = [NSNotification notificationWithName:@"T2" object:nil userInfo:dic1];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice1];
    
    
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:_style_headerStr,@"1" ,nil];
    NSNotification * notice2 = [NSNotification notificationWithName:@"T3" object:nil userInfo:dic2];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice2];
//
//    NSArray * ctrlArray = self.navigationController.viewControllers;
    if (_style_headerStr != 0) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[AddCarController class]]) {
                AddCarController *add =(AddCarController *)controller;
//                add.carBrand.text = _brand_headerStr;
//                add.carModel.text = _model_headerStr;
//                add.carStyle.text = _style_headerStr;
                add.brandID = _brandID;
                add.modelID = _modelID;
                add.stytleID = _stytleID;
                [self.navigationController popToViewController:add animated:YES];
            }
        }

        
    }else {
        
        [self showToastMsg:@"车款不能为空" Duration:3.0f];
    }
    
    
    
    
   

    NSLog(@"确认");
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
