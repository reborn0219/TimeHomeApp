//
//  PANewSuggestService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/28.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewSuggestService.h"
#import "PASubmitSuggstRequest.h"
#import "PAUploadImageRequest.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFURLResponseSerialization.h"
#import "PASuggestListRequest.h"
#import "PASuggestDetailRequest.h"

@implementation PANewSuggestService

/**
 新增投诉建议
 
 @param contactMobile 联系方式
 @param complaintDetails 投诉内容
 @param attachmentIds 附件列表
 @param success 成功
 @param failed 失败
 */
- (void)submitSuggestWithContactMobile:(NSString *)contactMobile
                      complaintDetails:(NSString *)complaintDetails
                         attachmentIds:(NSArray *)attachmentIds
                               success:(ServiceSuccessBlock)success
                                failed:(ServiceFailedBlock)failed{
    AppDelegate * delegate = GetAppDelegates;
    PASubmitSuggstRequest * req = [[PASubmitSuggstRequest alloc]initWithCommunityId:delegate.userData.communityid contactMobile:contactMobile complaintDetails:complaintDetails attachmentIds:attachmentIds];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel.data);
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
        failed(self,error.localizedDescription);
    }];
}

/**
 上传图片
 
 @param images 图片数组
 @param success success description
 @param failed failed description
 */
- (void)uploadImages:(NSArray <UIImage *>*)images
             success:(ServiceSuccessBlock)successed
              failed:(ServiceFailedBlock)failed{
    
    PAUploadImageRequest * req = [[PAUploadImageRequest alloc]initWithImage:images[0]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString * time =[XYString NSDateToString:[NSDate date] withFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * suburl = [NSString stringWithFormat:@"%@/upload?appId=APP_H5_WG&timeStamp=%@",PA_NEW_NOTICE_URL,time];
    NSString *URLTmp= [suburl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // 在parameters里存放照片以外的对象
    [manager POST:URLTmp parameters:req.requestArgument constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            NSString *fileName = [NSString  stringWithFormat:@"IMG%d.jpeg", i];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        //获取data内容
        [self.submitedImgArray removeAllObjects];
        NSString * imgName = responseObject[@"data"];
        [self.submitedImgArray addObject:imgName];
        successed(self);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"xxx上传失败xxx %@", error);
    }];
}

- (NSMutableArray *)submitedImgArray{
    if (!_submitedImgArray) {
        _submitedImgArray = @[].mutableCopy;
    }
    return _submitedImgArray;
}
/**
 获取投诉列表
 
 @param page 页码
 @param successed successed description
 @param failed failed description
 */
- (void)loadSuggestListWithPage:(NSInteger )page
                        success:(ServiceSuccessBlock)successed
                         failed:(ServiceFailedBlock)failed{
    PASuggestListRequest * req = [[PASuggestListRequest alloc]initWithPage:page];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary *dataDict = responseModel.data;
        if (page == 1) {
         self.suggestArray = [NSArray yy_modelArrayWithClass:[PASuggestListModel class] json:dataDict[@"beanList"]].mutableCopy;
        } else{
            [self.suggestArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[PASuggestListModel class] json:dataDict[@"beanList"]]];
        }
        
        successed(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,error.localizedDescription);
    }];
}

/**
 加载投诉建议详情
 
 @param orderId orderId description
 @param successed successed description
 @param failed failed description
 */
- (void)loadSuggestDetailWithOrderId:(NSString *)orderId
                             success:(ServiceSuccessBlock)successed
                              failed:(ServiceFailedBlock)failed{
    PASuggestDetailRequest * req = [[PASuggestDetailRequest alloc]initWithOrderId:orderId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel.data);
        self.suggestDetailModel = [PASuggestDetailModel yy_modelWithJSON:responseModel.data];
        successed(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,error.localizedDescription);
    }];
}


@end
