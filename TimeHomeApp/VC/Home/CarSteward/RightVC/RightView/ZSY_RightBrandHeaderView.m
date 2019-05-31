//
//  ZSY_RightBrandHeaderView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_RightBrandHeaderView.h"
#import "ZSY_RightBrandCell.h"
#import "ZSY_RightCarModelVC.h"
#import "ZSY_AllCarBrandModel.h"

#define COLLECTIONVIEW_HEIGHT self.frame.size.height - CGRectGetMaxY(_lineView.frame) + 5)
@implementation ZSY_RightBrandHeaderView

- (instancetype)initWithFrame:(CGRect)frame 
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createTopUI];
        
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    [self createCollectionViewDataSource];
    [self createCollectionView];
    
    [_collectionView reloadData];
    
}

- (void)createTopUI {
    
    
    _leftTitle = [[UILabel alloc] init];
    _leftTitle.textColor = [UIColor blackColor];
    _leftTitle.text = @"HOT";
    if (SCREEN_WIDTH <= 320) {
        _leftTitle.font = [UIFont boldSystemFontOfSize:12];
    }
    _leftTitle.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_leftTitle];
    _leftTitle.sd_layout.topSpaceToView(self,8).leftSpaceToView(self,8).heightIs(21).widthIs(30);
    
    
    _rightTitle = [[UILabel alloc] init];
    _rightTitle.textColor = [UIColor blackColor];
    _rightTitle.text = @"热门品牌";
    if (SCREEN_WIDTH <= 320) {
        _rightTitle.font = [UIFont boldSystemFontOfSize:12];
    }
    _rightTitle.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_rightTitle];
    _rightTitle.sd_layout.leftSpaceToView(_leftTitle,8).topEqualToView(_leftTitle).heightIs(21).widthIs(100);
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = BLACKGROUND_COLOR;
    [self addSubview:_lineView];
    _lineView.sd_layout.leftSpaceToView(self,5).rightSpaceToView(self,5).topSpaceToView(_leftTitle,5).heightIs(1);
    
}
#pragma amrk --- collectionView
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 1;//行间距
    flow.minimumLineSpacing = 5; //列间距
    
    flow.itemSize = CGSizeMake(self.frame.size.width / 4 - 4 * 5,(self.frame.size.width / 4 - 4 * 5)/2.*3);

//    flow.itemSize = CGSizeMake(self.frame.size.width / 4 - 4 * 5,(self.frame.size.height - 35 + 5)/2 - 2 * 5);
//    CGSizeMake(self.frame.size.width / 4 - 5 * 5,COLLECTIONVIEW_HEIGHT;
    
    /**创建collectionView*/
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35 + 5, self.frame.size.width-10, COLLECTIONVIEW_HEIGHT collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_collectionView];
    
    /**注册*/
    [_collectionView registerNib:[UINib nibWithNibName:@"ZSY_RightBrandCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

#pragma amrk -- collectionView数据源
- (void)createCollectionViewDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
//    for (int i = 0; i < 8; i++) {
//        [_dataSource addObject:[NSString  stringWithFormat:@"%d",i]];
//    }
    
    
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
    ZSY_AllCarBrandModel *model = _dataSource[indexPath.row];
    ZSY_RightBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
//    cell.carNameLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.carNameLabel.text = model.name;
//    [cell.carIconView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
//    [cell.carIconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PIC_URL,model.picurl]] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    [cell.carIconView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    return cell;
}



//当前与四周的边界值
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 10, 8, 8);
}




//选中了某一个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        ZSY_RightBrandCell *cell = (ZSY_RightBrandCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    ZSY_AllCarBrandModel *model = _dataSource[indexPath.row];
    ZSY_RightCarModelVC *carModel = [[ZSY_RightCarModelVC alloc] init];
    carModel.headerStr = cell.carNameLabel.text;
    carModel.brandID = model.ID;
    [[self viewController].navigationController pushViewController:carModel animated:YES];
    
}
                                                                         
                                                                         
//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



@end
