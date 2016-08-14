//
//  AddCarViewController.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "AddCarViewController.h"
#import "AddCarPhotoTableViewCell.h"
#import "MultiLabeledTableViewCell.h"
#import "KeyboardHandler.h"
#import "CarModel.h"


#import <MagicalRecord/MagicalRecord.h>

typedef NS_ENUM(NSInteger, AddCarCellType) {
    AddCarCellTypeScroll,
    AddCarCellTypeTitle,
    AddCarCellTypePrice,
    AddCarCellTypeEngine,
    AddCarCellTypeCondition,
    AddCarCellTypeTransmission,
    AddCarCellTypeDescription,
    AddCarCellTypeCount
};

static NSString * const kAddCarPhotoTableViewCell = @"AddCarPhotoTableViewCell";
static NSString * const kAddCarTitleInputCell = @"AddCarTitleInputCell";
static NSString * const kAddCarPickerCell = @"AddCarPickerCell";
static NSString * const kAddCarTextViewCell = @"AddCarTextViewCell";

@interface AddCarViewController() <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addCarTableView;

@property (strong, nonatomic) NSArray<CarConditionModel*> *conditionsArray;
@property (strong, nonatomic) NSArray<CarTransmissionModel*> *transmissionsArray;
@property (strong, nonatomic) NSArray<CarEngineModel*> *enginesArray;

@property (strong, nonatomic) NSMutableArray *carImages;

@property (strong, nonatomic) NSMutableDictionary *dynamicModel;

@property (strong, nonatomic) KeyboardHandler *keyboardHandler;

@end

@implementation AddCarViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardHandler = [[KeyboardHandler alloc] initWithScrollView:self.addCarTableView];
    
    self.carImages = [NSMutableArray new];
    
    self.conditionsArray = [CarConditionModel MR_findAllSortedBy:@"condition" ascending:YES];
    self.transmissionsArray = [CarTransmissionModel MR_findAllSortedBy:@"transmission" ascending:YES];
    self.enginesArray = [CarEngineModel MR_findAllSortedBy:@"engine" ascending:YES];
    
    NSInteger carID = [CarModel MR_countOfEntities];
    NSMutableDictionary *dynamicModel = [NSMutableDictionary new];
    dynamicModel[kCarID] = @(carID);
    dynamicModel[kCarName] = @"";
    dynamicModel[kCarPrice] = @"";
    dynamicModel[kCarDescription] = @"";
    dynamicModel[kCarEngine] = self.enginesArray.firstObject;
    dynamicModel[kCarCondition] = self.conditionsArray.firstObject;
    dynamicModel[kCarTransmission] = self.transmissionsArray.firstObject;
    self.dynamicModel = dynamicModel;
    
    self.addCarTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

#pragma mark - UITableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AddCarCellTypeCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == AddCarCellTypeScroll) {
        return [self prepareAddScrollTableViewCellWithTableView:tableView];
    } else {
        return [self prepareAddEditableCellWithType:indexPath.row tableView:tableView];
    }
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForAddRowWithType:indexPath.row tableView:tableView];
}

#pragma mark - Add Car Helpers

-(CGFloat)heightForAddRowWithType:(AddCarCellType)type tableView:(UITableView*)tableView {
    switch (type) {
        case AddCarCellTypeScroll: return 120.0f;
        case AddCarCellTypeTitle:
        case AddCarCellTypePrice: return 43.0f;
        case AddCarCellTypeEngine:
        case AddCarCellTypeCondition:
        case AddCarCellTypeTransmission: return 30.0f;
        case AddCarCellTypeDescription: return 150.0f;
            
        default: return 0.001f;
    }
}

-(UITableViewCell*)prepareAddScrollTableViewCellWithTableView:(UITableView*)tableView {
    AddCarPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddCarPhotoTableViewCell class])];
    cell.images = self.carImages;
    __weak typeof(self) _weakSelf = self;
    cell.didPressAddPhotoCell = ^(AddCarPhotoTableViewCell *addCarCell) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.editing = NO;
        imagePicker.delegate = _weakSelf;
        
        [_weakSelf presentViewController:imagePicker animated:YES completion:nil];
    };
    return cell;
}

-(UITableViewCell*)prepareAddEditableCellWithType:(AddCarCellType)type tableView:(UITableView*)tableView {
    MultiLabeledTableViewCell *cell;
    
    switch (type) {
        case AddCarCellTypeTitle: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarTitleInputCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-car", nil);
            cell.inputTextField.tag = type;
            break;
        }
        case AddCarCellTypePrice: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarTitleInputCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-price", nil);
            cell.inputTextField.tag = type;
            break;
        }
        case AddCarCellTypeCondition: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarPickerCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-condition", nil);
            cell.inputTextField.text = NSLocalizedString(((CarConditionModel*)self.dynamicModel[kCarCondition]).condition, nil);
            [self addInputViewToTextField:cell.inputTextField type:type];
            break;
        }
        case AddCarCellTypeTransmission: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarPickerCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-transmission", nil);
            cell.inputTextField.text = NSLocalizedString(((CarTransmissionModel*)self.dynamicModel[kCarTransmission]).transmission, nil);
            [self addInputViewToTextField:cell.inputTextField type:type];
            break;
        }
        case AddCarCellTypeEngine: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarPickerCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-engine", nil);
            cell.inputTextField.text = NSLocalizedString(((CarEngineModel*)self.dynamicModel[kCarEngine]).engine, nil);
            [self addInputViewToTextField:cell.inputTextField type:type];
            break;
        }
        case AddCarCellTypeDescription: {
            cell = [tableView dequeueReusableCellWithIdentifier:kAddCarTextViewCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-description", nil);
            cell.inputTextView.delegate = self;
            cell.inputTextView.text = self.dynamicModel[kCarDescription];
            break;
        }
        default: break;
    }
    cell.tag = type;
    cell.inputTextField.delegate = self;
    
    return cell;
}

#pragma mark - Button Actions

-(IBAction)doneBarButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];

    NSInteger totalImages = [CarImagesModel MR_countOfEntities];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSInteger currentIndex = totalImages;
        CarModel *car = [CarModel MR_createEntityInContext:localContext];
        CarEngineModel *engine = [self.dynamicModel[kCarEngine] MR_inContext:localContext];
        self.dynamicModel[kCarEngine] = engine;
        CarConditionModel *condition = [self.dynamicModel[kCarCondition] MR_inContext:localContext];
        self.dynamicModel[kCarCondition] = condition;
        CarTransmissionModel *transmission = [self.dynamicModel[kCarTransmission] MR_inContext:localContext];
        self.dynamicModel[kCarTransmission] = transmission;
        [car updateWithJSON:self.dynamicModel];
        for (UIImage *image in self.carImages) {
            NSString *path = [NSString stringWithFormat:@"IMG_%li.jpg", (long)currentIndex++];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:path];
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [data writeToFile:filePath atomically:YES];
            CarImagesModel *imageModel = [CarImagesModel MR_createEntityInContext:localContext];
            imageModel.imagePath = path;
            [car addCarImagesObject:imageModel];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if(self.shouldSaveCarValueUpdated) {
            self.shouldSaveCarValueUpdated(YES);
        }
    }];
}

-(void)doneToolbarBarButtonPressed:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

#pragma mark - UIPickerView Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0f;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch ((AddCarCellType)pickerView.tag) {
        case AddCarCellTypeCondition: return self.conditionsArray.count;
        case AddCarCellTypeEngine: return self.enginesArray.count;
        case AddCarCellTypeTransmission: return self.transmissionsArray.count;
            
        default: return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch ((AddCarCellType)pickerView.tag) {
        case AddCarCellTypeCondition: return NSLocalizedString(self.conditionsArray[row].condition, nil);
        case AddCarCellTypeEngine: return  NSLocalizedString(self.enginesArray[row].engine, nil);
        case AddCarCellTypeTransmission: return NSLocalizedString(self.transmissionsArray[row].transmission, nil);
        default: return @"";
    }
}

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value;
    switch ((AddCarCellType)pickerView.tag) {
        case AddCarCellTypeEngine: {
            CarEngineModel *engine = self.enginesArray[row];
            value = NSLocalizedString(engine.engine, nil);
            self.dynamicModel[kCarEngine] = engine; break;
        }
        case AddCarCellTypeCondition:{
            CarConditionModel *condition = self.conditionsArray[row];
            value = NSLocalizedString(condition.condition, nil);
            self.dynamicModel[kCarCondition] = condition; break;
        }
        case AddCarCellTypeTransmission: {
            CarTransmissionModel *transmission = self.transmissionsArray[row];
            value = NSLocalizedString(transmission.transmission, nil);
            self.dynamicModel[kCarTransmission] = transmission; break;
        }
        default: break;
    }
    
    MultiLabeledTableViewCell *cell = [self.addCarTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pickerView.tag inSection:0]];
    cell.inputTextField.text = value;
}

#pragma mark - UIImagePickerController Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *photo = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (photo) {
        [self.carImages addObject:photo];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AddCarCellTypeScroll inSection:0];
        [self.addCarTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch ((AddCarCellType)textField.tag) {
        case AddCarCellTypeTitle:
            self.dynamicModel[kCarName] = textField.text;
            break;
        case AddCarCellTypePrice:
            self.dynamicModel[kCarPrice] = textField.text;
            break;
        default: break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegate

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.dynamicModel[kCarDescription] = textView.text;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Helpers

-(void)addInputViewToTextField:(UITextField*)textField type:(AddCarCellType)type {
    UIPickerView *picker = [UIPickerView new];
    picker.tag = type;
    picker.delegate = self;
    picker.dataSource = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 44.0f)];
    toolbar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneToolbarBarButtonPressed:)];
    button.tintColor = [UIColor whiteColor];
    [toolbar setItems:@[flexibleSpaceLeft, button]];
    textField.inputView = picker;
    textField.inputAccessoryView = toolbar;
}

@end
