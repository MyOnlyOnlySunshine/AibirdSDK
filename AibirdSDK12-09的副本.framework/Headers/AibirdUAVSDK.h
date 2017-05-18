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

//移动延时摄影图1角度
@property(nonatomic,assign)float img1_x_value;
@property(nonatomic,assign)float img1_y_value;
@property(nonatomic,assign)float img1_z_value;

//移动延时摄影发送x y z
@property(nonatomic,assign)float sendXValue;
@property(nonatomic,assign)float sendYValue;
@property(nonatomic,assign)float sendZValue;

@property(nonatomic,assign)NSInteger sectionDistanceX;
@property(nonatomic,assign)NSInteger sectionDistanceY;
@property(nonatomic,assign)NSInteger sectionDistanceZ;


@property(nonatomic,strong)NSMutableArray *sectionStepArr;

@property(nonatomic,assign)NSInteger stepCount;
@property(nonatomic,assign)NSInteger sectionCount;

@property(nonatomic,assign)BOOL timeLapseFinished;
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






























@end
