//
//  RightViewController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RightViewController.h"
#import "RightCell.h"
#import "AddCarController.h"
#import "RightTableViewCell.h"
#import "CarStewardFirstVC.h"
#import "PopView.h"
#import "GasolineTypeView.h"

#define W [UIScreen mainScreen].bounds.size.width*3/4

@interface RightViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout ,UITableViewDelegate,UITableViewDataSource>

/** collectionView */
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;

/** tableView */
@property (nonatomic,strong)UITableView *tableView;
//@property (nonatomic,strong)UITableView *tableView2;

@property (nonatomic,strong)NSMutableArray *tableViewDataSource;
//@property (nonatomic,strong)NSMutableArray *tableViewDataSource2;

@property (nonatomic,assign)BOOL isChange;
@property (nonatomic,copy)NSString *str1;
@property (nonatomic,copy)NSString *str2;
@property (nonatomic,copy)NSString *str3;
@property (nonatomic,copy)NSString *str4;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
//    AddCarController *add = [[AddCarController alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [self createNotification];
    
    [self createCollectionView];
    [self createDataSource];
  
//    if ([_str1 isEqualToString:@"1"]) {
//
//        [_collectionView removeFromSuperview];
//        [_tableView removeFromSuperview];
//        
//        [self createDataSource];
//        [self createCollectionView];
//
//    }else if ([_str2 isEqualToString:@"2"]){
//        
//        [self createTableViewDataSource];
//        [self createtableView];
//    }else if ([_str3 isEqualToString:@"3"]){
//        
//        [self createView];
//    }else if ([_str3 isEqualToString:@"4"]){
//        
//        [self createGasolineType];
//    }

}

#pragma mark -- 注册观察者
- (void)createNotification {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(notifi:) name:nil object:nil];
    
}

- (void)notifi:(NSNotification *)sender {
    
    
    //     noti.object, noti.userInfo, noti.name
    
    if ([sender.name isEqualToString:@"k1"]) {
        NSLog(@"=====================%@",[sender.userInfo objectForKey:@"1"]);
        _str1 = [NSString stringWithFormat:@"%@",[sender.userInfo objectForKey:@"1"]];
    }else if([sender.name isEqualToString:@"k2"]) {
        
        _str2 = [NSString stringWithFormat:@"%@",[sender.userInfo objectForKey:@"2"]];
        NSLog(@"=====================%@",[sender.userInfo objectForKey:@"2"]);
    }else if([sender.name isEqualToString:@"k3"]) {
        _str3 = [NSString stringWithFormat:@"%@",[sender.userInfo objectForKey:@"3"]];
        NSLog(@"%@",[sender.userInfo objectForKey:@"3"]);
    }else if([sender.name isEqualToString:@"k4"]) {
        _str4 = [NSString stringWithFormat:@"%@",[sender.userInfo objectForKey:@"4"]];
        NSLog(@"%@",[sender.userInfo objectForKey:@"4"]);
       
}
}


#pragma mark -- createCollectionView
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;//行间距
    flow.minimumLineSpacing = 1; //列间距
    
    
    flow.itemSize = CGSizeMake(100,100);
    
    /**创建collectionView*/
    

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, self.view.frame.size.height - 64 - 49) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];

    /**注册*/
    [_collectionView registerNib:[UINib nibWithNibName:@"RightCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
}

- (void)dealloc {
    
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
/**是否可以选中*/
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

/**取消选中*/
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {



}



/**
 * tableView
 **/

- (void)createtableView {
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
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
    
    
    PopView *view = [[PopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andController:self];
    [self.view addSubview:view];

    view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        view.alpha = 1;
        
    }];

}




- (void)createView {
    
    PopView *view = [[PopView alloc] initWithFrame:self.view.frame andController:self];
    [self.view addSubview:view];
    view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        view.alpha = 1;
    }];
}


- (void)createGasolineType {
    
    GasolineTypeView *view = [[GasolineTypeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andController:self];
    [self.view addSubview:view];
    view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        view.alpha = 1;
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
