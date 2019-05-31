//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

/**
 *  上传图片界面中使用过
 *
 *  @return
 */
#import <UIKit/UIKit.h>

typedef void (^ CancelImageCallBack) ();

@interface TZTestCell : UICollectionViewCell
/**
 *  填满cell的图片
 */
@property (nonatomic, strong) UIImageView *imageView;
/**
 *  图片下方的label
 */
@property (nonatomic, strong) UILabel *headImageLabel;
/**
 *  图片右上角的删除按钮事件回调
 */
@property (nonatomic, strong) CancelImageCallBack cancelImageCallBack;

@end

