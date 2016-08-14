//
//  MainPageViewController.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "MainPageViewController.h"
#import "MainPageCarTableViewCell.h"
#import "MainPageWeatherTableViewCell.h"
#import "CarDetailsViewController.h"
#import "AddCarViewController.h"
#import "UIImage+ImageWithPath.h"
#import "TestWebService.h"

#import "CarModel.h"
#import "WeatherModel.h"

#import <MagicalRecord/MagicalRecord.h>

static NSString * const kShowCarSegue = @"showCarSegue";
static NSString * const kAddCarSegue = @"addCarSegue";

@interface MainPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) WeatherModel *currentWeather;
@property (strong, nonatomic) NSMutableArray<CarModel*> *cars;
@property (strong, nonatomic) NSMutableDictionary *images;

@property (strong, nonatomic) CarModel *selectedCar;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [NSMutableDictionary new];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    [self cleanupDataBase];
//    [self setupCarData];

    if(![CarEngineModel MR_findAll].count) {
        [self cleanupDataBase];
        [self setupCarData];
    }
    
    self.cars = [CarModel MR_findAllSortedBy:@"carID" ascending:YES].mutableCopy;
    self.currentWeather = [WeatherModel MR_findFirst];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCurrentWeather];
    self.selectedCar = nil;
}

#pragma mark - Web Service

-(void)requestCurrentWeather {
    BaseDTO *weatherDTO = [DTOWrapper getWeatherDTOWithLongitude:0 latitude:0];
    TestWebService *webService = [TestWebService new];
    webService.parseCompletionBlock = ^id(NSURLSessionDataTask *task, id response) {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            [WeatherModel MR_truncateAll];
            WeatherModel *model = [WeatherModel MR_createEntityInContext:localContext];
            [model updateWithJSON:response];
        }];
        WeatherModel *model = [WeatherModel MR_findAll].firstObject;
        return model;
    };
    [webService requestWithDTO:weatherDTO completion:^(NSURLSessionDataTask *task, WeatherModel *response) {
        if([response isKindOfClass:[WeatherModel class]]) {
            self.currentWeather = response;
        }
    }];
}

#pragma mark - UITableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.currentWeather ? 1 : 0;
    } else {
        return self.cars.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MainPageWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainPageWeatherTableViewCell class])];
        
        cell.weatherDescriptionLabel.text = self.currentWeather.weatherDescription;
        cell.temperatureLabel.text = self.currentWeather.weatherTemperature;
        cell.locationLabel.text = self.currentWeather.weatherCityName;
        [TestWebService loadImageWithString:self.currentWeather.weatherIconURL forImageView:cell.weatherIconImageView];
        
        return cell;
    } else {
        MainPageCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainPageCarTableViewCell class])];
        
        CarModel *model = self.cars[indexPath.row];
        if(model.carImages.allObjects.count) {
            NSArray *images = [model.carImages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"imagePath" ascending:YES]]];
            CarImagesModel *imageModel = images.firstObject;
            __block UIImage *image = self.images[imageModel.imagePath];
            if(!image) {
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    image = [UIImage imageWithPath:imageModel.imagePath];
                    [self.images setObject:image forKey:imageModel.imagePath];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        cell.carImageView.image = image;
                    });
                });
            } else {
                cell.carImageView.image = image;
            }
        }
        cell.carNameLabel.text = model.carName;
        cell.carPriceLabel.text = model.carPrice;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGRectGetWidth(tableView.bounds) * 0.557f; // cell ratio depending on desings
    } else {
        return 70.0f;
    }
}

#pragma mark - UITableView Delegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        self.selectedCar = self.cars[indexPath.row];
        [self performSegueWithIdentifier:kShowCarSegue sender:self];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        CarModel *car = self.cars[indexPath.row];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        for (CarImagesModel *image in car.carImages) {
            NSError *error;
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:image.imagePath];
            [fileManager removeItemAtPath:filePath error:&error];
        }
        [self.cars removeObjectAtIndex:indexPath.row];
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            CarModel *model = [car MR_inContext:localContext];
            [model MR_deleteEntityInContext:localContext];
        }];
    }
}

#pragma mark - Setters

-(void)setCars:(NSMutableArray<CarModel *> *)cars {
    BOOL fade = _cars.count;
    _cars = cars;
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:fade ? UITableViewRowAnimationFade : UITableViewRowAnimationTop];
    
}

-(void)setCurrentWeather:(WeatherModel *)currentWeather {
    BOOL fade = _currentWeather;
    if(!currentWeather) {
        fade = YES;
    }
    _currentWeather = currentWeather;
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if(currentWeather) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            [WeatherModel MR_truncateAllInContext:localContext];
            WeatherModel *model = [WeatherModel MR_createEntityInContext:localContext];
            [model updateWithModel:currentWeather];
        }];
    }
}

#pragma mark - Fake DB Setup

-(void)setupCarData {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [CarConditionModel MR_truncateAllInContext:localContext];
        NSArray *conditionArray = @[@"condition-bad", @"condition-good", @"condition-excellent", @"condition-new"];
        for (NSString *condition in conditionArray) {
            CarConditionModel *model = [CarConditionModel MR_createEntityInContext:localContext];
            model.condition = condition;
        }
        
        [CarEngineModel MR_truncateAllInContext:localContext];
        NSArray *engineArray = @[@"2.0 R4 16v FSI (EA113)", @"1.8 R4 16v TSI/TFSI (EA888)", @"1.6 R4 16v", @"1.6 R4", @"1.4 R4 16v TSI/TFSI"];
        for (NSString *engine in engineArray) {
            CarEngineModel *model = [CarEngineModel MR_createEntityInContext:localContext];
            model.engine = engine;
        }
        
        [CarTransmissionModel MR_truncateAllInContext:localContext];
        NSArray *transmissionArray = @[@"transmission-manual", @"transmission-semi-automatic", @"transmission-automatic"];
        for (NSString *transmission in transmissionArray) {
            CarTransmissionModel *model = [CarTransmissionModel MR_createEntityInContext:localContext];
            model.transmission = transmission;
        }
        
        [CarImagesModel MR_truncateAllInContext:localContext];
        [CarModel MR_truncateAllInContext:localContext];
    }];
}

-(void)cleanupDataBase {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURL *dbURL = [NSPersistentStore MR_urlForStoreName:@"SKTestApp.sqlite"];
    dbURL = [dbURL URLByDeletingLastPathComponent];
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:dbURL.path error:nil];
    for (NSString *sqliteFile in allFiles) {
        NSError *error = nil;
        NSString *item = [dbURL.path stringByAppendingPathComponent:sqliteFile];
        [manager removeItemAtPath:item error:&error];
        NSAssert(!error, @"Assertion: SQLite file deletion shall never throw an error.");
    }
    
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStack];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kShowCarSegue]) {
        CarDetailsViewController *carDetailsViewController = segue.destinationViewController;
        carDetailsViewController.car = self.selectedCar;
    } else if([segue.identifier isEqualToString:kAddCarSegue]) {
        AddCarViewController *addCarViewController = segue.destinationViewController;
        __weak typeof(self) _weakSelf = self;
        addCarViewController.shouldSaveCarValueUpdated = ^(BOOL shouldSaveCar) {
            if(shouldSaveCar) {
                _weakSelf.cars = [CarModel MR_findAllSortedBy:@"carID" ascending:YES].mutableCopy;
                [_weakSelf.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.cars.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        };
    }
}

@end
