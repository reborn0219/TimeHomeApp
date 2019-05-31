//
//  PAHomeMenuCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/8/1.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAHomeMenuCell.h"
#import "NibCell.h"
#import "PAMoreMenuViewController.h"
#import "HomePropertyIconModel.h"
#import "PropertyIcon.h"
#import "PANewHomeMenuModel.h"
#import "WebViewVC.h"

@interface PAHomeMenuCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    NSInteger isredenvelope;
}
@property (nonatomic,strong)NSMutableArray *dataSource;///首页展示图标
@property (nonatomic,strong)NSMutableArray *iconArray;///全部服务图标
@property (nonatomic,strong) UICollectionView *fuctionCollectionView;
@property (nonatomic,copy)ViewsEventBlock block;
@end
@implementation PAHomeMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:BLACKGROUND_COLOR];
    [self createCollectionView];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - 创建列表
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.fuctionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,0,SCREEN_WIDTH - 20 , 180) collectionViewLayout:viewFlowLayout];
    
    @WeakObj(self);
    
    self.fuctionCollectionView.backgroundColor = [UIColor whiteColor];
    self.fuctionCollectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
    self.fuctionCollectionView.delegate = self;
    self.fuctionCollectionView.dataSource = self;
    [self.fuctionCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self addSubview:self.fuctionCollectionView];
    
    self.fuctionCollectionView.alpha = 0;
}

#pragma mark - UICollectionViewDataSource
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-20)/4.0f,80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count<8 ? _dataSource.count : 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NibCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    HomePropertyIconModel *homeIconModel = _dataSource[indexPath.row];
    cell.textLabel.text = @"";
    cell.iconImage.image = [UIImage imageNamed:@""];
    cell.iconImage.image = [UIImage imageNamed:@""];
    cell.sourceId = homeIconModel.keynum;//控制权限的资源ID
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:homeIconModel.picurl] placeholderImage:[UIImage imageNamed:@"homepage_button_none_n"]];
    cell.textLabel.text  = homeIconModel.title;
    if ([homeIconModel.key isEqualToString:@"shake"]) {
        cell.textLabel.text = homeIconModel.title;
        if (isredenvelope == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"homepage_button_yytxhd_n"];
            [cell startAnimation];
        }else {
            cell.iconImage.image = [UIImage imageNamed:@"homepage_button_yytx_n"];
        }
    }else if ([homeIconModel.key isEqualToString:@"more"])
    {
        cell.iconImage.image = [UIImage imageNamed:@"homepage_button_more_n"];
        cell.textLabel.text  = @"全部服务";
    }
    return cell;
}

#pragma mark - Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomePropertyIconModel *homeIconModel = _dataSource[indexPath.row];
    if (self.callback) {
        self.callback(homeIconModel, nil, indexPath.row);
    }
}

#pragma mark - 主页图标数组整合
-(void)mergeIconArray
{
    [_iconArray removeAllObjects];
    NSMutableArray * tempDataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary * dic = obj;
        NSArray * arr = [dic objectForKey:@"list"];
        //全部服务升序
        NSArray *allResult = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            NSNumber * topsort2 = obj2[@"allsort"];
            NSNumber * topsort1 = obj1[@"allsort"];
            
            return [topsort1 compare:topsort2];
            
        }];
        NSMutableDictionary * iconItem = [[NSMutableDictionary alloc]initWithCapacity:0];
        [iconItem setObject:dic[@"classname"]?:@"" forKey:@"classname"];
        [iconItem setObject:allResult forKey:@"list"];
        [_iconArray addObject:iconItem];
        //分组数组整合到一个数组
        for (int i = 0; i<arr.count; i++) {
            
            [tempDataArr addObject:[arr objectAtIndex:i]];
        }
    }];
    
    //首页图标升序
    NSArray *topResult = [tempDataArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSNumber * topsort2 = obj2[@"topsort"];
        NSNumber * topsort1 = obj1[@"topsort"];
        
        return [topsort1 compare:topsort2];
        
    }];
    [tempDataArr removeAllObjects];
    [tempDataArr addObjectsFromArray:topResult];
    
    //整合后数组赋值
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:tempDataArr];
}

- (void)setMenuArray:(NSArray *)menuArray{
    if (_menuArray!=menuArray) {
        _menuArray = menuArray;
    }
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    if (!_iconArray) {
        _iconArray = [NSMutableArray array];
    }
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:menuArray];
    [self mergeIconArray];
    ////edit by ls 2018.4.10
    
    ///判断是否有红包
    for (int i = 0; i < _dataSource.count; i++) {
        if ([[_dataSource[i] objectForKey:@"key"] isEqualToString:@"shake"]) {
            
            isredenvelope=[[_dataSource[i] objectForKey:@"isredenvelope"] intValue];
            break;
        }
    }
    
    ///将处理过的数据转模型
    NSArray *array = [HomePropertyIconModel mj_objectArrayWithKeyValuesArray:_dataSource];
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:array];
    
    [UIView animateWithDuration:1 animations:^{
        _fuctionCollectionView.alpha = 1;
    }];
    
    if(_dataSource.count>4){
        
#warning mark - 当数组大于 8 个的时候需要将最后一个图标模型变成 显示全部服务样式
        if(_dataSource.count>=7){
            HomePropertyIconModel * homeModel = [[HomePropertyIconModel alloc]init];
            homeModel.key = @"more";
            [_dataSource insertObject:homeModel atIndex:7];
        }
        
    }else{
        
    }
    [self.fuctionCollectionView reloadData];
}

- (void)sortIconArray{
    // 首页图标升序
    NSArray * resultArray = @[];
    NSMutableArray * tempArray = @[].mutableCopy;
    // 首先遍历大数组
    for (PANewHomeMenuListModel * list in self.menuArray) {
        // 将所有的menuModel 添加到tempArray中
        for (PANewHomeMenuModel * menu in list.list) {
            [tempArray addObject:menu];
        }
    }
    //这里类似KVO的读取属性的方法，直接从字符串读取对象属性，注意不要写错
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"topsort" ascending:YES];
    //这个数组保存的是排序好的对象
    self.dataSource = [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    // resultArray 即排序后数组
    NSLog(@"排序完毕");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fuctionCollectionView reloadData];
    });
}
@end
