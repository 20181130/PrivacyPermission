// PrivacyPermission.m
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


///-------------------------
#pragma mark - DEBUG
///-------------------------
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr, "%s [Line %zd]\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...) nil
#endif

#import "PrivacyPermission.h"

#import <Photos/Photos.h> //获取相册状态权限
#import <AVFoundation/AVFoundation.h> //相机麦克风权限
#import <EventKit/EventKit.h> //日历\备提醒事项权限
#import <Contacts/Contacts.h> //通讯录权限
#import <SafariServices/SafariServices.h>
#import <Speech/Speech.h> //语音识别
#import <HealthKit/HealthKit.h>//运动与健身
#import <MediaPlayer/MediaPlayer.h> //媒体资料库
#import <UserNotifications/UserNotifications.h> //推送权限
#import <CoreBluetooth/CoreBluetooth.h> //蓝牙权限
#import <CoreLocation/CoreLocation.h> //定位权限

static PrivacyPermission *_instance = nil;

static NSInteger const PrivacyPermissionTypeLocationDistanceFilter = 10; //定位精度

@interface PrivacyPermission()
//@property (nonatomic,strong) CLLocationManager *locationManager;
//@property (nonatomic,strong) CBCentralManager *centralManager;
@end

@implementation PrivacyPermission

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(instancetype)copyWithZone:(nullable NSZone *)zone{
    return _instance;
}
-(instancetype)init{
    if (self = [super init]) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.centralManager = [[CBCentralManager alloc] init];
    }
    return self;
}


#pragma mark - Public
-(void)accessPrivacyPermissionWithType:(PrivacyPermissionType)type completion:(void(^)(BOOL response,NSString *status))completion
{
    switch (type) {
        case PrivacyPermissionTypePhoto:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) {
                    completion(NO, @"AuthorizationStatusDenied");
                } else if (status == PHAuthorizationStatusNotDetermined) {
                    completion(NO,@"AuthorizationStatusNotDetermined");
                } else if (status == PHAuthorizationStatusRestricted) {
                    completion(NO, @"AuthorizationStatusRestricted");
                } else if (status == PHAuthorizationStatusAuthorized) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                }
            }];
        }break;
            
        case PrivacyPermissionTypeCamera:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (granted) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO, @"AuthorizationStatusDenied");
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,@"AuthorizationStatusNotDetermined");
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO, @"AuthorizationStatusRestricted");
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeMedia:
        {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                if (status == MPMediaLibraryAuthorizationStatusDenied) {
                    completion(NO, @"AuthorizationStatusDenied");
                } else if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
                    completion(NO,@"AuthorizationStatusNotDetermined");
                } else if (status == MPMediaLibraryAuthorizationStatusRestricted) {
                    completion(NO, @"AuthorizationStatusRestricted");
                } else if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                }
            }];
        }break;
            
        case PrivacyPermissionTypeMicrophone:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                if (granted) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO, @"AuthorizationStatusDenied");
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,@"AuthorizationStatusNotDetermined");
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO, @"AuthorizationStatusRestricted");
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeLocation:{
            if ([CLLocationManager locationServicesEnabled]) {
                CLLocationManager *locationManager = [[CLLocationManager alloc]init];
                [locationManager requestAlwaysAuthorization];
                [locationManager requestWhenInUseAuthorization];
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                locationManager.distanceFilter = PrivacyPermissionTypeLocationDistanceFilter;
                [locationManager startUpdatingLocation];
            }
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusAuthorizedAlways) {
                completion(YES,@"AuthorizationStatusAuthorizedAlways");
            } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                completion(YES,@"AuthorizationStatusAuthorizedWhenInUse");
            } else if (status == kCLAuthorizationStatusDenied) {
                completion(NO,@"AuthorizationStatusDenied");
            } else if (status == kCLAuthorizationStatusNotDetermined) {
                completion(NO,@"AuthorizationStatusNotDetermined");
            } else if (status == kCLAuthorizationStatusRestricted) {
                completion(NO,@"AuthorizationStatusRestricted");
            }
        }break;
            
        case PrivacyPermissionTypeBluetooth:{
            CBCentralManager *centralManager = [[CBCentralManager alloc] init];
            CBManagerState state = [centralManager state];
            if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                completion(NO,@"AuthorizationStatusDenied");
            } else {
                completion(YES,@"AuthorizationStatusAuthorized");
            }
        }break;
            
        case PrivacyPermissionTypePushNotification:{
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            DLog(@"%@",settings);
                        }];
                        completion(YES,@"AuthorizationStatusAuthorized");
                    } else {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
                    }
                }];
            }else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
#pragma clang diagnostic pop
            }
        }break;
            
        case PrivacyPermissionTypeSpeech:{
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
                    completion(NO,@"AuthorizationStatusDenied");
                } else if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
                    completion(NO,@"AuthorizationStatusNotDetermined");
                } else if (status == SFSpeechRecognizerAuthorizationStatusRestricted) {
                    completion(NO,@"AuthorizationStatusRestricted");
                } else if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                }
            }];
        }break;
            
        case PrivacyPermissionTypeEvent:{
            EKEventStore *store = [[EKEventStore alloc]init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,@"AuthorizationStatusDenied");
                    } else if (status == EKAuthorizationStatusNotDetermined) {
                        completion(NO,@"AuthorizationStatusNotDetermined");
                    } else if (status == EKAuthorizationStatusRestricted) {
                        completion(NO,@"AuthorizationStatusRestricted");
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeContact:{
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                if (granted) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                } else {
                    if (status == CNAuthorizationStatusDenied) {
                        completion(NO,@"AuthorizationStatusDenied");
                    }else if (status == CNAuthorizationStatusRestricted){
                        completion(NO,@"AuthorizationStatusNotDetermined");
                    }else if (status == CNAuthorizationStatusNotDetermined){
                        completion(NO,@"AuthorizationStatusRestricted");
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeReminder:{
            EKEventStore *eventStore = [[EKEventStore alloc]init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,@"AuthorizationStatusAuthorized");
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,@"AuthorizationStatusDenied");
                    }else if (status == EKAuthorizationStatusNotDetermined){
                        completion(NO,@"AuthorizationStatusNotDetermined");
                    }else if (status == EKAuthorizationStatusRestricted){
                        completion(NO,@"AuthorizationStatusRestricted");
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeHealth:{
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
                if (![HKHealthStore isHealthDataAvailable]) {
                    NSAssert([HKHealthStore isHealthDataAvailable],@"该设备不支持HealthKit");
                }else{
                    HKHealthStore *store = [[HKHealthStore alloc] init];
                    NSSet *readObjectTypes = [self readObjectTypes];
                    NSSet *writeObjectTypes = [self writeObjectTypes];
                    [store requestAuthorizationToShareTypes:writeObjectTypes readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
                        if (success == YES) {
                            completion(YES,@"AuthorizationStatusAuthorized");
                        }else{
                            completion(NO,error.description);
                        }
                    }];
                }
            }else{
                NSAssert([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0, @"HealthKit暂不支持iOS8以下系统,请更新你的系统。");
            }
        }break;
            
        default:
            break;
    }
}

#pragma mark - Private
-(NSSet *)readObjectTypes{
    HKQuantityType *StepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *DistanceWalkingRunning= [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKObjectType *FlightsClimbed = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    return [NSSet setWithObjects:StepCount,DistanceWalkingRunning,FlightsClimbed, nil];
}
-(NSSet *)writeObjectTypes{
    HKQuantityType *StepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *DistanceWalkingRunning= [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKObjectType *FlightsClimbed = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    return [NSSet setWithObjects:StepCount,DistanceWalkingRunning,FlightsClimbed, nil];
}

@end
