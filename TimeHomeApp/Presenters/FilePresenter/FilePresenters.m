//
//  FilePresenters.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/12/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "FilePresenters.h"

@implementation FilePresenters

#pragma mark - 单例支付类
/**
 单例支付类
 */
+ (instancetype)sharedPresenter {
    static FilePresenters *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// 显示缓存大小
- (float)filePath {
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/image", pathDocuments];
    float a = [self folderSizeAtPath:createPath];
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    float b = [self folderSizeAtPath:cachPath];
    
    return a + b;
    
}
//1:首先我们计算一下 单个文件的大小

- (long long) fileSizeAtPath:( NSString *) filePath {
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- (float) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}
// 清理缓存

- (void)clearFileWithBlock:(void(^)(NSInteger success))callBack {
    
    self.callBack = callBack;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/image", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则删除
    if ([fileManager fileExistsAtPath:createPath]) {
        
        [fileManager removeItemAtPath:createPath error:nil];
    }
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    //    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess {
    NSLog ( @" 清理成功 " );
    if (self.callBack) {
        self.callBack(1);
    }
//    [self showToastMsg:@"清理成功" Duration:2.0];
    
}

@end
