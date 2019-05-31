//
//  QrCodeScanningVC.h
//  YouLifeApp
//
//  Created by UIOS on 15/8/18.
//  Copyright © 2015年 us. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol BackValueDelegate <NSObject>

-(void)backValue:(NSString *)value;

@end

@interface QrCodeScanningVC : THBaseViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic,assign) int jmpCode;//1添加设备，2添加监控 3.扫gps定位IMEI号

@property(nonatomic,strong) NSMutableArray * sectionArr;//分组数据

@property(nonatomic,weak)id<BackValueDelegate> delegate;

@property(nonatomic,copy)NSString *isBikePush;//是否从二轮车过来 0否 1是

@end
