//
//  AibirdUAVSDK.h
//  SDK
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AibirdUAVSDK : NSObject

@property(nonatomic,assign)NSInteger  deviceCurrentMode;


//----------integer类型
//工作模式  －－－ 休眠与工作
@property(nonatomic,assign)NSInteger workInteger;

//跟随模式  －－－  全跟随 半跟随  锁定
@property(nonatomic,assign)NSInteger folowingInteger;

//横竖拍模式  －－－  横拍（上） 横拍（下） 竖拍（右） 竖拍（左）
@property(nonatomic,assign)NSInteger  verOrHorInteger;

//设备当前电量
/**
 *
 powerIndex
 0：没电
 1：0～25%
 2：25%～50%
 3：50%～75%
 4：75%~ 100%
 */

@property(nonatomic,assign)NSInteger powerIndex;


//------------str类型
@property(nonatomic,copy)NSString *workModeStr;
@property(nonatomic,copy)NSString *followingStr;
@property(nonatomic,copy)NSString *verOrHorStr;;



//--------------------------移动延时摄影部分---------------------

//实时解析x y z 角度
@property(nonatomic,assign)int16_t xValue;
@property(nonatomic,assign)int16_t yValue;
@property(nonatomic,assign)int16_t zValue;

//移动延时摄影图1角度  延时摄影取的第一个点的 x y z的单个初始位置
@property(nonatomic,assign)float img1_x_value;
@property(nonatomic,assign)float img1_y_value;
@property(nonatomic,assign)float img1_z_value;

//移动延时摄影发送x y z
@property(nonatomic,assign)float sendXValue;
@property(nonatomic,assign)float sendYValue;
@property(nonatomic,assign)float sendZValue;

//纪录选的所有点的 x  y  z 的点击角度的位置
@property(nonatomic,assign)NSInteger sectionDistanceX;
@property(nonatomic,assign)NSInteger sectionDistanceY;
@property(nonatomic,assign)NSInteger sectionDistanceZ;


@property(nonatomic,strong)NSMutableArray *sectionStepArr;


@property(nonatomic,assign)NSInteger stepCount;

//设置关键点的 个数  －－ 至少2个  至多3个
@property(nonatomic,assign)NSInteger sectionCount;

//移动延时摄影是否会到最初点
@property(nonatomic,assign)BOOL timeLapseFinished;

//移动延时摄影是否已经完成
@property(nonatomic,assign)BOOL timeLapsePrepareFinish;


//************以下所有数据请保证蓝牙已连接且通信正常的情况下发送

/**
 *  查询云台所有配置信息data
 *
 *  @return 查询云台所有配置信息data
 */

- (NSData *)configurationInformationData;  // －－ 需要解析硬件端回传命令

/**
 *  以上数据若发送成功，手机端会收到如下20个字节byte
 55
 AA
 01
 0E
 E0
 1C
 Data0-Data11   
 {
   Data0：模式切换配置值，具体定义见设置值
   Data1：方位速度等级（摇杆）
   Data2：俯仰速度等级（摇杆）
   Data3：方位速度等级（随动）
   Data4：俯仰速度等级（随动）
   Data5：横滚角参考高8位（×100）
   Data6：横滚角参考低8位（×100）
   Data7：方位速度方向
   Data8：俯仰速度方向
 }
 XOR  -- 校验段   自01^0E^.....^data7^data8
 F0
 */

//--------------------------------------------------------------------------

/**
 *  设置硬件速度等级data
 *
 *  @param rockerPositionSpeed    方位速度等级（摇杆）
 *  @param rockerpitchingSpeed       俯仰速度等级（摇杆）
 *  @param followingPositionSpeed 方位速度等级（随动）
 *  @param follingPositionSpeed   俯仰速度等级（随动）
 *
 *  @return 设置硬件速度等级data
 */



- (NSData *)speedSettingDataWithRockerPositionSpeed:(NSInteger)rockerPositionSpeed andRockerpitchingSpeed:(NSInteger)rockerpitchingSpeed andFollowingPositionSpeed:(NSInteger)followingPositionSpeed andFollowingPitchingSpeed:(NSInteger)follingPitchingSpeed;

/**
 *  以上数据若发送成功，且硬件设置速度成功,手机端会收到如下8个字节byte

 55
 AA
 01
 0C
 E1
 50
 XOR = 01^0C^E1^50   （以下校验值依此类推）
 F0

 */

//--------------------------------------------------------------------------

/**
 *  云台模式切换配置，设置以下任意模式后，云台将只能切换当前index对应的模式
 *
 *  @param index 1    X_Z_FOLLOW->Z_FOLLOW
    @param index 2    Z_FOLLOW->X_Z_FOLLOW
    @param index 3    X_Z_FOLLOW->NONE_FOLLOW
    @param index 4    Z_FOLLOW->NONE_FOLLOW
    @param index 5    X_Z_FOLLOW –>Z_FOLLOW->NONE_FOLLOW
    @param index 6    X_Z_FOLLOW
    @param index 7    Z_FOLLOW
    @param index 8    NONE_FOLLOW
 *
 *  @return 云台模式切换配置data
 */

- (NSData *)deviceSetModeDataWithIndex:(NSInteger)index;

/**
 *   以上数据发送成功后，云台回传给手机端字节
 55
 AA
 01
 02
 E1
 10
 XOR
 F0

 */


//--------------------------------------------------------------------------


/**
 *  云台速度控制方向设置 (默认方位速度方向为 1  俯仰速度方向为3)
 *
 *  @param positionSpeedIndex 1   与2方向相反
           positionSpeedIndex 2   与1方向相反
 *  @param pitchingSpeedIndex 3   与4方向相反
           pitchingSpeedIndex 4   与3反向相反
 *
 *  @return <#return value description#>
 */

- (NSData *)deviceSetMoveDirectionWithPositionSpeedDirection:(NSInteger)positionSpeedIndex andPitchingSpeedDirection:(NSInteger)pitchingSpeedIndex;


/**
 *   以上数据发送成功后，云台回传给手机端字节
 55
 AA
 01
 02
 E1
 70
 XOR
 F0

 */

//--------------------------------------------------------------------------

/**
 *  云台工作模式 跟随模式 横竖拍模式切换
 *
 *  @param workModeIndex 1  休眠
           workModeIndex 2  启动
 *  @param followMode    1  NONE_FOLLOW
           followMode    2  Z_FOLLOW
           followMode    3  X_Z_FOLLOW
 *  @param verOrHorMode  1  HOR_UP
           verOrHorMode  2  HOR_DOWN
           verOrHorMode  3  VER_RIGHT
           verOrHorMode  4  VER_LEFT
 *
 *  @return <#return value description#>
 */

- (NSData *)controlDeviceDataWithWorkMode:(NSInteger)workModeIndex andFollowMode:(NSInteger)followMode andVerOrHorMode:(NSInteger)verOrHorMode;


//--------------------------------------------------------------------------

/**
 *  云台控制数据 （控制云台移动，因需要在不改变当前云台所处模式下,故需要传入当前设备工作模式状态）
 *
 *  @param directionIndex 1  上
           directionIndex 2  下
           directionIndex 3  左
           directionIndex 4  右
 
 *  @param deviceCurrentMode 当前设备的工作模式
 *
 *  @return <#return value description#>
 */

- (NSData *)controlDeviceWithDirection:(NSInteger)directionIndex andCurrentMode:(NSInteger)deviceCurrentMode;



//--------------------------------------------------------------------------


/**
 *  收到20个字节 ＋ 3个字节   请用data数组存起来   足23字节后 进行解析  解析云台收到的23字节数据  结构如下所示
 * 注 也可以把所有的受到的字节放到一个容器里面，然后根据自己的需要进行解析，用完之后即从容易中删除
 *
 *  @param data
 55
 AA
 01
 0x11
 F1  >>>  确保23字节中此位字节为此
 0F  >>>  确保23字节中此位字节为此
 Data0
 ……
 Data14
 XOR
 F0
 
 */

- (void)analyzeReceiveLongData:(NSData *)data;

//--------------------------------------------------------------------------
/**
 *  人脸跟踪发送数据data
 *
 *  @param faceCenterX   人脸中心点X坐标
 *  @param faceCenterY   人脸中心店Y坐标
 *  @param screenCenterX 手机屏幕中心点X
 *  @param screenCenterY 手机屏幕中心点Y
 *  @param cameraIndex   1 前置摄像头
           cameraIndex   2 后置摄像头
 
 *
 *  @return <#return value description#>
 */

- (NSData *)faceFollowDataWithFaceCenterX:(float)faceCenterX andFaceCenterY:(float)faceCenterY  andScreenCenterX:(float)screenCenterX andScreenCenterY:(float)screenCenterY withFrontCameraOrBackCameraIndex:(NSInteger)cameraIndex;

//--------------------------------------------------------------------------
/**
 *  人脸跟踪未识别或跟丢后发送的data
 *
 *  @return <#return value description#>
 */

- (NSData *)loseFaceData;

//--------------------------------------------------------------------------

/**
 *  移动延时摄影选取完点后，让云台回到最初选的第一个点的位置
 *
 *  @param x_value 第一个点x电机位置
 *  @param Y_value 第一个点y电机位置
 *  @param Z_value 第一个点z电机位置
 *
 *  @return <#return value description#>
 */


- (NSData *)backToFirstPointWithFirstXValue:(float)x_value   andFirstYValue:(float)Y_value andZValue:(float)Z_value;

//--------------------------------------------------------------------------

/**
 *  根据选取的所有点中 x y z 相对应的电机角度，和用户选择的时间  算出每一个区间匀速分别所需要时间
 *
 *  @param xSetPositionArr 所有选取点 x电机角度的数组
 *  @param ySetPositionArr 所有选取点 y电机角度的数组
 *  @param zSetPositionArr 所有选取点 z电机角度的位置
 *  @param time            用户选择的时间  以秒为单位
 *
 *         选取完所有点，并在开始移动延时摄影前，调用此方法来计算出匀速走每个区间所要走的步径
 *  @return   返回的可变数组 即为每个区间所要走的时间
 */


- (NSMutableArray *)getSectionTimeFromxSetPositionArr:(NSMutableArray *)xSetPositionArr andMaxY:(NSMutableArray *)ySetPositionArr andMaxZ:(NSMutableArray *)zSetPositionArr andTime:(float)time;


//--------------------------------------------------------------------------
/**
 *  得到移动延时摄影所有选取点 x y z的电机位置并存放到相对应的数组中
 *
 *  @param xPostionArr  所有选取点 x电机角度的数组
 *  @param yPositionArr 所有选取点 y电机角度的数组
 *  @param zPositionArr 所有选取点 z电机角度的位置
 *  @param sectionTimeArr 匀速走每个x y z 单个section所需要的时间
 *
 *  @return <#return value description#>
 */

- (NSData *)moveTimeLapseDataWithXPositionArr:(NSMutableArray *)xPostionArr  andYPositionArr:(NSMutableArray *)yPositionArr andZpositionArr:(NSMutableArray *)zPositionArr andSectionStepArr:(NSMutableArray *)sectionTimeArr;

//--------------------------------------------------------------------------























@end
