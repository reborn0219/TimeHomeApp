//
//  QrCodeScanningVC.m
//  YouLifeApp
//
//  Created by UIOS on 15/8/18.
//  Copyright © 2015年 us. All rights reserved.
//

#import "QrCodeScanningVC.h"
#import "QRScanView.h"
@interface QrCodeScanningVC ()
{
    UIImageView * imageView;
    float imgY;
    CGFloat imgWidth;
    BOOL isAmplification;//是否放大
}
@end

@implementation QrCodeScanningVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAmplification = NO;
    self.title=@"扫设备识别码";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
//    self.view.backgroundColor = [UIColor clearColor];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=0;
    labIntroudction.font = DEFAULT_FONT(15);
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
//    [self.view addSubview:labIntroudction];

    imgY=CGRectGetMaxY(labIntroudction.frame)+20;
    
    imgWidth = 35;

    ///扫描框
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imgWidth, imgY, SCREEN_WIDTH-imgWidth*2, SCREEN_WIDTH-imgWidth*2)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    ///半透明view
    QRScanView *bgView = [[QRScanView alloc] initWithScanRect:CGRectMake(imgWidth, imgY, SCREEN_WIDTH-imgWidth*2, SCREEN_WIDTH-imgWidth*2)];
    [self.view addSubview:bgView];
    
    ///提示信息label
    UILabel * showMsgLabel= [[UILabel alloc] initWithFrame:CGRectMake(imgWidth - 10, CGRectGetMaxY(imageView.frame)+20, SCREEN_WIDTH-(imgWidth - 10)*2, 20)];
    showMsgLabel.backgroundColor = [UIColor clearColor];
    showMsgLabel.numberOfLines=0;
    showMsgLabel.font = DEFAULT_FONT(15);
    showMsgLabel.textAlignment = NSTextAlignmentCenter;
    showMsgLabel.textColor=[UIColor whiteColor];
    showMsgLabel.text=@"将二维码/条码放入框内，即可自动扫描";
    [self.view addSubview:showMsgLabel];
    
    
    ///动画横线相关
    upOrdown = NO;
    num =0;
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth, imgY+10, SCREEN_WIDTH-imgWidth*2, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setupCamera];

    });
}

-(void)animation1 {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (upOrdown == NO) {
                num ++;
                _line.frame = CGRectMake(imgWidth,imgY+10+2*num, SCREEN_WIDTH-imgWidth*2, 2);
                if (2*num >= SCREEN_WIDTH-imgWidth*2-20) {
                    upOrdown = YES;
                }
            }
            else {
                num --;
                _line.frame = CGRectMake(imgWidth,imgY+10+2*num, SCREEN_WIDTH-imgWidth*2, 2);
                if (num == 0) {
                    upOrdown = NO;
                }
            }
            
        });
        
    });
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_session stopRunning];
    _session = nil;
    [timer invalidate];
    timer = nil;
}

- (void)setupCamera {
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    if ([self.device lockForConfiguration:NULL]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [self.device unlockForConfiguration];
    }
    /****************Device****************/
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    CGRect cropRect = CGRectMake(imgWidth+10,imgY+10,SCREEN_WIDTH-(imgWidth+10)*2,SCREEN_WIDTH-(imgWidth+10)*2);
    CGSize size = self.view.bounds.size;
    
    CGRect intertRect = CGRectMake(cropRect.origin.y/size.height,
                                   cropRect.origin.x/size.width,
                                   cropRect.size.height/size.height,
                                   cropRect.size.width/size.width);

    _output.rectOfInterest = intertRect;

    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                     object:nil
                                                      queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification * _Nonnull note) {
                                                     if (weakSelf){
                                                         //调整扫描区域
                                                         AVCaptureMetadataOutput *outPut = weakSelf.session.outputs.firstObject;
                                                         outPut.rectOfInterest = intertRect;
                                                         
                                                     }
                                                     
                                                 }];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _preview.frame = CGRectMake(imgWidth+10,imgY+10,SCREEN_WIDTH-(imgWidth+10)*2,SCREEN_WIDTH-(imgWidth+10)*2);
    _preview.frame = self.view.frame;
    

    CGFloat canFloat = 1.5;
    AVCaptureConnection *connect = [_output connectionWithMediaType:AVMediaTypeVideo];
//    [_preview setAffineTransform:CGAffineTransformMakeScale(canFloat, canFloat)];
    connect.videoScaleAndCropFactor= canFloat;
    [CATransaction commit];
    self.view.clipsToBounds=YES;
    self.view.layer.masksToBounds=YES;

    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    ///如果从自行车放到push 则放大焦距
    if ([_isBikePush isEqualToString:@"1"]) {
        [self amplification];
    }
    
    [_session startRunning];
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSLog(@"扫描到了");
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
//        NSArray *arry = metadataObject.corners;
//        for (id temp in arry) {
//            NSLog(@"temp====%@",temp);
//        }
        
    }
    NSLog(@"二维码＝＝＝＝%@",stringValue);
    
    [_session stopRunning];
    _session = nil;
    [timer invalidate];
    timer = nil;
    
    if(self.delegate) {
        [self.delegate backValue:stringValue];
        [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)amplification {

    //放大焦距
    NSError *error = nil;
    
    [_device lockForConfiguration:&error];
    
    if (_device.activeFormat.videoMaxZoomFactor > 2) {
        
        _device.videoZoomFactor = 2;
        
    }else{
        
        _device.videoZoomFactor = _device.activeFormat.videoMaxZoomFactor;
        
    }

    [_device unlockForConfiguration];
}

@end

