//
//  ZSY_PostView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface ZSY_PostView : UIView<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)UIView *bgView;


@end
