//
//  AppDelegate.m
//
//  Created by eric on 2019/6/22.
//

#import "AppDelegate.h"
#import "MobileProvisionInfo.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// 传入正确的 identifier 去作为检查目标
    [[MobileProvisionInfo shareInstance] checkAndProtectWithAppIdentifier:@"xxxxxxx"];
    
    return YES;
}

@end
