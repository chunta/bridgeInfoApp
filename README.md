Here's your improved README content in Markdown format:

---

# App Info

**BridgeInfoApp** is a Flutter application designed to deliver detailed information about various bridges. The app retrieves data from a backend service and displays it in a well-organized and user-friendly format.

## Included Important Dependencies

The project utilizes several key dependencies to enhance functionality and maintainability:

- **native_dio_adapter**: Provides native platform-specific adapters for Dio, ensuring optimized network requests.
- **dio_http_cache_fix**: Implements HTTP caching support for Dio, reducing data usage and improving performance by caching responses.
- **flutter_bloc**: A state management library that facilitates the implementation of the BLoC (Business Logic Component) pattern, ensuring predictable and manageable state transitions.

## Code Coverage

To view the code coverage report, open the pre-generated coverage page:

```
coverage/html/index.html
```

This report provides insights into the test coverage of the codebase, highlighting tested and untested portions.

## Unit Tests

Comprehensive unit tests have been implemented for critical components of the application, including:

- **Main BLoC**: Ensures that the business logic of the application functions correctly.
- **Group List Page**: Verifies the correct retrieval and display of a list of groups.
- **Single Group Page**: Tests the functionality related to viewing a single group's details.
- **Bridge Detail Page**: Checks the display and functionality of detailed bridge information.


## Tested Platform
- iOS Simulator: iPhone 15 iOS 17.5 / iPhone SE 3 iOS 17.5  
- Android Emulator: Pixel 8 Pro API 35 / Pixel 6 Pro API 35
- Mac OSX: Sonoma 14.5