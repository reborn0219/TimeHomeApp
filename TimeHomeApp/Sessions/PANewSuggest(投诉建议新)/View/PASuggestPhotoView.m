//
//  PASuggestPhotoView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/22.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestPhotoView.h"
#import "PANewNoticeURL.h"

@interface PASuggestPhotoView ()
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * maxCountLabel;
@end

@implementation PASuggestPhotoView

- (instancetype)init{
    if (self = [super init]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.maxCountLabel];
    [self addSubview:self.scrollView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(13);
        make.top.equalTo(self).with.offset(16);
    }];
    [self.maxCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self).with.offset(-14);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(18);
        make.height.equalTo(@84);
    }];
    
}

#pragma mark - Lazyload

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorHex(0x9B9B9B);
        _titleLabel.text = @"请提供相关问题的截图或照片";
    }
    return _titleLabel;
}
- (UILabel *)maxCountLabel{
    if (!_maxCountLabel) {
        _maxCountLabel = [[UILabel alloc]init];
        _maxCountLabel.font = [UIFont systemFontOfSize:14];
        _maxCountLabel.textColor = UIColorHex(0x9B9B9B);
        _maxCountLabel.text = @"0/4";
    }
    return _maxCountLabel;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}

#pragma mark - Actions

- (void)scrollViewAddPhotoResource{
    
}

- (void)scrollViewLayoutWithPhotoArray:(NSArray *)photoArray{
    [self.scrollView removeAllSubviews];
    [photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imageView = [[UIImageView alloc]initWithImage:obj];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(13+(13+79)*idx, 4, 79, 79);
        if (obj == photoArray.lastObject) {
            //末位取消删除按钮 回调选择相册/相机
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePhotoAction)];
            [imageView addGestureRecognizer:tap];
            
        } else{
            UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setImage:[UIImage imageNamed:@"tsjy_icon_deleteimg_n"] forState:UIControlStateNormal];
            [imageView addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(imageView);
            }];
            deleteBtn.tag = 3000+idx;
            [deleteBtn addTarget:self action:@selector(removePhotoFromSuperView:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
}

- (void)scrollViewShowPhotos:(NSArray *)photos{
    [self.scrollView removeAllSubviews];
    self.scrollView.contentSize = CGSizeMake((79+13)*photos.count+13, 79);
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",PA_NEW_NOTICE_URL,PANewNoticeImgPath,obj]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(13+(13+79)*idx, 4, 79, 79);
    }];

};



- (void)removePhotoFromSuperView:(UIButton *)sender{
    [sender.superview removeFromSuperview];
    NSInteger index = sender.tag - 3000;
    [self.photoArray removeObjectAtIndex:index];
    [self scrollViewLayoutWithPhotoArray:self.photoArray];
    self.maxCountLabel.text = [NSString stringWithFormat:@"%d/%d",self.photoArray.count-1,self.maxCount];
    self.deletePhotoBlock(@(index), 0);
}
- (void)choosePhotoAction{
    if (self.photoArray.count == 5) {
        return;
    }
    self.choosePhotoBlock(nil, 1);
}

- (void)showChoosePhotos{
    NSArray * photos = @[[UIImage imageNamed:@"tsjy_icon_img_n@2x"]];
    self.photoArray = photos.mutableCopy;
    self.maxCountLabel.text = [NSString stringWithFormat:@"%lu/%d",self.photoArray.count-1,self.maxCount];
    [self scrollViewLayoutWithPhotoArray:photos];

}


/**
 插入图片

 @param photo photo description
 */
- (void)addPhoto:(UIImage *)photo{
    [self.photoArray insertObject:photo atIndex:0];
    [self scrollViewLayoutWithPhotoArray:self.photoArray];
    self.maxCountLabel.text = [NSString stringWithFormat:@"%d/%d",self.photoArray.count-1,self.maxCount];
}

- (void)showPhotos:(NSArray *)photos{
    [self.photoArray removeAllObjects];
    [self scrollViewShowPhotos:photos];
}

- (void)dismissTag{
    self.titleLabel.hidden = YES;
    self.maxCountLabel.hidden = YES;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(12);
        make.left.right.equalTo(self);
        make.height.equalTo(@84);
    }];
}

@end
