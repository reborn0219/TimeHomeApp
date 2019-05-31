//
//  LiftUpRodBluetoothPresenter.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/9/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LiftUpRodBluetoothPresenter.h"

#import "UserUnitKeyModel.h"

#import "ParkingModel.h"

#define BLUETOOTH_UUID @""

@interface LiftUpRodBluetoothPresenter()
{
    NSTimer * connectTimer;
    int count;
    CBCharacteristic *_characteristicWrite;
    CBCharacteristic *_characteristic;
    
    NSMutableString *mutableStr;
    NSString * Cmmd;
    NSArray * blueTooths;
    UserUnitKeyModel * uukm;
    NSNumber * rssi;
    int blueCount;
    
    int tagValue;
    int cycleNumber;
}

@end

@implementation LiftUpRodBluetoothPresenter

#pragma mark - BluetoothDelegate

-(instancetype)init
{
    if (self = [super init]) {
        
        mutableStr = [[NSMutableString alloc]init];
        count=0;
        tagValue = 0;
        cycleNumber = 0;
        if (!_centralManager){
            _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
            [_centralManager setDelegate:self];
        }
        
    }
    return self;
}

-(void)discconnection
{
    if (_discoveredPeripheral!=nil&&_centralManager!=nil) {
        [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
        NSLog(@"Disco=====discconnection");
    }
    
}

///开始搜索蓝牙设备
- (void)scanForPeripherals
{
    
    if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            
            [self discconnection];
            
            _discoveredPeripheral=nil;
            rssi=[[NSNumber alloc]initWithInt:-100];
            if (blueTooths==nil) {
                
                blueTooths=self.dataDict[@"Competence"];
                NSLog(@"%@",self.dataDict);
                
            }
            if (blueTooths==nil||blueTooths.count==0) {
                
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"您所在小区没有智能开闸设备",NOAuthorize);
                }
                return;
                
            }
            
            blueCount=0;
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@"正在搜索设备...",SearchBluetooth);
            }
            count=0;
            //开一个定时器监控连接超时的情况
            if (connectTimer) {
                [connectTimer invalidate];//停止时钟
                connectTimer=nil;
            }
            connectTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(connectTimeout) userInfo:nil repeats:YES];
        }
        else
        {
            alert(@"蓝牙设备未打开,请先打开蓝牙!",@"确认");
        }
        
        
    }
}

#pragma mark - ScanTimer
- (void)startScanPeripherals
{
    [self scanForPeripherals];
    
}

- (void)stopScan
{
    [_centralManager stopScan];
}

#pragma mark - CBCentralManager Delegate
/// 蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(self.blueToothBlock)
    {
        self.blueToothBlock(central,BluetoothState);
    }
    
}
///发现蓝牙设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"-----扫描到的蓝牙名称------%@---蓝牙详情%@----advertisementData:----%@",peripheral.name==nil?@"0":peripheral.name,peripheral,advertisementData);
    
    [self findStrongBlueth:peripheral RSSI:RSSI andAdverDataName:[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
}

//查找有限权的蓝牙
-(void) findStrongBlueth:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI andAdverDataName:(NSString *)advStr 
{
    
    NSInteger counts=blueTooths.count;
    
    NSLog(@"-----扫描到的蓝牙名称------%@---蓝牙详情%@",peripheral.name==nil?@"------":peripheral.name,peripheral);
    NSString * scanBlueName = peripheral.name;
    
    if (![XYString isBlankString:advStr]) {
        scanBlueName = advStr;
    }
    
    for (int i=0; i<counts; i++) {
        uukm=[blueTooths objectAtIndex:i];
        
        if ([XYString isBlankString:scanBlueName]) {
            break;
        }
        
        if([scanBlueName isEqualToString:uukm.bluename]){

            rssi=RSSI;
            _discoveredPeripheral=peripheral;
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@{@"name":_discoveredPeripheral.name,
                                      @"RSSI":rssi,@"uukm":uukm},DevInfo);
            }
            _discoveredPeripheral=peripheral;
            [_centralManager stopScan];
            [connectTimer invalidate];//停止时钟
            connectTimer=nil;
            count=0;
            [self connect:_discoveredPeripheral];
            [_discoveredPeripheral setDelegate:self];
            
            break;
        }
    }
}

///链接需要匹配的蓝牙设备
-(void)connect:(CBPeripheral *)peripheral{
    
    
    if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            //连接设备
            [_discoveredPeripheral setDelegate:self];
            [_centralManager connectPeripheral:_discoveredPeripheral
                                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
            
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@"正在连接...",ConntectBluetooth);
            }
            
        }
    }
    
}
-(void)connectTimeout
{
    count++;
    if(count>1)
    {
        [_centralManager stopScan];
        [connectTimer invalidate];//停止时钟
        connectTimer=nil;
        count=0;
        if(_discoveredPeripheral==nil)
        {
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@"未搜索到蓝牙设备~",NoFindDev);
            }
        }
        else
        {
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@{@"name":_discoveredPeripheral.name,
                                      @"RSSI":rssi,@"uukm":uukm},DevInfo);
            }
            [self connect:_discoveredPeripheral];
            
        }
        
        
    }
    NSLog(@"count==%d",count);
}



///连接蓝牙设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _discoveredPeripheral = peripheral;
    
    [connectTimer invalidate];//停止时钟
    _discoveredPeripheral.delegate = self;
    [peripheral discoverServices:nil];
    [_discoveredPeripheral readRSSI];
    
}
//写数据
-(BOOL)writeChar:(NSData *)data
{
    NSLog(@"====writeChar=%@",data);
    NSLog(@"====writeChar===lenth==%ld",(unsigned long)data.length);
    //alert(@"data", @"data");
    if (data==nil||data.length==0) {
        if(self.blueToothBlock)
        {
            self.blueToothBlock(@"打开失败!",OpenError);
        }
        
        return NO;
    }
    
    if([uukm.version isEqualToString:@"2.0"]){
        
        if (data.length > 20) {
            
            for (int i = 0; i < data.length / 20 + 1; i++) {
                NSData *dataCut;
                if (i == data.length / 20) {
                    
                    dataCut = [data subdataWithRange:NSMakeRange(0 + i*20, data.length - i * 20)];
                }else{
                    
                    dataCut = [data subdataWithRange:NSMakeRange(0 + i*20, 20)];
                }
                [_discoveredPeripheral writeValue:dataCut forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithResponse];
                sleep(0.1);
            }
        }else{
            
            [_discoveredPeripheral writeValue:data forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithResponse];
        }
    }else{
        
        [_discoveredPeripheral writeValue:data forCharacteristic:_characteristic type:CBCharacteristicWriteWithoutResponse];
    }
    
   
    return YES;
}
///连接蓝牙设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(self.blueToothBlock)
    {
        self.blueToothBlock(@"打开失败!",OpenError);
    }
    NSLog(@"%s",__FUNCTION__);
}
///断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - CBPeripheral Delegate
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"====didReadRSSI==%@  eerr=%@",RSSI,error.description);
    if (error!=nil) {
        
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        //发现服务
        if ([uukm.version isEqualToString:@"2.0"]) {
            
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FEE7"]])
            {
                NSLog(@"Service found with UUID: %@", service.UUID);//查找特征
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }else{
        
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
            {
                NSLog(@"Service found with UUID: %@", service.UUID);//查找特征
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"\nservice's UUID :%@\nCharacteristics :%@",service.UUID,service.characteristics);
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([uukm.version isEqualToString:@"2.0"]) {
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC7"]]) {
                
                _characteristicWrite = characteristic;//保存写的特征
                //[self writeChar:_wirteData];
                
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC8"]]) {
                
                NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
                _characteristic = characteristic;//保存接收的特征
                //订阅特征值
                [_discoveredPeripheral setNotifyValue:YES forCharacteristic:_characteristic];
                NSLog(@"发送指令:%f",[[NSDate date] timeIntervalSince1970]);
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"发送指令...",DevNew);
                }
            }
        }else{
        
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                
                NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
                _characteristic = characteristic;//保存写的特征
                
                ParkingModel *carMod = self.dataDict[@"car"];
                NSString *carCard = [NSString stringWithFormat:@"%@",carMod.card];
                NSString *carP = [carCard substringToIndex:1];
                NSString *carNo = [carCard substringFromIndex:1];
                NSDictionary *dict = [self provinceCorrespondence];
                carP = [NSString stringWithFormat:@"%@",dict[carP]];
                
                Cmmd = @"";
                Cmmd = [NSString stringWithFormat:@"%@%@",Cmmd,carP];
                Cmmd = [NSString stringWithFormat:@"%@%@",Cmmd,carNo];
                Cmmd = [NSString stringWithFormat:@"BHR%@000000BFR",Cmmd];
                //alert(Cmmd, @"确定");
                [_discoveredPeripheral setNotifyValue:YES forCharacteristic:_characteristic];
                NSLog(@"发送指令:%f",[[NSDate date] timeIntervalSince1970]);
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"发送指令...",SendCommd);
                }
                if ([self writeChar:[Cmmd dataUsingEncoding:NSUTF8StringEncoding]]) {
                    
                }
                
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error==nil)
    {
        if(characteristic.value.length>0)
        {
            NSString *msg = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"====didUpdateNotificationStateForCharacteristic==%@  eerr=%@ length=%ld",msg,error,characteristic.value.length);
            //alert(msg,@"回复1");
            if ([msg isEqualToString:@"OK"]) {
                
                NSLog(@"发送指令成功:%f",[[NSDate date] timeIntervalSince1970]);
                NSString * msg=@"";
                msg=@"如未抬杆请联系物业";
               
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(msg,OpenOk);
                }
            }
            else
            {
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"打开失败!",OpenError);
                }
            }
            [self discconnection];
        }
    }
    else
    {
        [self discconnection];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error==nil)
    {
        if(characteristic.value.length>0)
        {
            
            if ([uukm.version isEqualToString:@"2.0"]) {
                
                Byte *bytes=(Byte*)[characteristic.value bytes];
                
                NSString *msg=@"";
                for(int i=0;i<[characteristic.value length];i++)
                    
                {
                    
                    NSString *newHexStr=[NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
                    
                    if([newHexStr length]==1)
                        
                        msg=[NSString stringWithFormat:@"%@0%@",msg,newHexStr];
                    
                    else
                        
                        msg=[NSString stringWithFormat:@"%@%@",msg,newHexStr];
                    
                }
                NSString *showMsg;
                
                if (tagValue == 0) {
                    
                    NSString *result = [msg substringWithRange:NSMakeRange(4, 4)];
                    
                    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([result UTF8String],0,16)];
                    NSLog(@"心跳数字 10进制 %@",temp10);
                    //转成数字
                    cycleNumber = [temp10 intValue];
                    tagValue ++;
                    
                }
                
                //fe010047271100010a0012103c8082e32da31e558234d45876797ba61884800420012801622167685f3965623165383564613862365f3731383630393363303962373063363700
                
                [mutableStr appendString:msg];
                NSLog(@"%ld       %d",mutableStr.length,cycleNumber);
                if ([mutableStr isEqualToString:@"fe01001b271200030a00120ffecf0001000f0001000300004f4b00"]) {
                    
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"大门已打开";
                    [self discconnection];
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,OpenOk);
                    }
                    tagValue = 0;
                }else if ([mutableStr isEqualToString:@"fe010010271300020a001a0411223344"]){
                    
                    [self writeChar:_wirteData];
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"开始创建";
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,initOk);
                    }
                }else if (mutableStr.length == cycleNumber * 2) {
                    
                    [self writeChar:_wirteData];
                    showMsg = @"开始注册";
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,autoOk);
                    }
                    
                }else if ([mutableStr isEqualToString:@"fe010027271200030a00121bfecf0001001b00010003000048656c6c6f2c205765436861742100"]){
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"收到消息！！！！！";
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,backOk);
                    }
                }
            }else{
            
                NSString *msg = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                NSLog(@"====didUpdateValueForCharacteristic==%@  eerr=%@ length=%ld",msg,error,characteristic.value.length);
                //alert(msg,@"回复2");
                if ([msg isEqualToString:@"OK"]) {
                    
                    NSLog(@"发送指令成功:%f",[[NSDate date] timeIntervalSince1970]);
                    NSString * msg=@"";
                    msg=@"如未抬杆请联系物业";
                    
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(msg,OpenOk);
                    }
                }
                
                [self discconnection];
            }
        }
    }else {
        
        [self discconnection];
    }
}
///拼接data
-(NSData * )str16toData:(NSString *)str
{
    if(str.length != 24)return nil;
    ///取出后面16位转成NSData
    
    NSData * data_16 = [[str substringWithRange:NSMakeRange(8,16)] dataUsingEncoding:NSASCIIStringEncoding];
    
    Byte *buf = (Byte*)malloc(4);
    
    long a = strtoul([[str substringWithRange:NSMakeRange(0,2)] cStringUsingEncoding:NSASCIIStringEncoding],0, 16);
    long b = strtoul([[str substringWithRange:NSMakeRange(2,2)] cStringUsingEncoding:NSASCIIStringEncoding],0, 16);
    long c = strtoul([[str substringWithRange:NSMakeRange(4,2)] cStringUsingEncoding:NSASCIIStringEncoding],0, 16);
    long d = strtoul([[str substringWithRange:NSMakeRange(6,2)] cStringUsingEncoding:NSASCIIStringEncoding],0, 16);
    //如果等于0 则取0的ascii码
    buf[0] = (a==0?0x30:a);
    buf[1] = (b==0?0x30:b);
    buf[2] = (c==0?0x30:c);
    buf[3] = (d==0?0x30:d);
    
    NSMutableData *adata = [[NSMutableData alloc]initWithBytes:buf length:4];
    [adata appendData:data_16];
    return adata;
}


#pragma mark - 省份指令对应关系

-(NSDictionary *)provinceCorrespondence
{
    
    NSDictionary * liftDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"LiftUpRodBluetooth"];
    if (liftDict !=nil) return liftDict;
    
    NSString * s =  @"京,津,沪,渝,冀,鲁,晋,蒙,吉,粤,甘,川,辽,黑,苏,宁,豫,鄂,湘,琼,陕,藏,浙,皖,闽,赣,桂,云,贵,青,新,军,使,海";
    NSArray * keyArr = [s componentsSeparatedByString:@","];
    NSMutableArray * valueArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<keyArr.count; i++) {
        
        NSString * temp;
        if(i >= 0 && i <= 9){
            temp = @"0";
            
            temp = [NSString stringWithFormat:@"%@%d",temp,i];

        }else{
            
            temp = [NSString stringWithFormat:@"%d",i];
        }
        
        [valueArr addObject:temp];
        
    }
    
    NSDictionary * dict = [NSDictionary  dictionaryWithObjects:valueArr forKeys:keyArr];
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"LiftUpRodBluetooth"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return dict;

}

@end
