//
//  AibirdUAVSDK.m
//  SDK
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 ChangChang. All rights reserved.
//

#import "AibirdUAVSDK.h"

#define MODE_SLEEP @"00"
#define MODE_NORMAL_TO_SLEEP @"11"
#define MODE_NOMRAL @"01"
#define MODE_SLEEP_TO_NORMAL @"10"
#define MODE_NONE_FOLLOW @"0000"
#define MODE_Z_FOLLOW @"0001"
#define MODE_X_Z_FOLLOW @"0010"
#define MODE_TRACKER @"0011"
#define MODE_LOCK @"0100"
#define MODE_HOR @"00" //MODE_HOR_UP
#define MODE_HOR_UP @"10" //MODE_HOR_DOWN
#define MODE_VER @"01"   //MODE_VER_RIGHT
#define MODE_VER_LEFT @"11" //MODE_VER_LEFT


@implementation AibirdUAVSDK


- (NSData *)configurationInformationData
{
    /**
     *  云台配置信息查询data
     */
    Byte reg[8];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x02;
    reg[4] = 0xe0;
    reg[5] = 0x00;
    reg[6] = reg[2]^reg[3]^reg[4]^reg[5];
    reg[7] = 0xf0;
    NSData *data = [NSData dataWithBytes:reg length:8];
    return data;
}

- (NSData *)speedSettingDataWithRockerPositionSpeed:(NSInteger)rockerPositionSpeed andRockerpitchingSpeed:(NSInteger)rockerpitchingSpeed andFollowingPositionSpeed:(NSInteger)followingPositionSpeed andFollowingPitchingSpeed:(NSInteger)follingPitchingSpeed
{
    /**
     *  云台随动速度设置
     */
    Byte reg[12];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x06;
    reg[4] = 0xE1;
    reg[5] = 0x44;
    reg[6] = strtoul([[self ToHex:rockerPositionSpeed] UTF8String],0,16);
    reg[7] = strtoul([[self ToHex:rockerpitchingSpeed] UTF8String],0,16);
    reg[8] = strtoul([[self ToHex:followingPositionSpeed] UTF8String],0,16);
    reg[9] = strtoul([[self ToHex:follingPitchingSpeed] UTF8String],0,16);
    reg[10] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]);
    reg[11] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:12];
    return  data;
}

- (NSData *)deviceSetModeDataWithIndex:(NSInteger)index
{
    
    /**
     *  云台模式设置
     */
    Byte modeB[9];
    modeB[0] = 0x55;
    modeB[1] = 0xAA;
    modeB[2] = 0x01;
    modeB[3] = 0x03;
    modeB[4] = 0xE1;
    modeB[5] = 0x01;
    
    switch (index) {
        case 1:
        {
            modeB[6] = 0x00;
        }
            break;
        case 2:
        {
            modeB[6] = 0x01;
        }
            break;
        case 3:
        {
            modeB[6] = 0x02;
        }
            break;
        case 4:
        {
            modeB[6] = 0x03;
        }
            break;
        case 5:
        {
            modeB[6] = 0x04;
        }
            break;
        case 6:
        {
            modeB[6] = 0x05;
        }
            break;
        case 7:
        {
            modeB[6] = 0x06;
        }
            break;
        case 8:
        {
            modeB[6] = 0x07;
        }
            break;
            
        default:
            break;
    }
    modeB[7] = modeB[2]^modeB[3]^modeB[4]^modeB[5]^modeB[6];
    modeB[8] = 0xf0;
    NSData *data = [[NSData alloc]initWithBytes:modeB length:9];
    return data;
}


- (NSData *)deviceSetMoveDirectionWithPositionSpeedDirection:(NSInteger)positionSpeedIndex andPitchingSpeedDirection:(NSInteger)pitchingSpeedIndex
{
    
    Byte modeB[10];
    modeB[0] = 0x55;
    modeB[1] = 0xAA;
    modeB[2] = 0x01;
    modeB[3] = 0x04;
    modeB[4] = 0xE1;
    modeB[5] = 0x62;
    
    switch (positionSpeedIndex)
    {
        case 1:
            modeB[6] = -1;
            break;
        case 2:
            modeB[6] = 1;
            break;
            
        default:
            break;
    }
    
    switch (pitchingSpeedIndex)
    {
        case 3:
            modeB[7] = -1;
            break;
        case 4:
            modeB[7] = 1;
            break;
            
        default:
            break;
    }
    modeB[8] = modeB[2]^modeB[3]^modeB[4]^modeB[5]^modeB[6]^modeB[7];
    modeB[9] = 0xf0;
    NSData *data = [NSData dataWithBytes:modeB length:10];
    return data;
}


- (NSData *)controlDeviceDataWithWorkMode:(NSInteger)workModeIndex andFollowMode:(NSInteger)followMode andVerOrHorMode:(NSInteger)verOrHorMode
{
    NSMutableString *binaryStr = [NSMutableString new];
    Byte reg[20];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    
    switch (verOrHorMode)
    {
        case 1:
            [binaryStr appendString:MODE_HOR];
            break;
        case 2:
            [binaryStr appendString:MODE_HOR_UP];
            break;
        case 3:
            [binaryStr appendString:MODE_VER];
            break;
        case 4:
            [binaryStr appendString:MODE_VER_LEFT];
            break;
        default:
            break;
    }
    
    switch (followMode)
    {
        case 1:
            [binaryStr appendString:MODE_NONE_FOLLOW];
            break;
        case 2:
            [binaryStr appendString:MODE_Z_FOLLOW];
            break;
        case 3:
            [binaryStr appendString:MODE_X_Z_FOLLOW];
            break;
        default:
            break;
    }
    
    switch (workModeIndex)
    {
        case 1:
           [binaryStr appendString:MODE_SLEEP];
            break;
        case 2:
           [binaryStr appendString:MODE_NOMRAL];
            break;
        default:
            break;
    }
    self.deviceCurrentMode = [self convertBinaryStrToInteger:binaryStr];
    reg[6] = [self convertBinaryStrToInteger:binaryStr];
    reg[7] = 0x00;
    reg[8] = 0x00;
    reg[9] = 0x00;
    reg[10] = 0x00;
    reg[11] = 0x00;
    reg[12] = 0x00;
    reg[13] = 0x00;
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;
}



- (NSData *)controlDeviceWithDirection:(NSInteger)directionIndex andCurrentMode:(NSInteger)deviceCurrentMode
{
    Byte reg[20];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    
    reg[6] = self.deviceCurrentMode;
    reg[7] = 0x00;
    reg[8] = 0x00;
    reg[10] = 0x00;
    switch (directionIndex) {
        case 1:
            reg[9] = 0x00;
            reg[11] = 0x03;
            break;
        case 2:
            reg[9] = 0x00;
            reg[11] = 0xfd;
            break;
        case 3:
            reg[9] = 0x03;
            reg[11] = 0x00;
            break;
        case 4:
            reg[9] = 0xfd;
            reg[11] = 0x00;
            break;
            
        default:
            break;
    }
    reg[12] = 0x00;
    reg[13] = 0x00;
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;
}


- (NSData *)faceFollowDataWithFaceCenterX:(float)faceCenterX andFaceCenterY:(float)faceCenterY  andScreenCenterX:(float)screenCenterX andScreenCenterY:(float)screenCenterY withFrontCameraOrBackCameraIndex:(NSInteger)cameraIndex
{
    
    Byte reg[20] ;
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    
    // self.followModeSetStr = @"0011";
    reg[6] = [self currentModeWithHorOrVerStr:self.verOrHorStr andFollowModeStr:@"0011" andWorkModeStr:self.workModeStr];
    reg[7] = 0;
    if ([self.followingStr isEqualToString:@"0011"])
    {
        switch (cameraIndex) {
            case 1:
            {
                reg[8] = ((int)(screenCenterY - faceCenterY)* (-10) & 0xff00)>>8;
                reg[9] = ((int)(screenCenterY - faceCenterY)* (-10) & 0x00ff);
                
                reg[10] = ((int)(screenCenterX - faceCenterX)* (-10) & 0xff00)>>8;
                reg[11] = ((int)(screenCenterX - faceCenterX)* (-10) & 0x00ff);
            }
                break;
            case 2:
            {
                reg[8] = ((int)(screenCenterY - faceCenterY)* (10) & 0xff00)>>8;
                reg[9] = ((int)(screenCenterY - faceCenterY)* (10) & 0x00ff);
                
                reg[10] = ((int)(screenCenterX - faceCenterX)* (10) & 0xff00)>>8;
                reg[11] = ((int)(screenCenterX - faceCenterX)* (10) & 0x00ff);
            }
                break;
        
            default:
                break;
        }

    }
    else
    {
        reg[8] = 0;
        reg[9] = 0;
        reg[10]= 0;
        reg[11] = 0;
    }
    
    reg[12] = 0;
    reg[13] = 0;
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;
    
}


- (void)analyzeReceiveLongData:(NSData *)data
{
    if (data.length == 23) {
        Byte *byte = (Byte *)[data bytes];
        if (byte[0] == 0x55 &&byte[1] == 0xaa &&(byte[2]^byte[3]^byte[4]^byte[5]^byte[6]^byte[7]^byte[8]^byte[9]^byte[10]^byte[11]^byte[12]^byte[13]^byte[14]^byte[15]^byte[16]^byte[17]^byte[18]^byte[19]^byte[20] == byte[21])&&byte[22] == 0xf0)
        {
            if (byte[4] == 0xf1 &&byte[5] == 0x0f)
            {
                //解析电池电量
                {
                    // 第八个字节包含电量信息
                    Byte seventhB[] = {byte[7]};
                    NSData *sevenData = [NSData dataWithBytes:seventhB length:1];
                    
                    self.powerIndex = [[self hexadecimalString:sevenData] integerValue];
                }
                
                
                Byte sixthB[] = {byte[6]};
                NSData *modeData = [NSData dataWithBytes:sixthB length:1];
                NSString *str = [self hexadecimalString:modeData];
                
                int  value = (int)strtoul([str UTF8String],0,16);
                NSString *binaryStr = [self binaryStringWithInteger:value];
                
                //解析横竖拍
                {
                  self.verOrHorStr = [binaryStr substringWithRange:NSMakeRange(0, 2)] ;
                    
                }
                
                // 解析跟随模式
                {
                    self.followingStr= [binaryStr substringWithRange:NSMakeRange(2, 4)] ;
                }
                
                //解析工作模式
                {
                    self.workModeStr = [binaryStr substringWithRange:NSMakeRange(6, 2)] ;
                }
                if (![self performSelector:@selector(controlDeviceDataWithWorkMode:andFollowMode:andVerOrHorMode:)]) {
                    self.deviceCurrentMode =byte[6];
                }else
                {
                    
                }

            }else
            {
                NSLog(@" not ‘0xF1’ and ‘0x01’ ");
            }
        }
        else
        {
            NSLog(@"XOR error");
        }
    }else
    {
        NSLog(@"data.length!=23");
    }
}


- (NSData *)loseFaceData
{
   return  [self sendQuitMoveTimeLapseData];
}


//跟丢人脸或退出移动延时摄影时发送的数据
- (NSData *)sendQuitMoveTimeLapseData
{
    Byte reg[20];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    reg[6] = [self currentModeWithHorOrVerStr:self.verOrHorStr andFollowModeStr:@"0101" andWorkModeStr:self.workModeStr];
    reg[7] = 0x00;
    reg[8] = 0;
    reg[9] = 0;
    reg[10] = 0;
    reg[11] = 0;
    reg[12] = 0;
    reg[13] = 0;
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;
}




- (NSMutableArray *)getSectionTimeFromxSetPositionArr:(NSMutableArray *)xSetPositionArr andMaxY:(NSMutableArray *)ySetPositionArr andMaxZ:(NSMutableArray *)zSetPositionArr andTime:(float)time
{
    NSMutableArray *maxDistanceArr = [NSMutableArray new];
    NSInteger  totalDistance = 0;
    
    for (int i=0; i<xSetPositionArr.count-1; i++)
    {
        NSInteger xDistance = labs([xSetPositionArr[i+1]  integerValue] - [xSetPositionArr[i]  integerValue]);
        NSInteger yDistance = labs([ySetPositionArr[i+1]  integerValue] - [ySetPositionArr[i]  integerValue]);
        NSInteger zDistance = labs([zSetPositionArr[i+1]  integerValue] - [zSetPositionArr[i]  integerValue]);
        
        //如果ydistance>180 对Y轴寻找最短路径
        if (yDistance>1800)
        {
            yDistance = 3600 - yDistance;
        }
        
        // 计算单个区间最大距离并记录
        NSInteger maxDistance = (xDistance>yDistance?xDistance:yDistance)>(zDistance) ? (xDistance>yDistance ? xDistance: yDistance):zDistance;
        [maxDistanceArr addObject:@(maxDistance)];
        
        //计算总距离
        totalDistance +=maxDistance;
    }
    
    float speed = totalDistance/( time * 10 );
    
    NSMutableArray *sectionTime = [NSMutableArray new];
    for (int i=0; i<maxDistanceArr.count; i++)
    {
        [sectionTime addObject:@((NSInteger)([maxDistanceArr[i] integerValue]/speed))];
    }
    return sectionTime;
}



- (NSData *)backToFirstPointWithFirstXValue:(float)x_value   andFirstYValue:(float)Y_value andZValue:(float)Z_value
{
    Byte reg[20];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    reg[6] = [self currentModeWithHorOrVerStr:self.verOrHorStr andFollowModeStr:@"0100" andWorkModeStr:self.workModeStr];
    reg[7] = 0x00;
    //   if ([self.followModeFeedbackStr isEqualToString:@"0100"])
    //   {
    reg[8] = ((NSInteger)x_value & 0xff00)>>8;
    reg[9] = ((NSInteger)x_value & 0x00ff);
    
    reg[10] = ((NSInteger)Y_value & 0xff00)>>8;
    reg[11] = ((NSInteger)Y_value & 0x00ff);
    
    reg[12] = ((NSInteger)Z_value & 0xff00)>>8;
    reg[13] = ((NSInteger)Z_value & 0x00ff);
    
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;
}


- (NSData *)moveTimeLapseDataWithXPositionArr:(NSMutableArray *)xPostionArr  andYPositionArr:(NSMutableArray *)yPositionArr andZpositionArr:(NSMutableArray *)zPositionArr andSectionStepArr:(NSMutableArray *)sectionTimeArr
{
    [self calculateRefFromxPosition:xPostionArr andySetPosition:yPositionArr andzSetPosition:zPositionArr andSectionStepArray:sectionTimeArr];
   
    
    Byte reg[20];
    reg[0] = 0x55;
    reg[1] = 0xAA;
    reg[2] = 0x01;
    reg[3] = 0x0e;
    reg[4] = 0xF7;
    reg[5] = 0x0c;
    reg[6] = [self currentModeWithHorOrVerStr:self.verOrHorStr andFollowModeStr:@"0100" andWorkModeStr:self.workModeStr];
    reg[7] = 0x00;

    reg[8] = ((NSInteger)self.sendXValue & 0xff00)>>8;
    reg[9] = ((NSInteger)self.sendXValue & 0x00ff);
    
    reg[10] = ((NSInteger)self.sendYValue & 0xff00)>>8;
    reg[11] = ((NSInteger)self.sendYValue & 0x00ff);
    
    reg[12] = ((NSInteger)self.sendZValue & 0xff00)>>8;
    reg[13] = ((NSInteger)self.sendZValue & 0x00ff);
    
    reg[14] = 0x00;
    reg[15] = 0x00;
    reg[16] = 0x00;
    reg[17] = 0x00;
    
    reg[18] = (Byte)(reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]^reg[8]^reg[9]^reg[10]^reg[11]^reg[12]^reg[13]^reg[14]^reg[15]^reg[16]^reg[17]);
    reg[19] =0xF0;
    NSData *data = [NSData dataWithBytes:reg length:20];
    return data;

}

- (void)calculateRefFromxPosition:(NSMutableArray *)xSetPosition andySetPosition:(NSMutableArray *)ySetPosition andzSetPosition:(NSMutableArray *)zSetPosition andSectionStepArray:(NSMutableArray *)sectionStepArr
{
    NSLog(@"send x: %lf, y : %lf,z: %lf",self.sendXValue,self.sendYValue,self.sendZValue);
    if (sectionStepArr.count>=1)
    {
        if (self.stepCount==0) {
            self.sendXValue = [xSetPosition[self.sectionCount] floatValue];
            self.sendYValue = [ySetPosition[self.sectionCount] floatValue];
            self.sendZValue = [zSetPosition[self.sectionCount] floatValue];
            
            self.sectionDistanceX = [xSetPosition[self.sectionCount+1] integerValue] - [xSetPosition[self.sectionCount] integerValue];
            self.sectionDistanceY = [ySetPosition[self.sectionCount+1] integerValue] - [ySetPosition[self.sectionCount] integerValue];
            self.sectionDistanceZ = [zSetPosition[self.sectionCount+1] integerValue] - [zSetPosition[self.sectionCount] integerValue];
            
            //对Y电机寻找最短路径
            if (self.sectionDistanceY >1800) {
                self.sectionDistanceY-= 3600;
            }
            else if(self.sectionDistanceY < -1800)
            {
                self.sectionDistanceY  += 3600;
            }
            self.stepCount ++;
        }
        else if (self.stepCount<[sectionStepArr[self.sectionCount] integerValue])
        {
            self.sendXValue += self.sectionDistanceX/[sectionStepArr[self.sectionCount] floatValue];
            self.sendYValue += self.sectionDistanceY/[sectionStepArr[self.sectionCount] floatValue];
            self.sendZValue += self.sectionDistanceZ/[sectionStepArr[self.sectionCount] floatValue];
            
            //对Y电机寻找最短路径
            if (self.sendYValue >1800) {
                self.sendYValue-= 3600;
            }
            else if(self.sendYValue < -1800)
            {
                self.sendYValue += 3600;
            }
            self.stepCount ++;
        }
        else
        {
            self.sectionCount++;
            self.stepCount = 0;
            
            if (self.sectionCount >= sectionStepArr.count)
            {
                self.sectionCount = 0;
                self.timeLapseFinished = YES;
            }
        }
    }
    else
    {
        self.stepCount = 0;
    }
}









//---------------------------------私有方法————————————————————


//字符串拼接
- (NSInteger)currentModeWithHorOrVerStr:(NSString *)horOrVerStr andFollowModeStr:(NSString *)followModeStr andWorkModeStr:(NSString *)workModeStr
{
    NSString *modeStr = [NSString stringWithFormat:@"%@%@%@",horOrVerStr,followModeStr,workModeStr];
    NSInteger integer = [self convertBinaryStrToInteger:modeStr];
    return integer;
}

- (NSString *)binaryStringWithInteger:(NSInteger)value
{
    NSMutableString *string = [NSMutableString string];
    while (value)
    {
        [string insertString:(value & 1)? @"1": @"0" atIndex:0];
        value /= 2;
    }
    //不足8个比特 ，补0
    while (string.length < 8)
    {
        [string insertString:@"0" atIndex:0];
    }
    return string;
}


//NSData类型转换成NSString
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}


//把十进制的数字转化成十六进制
- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str = @"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++)
    {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";
                break;
            case 11:
                nLetterValue =@"B";
                break;
            case 12:
                nLetterValue =@"C";
                break;
            case 13:
                nLetterValue =@"D";
                break;
            case 14:
                nLetterValue =@"E";
                break;
            case 15:
                nLetterValue =@"F";
                break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}


#pragma mark --二进制字符串转成十进制integer类型
- (NSInteger)convertBinaryStrToInteger:(NSString *)binaryStr
{
    NSInteger number = 0;
    if (([binaryStr isKindOfClass:[NSString class]])&& binaryStr.length == 8) {
        for (int i=0; i<8; i++) {
            NSString *str = [binaryStr substringWithRange:NSMakeRange(i, 1)];
            if ([str integerValue] == 1) {
                number = number +pow(2, 7-i);
            }
        }
    }
    return number;
}


@end
