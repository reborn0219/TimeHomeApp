//
//  ImageUitls.h
//  YouLifeApp
//
//  Created by us on 15/11/13.
//  Copyright © 2015年 us. All rights reserved.
//
/**
 图片处理工具类
 **/
#import <Foundation/Foundation.h>

@interface ImageUitls : NSObject

///判断图片格式
+ (NSString *)typeForImageData:(NSData *)data;
///获取文件大小
+(long long) fileSizeAtPath:(NSString*) filePath;
///压缩质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
///保存
+(NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)iamgeName;
///读取图片
+(void)saveAndShowImage:(UIImageView*)imgV withName:(NSString *)imgName;
///比例缩放
//+(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize;
///等比例缩放
+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height;
///等比例缩放（没有效果）
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
///等比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
///压缩图片质量
//+ (UIImage *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;

/**
 设置圆角
 */
+ (void)setViewCorners:(UIView *)view;

/**
 旋转图片
 @param image 图片
 @param orientation 旋转方向
 */
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
