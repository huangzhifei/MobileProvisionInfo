//
//  MobileProvisionInfo.m
//
//  Created by eric on 2019/6/22.
//

#import "MobileProvisionInfo.h"

@interface MobileProvisionInfo ()

@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *bundleID;

@end

@implementation MobileProvisionInfo

+ (instancetype)shareInstance {
    static MobileProvisionInfo *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MobileProvisionInfo alloc] init];
        [_instance read];
    });
    return _instance;
}

#pragma mark - Private Methods

- (void)read {
    // 读取 ipa 包中的 embedded.mobileprovision 文件内容, 真实内容是 xml 格式
    // 描述文件路径
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    // 读取application-identifier 注意描述文件的编码要使用:NSASCIIStringEncoding
    NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
    NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (int i = 0; i < embeddedProvisioningLines.count; i++) {
        if ([embeddedProvisioningLines[i] rangeOfString:@"com.apple.security.application-groups"].location != NSNotFound) {
            // application-identifier
            NSInteger fromPosition = [embeddedProvisioningLines[i + 2] rangeOfString:@"<string>"].location + 8;
            NSInteger toPosition = [embeddedProvisioningLines[i + 2] rangeOfString:@"</string>"].location;

            NSRange range;
            range.location = fromPosition;
            range.length = toPosition - fromPosition;

            NSString *group = [embeddedProvisioningLines[i + 2] substringWithRange:range];
            self.groupID = group;
        } else if ([embeddedProvisioningLines[i] rangeOfString:@"application-identifier"].location != NSNotFound) {
            // com.apple.security.application-groups
            NSInteger fromPosition = [embeddedProvisioningLines[i + 1] rangeOfString:@"<string>"].location + 8;
            NSInteger toPosition = [embeddedProvisioningLines[i + 1] rangeOfString:@"</string>"].location;

            NSRange range;
            range.location = fromPosition;
            range.length = toPosition - fromPosition;

            self.appID = [embeddedProvisioningLines[i + 1] substringWithRange:range];
            NSArray *identifierComponents = [self.appID componentsSeparatedByString:@"."];
            self.teamID = [identifierComponents firstObject];
            NSString *replaceStr = [NSString stringWithFormat:@"%@.", self.teamID];
            self.bundleID = [self.appID stringByReplacingOccurrencesOfString:replaceStr withString:@""];
        }

        if (self.teamID.length > 0 && self.appID.length > 0 && self.groupID.length > 0) {
            break;
        }
    }
}

#pragma mark - Public Methods

- (void)checkAndProtectWithAppIdentifier:(NSString *)appID {
    // 对比签名ID
    if (![self.appID isEqual:appID] && appID.length > 0) {
        //exit
        exit(1);
    }
}

#pragma mark - Getter

- (NSString *)getTeamIdentifier {
    return self.teamID;
}

- (NSString *)getAppIdentifier {
    return self.appID;
}

- (NSString *)getGroupIdentifier {
    return self.groupID;
}

- (NSString *)getBundleIdentifier {
    return self.bundleID;
}

@end
