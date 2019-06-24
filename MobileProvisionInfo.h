//
//  MobileProvisionInfo.h
//
//  Created by eric on 2019/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 iOS 安全防护之重签名防护，通过读取 embedded.mobileprovision ，取出里面相关信息比较
 注意：
 embedded.mobileprovision
 1、在 App Store 下载的 App 中不会存在，
 2、在模拟器 build 包也不会存在
 */
@interface MobileProvisionInfo : NSObject

+ (instancetype)shareInstance;

/**
 通过传入真实 AppIdentifier 来检查包是否为重签名的包
 */
- (void)checkAndProtectWithAppIdentifier:(NSString *)appID;

/**
 com.apple.developer.team-identifier

 @return team identifier
 */
- (NSString *)getTeamIdentifier;

/**
 application-identifier

 @return app identifier
 */
- (NSString *)getAppIdentifier;

/**
 com.apple.security.application-groups

 @return group id
 */
- (NSString *)getGroupIdentifier;

/**
 bunlde Identifier 与 AppIdentifier 区别是少个 team 头

 @return bundle id
 */
- (NSString *)getBundleIdentifier;

@end

NS_ASSUME_NONNULL_END
