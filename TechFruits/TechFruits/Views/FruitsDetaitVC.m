//
//  FruitsDetaitVC.m
//  TechFruits
//
//  Created by TaiND on 12/1/15.
//  Copyright (c) 2015 Toan Lai. All rights reserved.
//

#import "FruitsDetaitVC.h"
#import "FruitsDetail.h"
#import "Fruits.h"
#import "AMRatingControl.h"
#import "ImageSaver.h"

@interface FruitsDetaitVC ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@end

@implementation FruitsDetaitVC{
    BOOL isEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //check entity is exist
    if (!self.fruit) {
        self.fruit = [Fruits createEntity];
        isEdit = NO;
    }else{
        isEdit = YES;
    }
    
    //check entity's detail exist
    if (!self.fruit.fruitsDetail) {
        self.fruit.fruitsDetail = [FruitsDetail createEntity];
    }
    
    //set info of fruit if click cell edit
    self.title = self.fruit.name ? self.fruit.name : @"New Fruit";
    self.fruitName.text = self.fruit.name;
    self.fruitNote.text = self.fruit.fruitsDetail.note;
    self.ratingControl.rating = [self.fruit.fruitsDetail.rating integerValue];
    
    [self.ratingView addSubview:self.ratingControl];
    
    //set image for fruit if image path is exist
    if ([self.fruit.fruitsDetail.image length] >  0) {
        NSData *imageData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:self.fruit.fruitsDetail.image]];
        [self setImageForFruit:[UIImage imageWithData:imageData]];
    }
    
    //add tap gesture recognizer for image's fruit
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
    self.fruitImage.userInteractionEnabled = YES;
    self.fruitImage.multipleTouchEnabled = YES;
    [self.fruitImage addGestureRecognizer:tap];
    
    //set textview
    self.fruitNote.layer.cornerRadius = 10.0;
    self.fruitNote.layer.borderColor = [[UIColor blackColor] CGColor];
    self.fruitNote.layer.borderWidth = 1.0;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.fruitName resignFirstResponder];
    [self.fruitNote resignFirstResponder];
    
    [self saveContext];
}

#pragma mark - Rating control
-(void)updateRating{
    self.fruit.fruitsDetail.rating = @(self.ratingControl.rating);
}

/**
 *  Setting AMRatingControl for fruit
 *
 *  @return ratingControl
 */
-(AMRatingControl*)ratingControl{
    if (!_ratingControl) {
        _ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                        emptyImage:[[UIImage imageNamed:@"star-empty"] convertToSize:CGSizeMake(20, 20)]
                                                        solidImage:[[UIImage imageNamed:@"star-full"] convertToSize:CGSizeMake(20, 20)] andMaxRating:5];
        _ratingControl.starSpacing = 5;
        [_ratingControl addTarget:self action:@selector(updateRating) forControlEvents:UIControlEventEditingChanged];
    }
    return _ratingControl;
}

#pragma mark - Image capture
-(IBAction)takePicture:(UITapGestureRecognizer*)sender{
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"Pick Photo"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [sheet showInView:self.navigationController.view];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //get image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //delete old image
    if (self.fruit.fruitsDetail.image) {
        [ImageSaver deleteImageAtPath:self.fruit.fruitsDetail.image];
    }
    
    //save new image
    if ([ImageSaver saveImageToDisk:image andToFruit:self.fruit]) {
        [self setImageForFruit:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;
            
        case 1:{
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            
        default:
            break;
    }
}

#pragma mark - textfield
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.title = textField.text;
        self.fruit.name = textField.text;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.fruit.fruitsDetail.note = textView.text;
    }
}

#pragma mark - handle
-(void)setImageForFruit:(UIImage*)img{
    self.fruitImage.image = img;
    self.fruitImage.backgroundColor = [UIColor clearColor];
}

-(void)cancelAdd{
    if (!isEdit) {
        [self.fruit deleteEntity];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNewFruit{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveContext{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Success");
        }
        else{
            NSLog(@"Error: %@", error.description);
        }
    }];
}

-(IBAction)didFinishEdittingFruit:(id)sender{
    [self.fruitName resignFirstResponder];
}


@end
