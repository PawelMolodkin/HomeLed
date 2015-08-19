//
//  HLSlider.h
//  HomeLed
//
//  Created by Pavel Molodkin on 18.08.15.
//  Copyright © 2015 Voevoda's Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLSlider : UIView

@property(copy, nonatomic) dispatch_block_t valueChangedBlock;
@property(assign, nonatomic) CGFloat value;

@end
