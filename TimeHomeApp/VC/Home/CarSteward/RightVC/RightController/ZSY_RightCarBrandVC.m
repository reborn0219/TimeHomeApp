//
//  ZSY_RightCarBrandVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_RightCarBrandVC.h"
#import "ZSY_BrandTableViewCell.h"
#import "ZSY_RightBrandCell.h"

#import "ZSY_RightBrandHeaderView.h"
#import "ZSY_tableViewSectionView.h"
#import "ZSY_RightCarModelVC.h"
#import "CarManagerPresenter.h"
#import "ZSY_AllCarBrandModel.h"

@interface ZSY_RightCarBrandVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *tempSource;
@property (nonatomic, strong)NSMutableArray *headerData;
@property (nonatomic, strong)ZSY_AllCarBrandModel *model;
//arrayarray
//@property (nonatomic, strong)UICollectionView *collectionView;
//@property (nonatomic, strong)NSMutableArray *collectionData;

/**
 *英文字母数组
 **/
@property (nonatomic,strong)NSMutableArray *charArray;
@property (nonatomic,strong)UIView *collectionBgView;


@property (nonatomic,strong)ZSY_RightBrandHeaderView *headerView;


@end

@implementation ZSY_RightCarBrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择品牌";
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    self.view.backgroundColor = BLACKGROUND_COLOR;
//    self.view.backgroundColor = [UIColor greenColor];
    
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

#pragma mark -- createTabeleView
- (void)createTableView {
    
    UIView *Bg = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT)];
    Bg.backgroundColor = [UIColor redColor];
//    [self.view addSubview:Bg];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width - 16, self.view.frame.size.height - 16 - (44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_BrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    _headerView = [[ZSY_RightBrandHeaderView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, (_tableView.frame.size.width / 4 - 4 * 5)/2.*3*2+45)];
    _tableView.tableHeaderView = _headerView;
    _headerView.backgroundColor = [UIColor orangeColor];
    
    
    [_tableView reloadData];
    
}



/**
 *tableView数据源
 **/
- (void)createTableViewDataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    _dataSource = [[NSMutableArray alloc]initWithObjects:@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[], nil];

    
    if (!_charArray) {
        _charArray=[NSMutableArray new];
    }
    if (!_headerData) {
        _headerData = [NSMutableArray new];
    }
    if (!_tempSource) {
        _tempSource = [NSMutableArray new];
    }
    @WeakObj(self);
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];

    [CarManagerPresenter getAllCarBrandWithBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                
                
                [_tempSource removeAllObjects];

                NSArray *array = [ZSY_AllCarBrandModel mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"list"]];
                
                [_tempSource addObjectsFromArray:array];


                for (int i = 0; i < array.count; i++) {
                    
                    ZSY_AllCarBrandModel *model = array[i];
//                    [_charArray addObject:model.firstletter];
                   
                    
                    if ([model.firstletter isEqualToString:@"A"]) {
                
                        NSMutableArray *A = [[NSMutableArray alloc] init];
                         NSArray *arr = [_dataSource objectAtIndex:0];
                        [A addObjectsFromArray:arr];
                        [A addObject:model];

                        [_dataSource replaceObjectAtIndex:0 withObject:A];
                    

                        
                    }
                    else if ([model.firstletter isEqualToString:@"B"]) {
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:1];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:1 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"C"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:2];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:2 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"D"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:3];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:3 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"E"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:4];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:4 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"F"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:5];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:5 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"G"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:6];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:6 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"H"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:7];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:7 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"I"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:8];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:8 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"J"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:9];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:9 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"K"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:10];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:10 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"L"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:11];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:11 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"M"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:12];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:12 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"N"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:13];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:13 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"O"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:14];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:14 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"P"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:15];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:15 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"Q"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:16];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:16 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"R"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:17];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:17 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"S"]) {
                    
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:18];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:18 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"T"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:19];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:19 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"U"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:20];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:20 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"V"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:21];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:21 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"W"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:22];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:22 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"X"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:23];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:23 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"Y"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:24];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:24 withObject:B];
                    }else if ([model.firstletter isEqualToString:@"Z"]) {
                        
                        NSMutableArray *B = [[NSMutableArray alloc] init];
                        NSArray *arr = [_dataSource objectAtIndex:25];
                        [B addObjectsFromArray:arr];
                        [B addObject:model];

                        [_dataSource replaceObjectAtIndex:25 withObject:B];
                    }
                    
                }
                
//                _charArray = [_charArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
                
                
                NSArray *charArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
                                 @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",
                                 @"U",@"V",@"W",@"X",@"Y",@"Z"];
//                [_charArray addObjectsFromArray:charArr];

                for (int k = 0; k < 26; k++) {
                    
                    if ([_dataSource[k] count] != 0) {
                        [_charArray addObject:charArr[k]];
                    }
                    
                }
                
                NSArray *array1= [_dataSource copy];
                [_dataSource removeAllObjects];
                for (int i = 0; i < array1.count; i++) {
                    if ([array1[i] count] != 0) {
                        [_dataSource addObject:array1[i]];
                    }
                }
                
                for (int i = 0; i < array.count; i++) {
                    
                    ZSY_AllCarBrandModel *model = array[i];
                    if ([model.ishot isEqualToString:@"1"]) {
                        
                        [_headerData addObject:model];
                    }
                }
                
                [_headerView setDataSource:_headerData];
                
                [selfWeak.tableView reloadData];
                
            }else {
                [self showToastMsg:@"暂无数据" Duration:3.0];
            }
            
        });

        
    }];
    
    
    
    
    
}


#pragma mark -- tableViewDataSource And tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if ([_dataSource[section] count] == 0) {
//
//        return 0;
//    }
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataSource[section] count];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 80;
}

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
    label.sd_layout.leftSpaceToView(headerView,8).topSpaceToView(headerView,8).heightIs(21).widthIs(50);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BLACKGROUND_COLOR;
    [headerView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(headerView,5).rightSpaceToView(headerView,5).topSpaceToView(label,5).heightIs(1);
//    NSArray *array = _dataSource[section];
//    ZSY_AllCarBrandModel *model = array[0];
    
//    label.text = model.firstletter;
    if (_charArray.count != 0) {
        label.text = _charArray[section];
    }

    return headerView;

    
}

// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    
    self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];//背景色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    //改变索引选中的背景颜色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor whiteColor];
    
    return _charArray;
}

// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    // 获取所点目录对应的indexPath值
//    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
//    
//    // 让table滚动到对应的indexPath位置
//    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    NSLog(@"index===%ld",(long)index);
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSY_BrandTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (_dataSource.count != 0) {
        ZSY_AllCarBrandModel *model = _dataSource[indexPath.section][indexPath.row];

        
        tableViewCell.carNameLabel.text = model.name;
//        [tableViewCell.carIconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PIC_URL,model.picurl]] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        NSLog(@"--tupian-%@",model.picurl);
        
        [tableViewCell.carIconView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",model.picurl]);
        
    }
    
    
//    tableViewCell.carNameLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    return tableViewCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ZSY_BrandTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    ZSY_RightCarModelVC *carModel = [[ZSY_RightCarModelVC alloc] init];
    ZSY_AllCarBrandModel *model = _dataSource[indexPath.section][indexPath.row];
    
    carModel.headerStr = model.name;
    carModel.brandID = model.ID;
    [self.navigationController pushViewController:carModel animated:YES];
    
 
}


@end
