# Worker Bookings - Implementation TODO

## Steps
- [x] Explore existing code (models, services, providers, screens, api config)
- [ ] Create `lib/models/worker_booking_model.dart` (typed model)
- [ ] Create `lib/services/worker_booking_service.dart` (API calls)
- [ ] Create `lib/providers/worker_booking_provider.dart` (ChangeNotifier)
- [x] Register `WorkerBookingProvider` in `lib/main.dart`
- [x] Refactor `lib/screens/worker/worker_bookings_screen.dart` to use new model/provider
- [x] Update `lib/screens/worker/worker_bottom_nav.dart` to use new provider
- [x] Run `flutter analyze` to verify (no errors in new files)
