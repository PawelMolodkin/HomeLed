//
//  HLRemoteClient.h
//  HomeLed
//
//  Created by ANDREI VAYAVODA on 04.08.15.
//  Copyright (c) 2015 Voevoda's Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLRemoteClient : NSObject

+ (void)setColor:(UIColor *)color;

+ (void)setColorsList:(NSArray *)colorsList;

@end
