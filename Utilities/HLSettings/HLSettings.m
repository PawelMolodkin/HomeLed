//
//  HLSettings.m
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 06.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import "HLSettings.h"

@implementation HLSettings {
    NSUserDefaults *_userDefaults;
}

+ (instancetype)shared {
    static HLSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HLSettings new];
    });
    return sharedInstance;
}

#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        if (!self.multiColorsList) {
            [self resetToDefaults];
        }
    }
    return self;
}

- (void)resetToDefaults {
    self.ipAddress = @"192.168.100.12";
    self.port = @(8090);
    self.entireStripColor = [UIColor colorWithRed:255 green:128 blue:0 alpha:1.f];
    self.multiColorsList = @[[UIColor redColor], [UIColor greenColor]];
}

#pragma mark - Accessors
- (NSString *)ipAddress {
    return [_userDefaults stringForKey:@"ipAddress"];
}

- (void)setIpAddress:(NSString *)ipAddress {
    [_userDefaults setObject:ipAddress forKey:@"ipAddress"];
    [self synchronize];
}

- (NSNumber *)port {
    return [_userDefaults objectForKey:@"port"];
}

- (void)setPort:(NSNumber *)port {
    [_userDefaults setObject:port forKey:@"port"];
    [self synchronize];
}

- (UIColor *)entireStripColor {
    NSData *data = [_userDefaults dataForKey:@"entireStripColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setEntireStripColor:(UIColor *)entireStripColor {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:entireStripColor];
    [_userDefaults setObject:data forKey:@"entireStripColor"];
    [self synchronize];
}

- (NSArray *)multiColorsList {
    NSData *data = [_userDefaults dataForKey:@"multiColorsList"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)setMultiColorsList:(NSArray *)multiColorsList {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:multiColorsList];
    [_userDefaults setObject:data forKey:@"multiColorsList"];
    [self synchronize];
}

#pragma mark - Private Methods
- (void)synchronize {
    [_userDefaults synchronize];
}
@end
