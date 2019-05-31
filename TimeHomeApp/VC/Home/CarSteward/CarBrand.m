//
//  CarBrand.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarBrand.h"
#import "RightCell.h"
#import "RightTableViewCell.h"
#import "PopView.h"
#import "UIViewController+MMDrawerController.h"//第三方封装的头文件
#import "MMDrawerBarButtonItem.h"//第三方封装的头文件

#define W [UIScreen mainScreen].bounds.size.width*3/4
@implementation CarBrand

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
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;//行间距
    flow.minimumLineSpacing = 1; //列间距
    
    
    flow.itemSize = CGSizeMake(100,100);
    
    /**创建collectionView*/
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, self.frame.size.height - 64 - 49) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_collectionView];
    
    /**注册*/
    [_collectionView registerNib:[UINib nibWithNibName:@"RightCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

#pragma amrk -- collectionView数据源
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    for (int i = 0; i < 100; i++) {
        [_dataSource addObject:[NSString  stringWithFormat:@"%d",i]];
    }
    
    
}


#pragma amrk -- collectionViewdataSource And collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**cell*/
    RightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.label.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    
    return cell;
}



//当前与四周的边界值
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 10, 8, 8);
}




//选中了某一个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RightCell *cell = (RightCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cell.label.text,@"1" ,nil];
    NSNotification * notice = [NSNotification notificationWithName:@"T1" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    
    
    
    [_dataSource removeAllObjects];
    [_collectionView removeFromSuperview];
    
    [self createTableViewDataSource];
    [self createtableView];

    
    
}


/**
 * tableView
 **/

- (void)createtableView {
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = (UIColorFromRGB(0xE9E9E9));
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
    
}



- (void)createTableViewDataSource {
    
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSMutableArray array];
    }
    for (int i = 00; i<100; i++) {
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
    NSNotification * notice = [NSNotification notificationWithName:@"T2" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    
    [_tableViewDataSource removeAllObjects];
    
    [_tableView removeFromSuperview];
    
    
    PopView *view = [[PopView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) andController:nil];
    [self addSubview:view];
    
    view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        view.alpha = 1;
        
    }];
    
}

- (void)clickWithController:(UIViewController *)controller {
    
    [controller.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


@end
