//
//  PropertyManagementVC.h
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  物业服务VC
 */
#import "BaseViewController.h"

@interface PropertyManagementVC : THBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  集合视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
