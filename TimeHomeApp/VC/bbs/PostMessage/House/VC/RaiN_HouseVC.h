//
//  RaiN_HouseVC.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseViewController.h"


@interface RaiN_HouseVC : THBaseViewController

//本页面判断
@property(nonatomic,copy)NSString *isHouse;// 0是房产贴 1车位帖

//页面跳转判断
@property(nonatomic,copy)NSString *isCompile;// 0是从编辑页面跳转 1不是
@property(nonatomic,copy)NSString *postID;// 帖子ID



/**
 房产地址背景
 */
@property (weak, nonatomic) IBOutlet UIView *houseAddressBG;
@property (weak, nonatomic) IBOutlet UILabel *houseAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *houseAddressBtn;

/**
 出让方式
 */
@property (weak, nonatomic) IBOutlet UIView *transferBG;
//出租
@property (weak, nonatomic) IBOutlet UIButton *rentOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;


/**
 pic
 */
@property (weak, nonatomic) IBOutlet UIView *collectionBG;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *showNumberBG;
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;


#pragma mark ---------- 出租 户型面积等
@property (weak, nonatomic) IBOutlet UIView *rentBGView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIView *textViewBG;

/** 户型 */
@property (weak, nonatomic) IBOutlet UIView *doorModelBG;
@property (weak, nonatomic) IBOutlet UILabel *doorModeLabel;
@property (weak, nonatomic) IBOutlet UIView *inputFieldBG;

//室
@property (weak, nonatomic) IBOutlet UIView *roomBG;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UIView *roomTfBG;
@property (weak, nonatomic) IBOutlet UITextField *roomTF;

//厅
@property (weak, nonatomic) IBOutlet UIView *hallBG;
@property (weak, nonatomic) IBOutlet UILabel *hallLabel;
@property (weak, nonatomic) IBOutlet UIView *hallTfBg;
@property (weak, nonatomic) IBOutlet UITextField *hallTF;
//卫
@property (weak, nonatomic) IBOutlet UIView *toiletBG;
@property (weak, nonatomic) IBOutlet UILabel *toiletLabel;
@property (weak, nonatomic) IBOutlet UIView *toiletTfBG;
@property (weak, nonatomic) IBOutlet UITextField *toiletTF;


/** 装修 */
@property (weak, nonatomic) IBOutlet UIView *decoratedBG;
@property (weak, nonatomic) IBOutlet UILabel *decoratedLabel;

//拎包入住
@property (weak, nonatomic) IBOutlet UIView *nowStayBG;
@property (weak, nonatomic) IBOutlet UIButton *nowStayBtn;

//简单装修
@property (weak, nonatomic) IBOutlet UIView *simpleDecorationBg;
@property (weak, nonatomic) IBOutlet UIButton *simpleDecorationBtn;


/** 楼层 */
@property (weak, nonatomic) IBOutlet UIView *floorBG;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

@property (weak, nonatomic) IBOutlet UIView *currentFloorBg;
@property (weak, nonatomic) IBOutlet UIView *currentTFBg;
@property (weak, nonatomic) IBOutlet UITextField *currentTF;

@property (weak, nonatomic) IBOutlet UIView *allFloorBG;
@property (weak, nonatomic) IBOutlet UIView *allFloorTFBg;
@property (weak, nonatomic) IBOutlet UITextField *allFloorTF;

/** 租金 */
@property (weak, nonatomic) IBOutlet UIView *rentBG;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet UIView *rentTFBg;
@property (weak, nonatomic) IBOutlet UITextField *rentTF;

/** 面积 */
@property (weak, nonatomic) IBOutlet UIView *areaBG;
@property (weak, nonatomic) IBOutlet UIView *areaTFBG;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;


#pragma mark ---------- 出售 户型面积等 sell
@property (weak, nonatomic) IBOutlet UIView *sellBGView;

@property (weak, nonatomic) IBOutlet UIView *sell_doorModelBG;
//室
@property (weak, nonatomic) IBOutlet UIView *sell_roomTFBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_roomTF;
//厅
@property (weak, nonatomic) IBOutlet UIView *sell_hallTFBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_hallTF;
//卫
@property (weak, nonatomic) IBOutlet UIView *sell_toiletTFBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_toiletTF;

///面积
@property (weak, nonatomic) IBOutlet UIView *sell_areaTFBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_areaTF;

///楼层
@property (weak, nonatomic) IBOutlet UIView *sell_currentFloorTfBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_currentFloorTF;

@property (weak, nonatomic) IBOutlet UIView *sell_allFloorTfBg;
@property (weak, nonatomic) IBOutlet UITextField *sell_allFloorTF;

@property (weak, nonatomic) IBOutlet UIView *priceTfBg;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;

/** 详情描述 */
@property (weak, nonatomic) IBOutlet UITextView *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *showTV;

/**
 红包
 */
@property (weak, nonatomic) IBOutlet UIImageView *redPacketImage;
@property (weak, nonatomic) IBOutlet UILabel *redPacketShowLabel;
@property (weak, nonatomic) IBOutlet UIButton *addRedPacket;
@property (weak, nonatomic) IBOutlet UILabel *moneyShowLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

/**
 展示天数
 */
@property (weak, nonatomic) IBOutlet UIView *showDaysBG;
@property (weak, nonatomic) IBOutlet UILabel *shouSliderNumbers;
@property (weak, nonatomic) IBOutlet UISlider *daysSlider;




@property (weak, nonatomic) IBOutlet UITableView *labelTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTableViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *postHouseBtn;



#pragma amrk ---- 车位相关
@property (weak, nonatomic) IBOutlet UIView *carportBgView;//背景
//固定车位位置
@property (weak, nonatomic) IBOutlet UIButton *permanentBtn;
//不固定车位位置
@property (weak, nonatomic) IBOutlet UIButton *noPermanentBtn;

//地上车位
@property (weak, nonatomic) IBOutlet UIButton *onTheGround;
//地下车位
@property (weak, nonatomic) IBOutlet UIButton *undergroundBtn;
//租金/总价
@property (weak, nonatomic) IBOutlet UILabel *carPortMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *carPortMoneyTfBG;
@property (weak, nonatomic) IBOutlet UITextField *carPortMoneyTF;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeMoneyBtn;


/**
 添加标签
 */
@property (weak, nonatomic) IBOutlet UIView *tagsTFBgView;

@property (weak, nonatomic) IBOutlet UITextField *tagsTF;

@property (weak, nonatomic) IBOutlet UIButton *addTagsBtn;



@end
