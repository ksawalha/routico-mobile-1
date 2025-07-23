// SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
// SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
//
// Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
// intellectual property and proprietary rights in and to this material, related
// documentation and any modifications thereto. Any use, reproduction,
// disclosure or distribution of this material and related documentation
// without an express license agreement from Magic Lane Intellectual Property B.V. 
// or its affiliates is strictly prohibited.

#import <Foundation/Foundation.h>
#import <GEMKit/ContentStoreObject.h>

/**
 * Constants indicating the unit system.
 */
typedef NS_ENUM(NSInteger, HumanVoiceGender)
{
    /// Male
    HumanVoiceGenderMale = 0,
    
    /// Female
    HumanVoiceGenderFemale,
    
    /// Computer
    HumanVoiceGenderComputer
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class handles the sound.
 */
__attribute__((visibility("default"))) @interface HumanVoiceContext : NSObject

/**
 * Check if the online human voices content is preloaded.
 * @details If the content is not cached locally a call to preloadContentWithCompletionHandler must be performed.
 */
- (BOOL)isContentPreloaded;

/**
 * Preload the online human voices content.
 */
- (void)preloadContentWithCompletionHandler:(void(^)(BOOL success))handler;

/**
 * Returns the local human voices list.
 */
- (nonnull NSArray<ContentStoreObject *> *)getLocalList;

/**
 * Asynchronously returns the online human voices list.
 */
- (void)getOnlineListWithCompletionHandler:(nonnull void(^)(NSArray<ContentStoreObject *> *array))handler;

/**
 * Start a download request for the given human voice identifier.
 * @param identifier The voice identifier.
 * @param allow The flag whether to allow charged networks.
 * @param handler The block to execute asynchronously with the result.
 */
- (void)downloadVoiceWithIdentifier:(NSInteger)identifier allowCellularNetwork:(BOOL)allow completionHandler:(nonnull void(^)(BOOL success))handler;

/**
 * Returns the human voice country image flag.
 * @param code The country code.
 * @param size The image size in pixels.
 */
- (nullable UIImage*)getCountryFlagWithIsoCode:(nonnull NSString*)code size:(CGSize)size;

/**
 * Returns the human voice gender.
 * @param object The content store item.
 */
- (HumanVoiceGender)getHumanVoiceGenderWithContentStoreObject:(nonnull ContentStoreObject *)object;

/**
 * Returns the human voice country name.
 * @param code The country code.
 */
- (nonnull NSString*)getCountryName:(nonnull NSString*)code;

/**
 * Returns the human voice native language.
 * @param object The content store item.
 */
- (nonnull NSString*)getNativeLanguage:(nonnull ContentStoreObject *)object;

/**
 * Returns the human voice gender image.
 * @param gender The human voice gender.
 * @param size The image size in pixels.
 */
- (nullable UIImage*)getGenderImage:(HumanVoiceGender)gender size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
