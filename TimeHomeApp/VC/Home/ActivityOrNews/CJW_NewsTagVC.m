//
//  CJW_NewsTagVC.m
//  TimeHomeApp
//
//  Created by cjw on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CJW_NewsTagVC.h"
#import "CJW_NewsTagCell.h"
#import "CJW_NewsTagHeaderView.h"
#import "NewsPresenter.h"
#import "CJW_NewsTagModel.h"

@interface CJW_NewsTagVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

//已收藏模型数组
@property (nonatomic,strong) NSMutableArray<CJW_NewsTagModel *> *collectModelArr;
//未收藏模型数组
@property (nonatomic,strong) NSMutableArray<CJW_NewsTagModel *> *unCollectModelArr;
//用于记录移动cell时的索引
@property (nonatomic,strong) NSIndexPath *oldIndexPath;
@property (nonatomic,strong) NSIndexPath *moveIndexPath;

@property (nonatomic,strong) UIView *snapshotView;

//是否处于编辑状态
@property (nonatomic,assign) BOOL isClick;

//编辑按钮状态
@property (nonatomic,copy) NSString *btnStatus;

@end

@implementation CJW_NewsTagVC
{
    CJW_NewsTagCell* _tagCell;
    UICollectionView *_collectionView;
    CJW_NewsTagHeaderView *_headerView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_lockArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    self.navigationItem.title = @"频道管理";
    
    self.btnStatus = @"编辑";
    //请求数据
    [self newsPresenter];
}

#pragma mark - 请求方法
- (void)newsPresenter {
    @WeakObj(self);
    //请求标签数据
    [NewsPresenter getZakerUserChanneList:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSDictionary * dic = (NSDictionary *)data;
                
                NSLog(@"---------%@-------",data);
                
                //需要锁定的标签
                NSString *lockchannels = [dic objectForKey:@"lockchannels"];
                _lockArr = [lockchannels componentsSeparatedByString:@","];
                //已收藏标签
                NSString * channels = [dic objectForKey:@"channels"];
                NSArray *arr = [channels componentsSeparatedByString:@","];
                NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:arr];
                //遍历去重
                for (NSString *string in arr) {
                        if ([_lockArr containsObject:string]) {
                            [mArr removeObject:string];
                            continue;
                        }
                }
                //拼接数组
                NSArray *collectArr = [[NSMutableArray alloc] init];
                collectArr = [_lockArr arrayByAddingObjectsFromArray:mArr];
                NSLog(@"%@",collectArr);
                
                //将收藏数据保存到模型
                for (NSInteger i = 0; i < collectArr.count; i++) {
                    CJW_NewsTagModel *model = [[CJW_NewsTagModel alloc] init];
                    model.title = collectArr[i];
                    model.color = kNewRedColor;
                    [self.collectModelArr addObject:model];
                    
                }
                ///edit by ls 2018.1.10  取出未添加的频道展示
                NSString *allchannels = [dic objectForKey:@"allchannels"];
                NSArray * allarr = [allchannels componentsSeparatedByString:@","];
                NSMutableArray *noAttentionArr = [[NSMutableArray alloc] init];
                [noAttentionArr  addObjectsFromArray:allarr];
                for (NSString * lschannel in allarr) {
                    
                    if ([collectArr containsObject:lschannel]) {
                        [noAttentionArr  removeObject:lschannel];
                    }
                    
                }
                ///edit by ls 2018.1.10
                
                //将未收藏数据保存到模型
                for (NSInteger i = 0; i < noAttentionArr.count; i++) {
                    CJW_NewsTagModel *model = [[CJW_NewsTagModel alloc] init];
                    model.title = noAttentionArr[i];
                    model.color = NEW_GRAY_COLOR;
                    [self.unCollectModelArr addObject:model];
                    
                }
                
                [_collectionView reloadData];
                [selfWeak initializeUI];
                
            }else
            {
                
                
            }
            
        });
        
    }];
}

#pragma mark - 初始化UI
- (void)initializeUI {

    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(84, 30);
        if ([UIApplication sharedApplication].keyWindow.frame.size.width < 375) {
            _layout.minimumLineSpacing = 8;
            _layout.minimumInteritemSpacing = 0;
        }else {
            _layout.minimumLineSpacing = 24;
            _layout.minimumInteritemSpacing = 34;
        }
        _layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 34);
    }
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView.backgroundColor = BLACKGROUND_COLOR;
        _collectionView.frame = CGRectMake(24, 0, [UIScreen mainScreen].bounds.size.width - 48, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:_collectionView];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册
        [_collectionView registerClass:[CJW_NewsTagCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[CJW_NewsTagHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        //滚动
        _collectionView.scrollEnabled = NO;
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        
        [_collectionView addGestureRecognizer:longPress];
    }
}

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.unCollectModelArr.count != 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _collectModelArr.count;
    }
    return _unCollectModelArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        _tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        _tagCell.title = _collectModelArr[indexPath.item].title;
        if (_isClick == YES) {
            for (NSInteger i = 0; i < _lockArr.count; i++) {
                _collectModelArr[i].color = NEW_GRAY_COLOR;
            }
        }else {
            for (NSInteger i = 0; i < _lockArr.count; i++) {
                _collectModelArr[i].color = kNewRedColor;
            }
        }
        _tagCell.label.layer.borderColor = _collectModelArr[indexPath.item].color.CGColor;
        _tagCell.label.textColor = _collectModelArr[indexPath.item].color;
        
        //第一组的删除按钮根据情况显示隐藏 第二组不需要按钮
        if (_isClick == NO || indexPath.item < _lockArr.count) {
            _tagCell.deleteBtn.hidden = YES;
        }else{
            _tagCell.deleteBtn.hidden = NO;
        }
        
        //设置删除按钮的tag 对应cell
        if (!indexPath.item) {
            _tagCell.deleteBtn.tag = 0;
        }else {
            _tagCell.deleteBtn.tag = indexPath.item;
        }
        [_tagCell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if(_unCollectModelArr.count != 0){
        _tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        _tagCell.title = _unCollectModelArr[indexPath.item].title;
        _tagCell.label.textColor = _unCollectModelArr[indexPath.item].color;
        _tagCell.label.layer.borderColor = _unCollectModelArr[indexPath.item].color.CGColor;
        _tagCell.deleteBtn.hidden = YES;
    }

    return _tagCell;
}

#pragma mark - 代理方法
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    _headerView.btnTitle = _btnStatus;
    if (indexPath.section == 0) {
        _headerView.title = @"我的频道";
        if (_isClick == YES) {
            _headerView.editLabel.hidden = NO;
        }else {
            _headerView.editLabel.hidden = YES;
        }
        [_headerView.btn setHidden:NO];
        [_headerView.btn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else {
        _headerView.title = @"点击添加频道";
        _headerView.editLabel.hidden = YES;
        [_headerView.btn setHidden:YES];
    }
    return _headerView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 44);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && _isClick == YES) {
        //取出移动item数据
        CJW_NewsTagModel *model = _unCollectModelArr[indexPath.item];
        
        //从数据源中移除该数据
        [_unCollectModelArr removeObject:model];

        
        //将数据插入到数据源中的目标位置 并赋值颜色
        model.color = kNewRedColor;
        [_collectModelArr addObject:model];
        [_collectionView reloadData];
    }
}

#pragma mark - 长按手势
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longPress{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        
        [self action:longPress];
        
    }else{
        
        [self iOS9_Action:longPress];
        
    }
    
}

#pragma mark - iOS9 之后的方法
- (BOOL)collectionView:(UICollectionView*)collectionView canMoveItemAtIndexPath:(NSIndexPath*)indexPath{
    // 返回YES允许item移动
    if (indexPath.section == 0 && _isClick == YES && indexPath.item >= _lockArr.count) {
        return YES;
    }
    return NO;
    
}

- (void)collectionView:(UICollectionView*)collectionView moveItemAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    //取出移动item数据
    CJW_NewsTagModel *model = _collectModelArr[sourceIndexPath.row];
    
    //从数据源中移除该数据
    [_collectModelArr removeObject:model];
    
    //将数据插入到数据源中的目标位置
    [_collectModelArr insertObject:model atIndex:destinationIndexPath.row];
}

- (void)iOS9_Action:(UILongPressGestureRecognizer *)longPress{

    switch(longPress.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在row上
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[longPress locationInView:_collectionView]];
            if(indexPath == nil){
                break;
            }

            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            [self.view bringSubviewToFront:cell];
            //iOS9方法 移动cell
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[longPress locationInView:_collectionView]];
            if(indexPath.item < _lockArr.count || indexPath.section == 1){
                break;
            }

            // iOS9方法 移动过程中随时更新cell位置
            [_collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_collectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            // 手势结束
            // iOS9方法 移动结束后关闭cell移动
            [_collectionView endInteractiveMovement];
        }
            break;
            
        default://手势其他状态
            [_collectionView cancelInteractiveMovement];
            break;
    }
    
}

#pragma mark - iOS9 之前的方法

- (void)action:(UILongPressGestureRecognizer *)longPress{
    
    switch(longPress.state){
            
        case UIGestureRecognizerStateBegan:{
            // 手势开始
            //判断手势落点位置是否在row上
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[longPress locationInView:_collectionView]];
            
            self.oldIndexPath = indexPath;
            
            if(indexPath == nil){
                break;
            }
            
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            
            // 使用系统的截图功能,得到cell的截图视图
            UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
            
            snapshotView.frame = cell.frame;
            self.snapshotView = snapshotView;
            [self.view addSubview:snapshotView];
            
            // 截图后隐藏当前cell
            cell.hidden=YES;
            
            CGPoint currentPoint = [longPress locationInView:_collectionView];
            
            [UIView animateWithDuration:0.25 animations:^{
                snapshotView.transform = CGAffineTransformMakeScale(1.05,1.05);
                snapshotView.center = currentPoint;
            }];
            
        }
            
            break;
            
        case UIGestureRecognizerStateChanged:{
            // 手势改变
            //当前手指位置 截图视图位置随着手指移动而移动
            CGPoint currentPoint = [longPress locationInView:_collectionView];
            self.snapshotView.center = currentPoint;
            
            // 计算截图视图和哪个可见cell相交
            for(UICollectionViewCell *cell in _collectionView.visibleCells) {
                
                // 当前隐藏的cell就不需要交换了,直接continue(无测试机,下面判断暂时这么写)
                
                if([_collectionView indexPathForCell:cell] == self.oldIndexPath || [_collectionView indexPathForCell:cell].item < _lockArr.count || [_collectionView indexPathForCell:cell].section == 1) {
                    continue;
                }
                
                // 计算中心距
                CGFloat space = sqrtf(pow(self.snapshotView.center.x - cell.center.x,2) + powf(self.snapshotView.center.y - cell.center.y,2));
                
                // 如果相交一半就移动
                if(space <= self.snapshotView.bounds.size.width/2) {
                    self.moveIndexPath = [_collectionView indexPathForCell:cell];
                    
                    //移动 会调用willMoveToIndexPath方法更新数据源
                    [_collectionView moveItemAtIndexPath:self.oldIndexPath toIndexPath:self.moveIndexPath];
                    
                    //设置移动后的起始indexPath
                    self.oldIndexPath = self.moveIndexPath;
                    break;
                }
            }
        }
            
            break;
            
        default:{
            // 手势结束和其他状态
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:self.oldIndexPath];
            
            // 结束动画过程中停止交互,防止出问题
            _collectionView.userInteractionEnabled=NO;
            
            // 给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                self.snapshotView.center = cell.center;
                self.snapshotView.transform = CGAffineTransformMakeScale(1.0,1.0);
            }completion:^(BOOL finished) {
                
                // 移除截图视图,显示隐藏的cell并开始交互
                [self.snapshotView removeFromSuperview];
                cell.hidden = NO;
                _collectionView.userInteractionEnabled = YES;
                
            }];
        }
            break;
    }
    
}

#pragma mark - 按钮点击方法

- (void)deleteBtnClick:(UIButton *)sender {
    //取出移动item数据
    CJW_NewsTagModel *model = _collectModelArr[sender.tag];
    
    //从数据源中移除该数据
    [_collectModelArr removeObject:model];

    //将数据插入到数据源中的目标位置 给需要移除标签的模型赋值颜色
    model.color = NEW_GRAY_COLOR;
    [_unCollectModelArr addObject:model];
    [_collectionView reloadData];
}

- (void)editBtnClick {
    if ([_headerView.btn.titleLabel.text isEqualToString:@"编辑"]) {

        self.btnStatus = @"完成";
        _tagCell.deleteBtn.hidden = NO;
        [_collectionView reloadData];
        _isClick = YES;
    

    }else {
        self.btnStatus = @"编辑";
        _tagCell.deleteBtn.hidden = YES;
        [_collectionView reloadData];
        _isClick = NO;

        ///edit by ls 2018.1.10 保存编辑好的标签
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < _collectModelArr.count; i++) {
            [arr addObject:_collectModelArr[i].title];
        }
        NSString * channels = [arr componentsJoinedByString:@","];
        @WeakObj(self);
        [NewsPresenter getZakerSaveChannels:channels withBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (resultCode == SucceedCode) {
                    
                    [selfWeak showToastMsg:@"保存成功！" Duration:2.0];
                }else
                {
                    [selfWeak showToastMsg:@"保存失败！" Duration:2.0];
                    
                }
            });
            
        }];
        ///edit by ls 2018.1.10 保存编辑好的标签
        
        
    }
}

#pragma mark - 懒加载

-(NSMutableArray *)collectModelArr {
    if (!_collectModelArr) {
        _collectModelArr = [[NSMutableArray alloc] init];
        return _collectModelArr;
    }
    return _collectModelArr;
}

-(NSMutableArray *)unCollectModelArr {
    if (!_unCollectModelArr) {
        _unCollectModelArr = [[NSMutableArray alloc] init];
        return _unCollectModelArr;
    }
    return _unCollectModelArr;
}

@end
