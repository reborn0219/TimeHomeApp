//
//  L_MyPublishViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyPublishViewController.h"

#import "L_OnSaleViewController.h"
#import "L_DownSaleViewController.h"
#import "L_OtherViewController.h"

@interface L_MyPublishViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftLIine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

/**
 上方背景view
 */
@property (weak, nonatomic) IBOutlet UIView *topBgView;

/**
 在售按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *onSaleButton;

/**
 下架按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *downSaleButton;

/**
 其他按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

/**
 下方VC布局
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomLineView;

@end
//65
@implementation L_MyPublishViewController

- (IBAction)threeButtonDidClick:(UIButton *)sender {
    
    if (sender.tag == _selectIndex) {
        return;
    }
    
    UIButton *button = [self.view viewWithTag:_selectIndex];
    [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    
    [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
    _selectIndex = sender.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/3.f/2.f-33 + SCREEN_WIDTH/3.f*(_selectIndex - 1), 52 , 66, 2);

    }];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    if (sender.tag == 1) {
        NSLog(@"在售");
    }else if (sender.tag == 2) {
        NSLog(@"下架");
    }else {
        NSLog(@"其他");
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"scrollView=====%f",scrollView.contentOffset.x);
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        int offsetXIndex = scrollView.contentOffset.x / (SCREEN_WIDTH - 16);
        
        UIButton *button = [self.view viewWithTag:_selectIndex];
        [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        
        UIButton *sender = [self.view viewWithTag:offsetXIndex + 1];
        [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
        _selectIndex = offsetXIndex + 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/3.f/2.f-33 + SCREEN_WIDTH/3.f*(_selectIndex - 1), 52 , 66, 2);
            
        }];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:WoDeFaBu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":WoDeFaBu}];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (int i = 1; i < 4; i++) {
        UIButton *button = [self.view viewWithTag:i];
        [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    }
    
    UIButton *button = [self.view viewWithTag:_selectIndex];
    [button setTitleColor:kNewRedColor forState:UIControlStateNormal];
    _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/3.f/2.f-33 + SCREEN_WIDTH/3.f*(_selectIndex - 1), 52 , 66, 2);
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initForSomeView];             //初始设置一些view
}

- (void)backButtonClick {
    
    if (_isFromPush) {
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else {
        [super backButtonClick];
    }
    
}

/**
 初始设置一些view
 */
- (void)initForSomeView {
    
//    _selectIndex = 1;
    
    _leftLIine.layer.cornerRadius = 1;
    _rightLine.layer.cornerRadius = 1;
    
    [_onSaleButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = kNewRedColor;
    [_topBgView addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/3.f/2.f-33, 52 , 66, 2);
    
    L_OnSaleViewController *onSaleVC = [[L_OnSaleViewController alloc] init];
    [self addChildViewController:onSaleVC];
    
    L_DownSaleViewController *downSaleVC = [[L_DownSaleViewController alloc] init];
    [self addChildViewController:downSaleVC];
    
    L_OtherViewController *otherVC = [[L_OtherViewController alloc] init];
    [self addChildViewController:otherVC];
    
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    vc.view.frame = CGRectMake(0, 0, _collectionView.frame.size.width, _collectionView.frame.size.height);
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
    
}


@end
