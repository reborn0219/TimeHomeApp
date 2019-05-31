//
//  CarBrand.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


/**
 *汽车品牌
 **/
#import <UIKit/UIKit.h>

@interface CarBrand : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>


/** collectionView */
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UIViewController *controller;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *tableViewDataSource;

- (void)clickWithController:(UIViewController *)controller;
- (instancetype)initWithFrame:(CGRect)frame andController:(UIViewController *)controller;

@end
