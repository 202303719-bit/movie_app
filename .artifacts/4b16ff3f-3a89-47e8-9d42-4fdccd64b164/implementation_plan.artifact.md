# Implementation Plan - Fix AppUser Errors and UI Warnings

The project has several compilation errors due to missing fields in the `AppUser` model that `ProfileBloc` expects. Additionally, there are several UI warnings related to unused imports, parameters, and deprecated APIs.

## Proposed Changes

### [Component: Data Models]

#### [MODIFY] [app_user.dart](file:///D:/تجربههه/lib/models/app_user.dart)
- Add `favorites` and `watchedMovies` fields (List of int).
- Update `fromMap`, `toMap`, and `copyWith` to handle these fields.

### [Component: Profile Logic]

#### [MODIFY] [profile_bloc.dart](file:///D:/تجربههه/lib/blocs/profile/profile_bloc.dart)
- No changes needed here, as updating `AppUser` will resolve the getter errors.

### [Component: UI & Cleanup]

#### [MODIFY] [main.dart](file:///D:/تجربههه/lib/main.dart)
- Remove unused imports (`home_screen.dart`, `update_profile_screen.dart`).

#### [MODIFY] [forget_password_screen.dart](file:///D:/تجربههه/lib/screens/forget_password_screen.dart)
- Remove unused parameters (`obscureText`, `suffixIcon`) from the private `_AuthTextField` component as they are not used within this screen.

#### [MODIFY] [update_profile_screen.dart](file:///D:/تجربههه/lib/screens/update_profile_screen.dart)
- Replace deprecated `withOpacity(0.15)` with `withAlpha((255 * 0.15).toInt())` or similar to resolve the warning.
- Remove unused parameters from the private `_AuthTextField`.

#### [MODIFY] [search_screen.dart](file:///D:/تجربههه/lib/screens/search_screen.dart)
- Fix `unnecessary_underscores` info by using a single underscore for unused arguments in `errorBuilder`.

## Verification Plan

### Automated Tests
- Run `analyze_file` on all modified files to ensure all errors and warnings are resolved.

### Manual Verification
- Verify that the Profile screen loads correctly (if testing on a device is possible).
