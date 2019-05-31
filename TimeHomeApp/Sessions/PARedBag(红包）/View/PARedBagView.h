//
//  PARedBagView.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PARedBagModel.h"

@interface PARedBagView : UIView

@property (strong,nonatomic) PARedBagModel *redBag;

+(void)showWithRedBag:(PARedBagModel*)redBag EventBlock:(ViewsEventBlock)tapBlock;


@end
