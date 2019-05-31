//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"

#import <Photos/Photos.h>
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@interface SDPhotoBrowser ()

@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation SDPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
//    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIButton *_headerButton;
    UIActivityIndicatorView *_indicatorView;
    
    NSInteger index_;
}
/**
 *  单例
 *
 *  @return
 */
+(instancetype)sharedInstanceSDPhotoBrower {
    
    static SDPhotoBrowser * sharedSDPhotoBrower = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedSDPhotoBrower = [[self alloc] init];
        sharedSDPhotoBrower.backgroundColor = SDPhotoBrowserBackgrounColor;
        
    });
    
    return sharedSDPhotoBrower;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}

-(void)getUserHeader:(NSInteger)index{
    
    index_ = index;
}

- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
        _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, statuBar_Height + 10);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];

    }
    return _indexLabel;
}

- (void)setupToolbars
{
    // 1. 序标
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.alpha = 1;
    _indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _indexLabel.layer.cornerRadius = _indexLabel.bounds.size.height * 0.5;
    _indexLabel.clipsToBounds = YES;
    _indexLabel.text = @"1/1";
    if (self.imageCount > 1) {
        _indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    [self addSubview:self.indexLabel];

    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
    
    // 3.设为头像按钮
    UIButton *headerButton = [[UIButton alloc] init];
    [headerButton setTitle:@"设为头像" forState:UIControlStateNormal];
    [headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    headerButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    headerButton.layer.cornerRadius = 5;
    headerButton.clipsToBounds = YES;
    [headerButton addTarget:self action:@selector(headerButton) forControlEvents:UIControlEventTouchUpInside];
    _headerButton = headerButton;
    
    if (_isFromPhotoWall) {
        
        if(index_ == 0 || index_ == 1){
            
            _headerButton.hidden = YES;
        }else{
            
            _headerButton.hidden = NO;
        }
        
    }else {
        
        _headerButton.hidden = YES;

    }
    
    [self addSubview:headerButton];
}

-(void)headerButton{
    
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    if (self.saveButtonDidClickBlock) {
        self.saveButtonDidClickBlock(index);
    }
}

- (void)saveImage
{
    //判断是否有访问相册权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //没有权限 拒绝
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有访问相册的权限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
        UIImageView *currentImageView = _scrollView.subviews[index];
        
        UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.center = self.center;
        _indicatorView = indicator;
        [[UIApplication sharedApplication].keyWindow addSubview:indicator];
        [indicator startAnimating];
        
    }

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = SDPhotoBrowserBackgrounColor;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];

    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;

        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    
    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
//    NSInteger currentIndex = currentImageView.tag;
    
//    CGRect targetTemp = CGRectMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0, 1, 1);
//    if (self.sourceImagesContainerView.subviews.count > 1) {
//        UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
//        targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
//    }

    
    UIImageView *tempView = [[UIImageView alloc] init];
//    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    if (h > SCREEN_HEIGHT) {
        h = SCREEN_HEIGHT;
    }
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];

    _saveButton.hidden = YES;
    _headerButton.hidden = YES;
    index_ = 0;
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
//        tempView.frame = targetTemp;
//        self.backgroundColor = [UIColor clearColor];
//        _indexLabel.alpha = 0.1;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alpha = 1;
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
//    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    _headerButton.frame = CGRectMake(self.bounds.size.width - 30 - 100, self.bounds.size.height - 70, 100, 25);
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];

}

-(void)hidden{
    
    [self removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    CGRect rect = CGRectMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0, 1, 1);
    if (self.sourceImagesContainerView.subviews.count > 1) {
        if (self.sourceImagesContainerView.subviews.count > self.currentImageIndex) {
            UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
            rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        }
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
//    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;

    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    
    if (_isFromPhotoWall) {
        if (index_ == 0 || index == 0) {
            
            _headerButton.hidden = YES;
        }else{
            
            _headerButton.hidden = NO;
        }
    }else {
        _headerButton.hidden = YES;
    }

    [self setupImageOfImageViewForIndex:index];
}



@end
