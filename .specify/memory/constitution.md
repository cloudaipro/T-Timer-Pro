# T-Timer Pro Constitution

## Core Principles

### I. iOS Platform Standards
All code must follow iOS development standards and Apple Human Interface Guidelines. Use UIKit and iOS frameworks appropriately. Support minimum iOS deployment target as specified in project configuration.

### II. Swift & Objective-C Compatibility
Use Swift as primary language. Maintain Objective-C interoperability where needed. Follow Swift naming conventions and best practices.

### III. Memory Management
Use ARC (Automatic Reference Counting) properly. Avoid retain cycles with weak references. Ensure proper memory cleanup in view controllers and custom objects.

### IV. App Store Compliance
Code must be App Store ready. No private APIs or restricted functionality. Handle user privacy and permissions appropriately.

### V. Code Quality
Write clean, readable code with meaningful names. Use proper error handling and logging. Follow established project architecture patterns.

## Technical Requirements

**Deployment Target**: iOS 13.0 minimum
**Build System**: Xcode with CocoaPods dependency management
**Architecture**: MVC with reactive programming patterns (RxSwift)

## Development Workflow

**Build Process**: Use `pod install` before building, always open `.xcworkspace` file
**Testing**: Build successfully before committing changes
**Dependencies**: Manage through CocoaPods, update carefully to avoid breaking changes

## Governance

This constitution defines the minimum standards for T-Timer Pro development. All code changes must comply with these principles. When in doubt, refer to CLAUDE.md for detailed project guidance.

**Version**: 1.0.0 | **Ratified**: 2025-09-15 | **Last Amended**: 2025-09-15