//
//  EncryptUtils.h
//  QYgaosu
//
//  Created by us on 15/7/27.
//  Copyright © 2015年 uskj. All rights reserved.
//加密
/**
 加密工具类
 **/

#import <Foundation/Foundation.h>


@interface EncryptUtils : NSObject

+(NSString *)processingParameters:(NSDictionary *)dic;

//MD5加密方法
+(NSString *)md5HexDigest:(NSString *)input;
/**
 AES128 加密
 **/
+(NSString *) Aes128Encrypt:(NSString *) plainText forKey:(NSString *) key;
/**
 AES128 解密
 **/
+(NSString*) AES128Decrypt:(NSString *)encryptText forKey:(NSString *) key;

/**
 Url编码

 @param unencodedString 编码前string
 @return 返回编码后string
 */
+(NSString*)urlEncoding:(NSString*)unencodedString;

@end
