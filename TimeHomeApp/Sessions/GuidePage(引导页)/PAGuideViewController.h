//
//  SHGuideViewController.h
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAGuideViewController : UIViewController

/**
 展示引导页

 @param imageArray 需要展示的引导页图片资源数组
 @param completionBlock 点击'立即体验'按钮后的回调
 */
+(void)showGuidePageWithImageArray:(NSArray*)imageArray Completion:(void(^)(BOOL isNewVersion))completionBlock;

@end
