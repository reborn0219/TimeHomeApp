//
//  CertificationSuccessfulVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CertificationSuccessfulVC.h"
#import "NibCell.h"
#import "CertificationSuccessfulHeaderView.h"
#import "L_NewMyHouseListViewController.h"//我的房产
#import "L_CertifyHoustListViewController.h"
#import "AppSystemSetPresenters.h"
#import "MainTabBars.h"
@interface CertificationSuccessfulVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *imageArr;
    NSMutableArray *titleArr;
}
@end

@implementation CertificationSuccessfulVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([_pushType isEqualToString:@"0"]) {
        /** rootViewController不允许侧滑 */
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"社区认证";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    [self setViews];
    
    ///创建collection和数据
    [self createCollection];
    [self createDataSource];
    
    if (_fromType == 1 || _fromType == 3) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
    if (_fromType == 2 || _fromType == 4 || _fromType == 5 || _fromType == 6) {
        
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (tempMarr.count > 0) {
            
            [tempMarr removeObjectAtIndex:tempMarr.count-2];
            
            [self.navigationController setViewControllers:tempMarr animated:NO];
            
        }
        
    }
    
}

/**
 UI设置
 */
- (void)setViews {
    
    if ([_pushType isEqualToString:@"1"]) {
        
        _twoBtnBgView.hidden = YES;
        _oneBtnBgView.hidden = NO;
        
    }else {
        _twoBtnBgView.hidden = NO;
        _oneBtnBgView.hidden = YES;
    }
    
    _leftBtn.layer.borderColor = NEW_RED_COLOR.CGColor;
    _leftBtn.layer.borderWidth = 1.0f;
    
    
    _rightBtn.layer.borderColor = NEW_RED_COLOR.CGColor;
    _rightBtn.layer.borderWidth = 1.0f;
    
    _cenertBtn.layer.borderColor = NEW_RED_COLOR.CGColor;
    _cenertBtn.layer.borderWidth = 1.0f;
    
    ///导航按钮
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    
    UIImage *image = [UIImage imageNamed:@"返回"];
    [leftButton setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
}
#pragma mark ------ 创建九宫格 and dataSource

/**
 九宫格
 */
- (void)createCollection {
    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    NSInteger interSpacing = 20;
    NSInteger lineSpacing = 30;
    viewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - interSpacing * 2 - 30 )/3 - 1 , (SCREEN_WIDTH - interSpacing * 3)/3 - 1);
    
    viewFlowLayout.headerReferenceSize=CGSizeMake(SCREEN_WIDTH, 220); //设置collectionView头视图的大小
    viewFlowLayout.minimumInteritemSpacing = interSpacing;
    viewFlowLayout.minimumLineSpacing = lineSpacing;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = viewFlowLayout;
    _collectionView.showsHorizontalScrollIndicator = NO; // 去掉滚动条
    _collectionView.showsVerticalScrollIndicator = NO; // 去掉滚动条
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"NibCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CertificationSuccessfulHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CertificationSuccessfulHeaderView"];
}


/**
 数据源
 */
- (void)createDataSource {
    if (!imageArr) {
        imageArr = [[NSMutableArray alloc] init];
    }
    
    [imageArr addObjectsFromArray:@[@"专属服务",@"智能门禁",@"邀请同行",@"在线报修",@"意见建议",@"共享房产",@"智能梯控",@"发帖",@"更多"]];
    
    if (!titleArr) {
        titleArr = [[NSMutableArray alloc] init];
    }
    
    [titleArr addObjectsFromArray:@[@"专属标识",@"智能门禁",@"邀请访客",@"在线报修",@"投诉建议",@"房产共享",@"智能梯控",@"发帖特权",@"敬请期待"]];
}

#pragma mark ---- 九宫格代理

#pragma mark -- collectiuonViewDelegate,collectiuonViewDateSource


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            CertificationSuccessfulHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CertificationSuccessfulHeaderView" forIndexPath:indexPath];
            
            NSString *str1 = _communityName;
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您已经成功认证为 %@ 社区的业主，可以享受业主专属特权哦",str1]];
            [attribute addAttribute:NSForegroundColorAttributeName value:LIGHT_ORANGE_COLOR range:NSMakeRange(9, str1.length)];
            header.msglabel.attributedText =  attribute;
            
            
            return header;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NibCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NibCell" forIndexPath:indexPath];
    cell.iconImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = titleArr[indexPath.row];
    return cell;
    
}

#pragma mark ---- 按钮点击事件

/**
 查看社区房产
 */
- (IBAction)leftBtnClick:(id)sender {

    if ([_isMyPush isEqualToString:@"0"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
        L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
        houseListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:houseListVC animated:YES];
        
    }else {
        
        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in marr) {
            if ([vc isKindOfClass:[L_CertifyHoustListViewController class]]) {
                [marr removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = marr;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

/**
 进入平安社区
 */
- (IBAction)rightBtnClick:(id)sender {
    
    [AppSystemSetPresenters getBindingTag];
    AppDelegate *appDelegate = GetAppDelegates;
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
    MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
    appDelegate.window.rootViewController=MainTabBar;
    
    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
    [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
    
}

/**
 导航返回按钮
 */
- (void)backButtonClick {
    if ([_pushType integerValue] == 0) {
        
        //进入平安社区
        [AppSystemSetPresenters getBindingTag];
        AppDelegate *appDelegate = GetAppDelegates;
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        appDelegate.window.rootViewController=MainTabBar;
        
        CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
        [MainTabBar.view.window.layer addAnimation:animation forKey:nil];

    }else {
        [super backButtonClick];
    }
}
@end
