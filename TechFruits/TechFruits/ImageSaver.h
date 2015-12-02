//
//  ImageSaver.h
//  Fruits
//
//  Created by hoangdangtrung on 11/27/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Fruits;
@interface ImageSaver : NSObject
+ (BOOL)saveImageToDisk:(UIImage*)image andToFruit:(Fruits*)fruit;
+ (void)deleteImageAtPath:(NSString*)path;
@end
