//
//  PAChooseLicensePlateNumberView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAChooseLicensePlateNumberView.h"
#import "PAKeyboardCollectionCell.h"


@interface PAChooseLicensePlateNumberView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *paCollectionView;
@property (nonatomic, assign) CGAffineTransform theForm;
@property (nonatomic, copy) NSArray *tempArr;
@end
@implementation PAChooseLicensePlateNumberView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.theForm = self.transform;
    
    NSString * pstr =  @"京、津、冀、蒙、辽、鲁、晋、吉、苏、皖、豫、陕、黑、沪、浙、赣、鄂、湘、渝、川、甘、宁、粤、桂、贵、云、藏、青、新、琼、返回";
    self.tempArr = [pstr componentsSeparatedByString:@"、"];
    [self.paCollectionView registerNib:[UINib nibWithNibName:@"PAKeyboardCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PAKeyboardCollectionCell"];

}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PAKeyboardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PAKeyboardCollectionCell" forIndexPath:indexPath];
    cell.contentLb.text = self.tempArr[indexPath.item];
    if (indexPath.item == self.tempArr.count-1) {
        [cell.contentLb setFont:[UIFont systemFontOfSize:12.0f]];
        
    }else{
        [cell.contentLb setFont:[UIFont systemFontOfSize:14.0f]];

    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 0);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREEN_WIDTH-20-9*2)/10,(SCREEN_WIDTH-20-9*2)/10);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tempArr.count;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionReusableView new];
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 2;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.tempArr.count-1) {
        
        [self popupKeyBoard:NO];
    }else{
        
        if (self.block) {
            self.block(self.tempArr[indexPath.item], SucceedCode);
        }
    }
    
}
#pragma mark - 弹出键盘
-(void)popupKeyBoard:(BOOL)show{
    
    [UIView animateWithDuration:0.42f animations:^{
       
        if (show) {
            
            self.transform = CGAffineTransformTranslate(self.theForm,0,-self.popupAnimationDisplacement);

        }else{
            
            self.transform = CGAffineTransformTranslate(self.theForm, 0, 0);

        }
    }];
}
@end
