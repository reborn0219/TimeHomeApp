//
//  CarModel.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarModel.h"
#import "RightTableViewCell.h"
#import "RightViewController.h"
#import "UIViewController+MMDrawerController.h"//第三方封装的头文件
#import "MMDrawerBarButtonItem.h"//第三方封装的头文件

@implementation CarModel
- (instancetype)initWithFrame:(CGRect)frame andController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        _controller = controller;
        [self createDataSource];
        [self crteateTableView];
        
    }
    return self;
}

- (void)crteateTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = (UIColorFromRGB(0xE9E9E9));
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
}

- (void)createDataSource {
    
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSMutableArray array];
    }
    
    for (int i = 100; i < 200; i++) {
        [_tableViewDataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

#pragma mark -- tableViewDataSource And tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewDataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RightTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tableViewCell.label.text = [NSString stringWithFormat:@"%@",_tableViewDataSource[indexPath.row]];
    
    return tableViewCell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    RightTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cell.label.text,@"1" ,nil];
    NSNotification * notice = [NSNotification notificationWithName:@"T3" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self clickWithController:_controller];
    
    [_tableView removeFromSuperview];
    
    
    
}
- (void)clickWithController:(UIViewController *)controller {
    
    [controller.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


@end
