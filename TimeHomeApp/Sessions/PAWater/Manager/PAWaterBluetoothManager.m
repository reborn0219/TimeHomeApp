//
//  PAWaterBluetoothManager.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/6.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PAWaterBluetoothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

/// 中央管理者 -->管理设备的扫描 --连接
@property (nonatomic, strong) CBCentralManager *centralManager;
// 存储的设备
@property (nonatomic, strong) NSMutableArray *peripherals;
// 扫描到的设备
@property (nonatomic, strong) CBPeripheral *cbPeripheral;
// 特征
@property (nonatomic,strong) CBCharacteristic *cbCharacteristi;
// 蓝牙状态
@property (nonatomic, assign) CBManagerState peripheralState;
// 计时器
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger timeOutCount;
//搜索设备的计时器
@property (nonatomic,strong) NSTimer *scanTimer;
@property (nonatomic,assign) NSInteger scanCount;
@end

// 通知服务
static NSString * const kNotifyServerUUID = @"FFE0";
// 写服务
static NSString * const kWriteServerUUID = @"FFE0";
// 通知特征值
static NSString * const kNotifyCharacteristicUUID = @"FFE1";
// 写特征值
static NSString * const kWriteCharacteristicUUID = @"FFE1";

@implementation PAWaterBluetoothManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAWaterBluetoothManager)

#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self centralManager];
    }
    return self;
}

-(void)dealloc{
    [self stopTimer];
    [self stopScanTimer];
}

- (CBCentralManager *)centralManager{
    if (!_centralManager)
    {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

- (NSMutableArray *)peripherals{
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

// 扫描设备
- (void)scanForPeripherals{
    [self.centralManager stopScan];
    NSLog(@"扫描设备");
    if (self.peripheralState ==  CBManagerStatePoweredOn){
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [self startScanTimer];
    }else{
        self.blueToothBlock(@"", PAWaterBluetoothException);
    }
}

// 连接设备
- (void)connectToPeripheral{
    if (self.cbPeripheral != nil){
        NSLog(@"连接设备");
        [self.centralManager connectPeripheral:self.cbPeripheral options:nil];
    }else{
        NSLog(@"无设备可连接");
        [SVProgressHUD showErrorWithStatus:@"无设备可连接"];
    }
}

// 清空设备
- (void)clearPeripherals{
    NSLog(@"清空设备");
    [self.peripherals removeAllObjects];
    
    if (self.cbPeripheral != nil){
        // 取消连接
        NSLog(@"取消连接");
        [self.centralManager cancelPeripheralConnection:self.cbPeripheral];
    }
    [self.centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate
// 状态更新时调用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStateUnknown:{
            NSLog(@"为知状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateResetting:
        {
            NSLog(@"重置状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnsupported:
        {
            NSLog(@"不支持的状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStateUnauthorized:
        {
            NSLog(@"未授权的状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"关闭状态");
            self.peripheralState = central.state;
        }
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"开启状态－可用状态");
            self.peripheralState = central.state;
            NSLog(@"%ld",(long)self.peripheralState);
        }
            break;
        default:
            break;
    }
}
/**
 扫描到设备
 
 @param central 中心管理者
 @param peripheral 扫描到的设备
 @param advertisementData 广告信息
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@",[NSString stringWithFormat:@"发现设备,设备名:%@",peripheral.name]);
    if (![self.peripherals containsObject:peripheral]){
        [self.peripherals addObject:peripheral];
    }
    NSLog(@"%@",peripheral);
    if ([peripheral.name isEqualToString:self.kBlePeripheralName]){
        [self stopScanTimer];
        NSLog(@"%@",[NSString stringWithFormat:@"设备名:%@",peripheral.name]);
        self.cbPeripheral = peripheral;
        NSLog(@"开始连接");
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连接失败
 
 @param central 中心管理者
 @param peripheral 连接失败的设备
 @param error 错误信息
 */

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接失败");
    self.blueToothBlock(@"", PAWaterLinkFail);
}

/**
 连接断开
 
 @param central 中心管理者
 @param peripheral 连接断开的设备
 @param error 错误信息
 */

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"断开连接");
    self.kBlePeripheralName = @"";
    if ([peripheral.name isEqualToString:self.kBlePeripheralName]){
        //[self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连接成功
 
 @param central 中心管理者
 @param peripheral 连接成功的设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接设备:%@成功",peripheral.name);
    [self.centralManager stopScan];
    NSLog(@"%@",[NSString stringWithFormat:@"连接设备:%@成功",peripheral.name]);
    // 设置设备的代理
    peripheral.delegate = self;
    // services:传入nil  代表扫描所有服务
    [peripheral discoverServices:nil];
}

#pragma mark - CBPeripheralDelegate
/**
 扫描到服务
 
 @param peripheral 服务对应的设备
 @param error 扫描错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // 遍历所有的服务
    for (CBService *service in peripheral.services)
    {
        NSLog(@"服务:%@",service.UUID.UUIDString);
        // 获取对应的服务
        if ([service.UUID.UUIDString isEqualToString:kWriteServerUUID] || [service.UUID.UUIDString isEqualToString:kNotifyServerUUID])
        {
            // 根据服务去扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/**
 扫描到对应的特征
 
 @param peripheral 设备
 @param service 特征对应的服务
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // 遍历所有的特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"特征值:%@",characteristic.UUID.UUIDString);
        if ([characteristic.UUID.UUIDString isEqualToString:kWriteCharacteristicUUID]){
            self.cbCharacteristi = characteristic;
            [self writeDataWithString:PAWaterConnectToDevice];
        }
        if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

/**
 根据特征读到数据
 
 @param peripheral 读取到数据对应的设备
 @param characteristic 特征
 @param error 错误信息
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if ([characteristic.UUID.UUIDString isEqualToString:kNotifyCharacteristicUUID])
    {
        NSData *data = characteristic.value;
        NSLog(@"读取到数据对应的设备--%@",data);
        NSString *msg = [self convertDataToHexStr:data];
        NSLog(@"aString读取到数据对应的设备--%@",msg);
        if ([msg isEqualToString:PAWaterConnectionSuccess]) {
            //连接成功 可进入下步消费买水
            self.blueToothBlock(@"", PAWaterLinkSuccess);
        }else if([msg isEqualToString:PAWaterConnectionException]){
            //连接成功 出水未完成无法进行下步消费
            self.blueToothBlock(@"", PAWaterLinkException);
        }else if([msg isEqualToString:PAWaterBeforeCoin]){
            //接收投币指令成功
            [self startTimerWithTimeOutCount:6];
        }else if([msg isEqualToString:PAWaterUnfinished]){
            //投币指令成功 连接成功 出水未完成无法进行下步消费
            [SVProgressHUD showErrorWithStatus:@"出水未完成"];
        }else if ([msg isEqualToString:PAWaterAfterCoin]){
            //投币成功 APP接收到消费成功指令后回应指令
            [self stopTimer];
            [self writeDataWithString:PAWaterCoinSuccess];
            self.blueToothBlock(@"", PAWaterBuySuccess);
            //清空设备
            [self clearPeripherals];
        }else if([msg isEqualToString:PAWaterFlowing]){
            //出水中
            [SVProgressHUD showErrorWithStatus:@"设备正在运行，请稍后重试"];
        }else if ([msg isEqualToString:PAWaterIllegalAmount]){
            //非法金额
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }else if ([msg isEqualToString:PAWaterRepeatCoin]){
            [self stopTimer];
            [SVProgressHUD showErrorWithStatus:@"重复订单指令"];
            self.blueToothBlock(nil, PAWaterRepeatCoinOrder);
        }else if ([msg isEqualToString:PAWaterIllegalInstructions]){
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }else if ([msg isEqualToString:PAWaterIllegalConnect]){
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }else if ([msg isEqualToString:PAWaterHeaderOrFooterError]){
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }else if ([msg isEqualToString:PAWaterOtherError]){
            [SVProgressHUD showErrorWithStatus:@"操作异常"];
        }
    }
}

#pragma mark - Actions
- (void)payWaterMoney:(float )money andPayTimes:(NSInteger)payTimes andOrderId:(NSString *)orderId{
    [self startTimerWithTimeOutCount:3];
    NSString *orderString = [self getHexByDecimal:[orderId integerValue]];
    NSString *orderHexString = [self addZero:orderString withLength:20];
    NSString *moneyString = [self getHexByDecimal:(money/0.5)];
    NSString *moneyHexStr = [self addZero:moneyString withLength:2];
    NSString *dataString = [NSString stringWithFormat:@"EFEF000B7000%@%@FEFE",moneyHexStr,orderHexString];
    NSLog(@"投币指令----%@",dataString);
    [self writeDataWithString:dataString];
}

- (void)writeDataWithString:(NSString *)dataString{
    if(self.peripheralState != CBManagerStatePoweredOn){
        self.kBlePeripheralName = @"";
        [self clearPeripherals];
        PAAlertViewManager *alert = [PAAlertViewManager sharedPAAlertViewManager];
        [alert showOneButtonAlertWithTitle:@"提示" content:@"蓝牙已断开，请重新扫描二维码连接设备" buttonContent:@"确定" buttonBgColor:@"#007AFF" buttonBlock:^{
            self.blueToothBlock(nil, PAWaterDisConnect);
        }];
        return;
    }
    if (self.kBlePeripheralName.length>0) {
        NSData *data = [self hexToBytes:dataString];
        NSLog(@"hexToBytes---%@",data);
        [self.cbPeripheral writeValue:data forCharacteristic:self.cbCharacteristi type:CBCharacteristicWriteWithoutResponse];
    }else{
        PAAlertViewManager *alert = [PAAlertViewManager sharedPAAlertViewManager];
        [alert showOneButtonAlertWithTitle:@"提示" content:@"蓝牙已断开，请重新扫描二维码连接设备" buttonContent:@"确定" buttonBgColor:@"#007AFF" buttonBlock:^{
            self.blueToothBlock(nil, PAWaterDisConnect);
        }];
    }
}

#pragma mark - 投币计时器操作
- (void)startTimerWithTimeOutCount:(NSInteger)timeOutCount{  //开始
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.count = 0;
    self.timeOutCount = timeOutCount;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatCheckTime:) userInfo:nil repeats:YES];
}

- (void)stopTimer {  //停止
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.count = 0;
    self.timeOutCount = 0;
}

- (void)repeatCheckTime:(NSTimer *)tempTimer {
    NSLog(@"检查定时");
    self.count++;
    if (self.count>self.timeOutCount) {
        NSLog(@"超时---%ld,---%ld",(long)self.count,(long)self.timeOutCount);
        [self stopTimer];
        self.blueToothBlock(@"", PAWaterPayResponseTimeOut);
    }
}

#pragma mark - 搜索设备计时器
- (void)startScanTimer{  //开始
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    self.scanCount = 0;
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatScanCheckTime:) userInfo:nil repeats:YES];
}

- (void)stopScanTimer {  //停止
    if (self.scanTimer) {
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
    self.scanCount = 0;
}

- (void)repeatScanCheckTime:(NSTimer *)tempTimer {
    self.scanCount++;
    if (self.scanCount>10) {
        [self stopScanTimer];
        self.blueToothBlock(@"", PAWaterFindDeviceTimeOut);
    }
}
#pragma mark - Helper
//hex -> NSData
-(NSData*) hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

// NSData->hex string
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

// 十进制 -> 十六进制
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    return hex;
}

//字符串补零操作
- (NSString *)addZero:(NSString *)str withLength:(int)length{
    NSString *string = nil;
    if (str.length==length) {
        return str;
    }
    if (str.length<length) {
        NSUInteger inter = length-str.length;
        for (int i=0;i< inter; i++) {
            string = [NSString stringWithFormat:@"0%@",str];
            str = string;
        }
    }
    return string;
}
@end
