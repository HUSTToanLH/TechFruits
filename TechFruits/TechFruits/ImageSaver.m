//
//  ImageSaver.m
//  Fruits
//
//  Created by hoangdangtrung on 11/27/15.
//  Copyright © 2015 hoangdangtrung. All rights reserved.
//

#import "ImageSaver.h"
#import "Fruits.h"
#import "FruitsDetail.h"
@implementation ImageSaver
+ (BOOL)saveImageToDisk:(UIImage*)image andToFruit:(Fruits*)fruit {
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
    NSString *name    = [[NSUUID UUID] UUIDString];
    NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    if ([imgData writeToFile:jpgPath atomically:YES]) {
        fruit.fruitsDetail.image = path;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"There was an error saving your photo. Try again."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return NO;
    }
    return YES;
}
+ (void)deleteImageAtPath:(NSString *)path {
    NSError *error;
    NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
}
@end
