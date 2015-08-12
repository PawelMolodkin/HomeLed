//
//  HLSettings.h
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 06.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSettings : NSObject

@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSNumber *port;
@property (strong, nonatomic) UIColor *entireStripColor;
@property (strong, nonatomic) NSArray *multiColorsList;
@property (strong, nonatomic) NSArray *previousColorsList;
@property (strong, nonatomic) NSArray *savedColorsArray;

+ (instancetype)shared;

@end
