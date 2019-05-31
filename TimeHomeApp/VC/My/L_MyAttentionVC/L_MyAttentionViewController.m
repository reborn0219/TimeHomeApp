//
//  L_MyAttentionViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyAttentionViewController.h"
#import "L_ActivesViewController.h"
#import "L_PeoplesViewController.h"

@interface L_MyAttentionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
{
    NSInteger selectIndex;
}
/**
 用户按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *peoplesButton;

/**
 动态按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *activeButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@end

@implementation L_MyAttentionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:WoDeGuanZhu];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":WoDeGuanZhu}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initForSomeView];             //初始设置一些view
    
}

/**
 初始设置一些view
 */
- (void)initForSomeView {
    
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = kNewRedColor;
    [_topBgView addSubview:_bottomLineView];
    _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/2.f/2.f-33, 53 , 66, 2);
    [_topBgView bringSubviewToFront:_bottomLineView];
    
    selectIndex = 1;
    
    L_ActivesViewController *activeVC = [[L_ActivesViewController alloc] init];
    [self addChildViewController:activeVC];
    
    L_PeoplesViewController *peoplesVC = [[L_PeoplesViewController alloc] init];
    [self addChildViewController:peoplesVC];
    
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
}

/**
 动态,用户按钮点击
 */
- (IBAction)twoButtonDidTouch:(UIButton *)sender {
    
    if (sender.tag == selectIndex) {
        return;
    }
    
    UIButton *button = [self.view viewWithTag:selectIndex];
    [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    
    [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
    selectIndex = sender.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/2.f/2.f-33 + SCREEN_WIDTH/2.f*(selectIndex - 1), 53 , 66, 2);
        
    }];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    if (sender.tag == 1) {
        NSLog(@"动态");
    }else {
        NSLog(@"用户");
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"scrollView=====%f",scrollView.contentOffset.x);
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
        int offsetXIndex = scrollView.contentOffset.x / (SCREEN_WIDTH - 16);
        
        UIButton *button = [self.view viewWithTag:selectIndex];
        [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        
        UIButton *sender = [self.view viewWithTag:offsetXIndex + 1];
        [sender setTitleColor:kNewRedColor forState:UIControlStateNormal];
        selectIndex = offsetXIndex + 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _bottomLineView.frame = CGRectMake(SCREEN_WIDTH/2.f/2.f-33 + SCREEN_WIDTH/2.f*(selectIndex - 1), 53 , 66, 2);
            
        }];
        
    }
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath; {
    return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
}


@end
