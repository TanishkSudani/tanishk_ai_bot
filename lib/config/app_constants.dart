import 'app_colors.dart';
import '../models/call_model.dart';

export 'app_colors.dart';
export '../models/call_model.dart';
export '../models/call_session_state.dart';
export '../models/transcript_model.dart';
export '../models/ai_settings_model.dart';

const String kAppTitle = "Tanishk's AI Bot";
const String kDefaultWebhookUrl = 'https://bot.tanishk-ai.com/api/v1/voice-webhook';

final List<CallModel> initialTodayCalls = [
  const CallModel(
    name: 'Rahul Shah',
    number: '+91 98765 43210',
    language: 'Gujarati',
    type: 'in',
    summary: 'Delivery query · Bot resolved ✅',
    time: '2m ago',
    unread: 0,
    emoji: '😊',
    color: AppColors.accent,
  ),
  const CallModel(
    name: 'Priya Patel',
    number: '+91 77001 22334',
    language: 'Hindi',
    type: 'miss',
    summary: 'Missed call · Summary sent ⚠️',
    time: '8m ago',
    unread: 1,
    emoji: '👩',
    color: AppColors.purple,
  ),
  const CallModel(
    name: 'Amit Verma',
    number: '+91 90012 33445',
    language: 'Gujarati',
    type: 'in',
    summary: 'New order enquiry · Action needed',
    time: '18m ago',
    unread: 1,
    emoji: '👨',
    color: AppColors.orange,
  ),
  const CallModel(
    name: "Maria D'Souza",
    number: '+91 88997 66554',
    language: 'English',
    type: 'in',
    summary: 'Business hours query · Resolved ✅',
    time: '1h ago',
    unread: 0,
    emoji: '👩',
    color: AppColors.green,
  ),
  const CallModel(
    name: 'Ravi Kumar',
    number: '+91 70011 88223',
    language: 'Tamil',
    type: 'out',
    summary: 'Outgoing callback · Scheduled',
    time: '2h ago',
    unread: 0,
    emoji: '🧑',
    color: AppColors.accent,
  ),
];

final List<CallModel> initialYesterdayCalls = [
  const CallModel(
    name: 'Anjali Mehta',
    number: '+91 95555 12312',
    language: 'Gujarati',
    type: 'in',
    summary: 'Refund request · Escalated to you',
    time: 'Yesterday',
    unread: 0,
    emoji: '👩',
    color: AppColors.purple,
  ),
  const CallModel(
    name: 'Unknown Caller',
    number: '+91 80033 99001',
    language: 'Hindi',
    type: 'miss',
    summary: 'Dropped call · 22 seconds',
    time: 'Yesterday',
    unread: 0,
    emoji: '❓',
    color: AppColors.red,
  ),
];

// Provide global aliases for legacy imports
List<CallModel> todayCalls = List.from(initialTodayCalls);
List<CallModel> yesterdayCalls = List.from(initialYesterdayCalls);
