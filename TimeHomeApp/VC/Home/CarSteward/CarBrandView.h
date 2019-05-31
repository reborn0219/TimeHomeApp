//
//  CarBrandView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 * 车辆品牌
 **/

#import <UIKit/UIKit.h>

@interface CarBrandView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


/** collectionView */
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL shadowHidden;
@property (nonatomic,assign)BOOL remove;

@end
