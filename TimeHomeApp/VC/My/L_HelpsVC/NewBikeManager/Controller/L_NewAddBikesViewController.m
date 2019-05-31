//
//  L_NewAddBikesViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewAddBikesViewController.h"
#import "L_NewBikeFirstTVC.h"
#import "L_NewBikeSecondTVC.h"
#import "L_NewBikeThirdTVC.h"
#import "L_NewBikeForthTVC.h"
#import "L_AddBikeFooterView.h"
#import "L_NewBikeImageTVC.h"
#import "QrCodeScanningVC.h"
//----------图片相关库---------------
#import "TZImagePickerController.h"
//图片剪裁库
#import "TOCropViewController.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"
#import "AppSystemSetPresenters.h"
#import "ImageUitls.h"
//----------图片相关库---------------

#import "L_BikeImageResourceModel.h"
#import "L_BikeDeviceModel.h"

#import "ChangAreaVC.h"

#import "L_NewBikeBottomPopViewController.h"
#import "L_NewBikeImageShowViewController.h"

#import "L_BikeManagerPresenter.h"

#import "L_PopAlertView4.h"
#import "L_PopAlertView3.h"


#import "L_MyBikeListVC.h"


@interface L_NewAddBikesViewController ()<UITableViewDelegate, UITableViewDataSource, BackValueDelegate, TZImagePickerControllerDelegate, TOCropViewControllerDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *electBikeBrandArray;
@property (nonatomic, strong) NSArray *bikesBrandArray;


@property (nonatomic, strong) NSMutableArray *imageCountArray;

/**
 行数
 */
@property (nonatomic, strong) NSMutableArray *rowCountArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *codeArray;

@property (nonatomic, assign) NSInteger codeIndex;
@property (nonatomic, assign) NSInteger codeScanIndex;

/**
 相册选择器
 */
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;

@end

@implementation L_NewAddBikesViewController

// MARK: - 修改自行车请求
- (void)httpRequestForMotifyBikeInfoWith:(L_BikeListModel *)bikeListModel{
    
    if ([XYString isBlankString:bikeListModel.brand]) {
        [self showToastMsg:@"请填写二轮车品牌" Duration:3.0];
        return;
    }
    
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (L_BikeDeviceModel *deviceModel in _codeArray) {
        if (![XYString isBlankString:deviceModel.deviceno]) {
            [deviceArray addObject:deviceModel.deviceno];
        }
    }
    NSString *deviceno = [deviceArray componentsJoinedByString:@","];
    
    NSString *defaultresourceid = @"";
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    for (L_BikeImageResourceModel *resourceModel in _imageCountArray) {
        if (![XYString isBlankString:resourceModel.resourceid]) {
            [resourceArray addObject:resourceModel.resourceid];
        }
        if (resourceModel.isdefault.integerValue == 1) {
            defaultresourceid = resourceModel.resourceid;
        }
    }
    NSString *resourceid = [resourceArray componentsJoinedByString:@","];
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_BikeManagerPresenter changeBikeWithID:_bikeListModel.theID deviceno:[XYString IsNotNull:deviceno] devicetype:[XYString IsNotNull:bikeListModel.devicetype] color:[XYString IsNotNull:bikeListModel.color] brand:[XYString IsNotNull:bikeListModel.brand] resourceid:[XYString IsNotNull:resourceid] defaultresourceid:[XYString IsNotNull:defaultresourceid] communityid:[XYString IsNotNull:bikeListModel.communityid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if (resultCode == SucceedCode) {

                if (self.completeBlock) {
                    self.completeBlock();
                }

                [self showToastMsg:@"二轮车修改完成" Duration:3.0];
                [self.navigationController popViewControllerAnimated:YES];

            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];

}

// MARK: - 添加自行车请求
- (void)httpRequestForAddBikeInfoWith:(L_BikeListModel *)bikeListModel {
    
    if ([XYString isBlankString:bikeListModel.brand]) {
        [self showToastMsg:@"请填写二轮车品牌" Duration:3.0];
        return;
    }
    
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (L_BikeDeviceModel *deviceModel in _codeArray) {
        if (![XYString isBlankString:deviceModel.deviceno]) {
            [deviceArray addObject:deviceModel.deviceno];
        }
    }
    NSString *deviceno = [deviceArray componentsJoinedByString:@","];
    
    NSString *defaultresourceid = @"";
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    for (L_BikeImageResourceModel *resourceModel in _imageCountArray) {
        if (![XYString isBlankString:resourceModel.resourceid]) {
            [resourceArray addObject:resourceModel.resourceid];
        }
        if (resourceModel.isdefault.integerValue == 1) {
            defaultresourceid = resourceModel.resourceid;
        }
    }
    NSString *resourceid = [resourceArray componentsJoinedByString:@","];
    
    if (kIsNewBikeList == 1) {
        
        if ([XYString isBlankString:deviceno]) {
            
            L_PopAlertView4 *popView = [L_PopAlertView4 getInstance];
            
            [popView showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                if (index == 1) {
                    //保存

                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];

                    [L_BikeManagerPresenter newAddUserBikeWithDeviceno:[XYString IsNotNull:deviceno] devicetype:[XYString IsNotNull:bikeListModel.devicetype] color:[XYString IsNotNull:bikeListModel.color] brand:[XYString IsNotNull:bikeListModel.brand] resourceid:[XYString IsNotNull:resourceid] defaultresourceid:[XYString IsNotNull:defaultresourceid] communityid:[XYString IsNotNull:bikeListModel.communityid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

                        dispatch_async(dispatch_get_main_queue(), ^{

                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                            if (resultCode == SucceedCode) {

                                if (_fromType == 1) {

                                    L_MyBikeListVC *bikeListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyBikeListVC"];
                                    bikeListVC.fromType = 1;
                                    [self.navigationController pushViewController:bikeListVC animated:YES];

                                }else {

                                    if (self.completeBlock) {
                                        self.completeBlock();
                                    }

                                    [self showToastMsg:@"二轮车添加完成" Duration:3.0];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0];
                            }
                            
                        });
                        
                    }];
                    
                }
                
            }];
            NSString *msg = @"您已经添加二轮车，\n但是尚未添加感应条码，现在保存吗？";
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:msg attributes:@{NSFontAttributeName:DEFAULT_FONT(15)}];
            [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(0,9)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(10, attributeString.length - 10)];
            popView.title_Label.attributedText = attributeString;
            
        }else {
            
            L_PopAlertView3 *popVC = [L_PopAlertView3 getInstance];
            
            [popVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                if (index == 1) {
                    //保存并锁定
                    
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    
                    [L_BikeManagerPresenter saveAndLockBikeWithDeviceno:[XYString IsNotNull:deviceno] devicetype:[XYString IsNotNull:bikeListModel.devicetype] color:[XYString IsNotNull:bikeListModel.color] brand:[XYString IsNotNull:bikeListModel.brand] resourceid:[XYString IsNotNull:resourceid] defaultresourceid:[XYString IsNotNull:defaultresourceid] communityid:[XYString IsNotNull:bikeListModel.communityid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if (resultCode == SucceedCode) {
                                
                                if (_fromType == 1) {
                                    
                                    L_MyBikeListVC *bikeListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyBikeListVC"];
                                    bikeListVC.fromType = 1;
                                    [self.navigationController pushViewController:bikeListVC animated:YES];
                                    
                                }else {
                                    
                                    if (self.completeBlock) {
                                        self.completeBlock();
                                    }
                                    
                                    [self showToastMsg:@"二轮车添加完成" Duration:3.0];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0];
                            }
                            
                        });
                        
                    }];
                    
                    
                }
                
                if (index == 2) {
                    //仅保存
                    
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    
                    [L_BikeManagerPresenter newAddUserBikeWithDeviceno:[XYString IsNotNull:deviceno] devicetype:[XYString IsNotNull:bikeListModel.devicetype] color:[XYString IsNotNull:bikeListModel.color] brand:[XYString IsNotNull:bikeListModel.brand] resourceid:[XYString IsNotNull:resourceid] defaultresourceid:[XYString IsNotNull:defaultresourceid] communityid:[XYString IsNotNull:bikeListModel.communityid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if (resultCode == SucceedCode) {
                                
                                if (_fromType == 1) {
                                    
                                    L_MyBikeListVC *bikeListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_MyBikeListVC"];
                                    bikeListVC.fromType = 1;
                                    [self.navigationController pushViewController:bikeListVC animated:YES];
                                    
                                }else {
                                    
                                    if (self.completeBlock) {
                                        self.completeBlock();
                                    }
                                    
                                    [self showToastMsg:@"二轮车添加完成" Duration:3.0];
                                    [self.navigationController popViewControllerAnimated:YES];
                                    
                                }
                                
                            }else {
                                [self showToastMsg:data Duration:3.0];
                            }
                            
                        });
                        
                    }];
                    
                }
                
            }];
            
            NSString *msg = @"您已经添加二轮车，是否立即保存并锁定?您的车辆，为您的爱车保驾护航？";
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:msg attributes:@{NSFontAttributeName:DEFAULT_FONT(15)}];
            [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(0,9)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(10, 10)];
            [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(20, attributeString.length - 20)];
            popVC.title_Label.attributedText = attributeString;
        }
        
        return;
        
    }else {
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
        [L_BikeManagerPresenter newAddUserBikeWithDeviceno:[XYString IsNotNull:deviceno] devicetype:[XYString IsNotNull:bikeListModel.devicetype] color:[XYString IsNotNull:bikeListModel.color] brand:[XYString IsNotNull:bikeListModel.brand] resourceid:[XYString IsNotNull:resourceid] defaultresourceid:[XYString IsNotNull:defaultresourceid] communityid:[XYString IsNotNull:bikeListModel.communityid] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
    
            dispatch_async(dispatch_get_main_queue(), ^{
    
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
    
                if (resultCode == SucceedCode) {
    
                    if (self.completeBlock) {
                        self.completeBlock();
                    }
    
                    [self showToastMsg:@"二轮车添加完成" Duration:3.0];
                    [self.navigationController popViewControllerAnimated:YES];
    
                }else {
                    [self showToastMsg:data Duration:3.0];
                }
                
            });
            
        }];
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BLACKGROUND_COLOR;
    
    _imageCountArray = [[NSMutableArray alloc] init];
    _codeArray = [[NSMutableArray alloc] init];

    if (_isFromEditing) {
        _codeIndex = 6;
        _rowCountArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",nil];

        if (_bikeListModel.resource.count > 0) {
            [_imageCountArray addObjectsFromArray:_bikeListModel.resource];
        }
        
        if (_bikeListModel.device.count > 0) {
            [_codeArray addObjectsFromArray:_bikeListModel.device];
            
            for (int i = 0 ; i < _bikeListModel.device.count; i++) {
                [_rowCountArray addObject:@""];
            }
            
        }
        
        self.navigationItem.title = @"修改二轮车";
        
    }else {
        _codeIndex = 5;
        _rowCountArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
        _bikeListModel = [[L_BikeListModel alloc] init];
        AppDelegate *appDlgt = GetAppDelegates;
        _bikeListModel.communityname = [XYString IsNotNull:appDlgt.userData.communityname];
        _bikeListModel.communityid = [XYString IsNotNull:appDlgt.userData.communityid];
        _bikeListModel.devicetype = @"1";

        self.navigationItem.title = @"添加二轮车";
        
        L_BikeDeviceModel *deviceModel = [[L_BikeDeviceModel alloc] init];
        [_codeArray addObject:deviceModel];
        [_rowCountArray addObject:@""];

    }
    
    _electBikeBrandArray = @[@"绿源",@"新日",@"捷安特",@"雅迪",@"阿米尼",@"洪都",@"雅马哈",@"爱玛",@"小鸟",@"邦德.富士达"];
    _bikesBrandArray = @[@"捷安特",@"美利达",@"阿米尼",@"永久",@"凤凰",@"邦德.富士达",@"崔克",@"迪卡侬",@"捷马",@"喜德盛"];

    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeFirstTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeFirstTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeSecondTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeSecondTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeThirdTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeThirdTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeForthTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeForthTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_NewBikeImageTVC" bundle:nil] forCellReuseIdentifier:@"L_NewBikeImageTVC"];

    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZXCFD];
    
//    [TalkingData trackPageBegin:@"newbiycle"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate *appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZXCFD}];
    
//    [TalkingData trackPageEnd:@"newbiycle"];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowCountArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!_isFromEditing) {
        if (indexPath.row < 3) {
            return 50;
        }else if (indexPath.row == 3) {
            return _bikeListModel.imageRowHeight;
        }else if (indexPath.row == 4) {
            return 50;
        }else{
            return 80;
        }
    }else {
        if (indexPath.row < 4) {
            
            if (indexPath.row == 1) {
                return _bikeListModel.motifyBikenoRowHeight;
            }else {
                return 50;
            }
            
        }else if (indexPath.row == 4) {
            return _bikeListModel.imageRowHeight;
        }else if (indexPath.row == 5) {
            return 50;
        }else{
            return 80;
        }
    }
    
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    L_AddBikeFooterView *footerView = [L_AddBikeFooterView instanceAddBikeFooterView];
    
    footerView.twoButtonDidTouchCallBack = ^(NSInteger buttonIndex) {
      
        [self.view endEditing:YES];

        //1.添加感应条码 2.提交
        NSLog(@"==%ld",(long)buttonIndex);
        
        if (buttonIndex == 1) {
            
            if (_codeArray.count > 0) {
                
                L_BikeDeviceModel *deviceModel = [_codeArray lastObject];
                
                if ([XYString isBlankString:deviceModel.deviceno]) {
                    [self showToastMsg:@"请先完善上一个感应条码内容" Duration:3.0];
                    return ;
                }
                
            }
            
            [_rowCountArray addObject:@""];

            L_BikeDeviceModel *deviceModel = [[L_BikeDeviceModel alloc] init];
            [_codeArray addObject:deviceModel];
            
            [_tableView reloadData];
            
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowCountArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        }
        
        if (buttonIndex == 2) {
            
            if (_isFromEditing) {
                [self httpRequestForMotifyBikeInfoWith:_bikeListModel];
            }else {
                [self httpRequestForAddBikeInfoWith:_bikeListModel];
            }
            
        }
        
    };
    
    return footerView;
}

// MARK: - 选择社区
- (L_NewBikeFirstTVC *)L_NewBikeFirstTVCForTableView:(UITableView *)tableView {
    L_NewBikeFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeFirstTVC"];

    if (_isFromEditing) {
        cell.type = 3;
    }else {
        cell.type = 1;
    }
    cell.model = _bikeListModel;
    
    return cell;
}
// MARK: - 车辆编码
- (L_NewBikeFirstTVC *)L_NewBikeFirstTVC2ForTableView:(UITableView *)tableView {
    L_NewBikeFirstTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeFirstTVC"];
    
    cell.type = 2;
    cell.model = _bikeListModel;
    
    return cell;
}
// MARK: - 车辆类型
- (L_NewBikeSecondTVC *)L_NewBikeSecondTVCForTableView:(UITableView *)tableView {
    
    L_NewBikeSecondTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeSecondTVC"];
    
    cell.model = _bikeListModel;
    
    return cell;
}
// MARK: - 车辆品牌
- (L_NewBikeThirdTVC *)L_NewBikeThirdTVCForTableView:(UITableView *)tableView {
    
    L_NewBikeThirdTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeThirdTVC"];

    cell.type = 1;

    cell.leftTitleLabel.text = @"车辆品牌";
    cell.textField.placeholder = @"输入品牌名";
    cell.textField.text = [XYString IsNotNull:_bikeListModel.brand];
    
    cell.textFieldBlock = ^(NSString *string) {
        _bikeListModel.brand = string;
    };
    

    cell.buttonDidTouchBlock = ^(){
        
        [self.view endEditing:YES];

        NSArray *array;
        //自行车类型 0 自行车 1 电动车
        if (_bikeListModel.devicetype.integerValue == 1) {
            array = [_electBikeBrandArray copy];
        }else {
            array = [_bikesBrandArray copy];
        }
        
        L_NewBikeBottomPopViewController *popView = [L_NewBikeBottomPopViewController getInstance];
        [popView showVC:self withDataArray:array cellEvent:^(NSString *selectedString) {
            
            _bikeListModel.brand = selectedString;
            [_tableView reloadData];
            
        }];
        
    };
    
    return cell;
}
#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    L_BikeImageResourceModel *photoModel = self.imageCountArray[index];
    
    return  photoModel.image == nil ? PLACEHOLDER_IMAGE : photoModel.image;
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    L_BikeImageResourceModel *photoModel = self.imageCountArray[index];
    return [NSURL URLWithString:photoModel.resourceurl];
    
}
// MARK: - 车辆照片
- (L_NewBikeImageTVC *)L_NewBikeImageTVCForTableView:(UITableView *)tableView {
    
    L_NewBikeImageTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeImageTVC"];
    
    cell.model = _bikeListModel;
    
    cell.allButtonsDidTouchBlock = ^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex==%ld",(long)buttonIndex);
        //sender.tag == 1.右上角按钮 2.3.4 展示照片按钮 5 添加图片 6.7.8删除按钮 9.10.11图片点击
        if (buttonIndex == 1) {
            L_NewBikeImageShowViewController *imageShowVC = [L_NewBikeImageShowViewController getInstance];
            [imageShowVC showVC:self withCallBack:^{
                
            }];
        }
        
        if (buttonIndex == 9 || buttonIndex == 10 || buttonIndex == 11) {
            
            SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
            browser.sourceImagesContainerView = self.view;
            browser.imageCount = _imageCountArray.count;
            browser.currentImageIndex = buttonIndex - 9;
            browser.delegate = self;
            [browser show]; // 展示图片浏览器
            
        }
        
        if (buttonIndex == 5) {
            
            if (_imageCountArray.count == 0) {
                L_NewBikeImageShowViewController *imageShowVC = [L_NewBikeImageShowViewController getInstance];
                [imageShowVC showVC:self withCallBack:^{
                    
                    [self addButtonDidClick];

                }];
            }else {
                [self addButtonDidClick];
            }

        }
        
        if (buttonIndex == 2 || buttonIndex == 3 || buttonIndex == 4) {
            
            L_BikeImageResourceModel *photoModel = _imageCountArray[buttonIndex - 2];
            
            if (photoModel.isdefault.integerValue == 0) {
                
                for (int i = 0; i < _imageCountArray.count; i++) {
                    L_BikeImageResourceModel *photoModel = _imageCountArray[i];
                    photoModel.isdefault = @"0";

                }
                L_BikeImageResourceModel *photoModel = _imageCountArray[buttonIndex - 2];
                photoModel.isdefault = @"1";

            }else {
                
                for (int i = 0; i < _imageCountArray.count; i++) {
                    L_BikeImageResourceModel *photoModel = _imageCountArray[i];
                    photoModel.isdefault = @"0";
                }
                
            }
            
        }
        
        if (buttonIndex == 6 || buttonIndex == 7 || buttonIndex == 8) {
            [_imageCountArray removeObjectAtIndex:buttonIndex - 6];
            
            /** 默认第一张图片为首页显示图片 */
            if (_imageCountArray.count > 0) {
                NSInteger count = 0;
                for (int i = 0; i < _imageCountArray.count; i++) {
                    L_BikeImageResourceModel *photoModel = _imageCountArray[i];
                    if (photoModel.isdefault.integerValue == 0) {
                        count ++;
                    }
                }
                if (count == _imageCountArray.count) {
                    L_BikeImageResourceModel *photoModel = _imageCountArray[0];
                    photoModel.isdefault = @"1";

                }
            }
            
        }
        _bikeListModel.resource = [_imageCountArray copy];

        [_tableView reloadData];
        
    };
    
    return cell;

}
// MARK: - 车辆颜色
- (L_NewBikeThirdTVC *)L_NewBikeThirdTVC2ForTableView:(UITableView *)tableView {
    
    L_NewBikeThirdTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeThirdTVC"];

    cell.type = 2;
    cell.leftTitleLabel.text = @"车辆颜色";
    cell.textField.placeholder = @"输入车辆颜色";
    cell.textField.text = [XYString IsNotNull:_bikeListModel.color];
    
    cell.leftImageView.hidden = YES;
    
    cell.textFieldBlock = ^(NSString *string) {
        _bikeListModel.color = string;
    };
    
    return cell;
}
// MARK: - 感应条码
- (L_NewBikeForthTVC *)L_NewBikeForthTVCForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    L_NewBikeForthTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_NewBikeForthTVC"];
    
    L_BikeDeviceModel *deviceModel = _codeArray[indexPath.row - _codeIndex];
    
    cell.codeString = [XYString IsNotNull:deviceModel.deviceno];
    
    cell.trailingLayout.constant = 52;
    cell.deleteButton.hidden = NO;
    cell.scanButton.hidden = NO;
    cell.scan_ImageView.hidden = NO;
    cell.tfTrailingLayout.constant = 5;

    /** 自行车是否锁定：0否1是 */
    if (_bikeListModel.islock.integerValue == 1) {
        
        if (_bikeListModel.device.count > 0) {
            
            if ((indexPath.row - _codeIndex) < _bikeListModel.device.count) {
                
                cell.textField.enabled = NO;
//                [cell.deleteButton setBackgroundColor:NEW_GRAY_COLOR];
                
                NSLog(@"已锁定车辆不能删除已有的感应条码");//隐藏扫描和删除按钮

                cell.trailingLayout.constant = 17;
                cell.deleteButton.hidden = YES;
                cell.scanButton.hidden = YES;
                cell.scan_ImageView.hidden = YES;
                cell.tfTrailingLayout.constant = -35;

            }else {
                
                cell.textField.enabled = YES;
//                [cell.deleteButton setBackgroundColor:kNewRedColor];

            }
            
        }else {
            cell.textField.enabled = YES;
//            [cell.deleteButton setBackgroundColor:kNewRedColor];

        }
        
    }
    
    cell.tFTextCallBack = ^(NSString *string){
        NSLog(@"string======%@",string);
        
        L_BikeDeviceModel *deviceModel = _codeArray[indexPath.row - _codeIndex];
        deviceModel.deviceno = [XYString IsNotNull:string];
        [_codeArray replaceObjectAtIndex:indexPath.row - _codeIndex withObject:deviceModel];
        
    };
    
    cell.allButtonDidTouchBlock = ^(NSInteger buttonIndex){
        /** 1.2扫描 3删除 */
        
        [self.view endEditing:YES];

        if (buttonIndex == 1 || buttonIndex == 2) {
            
            if (![self canOpenCamera]) {
                return;
            }
            
            _codeScanIndex = indexPath.row - _codeIndex;
            
            QrCodeScanningVC * QrCodeVc = [[QrCodeScanningVC alloc]init];
            QrCodeVc.isBikePush = @"1";
            QrCodeVc.delegate = self;
            [self.navigationController pushViewController:QrCodeVc animated:YES];
            
        }
        
        if (buttonIndex == 3) {
            
            /** 自行车是否锁定：0否1是 */
            if (_bikeListModel.islock.integerValue == 1) {
                
                if (_bikeListModel.device.count > 0) {
                    
                    if ((indexPath.row - _codeIndex) < _bikeListModel.device.count) {

                        NSLog(@"已锁定车辆不能删除已有的感应条码");//隐藏扫描和删除按钮
                        
                        return;
                    }
                    
                }
                
            }
            
            [_codeArray removeObjectAtIndex:indexPath.row - _codeIndex];
            [_rowCountArray removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
            
            //提示
//            CommonAlertVC *alertVC = [CommonAlertVC getInstance];
//            
//            [alertVC ShowAlert:self Title:@"温馨提示" Msg:[NSString stringWithFormat:@"是否删除该感应条码？"] oneBtn:@"取消" otherBtn:@"确定"];
//            
//            alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
//                
//                if (index == 1000) {
//                    /** 确定 */
//
//                }
//                
//            };

        }
        
    };
    
    return cell;
}
-(void)backValue:(NSString *)value
{
    L_BikeDeviceModel *deviceModel = _codeArray[_codeScanIndex];
    deviceModel.deviceno = [XYString IsNotNull:value];
    [_codeArray replaceObjectAtIndex:_codeScanIndex withObject:deviceModel];
    [_tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isFromEditing) {/** 添加 */
        
        if (indexPath.row == 0) {
            
            return [self L_NewBikeFirstTVCForTableView:tableView];
            
        }else if (indexPath.row == 1) {
            
            return [self L_NewBikeSecondTVCForTableView:tableView];
            
        }else if (indexPath.row == 2) {
            
            return [self L_NewBikeThirdTVCForTableView:tableView];
            
        }else if (indexPath.row == 3) {
            
            return [self L_NewBikeImageTVCForTableView:tableView];
            
        }else if (indexPath.row == 4) {
            
            return [self L_NewBikeThirdTVC2ForTableView:tableView];
            
        }else {
            
            return [self L_NewBikeForthTVCForTableView:tableView indexPath:indexPath];
            
        }

    }else {
        
        if (indexPath.row == 0) {
            
            return [self L_NewBikeFirstTVCForTableView:tableView];
            
        }else if (indexPath.row == 1) {
            
            return [self L_NewBikeFirstTVC2ForTableView:tableView];
            
        }else if (indexPath.row == 2) {
            
            return [self L_NewBikeSecondTVCForTableView:tableView];
            
        }else if (indexPath.row == 3) {
            
            return [self L_NewBikeThirdTVCForTableView:tableView];
            
        }else if (indexPath.row == 4) {
            
            return [self L_NewBikeImageTVCForTableView:tableView];
            
        }else if (indexPath.row == 5) {
            
            return [self L_NewBikeThirdTVC2ForTableView:tableView];
            
        }else {
            
            return [self L_NewBikeForthTVCForTableView:tableView indexPath:indexPath];
            
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        NSLog(@"选择小区");
        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ChangAreaVC * areaVC=[storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
        areaVC.pageSourceType = PAGE_SOURCE_TYPE_BIKE;
        areaVC.bikeCommunityID = [XYString IsNotNull:_bikeListModel.communityid];
        areaVC.bikeCommunityName = [XYString IsNotNull:_bikeListModel.communityname];
        
        areaVC.bikeCityid = [XYString IsNotNull:_bikeListModel.cityid];
        areaVC.bikeCityName = [XYString IsNotNull:_bikeListModel.cityname];
        
        areaVC.myCallBack = ^(NSString *selectID, NSString *selectName){
            
            _bikeListModel.communityid = [XYString IsNotNull:selectID];
            _bikeListModel.communityname = [XYString IsNotNull:selectName];
            [_tableView reloadData];

        };
        [self.navigationController pushViewController:areaVC animated:YES];
        
    }
    
}

// MARK: - 点击上传照片
- (void)addButtonDidClick {
    
    [self.view endEditing:YES];
    
    @WeakObj(self);
    // 类方法
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex==0)//拍照
        {
            
            /** 相机授权判断 */
            if (![self canOpenCamera]) {
                return ;
            };
            
            /**
             *  最多能选择数
             */
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.takePhotoOfMax = 1;
            cameraController.isSaveLocal = NO;
            cameraController.cameraSourceType = ZZImageSourceForSingle;
            cameraController.imageAspectRatio = TOCropViewControllerAspectRatio16x9;
            cameraController.isCanCustom = YES;
            
            cameraController.rotateClockwiseButtonHidden = NO;
            cameraController.rotateButtonsHidden = YES;
            cameraController.aspectRatioLocked = YES;
            
            [cameraController showIn:self result:^(id responseObject){
                
                NSLog(@"responseObject==%@",responseObject);
                
                UIImage *image = (UIImage *)responseObject;
                UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
                
                @WeakObj(self);
                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                
                [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        
                        if(resultCode == SucceedCode) {//图片上传成功
                            
                            NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                            L_BikeImageResourceModel *photoModel = [[L_BikeImageResourceModel alloc] init];
                            photoModel.resourceid = picID;
                            photoModel.image = image;
                            photoModel.resourceurl = [XYString IsNotNull:[data objectForKey:@"fileurl"]];
                            photoModel.isdefault = @"0";
                            [_imageCountArray addObject:photoModel];
                            
                            /** 默认第一张图片为首页显示图片 */
                            if (_imageCountArray.count > 0) {
                                NSInteger count = 0;
                                for (int i = 0; i < _imageCountArray.count; i++) {
                                    L_BikeImageResourceModel *photoModel = _imageCountArray[i];
                                    if (photoModel.isdefault.integerValue == 0) {
                                        count ++;
                                    }
                                }
                                if (count == _imageCountArray.count) {
                                    L_BikeImageResourceModel *photoModel = _imageCountArray[0];
                                    photoModel.isdefault = @"1";
                                    
                                }
                            }
                            
                            
                            _bikeListModel.resource = [_imageCountArray copy];

                            [_tableView reloadData];
                            
                        }else {//图片上传失败
                            
                            if ([data isKindOfClass:[NSString class]]) {
                                if (![XYString isBlankString:data]) {
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }else {
                                    [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                                }
                            }
                        }
                        
                        
                    });
                    
                }];
                
                
                
                
            }];
            
            
        }else if (buttonIndex==1)//相册
        {
            _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:selfWeak];
            _imagePickerVC.pickerDelegate = selfWeak;
            [self presentViewController:_imagePickerVC animated:YES completion:^{
                
            }];
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];
    
    
}
#pragma mark TZImagePickerControllerDelegate

// MARK: - 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
//    @WeakObj(self);
    _imagePickerVC = nil;
    
    [GCDQueue executeInGlobalQueue:^{
        [GCDQueue executeInMainQueue:^{
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:photos[0]];
            cropController.delegate = self;
            cropController.defaultAspectRatio = TOCropViewControllerAspectRatio16x9;
            cropController.rotateClockwiseButtonHidden = NO;
            cropController.rotateButtonsHidden = YES;
            cropController.aspectRatioLocked = YES;

            [self presentViewController:cropController animated:YES completion:nil];
            
        }];
        
    }];
    
}

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:^{
        
        UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
        
        @WeakObj(self);
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        
        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if(resultCode == SucceedCode) {//图片上传成功
                    
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    L_BikeImageResourceModel *photoModel = [[L_BikeImageResourceModel alloc] init];
                    photoModel.resourceid = picID;
                    photoModel.image = image;
                    photoModel.resourceurl = [XYString IsNotNull:[data objectForKey:@"fileurl"]];
                    photoModel.isdefault = @"0";

                    [_imageCountArray addObject:photoModel];
                    
                    /** 默认第一张图片为首页显示图片 */
                    if (_imageCountArray.count > 0) {
                        NSInteger count = 0;
                        for (int i = 0; i < _imageCountArray.count; i++) {
                            L_BikeImageResourceModel *photoModel = _imageCountArray[i];
                            if (photoModel.isdefault.integerValue == 0) {
                                count ++;
                            }
                        }
                        if (count == _imageCountArray.count) {
                            L_BikeImageResourceModel *photoModel = _imageCountArray[0];
                            photoModel.isdefault = @"1";
                            
                        }
                    }

                    _bikeListModel.resource = [_imageCountArray copy];

                    [_tableView reloadData];
                    
                }else {//图片上传失败
                    
                    if (![XYString isBlankString:data]) {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }else {
                        [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                    }

                }
                
                
            });
            
        }];
        
        
    }];
}
// MARK: - 取消编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:nil];
    
}


@end
