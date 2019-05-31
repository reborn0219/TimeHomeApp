//
//  MyBigPictureFlowLayout
//  TimeHomeApp
//
//  Created by 赵思雨 on 17/7/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;
@end
@interface MyBigPictureFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<CustomViewFlowLayoutDelegate> delegate;
@end
