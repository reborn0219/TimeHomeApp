//
//  EncryptUtils.m
//  QYgaosu
//
//  Created by us on 15/7/27.
//  Copyright © 2015年 uskj. All rights reserved.
//

#import "EncryptUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define gkey			@"ac67529a2ea18cf8c"
#define gIv             @"1234567890123456"

@implementation EncryptUtils

///网络请求排序并加密参数
+(NSString *)processingParameters:(NSDictionary *)dic
{
    
    NSString * sign = @"";
    if (dic) {
        
        //取出所有参数KEY 按照字母先后顺序排序
        NSMutableString * parameStr = [[NSMutableString alloc]initWithCapacity:0];
        NSArray * arr = [dic allKeys];
        NSArray * newArr = [arr sortedArrayUsingSelector:@selector(compare:)];
        
        [parameStr appendString:@"APP_H5_2017"];
        for (NSString * keyStr in newArr) {
            
            NSString * valueStr = [dic objectForKey:keyStr];
            [parameStr appendString:keyStr];
            [parameStr appendString:valueStr];
        }
        [parameStr appendString:@"APP_H5_2017"];
        NSLog(@"---拼接后的字符串%@---",parameStr);
        
        sign = [EncryptUtils md5HexDigest:parameStr];
    }
    return sign;
    
}
//MD5加密方法
+(NSString *)md5HexDigest:(NSString *)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
//    NSLog(@"ret==:%@",ret);
    return ret;
}
/**
 AES128 加密
 **/
+(NSString *) Aes128Encrypt:(NSString *) plainText forKey:(NSString *) key
{
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
//    char ivPtr[kCCBlockSizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString * encrText=[resultData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        encrText=[encrText stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        return encrText;
    }
    free(buffer);
    return nil;
}
/**
 AES128 解密
 **/
+(NSString*) AES128Decrypt:(NSString *)encryptText forKey:(NSString *) key
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:encryptText options:0];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString * desStr=[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return desStr;
    }
    free(buffer);
    return nil;
}


+(NSString*)urlEncoding:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}

@end
