import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _botNameCtrl = TextEditingController(text: 'Priya');
  final _businessNameCtrl = TextEditingController(text: "Tanishk's AI Solutions");
  final _waNumberCtrl = TextEditingController(text: '+91 98765 43210');
  final _twilioSidCtrl = TextEditingController(text: 'AC_sample_twilio_sid_92834');
  final _twilioTokenCtrl = TextEditingController(text: '••••••••••••••••••••••••');
  final _claudeKeyCtrl = TextEditingController(text: 'sk-ant-sample-claude-key-8374');
  final _deepgramKeyCtrl = TextEditingController(text: 'dg_sample_deepgram_key_1928');

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
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _botNameCtrl.text = prefs.getString('bot_name') ?? 'Priya';
        _businessNameCtrl.text = prefs.getString('business_name') ?? "Tanishk's AI Solutions";
        _waNumberCtrl.text = prefs.getString('wa_number') ?? '+91 98765 43210';
        _twilioSidCtrl.text = prefs.getString('twilio_sid') ?? 'AC_sample_twilio_sid_92834';
        _twilioTokenCtrl.text = prefs.getString('twilio_token') ?? '••••••••••••••••••••••••';
        _claudeKeyCtrl.text = prefs.getString('claude_key') ?? 'sk-ant-sample-claude-key-8374';
        _deepgramKeyCtrl.text = prefs.getString('deepgram_key') ?? 'dg_sample_deepgram_key_1928';
        _autoLang = prefs.getBool('auto_lang') ?? true;
        _sendWa = prefs.getBool('send_wa') ?? true;
        _record = prefs.getBool('record') ?? true;
        _urgentFlag = prefs.getBool('urgent_flag') ?? true;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bot_name', _botNameCtrl.text);
    await prefs.setString('business_name', _businessNameCtrl.text);
    await prefs.setString('wa_number', _waNumberCtrl.text);
    await prefs.setString('twilio_sid', _twilioSidCtrl.text);
    await prefs.setString('twilio_token', _twilioTokenCtrl.text);
    await prefs.setString('claude_key', _claudeKeyCtrl.text);
    await prefs.setString('deepgram_key', _deepgramKeyCtrl.text);
    await prefs.setBool('auto_lang', _autoLang);
    await prefs.setBool('send_wa', _sendWa);
    await prefs.setBool('record', _record);
    await prefs.setBool('urgent_flag', _urgentFlag);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                'Settings saved successfully!',
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
        body: Center(child: CircularProgressIndicator()),
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
                    hint: 'e.g. Tanishk Store',
                    controller: _businessNameCtrl,
                    icon: Icons.business_outlined,
                  ),
                  _buildField(
                    label: 'Owner WhatsApp Number',
                    hint: '+91 98765 43210',
                    controller: _waNumberCtrl,
                    icon: Icons.phone_android_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Cloud API Credentials
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
                      const Text('🔑', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'API Keys & Cloud Connectors',
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
                    label: 'Claude API Key (Anthropic)',
                    hint: 'sk-ant-api03-...',
                    controller: _claudeKeyCtrl,
                    obscureText: true,
                    icon: Icons.auto_awesome_outlined,
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
                    subtitle: 'Switches between Gujarati, Hindi, English, Tamil dynamically',
                    value: _autoLang,
                    onChanged: (v) => setState(() => _autoLang = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Auto Send WhatsApp Summary',
                    subtitle: 'Dispatches instant call digest to your WhatsApp number',
                    value: _sendWa,
                    onChanged: (v) => setState(() => _sendWa = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Record Call Audio',
                    subtitle: 'Saves full audio for review and quality control',
                    value: _record,
                    onChanged: (v) => setState(() => _record = v),
                  ),
                  const Divider(color: AppColors.border),
                  _buildSwitch(
                    title: 'Urgent Escalation Alerts',
                    subtitle: 'Sends high priority notification if caller needs owner',
                    value: _urgentFlag,
                    onChanged: (v) => setState(() => _urgentFlag = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
