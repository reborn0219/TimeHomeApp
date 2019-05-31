//
//  ZSY_RightBrandHeaderView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_RightBrandHeaderView : UITableViewHeaderFooterView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**
 * 上方lable和view
 **/
@property (nonatomic, strong)UILabel *leftTitle;
@property (nonatomic, strong)UILabel *rightTitle;
@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;


@end
