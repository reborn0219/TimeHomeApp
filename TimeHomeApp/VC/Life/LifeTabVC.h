//
//  LifeTabVC.h
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 生活功能界面
 
 **/
#import "BaseViewController.h"

@interface LifeTabVC : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  集合视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
