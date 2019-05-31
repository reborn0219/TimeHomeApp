//
//  PAWaterFailView.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAWaterOrderModel;
@interface PAWaterFailView : UIView

@property (nonatomic,strong) PAWaterOrderModel *orderDataModel;

@property (nonatomic,copy) ViewsEventBlock callBackBlock;

@end
