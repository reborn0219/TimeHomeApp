//
//  UIImage+ImageRotate.h
//  YouLifeApp
//
//  Created by us on 15/10/24.
//  Copyright © 2015年 us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageRotate)
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageWithColor:(UIColor *)color;

// MARK: - 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor*) color;
@end
