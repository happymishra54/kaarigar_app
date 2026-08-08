# Kaarigar App - Task Progress

## Original Task: Fix services not showing in worker dashboard

## Root Cause #1 (fixed)
The backend `WorkerServiceController::index()` returned placeholder data
(`user` and `id`) instead of the worker's services. The Flutter client
expects `data["services"]` (a list), so nothing displayed.

- [x] Fixed `WorkerServiceController::index()` to return the authenticated
      worker's services under `services` key (with `category` eager-loaded).

## Root Cause #2 (fixed) — Error when creating a service
The `services` table has `status` as a **boolean** column, but
`WorkerServiceController::store()` inserted the string `'active'`, causing:
`SQLSTATE[22007]: Incorrect integer value: 'active'`.

- [x] Changed `store()` to insert `'status' => true` (boolean).
- [x] Updated `WorkerServiceModel` to parse boolean/numeric status into a
      readable "Active"/"Inactive" label.

## Root Cause #3 (fixed) — Default service image always showing
The `Service` model's `getImageAttribute()` accessor ALWAYS returned a
default image (based on title keyword), even when no image was uploaded.
Also, the API `store()` never saved the uploaded image file.

- [x] `Service::getImageAttribute()` now returns the uploaded image URL only
      when an image exists, otherwise returns null (no default fallback).
- [x] `WorkerServiceController::store()` now saves the uploaded image to
      `storage/app/public/services` and stores it in the `image` column.
- [x] `WorkerServiceController::update()` now saves the uploaded image too.
- [x] `my_services_screen.dart` now shows the service image only when one was
      uploaded; otherwise shows a placeholder icon.

## New Landing / Onboarding Screen (mirrors kaarigar.net)
- [x] Created `lib/screens/auth/onboarding_screen.dart` — a rich landing page:
      top bar with **Login** & **Register** buttons, hero section matching the
      website ("India's Trusted Home Service Platform"), "Why Choose Kaarigar"
      feature grid, "Our Impact" stats, popular categories, "How It Works"
      steps, a "Find Workers" CTA, and a footer with brand info.
- [x] Updated `splash_screen.dart` to navigate to `OnboardingScreen` after the
      splash instead of the bare role-selection screen.

## UI Polish (done alongside original bug fix)
- [x] Upgraded `lib/widgets/primary_button.dart`
- [x] Upgraded `lib/widgets/app_textfield.dart`
- [x] Polished auth screens (`role_selection`, `login`, `register`)

## Verification
- [x] `php -l` on controller & model -> no syntax errors
- [x] `php artisan optimize:clear` done; storage symlink exists
- [x] `flutter analyze` -> no errors/warnings

