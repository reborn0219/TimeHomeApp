//
//  SHADViewController.h
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THBaseViewController.h"
#import "PAWebViewController.h"
@interface PAADViewController : THBaseViewController

+(void)showAdCompletion:(void(^)(BOOL show,PAWebViewController * webview))completionBlock;

+ (PAADViewController *)currentAdViewController;


@end
