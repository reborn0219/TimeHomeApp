//
//  PAWaterBottomView.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAWaterBottomView : UIView
@property (nonatomic,assign) NSInteger money;
@property (nonatomic,copy) ViewsEventBlock payButtonClickBlock;
- (void)updateMoney:(NSInteger )money;
@end
