//
//  PAParkingSpaceCollectionViewCell.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PACarSpaceModel;
@interface PACarSpaceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)PACarSpaceModel * spaceModel;
@property (nonatomic, copy) UpDateViewsBlock lockCarBlock;

- (void)hideParkingSpaceInfo;
@end
