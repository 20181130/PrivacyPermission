// PrivacyPermission.h
//
// Copyright (c) 2017 BANYAN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PrivacyPermissionType) {
    PrivacyPermissionTypePhoto = 0, //相册
    PrivacyPermissionTypeCamera, //相机
    PrivacyPermissionTypeMedia, //媒体资料库
    PrivacyPermissionTypeMicrophone, //麦克风
    PrivacyPermissionTypeLocation, //位置
    PrivacyPermissionTypeBluetooth, //蓝牙
    PrivacyPermissionTypePushNotification, //推送
    PrivacyPermissionTypeSpeech, //语音识别
    PrivacyPermissionTypeEvent, //日历
    PrivacyPermissionTypeContact, //通讯录
    PrivacyPermissionTypeReminder, //提醒事项
    PrivacyPermissionTypeHealth, //运动与健身  //暂时只有步数,步行+跑步距离和以爬楼层三种读写权限，如果想要访问更多HealthKit权限请参考 https://github.com/GREENBANYAN/skoal
};

@interface PrivacyPermission : NSObject

+(instancetype)sharedInstance;

-(void)accessPrivacyPermissionWithType:(PrivacyPermissionType)type completion:(void(^)(BOOL response,NSString *status))completion;

@end
