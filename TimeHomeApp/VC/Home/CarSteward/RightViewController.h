//
//  RightViewController.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "AddCarController.h"
//typedef void (^blockString)(NSString *str);

@interface RightViewController : BaseViewController

@property (nonatomic,strong)AddCarController *addCar;
//@property (nonatomic, copy) void (^blockString)(NSString *str);
//- (void)showText:(blockString)block;

@end
