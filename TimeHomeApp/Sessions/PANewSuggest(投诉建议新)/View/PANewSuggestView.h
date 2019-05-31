//
//  PANewSuggestView.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/22.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PASuggestDelegate <NSObject>

- (void)choosePhotoAction;
- (void)deletePhotoWithIndex:(NSInteger)index;
- (void)submitSuggestWithMobile:(NSString *)mobile suggestInfo:(NSString *)suggestInfo photoArray:(NSArray<UIImage *>*)photoArray;

@end

@interface PANewSuggestView : UIView

@property (nonatomic, assign)id<PASuggestDelegate>delegate;

- (void)addPhotoImage:(UIImage *)image;

- (void)resetSuggestView;

@end
