//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

#import "OWSReadTracking.h"
#import "TSMessage.h"

NS_ASSUME_NONNULL_BEGIN

@class SDSAnyWriteTransaction;
@class SignalServiceAddress;
@class TSContactThread;
@class TSGroupThread;

@interface TSIncomingMessage : TSMessage <OWSReadTracking>

@property (nonatomic, readonly, nullable) NSNumber *serverTimestamp;

@property (nonatomic, readonly) BOOL wasReceivedByUD;

- (instancetype)initMessageWithTimestamp:(uint64_t)timestamp
                                inThread:(TSThread *)thread
                             messageBody:(nullable NSString *)body
                           attachmentIds:(NSArray<NSString *> *)attachmentIds
                        expiresInSeconds:(uint32_t)expiresInSeconds
                         expireStartedAt:(uint64_t)expireStartedAt
                           quotedMessage:(nullable TSQuotedMessage *)quotedMessage
                            contactShare:(nullable OWSContact *)contactShare
                             linkPreview:(nullable OWSLinkPreview *)linkPreview
                          messageSticker:(nullable MessageSticker *)messageSticker
                       isViewOnceMessage:(BOOL)isViewOnceMessage NS_UNAVAILABLE;
- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
           receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                        sortId:(uint64_t)sortId
                     timestamp:(uint64_t)timestamp
                uniqueThreadId:(NSString *)uniqueThreadId
                 attachmentIds:(NSArray<NSString *> *)attachmentIds
                          body:(nullable NSString *)body
                  contactShare:(nullable OWSContact *)contactShare
               expireStartedAt:(uint64_t)expireStartedAt
                     expiresAt:(uint64_t)expiresAt
              expiresInSeconds:(unsigned int)expiresInSeconds
            isViewOnceComplete:(BOOL)isViewOnceComplete
             isViewOnceMessage:(BOOL)isViewOnceMessage
                   linkPreview:(nullable OWSLinkPreview *)linkPreview
                messageSticker:(nullable MessageSticker *)messageSticker
                 quotedMessage:(nullable TSQuotedMessage *)quotedMessage
  storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer NS_UNAVAILABLE;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (instancetype)initIncomingMessageWithTimestamp:(uint64_t)timestamp
                                        inThread:(TSThread *)thread
                                   authorAddress:(SignalServiceAddress *)authorAddress
                                  sourceDeviceId:(uint32_t)sourceDeviceId
                                     messageBody:(nullable NSString *)body
                                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                                expiresInSeconds:(uint32_t)expiresInSeconds
                                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
                                    contactShare:(nullable OWSContact *)contactShare
                                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                                  messageSticker:(nullable MessageSticker *)messageSticker
                                 serverTimestamp:(nullable NSNumber *)serverTimestamp
                                 wasReceivedByUD:(BOOL)wasReceivedByUD
                               isViewOnceMessage:(BOOL)isViewOnceMessage NS_DESIGNATED_INITIALIZER;

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                    contactShare:(nullable OWSContact *)contactShare
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
               authorPhoneNumber:(nullable NSString *)authorPhoneNumber
                      authorUUID:(nullable NSString *)authorUUID
                            read:(BOOL)read
                 serverTimestamp:(nullable NSNumber *)serverTimestamp
                  sourceDeviceId:(unsigned int)sourceDeviceId
                 wasReceivedByUD:(BOOL)wasReceivedByUD
NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(grdbId:uniqueId:receivedAtTimestamp:sortId:timestamp:uniqueThreadId:attachmentIds:body:contactShare:expireStartedAt:expiresAt:expiresInSeconds:isViewOnceComplete:isViewOnceMessage:linkPreview:messageSticker:quotedMessage:storedShouldStartExpireTimer:wasRemotelyDeleted:authorPhoneNumber:authorUUID:read:serverTimestamp:sourceDeviceId:wasReceivedByUD:));

// clang-format on

// --- CODE GENERATION MARKER

// This will be 0 for messages created before we were tracking sourceDeviceId
@property (nonatomic, readonly) UInt32 sourceDeviceId;

@property (nonatomic, readonly) SignalServiceAddress *authorAddress;
@property (nonatomic, readonly, nullable) NSString *authorPhoneNumber;
@property (nonatomic, readonly, nullable) NSString *authorUUID;

// convenience method for expiring a message which was just read
- (void)debugonly_markAsReadNowWithTransaction:(SDSAnyWriteTransaction *)transaction
    NS_SWIFT_NAME(debugonly_markAsReadNow(transaction:));

@end

NS_ASSUME_NONNULL_END
