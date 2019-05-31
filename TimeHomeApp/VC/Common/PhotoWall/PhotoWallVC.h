//
//  PhotoWallVC.h
//  TimeHomeApp
//
//  Created by us on 16/4/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
@interface PhotoWallVC : THBaseViewController<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

///集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray * imgArray;
///最多选择图片数
@property(nonatomic,assign) NSInteger selectImgMaxNum;

/**
 *  返回实例
 *
 *  @return return value description
 */
+(PhotoWallVC *)getInstance;
@end
