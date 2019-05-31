//
//  ImageUitls.m
//  YouLifeApp
//
//  Created by us on 15/11/13.
//  Copyright © 2015年 us. All rights reserved.
//

#import "ImageUitls.h"

@implementation ImageUitls

+ (NSString *)typeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}


+(long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//压缩质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//+(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
//    newSize.height=image.size.height*(newSize.width/image.size.width);
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return  newImage;
//}

+(NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)iamgeName
{
    float kCompressionQuality = 0.1;
    NSData *imageData = UIImageJPEGRepresentation(tempImage, kCompressionQuality);
    //    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullpathToFile = [documentsDirectory stringByAppendingPathComponent:iamgeName];
    NSArray *nameAry = [fullpathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===new fullPathToFile===%@",fullpathToFile);
    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullpathToFile atomically:NO];
    return fullpathToFile;
}

+(void)saveAndShowImage:(UIImageView*)imgV withName:(NSString *)imgName {
    
    //首先,需要获取沙盒路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/image", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![fileManager fileExistsAtPath:createPath]) {
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    } else {
        //NSLog(@"FileDir is exists.");
    }
    // 拼接图片名为"imgName"的路径
    
    NSArray *arr = [imgName componentsSeparatedByString:@"/"];
    NSString *pathUrl = [NSString stringWithFormat:@"/%@",arr[arr.count - 1]];
    NSString *imageFilePath = [createPath stringByAppendingPathComponent:pathUrl];
    UIImage * img = [UIImage imageWithContentsOfFile:imageFilePath];
    
    if (img) {

        imgV.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [imgV performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
            imgV.alpha = 1;
            
        }];
        
    }else {
        
        [imgV sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:PLACEHOLDER_IMAGE completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
  
            });
        }];
    }
    
}
//-------等比缩放-----

+(UIImage *)compressImageWith:(UIImage *)image width:(float)width height:(float)height
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

///压缩图片到固定大小
//+ (UIImage *)resetSizeOfImageData:(UIImage *)image maxSize:(NSInteger)maxSize
//{
//    UIImage *newImage=image;
//    //调整大小
//    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
//    NSUInteger sizeOrigin = [imageData length];
//    NSLog(@"sizeOriginKB==%ld",sizeOrigin);
//    NSInteger size=maxSize*1024;
////    newImage= [UIImage imageWithData:imageData];
//    UIImage * newimg=[newImage copy];
//    while(sizeOrigin >size) {
//        newImage=[self reduceImage:newimg percent:0.00001];
//        NSData * finalimageData = UIImageJPEGRepresentation(newImage,1.0);
//        sizeOrigin = [finalimageData length];
//        NSLog(@"sizeOriginKB==%ld",sizeOrigin/1024);
//    }
////    newImage= [UIImage imageWithData:imageData];
//    return newImage;
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    NSData *imageData = UIImageJPEGRepresentation(image, compression);
//    while ([imageData length] > maxSize*1024 && compression > maxCompression) {
//        compression -= 0.1;
//        imageData = UIImageJPEGRepresentation(image, compression);
//    }
//    
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
//    return compressedImage;
//
//}
//- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
//    CGFloat compression = 0.9f;
//    CGFloat maxCompression = 0.1f;
//    NSData *imageData = UIImageJPEGRepresentation(image, compression);
//    while ([imageData length] > maxFileSize && compression > maxCompression) {
//        compression -= 0.1;
//        imageData = UIImageJPEGRepresentation(image, compression);
//    }
//    
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
//    return compressedImage;
//}

/**
 设置圆角
 如果要加圆角边框，请勿使用此方法
 */
+ (void)setViewCorners:(UIView *)view {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:view.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图像样式
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
