//
//  UIImage+StatusLane.h
//  Status Lane
//
//  Created by Jonathan Aguele on 14/06/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (StatusLane)

+(UIImage*)grayishImage:(UIImage*)inputImage;
+(UIImage*)flipPicture:(UIImage*)picture;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(UIImage *)shrinkImage:(UIImage *)image;
+(BOOL)isImageToLarge:(UIImage *)image;

@end
