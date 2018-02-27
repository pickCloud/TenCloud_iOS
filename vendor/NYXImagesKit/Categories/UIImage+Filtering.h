//
//  UIImage+Filters.h
//  NYXImagesKit
//
//  Created by @Nyx0uf on 02/05/11.
//  Copyright 2012 Nyx0uf. All rights reserved.
//  www.cocoaintheshell.com
//


#import "NYXImagesHelper.h"


@interface UIImage (NYX_Filtering)

-(UIImage*)brightenWithValue:(float)factor;

-(UIImage*)contrastAdjustmentWithValue:(float)value;

-(UIImage*)edgeDetectionWithBias:(NSInteger)bias;

-(UIImage*)embossWithBias:(int32_t)bias;

-(UIImage*)gammaCorrectionWithValue:(float)value;

-(UIImage*)grayscale;

-(UIImage*)invert;

-(UIImage*)opacity:(float)value;

-(UIImage*)sepia;

-(UIImage*)sharpenWithBias:(int32_t)bias;

-(UIImage*)unsharpenWithBias:(int32_t)bias;

@end
