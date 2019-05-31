//
//  L_CarNumberErrorViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarNumberErrorViewController.h"
#import "L_CarErrorApplyViewController.h"
#import "L_ErrorHistoryRecordViewController.h"

@interface L_CarNumberErrorViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIButton *btn_First;/** 车牌纠错申请 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Second;/** 纠错历史记录 */

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomLineView;/** 线 */



@end

@implementation L_CarNumberErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initForSomeView];
    
    [self.view layoutIfNeeded];

    if (_isFromPush) {
        [self secondBtnDidTouch];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ChePaiJiuCuo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ChePaiJiuCuo}];
}
- (void)secondBtnDidTouch {
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [_btn_First setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    [_btn_Second setTitleColor:kNewRedColor forState:UIControlStateNormal];
    
    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomLineView.frame = CGRectMake(_topBgView.frame.size.width * 0.5 * 1, _topBgView.frame.size.height-2, SCREEN_WIDTH * 0.5, 2);
        
    }];
    
}

#pragma mark - 上面按钮点击

- (IBAction)topTwoBtnDidTouch:(UIButton *)sender {
    
    /** tag 1.车牌纠错申请 2.纠错历史记录 */
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (sender.tag == 1) {
        
        [_btn_First setTitleColor:kNewRedColor forState:UIControlStateNormal];
        [_btn_Second setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        
    }else {
        
        [_btn_First setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        [_btn_Second setTitleColor:kNewRedColor forState:UIControlStateNormal];
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomLineView.frame = CGRectMake(_topBgView.frame.size.width * 0.5 * (sender.tag-1), _topBgView.frame.size.height-2, SCREEN_WIDTH * 0.5, 2);
        
    }];
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"scrollView=====%f",scrollView.contentOffset.x);
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        int offsetXIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        if (offsetXIndex == 0) {
            
            [_btn_First setTitleColor:kNewRedColor forState:UIControlStateNormal];
            [_btn_Second setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            
        }else {
            
            [_btn_First setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            [_btn_Second setTitleColor:kNewRedColor forState:UIControlStateNormal];
            
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _bottomLineView.frame = CGRectMake(_topBgView.frame.size.width * 0.5 * offsetXIndex, _topBgView.frame.size.height-2, SCREEN_WIDTH * 0.5, 2);
            
        }];
        
    }
    
}

#pragma mark - 初始设置一些view

- (void)initForSomeView {
    
//    [_topBgView layoutIfNeeded];
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topBgView.frame.size.height-2, SCREEN_WIDTH * 0.5, 2)];
    _bottomLineView.backgroundColor = kNewRedColor;
    [_topBgView addSubview:_bottomLineView];
    
    L_CarErrorApplyViewController *applyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_CarErrorApplyViewController"];
    [self addChildViewController:applyVC];
    
    L_ErrorHistoryRecordViewController *historyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_ErrorHistoryRecordViewController"];
    [self addChildViewController:historyVC];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT-(44+statuBar_Height)-56-8);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [UICollectionReusableView new];
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)-56-8);
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

@end

