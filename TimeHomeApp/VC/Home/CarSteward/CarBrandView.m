//
//  CarBrandView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarBrandView.h"
#import "CarModelView.h"
#import "CarBrandCell.h"
#define W [UIScreen mainScreen].bounds.size.width*3/4

@implementation CarBrandView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createDataSource];
        [self crteateCollectionView];
        _shadowHidden = YES;
        _remove = NO;
        
    }
    return self;
}


#pragma mark -- 设置阴影
- (void)setShadowHidden:(BOOL)shadowHidden {
    
    if (shadowHidden != YES) {
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
        self.layer.shadowOpacity = 0.8;//不透明度
        self.layer.shadowRadius = 15.0;//半径
        self.layer.cornerRadius = 4;
    }
    
}



/**
 *移除view
 **/
- (void)setRemove:(BOOL)remove {
    
    if (remove == YES) {
        [self removeFromSuperview];
    }
}


#pragma amrk -- 创建collectionView
- (void)crteateCollectionView {
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;//行间距
    flow.minimumLineSpacing = 1; //列间距
    
    
    flow.itemSize = CGSizeMake(100,100);
    
    /**创建collectionView*/
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height - (44+statuBar_Height)) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_collectionView];
    
    /**注册*/
    [_collectionView registerNib:[UINib nibWithNibName:@"CarBrandCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

#pragma amrk -- collectionView数据源
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    for (int i = 0; i < 100; i++) {
        [_dataSource addObject:[NSString  stringWithFormat:@"%d",i]];
    }
    
    
}


#pragma amrk -- collectionViewdataSource And collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**cell*/
    CarBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    
    return cell;
}



//当前与四周的边界值
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 10, 8, 8);
}




//选中了某一个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CarBrandCell *cell = (CarBrandCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:cell.titleLabel.text,@"1" ,nil];
    NSNotification * notice = [NSNotification notificationWithName:@"T1" object:nil userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
    
    
    
    [_dataSource removeAllObjects];
    [_collectionView removeFromSuperview];
    
    
    CarModelView *view = [[CarModelView alloc] initWithFrame:CGRectMake(0, 0, W, [UIScreen mainScreen].bounds.size.height)];
//                          CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self addSubview:view];
    
    view.alpha = 0;
    
    [UIView animateWithDuration:0 animations:^{
        
        view.alpha = 1;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];

}
@end
