//
//  PACarportManagermentController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceManagermentViewController.h"
#import "PACarSpaceCollectionViewCell.h"
#import "PACarSpaceDetailViewController.h"
#import "PACarSpaceModel.h"
#import "PACarSpaceService.h"
#import "PACarSpaceLockService.h"
#import "PACarSpaceRentDetailViewController.h"
@interface PACarSpaceManagermentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PABaseServiceDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) PACarSpaceService * carService;
@end

@implementation PACarSpaceManagermentViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.view);
    }];
    @WeakObj(self);
    self.collectionView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
         [selfWeak.carService loadData];
    }];
    [self.carService loadData];
    
}
- (PACarSpaceService *)carService{
    if (!_carService) {
        _carService = [[PACarSpaceService alloc]init];
        _carService.delegate = self;
    }
    return _carService;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3, 150);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//上左下右
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 35);
        flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 8);
        _collectionView  = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PACarSpaceCollectionViewCell class] forCellWithReuseIdentifier:@"PAPARKSPACECELLID"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CARPORTHEADER"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CARPORTFOOTER"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)loadDataSuccess{
    
    [self.collectionView.mj_header endRefreshing];
    
    if (self.carService.personalCarportArray.count==0 && self.carService.rentCarportArray.count == 0) {
        [self.collectionView setHidden:YES];
        [self showNothingnessViewWithType:NoAssociatedVehicle Msg:@"暂时没有车位信息" eventCallBack:nil];
    } else {
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    }
    
}

- (void)loadDataFailed:(NSString *)errorMsg{
    [self.collectionView setHidden:YES];
    [self showNothingnessViewWithType:NoAssociatedVehicle Msg:@"暂时没有车位信息" eventCallBack:nil];
    
}
#pragma mark - Actions
/**
 锁车事件
 @param parameter 锁车参数 由车位IDparkingSpaceId 入库车牌号carNo 锁车状态组成carLockState 字典
 */
- (void)lockCarAction:(NSDictionary *)parameter indexPath:(NSIndexPath *)indexPath{
    
    [YYPlaySound playSoundWithResourceName:@"锁车解锁提示音" ofType:@"wav"];
    PACarSpaceLockService * lockCarService = [[PACarSpaceLockService alloc]init];
    [lockCarService lockCarWithParkingSpaceId:parameter[@"parkingSpaceId"] carNo:parameter[@"carNo"] lockState:[parameter[@"carLockState"]integerValue]];
     PACarSpaceModel * spaceModel = self.carService.personalCarportArray[indexPath.item];
    spaceModel.carLockState = !spaceModel.carLockState;
    
}

#pragma mark  Collection Delegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.carService.titleArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section ? self.carService.rentCarportArray.count : self.carService.personalCarportArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CARPORTHEADER" forIndexPath:indexPath];
        for (UIView *subview  in header.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorHex(0x4A4A4A);
        titleLabel.text = self.carService.titleArray[indexPath.section];
        [header addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).with.offset(14);
            make.centerY.equalTo(header);
        }];
        reusableview = header;
        
    } else {
        
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CARPORTFOOTER" forIndexPath:indexPath];
        footer.backgroundColor = UIColorHex(0xF5F5F5);
        reusableview = footer;
        
    }
    return reusableview;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PACarSpaceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PAPARKSPACECELLID" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell hideParkingSpaceInfo:NO];
        cell.spaceModel =  self.carService.personalCarportArray[indexPath.item];
    } else {
        [cell hideParkingSpaceInfo:YES];
        PACarSpaceModel * spaceModel = self.carService.rentCarportArray[indexPath.item];
        cell.spaceModel = spaceModel;
        [cell hideParkingSpaceInfo:YES];
    }
    @WeakObj(self);
    cell.lockCarBlock = ^(id  _Nullable data, ResultCode resultCode) {
        [selfWeak lockCarAction:data indexPath:indexPath];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    THBaseViewController * controller;
    PACarSpaceModel * spaceModel = indexPath.section ? self.carService.rentCarportArray[indexPath.item] : self.carService.personalCarportArray[indexPath.item];
    @WeakObj(self);
    if (indexPath.section == 0) {
        
        PACarSpaceDetailViewController * carport = [[PACarSpaceDetailViewController alloc]init];
        carport.limitapp = self.carService.limitapp.intValue;
        carport.parkingSpace = spaceModel;
        carport.title = spaceModel.parkingSpaceName;
        carport.rentSuccessBlock = ^(id  _Nullable data, ResultCode resultCode) {
            [selfWeak.carService loadData];
        };
        controller = carport;
        
    } else {
        
        PACarSpaceRentDetailViewController * rentDetail = [[PACarSpaceRentDetailViewController alloc]init];
        rentDetail.parkingSpace = spaceModel;
        rentDetail.title = spaceModel.parkingSpaceName;
        rentDetail.reloadParkingSpaceBlock = ^(id  _Nullable data, ResultCode resultCode) {
            [selfWeak.carService loadData];
        };
        controller = rentDetail;
        
    }
    [self.navigationController pushViewController:controller animated:YES];
}

@end

