//
//  CarModelView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarModelView.h"
#import "CarStyleView.h"
#import "ListCell.h"

#define W [UIScreen mainScreen].bounds.size.width*3/4

@implementation CarModelView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createDataSource];
        [self createTableView];
        _shadowHidden = YES;
        _remove = NO;
    }
    return self;
}

- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    for (int i = 0; i < 100; i++) {
        [_dataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
}
#pragma mark -- 设置阴影
- (void)setShadowHidden:(BOOL)shadowHidden {
    
    if (shadowHidden != YES) {
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
        self.layer.shadowOpacity = 0.8;//不透明度
        self.layer.shadowRadius = 15.0;//半径
        self.layer.cornerRadius = 4;
    }
    
}

/**
*移除view
**/
- (void)setRemove:(BOOL)remove {
    
    if (remove == YES) {
        [self removeFromSuperview];
    }
}




- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
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
    
    return _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tableViewCell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cell.titleLabel.text,@"1" ,nil];
    NSNotification * notice = [NSNotification notificationWithName:@"T2" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    
    [_tableView removeFromSuperview];
    
    
    CarStyleView *style = [[CarStyleView alloc] initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height)];
//                           CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:style];
    style.alpha = 0;
    
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        style.alpha = 1;
        
    }];
    
    
    
    
    
    
    
    
}

@end
