//
//  SHOrderPaymentModel.h
//  PAPark
//
//  Created by Evagrius on 2018/6/6.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAWaterPosPayRequestModel : NSObject

@property (nonatomic, strong)NSString * qrCode;

@end

@interface PAWaterPayData:NSObject

@property (nonatomic, strong)PAWaterPosPayRequestModel *appPayRequest;
@property (nonatomic, strong)NSString * qrCode;
@property (nonatomic, strong)NSString * errCode;
@property (nonatomic, strong)NSString * merOrderId;
@end

@interface PAWaterPaymentModel : NSObject

@property (nonatomic, strong)PAWaterPayData * data;
@property (nonatomic, assign)NSInteger type;

@end
