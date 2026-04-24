// // lib/supabase/supabase_init.dart
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../utils/constants.dart';

// class SupabaseInit {
//   static Future<void> initialize() async {
//     await Supabase.initialize(
//       url: AppConstants.supabaseUrl,
//       anonKey: AppConstants.supabaseAnonKey,
//     );
//   }

//   static SupabaseClient get client => Supabase.instance.client;
// }
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class SupabaseInit {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,

      // 🔥 THIS FIXES YOUR ERROR
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: false,
        persistSession: false,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
