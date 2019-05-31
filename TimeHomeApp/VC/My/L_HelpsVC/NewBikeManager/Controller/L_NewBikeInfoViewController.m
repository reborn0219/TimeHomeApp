//
//  L_NewBikeInfoViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeInfoViewController.h"

#import "L_NewBikeInfoTitle1TableViewCell.h"
#import "L_NewBikeInfoImageTVC.h"
#import "L_NewBikeInfoBarcode3TableViewCell.h"
#import "L_NewBikeInfoStyle1TVC.h"

#import "L_NewBikeSharedViewController.h"

#import "L_GarageTimeSetInfoViewController.h"

#import "RegularUtils.h"
#import "SysPresenter.h"
#import "ParkingCarModel.h"
#import "ContactServiceVC.h"
#import "L_BikeManagerPresenter.h"

@interface L_NewBikeInfoViewController ()<UITableViewDelegate, UITableViewDataSource, SDPhotoBrowserDelegate>
{
    NSInteger sectionsCount;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) L_BikeListModel *bikeModel;

/**
 共享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/**
 定时锁车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *lockButton;

@end

@implementation L_NewBikeInfoViewController

// MARK: - 二轮车详情
- (void)httpRequestForGetBikeInfoIsShowIndicator:(BOOL)showIndicator {

    if (showIndicator) {
        THIndicatorVCStart
    }
    
    NSString *bikeIDStr;
    if ([_bikeListType isEqualToString:@"1"]) {
        bikeIDStr = _theID;

    }else {
        bikeIDStr = _bikeID;
    }
    
    [L_BikeManagerPresenter getNewBikeInfoWithID:bikeIDStr UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            sectionsCount = 4;
            
            if (showIndicator) {
                THIndicatorVCStopAnimating
            }
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                _bikeModel = (L_BikeListModel *)data;
                
                if (_bikeModel.isshare.integerValue == 2) {
                    _shareButton.backgroundColor = NEW_GRAY_COLOR;
                }
                
                if (_bikeModel.device.count == 0) {
                    _lockButton.backgroundColor = NEW_GRAY_COLOR;
                }
                
                [_tableView reloadData];
                
            }else {
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];

                [self.view bringSubviewToFront:self.nothingnessView];
                
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.tableFooterView = [UIView new];
    
    sectionsCount = 0;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeInfoTitle1TableViewCell" bundle:nil] forCellReuseIdentifier:@"L_NewBikeInfoTitle1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeInfoImageTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeInfoImageTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeInfoBarcode3TableViewCell" bundle:nil] forCellReuseIdentifier:@"L_NewBikeInfoBarcode3TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeInfoStyle1TVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeInfoStyle1TVC"];
    
    if ([XYString isBlankString:_theID]) {
        
        [self showToastMsg:@"获取二轮车详情失败" Duration:3.0];
        [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];

        [self.view bringSubviewToFront:self.nothingnessView];
        
    }else {
        
        @WeakObj(self)
//        _bikeID = _theID;
        _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
            [selfWeak httpRequestForGetBikeInfoIsShowIndicator:NO];
        }];
        
//        [_tableView.mj_header beginRefreshing];
        [selfWeak httpRequestForGetBikeInfoIsShowIndicator:YES];

    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZXCFD];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZXCFD}];
}
// MARK: - 底部按钮点击
- (IBAction)threeButtonDidTouch:(UIButton *)sender {
    // 1.联系物业 2.共享 3.定时锁车
    NSLog(@"sender.tag=======%ld",(long)sender.tag);
    
    if (sender.tag == 1) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ContactServiceVC * contactsVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
        contactsVC.isFromBikeInfo = YES;
        contactsVC.communityID = _bikeModel.communityid;
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
    
    if (sender.tag == 2) {
        
        if (_bikeModel.isshare.integerValue == 2) {
            return;
        }
        
        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        L_NewBikeSharedViewController *sharedVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeSharedViewController"];
        
        sharedVC.bikeID = _bikeModel.theID;
        
        [self.navigationController pushViewController:sharedVC animated:YES];
    }
    
    if (sender.tag == 3) {
        
        if (_bikeModel.device.count == 0) {
            return;
        }
        
        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        L_GarageTimeSetInfoViewController *timeInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"L_GarageTimeSetInfoViewController"];
        timeInfoVC.bikeID = _bikeModel.theID;
        timeInfoVC.isFromBike = YES;
        [self.navigationController pushViewController:timeInfoVC animated:YES];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }else if (section == 1) {
        return _bikeModel.device.count;
    }else if (section == 2) {
        return 2;
    }else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        if (_bikeModel.resource.count == 0) {
            return 0;
        }else {
            return 10;
        }
    }
    
    if (section == 1) {
        if (_bikeModel.device.count == 0) {
            return 0;
        }else {
            return 10;
        }
    }
    
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        if (_bikeModel.device.count > 0) {
            return 30;
        }else {
            return 0;
        }
        
    }else if (section == 2) {
        
        return 30;
        
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        label.text = @"关联感应条码";
        label.textColor = TITLE_TEXT_COLOR;
        label.font = DEFAULT_BOLDFONT(16);
        [bgView addSubview:label];
        
        return bgView;
        
    }else if (section == 2) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        label.text = @"社区信息";
        label.textColor = TITLE_TEXT_COLOR;
        label.font = DEFAULT_BOLDFONT(16);
        [bgView addSubview:label];
        
        return bgView;
        
    }else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return _bikeModel.infoFirstRowHeight;
    }else if (indexPath.section == 3) {
        return _bikeModel.infoSecondRowHeight;
    }else if (indexPath.section == 1){
        
        if (_bikeModel.device.count > 0) {
            L_BikeDeviceModel *deviceModel = _bikeModel.device[indexPath.row];
            return deviceModel.rowHeight;
            
        }else {
            return 0;
        }
        
    }else {
        return 40;
    }
}
#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    L_BikeImageResourceModel *photoModel = _bikeModel.resource[index];
    
    return  photoModel.image == nil ? PLACEHOLDER_IMAGE : photoModel.image;
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    L_BikeImageResourceModel *photoModel = _bikeModel.resource[index];
    return [NSURL URLWithString:photoModel.resourceurl];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        L_NewBikeInfoTitle1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeInfoTitle1TableViewCell"];
        
        cell.bikeModel = _bikeModel;
        
        return cell;
        
    }else if (indexPath.section == 3) {
        
        L_NewBikeInfoImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeInfoImageTVC"];
        
        cell.bikeModel = _bikeModel;
        
        cell.imageButtonDidTouchBlock = ^(NSInteger buttonIndex) {
          
            SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
            browser.sourceImagesContainerView = self.view;
            browser.imageCount = _bikeModel.resource.count;
            browser.currentImageIndex = buttonIndex - 1;
            browser.delegate = self;
            [browser show]; // 展示图片浏览器
            
        };
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        L_NewBikeInfoBarcode3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeInfoBarcode3TableViewCell"];
        
        if (_bikeModel.device.count > 0 ) {
            L_BikeDeviceModel *deviceModel = _bikeModel.device[indexPath.row];
            cell.deviceModel = deviceModel;
            cell.leftTitleLabel.text = [NSString stringWithFormat:@"关联感应条码 %ld :",indexPath.row + 1];
        }
        
        return cell;
        
    }else {
        
        L_NewBikeInfoStyle1TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeInfoStyle1TVC"];
        
        if (indexPath.row == 0) {
            cell.leftTitleLabel.text = [NSString stringWithFormat:@"所属区域: %@",[XYString IsNotNull:_bikeModel.areaname]];
        }else {
            cell.leftTitleLabel.text = [NSString stringWithFormat:@"所属社区: %@",[XYString IsNotNull:_bikeModel.communityname]];
        }
        
        return cell;
        
    }

}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 15;
    if (indexPath.section == 0 || indexPath.section == 3) {
        width = (SCREEN_WIDTH - 16)/2;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
}

@end
