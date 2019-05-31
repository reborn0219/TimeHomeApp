//
//  PANewHomeBannerViewModel.h
//  TimeHomeApp
//
//  Created by ning on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PANewHomeBannerView;

@interface PANewHomeBannerViewModel : NSObject

@property (nonatomic,strong) PANewHomeBannerView *bannerView;

- (void)update;

@end
