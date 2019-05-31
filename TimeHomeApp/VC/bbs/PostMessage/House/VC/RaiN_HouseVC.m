//
//  RaiN_HouseVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_HouseVC.h"
#import "PostingVC.h"
#import "BBSTabVC.h"

//----------图片相关库---------------
#import "TZImagePickerController.h"
//图片剪裁库
#import "TOCropViewController.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"
#import "AppSystemSetPresenters.h"
#import "ImageUitls.h"
//----------图片相关库---------------

//标签的cell
#import "RaiN_LabelCell.h"
#import "SelectCell.h"

#import "RaiN_LabelCustomCell.h"
#import "RaiN_LabelTitleCell.h"
#import "RaiN_AddLabelCell.h"
#import "THTags.h"
#import "UIButtonImageWithLable.h"

///红包弹框
#import "OrdinaryAddMoneyAlert.h"
///照片展示cell
#import "LayoutCell.h"
///标签的cell
#import "RaiN_LabelCell.h"
#import "SelectCell.h"

#import "ModeOfPaymentAlert.h"
///接口
#import "BBSMainPresenters.h"
#import "L_NewPointPresenters.h"
#import "RaiN_BalanceAlert.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppPayPresenter.h"

#import "L_BikeImageResourceModel.h"

///选择房产或车位
#import "RaiN_SelectHouseVC.h"
@interface RaiN_HouseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,TOCropViewControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SDPhotoBrowserDelegate>
{
    
    ///房产出让方式    0出租  1出售  默认出租
    NSString *transferType;
    
    ///是否装修         0是简单装修 1是拎包入住
    NSString *isDecorated;
    
    ///车位是否固定     1是 0否
    NSString *isPermanent;
    
    ///车位是否在地上  0是 1否
    NSString *isOnTheGround;
    
    ///有没有红包
    BOOL isHaveRedPacket;
    
    ///九宫格照片的flowLayout
    UICollectionViewFlowLayout *flowLayout;
    
    // MARK: -  标签相关数组
    NSArray *leftImages;
    NSArray *myTitles;
    
    ///供选择的标签
    NSMutableArray *forSelectTags;
    
    ///已选中的标签
    NSMutableArray *hasSelectedTags;
    
    ///是否在未保存是选中过标签
    BOOL isSelected;
    
    //图片ID数组
    NSMutableArray *picIDArr;
    NSMutableArray *temppPicIDArr;
    
    ///帖子展示天数
    NSString *showDays;
    
    ///红包总金额
    NSString *redallmoney;
    ///红包总个数
    NSString *redallcount;
    ///红包发放类型0 随机 1 定额
    NSString *redtheway;
    ///支付类型0 余额 101 支付宝 102 微信
    NSString *paytype;
    ///单个红包金额
    NSString *onemoney;
    
    ///小区ID
    NSString *areaId;
    ///小区名字
    NSString *areaname;
    ///房间名字；
    NSString *houseareaId;
    ///是否编辑帖子 0否 1是
    NSString *isEdit;
    
    ///展示放大图片
    NSMutableArray *imageUrlArr;
}
///展示照片九宫格背景view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBGHeight;
///相册选择器
@property (nonatomic, strong) TZImagePickerController *imagePickerVC;
///九宫格照片的数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
///标签展示数据源
//@property (nonatomic,strong)NSMutableArray *labelShowData;
//标签数据源
//@property (nonatomic,strong)NSMutableArray *labelData;
//@property (nonatomic,strong)NSMutableArray *temporaryArray;


/**
 控制标签的数组
 */
@property (nonatomic,strong)NSMutableArray *labesTempArr;
@property (nonatomic,strong)NSMutableArray *labesIndexArr;
@end

@implementation RaiN_HouseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([_isHouse isEqualToString:@"0"]) {
        //房产贴
        self.navigationItem.title = @"房产贴";
        _sellBGView.hidden = YES;
        _rentBGView.hidden = NO;
        _carportBgView.hidden = YES;
        _houseAddressLabel.text = @"选择房产地址";
        [_postHouseBtn setTitle:@"发 布 房 产" forState:UIControlStateNormal];
        
    }else if ([_isHouse isEqualToString:@"1"]) {
        //车位贴
        self.navigationItem.title = @"车位贴";
        _sellBGView.hidden = YES;
        _rentBGView.hidden = YES;
        _carportBgView.hidden = NO;
        _houseAddressLabel.text = @"选择车位地址";
        [_postHouseBtn setTitle:@"发 布 车 位" forState:UIControlStateNormal];
    }
    
    ///九宫格的高度  根据itemSize计算的
    _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*1;
        
    isEdit = @"0";//默认正常发帖
    redallmoney = @"0";//默认红包总金额为0
    onemoney = @"0";   //默认单个红包金额为0
    redallcount = @"0";//默认红包个数为0
    
    transferType = @"0";//默认房产出租
    isDecorated = @"1"; //默认拎包入住
    isPermanent = @"1";//默认固定车位
    isOnTheGround = @"0";//默认地上
    showDays = @"1";//默认展示1天

    isHaveRedPacket = NO;//没有红包
    [self sliderShowDays];//展示天数
    
    [self setUpUI];
    [self createData];
    [self createCollectionView];
    
    //判断是否是编辑跳转
    if ([_isCompile isEqualToString:@"0"]) {
        isEdit = @"1";
        [self getHouseList];
    }
}

    
#pragma mark ----- UI布局
- (void)setUpUI {
    
    [self isNoHaveMoney];
    //图片数量
    _showNumberBG.layer.cornerRadius = 7.5f;
    _tagsTFBgView.layer.borderColor = LINE_COLOR.CGColor;
    _tagsTFBgView.layer.borderWidth = 1.0f;
    //详情描述
    _placeHolder.delegate = self;
    _showTV.delegate = self;
    _showTV.tag = 901;
    
    /**
     键盘模式
     */
    /******  出租 *******/
    _roomTF.keyboardType = UIKeyboardTypeNumberPad;
    _hallTF.keyboardType = UIKeyboardTypeNumberPad;
    _toiletTF.keyboardType = UIKeyboardTypeNumberPad;
    _currentTF.keyboardType = UIKeyboardTypeNumberPad;
    _allFloorTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _rentTF.keyboardType = UIKeyboardTypeDecimalPad;
    _areaTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    _areaTF.delegate = self;
    _areaTF.tag = 566;
    _rentTF.delegate = self;
    _rentTF.tag = 567;
    
    _roomTF.tag = 570;
    _hallTF.tag = 571;
    _toiletTF.tag = 572;
    _allFloorTF.tag = 573;
    _currentTF.tag = 574;
    
    
    _sell_roomTF.tag = 575;
    _sell_hallTF.tag = 576;
    _sell_toiletTF.tag = 577;
    _sell_currentFloorTF.tag = 578;
    _sell_allFloorTF.tag = 579;
    
    /******  出售 *******/
    _sell_roomTF.keyboardType = UIKeyboardTypeNumberPad;
    _sell_hallTF.keyboardType = UIKeyboardTypeNumberPad;
    _sell_toiletTF.keyboardType = UIKeyboardTypeNumberPad;
    _sell_currentFloorTF.keyboardType = UIKeyboardTypeNumberPad;
    _sell_allFloorTF.keyboardType = UIKeyboardTypeNumberPad;
    
    
    _sell_areaTF.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    

    _sell_areaTF.delegate = self;
    _sell_areaTF.tag = 568;
    _priceTF.delegate = self;
    _priceTF.tag = 569;
    
    /**
     户型相关
     */
    /******  出租 *******/

    _roomTfBG.layer.borderWidth = 1.0f;
    _roomTfBG.layer.borderColor = LINE_COLOR.CGColor;
    

    _hallTfBg.layer.borderWidth = 1.0f;
    _hallTfBg.layer.borderColor = LINE_COLOR.CGColor;
    

    _toiletTfBG.layer.borderWidth = 1.0f;
    _toiletTfBG.layer.borderColor = LINE_COLOR.CGColor;
    
    
    /**
     楼层相关
     */

    _currentTFBg.layer.borderWidth = 1.0f;
    _currentTFBg.layer.borderColor = LINE_COLOR.CGColor;
    

    _allFloorTFBg.layer.borderWidth = 1.0f;
    _allFloorTFBg.layer.borderColor = LINE_COLOR.CGColor;
    
    /**
     租金和面积
     */

    _rentTFBg.layer.borderWidth = 1.0f;
    _rentTFBg.layer.borderColor = LINE_COLOR.CGColor;
    

    _areaTFBG.layer.borderWidth = 1.0f;
    _areaTFBG.layer.borderColor = LINE_COLOR.CGColor;
    
 
    
    /******  出售  *******/

    _sell_roomTFBg.layer.borderWidth = 1.0f;
    _sell_roomTFBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _sell_hallTFBg.layer.borderWidth = 1.0f;
    _sell_hallTFBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _sell_toiletTFBg.layer.borderWidth = 1.0f;
    _sell_toiletTFBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _sell_currentFloorTfBg.layer.borderWidth = 1.0f;
    _sell_currentFloorTfBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _sell_allFloorTfBg.layer.borderWidth = 1.0f;
    _sell_allFloorTfBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _sell_areaTFBg.layer.borderWidth = 1.0f;
    _sell_areaTFBg.layer.borderColor = LINE_COLOR.CGColor;
    
    _priceTfBg.layer.borderWidth = 1.0f;
    _priceTfBg.layer.borderColor = LINE_COLOR.CGColor;
    
    
    /**
     * 装修
     */
    if ([isDecorated isEqualToString:@"1"]) {
        
        [_nowStayBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
        [_simpleDecorationBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
        
    }else {
        
        [_nowStayBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
        [_simpleDecorationBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    }
    
   /**
    房产出让方式判断
    */
    if ([transferType isEqualToString:@"0"]) {
        //出租
        [_rentOutBtn setImage:[UIImage imageNamed:@"房产帖-选择按钮-红色"] forState:UIControlStateNormal];
        [_rentOutBtn setTitle:@" 出租" forState:UIControlStateNormal];
        
        [_sellBtn setImage:[UIImage imageNamed:@"房产帖-未选择按钮-红色"] forState:UIControlStateNormal];
        [_sellBtn setTitle:@" 出售" forState:UIControlStateNormal];
        
        _sellBGView.hidden = YES;
        _rentBGView.hidden = NO;
        
        
        
        
        /**
         车位
         */
        _carPortMoneyLabel.text = @"租       金";
        _unitLabel.text = @"元/月";
    }else {
        //出售
        [_rentOutBtn setImage:[UIImage imageNamed:@"房产帖-未选择按钮-红色"] forState:UIControlStateNormal];
        [_rentOutBtn setTitle:@" 出租" forState:UIControlStateNormal];
        
        [_sellBtn setImage:[UIImage imageNamed:@"房产帖-选择按钮-红色"] forState:UIControlStateNormal];
        [_sellBtn setTitle:@" 出售" forState:UIControlStateNormal];
        
        _sellBGView.hidden = NO;
        _rentBGView.hidden = YES;
        _carPortMoneyLabel.text = @"总       价";
        _unitLabel.text = @"元";
    }
    
    
    
    
    _labelTableView.delegate = self;
    _labelTableView.dataSource = self;
    [_labelTableView registerNib:[UINib nibWithNibName:@"SelectCell" bundle:nil] forCellReuseIdentifier:@"SelectCell"];
    
    
    
    /********      车位贴设置      ***********/
//    _carPortMoneyTfBG.layer.cornerRadius = 10.f;
    _carPortMoneyTfBG.layer.borderWidth = 1.0f;
    _carPortMoneyTfBG.layer.borderColor = LINE_COLOR.CGColor;
    
    
    _carPortMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    _carPortMoneyTF.delegate = self;
    _carPortMoneyTF.tag = 565;
    
    
    ///车位位置
    if ([isOnTheGround isEqualToString:@"0"]) {
        [_onTheGround setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
        [_undergroundBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    }else {
        [_onTheGround setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
        [_undergroundBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    }
    
    
    ////固定与否
    if ([isPermanent isEqualToString:@"1"]) {
        [_permanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
        [_noPermanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    }else {
        [_permanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
        [_noPermanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    }
    
    _tagsTF.delegate = self;
    _tagsTF.tag = 564;
    
    [self setTFTextColor];
}
#pragma mark -- 设置输入框字体颜色
- (void)setTFTextColor {
    
    _showTV.textColor = TEXT_COLOR;
    
    _roomTF.textColor = TEXT_COLOR;
    _hallTF.textColor = TEXT_COLOR;
    _toiletTF.textColor = TEXT_COLOR;
    _allFloorTF.textColor = TEXT_COLOR;
    _currentTF.textColor = TEXT_COLOR;
    _areaTF.textColor = TEXT_COLOR;
    _rentTF.textColor = TEXT_COLOR;
    
    
    _sell_roomTF.textColor = TEXT_COLOR;
    _sell_hallTF.textColor = TEXT_COLOR;
    _sell_toiletTF.textColor = TEXT_COLOR;
    _sell_areaTF.textColor = TEXT_COLOR;
    _sell_allFloorTF.textColor = TEXT_COLOR;
    _sell_currentFloorTF.textColor = TEXT_COLOR;
    _priceTF.textColor = TEXT_COLOR;
    
    _carPortMoneyTF.textColor = TEXT_COLOR;
}


- (void)sliderShowDays {
    /**
     展示天数
     */
    [_daysSlider setThumbImage:[UIImage imageNamed:@"车位房产-天数选择"] forState:UIControlStateNormal];
    /**
     @property(nonatomic,retain) UIImage *minimumValueImage;
     @property(nonatomic,retain) UIImage *maximumValueImage;
     */
    _daysSlider.minimumTrackTintColor = kNewRedColor;
    _daysSlider.continuous = YES;
    

    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:@"1天"];
    NSString *daysStr = @"1";
    [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, daysStr.length)];
    _shouSliderNumbers.attributedText = attribute;
}

#pragma mark -- 创建collectiuon and dataSource
- (void)createData {
    
    _dataSource = [[NSMutableArray alloc] init];
    temppPicIDArr = [[NSMutableArray alloc] init];
    picIDArr = [[NSMutableArray alloc] init];
    
    forSelectTags = [[NSMutableArray alloc]init];
    hasSelectedTags = [[NSMutableArray alloc]init];
    
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
    
    if (!_labesTempArr) {
        _labesTempArr = [[NSMutableArray alloc] init];
    }
    if (!_labesIndexArr) {
        _labesIndexArr = [[NSMutableArray alloc] init];
    }
    
    if (!imageUrlArr) {
        imageUrlArr = [[NSMutableArray alloc] init];
    }
}

- (void)createCollectionView {
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView.collectionViewLayout = flowLayout;
    
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 16 - 61 - 14)/3, (SCREEN_WIDTH - 16 - 61 - 14)/3);
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 8;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.tag = 21;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"LayoutCell" bundle:nil] forCellWithReuseIdentifier:@"LayoutCell"];
    
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
            
        }else {
            
            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:temppPicIDArr[indexPath.row][@"picurl"]] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
        }
    }
    
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
    
    
    return [NSURL URLWithString:imageUrlArr[index]];
    
    
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
                _labelTableViewHeight.constant = WidthSpace(105)*2 + [cell configureHeightForCellTagsArray:forSelectTags]+ 20 +40 + 10;
                return 40;
                
            }else {
                _labelTableViewHeight.constant = WidthSpace(105)*2 + [cell configureHeightForCellTagsArray:forSelectTags]+ 20 +[cell configureHeightForCellTagsArray:hasSelectedTags]+20 + 10;
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
                [_labesIndexArr addObject:[NSString stringWithFormat:@"%ld",[forSelectTags indexOfObject:forSelectTags[selectIndex]]]];
                
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


#pragma mark ------ 按钮点击事件

/**
 选择房产
 */
- (IBAction)houseAddress:(id)sender {
    [_tagsTF resignFirstResponder];
    RaiN_SelectHouseVC *selectHouse = [[RaiN_SelectHouseVC alloc] init];
    selectHouse.isHouse = _isHouse;
    selectHouse.eventCallBack = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
        _houseAddressLabel.text = [NSString stringWithFormat:@"%@ %@",data[@"communityname"],data[@"houseareaname"]];
       
        areaId = (NSString *)data[@"communityid"];    //社区ID
        areaname = (NSString *)data[@"communityname"];//小区名字
        houseareaId = (NSString *)data[@"houseareaid"];
    };
    [self.navigationController pushViewController:selectHouse animated:YES];
}
/**
 出租
 */
- (IBAction)rentOutClick:(id)sender {
    if ([transferType isEqualToString:@"0"]) {
        return;
    }
    transferType = @"0";
    _sellBGView.hidden = YES;
    _rentBGView.hidden = NO;
    [self setUpUI];
}

/**
 出售
 */
- (IBAction)sellClick:(id)sender {
    if (![transferType isEqualToString:@"0"]) {
        return;
    }
    transferType = @"1";
    _sellBGView.hidden = NO;
    _rentBGView.hidden = YES;
    [self setUpUI];
}
/**
 添加图片
 */
- (IBAction)addPicClick:(id)sender {
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
                                [imageUrlArr addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                                [picIDArr addObject:picID];
                                [_dataSource addObject:image];
                                _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                                
                                if (_dataSource.count > 3 && _dataSource.count <= 6) {
                                    _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2;
                                }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
                                    _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3;
                                }else if(_dataSource.count > 9) {
                                    _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4;
                                }else {
                                    _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*1;
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

/**
 删除图片按钮
 */
- (void)deletePhotos:(UIButton *)sender {
    [_dataSource removeObjectAtIndex:sender.tag - 100];
    [picIDArr removeObjectAtIndex:sender.tag - 100];
    [imageUrlArr removeObjectAtIndex:sender.tag - 100];
    _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
    if (_dataSource.count > 3 && _dataSource.count <= 6) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2;
    }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3;
    }else if(_dataSource.count > 9) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4;
    }else {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*1;
    }
    [_collectionView reloadData];
}



/**
 简单装修
 */
- (IBAction)simpleDecorationClick:(id)sender {
    [_nowStayBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isDecorated isEqualToString:@"0"]) {
        return;
    }
    [_simpleDecorationBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    
    isDecorated = @"0";
}

/**
 拎包入住
 */
- (IBAction)nowStay:(id)sender {
    [_simpleDecorationBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isDecorated isEqualToString:@"1"]) {
        return;
    }
    [_nowStayBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    
    isDecorated = @"1";
}

/**
 添加红包
 */
- (IBAction)addmoneyClick:(id)sender {
    
    //普通帖
    [_tagsTF resignFirstResponder];
    OrdinaryAddMoneyAlert *ordinary = [OrdinaryAddMoneyAlert shareAddMoneyVC];
    [ordinary show:self];
    @WeakObj(self)
    ordinary.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
        if (index == 0) {
            
            
            if ([data[2] isEqualToString:@"0"]) {
                //随机金额 展示 总金额/个数
                _moneyShowLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue],data[0]];
                
                redallmoney = data[1];
                redallcount = data[0];
                redtheway = @"0";
                onemoney = @"0";
            }else {
                //固定金额
                
                _moneyShowLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue] * [data[0] floatValue],data[0]];
                redallmoney = [NSString stringWithFormat:@"%f",[data[1] floatValue] * [data[0] floatValue]];
                redallcount = data[0];
                redtheway = @"1";
                onemoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue]];
                
            }
            [selfWeak isHaveMoney];
            
        }
    };
    
}

/**
 修改红包
 */
- (IBAction)changeMoneyClick:(id)sender {
    [_tagsTF resignFirstResponder];
    //普通帖
    OrdinaryAddMoneyAlert *ordinary = [OrdinaryAddMoneyAlert shareAddMoneyVC];
    if ([redtheway integerValue] == 0 ) {
        ordinary.isRandom = @"0";//随机
        ordinary.theNumberTF.text = redallcount;
        ordinary.theMoneyTF.text = [NSString stringWithFormat:@"%ld",[redallmoney integerValue]];
    }else {
        ordinary.isRandom = @"1";//随机
        ordinary.theNumberTF.text = [NSString stringWithFormat:@"%ld",[redallcount integerValue]];
        ordinary.theMoneyTF.text = [NSString stringWithFormat:@"%ld",[onemoney integerValue]];
    }
    [ordinary show:self];
    @WeakObj(self)
    ordinary.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
        if (index == 0) {
            
            
            if ([data[2] isEqualToString:@"0"]) {
                //随机金额 展示 总金额/个数
                _moneyShowLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue],data[0]];
                
                redallmoney = data[1];
                redallcount = data[0];
                redtheway = @"0";
                onemoney = @"0";
            }else {
                //固定金额
                
                _moneyShowLabel.text = [NSString stringWithFormat:@"￥%.2f/%@个",(CGFloat)[data[1] floatValue] * [data[0] floatValue],data[0]];
                redallmoney = [NSString stringWithFormat:@"%f",[data[1] floatValue] * [data[0] floatValue]];
                redallcount = data[0];
                redtheway = @"1";
                onemoney = [NSString stringWithFormat:@"%.2f",[data[1] floatValue]];
                
            }
            [selfWeak isHaveMoney];
            
        }
    };

    
}

/**
 清空红包
 */
- (IBAction)clearClick:(id)sender {
    [_tagsTF resignFirstResponder];
    [self isNoHaveMoney];
}


/**
 发布房产
 */
- (IBAction)postHouseClick:(id)sender {
    
    [_tagsTF resignFirstResponder];
    
    if ([_isHouse isEqualToString:@"0"]) {
        //房产帖
        if ([_houseAddressLabel.text isEqualToString:@"选择房产地址"]) {
            [self showToastMsg:@"请选择房产地址" Duration:3.0f];
            return;
        }
        if (_dataSource.count <= 0) {
            [self showToastMsg:@"请添加图片" Duration:3.0f];
            return;
        }
        
        if ([_currentTF.text integerValue] > [_allFloorTF.text integerValue]) {
            [self showToastMsg:@"请输入正确的楼层信息" Duration:3.0f];
            return;
        }
        if ([_sell_currentFloorTF.text integerValue] > [_sell_allFloorTF.text integerValue]) {
            [self showToastMsg:@"请输入正确的楼层信息" Duration:3.0f];
            return;
        }
        
        if ([transferType isEqualToString:@"0"]) {
            ///////出租
            if ([XYString isBlankString:_roomTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_hallTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_toiletTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_currentTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_allFloorTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_rentTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_areaTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_showTV.text]) {
                [self showToastMsg:@"房产描述不能为空" Duration:3.0f];
                return;
            }
            
            

            if (isHaveRedPacket == YES) {
                [self alertRedPacketForHouseRentOut];
            }else {
                //接口发帖---房产出租
                [self postRentOutHouseWithType:@""];
            }
            

        }else {
            /////////出售
            if ([XYString isBlankString:_sell_roomTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_sell_hallTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_sell_toiletTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_sell_areaTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_sell_currentFloorTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_sell_allFloorTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_priceTF.text]) {
                [self showToastMsg:@"请填写完整的房产信息" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_showTV.text]) {
                [self showToastMsg:@"房产描述不能为空" Duration:3.0f];
                return;
            }
            
            if (isHaveRedPacket == YES) {
                [self alertRedPacketForHouseSell];
            }else {
                //接口发帖 --- 房产出售
                [self postSellHouseWithType:@""];
            }
            
        }
        
        
        
        
    }else {
        //车位贴
        if ([_houseAddressLabel.text isEqualToString:@"选择车位地址"]) {
            [self showToastMsg:@"请选择车位地址" Duration:3.0f];
            return;
        }
        if ([transferType isEqualToString:@"0"]) {
            ///车位出租
            if ([XYString isBlankString:_carPortMoneyTF.text]) {
                [self showToastMsg:@"价格不能为空" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_showTV.text]) {
                [self showToastMsg:@"车位描述不能为空" Duration:3.0f];
                return;
            }
            
            if (isHaveRedPacket == YES) {
                [self alertRedPacketForCarPortRentOut];
            }else {
                //接口发帖 --- 车位出租
                [self postRentOutCarPortWithType:@""];
            }
        }else {
            ///车位出售
            
            if ([XYString isBlankString:_carPortMoneyTF.text]) {
                [self showToastMsg:@"价格不能为空" Duration:3.0f];
                return;
            }
            if ([XYString isBlankString:_showTV.text]) {
                [self showToastMsg:@"车位描述不能为空" Duration:3.0f];
                return;
            }
            
            if (isHaveRedPacket == YES) {
                [self alertRedPacketForCarPortSell];
            }else {
                //接口发帖 --- 车位出售
                [self postSellCarPortWithType:@""];
            }
            
        }
        
        
    }
    
}

/**
 固定车位
*/
- (IBAction)permanentClick:(id)sender {
    
    [_noPermanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isPermanent isEqualToString:@"1"]) {
        return;
    }
    [_permanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    isPermanent = @"1";//默认固定车位
}
/**
 不固定
 */
- (IBAction)noPermanentClick:(id)sender {
    [_permanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isPermanent isEqualToString:@"0"]) {
        return;
    }
    [_noPermanentBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    isPermanent = @"0";
}

/**
 地上车位
 */
- (IBAction)onTheGroundClick:(id)sender {
    [_undergroundBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isOnTheGround isEqualToString:@"0"]) {
        return;
    }
    [_onTheGround setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    isOnTheGround = @"0";
}

/**
 地下车位
 */
- (IBAction)underGroundClick:(id)sender {
    [_onTheGround setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    if ([isOnTheGround isEqualToString:@"1"]) {
        return;
    }
    [_undergroundBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
    isOnTheGround = @"1";
}




#pragma mark ------ slider事件
- (IBAction)daysCHange:(id)sender {
    UISlider *slider = sender;
    showDays = [NSString stringWithFormat:@"%d",(int)slider.value];
    NSString *daysStr = [NSString stringWithFormat:@"%d",(int)slider.value];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",daysStr]];
    [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, daysStr.length)];
    
    _shouSliderNumbers.attributedText = attribute;
    
}


/**
 添加标签
 */
- (IBAction)addTagsBtnCklick:(id)sender {
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


#pragma mark ------ 添加奖励金钱UI相关
- (void)isHaveMoney {
    
    _redPacketShowLabel.text = @"红包";
    _redPacketImage.image = [UIImage imageNamed:@"邻趣-首页-红包图标"];
    _moneyShowLabel.hidden = NO;
    _addRedPacket.hidden = YES;
    _clearBtn.hidden = NO;
    isHaveRedPacket = YES;
    _changeMoneyBtn.hidden = NO;
}

- (void)isNoHaveMoney {
    
    _redPacketImage.image = [UIImage imageNamed:@"邻趣-发布-红包图标"];
    _redPacketShowLabel.text = @"发 红包 奖励";
    _moneyShowLabel.text = @"";
    _moneyShowLabel.hidden = YES;
    _addRedPacket.hidden = NO;
    _clearBtn.hidden = YES;
    _changeMoneyBtn.hidden = YES;
    isHaveRedPacket = NO;
}

#pragma mark ----- textView

- (void)textViewDidEndEditing:(UITextView *)textView {

    if (textView.text.length <= 0) {
        _placeHolder.hidden = NO;
        _showTV.backgroundColor = [UIColor clearColor];
    }else {
        _placeHolder.hidden = YES;
        _showTV.backgroundColor = [UIColor whiteColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHolder.hidden = YES;
    _showTV.backgroundColor = [UIColor whiteColor];
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    
    NSInteger existTextNum = nsTextContent.length;
    NSLog(@"%ld",existTextNum);
    if (existTextNum >= 500)
    {
        NSString *tempStr = [nsTextContent substringWithRange:NSMakeRange(nsTextContent.length-2, 2)];
        if ([self stringContainsEmoji:tempStr]) {
            
            [self showToastMsg:@"最多可输入500个字" Duration:3.0f];
            NSString *s = [nsTextContent substringToIndex:499];
            [textView setText:s];
        }else {
            [self showToastMsg:@"最多输入500字" Duration:3.0f];
            NSString *s = [nsTextContent substringToIndex:500];
            [textView setText:s];
        }
    }
    
}


#pragma mark --- textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 565 || textField.tag == 566 ||textField.tag == 567 || textField.tag == 568 || textField.tag == 569) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger flag=0;
        const NSInteger limited = 2;
        for (NSInteger i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    
                    [self showToastMsg:@"小数点后只能保留2位" Duration:3.0f];
                    return NO;
                }
                
                break;
            }
            flag++;
        }
    }
    return YES;
}


#pragma mark ------ 照片选择器以及编辑相关
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
    
//    _imagePickerVC = nil;
    
    
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
                    [imageUrlArr addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                    [picIDArr addObject:picID];
                    [_dataSource addObject:image];
                    _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                    
                    if (_dataSource.count > 3 && _dataSource.count <= 6) {
                        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2;
                    }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
                        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3;
                    }else if(_dataSource.count > 9) {
                        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4;
                    }else {
                        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*1;
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

#pragma mark - Cropper Delegate - 编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
}
// MARK: - 取消编辑图片
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    [cropViewController dismissAnimatedFromParentViewController:self toFrame:CGRectMake(self.view.centerX_sd, self.view.centerY_sd, 0, 0) completion:nil];
    
}





#pragma mark --------------   分情况弹窗问题
//////房产有红包出售
- (void)alertRedPacketForHouseSell {
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
                [selfWeak postSellHouseWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信");
                [selfWeak postSellHouseWithType:@"102"];
            }
                break;
            case 2:
            {
                NSLog(@"余额");
                //余额
                
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                redPacket.needPayStr = redallmoney;
                [redPacket show:self];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    //调用余额支付
                   [selfWeak postSellHouseWithType:@"0"];
                };
            }
                break;
                
            default:
                break;
        }
    };

}



//////房产有红包出租
- (void)alertRedPacketForHouseRentOut {
    ModeOfPaymentAlert *payment = [ModeOfPaymentAlert sharePaymentVC];
    payment.moneyStr = redallmoney;
    [payment show:self];
    @WeakObj(self)
    payment.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
        switch (index) {
            case 0:
            {
                //支付宝
                NSLog(@"支付宝 ==== 101");
                [selfWeak postRentOutHouseWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信 ===== 102");
                [selfWeak postRentOutHouseWithType:@"102"];
                
            }
                break;
            case 2:
            {
                NSLog(@"余额 ======= 0");
                //余额
                
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                redallmoney = [XYString IsNotNull:redallmoney];
                redPacket.needPayStr = redallmoney;
                [redPacket show:self];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    //调用余额支付
                    [selfWeak postRentOutHouseWithType:@"0"];
                };
            }
                break;
                
            default:
                break;
        }
    };
    
}




//////车位有红包出售
- (void)alertRedPacketForCarPortSell {
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
                [selfWeak postSellCarPortWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信");
                [selfWeak postSellCarPortWithType:@"102"];
            }
                break;
            case 2:
            {
                NSLog(@"余额");
                //余额
                
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                redallmoney = [XYString IsNotNull:redallmoney];
                redPacket.needPayStr = redallmoney;
                [redPacket show:selfWeak];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    //调用余额支付
                    [selfWeak postSellCarPortWithType:@"0"];
                };
            }
                break;
                
            default:
                break;
        }
    };
}


//////车位有红包出租
- (void)alertRedPacketForCarPortRentOut {
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
                [selfWeak postRentOutCarPortWithType:@"101"];
            }
                break;
            case 1:
            {
                //微信
                NSLog(@"微信");
                [selfWeak postRentOutCarPortWithType:@"102"];
            }
                break;
            case 2:
            {
                NSLog(@"余额");
                //余额
                
                //余额
                RaiN_BalanceAlert *redPacket = [RaiN_BalanceAlert shareshowBalanceVC];
                
                redPacket.needPayStr = redallmoney;
                [redPacket show:selfWeak];
                
                redPacket.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
                    //调用余额支付
                    [selfWeak postRentOutCarPortWithType:@"0"];
                };
            }
                break;
                
            default:
                break;
        }
    };
    
}


#pragma mark ----------   数据请求

#pragma mark -------------  房产
/**
 房产贴出租
 */
- (void)postRentOutHouseWithType:(NSString *)type{
    
    
    if (isHaveRedPacket == YES) {
        /********     有红包     ********/

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
        _postID  = [XYString IsNotNull:_postID];
        NSString *str = @"";
        if ([isDecorated isEqualToString:@"0"]) {
            //简单装修
            str = @"2";
        }else {
            str = @"1";
        }

        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"11" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"0" andPaytype:type andRedallmoney:redallmoney andRedallcount:redallcount andRedtheway:redtheway andTagsname:tagsStr andBedroom:_roomTF.text andLivingroom:_hallTF.text andToilef:_toiletTF.text andArea:_areaTF.text andAllfloornum:_allFloorTF.text andFloornum:_currentTF.text andPrice:_rentTF.text andDecorattype:str andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID  andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode){
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    
                    if ([type isEqualToString:@"102"]) {
                        //微信
                        [selfWeak jumpToWXPay:data[@"map"]];
                        
                    }else if([type isEqualToString:@"101"]) {
                        //支付宝
                        [selfWeak jumpToAliPay:data[@"map"]];
                    }else {
                        [self updUserIntebyType];
                        if ([_isCompile isEqualToString:@"0"]) {
                            [self refreshEdit];
                        }else {
                            [self jumpIndexLQ];
                        }

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
        
        
        
    }else {
        
        /********     没有红包     ********/
        
        /**
         房产帖
         接口域名/housepost/addhousepost
         type	是	10 房产出售 11 房产出租30 车位出售 31 车位出租
         posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
         title	是	标题没有则为空
         content	是	描述
         picids	是	照片资源表ID,逗号分隔存储
         redtype	是	0 红包1 粉包 -1 无红包
         paytype	是	支付类型0 余额 101 支付宝 102 微信
         redallmoney	是	红包总金额
         redallcount	是	红包总个数
         redtheway	是	红包发放类型0 随机 1 定额
         tagsname	是	标签名称,多个则逗号拼接
         bedroom	是	卧室数
         livingroom	是	客厅数
         toilef	是	卫数
         area	是	面积
         allfloornum	是	总楼层
         floornum	是	楼层
         price	是	单价
         decorattype	是	装修程度：1领包 2 简装
         underground	是	是否地下车位
         fixed	是	是否固定车位
         showday	是	展示天数
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
        _postID  = [XYString IsNotNull:_postID];
        
        NSString *str = @"";
        if ([isDecorated isEqualToString:@"0"]) {
            //简单装修
            str = @"2";
        }else {
            str = @"1";
        }
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"11" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"-1" andTagsname:tagsStr andBedroom:_roomTF.text andLivingroom:_hallTF.text andToilef:_toiletTF.text andArea:_areaTF.text andAllfloornum:_allFloorTF.text andFloornum:_currentTF.text andPrice:_rentTF.text andDecorattype:str andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                   
                    [self updUserIntebyType];
                    
                    if ([_isCompile isEqualToString:@"0"]) {
                        [self refreshEdit];
                    }else {
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
}


/**
 房产贴出售
 */
- (void)postSellHouseWithType:(NSString *)type{
    if (isHaveRedPacket == YES) {
        /********     有红包     ********/
        
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
        _postID  = [XYString IsNotNull:_postID];
        
        NSString *str = @"";
        if ([isDecorated isEqualToString:@"0"]) {
            //简单装修
            str = @"2";
        }else {
            str = @"1";
        }
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"10" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"0" andPaytype:type andRedallmoney:redallmoney andRedallcount:redallcount andRedtheway:redtheway andTagsname:tagsStr andBedroom:_sell_roomTF.text andLivingroom:_sell_hallTF.text andToilef:_sell_toiletTF.text andArea:_sell_areaTF.text andAllfloornum:_sell_allFloorTF.text andFloornum:_sell_currentFloorTF.text andPrice:_priceTF.text andDecorattype:str andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
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
                        [self updUserIntebyType];
                        if ([_isCompile isEqualToString:@"0"]) {
                            [self refreshEdit];
                        }else {
                            [self jumpIndexLQ];
                        }

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
        
        
        
        
    }else {
        
        /********     没有红包     ********/
        
        /**
         房产帖
         接口域名/housepost/addhousepost
         type	是	10 房产出售 11 房产出租30 车位出售 31 车位出租
         posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
         title	是	标题没有则为空
         content	是	描述
         picids	是	照片资源表ID,逗号分隔存储
         redtype	是	0 红包1 粉包 -1 无红包
         paytype	是	支付类型0 余额 101 支付宝 102 微信
         redallmoney	是	红包总金额
         redallcount	是	红包总个数
         redtheway	是	红包发放类型0 随机 1 定额
         tagsname	是	标签名称,多个则逗号拼接
         bedroom	是	卧室数
         livingroom	是	客厅数
         toilef	是	卫数
         area	是	面积
         allfloornum	是	总楼层
         floornum	是	楼层
         price	是	单价
         decorattype	是	装修程度：1领包 2 简装
         underground	是	是否地下车位
         fixed	是	是否固定车位
         showday	是	展示天数
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
        _postID  = [XYString IsNotNull:_postID];
        
        NSString *str = @"";
        if ([isDecorated isEqualToString:@"0"]) {
            //简单装修
            str = @"2";
        }else {
            str = @"1";
        }
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"10" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"-1" andTagsname:tagsStr andBedroom:_sell_roomTF.text andLivingroom:_sell_hallTF.text andToilef:_sell_toiletTF.text andArea:_sell_areaTF.text andAllfloornum:_sell_allFloorTF.text andFloornum:_sell_currentFloorTF.text andPrice:_priceTF.text andDecorattype:str andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    
                    [self updUserIntebyType];
                    
                    if ([_isCompile isEqualToString:@"0"]) {
                        [self refreshEdit];
                    }else {
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
    
}




#pragma mark -------------  车位

/**
 车位贴出租
 */
- (void)postRentOutCarPortWithType:(NSString *)type{
    if (isHaveRedPacket == YES) {
        /********     有红包     ********/
        
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
        _postID  = [XYString IsNotNull:_postID];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"31" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"0" andPaytype:type andRedallmoney:redallmoney andRedallcount:redallcount andRedtheway:redtheway andTagsname:tagsStr andBedroom:_roomTF.text andLivingroom:_hallTF.text andToilef:_toiletTF.text andArea:_areaTF.text andAllfloornum:_allFloorTF.text andFloornum:_currentTF.text andPrice:_carPortMoneyTF.text andDecorattype:isDecorated andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
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
                        
                        [self updUserIntebyType];
                        if ([_isCompile isEqualToString:@"0"]) {
                            [self refreshEdit];
                        }else {
                            [self jumpIndexLQ];
                        }

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
        
        
        
    }else {
        
        /********     没有红包     ********/
        
        /**
         房产帖
         接口域名/housepost/addhousepost
         type	是	10 房产出售 11 房产出租30 车位出售 31 车位出租
         posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
         title	是	标题没有则为空
         content	是	描述
         picids	是	照片资源表ID,逗号分隔存储
         redtype	是	0 红包1 粉包 -1 无红包
         paytype	是	支付类型0 余额 101 支付宝 102 微信
         redallmoney	是	红包总金额
         redallcount	是	红包总个数
         redtheway	是	红包发放类型0 随机 1 定额
         tagsname	是	标签名称,多个则逗号拼接
         bedroom	是	卧室数
         livingroom	是	客厅数
         toilef	是	卫数
         area	是	面积
         allfloornum	是	总楼层
         floornum	是	楼层
         price	是	单价
         decorattype	是	装修程度：1领包 2 简装
         underground	是	是否地下车位
         fixed	是	是否固定车位
         showday	是	展示天数
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
        _postID  = [XYString IsNotNull:_postID];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"31" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"-1" andTagsname:tagsStr andBedroom:_roomTF.text andLivingroom:_hallTF.text andToilef:_toiletTF.text andArea:_areaTF.text andAllfloornum:_allFloorTF.text andFloornum:_currentTF.text andPrice:_carPortMoneyTF.text andDecorattype:isDecorated andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    
                    [self updUserIntebyType];
                    
                    if ([_isCompile isEqualToString:@"0"]) {
                        [self refreshEdit];
                    }else {
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
}


/**
 车位贴出售
 */
- (void)postSellCarPortWithType:(NSString *)type{
    if (isHaveRedPacket == YES) {
        
        /********     有红包     ********/
        
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
        _postID  = [XYString IsNotNull:_postID];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"30" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"0" andPaytype:type andRedallmoney:redallmoney andRedallcount:redallcount andRedtheway:redtheway andTagsname:tagsStr andBedroom:_sell_roomTF.text andLivingroom:_sell_hallTF.text andToilef:_sell_toiletTF.text andArea:_sell_areaTF.text andAllfloornum:_sell_allFloorTF.text andFloornum:_sell_currentFloorTF.text andPrice:_carPortMoneyTF.text andDecorattype:isDecorated andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    
                    [self updUserIntebyType];
                    if ([type isEqualToString:@"102"]) {
                        //微信
                        [selfWeak jumpToWXPay:data[@"map"]];
                    }else if([type isEqualToString:@"101"]) {
                        [selfWeak jumpToAliPay:data[@"map"]];
                    }else {
                        //余额
                        [self updUserIntebyType];
                        if ([_isCompile isEqualToString:@"0"]) {
                            [self refreshEdit];
                        }else {
                            [self jumpIndexLQ];
                        }

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
        
        
        
        
        
    }else {
        
        /********     没有红包     ********/
        
        /**
         房产帖
         接口域名/housepost/addhousepost
         type	是	10 房产出售 11 房产出租30 车位出售 31 车位出租
         posttype	是	发布帖子类型 0 普通帖子 1 商品帖子 2 投票 3 问答 4 房产
         title	是	标题没有则为空
         content	是	描述
         picids	是	照片资源表ID,逗号分隔存储
         redtype	是	0 红包1 粉包 -1 无红包
         paytype	是	支付类型0 余额 101 支付宝 102 微信
         redallmoney	是	红包总金额
         redallcount	是	红包总个数
         redtheway	是	红包发放类型0 随机 1 定额
         tagsname	是	标签名称,多个则逗号拼接
         bedroom	是	卧室数
         livingroom	是	客厅数
         toilef	是	卫数
         area	是	面积
         allfloornum	是	总楼层
         floornum	是	楼层
         price	是	单价
         decorattype	是	装修程度：1领包 2 简装
         underground	是	是否地下车位
         fixed	是	是否固定车位
         showday	是	展示天数
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
        _postID  = [XYString IsNotNull:_postID];
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters postHousePosts:@"30" andPosttype:@"4" andTitle:@"" andContent:_showTV.text andPicids:picIDStr andRedtype:@"-1" andPaytype:@"-1" andRedallmoney:@"0" andRedallcount:@"0" andRedtheway:@"-1" andTagsname:tagsStr andBedroom:_sell_roomTF.text andLivingroom:_sell_hallTF.text andToilef:_sell_toiletTF.text andArea:_sell_areaTF.text andAllfloornum:_sell_allFloorTF.text andFloornum:_sell_currentFloorTF.text andPrice:_carPortMoneyTF.text andDecorattype:isDecorated andUnderground:isOnTheGround andFixed:isPermanent andShowday:showDays andHouseareacommunityid:areaId andHouseareacommunityname:areaname andHouseareaid:houseareaId andIsedit:isEdit andPostid:_postID andOnemoney:onemoney updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    [self updUserIntebyType];
                    if ([_isCompile isEqualToString:@"0"]) {
                        [self refreshEdit];
                    }else {
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
    
    @WeakObj(self);
    [APPWXPAYMANAGER usPay_payWithPayReq:req callBack:^(enum WXErrCode errCode) {
        
        NSLog(@"errorCode = %zd",errCode);
        if (errCode == WXSuccess) {
            NSLog(@"支付成功");
            [self updUserIntebyType];
            if ([_isCompile isEqualToString:@"0"]) {
                [selfWeak refreshEdit];
            }else {
                [selfWeak jumpIndexLQ];
            }

            
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
        
        NSLog(@"支付宝支付结果====%@",dict);
        
        NSInteger resultStatus = [dict[@"resultStatus"] integerValue];
        switch (resultStatus) {
            case 9000:
            {
                //成功
                [self updUserIntebyType];
                if ([_isCompile isEqualToString:@"0"]) {
                    [selfWeak refreshEdit];
                }else {
                    [selfWeak jumpIndexLQ];
                }

                
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
    }];
    
}






#pragma mark ---- 编辑页面跳转时UI赋值等操作

/**
 根据内容调整九宫格的高度
 */
- (void)setCollectionHeight {
    if (_dataSource.count > 3 && _dataSource.count <= 6) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*2;
    }else if(_dataSource.count > 6 && _dataSource.count<= 9) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*3;
    }else if(_dataSource.count > 9) {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*4;
    }else {
        _collectionBGHeight.constant = ((SCREEN_WIDTH - 16 - 61 - 14)/3 + 8)*1;
    }
}


#pragma mark ----  编辑房产或者车位
/**
 编辑页面跳转过来时调用获得房产贴详情接口
 */
- (void)getHouseList {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters getPostUpDateInfo:_postID AndUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
                NSDictionary *mapDic = data[@"map"];
                NSString *typeStr = mapDic[@"housetype"];
                
                
                switch ([typeStr integerValue]) {
                    case 10:
                    {
                        // 10 房产出售
                        self.navigationItem.title = @"房产贴";
                        _carportBgView.hidden = YES;
                        _sellBGView.hidden = NO;
                        _rentBGView.hidden = YES;
                        
                        ///小区ID小区名字等
                        areaId = [NSString stringWithFormat:@"%@",mapDic[@"communityid"]];
                        areaname = [NSString stringWithFormat:@"%@",mapDic[@"communityname"]];
                        houseareaId = [NSString stringWithFormat:@"%@",mapDic[@"houseareaid"]];
                        _houseAddressLabel.text = [NSString stringWithFormat:@"%@ %@",mapDic[@"communityname"],mapDic[@"houseareaname"]];
                        
                        
                        ///出让方式
                        transferType = @"1";//出售
                        
                        ///图片
                        [temppPicIDArr removeAllObjects];
                        temppPicIDArr = mapDic[@"piclist"];
                        _dataSource = mapDic[@"piclist"];
                        _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                        
                        for (int i = 0; i < temppPicIDArr.count; i++) {
                            [picIDArr addObject:temppPicIDArr[i][@"picid"]];
                            [imageUrlArr addObject:temppPicIDArr[i][@"picurl"]];
                        }
                        [self setCollectionHeight];
                        
                        ///室厅卫
                        _sell_roomTF.text = [NSString stringWithFormat:@"%@",mapDic[@"bedroom"]];
                        _sell_hallTF.text = [NSString stringWithFormat:@"%@",mapDic[@"livingroom"]];
                        _sell_toiletTF.text = [NSString stringWithFormat:@"%@",mapDic[@"toilef"]];
                        
                        ///楼层租金面积
                        _sell_areaTF.text = [NSString stringWithFormat:@"%@",mapDic[@"area"]];
                        _sell_allFloorTF.text = [NSString stringWithFormat:@"%@",mapDic[@"allfloornum"]];
                        _sell_currentFloorTF.text = [NSString stringWithFormat:@"%@",mapDic[@"floornum"]];
                        _priceTF.text = [NSString stringWithFormat:@"%@",mapDic[@"price"]];
                        
                        ///内容
                        _showTV.text = [NSString stringWithFormat:@"%@",mapDic[@"content"]];
                        _placeHolder.hidden = YES;
                        _showTV.backgroundColor = [UIColor whiteColor];
                        
                        ///红包
                        [selfWeak isNoHaveMoney];//编辑情况红包
                        
                        ///展示天数
                        NSString *daysStr = [NSString stringWithFormat:@"%@",mapDic[@"showday"]];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",mapDic[@"showday"]]];
                        [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, [NSString stringWithFormat:@"%@",mapDic[@"showday"]].length)];
                        
                        _shouSliderNumbers.attributedText = attribute;
                        [_daysSlider setValue:[daysStr floatValue]];
                        showDays = [NSString stringWithFormat:@"%@",daysStr];
                        
                        ///标签
                        NSString *tagStr = [NSString stringWithFormat:@"%@",mapDic[@"tagsname"]];
                        
                        if (tagStr.length > 0) {
                            
                            NSString *mySubStr =  [tagStr substringToIndex:tagStr.length - 1];
                            NSArray *tagsArr = [mySubStr componentsSeparatedByString:@","];
                            
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            for (int i = 0; i < tagsArr.count; i++) {
                                [tempArr addObject:@{@"name":tagsArr[i]}];
                                
                            }
                            hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:tempArr];
                            
                            
                            for (int i = 0; i < hasSelectedTags.count; i++) {
                                
                                for (int j = 0; j < forSelectTags.count; j++) {
                                    
                                    THTags *oneTag = [hasSelectedTags objectAtIndex:i];
                                    THTags *forSeleTag = [forSelectTags objectAtIndex:j];
                                    if ([oneTag.name isEqualToString:forSeleTag.name]) {
                                        [_labesTempArr addObject:forSeleTag];
                                        [forSelectTags removeObject:forSeleTag];
                                    }
                                }
                                
                            }
                            
                        }
                        [_labelTableView reloadData];
                        [_collectionView reloadData];
                        [selfWeak setUpUI];
                    }
                        break;
                        
                        
                        
                    case 11:
                    {
                        /*
                         11 房产出租
                         */
                        self.navigationItem.title = @"房产贴";
                        _carportBgView.hidden = YES;
                        _sellBGView.hidden = YES;
                        _rentBGView.hidden = NO;
                        
                        
                        ///小区ID小区名字等
                        areaId = [NSString stringWithFormat:@"%@",mapDic[@"communityid"]];
                        areaname = [NSString stringWithFormat:@"%@",mapDic[@"communityname"]];
                        houseareaId = [NSString stringWithFormat:@"%@",mapDic[@"houseareaid"]];
                        _houseAddressLabel.text = [NSString stringWithFormat:@"%@ %@",mapDic[@"communityname"],mapDic[@"houseareaname"]];
                        
                        
                        ///出让方式
                        transferType = @"0";//出租
                        
                        ///图片
                        [temppPicIDArr removeAllObjects];
                        temppPicIDArr = mapDic[@"piclist"];
                        _dataSource = mapDic[@"piclist"];
                        _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                        for (int i = 0; i < temppPicIDArr.count; i++) {
                            [picIDArr addObject:temppPicIDArr[i][@"picid"]];
                            [imageUrlArr addObject:temppPicIDArr[i][@"picurl"]];
                        }
                        [self setCollectionHeight];
                        
                        
                        ///室厅卫
                        _roomTF.text = [NSString stringWithFormat:@"%@",mapDic[@"bedroom"]];
                        _hallTF.text = [NSString stringWithFormat:@"%@",mapDic[@"livingroom"]];
                        _toiletTF.text = [NSString stringWithFormat:@"%@",mapDic[@"toilef"]];
                        
                        ///拎包入住或简单装修
                        if ([[NSString stringWithFormat:@"%@",mapDic[@"decorattype"]] isEqualToString:@"1"]) {
                            isDecorated = @"1";
                        }else {
                            isDecorated = @"0";
                        }
                        
                        ///楼层租金面积
                        _allFloorTF.text = [NSString stringWithFormat:@"%@",mapDic[@"allfloornum"]];
                        _currentTF.text = [NSString stringWithFormat:@"%@",mapDic[@"floornum"]];
                        
                        _areaTF.text = [NSString stringWithFormat:@"%@",mapDic[@"area"]];
                        _rentTF.text = [NSString stringWithFormat:@"%@",mapDic[@"price"]];
                        
                        ///内容
                        _showTV.text = [NSString stringWithFormat:@"%@",mapDic[@"content"]];
                        _placeHolder.hidden = YES;
                        _showTV.backgroundColor = [UIColor whiteColor];
                        
                        ///红包
                        [selfWeak isNoHaveMoney];
                        
                        ///展示天数
                        NSString *daysStr = [NSString stringWithFormat:@"%@",mapDic[@"showday"]];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",mapDic[@"showday"]]];
                        [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, [NSString stringWithFormat:@"%@",mapDic[@"showday"]].length)];
                        
                        _shouSliderNumbers.attributedText = attribute;
                        [_daysSlider setValue:[daysStr floatValue]];
                        showDays = [NSString stringWithFormat:@"%@",daysStr];
                        
                        ///标签
                        NSString *tagStr = [NSString stringWithFormat:@"%@",mapDic[@"tagsname"]];
                        
                        if (tagStr.length > 0) {
                            
                            NSString *mySubStr =  [tagStr substringToIndex:tagStr.length - 1];
                            NSArray *tagsArr = [mySubStr componentsSeparatedByString:@","];
                            
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            for (int i = 0; i < tagsArr.count; i++) {
                                [tempArr addObject:@{@"name":tagsArr[i]}];
                                
                            }
                            hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:tempArr];
                            
                            
                            for (int i = 0; i < hasSelectedTags.count; i++) {
                                
                                for (int j = 0; j < forSelectTags.count; j++) {
                                    
                                    THTags *oneTag = [hasSelectedTags objectAtIndex:i];
                                    THTags *forSeleTag = [forSelectTags objectAtIndex:j];
                                    if ([oneTag.name isEqualToString:forSeleTag.name]) {
                                        [_labesTempArr addObject:forSeleTag];
                                        [forSelectTags removeObject:forSeleTag];
                                    }
                                }
                                
                            }
                            
                        }
                        
                        [_labelTableView reloadData];
                        [_collectionView reloadData];
                        [selfWeak setUpUI];
                    }
                        break;
                        
                        
                        
                    case 30:
                    {
                        
                        /**
                         areaId       长
                         areaname     名字
                         houseareaId  短
                         */

                        //30 车位出售
                        self.navigationItem.title = @"车位贴";
                        _carportBgView.hidden = NO;
                        _sellBGView.hidden = YES;
                        _rentBGView.hidden = YES;
                        
                        ///小区ID小区名字等
                        areaId = [NSString stringWithFormat:@"%@",mapDic[@"communityid"]];
                        areaname = [NSString stringWithFormat:@"%@",mapDic[@"communityname"]];
                        houseareaId = [NSString stringWithFormat:@"%@",mapDic[@"houseareaid"]];
                        _houseAddressLabel.text = [NSString stringWithFormat:@"%@ %@",mapDic[@"communityname"],mapDic[@"houseareaname"]];
                        
                        ///出让方式
                        transferType = @"1";//出售
                        
                        ///图片
                        [temppPicIDArr removeAllObjects];
                        temppPicIDArr = mapDic[@"piclist"];
                        _dataSource = mapDic[@"piclist"];
                        _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                        for (int i = 0; i < temppPicIDArr.count; i++) {
                            [picIDArr addObject:temppPicIDArr[i][@"picid"]];
                            [imageUrlArr addObject:temppPicIDArr[i][@"picurl"]];
                        }
                        [self setCollectionHeight];
                        
                        
                        ///车位位置和模式
                        if ([mapDic[@"underground"] integerValue]==0) {
                            isOnTheGround = @"0";
                        }else {
                            isOnTheGround = @"1";
                        }
                        
                        if ([mapDic[@"fixed"] integerValue] == 0) {
                            isPermanent = @"0";
                        }else {
                            isPermanent = @"1";
                        }
                        
                         ///总价
                        _carPortMoneyTF.text = [NSString stringWithFormat:@"%@",mapDic[@"price"]];
                        
                        ///内容
                        _showTV.text = [NSString stringWithFormat:@"%@",mapDic[@"content"]];
                        _placeHolder.hidden = YES;
                        _showTV.backgroundColor = [UIColor whiteColor];
                        
                        ///红包
                        [selfWeak isNoHaveMoney];
                        
                        ///展示天数
                        NSString *daysStr = [NSString stringWithFormat:@"%@",mapDic[@"showday"]];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",mapDic[@"showday"]]];
                        [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, [NSString stringWithFormat:@"%@",mapDic[@"showday"]].length)];
                        
                        _shouSliderNumbers.attributedText = attribute;
                        [_daysSlider setValue:[daysStr floatValue]];
                        showDays = [NSString stringWithFormat:@"%@",daysStr];
                        
                        ///标签
                        NSString *tagStr = [NSString stringWithFormat:@"%@",mapDic[@"tagsname"]];
                        
                        if (tagStr.length > 0) {
                            
                            NSString *mySubStr =  [tagStr substringToIndex:tagStr.length - 1];
                            NSArray *tagsArr = [mySubStr componentsSeparatedByString:@","];
                            
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            for (int i = 0; i < tagsArr.count; i++) {
                                [tempArr addObject:@{@"name":tagsArr[i]}];
                                
                            }
                            hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:tempArr];
                            
                            
                            for (int i = 0; i < hasSelectedTags.count; i++) {
                                
                                for (int j = 0; j < forSelectTags.count; j++) {
                                    
                                    THTags *oneTag = [hasSelectedTags objectAtIndex:i];
                                    THTags *forSeleTag = [forSelectTags objectAtIndex:j];
                                    if ([oneTag.name isEqualToString:forSeleTag.name]) {
                                        [_labesTempArr addObject:forSeleTag];
                                        [forSelectTags removeObject:forSeleTag];
                                    }
                                }
                            }
                        }
                        
                        [_labelTableView reloadData];
                        [_collectionView reloadData];
                        [selfWeak setUpUI];
                    }
                        break;
                        
                        
                        
                    case 31:
                    {
                        //31 车位出租
                        self.navigationItem.title = @"车位贴";
                        _carportBgView.hidden = NO;
                        _sellBGView.hidden = YES;
                        _rentBGView.hidden = YES;
                        
                        ///小区ID小区名字等
                        areaId = [NSString stringWithFormat:@"%@",mapDic[@"communityid"]];
                        areaname = [NSString stringWithFormat:@"%@",mapDic[@"communityname"]];
                        houseareaId = [NSString stringWithFormat:@"%@",mapDic[@"houseareaid"]];
                        _houseAddressLabel.text = [NSString stringWithFormat:@"%@ %@",mapDic[@"communityname"],mapDic[@"houseareaname"]];
                        
                        ///出让方式
                        transferType = @"0";//出租
                        
                        ///图片
                        [temppPicIDArr removeAllObjects];
                        temppPicIDArr = mapDic[@"piclist"];
                        _showNumberLabel.text = [NSString stringWithFormat:@"%ld/10",_dataSource.count];
                        _dataSource = mapDic[@"piclist"];
                        for (int i = 0; i < temppPicIDArr.count; i++) {
                            [picIDArr addObject:temppPicIDArr[i][@"picid"]];
                            [imageUrlArr addObject:temppPicIDArr[i][@"picurl"]];
                        }
                        [self setCollectionHeight];
                        
                        ///车位位置和模式
                        if ([mapDic[@"underground"] integerValue] == 0) {
                            isOnTheGround = @"0";
                        }else {
                            isOnTheGround = @"1";
                        }
                        
                        if ([mapDic[@"fixed"] integerValue] == 0) {
                            isPermanent = @"0";
                        }else {
                            isPermanent = @"1";
                        }
                        
                        ///租金
                        _carPortMoneyTF.text = [NSString stringWithFormat:@"%@",mapDic[@"price"]];
                        
                        ///内容
                        _showTV.text = mapDic[@"content"];
                        _placeHolder.hidden = YES;
                        _showTV.backgroundColor = [UIColor whiteColor];
                        
                        ///红包
                        [selfWeak isNoHaveMoney];
                        
                        ///展示天数
                        NSString *daysStr = [NSString stringWithFormat:@"%@",mapDic[@"showday"]];
                        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@天",mapDic[@"showday"]]];
                        [attribute addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(0, [NSString stringWithFormat:@"%@",mapDic[@"showday"]].length)];
                        
                        _shouSliderNumbers.attributedText = attribute;
                        [_daysSlider setValue:[daysStr floatValue]];
                        showDays = [NSString stringWithFormat:@"%@",daysStr];
                        
                        ///标签
                        NSString *tagStr = [NSString stringWithFormat:@"%@",mapDic[@"tagsname"]];
                        
                        if (tagStr.length > 0) {
                            
                            NSString *mySubStr =  [tagStr substringToIndex:tagStr.length - 1];
                            NSArray *tagsArr = [mySubStr componentsSeparatedByString:@","];
                            
                            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                            for (int i = 0; i < tagsArr.count; i++) {
                                [tempArr addObject:@{@"name":tagsArr[i]}];
                                
                            }
                            hasSelectedTags = [THTags mj_objectArrayWithKeyValuesArray:tempArr];
                            
                            
                            for (int i = 0; i < hasSelectedTags.count; i++) {
                                
                                for (int j = 0; j < forSelectTags.count; j++) {
                                    
                                    THTags *oneTag = [hasSelectedTags objectAtIndex:i];
                                    THTags *forSeleTag = [forSelectTags objectAtIndex:j];
                                    if ([oneTag.name isEqualToString:forSeleTag.name]) {
                                        [_labesTempArr addObject:forSeleTag];
                                        [forSelectTags removeObject:forSeleTag];
                                    }
                                }
                                
                            }
                            
                        }
                        [_labelTableView reloadData];
                        [_collectionView reloadData];
                        [selfWeak setUpUI];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }else {
                //失败
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });

        
    }];
}







#pragma mark - 编辑发布成功回调
/**
 编辑发布成功回调
 */
- (void)refreshEdit {
    NSLog(@"编辑发布成功回调");
    
    [USER_DEFAULT setObject:@"yes" forKey:NOTICE_REFRESH_EDIT_DATA];
    [USER_DEFAULT synchronize];
    
    [self showToastMsg:@"贴子发布成功!" Duration:3.0];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
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



#pragma mark ----- textField事件
- (IBAction)tfTextChange:(id)sender {
    

    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    
    if(selectedRange == nil || selectedRange.empty) {
        
        switch (tf.tag) {
            case 564://添加标签
            {
                if(tf.text.length > 5) {
                    [self showToastMsg:@"不能超过5个字符" Duration:3.0];
                    tf.text=[tf.text substringToIndex:5];
                }
            }
                break;
            case 565://车位租金单价
            {
                if (tf.text.length > 8) {
//                    [self showToastMsg:@"最多只能输入8位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:8];
                    return;
                }

            }
                break;
            case 566://出租面积
            {
                if (tf.text.length > 8) {
//                    [self showToastMsg:@"最多只能输入8位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:8];
                    return;
                }
                
            }
                break;
            case 567://租金
            {
                if (tf.text.length > 8) {
//                    [self showToastMsg:@"最多只能输入8位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:8];
                    return;
                }
                
            }
                break;
            case 568://出售面积
            {
                if (tf.text.length > 8) {
//                    [self showToastMsg:@"最多只能输入8位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:8];
                    return;
                }
                
            }
                break;
            case 569://出售价格
            {
                if (tf.text.length >= 8) {
//                    [self showToastMsg:@"最多只能输入8位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:8];
                    return;
                    
                }
                
            }
                break;
            case 570://出租  室
            {
                if (tf.text.length > 2) {
//                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 571://出租  厅
            {
                if (tf.text.length > 2) {
                    //                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 572://出租  卫
            {
                if (tf.text.length > 2) {
                    //                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 573://出租  总楼层
            {
                if (tf.text.length > 3) {
                    //[self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:3];
                    return;
                }
                
            }
                break;
            case 574://  出租 当前楼层
            {
                if (tf.text.length > 3) {
                    //[self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:3];
                    return;
                }
                
            }
                break;
            case 575://出售  室
            {
                if (tf.text.length > 2) {
                    //                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 576://  出售  厅
            {
                if (tf.text.length > 2) {
                    //                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 577://  出售 卫
            {
                if (tf.text.length > 2) {
                    //                    [self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:2];
                    return;
                }
                
            }
                break;
            case 578://出售  总楼层
            {
                if (tf.text.length > 3) {
                    //[self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:3];
                    return;
                }
                
            }
                break;
            case 579://出售  当前楼层
            {
                if (tf.text.length > 3) {
                    //[self showToastMsg:@"最多只能输入2位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:3];
                    return;
                }
                
            }
                break;
            default:
                break;
        }
        
        
    }

}


@end
