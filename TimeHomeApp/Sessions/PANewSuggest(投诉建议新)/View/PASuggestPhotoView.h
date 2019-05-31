//
//  PASuggestPhotoView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/22.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PASuggestPhotoView : UIView
@property (nonatomic, assign)NSInteger maxCount; // 最大照片数
@property (nonatomic, strong)NSMutableArray * photoArray;
@property (nonatomic, copy)UpDateViewsBlock choosePhotoBlock;
@property (nonatomic, copy)UpDateViewsBlock deletePhotoBlock;

- (void)dismissTag;
- (void)addPhoto:(UIImage *)photo;
- (void)showChoosePhotos;
- (void)showPhotos:(NSArray *)photos;
@end
