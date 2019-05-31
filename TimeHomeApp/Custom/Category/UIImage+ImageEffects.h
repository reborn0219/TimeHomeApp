//
//  UIImage+ImageEffects.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 改变图片颜色
 */
- (UIImage *)imageWithColor:(UIColor *)color;

@end
