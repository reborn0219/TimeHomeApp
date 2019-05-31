//
//  PAWaterViewController.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterScanViewController.h"
#import "SHPosPayManager.h"
#import "PAWaterPayService.h"
#import "PAWaterScanViewController+Bluetooth.h"
@interface PAWaterScanViewController ()<PAQRScanDelegate>
@end

@implementation PAWaterScanViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self createBluetoothManager];
    [self.scanView startScanning];
}

-(void)dealloc{
    if (self.bluetoothManager) {
        [self.bluetoothManager clearPeripherals];
    }
}
#pragma mark - initUI
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanView];
    //提示信息label
    [self.scanView addSubview:self.showMsgLabel];
    //底部label
    [self.scanView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanView.mas_left).offset(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH-80);
    }];
    //链接蓝牙等待label
    [self.scanView addSubview:self.waitLabel];
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scanView.mas_centerX);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-29);
        make.width.mas_equalTo(150);
    }];
    //连接失败的view
    [self.view addSubview:self.failView];
    [self.failView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(PAWaterScanView *)scanView{
    if (!_scanView) {
        _scanView = [[PAWaterScanView alloc]initWithFrame:self.view.bounds];
        CGFloat x = SCREEN_WIDTH*0.5-SCREEN_WIDTH*0.75*0.5;
        _scanView.scanRect = CGRectMake(x, 60, SCREEN_WIDTH*0.75, SCREEN_WIDTH*0.75);
        _scanView.delegate = self;
        _scanView.showCornerLine = NO;
        _scanView.showBorderLine = YES;
        _scanView.scanLineColor = [UIColor colorWithHexString:@"#94DDFF"];
    }
    return _scanView;
}

-(UILabel *)showMsgLabel{
    if (!_showMsgLabel) {
        _showMsgLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanView.scanRect)+20, SCREEN_WIDTH, 20)];
        _showMsgLabel.backgroundColor = [UIColor clearColor];
        _showMsgLabel.numberOfLines=0;
        _showMsgLabel.font = DEFAULT_FONT(15);
        _showMsgLabel.textAlignment = NSTextAlignmentCenter;
        _showMsgLabel.textColor=[UIColor whiteColor];
        _showMsgLabel.text=@"将二维码/条码放入框内，即可自动扫描";
    }
    return _showMsgLabel;
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.text = @"温馨提示:请与设备保持3米范围内进行使用";
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = DEFAULT_FONT(15);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

-(UILabel *)waitLabel{
    if(!_waitLabel){
        _waitLabel = [[UILabel alloc]init];
        _waitLabel.text = @"正在连接设备\n请勿断开蓝牙...";
        _waitLabel.font = DEFAULT_FONT(16);
        _waitLabel.textAlignment = NSTextAlignmentCenter;
        _waitLabel.numberOfLines = 0;
        _waitLabel.hidden = YES;
        _waitLabel.textColor = [UIColor whiteColor];
        _waitLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _waitLabel;
}

-(PAWaterNotFoundView *)failView{
    if (!_failView) {
        _failView = [[NSBundle mainBundle] loadNibNamed:@"PAWaterNotFoundView"owner:self options:nil].firstObject;
        _failView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _failView.hidden = YES;
        @weakify(self)
        _failView.continueScanBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            @strongify(self)
            [self failToContinueScan];
        };
    }
    return _failView;
}

#pragma mark - scanViewDelegate
- (void)scanView:(PAWaterScanView *)scanView pickUpMessage:(NSString *)message{
    [scanView stopScanning];
    //扫描蓝牙
    self.qrCode = message;
    if (message.length<12) {
        [SVProgressHUD showErrorWithStatus:@"二维码无效，请扫描正确二维码"];
        [self failToContinueScan];
        return;
    }else{
        NSString *qrString = [message substringWithRange:NSMakeRange(0, 4)];
        if ([qrString isEqualToString:@"pasq"]||[qrString isEqualToString:@"PASQ"]){
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"二维码无效，请扫描正确二维码"];
            [self failToContinueScan];
            return;
        }
    }
    self.bluetoothManager.kBlePeripheralName = [message substringFromIndex:message.length-8];
    [self.bluetoothManager scanForPeripherals];
    self.waitLabel.hidden = NO;
}


@end
