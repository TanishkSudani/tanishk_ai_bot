import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'User Guide & Tutorials 📖',
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
            // Hero Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🤖', style: TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to Tanishk's AI Bot",
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text,
                              ),
                            ),
                            Text(
                              'નવા યુઝર માટે સંપૂર્ણ માર્ગદર્શિકા (Step-by-Step Guide)',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.sub),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'આ AI બોટ તમારા બિઝનેસના ફોન કૉલ્સ ઓટોમેટિકલી ઉપાડે છે, ગુજરાતી, હિન્દી કે અંગ્રેજીમાં ગ્રાહક સાથે વાતચીત કરે છે, અને કૉલ પૂરો થતાં જ તમારા WhatsApp પર આખી સમરી મોકલે છે.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFFE2E8F0),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Step 1: 3-Minute Quickstart
            _buildSectionHeader('🚀', '3-Step Quickstart (ઝડપી શરૂઆત)'),
            _buildGuideCard(
              stepNumber: '1',
              title: 'સેટિંગ્સમાં તમારો WhatsApp નંબર સેટ કરો',
              subtitle: 'Settings > Owner WhatsApp Number',
              content:
                  'ઍપના Settings ટેબમાં જઈને તમારો WhatsApp નંબર અને તમારા બિઝનેસનું નામ લખો (જેમ કે Priya / Tanishk Store). જેથી બોટ તમારા નામે કસ્ટમર સાથે વાત કરશે અને તમામ સમરી તમારા WhatsApp પર જ આવશે.',
              badge: 'Step 1',
              badgeColor: AppColors.accent,
            ),
            _buildGuideCard(
              stepNumber: '2',
              title: 'લાઈવ કૉલિંગ ટેસ્ટ કરો (Live Voice Call)',
              subtitle: 'Live Tab અથવા Deploy > Simulate Call',
              content:
                  'Live ટેબમાં જાઓ અને "Start Live AI Voice Call" દબાવો. તમે માઈક્રોફોનમાં બોલી શકો છો અથવા નીચે આપેલા ચિપ્સ (જેમ કે "Kem cho bhai?", "Maro order kyare aavse?") દબાવીને ટેસ્ટ કરી શકો છો. AI બોટ અવાજમાં સામે જવાબ આપશે!',
              badge: 'Step 2',
              badgeColor: AppColors.green,
            ),
            _buildGuideCard(
              stepNumber: '3',
              title: 'કૉલ સમરી WhatsApp પર મેળવો',
              subtitle: '1-Tap Auto WhatsApp Dispatch',
              content:
                  'કૉલ પૂરો થતાં "End Call" દબાવો. તરત જ એક ડાયલોગ આવશે જેમાં કૉલરનું નામ, નંબર, સમય અને આખી વાતચીતની સમરી હશે. "Send to WhatsApp" દબાવતાં જ તમારા WhatsApp પર મેસેજ તૈયાર થઈ જશે!',
              badge: 'Step 3',
              badgeColor: AppColors.wa,
            ),

            const SizedBox(height: 20),

            // App Tabs Overview
            _buildSectionHeader('📱', 'ઍપના મુખ્ય 5 વિભાગો (Navigation Overview)'),
            _buildFeatureTile(
              icon: '🏠',
              title: 'Home / Dashboard',
              description: 'બિઝનેસ સ્ટેટિસ્ટિક્સ, એક્ટિવ લાઈવ કૉલ કાર્ડ, અને તાજેતરના કૉલ્સની લિસ્ટ બતાવે છે.',
            ),
            _buildFeatureTile(
              icon: '📞',
              title: 'Calls Tab (કૉલ હિસ્ટ્રી)',
              description: 'આજના અને અગાઉના તમામ કૉલ્સની યાદી. કોઈ પણ કૉલ પર ક્લિક કરીને આખી વાતચીત વાંચી શકાય છે.',
            ),
            _buildFeatureTile(
              icon: '🔴',
              title: 'Live Call (લાઈવ વૉઇસ કૉલિંગ)',
              description: 'અહીં રીઅલ-ટાઇમ માઇક્રોફોન, લાઈવ સાઉન્ડ વેવફોર્મ, સ્પીચ ટ્રાન્સક્રિપ્ટ અને હોલ્ડ/મ્યૂટ કંટ્રોલ છે.',
            ),
            _buildFeatureTile(
              icon: '🚀',
              title: 'Deploy & Simulator',
              description: 'Twilio વેબહૂક URL કોપી કરવાનો અને કસ્ટમરનો ઇનકમિંગ કૉલ સિમ્યુલેટ કરવાનો વિકલ્પ.',
            ),
            _buildFeatureTile(
              icon: '⚙️',
              title: 'Settings (સેટિંગ્સ & AI કી)',
              description: 'બોટનું નામ, તમારો WhatsApp નંબર, Google Gemini API કી અને ઓટો-લેંગ્વેજ ટૉગલ સેટ કરો.',
            ),

            const SizedBox(height: 20),

            // FAQs
            _buildSectionHeader('❓', 'વારંવાર પૂછાતા પ્રશ્નો (FAQ)'),
            _buildFaqTile(
              question: 'બોટ કઈ ભાષામાં વાત કરી શકે છે?',
              answer:
                  'બોટ ઓટોમેટિકલી કૉલરની ભાષા સમજી લે છે. જો કૉલર ગુજરાતીમાં બોલશે ("મારો ઓર્ડર ક્યારે આવશે?"), તો બોટ ગુજરાતીમાં જવાબ આપશે. હિન્દી કે અંગ્રેજીમાં બોલશે તો તે જ ભાષામાં જવાબ આપશે.',
            ),
            _buildFaqTile(
              question: 'શું Google Gemini API કી નાખવી ફરજિયાત છે?',
              answer:
                  'ના, ફરજિયાત નથી! ઍપમાં બિલ્ટ-ઇન ઇન્ટેલિજન્સ છે જે ઑર્ડર, ડિલિવરી, ટાઇમિંગ અને પ્રાઇસિંગના સવાલોના સાચા જવાબો તરત જ આપે છે. જો તમે એડવાન્સ્ડ કસ્ટમ જવાબો ઇચ્છો તો Settings માં ફ્રી Gemini API Key નાખી શકો છો.',
            ),
            _buildFaqTile(
              question: 'મારો રિયલ ફોન નંબર Twilio સાથે કેવી રીતે જોડવો?',
              answer:
                  'Deploy ટેબમાં આપેલી "Twilio Voice Webhook URL" કોપી કરો અને તમારા Twilio Console માં તમારા ફોન નંબરના "A CALL COMES IN" ફિલ્ડમાં પેસ્ટ કરી દો.',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard({
    required String stepNumber,
    required String title,
    required String subtitle,
    required String content,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: badgeColor, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: badgeColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.sub),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.sub,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.sub,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
