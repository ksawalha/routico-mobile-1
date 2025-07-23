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

/**
 * Constants indicating the contact info field type.
 */
typedef NS_ENUM(NSInteger, ContactInfoFieldType)
{
    /// Phone.
    ContactInfoFieldTypePhone,
    
    /// Email.
    ContactInfoFieldTypeEmail,
    
    /// URL.
    ContactInfoFieldTypeUrl,
    
    /// Booking URL.
    ContactInfoFieldTypeBooking,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * This class encapsulates contact information.
 */
__attribute__((visibility("default"))) @interface ContactInfoObject : NSObject

/**
 * Initializes and returns a newly allocated object using the model data.
 */
- (instancetype)initWithModelData:(void*)data NS_SWIFT_UNAVAILABLE("Internal use only.");

/**
 * Returns the model data.
 */
- (nullable void *)getModelData;

/**
 * Returns the field count.
 */
- (int)getFieldsCount;

/**
 * Returns the field type.
 */
- (ContactInfoFieldType)getFieldType:(int)index;

/**
 * Returns the field name.
 */
- (nonnull NSString *)getFieldName:(int)index;

/**
 * Returns the field value.
 */
- (nonnull NSString *)getFieldValue:(int)index;

/**
 * Sets field type, value and name.
 */
- (void)setField:(int)index type:(ContactInfoFieldType)fieldType value:(nonnull NSString *)value name:(nonnull NSString *)name;

/**
 * Adds a new field.
 */
- (void)addField:(ContactInfoFieldType)fieldType value:(nonnull NSString *)value name:(nonnull NSString *)name;

/**
 * Removes a field specified by index.
 */
- (void)removeField:(int)index;

@end

NS_ASSUME_NONNULL_END
