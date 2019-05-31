//
//  RaiN_QuestionPostVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_QuestionPostVC.h"
//图片展示的cell
#import "LayoutCell.h"
//标签的cell
#import "RaiN_LabelCell.h"
#import "SelectCell.h"
//#import "RaiN_LabelView.h"

#import "RaiN_LabelCustomCell.h"
#import "RaiN_LabelTitleCell.h"
#import "RaiN_AddLabelCell.h"
#import "THTags.h"

//自定义标签
//#import "CustomLabelVC.h"
#import "UIButtonImageWithLable.h"
//金钱奖励弹框
#import "QuestionAddMoneyAlert.h"
#import "OrdinaryAddMoneyAlert.h"
//----------图片相关库---------------
#import "TZImagePickerController.h"
//图片剪裁库
#import "TOCropViewController.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"
#import "AppSystemSetPresenters.h"
#import "ImageUitls.h"
//----------图片相关库---------------

#import "BBSMainPresenters.h"//接口
#import "L_NewPointPresenters.h"
#import "RaiN_BalanceAlert.h"
#import "ModeOfPaymentAlert.h"//选择支付类型

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppPayPresenter.h"
#define MAX_LIMIT_NUMS     50
@interface RaiN_QuestionPostVC ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate, TOCropViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SDPhotoBrowserDelegate>{
   //九宫格照片的flowLayout
    UICollectionViewFlowLayout *flowLayout;
    //标签
    UICollectionViewFlowLayout *flow;

    
    
    NSArray *leftImages;
    NSArray *myTitles;
    /**
     *  供选择的标签
     */
    NSMutableArray *forSelectTags;
    /**
     *  已选中的标签
     */
    NSMutableArray *hasSelectedTags;
    /**
     *  是否在未保存是选中过标签
     */
    BOOL isSelected;
    BOOL isHaveRedPacket; //有没有红包
    
    NSMutableArray *picIDArr;//返回的照片ID数组
    
    
    NSString *redallmoney;//红包总金额
    NSString *redallcount;//红包总个数
    NSString *redtheway;  //红包发放类型0 随机 1 定额
    NSString *paytype;    //支付类型0 余额 101 支付宝 102 微信
    NSString *oneMoney;   //单个红包金额
}

//九宫格照片的数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
//标签数据源
@property (nonatomic,strong)NSMutableArray *labelData;
//标签展示数据源
@property (nonatomic,strong)NSMutableArray *labelShowData;
@property (nonatomic,strong)NSMutableArray *temporaryArray;
/**
 相册选择器
 */
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;

@property (nonatomic,strong)NSMutableArray *imageUrlArr;//点击放大图片

@property (nonatomic,strong)NSMutableArray *labesTempArr;
@property (nonatomic,strong)NSMutableArray *labesIndexArr;


@end

@implementation RaiN_QuestionPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    [self createData];
    [self setUpUI];
    [self createCollectionView];
}

#pragma mark -- UI设置
- (void)setUpUI {

    isHaveRedPacket = NO;
    [self isNoHaveMoney];//隐藏金钱label和清空按钮
    [self createCollectionView];
    oneMoney = @"0";
    _topShowTV.tag = 11;
    _topShowTV.delegate = self;
    
    _bottomShowTV.tag = 12;
    _bottomShowTV.delegate = self;
    
    _tagsTF.delegate = self;
    _tagsTF.tag = 13;
    
    _bottonShowLabelBG.layer.cornerRadius = 15/2;
    _lineLabel.backgroundColor = LINE_COLOR;
    _bottomNumerLabel.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)_dataSource.count];
    
    _postBtn.backgroundColor = kNewRedColor;
    [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([_isQuestion isEqualToString:@"1"]) {
        
        [_postBtn setTitle:@"发 布 问 题" forState:UIControlStateNormal];
        _topQuestionBGToTop.constant = 8;
        _topQuestionBG.hidden = NO;
        _lineLabel.hidden = NO;
        self.navigationItem.title = @"问答贴";
        _bottomPHTV.text = @"您可以在这里补充问题细节";
        
    }else {
        [_postBtn setTitle:@"发 布" forState:UIControlStateNormal];
        _topQuestionBGToTop.constant = -92;
        _topQuestionBG.hidden = YES;
        _lineLabel.hidden = YES;
        self.navigationItem.title = @"普通贴";
        _bottomPHTV.text = @"有什么好玩的告诉大家";
    }

//    _tagsTFBgView.layer.cornerRadius = 35/2;
    _tagsTFBgView.layer.borderWidth = 1.0f;
    _tagsTFBgView.layer.borderColor = LINE_COLOR.CGColor;
    
}



#pragma mark -- 创建collectiuon and dataSource
- (void)createData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    if (!_labelData) {
        _labelData = [[NSMutableArray alloc] init];

    }
    if (!_labelShowData) {
        _labelShowData = [[NSMutableArray alloc] init];
        [_labelShowData addObjectsFromArray:@[@"车位",@"房产",@"美食",@"烹饪",@"旅游",@"健身",@"宠物",@"阅读",@"装修",@"搞笑"]];
    }
    forSelectTags = [[NSMutableArray alloc]init];
    
    hasSelectedTags = [[NSMutableArray alloc]init];

    picIDArr = [[NSMutableArray alloc] init];
    forSelectTags = [THTags mj_objectArrayWithKeyValuesArray:@[@{@"name":@"车位"},
                                                                @{@"name":@"房产"},
                                                                @{@"name":@"美食"},
                                                                @{@"name":@"烹饪"},
                                                                @{@"name":@"旅游"},
                                                                @{@"name":@"健身"},
                                                                @{@"name":@"宠物"},
                                                                @{@"name":@"阅读"},
                                                                @{@"name":@"装修"},
                                                                @{@"name":@"搞笑"}]];
    leftImages = [[NSArray alloc]initWithObjects:@"我的_个人设置_标签_已选定的标签",@"我的_个人设置_标签_点击选择标签", nil];
    myTitles = [[NSArray alloc]initWithObjects:@"已选定标签",@"点击选择标签", nil];
    
    hasSelectedTags = [[NSMutableArray alloc]initWithArray:@[]];
    
    _imageUrlArr = [[NSMutableArray alloc] init];
    
    if (!_temporaryArray) {
        _temporaryArray= [[NSMutableArray alloc] init];
    }
    
    if (!_labesTempArr) {
        _labesTempArr = [[NSMutableArray alloc] init];
    }
    if (!_labesIndexArr) {
        _labesIndexArr = [[NSMutableArray alloc] init];
    }
}

- (void)createCollectionView {

    /**
     照片展示
     */
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.scrollEnabled = NO;
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 16 - 61 - 14)/3, (SCREEN_WIDTH - 16 - 61 - 14)/3);
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 8;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.tag = 21;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"LayoutCell" bundle:nil] forCellWithReuseIdentifier:@"LayoutCell"];

    /**
     标签列表
     */
    _labelTableView.delegate = self;
    _labelTableView.dataSource = self;
    _labelTableView.scrollEnabled = NO;
    _labelTableView.tableFooterView = [[UIView alloc]init];
    _labelTableView.backgroundColor = [UIColor whiteColor];
    [_labelTableView registerClass:[RaiN_LabelTitleCell class] forCellReuseIdentifier:NSStringFromClass([RaiN_LabelTitleCell class])];
    [_labelTableView registerClass:[RaiN_LabelCustomCell class] forCellReuseIdentifier:NSStringFromClass([RaiN_LabelCustomCell class])];
    [_labelTableView registerClass:[RaiN_AddLabelCell class] forCellReuseIdentifier:NSStringFromClass([RaiN_AddLabelCell class])];
}


#pragma mark -- 九宫格代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LayoutCell" forIndexPath:indexPath];
    if (_dataSource.count > 0) {
        if ([_dataSource[indexPath.row] isKindOfClass:[UIImage class]]) {
            cell.showImageView.image = _dataSource[indexPath.row];
        }
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     点击放大图片
     */
    SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
    browser.sourceImagesContainerView = self.view;
    browser.imageCount = _dataSource.count;
    browser.currentImageIndex = indexPath.row;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
}

#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return [UIImage imageNamed:@"图片加载失败"];
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:_imageUrlArr[index]];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return WidthSpace(26.f);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return WidthSpace(105);
    }
    if (indexPath.row == 1) {
        
        RaiN_LabelCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RaiN_LabelCustomCell class])];
        
        
        if (indexPath.section == 0) {
            if (hasSelectedTags.count <= 0) {
                _tableViewHeight.constant = WidthSpace(105)*2 + [cell configureHeightForCellTagsArray:forSelectTags]+ 20 +40 + 10;
                return 40;
                
            }else {
                _tableViewHeight.constant = WidthSpace(105)*2 + [cell configureHeightForCellTagsArray:forSelectTags]+ 20 +[cell configureHeightForCellTagsArray:hasSelectedTags]+20 + 10;
                return [cell configureHeightForCellTagsArray:hasSelectedTags]+20;
            }
            
        }
        if (indexPath.section == 1) {
            return [cell configureHeightForCellTagsArray:forSelectTags]+20;
        }
        
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        return WidthSpace(180);
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    
    RaiN_LabelTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RaiN_LabelTitleCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftImage = [UIImage imageNamed:leftImages[indexPath.section]];
    cell.titleString = myTitles[indexPath.section];
    
    if (indexPath.row == 1) {
        RaiN_LabelCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RaiN_LabelCustomCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            
            [cell configureCellTagsArray:hasSelectedTags atIndexPath:indexPath isCancelOrNot:YES];
            /**
             *  删除标签
             */
            cell.cancelCallBack = ^(NSInteger selectIndex) {
                
                RaiN_AddLabelCell *cell = [_labelTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                [cell.addtagTF resignFirstResponder];
                
                isSelected = YES;
                
                THTags *tag = [hasSelectedTags objectAtIndex:selectIndex];
                
                for (int i = 0; i < _labesTempArr.count; i++) {
                    THTags *oneTag = [_labesTempArr objectAtIndex:i];
                    if ([oneTag.name isEqualToString:tag.name]) {
                        [_labesTempArr removeObject:[hasSelectedTags objectAtIndex:selectIndex]];
                        [forSelectTags addObject:[hasSelectedTags objectAtIndex:selectIndex]];
                       
                    }
                }
                
                [hasSelectedTags removeObjectAtIndex:selectIndex];
                
                [selfWeak.labelTableView reloadData];
                
            };
        }
        if (indexPath.section == 1) {
            [cell configureCellTagsArray:forSelectTags atIndexPath:indexPath isCancelOrNot:NO];
            /**
             *  选中标签
             */
            
            cell.selectedCallBack = ^(NSInteger selectIndex) {
                
                RaiN_AddLabelCell *cell = [_labelTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                [cell.addtagTF resignFirstResponder];
                
                [selfWeak.labelTableView reloadData];
                if (hasSelectedTags.count == 5) {
                    [selfWeak showToastMsg:@"最多设置5个标签" Duration:2.0];
                    return ;
                }
                
                /**
                 *  不允许重复选中
                 */
                THTags *tag = [forSelectTags objectAtIndex:selectIndex];
                for (THTags *oneTag in hasSelectedTags) {
                    if ([oneTag.name isEqualToString:tag.name]) {
                        
                        [selfWeak showToastMsg:@"您已选中此标签" Duration:2.0];
                        return ;
                    }
                }
                
                isSelected = YES;
                [hasSelectedTags addObject:[forSelectTags objectAtIndex:selectIndex]];
                
                [_labesTempArr addObject:forSelectTags[selectIndex]];
                [_labesIndexArr addObject:[NSString stringWithFormat:@"%ld",(unsigned long)[forSelectTags indexOfObject:forSelectTags[selectIndex]]]];
                
                [forSelectTags removeObjectAtIndex:selectIndex];
                [selfWeak.labelTableView reloadData];
            };
        }
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        RaiN_AddLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RaiN_AddLabelCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /**
         *  添加标签
         */
        @WeakObj(cell);
        cell.addTagsCallBack = ^(){
            
            [cellWeak.addtagTF resignFirstResponder];
            
            if (hasSelectedTags.count == 5) {
                [selfWeak showToastMsg:@"最多设置5个标签" Duration:2.0];
                return ;
            }
            
            if ([XYString isBlankString:cellWeak.addtagTF.text]) {
                return ;
            }
            /**
             *  判断是否重复，若重复则不处理
             */
            for (THTags *oneTag in hasSelectedTags) {
                if ([oneTag.name isEqualToString:cellWeak.addtagTF.text]) {
                    [selfWeak showToastMsg:@"您已添加此标签" Duration:2.0];
                    return;
                }
            }
            
            if (cellWeak.addtagTF.text.length > 5) {
                [selfWeak showToastMsg:@"标签要在5字以内哦" Duration:2.0];
                return;
            }
            
            /**
             *  添加用户自定义标签
             */
            cellWeak.addtagTF.delegate = selfWeak;
            isSelected = YES;
            NSDictionary *dic = [NSDictionary dictionaryWithObject:cellWeak.addtagTF.text forKey:@"name"];
            [hasSelectedTags addObject:dic];
            cellWeak.addtagTF.text = @"";
            hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:hasSelectedTags];
            [selfWeak.labelTableView reloadData];
        };
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.section == 1 && indexPath.row == 2) {
        width = SCREEN_WIDTH/2-7;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
}



#pragma mark -- 按钮点击事件
//添加图片按钮
- (IBAction)addPicBtn:(id)sender {
    [_tagsTF resignFirstResponder];
    [self.view endEditing:YES];
    if (_dataSource.count >= 10) {
        [self showToastMsg:@"您最多可添加十张图片" Duration:3.0f];
        return;
    }
    @WeakObj(self);
    // 类方法
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex==0)//拍照
        {
            
            /** 相机授权判断 */
            if (![self canOpenCamera]) {
                return ;
            };
            
            /**
             *  最多能选择数
             */
            ZZCameraController *cameraController = [[ZZCameraController alloc]init];
            cameraController.takePhotoOfMax = 10 - _dataSource.count;
            cameraController.isSaveLocal = NO;
            cameraController.cameraSourceType = ZZImageSourceForMutable;

            
            [cameraController showIn:self result:^(id responseObject){
                
                NSLog(@"responseObject==%@",responseObject);
                NSArray *imageArr = (NSArray *)responseObject;
                
                for (int i = 0; i < imageArr.count; i++) {
                    UIImage *image = (UIImage *)imageArr[i];
                    UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
                    
                    
                    
                    @WeakObj(self);
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    
                    [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if(resultCode == SucceedCode) {//图片上传成功
                                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                                [picIDArr addObject:picID];
                                [_dataSource addObject:image];
                                [_imageUrlArr addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                                
                                
                                _bottomNumerLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                                if (_dataSource.count > 3 && _dataSource.count <= 6) {
                                    
                                    _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2 + 109;
                                }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
                                    _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3 + 109;
                                }else if(_dataSource.count > 9) {
                                    _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4 + 109;
                                }else {
                                    _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8) + 109;
                                }
                                [_collectionView reloadData];
                                
                            }else {//图片上传失败
                                
                                if ([data isKindOfClass:[NSString class]]) {
                                    if (![XYString isBlankString:data]) {
                                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                    }else {
                                        [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                                    }
                                }
                            }
                        });
                    }];
                }
            }];
            
            
        }else if (buttonIndex==1)//相册
        {
            _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:selfWeak];
            _imagePickerVC.maxImagesCount = 10 - _dataSource.count;
            
            _imagePickerVC.pickerDelegate = selfWeak;
            [self presentViewController:_imagePickerVC animated:YES completion:^{
                
            }];
        }
    }];
    [sheet setTextColor:UIColorFromRGB(0xffffff)];
    [sheet show];
    

}
//删除图片按钮
- (void)deletePhotos:(UIButton *)sender {
    [_dataSource removeObjectAtIndex:sender.tag - 100];
    [picIDArr removeObjectAtIndex:sender.tag - 100];
    [_imageUrlArr removeObjectAtIndex:sender.tag - 100];
    _bottomNumerLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
    if (_dataSource.count > 3 && _dataSource.count <= 6) {
        
        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2 + 109;
    }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3 + 109;
    }else if(_dataSource.count > 9) {
        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4 + 109;
    }else {
        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8) + 109;
    }
        [_collectionView reloadData];
}



/**
 发帖
 */
- (IBAction)postClick:(id)sender {
    [_tagsTF resignFirstResponder];
    if ([_isQuestion isEqualToString:@"0"]) {
        //普通帖
        if ([XYString isBlankString:_bottomShowTV.text]) {
            [self showToastMsg:@"内容不能为空" Duration:3.0f];
            return;
        }
        
        
        if (isHaveRedPacket == YES) {
            //有红包
            [self alertRedPacket];
            
        }else {
            //没有红包
            [self postMyPosts];
        }
        
    }else {
        //问答帖
        if ([XYString isBlankString:_topShowTV.text]) {
            [self showToastMsg:@"问答标题不能为空" Duration:3.0f];
            return;
        }
        
        if (isHaveRedPacket == YES) {
            //有红包
            [self alertQuestionRedPacket];
            
        }else {
            //没有红包
            [self postQusetion];//发布问答帖
        }
    }
}


/**
 清空金钱
 */
- (IBAction)clearBtnClick:(id)sender {
    [_tagsTF resignFirstResponder];
    redallmoney = @"";
    redallcount = @"";
    redtheway = @"";
    [self isNoHaveMoney];
}

/**
 修改金钱
 */
- (IBAction)changeMoneyBtnClick:(id)sender {
    [_tagsTF resignFirstResponder];
    if ([_isQuestion isEqualToString:@"0"]) {
        //普通帖
        OrdinaryAddMoneyAlert *ordinary = [OrdinaryAddMoneyAlert shareAddMoneyVC];
        if ([redtheway integerValue] == 0 ) {
            ordinary.isRandom = @"0";//随机
            ordinary.theNumberTF.text = redallcount;
            ordinary.theMoneyTF.text = [NSString stringWithFormat:@"%ld",[redallmoney integerValue]];
        }else {
            ordinary.isRandom = @"1";//随机
            ordinary.theNumberTF.text = [NSString stringWithFormat:@"%ld",[redallcount integerValue]];
            ordinary.theMoneyTF.text = [NSString stringWithFormat:@"%ld",[oneMoney integerValue]];
        }
        [ordinary show:self];
        @WeakObj(self)
        ordinary.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
            if (index == 0) {
                
                
                if ([data[2] isEqualToString:@"0"]) {
                    //随机金额 展示 总金额/个数
                    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue],data[0]];
                    redallmoney = data[1];
                    redallcount = data[0];
                    redtheway = @"0";
                    oneMoney = @"";
                }else {
                    //固定金额
                    
                    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue] * [data[0] floatValue],data[0]];
                    redallmoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue] * [data[0] floatValue]];
                    redallcount = data[0];
                    redtheway = @"1";
                    oneMoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue]];
                }
                [selfWeak isHaveMoney];
                
            }
        };
        
    }else {
        
        
        
        //问答帖
        QuestionAddMoneyAlert *question = [QuestionAddMoneyAlert shareAddMoneyVC];
        question.moneyTf.text = oneMoney;
        /****/
        [question show:self];
        @WeakObj(question)
        @WeakObj(self)
        question.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
            if (index == 0) {
                NSString *textStr = data;
                if (textStr.length <= 0) {
                    [selfWeak isNoHaveMoney];
                    [selfWeak showToastMsg:@"请输入正确的金额" Duration:3.0f];
                    return;
                }
                if ([textStr floatValue] < 1) {
                    [selfWeak isNoHaveMoney];
                    [selfWeak showToastMsg:@"奖励金额最少1元" Duration:3.0f];
                    return;
                }
                [questionWeak dismiss];
                
                _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",(CGFloat)[data floatValue]];
                redallmoney = data;
                oneMoney = data;
                [selfWeak isHaveMoney];
            }
        };
    }
}

/**
 添加金钱奖励
 */
- (IBAction)addMoneyClick:(id)sender {
    [_tagsTF resignFirstResponder];
    switch ([_isQuestion integerValue]) {
        case 0:
        {
            //普通帖
            
            OrdinaryAddMoneyAlert *ordinary = [OrdinaryAddMoneyAlert shareAddMoneyVC];
            [ordinary show:self];
            @WeakObj(self)
            ordinary.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                if (index == 0) {
                    
                    
                    if ([data[2] isEqualToString:@"0"]) {
                        //随机金额 展示 总金额/个数
                        _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue],data[0]];
                        redallmoney = data[1];
                        redallcount = data[0];
                        redtheway = @"0";
                        oneMoney = @"";
                        
                    }else {
                        //固定金额
                        
                        _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue] * [data[0] floatValue],data[0]];
                        redallmoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue] * [data[0] floatValue]];
                        redallcount = data[0];
                        redtheway = @"1";
                        oneMoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue]];
                    }
                    [selfWeak isHaveMoney];
                    
                }
            };
            
        }
            break;
            
            
        case 1:
        {
            
            //问答帖
            QuestionAddMoneyAlert *question = [QuestionAddMoneyAlert shareAddMoneyVC];
            /****/
            [question show:self];
            @WeakObj(question)
            @WeakObj(self)
            question.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                if (index == 0) {
                    NSString *textStr = data;
                    if (textStr.length <= 0) {
                        [selfWeak isNoHaveMoney];
                        [selfWeak showToastMsg:@"请输入正确的金额" Duration:3.0f];
                        return;
                    }
                    if ([textStr floatValue] < 1) {
                        [selfWeak isNoHaveMoney];
                        [selfWeak showToastMsg:@"奖励金额最少1元" Duration:3.0f];
                        return;
                    }
                    [questionWeak dismiss];
                    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",(CGFloat)[data floatValue]];
                    redallmoney = data;
                    oneMoney = data;
                    [selfWeak isHaveMoney];
                }
            };

            
        }
            break;
            
        default:
            break;
    }
    
    
}
/**
 添加标签
 */
- (IBAction)addTagsClick:(id)sender {
    [_tagsTF resignFirstResponder];
    if (hasSelectedTags.count == 5) {
        [self showToastMsg:@"最多设置5个标签" Duration:2.0];
        return ;
    }
    if (_tagsTF.text.length <= 0) {
        return;
    }
    if ([XYString isBlankString:_tagsTF.text]) {
        return ;
    }
    /**
     *  判断是否重复，若重复则不处理
     */
    for (THTags *oneTag in hasSelectedTags) {
        if ([oneTag.name isEqualToString:_tagsTF.text]) {
            [self showToastMsg:@"您已添加此标签" Duration:2.0];
            return;
        }
    }
    
    if (_tagsTF.text.length > 5) {
        [self showToastMsg:@"标签要在5字以内哦" Duration:2.0];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_tagsTF.text forKey:@"name"];
    [hasSelectedTags addObject:dic];
    _tagsTF.text = @"";
    hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:hasSelectedTags];
    [_labelTableView reloadData];
    
    
}


#pragma mark TZImagePickerControllerDelegate

// MARK: - 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    for (int i = 0; i < photos.count; i++) {
        UIImage *image = (UIImage *)photos[i];
        UIImage *newImg = [ImageUitls reduceImage:image percent:PIC_SCALING];
        
        @WeakObj(self);
        
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [AppSystemSetPresenters upLoadPicFile:newImg UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if(resultCode == SucceedCode) {//图片上传成功
                    
                    //处理
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    [picIDArr addObject:picID];
                    [_dataSource addObject:image];
                    [_imageUrlArr addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                    _bottomNumerLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                    
                    if (_dataSource.count > 3 && _dataSource.count <= 6) {
                        
                        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2 + 109;
                    }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
                        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3 + 109;
                    }else if(_dataSource.count > 9) {
                        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4 + 109;
                    }else {
                        _bgViewH.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8) + 109;
                    }
                    
                    
                    [_collectionView reloadData];
                    
                    
                }else {//图片上传失败
                    
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                        }else {
                            [selfWeak showToastMsg:@"图片上传失败" Duration:3.0];
                        }
                    }
                }
            });
        }];
    }
}


#pragma mark ---- textView相关
- (void)textViewDidEndEditing:(UITextView *)textView {
    switch (textView.tag) {
        case 11:
        {
            
            if (textView.text.length <= 0) {
                _showNumberLabel.text = @"0/50";
                _topPlacehodelTV.hidden = NO;
                _topShowTV.backgroundColor = [UIColor clearColor];
            }else {
                _topPlacehodelTV.hidden = YES;
                _topShowTV.backgroundColor = [UIColor whiteColor];
            }
        }
            break;
        case 12:
        {
            if (textView.text.length <= 0) {
                _bottomPHTV.hidden = NO;
                _bottomShowTV.backgroundColor = [UIColor clearColor];
            }else {
                _bottomPHTV.hidden = YES;
                _bottomShowTV.backgroundColor = [UIColor whiteColor];
            }
        }
            break;
        default:
            break;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 11:
        {
            _topPlacehodelTV.hidden = YES;
            _topShowTV.backgroundColor = [UIColor whiteColor];
            
        }
            break;
        case 12:
        {
            _bottomPHTV.hidden = YES;
            _bottomShowTV.backgroundColor = [UIColor whiteColor];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
        switch (textView.tag) {
        case 11:
        {
            NSString  *nsTextContent = textView.text;
            
            NSInteger existTextNum = nsTextContent.length;
            
            if (existTextNum > MAX_LIMIT_NUMS)
            {
                
                
                NSString *tempStr = [nsTextContent substringWithRange:NSMakeRange(nsTextContent.length-2, 2)];
                if ([self stringContainsEmoji:tempStr]) {
                    
                    [self showToastMsg:@"最多可输入50个字" Duration:3.0f];
                    if (existTextNum%2 ==0) {
                        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
                        [textView setText:s];
                    }else {
                        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS - 1];
                        [textView setText:s];
                    }
                    
                }else {
                    [self showToastMsg:@"最多可输入50个字" Duration:3.0f];
                    NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
                    [textView setText:s];
                }
            }
            
            if (textView.markedTextRange == nil) {
//                 NSString *tempStr = textView.text;
                 //去除掉首尾的空白字符和换行字符
//                 tempStr = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                 tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//                 tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                    //记录空格和换行
//                NSInteger textLenth = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
//                if(textLenth <= 0) {
//                    _showNumberLabel.text = @"0/50";
//                    return;
//                }

                _showNumberLabel.text = [NSString stringWithFormat:@"%ld/50",textView.text.length];
                
            }else {
                _showNumberLabel.text = @"0/50";
            }
 
            
        }
           break;
        case 12:
        {
            
            NSString  *nsTextContent = textView.text;
            
            NSInteger existTextNum = nsTextContent.length;
            
            if (existTextNum > 500)
            {

                NSString *tempStr = [nsTextContent substringWithRange:NSMakeRange(nsTextContent.length-2, 2)];
                if ([self stringContainsEmoji:tempStr]) {
                    
                    [self showToastMsg:@"最多输入500字" Duration:3.0f];
                    if (existTextNum%2 ==0) {
                        NSString *s = [nsTextContent substringToIndex:500];
                        [textView setText:s];
                    }else {
                        NSString *s = [nsTextContent substringToIndex:499];
                        [textView setText:s];
                    }
                    
                }else {
                    [self showToastMsg:@"最多输入500字" Duration:3.0f];
                    NSString *s = [nsTextContent substringToIndex:500];
                    [textView setText:s];
                }
            }
        }
            break;
            
        default:
            break;
    }
    if (textView.tag != 11) {
        return;
    }
    
}




#pragma mark ------ 添加奖励金钱UI相关
- (void)isHaveMoney {
    if ([_isQuestion isEqualToString:@"1"]) {
        //不变
        
        _showLabel.text = @"现金";
        _moneyImageView.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
        
    }else {
        _moneyImageView.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
        _showLabel.text = @"红包";
    }
    
    _moneyLabel.hidden = NO;
    _addBtn.hidden = YES;
    _clearBtn.hidden = NO;
    _changeMoneyBtn.hidden = NO;
    isHaveRedPacket = YES;
}

- (void)isNoHaveMoney {
    if ([_isQuestion isEqualToString:@"1"]) {
     _showLabel.text = @"发 现金 奖励";
     _moneyImageView.image = [UIImage imageNamed:@"邻趣-发布-红包图标"];
    }else {
     _moneyImageView.image = [UIImage imageNamed:@"邻趣-发布-红包图标"];
     _showLabel.text = @"发 红包 奖励";
    }
    _moneyLabel.text = @"";
    _moneyLabel.hidden = YES;
    _addBtn.hidden = NO;
    _clearBtn.hidden = YES;
    isHaveRedPacket = NO;
    _changeMoneyBtn.hidden = YES;
}


#pragma mark ------ 发帖与支付处理

//////有红包
- (void)alertRedPacket {
   
    ModeOfPaymentAlert *payment = [ModeOfPaymentAlert sharePaymentVC];
    payment.moneyStr = redallmoney;
    [payment show:self];
    @WeakObj(self)
    payment.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
        switch (index) {
            case 0:
            {
                //支付宝
                NSLog(@"支付宝");
                [selfWeak isHaveRedPAcketPostMyPostsWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信");
                [selfWeak isHaveRedPAcketPostMyPostsWithType:@"102"];
            }
                break;
            case 2:
            {
                NSLog(@"余额");
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                redPacket.needPayStr = redallmoney;
                [redPacket show:self];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                  //调用余额支付
                    [selfWeak isHaveRedPAcketPostMyPostsWithType:@"0"];
                };
                
                
            }
                break;
                
            default:
                break;
        }
    };
    
}


//////没有红包普通帖
- (void)postMyPosts {
    /**
     token	是	登陆令牌 可以为空
     title	是	标题没有则传递空
     content	是	内容
     picids	是	图片上传后返回的Id 逗号拼接的字符
     redtype	是	0 红包1 粉包 -1 无红包
     paytype	是	支付类型0 余额 101 支付宝 102 微信
     redallmoney	是	红包总金额
     redallcount	是	红包总个数
     redtheway	是	红包发放类型0 随机 1 定额
     tagsname	是	标签名称,多个则逗号拼接
     */
    
    
    NSString *picIDStr = @"";
    for (NSString *IDs in picIDArr) {
        picIDStr = [picIDStr stringByAppendingString:[NSString stringWithFormat:@"%@,",IDs]];
    }
    if (picIDStr.length > 0) {
        picIDStr = [picIDStr substringFromIndex:0];
    }
    
    NSString *tagsStr = @"";
    NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
    tagsArr = [THTags mj_keyValuesArrayWithObjectArray:hasSelectedTags];
    for (NSDictionary *tagsDic in tagsArr) {
        tagsStr = [tagsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tagsDic[@"name"]]];
    }
    if (tagsStr.length > 0) {
        tagsStr = [tagsStr substringFromIndex:0];
    }
    NSLog(@"%@",tagsStr);
    NSLog(@"%lu",(unsigned long)tagsStr.length);

    picIDStr  = [XYString IsNotNull:picIDStr];
    tagsStr  = [XYString IsNotNull:tagsStr];
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters postOrdinaryPosts:@"" andContent:_bottomShowTV.text andPicids:picIDStr andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"0" andTagsname:tagsStr andOneMoney:oneMoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
//                [selfWeak showToastMsg:@"发贴成功" Duration:3.0];
                [self updUserIntebyType];
                [self jumpIndexLQ];
                
            }else {
                //失败
                //NSString *string = (NSString *)data;
                if ([data isKindOfClass:[NSString class]]) {
                    if ([XYString isBlankString:data]) {
                        [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                }else {
                    [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                }

            }
        });
    }];
}


/////有红包普通帖
- (void)isHaveRedPAcketPostMyPostsWithType:(NSString *)type {
    /**
     token	是	登陆令牌 可以为空
     title	是	标题没有则传递空
     content	是	内容
     picids	是	图片上传后返回的Id 逗号拼接的字符
     redtype	是	0 红包1 粉包 -1 无红包
     paytype	是	支付类型0 余额 101 支付宝 102 微信
     redallmoney	是	红包总金额
     redallcount	是	红包总个数
     redtheway	是	红包发放类型0 随机 1 定额
     tagsname	是	标签名称,多个则逗号拼接
     */
    
    
    NSString *picIDStr = @"";
    for (NSString *IDs in picIDArr) {
        picIDStr = [picIDStr stringByAppendingString:[NSString stringWithFormat:@"%@,",IDs]];
    }
    if (picIDStr.length > 0) {
        picIDStr = [picIDStr substringFromIndex:0];
    }
    
    NSString *tagsStr = @"";
    NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
    tagsArr = [THTags mj_keyValuesArrayWithObjectArray:hasSelectedTags];
    for (NSDictionary *tagsDic in tagsArr) {
        tagsStr = [tagsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tagsDic[@"name"]]];
    }
    if (tagsStr.length > 0) {
        tagsStr = [tagsStr substringFromIndex:0];
    }
    
    picIDStr  = [XYString IsNotNull:picIDStr];
    tagsStr  = [XYString IsNotNull:tagsStr];
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters postOrdinaryPosts:@"" andContent:_bottomShowTV.text andPicids:picIDStr andRedtype:@"0" andPaytype:type andRedallmoney:redallmoney andRedallcount:redallcount andRedtheway:redtheway andTagsname:tagsStr andOneMoney:oneMoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
                
                
                if ([type isEqualToString:@"102"]) {
                    //微信
                    [selfWeak jumpToWXPay:data[@"map"]];
                    
                }else if([type isEqualToString:@"101"]) {
                    
                    [selfWeak jumpToAliPay:data[@"map"]];
                    
                }else {
                    [selfWeak updUserIntebyType];
                    [self jumpIndexLQ];
                }
                
            }else {
                //失败
                //NSString *string = (NSString *)data;
                if ([data isKindOfClass:[NSString class]]) {
                    if ([XYString isBlankString:data]) {
                        [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                }else {
                    [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                }

            }
        });
    }];
}





/**********     问答帖     **********/

//没有红包的问答帖
- (void)postQusetion {
    
    
    /**
     问答帖
     接口域名/answerpost/addanswerpost
     posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
     title	是	标题
     content	是	问题描述
     picids	是	照片资源表ID,多个则逗号拼接
     rewardtype	是	奖励形式 0 现金 1 积分
     rewardmoney	是	奖励金额
     paytype	是	支付类型0 余额 101 支付宝 102 微信
     tagsname	是	标签名称,多个则逗号拼接
     */
    
    NSString *picIDStr = @"";
    for (NSString *IDs in picIDArr) {
        picIDStr = [picIDStr stringByAppendingString:[NSString stringWithFormat:@"%@,",IDs]];
    }
    if (picIDStr.length > 0) {
        picIDStr = [picIDStr substringFromIndex:0];
    }
    
    NSString *tagsStr = @"";
    NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
    tagsArr = [THTags mj_keyValuesArrayWithObjectArray:hasSelectedTags];
    for (NSDictionary *tagsDic in tagsArr) {
        tagsStr = [tagsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tagsDic[@"name"]]];
    }
    if (tagsStr.length > 0) {
        tagsStr = [tagsStr substringFromIndex:0];
    }
    
    picIDStr  = [XYString IsNotNull:picIDStr];
    tagsStr  = [XYString IsNotNull:tagsStr];
    
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters postQuestionPosts:@"3" andTitle:_topShowTV.text andContent:_bottomShowTV.text andPicids:picIDStr andRewardtype:@"-1" andPaytype:@"-1" andRewardmoney:@"0" andTagsname:tagsStr updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
//                [selfWeak showToastMsg:@"发贴成功" Duration:3.0];
                [self updUserIntebyType];
                [self jumpIndexLQ];
            }else {
                //失败
                //NSString *string = (NSString *)data;
                if ([data isKindOfClass:[NSString class]]) {
                    if ([XYString isBlankString:data]) {
                        [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                }else {
                    [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                }

            }
        });
        
    }];
    
}



///问答帖红包弹窗
- (void)alertQuestionRedPacket {
    
    ModeOfPaymentAlert *payment = [ModeOfPaymentAlert sharePaymentVC];
    payment.moneyStr = redallmoney;
    [payment show:self];
    @WeakObj(self)
    payment.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
        switch (index) {
            case 0:
            {
                //支付宝
                NSLog(@"支付宝");
                [selfWeak isHaveRedPacketPostQusetionWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信");
                [selfWeak isHaveRedPacketPostQusetionWithType:@"102"];
            }
                break;
            case 2:
            {
                NSLog(@"余额");
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                redPacket.needPayStr = redallmoney;
                [redPacket show:self];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    //调用余额支付
                    [selfWeak isHaveRedPacketPostQusetionWithType:@"0"];
                };
                
                
            }
                break;
                
            default:
                break;
        }
    };
    
}



//有红包的问答帖
- (void)isHaveRedPacketPostQusetionWithType:(NSString *)type {
    
    
    /**
     问答帖
     接口域名/answerpost/addanswerpost
     posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
     title	是	标题
     content	是	问题描述
     picids	是	照片资源表ID,多个则逗号拼接
     rewardtype	是	奖励形式 0 现金 1 积分
     rewardmoney	是	奖励金额
     paytype	是	支付类型0 余额 101 支付宝 102 微信
     tagsname	是	标签名称,多个则逗号拼接
     */
    
    NSString *picIDStr = @"";
    for (NSString *IDs in picIDArr) {
        picIDStr = [picIDStr stringByAppendingString:[NSString stringWithFormat:@"%@,",IDs]];
    }
    if (picIDStr.length > 0) {
        picIDStr = [picIDStr substringFromIndex:0];
    }
    
    NSString *tagsStr = @"";
    NSMutableArray *tagsArr = [[NSMutableArray alloc] init];
    tagsArr = [THTags mj_keyValuesArrayWithObjectArray:hasSelectedTags];
    for (NSDictionary *tagsDic in tagsArr) {
        tagsStr = [tagsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tagsDic[@"name"]]];
    }
    if (tagsStr.length > 0) {
        tagsStr = [tagsStr substringFromIndex:0];
    }
    
    picIDStr  = [XYString IsNotNull:picIDStr];
    tagsStr  = [XYString IsNotNull:tagsStr];
    
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters postQuestionPosts:@"3" andTitle:_topShowTV.text andContent:_bottomShowTV.text andPicids:picIDStr andRewardtype:@"0" andPaytype:type andRewardmoney:redallmoney andTagsname:tagsStr updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
                
                
                if ([type isEqualToString:@"102"]) {
                    //微信
                    [selfWeak jumpToWXPay:data[@"map"]];
                    
                    
                }else if([type isEqualToString:@"101"]) {
                    
                    [selfWeak jumpToAliPay:data[@"map"]];
                    
                }else {
                    [selfWeak updUserIntebyType];
                    [self jumpIndexLQ];
                }
                
                
            }else {
                //失败
                //NSString *string = (NSString *)data;
                if ([data isKindOfClass:[NSString class]]) {
                    if ([XYString isBlankString:data]) {
                        [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                    }else {
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                }else {
                    [selfWeak showToastMsg:@"发贴失败" Duration:3.0];
                }

            }
        });
    }];
}



#pragma mark ----------- 发帖完毕调用，不需要处理其结果
- (void)updUserIntebyType {
    [L_NewPointPresenters updUserIntebyTypeWithType:20 content:@"发贴子" costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
    }];
}





#pragma mark --------- 支付---------

/**
 微信支付
 */
- (void)jumpToWXPay:(id)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary * tempDic = [param objectForKey:@"thirdpay"];
        NSString * timerStr = [tempDic objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"appid"]];
        req.partnerId           = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"partnerid"]];
        req.prepayId            = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"prepayid"]];
        req.nonceStr            = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"noncestr"]];
        req.timeStamp           = timerStr.intValue;
        req.package             = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"package"]];
        req.sign                = [NSString stringWithFormat:@"%@",[tempDic objectForKey:@"sign"]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @WeakObj(self);
            [APPWXPAYMANAGER usPay_payWithPayReq:req callBack:^(enum WXErrCode errCode) {
                
                NSLog(@"errorCode = %zd",errCode);
                if (errCode == WXSuccess) {
                    NSLog(@"支付成功");
                    [selfWeak updUserIntebyType];
                    [self jumpIndexLQ];
                }else {
                    
                    NSLog(@"支付失败：errCode=%d",errCode);
                    
                    NSString *errmsg = @"";
                    
                    switch (errCode) {
                        case WXErrCodeCommon:
                        {
                            errmsg = @"普通错误类型";
                        }
                            break;
                        case WXErrCodeUserCancel:
                        {
                            errmsg = @"支付取消";
                        }
                            break;
                        case WXErrCodeSentFail:
                        {
                            errmsg = @"发送失败";
                        }
                            break;
                        case WXErrCodeAuthDeny:
                        {
                            errmsg = @"授权失败";
                        }
                            break;
                        case WXErrCodeUnsupport:
                        {
                            errmsg = @"微信不支持";
                        }
                            break;
                        default:
                            break;
                    }
                    
                    [self showToastMsg:errmsg Duration:3.0];
                    
                    
                }
                
            }];
            
        });
       

        
    });

    
}



/**
 支付宝支付
 */
- (void)jumpToAliPay:(id)param {
    
    NSString *thirdPay = [param objectForKey:@"thirdpay"];
    if ([XYString isBlankString:thirdPay]) {
        return ;
    }
    @WeakObj(self)
    [APPWXPAYMANAGER doAlipayPayWithOrderString:thirdPay CallBack:^(NSDictionary *dict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"支付宝支付结果====%@",dict);
            
            NSInteger resultStatus = [dict[@"resultStatus"] integerValue];
            switch (resultStatus) {
                case 9000:
                {
                    //成功
                    [selfWeak updUserIntebyType];
                    [self jumpIndexLQ];
                    
                }
                    break;
                case 6001:
                {
                    [self showToastMsg:@"支付取消" Duration:3.0];
                    
                }
                    break;
                default:
                {
                    [self showToastMsg:dict[@"memo"] Duration:3.0];
                    
                }
                    break;
            }
            
        });
        
    }];
}


#pragma mark - 跳转邻趣首页
/**
 跳转邻趣首页
 */
- (void)jumpIndexLQ {
    NSLog(@"跳转邻趣首页");
    
    [USER_DEFAULT setObject:@"yes" forKey:DELETE_LIST_VALUE_OK];
    [USER_DEFAULT synchronize];
        [self showToastMsg:@"贴子发布成功!" Duration:3.0];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tagsTF resignFirstResponder];
}


#pragma mark ----- textField Delegate
- (IBAction)tagsTF:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    
    if(selectedRange == nil || selectedRange.empty) {
        
        switch (tf.tag) {
            case 13:
            {
                if(tf.text.length > 5) {
                    [self showToastMsg:@"不能超过5个字符" Duration:3.0];
                    tf.text=[tf.text substringToIndex:5];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
}


@end
