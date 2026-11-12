enum PhraseCategory {
  all('All', '🌟'),
  emergency('Emergency', '🚨'),
  transit('Transit & Directions', '🚕'),
  dining('Dining & Food', '🍽️'),
  hotel('Hotel & Stay', '🏨'),
  essentials('Basics & Greetings', '👋');

  final String title;
  final String emoji;
  const PhraseCategory(this.title, this.emoji);
}

class PhraseItem {
  final String id;
  final PhraseCategory category;
  final String text;
  final Map<String, String> offlineTranslations;

  const PhraseItem({
    required this.id,
    required this.category,
    required this.text,
    this.offlineTranslations = const {},
  });
}

class PhrasebookData {
  static const List<PhraseItem> phrases = [
    // 🚨 Emergency & Medical
    PhraseItem(
      id: 'em_1',
      category: PhraseCategory.emergency,
      text: 'Help! Call the police immediately!',
      offlineTranslations: {
        'es': '¡Ayuda! ¡Llame a la policía de inmediato!',
        'fr': 'Au secours ! Appelez la police immédiatement !',
        'hi': 'मदद! तुरंत पुलिस को बुलाओ!',
        'kn': 'ಸಹಾಯ! ತಕ್ಷಣ ಪೊಲೀಸರನ್ನು ಕರೆಯಿರಿ!',
        'de': 'Hilfe! Rufen Sie sofort die Polizei!',
        'ja': '助けて！すぐに警察を呼んでください！',
        'it': 'Aiuto! Chiamate subito la polizia!',
      },
    ),
    PhraseItem(
      id: 'em_2',
      category: PhraseCategory.emergency,
      text: 'I need an ambulance. Someone is seriously injured.',
      offlineTranslations: {
        'es': 'Necesito una ambulancia. Alguien está gravemente herido.',
        'fr': "J'ai besoin d'une ambulance. Quelqu'un est grièvement blessé.",
        'hi': 'मुझे एम्बुलेंस चाहिए। कोई गंभीर रूप से घायल है।',
        'kn': 'ನನಗೆ ಆಂಬ್ಯುಲೆನ್ಸ್ ಬೇಕು. ಯಾರೋ ತೀವ್ರವಾಗಿ ಗಾಯಗೊಂಡಿದ್ದಾರೆ.',
        'de': 'Ich brauche einen Krankenwagen. Jemand ist schwer verletzt.',
      },
    ),
    PhraseItem(
      id: 'em_3',
      category: PhraseCategory.emergency,
      text: 'Where is the nearest hospital or pharmacy?',
      offlineTranslations: {
        'es': '¿Dónde está el hospital o farmacia más cercano?',
        'fr': "Où se trouve l'hôpital ou la pharmacie la plus proche ?",
        'hi': 'निकटतम अस्पताल या फार्मेसी कहाँ है?',
        'kn': 'ಹತ್ತಿರದ ಆಸ್ಪತ್ರೆ ಅಥವಾ ಔಷಧಾಲಯ ಎಲ್ಲಿದೆ?',
        'de': 'Wo ist das nächste Krankenhaus oder die nächste Apotheke?',
      },
    ),
    PhraseItem(
      id: 'em_4',
      category: PhraseCategory.emergency,
      text: 'I lost my passport and wallet. Please help me.',
      offlineTranslations: {
        'es': 'Perdí mi pasaporte y mi billetera. Por favor ayúdeme.',
        'fr': "J'ai perdu mon passeport et mon portefeuille. Aidez-moi s'il vous plaît.",
        'hi': 'मेरा पासपोर्ट और बटुआ खो गया है। कृपया मेरी मदद करें।',
        'kn': 'ನನ್ನ ಪಾಸ್‌ಪೋರ್ಟ್ ಮತ್ತು ವ್ಯಾಲೆಟ್ ಕಳೆದುಹೋಗಿದೆ. ದಯವಿಟ್ಟು ನನಗೆ ಸಹಾಯ ಮಾಡಿ.',
      },
    ),
    PhraseItem(
      id: 'em_5',
      category: PhraseCategory.emergency,
      text: 'I am lost. Can you help me find my way back?',
      offlineTranslations: {
        'es': 'Estoy perdido. ¿Puede ayudarme a encontrar el camino de regreso?',
        'fr': "Je suis perdu. Pouvez-vous m'aider à retrouver mon chemin ?",
        'hi': 'मैं रास्ता भटक गया हूँ। क्या आप मुझे वापस रास्ता खोजने में मदद कर सकते हैं?',
        'kn': 'ನಾನು ದಾರಿ ತಪ್ಪಿದ್ದೇನೆ. ದಯವಿಟ್ಟು ನನಗೆ ಮಾರ್ಗ ತೋರಿಸಿ.',
      },
    ),
    PhraseItem(
      id: 'em_6',
      category: PhraseCategory.emergency,
      text: 'Please call my embassy right away.',
      offlineTranslations: {
        'es': 'Por favor llame a mi embajada de inmediato.',
        'fr': 'Veuillez appeler mon ambassade tout de suite.',
        'hi': 'कृपया तुरंत मेरे दूतावास को कॉल करें।',
        'kn': 'ದಯವಿಟ್ಟು ತಕ್ಷಣ ನನ್ನ ರಾಯಭಾರ ಕಚೇರಿಗೆ ಕರೆ ಮಾಡಿ.',
      },
    ),

    // 🚕 Travel & Transit
    PhraseItem(
      id: 'tr_1',
      category: PhraseCategory.transit,
      text: 'Where is the nearest train station or subway?',
      offlineTranslations: {
        'es': '¿Dónde está la estación de tren o metro más cercana?',
        'fr': 'Où se trouve la gare ou station de métro la plus proche ?',
        'hi': 'निकटतम रेलवे स्टेशन या मेट्रो कहाँ है?',
        'kn': 'ಹತ್ತಿರದ ರೈಲ್ವೆ ನಿಲ್ದಾಣ ಅಥವಾ ಮೆಟ್ರೋ ಎಲ್ಲಿದೆ?',
        'de': 'Wo ist der nächste Bahnhof oder die nächste U-Bahn-Station?',
      },
    ),
    PhraseItem(
      id: 'tr_2',
      category: PhraseCategory.transit,
      text: 'How much is the taxi fare to this address?',
      offlineTranslations: {
        'es': '¿Cuánto cuesta el taxi hasta esta dirección?',
        'fr': 'Combien coûte la course de taxi jusqu’à cette adresse ?',
        'hi': 'इस पते के लिए टैक्सी का किराया कितना है?',
        'kn': 'ಈ ವಿಳಾಸಕ್ಕೆ ಟ್ಯಾಕ್ಸಿ ದರ ಎಷ್ಟು?',
      },
    ),
    PhraseItem(
      id: 'tr_3',
      category: PhraseCategory.transit,
      text: 'Please take me to the airport as quickly as possible.',
      offlineTranslations: {
        'es': 'Por favor lléveme al aeropuerto lo más rápido posible.',
        'fr': "Veuillez m'emmener à l'aéroport le plus rapidement possible.",
        'hi': 'कृपया मुझे जल्द से जल्द हवाई अड्डे ले चलें।',
        'kn': 'ದಯವಿಟ್ಟು ಸಾಧ್ಯವಾದಷ್ಟು ಬೇಗ ನನ್ನನ್ನು ವಿಮಾನ ನಿಲ್ದಾಣಕ್ಕೆ ಕರೆದೊಯ್ಯಿರಿ.',
      },
    ),
    PhraseItem(
      id: 'tr_4',
      category: PhraseCategory.transit,
      text: 'Where is the restroom / toilet?',
      offlineTranslations: {
        'es': '¿Dónde está el baño?',
        'fr': 'Où sont les toilettes ?',
        'hi': 'शौचालय कहाँ है?',
        'kn': 'ಶೌಚಾಲಯ ಎಲ್ಲಿದೆ?',
        'de': 'Wo ist die Toilette?',
        'ja': 'お手洗いはどこですか？',
      },
    ),
    PhraseItem(
      id: 'tr_5',
      category: PhraseCategory.transit,
      text: 'Does this bus go to the city center?',
      offlineTranslations: {
        'es': '¿Este autobús va al centro de la ciudad?',
        'fr': 'Est-ce que ce bus va au centre-ville ?',
        'hi': 'क्या यह बस शहर के केंद्र में जाती है?',
        'kn': 'ಈ ಬಸ್ ನಗರದ ಕೇಂದ್ರಕ್ಕೆ ಹೋಗುತ್ತದೆಯೇ?',
      },
    ),
    PhraseItem(
      id: 'tr_6',
      category: PhraseCategory.transit,
      text: 'Can you show me where I am on this map?',
      offlineTranslations: {
        'es': '¿Puede mostrarme dónde estoy en este mapa?',
        'fr': 'Pouvez-vous me montrer où je suis sur cette carte ?',
        'hi': 'क्या आप मुझे इस नक्शे पर दिखा सकते हैं कि मैं कहाँ हूँ?',
        'kn': 'ಈ ನಕ್ಷೆಯಲ್ಲಿ ನಾನು ಎಲ್ಲಿದ್ದೇನೆ ಎಂದು ತೋರಿಸಬಲ್ಲಿರಾ?',
      },
    ),
    PhraseItem(
      id: 'tr_7',
      category: PhraseCategory.transit,
      text: 'Excuse me, is this seat available?',
      offlineTranslations: {
        'es': 'Disculpe, ¿este asiento está libre?',
        'fr': 'Excusez-moi, est-ce que cette place est libre ?',
        'hi': 'माफ़ कीजिये, क्या यह सीट खाली है?',
        'kn': 'ಕ್ಷಮಿಸಿ, ಈ ಆಸನ ಖಾಲಿ ಇದೆಯೇ?',
      },
    ),

    // 🍽️ Dining & Food
    PhraseItem(
      id: 'di_1',
      category: PhraseCategory.dining,
      text: 'Table for two, please.',
      offlineTranslations: {
        'es': 'Mesa para dos, por favor.',
        'fr': 'Une table pour deux, s’il vous plaît.',
        'hi': 'दो लोगों के लिए मेज, कृपया।',
        'kn': 'ಇಬ್ಬರಿಗೆ ಮೇಜು, ದಯವಿಟ್ಟು.',
        'de': 'Einen Tisch für zwei, bitte.',
      },
    ),
    PhraseItem(
      id: 'di_2',
      category: PhraseCategory.dining,
      text: 'Could we please see the food and drink menu?',
      offlineTranslations: {
        'es': '¿Podríamos ver el menú de comida y bebidas, por favor?',
        'fr': 'Pourrions-nous voir le menu, s’il vous plaît ?',
        'hi': 'क्या हम कृपया खाने और पीने का मेनू देख सकते हैं?',
        'kn': 'ನಾವು ಊಟ ಮತ್ತು ಪಾನೀಯಗಳ ಮೆನುವನ್ನು ನೋಡಬಹುದೇ?',
      },
    ),
    PhraseItem(
      id: 'di_3',
      category: PhraseCategory.dining,
      text: 'I am vegetarian. Do you have vegetarian options?',
      offlineTranslations: {
        'es': 'Soy vegetariano. ¿Tienen opciones vegetarianas?',
        'fr': 'Je suis végétarien. Avez-vous des options végétariennes ?',
        'hi': 'मैं शाकाहारी हूँ। क्या आपके पास शाकाहारी विकल्प हैं?',
        'kn': 'ನಾನು ಸಸ್ಯಾಹಾರಿ. ನಿಮ್ಮಲ್ಲಿ ಸಸ್ಯಾಹಾರಿ ಆಯ್ಕೆಗಳಿವೆಯೇ?',
      },
    ),
    PhraseItem(
      id: 'di_4',
      category: PhraseCategory.dining,
      text: 'I have a severe peanut and nut allergy. Please ensure no nuts are in my food.',
      offlineTranslations: {
        'es': 'Tengo una alergia grave al maní y a los frutos secos. Por favor, asegúrese de que no haya nueces.',
        'fr': "J'ai une allergie sévère aux arachides et fruits à coque. Veuillez vérifier qu'il n'y en a pas.",
        'hi': 'मुझे मूंगफली से गंभीर एलर्जी है। कृपया ध्यान रखें कि मेरे भोजन में कोई नट्स न हों।',
        'kn': 'ನನಗೆ ಕಡಲೆಕಾಯಿ ಅಲರ್ಜಿ ಇದೆ. ದಯವಿಟ್ಟು ಆಹಾರದಲ್ಲಿ ಕಡಲೆಕಾಯಿ ಇಲ್ಲದಿರುವುದನ್ನು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ.',
      },
    ),
    PhraseItem(
      id: 'di_5',
      category: PhraseCategory.dining,
      text: 'Could we please have the bill / check?',
      offlineTranslations: {
        'es': '¿Podría traernos la cuenta, por favor?',
        'fr': 'L’addition, s’il vous plaît.',
        'hi': 'कृपया बिल दे दीजिए।',
        'kn': 'ದಯವಿಟ್ಟು ಬಿಲ್ ಕೊಡಿ.',
        'de': 'Die Rechnung, bitte.',
      },
    ),
    PhraseItem(
      id: 'di_6',
      category: PhraseCategory.dining,
      text: 'Do you accept credit card payments?',
      offlineTranslations: {
        'es': '¿Aceptan pagos con tarjeta de crédito?',
        'fr': 'Acceptez-vous les cartes de crédit ?',
        'hi': 'क्या आप क्रेडिट कार्ड स्वीकार करते हैं?',
        'kn': 'ನೀವು ಕ್ರೆಡಿಟ್ ಕಾರ್ಡ್ ಪಾವತಿಗಳನ್ನು ಸ್ವೀಕರಿಸುತ್ತೀರಾ?',
      },
    ),
    PhraseItem(
      id: 'di_7',
      category: PhraseCategory.dining,
      text: 'Can I please have a bottle of drinking water?',
      offlineTranslations: {
        'es': '¿Me puede traer una botella de agua potable, por favor?',
        'fr': "Puis-je avoir une bouteille d'eau, s'il vous plaît ?",
        'hi': 'क्या मुझे एक बोतल पीने का पानी मिल सकता है?',
        'kn': 'ದಯವಿಟ್ಟು ಒಂದು ಬಾಟಲ್ ಕುಡಿಯುವ ನೀರು ಕೊಡಿ.',
      },
    ),

    // 🏨 Hotel & Stay
    PhraseItem(
      id: 'ho_1',
      category: PhraseCategory.hotel,
      text: 'I have a room reservation under my name.',
      offlineTranslations: {
        'es': 'Tengo una reserva de habitación a mi nombre.',
        'fr': 'J’ai une réservation de chambre à mon nom.',
        'hi': 'मेरे नाम पर एक कमरा आरक्षित है।',
        'kn': 'ನನ್ನ ಹೆಸರಿನಲ್ಲಿ ಕೋಣೆ ಬುಕಿಂಗ್ ಇದೆ.',
        'de': 'Ich habe eine Zimmerreservierung auf meinen Namen.',
      },
    ),
    PhraseItem(
      id: 'ho_2',
      category: PhraseCategory.hotel,
      text: 'What is the Wi-Fi network and password?',
      offlineTranslations: {
        'es': '¿Cuál es la red Wi-Fi y la contraseña?',
        'fr': 'Quel est le nom du réseau Wi-Fi et le mot de passe ?',
        'hi': 'वाई-फाई नेटवर्क और पासवर्ड क्या है?',
        'kn': 'ವೈ-ಫೈ ನೆಟ್‌ವರ್ಕ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ ಏನು?',
        'de': 'Wie lautet das WLAN-Netzwerk und das Passwort?',
      },
    ),
    PhraseItem(
      id: 'ho_3',
      category: PhraseCategory.hotel,
      text: 'What time is checkout tomorrow morning?',
      offlineTranslations: {
        'es': '¿A qué hora es el check-out mañana por la mañana?',
        'fr': 'À quelle heure est le départ demain matin ?',
        'hi': 'कल सुबह चेकआउट का समय क्या है?',
        'kn': 'ನಾಳೆ ಬೆಳಿಗ್ಗೆ ಚೆಕ್‌ಔಟ್ ಸಮಯ ಎಷ್ಟು?',
      },
    ),
    PhraseItem(
      id: 'ho_4',
      category: PhraseCategory.hotel,
      text: 'Can I store my luggage here for a few hours after checkout?',
      offlineTranslations: {
        'es': '¿Puedo guardar mi equipaje aquí por unas horas después del check-out?',
        'fr': 'Puis-je laisser mes bagages ici pendant quelques heures ?',
        'hi': 'क्या मैं चेकआउट के बाद कुछ घंटों के लिए अपना सामान यहाँ रख सकता हूँ?',
        'kn': 'ಚೆಕ್‌ಔಟ್ ನಂತರ ಕೆಲವು ಗಂಟೆಗಳ ಕಾಲ ನನ್ನ ಲಗೇಜ್ ಅನ್ನು ಇಲ್ಲಿ ಇಡಬಹುದೇ?',
      },
    ),
    PhraseItem(
      id: 'ho_5',
      category: PhraseCategory.hotel,
      text: 'The air conditioner / heater is not working in my room.',
      offlineTranslations: {
        'es': 'El aire acondicionado / calefacción no funciona en mi habitación.',
        'fr': 'La climatisation / le chauffage ne fonctionne pas dans ma chambre.',
        'hi': 'मेरे कमरे में एयर कंडीशनर / हीटर काम नहीं कर रहा है।',
        'kn': 'ನನ್ನ ಕೋಣೆಯಲ್ಲಿ ಎಸಿ / ಹೀಟರ್ ಕೆಲಸ ಮಾಡುತ್ತಿಲ್ಲ.',
      },
    ),
    PhraseItem(
      id: 'ho_6',
      category: PhraseCategory.hotel,
      text: 'Could I please get extra towels and toiletries?',
      offlineTranslations: {
        'es': '¿Podría traerme toallas y artículos de tocador adicionales?',
        'fr': 'Pourrais-je avoir des serviettes supplémentaires ?',
        'hi': 'क्या मुझे अतिरिक्त तौलिये मिल सकते हैं?',
        'kn': 'ದಯವಿಟ್ಟು ಹೆಚ್ಚುವರಿ ಟವೆಲ್ ನೀಡಬಹುದೇ?',
      },
    ),

    // 👋 Greetings & Basics
    PhraseItem(
      id: 'es_1',
      category: PhraseCategory.essentials,
      text: 'Hello! Good day / Good evening.',
      offlineTranslations: {
        'es': '¡Hola! Buenos días / Buenas tardes.',
        'fr': 'Bonjour ! Bonsoir.',
        'hi': 'नमस्ते! शुभ दिन / शुभ संध्या।',
        'kn': 'ನಮಸ್ಕಾರ! ಶುಭ ದಿನ / ಶುಭ ಸಂಜೆ.',
        'de': 'Hallo! Guten Tag / Guten Abend.',
        'ja': 'こんにちは！おはようございます / こんばんは。',
      },
    ),
    PhraseItem(
      id: 'es_2',
      category: PhraseCategory.essentials,
      text: 'Thank you very much for your kind help!',
      offlineTranslations: {
        'es': '¡Muchas gracias por su amable ayuda!',
        'fr': 'Merci beaucoup pour votre aide aimable !',
        'hi': 'आपकी मदद के लिए बहुत-बहुत धन्यवाद!',
        'kn': 'ನಿಮ್ಮ ಸಹಾಯಕ್ಕೆ ತುಂಬಾ ಧನ್ಯವಾದಗಳು!',
        'de': 'Vielen Dank für Ihre freundliche Hilfe!',
        'ja': '親切なご協力ありがとうございます！',
      },
    ),
    PhraseItem(
      id: 'es_3',
      category: PhraseCategory.essentials,
      text: 'Excuse me / I am so sorry.',
      offlineTranslations: {
        'es': 'Disculpe / Lo siento mucho.',
        'fr': 'Excusez-moi / Je suis désolé.',
        'hi': 'माफ़ कीजिये / मुझे बहुत खेद है।',
        'kn': 'ಕ್ಷಮಿಸಿ / ತುಂಬಾ ಕ್ಷಮೆಯಿರಲಿ.',
        'de': 'Entschuldigung / Es tut mir leid.',
        'ja': 'すみません / ごめんなさい。',
      },
    ),
    PhraseItem(
      id: 'es_4',
      category: PhraseCategory.essentials,
      text: 'Do you speak English?',
      offlineTranslations: {
        'es': '¿Habla inglés?',
        'fr': 'Parlez-vous anglais ?',
        'hi': 'क्या आप अंग्रेज़ी बोलते हैं?',
        'kn': 'ನೀವು ಇಂಗ್ಲಿಷ್ ಮಾತನಾಡುತ್ತೀರಾ?',
        'de': 'Sprechen Sie Englisch?',
        'ja': '英語を話せますか？',
      },
    ),
    PhraseItem(
      id: 'es_5',
      category: PhraseCategory.essentials,
      text: 'How much does this cost?',
      offlineTranslations: {
        'es': '¿Cuánto cuesta esto?',
        'fr': 'Combien cela coûte-t-il ?',
        'hi': 'इसकी कीमत कितनी है?',
        'kn': 'ಇದರ ಬೆಲೆ ಎಷ್ಟು?',
        'de': 'Wie viel kostet das?',
        'ja': 'これはいくらですか？',
      },
    ),
    PhraseItem(
      id: 'es_6',
      category: PhraseCategory.essentials,
      text: 'Yes, please / No, thank you.',
      offlineTranslations: {
        'es': 'Sí, por favor / No, gracias.',
        'fr': 'Oui, s’il vous plaît / Non, merci.',
        'hi': 'हाँ, कृपया / नहीं, धन्यवाद।',
        'kn': 'ಹೌದು, ದಯವಿಟ್ಟು / ಇಲ್ಲ, ಧನ್ಯವಾದಗಳು.',
        'de': 'Ja, bitte / Nein, danke.',
      },
    ),
    PhraseItem(
      id: 'es_7',
      category: PhraseCategory.essentials,
      text: 'Where is the nearest ATM or bank?',
      offlineTranslations: {
        'es': '¿Dónde está el cajero automático o banco más cercano?',
        'fr': 'Où se trouve le distributeur ou la banque la plus proche ?',
        'hi': 'निकटतम एटीएम या बैंक कहाँ है?',
        'kn': 'ಹತ್ತಿರದ ಎಟಿಎಂ ಅಥವಾ ಬ್ಯಾಂಕ್ ಎಲ್ಲಿದೆ?',
      },
    ),
    PhraseItem(
      id: 'es_8',
      category: PhraseCategory.essentials,
      text: 'Goodbye! Have a wonderful day!',
      offlineTranslations: {
        'es': '¡Adiós! ¡Que tenga un maravilloso día!',
        'fr': 'Au revoir ! Bonne journée !',
        'hi': 'अलविदा! आपका दिन शुभ हो!',
        'kn': 'ಬರುತ್ತೇನೆ! ನಿಮ್ಮ ದಿನ ಶುಭವಾಗಿರಲಿ!',
        'de': 'Auf Wiedersehen! Einen schönen Tag noch!',
      },
    ),
  ];
}
