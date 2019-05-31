//
//  PAWaterDispenserController.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterDispenserController.h"
#import "PAWaterEquipmentCardCell.h"
#import "PAWaterMoneyCardCell.h"
#import "PAWaterCostCardcell.h"
#import "PAWaterBottomView.h"
#import "PAWaterSuccessView.h"
#import "PAWaterFailView.h"
#import "PAWaterBluetoothManager.h"
#import "PAWaterDispenserService.h"
#import "PAWaterOrderService.h"
#import "PAWaterDispenserModel.h"
#import "SHPosPayManager.h"
#import "PAWaterPayService.h"
#import "PAWaterOrderModel.h"
@interface PAWaterDispenserController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) PAWaterBottomView *bottomView;
@property (nonatomic,strong) PAWaterSuccessView *buySuccessView;
@property (nonatomic,strong) PAWaterFailView *unfinishedOrderView;
@property (nonatomic,strong) PAWaterDispenserService *deviceService;
@property (nonatomic,strong) PAWaterOrderService *orderService;
@property (nonatomic,strong) PAWaterBluetoothManager *bluetoothManager;
@property (nonatomic,assign) float selectMoney; //选中的投币金额
@property (nonatomic,assign) NSInteger payTimes; //发送投币指令的次数
@property (nonatomic,assign) BOOL isPaid;//发起支付
@property (nonatomic,assign) BOOL isCoin; //是否投币成功
@property (nonatomic,copy) NSString *merOrderId; //订单流水号
@end

@implementation PAWaterDispenserController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.payTimes = 0;
    self.selectMoney = 0.0;
    [self getDeviceInfo];
    [self getUnfinishOrderInfo];
    [self setupNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.buySuccessView removeFromSuperview];
    [self.unfinishedOrderView removeFromSuperview];
}
#pragma mark - initUI
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.buySuccessView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.unfinishedOrderView];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:viewFlowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"PAWaterEquipmentCardCell" bundle:nil] forCellWithReuseIdentifier:@"PAWaterEquipmentCardCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PAWaterMoneyCardCell" bundle:nil] forCellWithReuseIdentifier:@"PAWaterMoneyCardCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"PAWaterCostCardcell" bundle:nil] forCellWithReuseIdentifier:@"PAWaterCostCardcell"];
    }
    return _collectionView;
}

-(PAWaterBottomView *)bottomView{
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"PAWaterBottomView"owner:self options:nil].firstObject;
        _bottomView.payButtonClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            //发起支付
            @strongify(self)
            if (self.selectMoney == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择投币金额"];
                return ;
            }
            self.isPaid = YES;
            PAWaterPayService * pay = [[PAWaterPayService alloc]init];
            CGFloat waterNum = self.selectMoney*[self.deviceService.deviceInfoModel.waterPrice floatValue];
            [pay sendPosPayWithPayType:1 deviceUuid:self.deviceService.deviceInfoModel.uuid amount:(self.selectMoney*100) waterNum:waterNum];
            pay.successBlock = ^(PABaseRequestService *service) {
                PAWaterPayService * payService = (PAWaterPayService *)service;
                NSString * posData = [[payService.payment.data.appPayRequest yy_modelToJSONString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.merOrderId = payService.payment.data.merOrderId;
                posData = [posData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [SHPosPayManager posPayWithChannel:SHAliPay posData:posData callback:^(BOOL isSuccess, NSString *resultCode, NSString *resultInfo) {
                    NSLog(@" code = %@ && info = %@",resultCode,resultInfo);
                    if(!isSuccess){
                        if ([resultCode isEqualToString:@"1003"]) {
                            [SVProgressHUD showErrorWithStatus:@"请安装支付宝，再尝试支付"];
                        }
                    }
                }];
            };
            pay.failedBlock = ^(PABaseRequestService *service, NSString *errorMsg) {
                if ([errorMsg isEqualToString:@"-1"]) {
                    [SVProgressHUD showErrorWithStatus:@"存在未取水订单"];
                    [self getUnfinishOrderInfo];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"支付失败，请重新支付"];
                }
            };
        };
    }
    return _bottomView;
}

-(PAWaterSuccessView *)buySuccessView{
    if (!_buySuccessView) {
        _buySuccessView = [[NSBundle mainBundle] loadNibNamed:@"PAWaterSuccessView"owner:self options:nil].firstObject;
        _buySuccessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _buySuccessView.hidden = YES;
        @weakify(self);
        _buySuccessView.backToHomeViewBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            @strongify(self);
            [self.buySuccessView removeFromSuperview];
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _buySuccessView;
}

-(PAWaterFailView *)unfinishedOrderView{
    if (!_unfinishedOrderView) {
        _unfinishedOrderView = [[NSBundle mainBundle] loadNibNamed:@"PAWaterFailView"owner:self options:nil].firstObject;
        _unfinishedOrderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _unfinishedOrderView.hidden = YES;
        @weakify(self)
        _unfinishedOrderView.callBackBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            @strongify(self)
            if(index>0){
                //投币
                [self payCoinToDevice:self.selectMoney andPayTimes:self.payTimes andOrderId:self.orderService.waterOrderData.orderId];
            }else{
                //关闭
                [self.unfinishedOrderView removeFromSuperview];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        };
    }
    return _unfinishedOrderView;
}

-(PAWaterDispenserService *)deviceService{
    if (!_deviceService) {
        _deviceService = [[PAWaterDispenserService alloc]init];
    }
    return _deviceService;
}

-(PAWaterOrderService *)orderService{
    if (!_orderService) {
        _orderService = [[PAWaterOrderService alloc]init];
    }
    return _orderService;
}

-(PAWaterBluetoothManager *)bluetoothManager{
    if (!_bluetoothManager) {
        _bluetoothManager = [PAWaterBluetoothManager sharedPAWaterBluetoothManager];
        @weakify(self)
        _bluetoothManager.blueToothBlock = ^(id  _Nullable data, PAWaterResponseType bluetoothCode) {
            [SVProgressHUD dismiss];
            @strongify(self)
            if (bluetoothCode == PAWaterBuySuccess) {
                [self showSuccessView];
                //修改订单状态
                self.isCoin = YES;
                [self.orderService updateOrderWithMerOrderId:self.merOrderId success:^(PABaseRequestService *service) {
                    NSLog(@"修改订单状态成功");
                } failure:^(PABaseRequestService *service, NSString *errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
            }else if (bluetoothCode == PAWaterPayResponseTimeOut){
                if (self.payTimes>3) {
                    [SVProgressHUD showErrorWithStatus:@"超出发送取水指令次数，请重新扫描二维码取水"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    return;
                }else{
                    [SVProgressHUD showErrorWithStatus:@"操作超时，请重新操作"];
                }
                self.payTimes+=1;
                [self getUnfinishOrderInfo];
            }else if(bluetoothCode == PAWaterRepeatCoinOrder){
                //重复投币指令 修改订单状态
                [SVProgressHUD showInfoWithStatus:@"取水失败，请勿重复取水"];
                [self.orderService updateOrderWithMerOrderId:self.merOrderId success:^(PABaseRequestService *service) {
                    NSLog(@"修改订单状态成功");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^(PABaseRequestService *service, NSString *errorMsg) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                }];
            }else if(bluetoothCode == PAWaterDisConnect){
                [self.unfinishedOrderView removeFromSuperview];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        };
    }
    return _bluetoothManager;
}

#pragma mark - Request
- (void)getDeviceInfo{
    @weakify(self)
    [self.deviceService loadWaterDeviceInfoWithQRCode:self.QrCode success:^(PABaseRequestService *service) {
        @strongify(self)
        [self hiddenNothingnessView];
        self.title = self.deviceService.deviceInfoModel.deviceName;
        [self.collectionView reloadData];
        [self.bottomView updateMoney:0];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        @strongify(self)
        [self showNothingnessViewWithType:NoContentTypeData Msg:@"获取设备信息失败，点击重新加载" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            [self getDeviceInfo];
        }];
    }];
}

- (void)getUnfinishOrderInfo{
    @weakify(self)
    [self.orderService queryUnfinishedOrderWithQrCode:self.QrCode success:^(PABaseRequestService *service) {
        @strongify(self)
        if (!self.orderService.waterOrderData.orderId) {
            return ;
        }
        self.unfinishedOrderView.orderDataModel = self.orderService.waterOrderData;
        self.merOrderId = self.orderService.waterOrderData.merOrderId;
        self.selectMoney = [self.orderService.waterOrderData.amount floatValue];
        [self showUnfinishedOrderView];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}

#pragma mark - Actions
- (void)setupNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verifyPosPayResult) name:PAWaterPayVerfifyNotificaiton object:nil];
}

/**
 校验支付结果
 */
- (void)verifyPosPayResult{
    // 调用订单
    if (!self.isPaid) {
        return;
    }
    @weakify(self)
    [self.orderService queryOrderPayWithMerOrderId:self.merOrderId success:^(PABaseRequestService *service) {
        @strongify(self)
        if (self.isCoin) {
            return ;
        }
        [self payCoinToDevice:self.selectMoney andPayTimes:self.payTimes andOrderId:self.orderService.waterOrderData.orderId];
    } failure:^(PABaseRequestService *service, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:@"订单查询失败"];
    }];
}
- (void)showUnfinishedOrderView{
    self.unfinishedOrderView.hidden = NO;
    self.buySuccessView.hidden = YES;
}

- (void)showSuccessView{
    self.unfinishedOrderView.hidden = YES;
    self.buySuccessView.hidden = NO;
}

//模拟发送投币指令
- (void)payCoinToDevice:(float )money andPayTimes:(NSInteger)payTimes andOrderId:(NSString *)orderId{
    if (self.selectMoney == 0) {
        return;
    }
    [self.bluetoothManager payWaterMoney:money andPayTimes:payTimes andOrderId:orderId];
    [SVProgressHUD showWithStatus:@"正在响应设备\n请勿关闭手机"];
}

-(void)backButtonClick{
    [self.buySuccessView removeFromSuperview];
    [self.unfinishedOrderView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return self.deviceService.deviceInfoModel.takeWaterAmount.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PAWaterEquipmentCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PAWaterEquipmentCardCell" forIndexPath:indexPath];
        cell.deviceData = self.deviceService.deviceInfoModel;
        return cell;
    }else if (indexPath.section == 1){
        PAWaterMoneyCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PAWaterMoneyCardCell" forIndexPath:indexPath];
        if ([self.deviceService.deviceInfoModel.takeWaterAmount[indexPath.row] integerValue] == self.selectMoney) {
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
        [cell initUIWithLabelContent:[self.deviceService.deviceInfoModel.takeWaterAmount[indexPath.row] integerValue]];
        return cell;
    }else{
        PAWaterCostCardcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PAWaterCostCardcell" forIndexPath:indexPath];
        CGFloat waterNum = self.selectMoney*[self.deviceService.deviceInfoModel.waterPrice floatValue];
        [cell setWaterNumLabelContent:waterNum];
        return cell;
    }
}

//定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH-40,253);
    }else if(indexPath.section == 1){
        return CGSizeMake((SCREEN_WIDTH-60)*0.33333, 53);
    }else{
        return CGSizeMake(SCREEN_WIDTH-40, 82);
    }
}

//section间的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(21, 0, 0, 0);
    }else if(section == 1){
        return UIEdgeInsetsMake(24, 20, 0, 20);
    }
    return UIEdgeInsetsMake(30, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self.collectionView reloadData];
        self.selectMoney = [self.deviceService.deviceInfoModel.takeWaterAmount[indexPath.row] integerValue];
        [self.bottomView updateMoney:self.selectMoney];
    }
}

@end
