//
//  PAAlertViewManager.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAAlertViewManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(PAAlertViewManager)

- (void)showOneButtonAlertWithTitle:(NSString *)title
                            content:(NSString *)content
                      buttonContent:(NSString *)buttonContent
                      buttonBgColor:(NSString *)buttonBgColor
                        buttonBlock:(void(^)(void))buttonBlock;
@end
