import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';
import '../models/ai_settings_model.dart';
import '../services/storage_service.dart';
import 'guide_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();

  final _botNameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();
  final _waNumberCtrl = TextEditingController();
  final _geminiKeyCtrl = TextEditingController();
  final _twilioSidCtrl = TextEditingController();
  final _twilioTokenCtrl = TextEditingController();
  final _claudeKeyCtrl = TextEditingController();
  final _deepgramKeyCtrl = TextEditingController();

  bool _autoLang = true;
  bool _sendWa = true;
  bool _record = true;
  bool _urgentFlag = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _storage.init();
    final s = _storage.settings;
    setState(() {
      _botNameCtrl.text = s.botName;
      _businessNameCtrl.text = s.businessName;
      _waNumberCtrl.text = s.waNumber;
      _geminiKeyCtrl.text = s.geminiApiKey;
      _twilioSidCtrl.text = s.twilioSid;
      _twilioTokenCtrl.text = s.twilioToken;
      _claudeKeyCtrl.text = s.claudeApiKey;
      _deepgramKeyCtrl.text = s.deepgramKey;
      _autoLang = s.autoLang;
      _sendWa = s.sendWa;
      _record = s.record;
      _urgentFlag = s.urgentFlag;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final updated = AiSettingsModel(
      botName: _botNameCtrl.text.trim(),
      businessName: _businessNameCtrl.text.trim(),
      waNumber: _waNumberCtrl.text.trim(),
      geminiApiKey: _geminiKeyCtrl.text.trim(),
      twilioSid: _twilioSidCtrl.text.trim(),
      twilioToken: _twilioTokenCtrl.text.trim(),
      claudeApiKey: _claudeKeyCtrl.text.trim(),
      deepgramKey: _deepgramKeyCtrl.text.trim(),
      autoLang: _autoLang,
      sendWa: _sendWa,
      record: _record,
      urgentFlag: _urgentFlag,
    );

    await _storage.saveSettings(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                'Settings & AI credentials saved successfully!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _botNameCtrl.dispose();
    _businessNameCtrl.dispose();
    _waNumberCtrl.dispose();
    _geminiKeyCtrl.dispose();
    _twilioSidCtrl.dispose();
    _twilioTokenCtrl.dispose();
    _claudeKeyCtrl.dispose();
    _deepgramKeyCtrl.dispose();
    super.dispose();
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    IconData? icon,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.sub,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.text),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, size: 18, color: AppColors.sub) : null,
            hintText: hint,
            helperText: helperText,
            helperStyle: GoogleFonts.inter(fontSize: 10, color: AppColors.muted),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.sub,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.text),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Settings & AI Config',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Identity Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🤖', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Bot Identity & Business',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'Bot Persona Name',
                    hint: 'e.g. Priya',
                    controller: _botNameCtrl,
                    icon: Icons.person_outline,
                  ),
                  _buildField(
                    label: 'Business Name',
                    hint: 'e.g. Tanishk AI Solutions',
                    controller: _businessNameCtrl,
                    icon: Icons.business_outlined,
                  ),
                  _buildField(
                    label: 'Owner WhatsApp Number',
                    hint: '+91 98765 43210',
                    controller: _waNumberCtrl,
                    icon: Icons.phone_android_outlined,
                    helperText: 'Call summaries will be formatted and dispatched to this WhatsApp',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // AI Models & Cloud API Keys
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Google Gemini & AI Engines',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'Google Gemini API Key (Recommended)',
                    hint: 'AIzaSy...',
                    controller: _geminiKeyCtrl,
                    obscureText: true,
                    icon: Icons.auto_awesome_rounded,
                    helperText: 'Enables live Gemini 1.5/2.0 voice reasoning in Gujarati, Hindi & English',
                  ),
                  _buildField(
                    label: 'Claude API Key (Anthropic)',
                    hint: 'sk-ant-api03-...',
                    controller: _claudeKeyCtrl,
                    obscureText: true,
                    icon: Icons.psychology_outlined,
                  ),
                  _buildField(
                    label: 'Twilio Account SID',
                    hint: 'ACxxxxxxxxxxxxxxx',
                    controller: _twilioSidCtrl,
                    icon: Icons.vpn_key_outlined,
                  ),
                  _buildField(
                    label: 'Twilio Auth Token',
                    hint: 'Auth Token',
                    controller: _twilioTokenCtrl,
                    obscureText: true,
                    icon: Icons.lock_outline,
                  ),
                  _buildField(
                    label: 'Deepgram Key (Voice AI)',
                    hint: 'Token...',
                    controller: _deepgramKeyCtrl,
                    obscureText: true,
                    icon: Icons.mic_none_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Automated Behaviors
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('⚙️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'Automations & Alerts',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSwitch(
                    title: 'Auto-detect Language',
                    subtitle: 'Switches between Gujarati, Hindi, English dynamically',
                    value: _autoLang,
                    onChanged: (v) => setState(() => _autoLang = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Auto WhatsApp Summary Prompt',
                    subtitle: 'Shows instant 1-tap WhatsApp digest when live call ends',
                    value: _sendWa,
                    onChanged: (v) => setState(() => _sendWa = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Record Live Transcripts',
                    subtitle: 'Saves full audio transcripts to local call history',
                    value: _record,
                    onChanged: (v) => setState(() => _record = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Urgent Escalation Alerts',
                    subtitle: 'Highlights calls requiring immediate owner follow-up',
                    value: _urgentFlag,
                    onChanged: (v) => setState(() => _urgentFlag = v),
                  ),
                ],
              ),
            ),

            // Help & User Guide Card
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App User Guide & Tutorials',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          'નવા યુઝર માટે સ્ટેપ-બાય-સ્ટેપ ગાઈડ અને FAQs',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.sub,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                      foregroundColor: AppColors.accent,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.accent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GuideScreen()),
                      );
                    },
                    child: const Text('Open Guide'),
                  ),
                ],
              ),
            ),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _saveSettings,
                icon: const Icon(Icons.save_rounded, size: 20),
                label: Text(
                  'Save Settings',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
