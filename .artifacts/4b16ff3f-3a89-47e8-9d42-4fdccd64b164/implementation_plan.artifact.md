# Implementation Plan - Fix Project Errors and Structure

The project currently has a duplicated and misplaced structure in `Movie_Updated_FLUTTER_READY/lib/`. The files within this directory have broken relative imports because they are not located in the expected package root (`lib/`).

## Proposed Changes

### [Component: Project Structure]

I will move the missing components from the temporary folder to the main project structure and clean up the redundancy.

#### [MOVE] `Movie_Updated_FLUTTER_READY/lib/blocs/` -> [lib/blocs/](file:///D:/تجربههه/lib/blocs/)
#### [MOVE] `Movie_Updated_FLUTTER_READY/lib/services/yts_api_service.dart` -> [lib/services/yts_api_service.dart](file:///D:/تجربههه/lib/services/yts_api_service.dart)
#### [DELETE] `Movie_Updated_FLUTTER_READY/`

### [Component: Fix Imports and Types]

After moving the files, I will verify the imports and fix any remaining type errors.

#### [MODIFY] [browse_bloc.dart](file:///D:/تجربههه/lib/blocs/browse/browse_bloc.dart)
- Verify `../../models/movie.dart` resolves correctly.
- Fix null safety issue with `movie.genres`.

#### [MODIFY] [profile_bloc.dart](file:///D:/تجربههه/lib/blocs/profile/profile_bloc.dart)
- Verify `../../services/firestore_service.dart` resolves correctly.

#### [MODIFY] [yts_api_service.dart](file:///D:/تجربههه/lib/services/yts_api_service.dart)
- Verify `../models/movie.dart` resolves correctly.

## Verification Plan

### Automated Tests
- Run `analyze_file` on all moved files to ensure no more errors exist.
- Run `flutter analyze` (via shell) if possible to check the entire project.

### Manual Verification
- Check the `lib/` directory structure to ensure it matches the standard Flutter layout.
