{ config, pkgs, ... }: {

  # --- BANNER APÓS O LOGIN (MOTD) ---
  users.motd = ''
    +=======================================================================+
    |               ⚠️  RESTRICTED ACCESS – MONITORED SYSTEM  ⚠️            |
    +=======================================================================+
    |                                                                       |
    |  [EN] Unauthorized access is strictly prohibited and monitored 24/7.  |
    |       All sessions are logged and may be used in legal proceedings.   |
    |                                                                       |
    |  [PT] Acesso não autorizado é estritamente proibido e monitorado.     |
    |       Todas as sessões são registradas e podem ser usadas em juízo.   |
    |                                                                       |
    |  [JP] 不正アクセスは厳重に禁止され、24時間体制で監視されています。              |
    |       すべてのセッションは記録され、法的措置に使用されることがあります。         |
    |                                                                       |
    |  [KR] 무단 접근은 엄격히 금지되며 24시간 모니터링됩니다.                        |
    |        모든 세션이 기록되며 법적 절차에 사용될 수 있습니다.                     |
    |                                                                       |
    |  [RU] Несанкционированный доступ строго запрещен и круглосуточно      |
    |        контролируется. Все сеансы регистрируются и могут быть         |
    |        использованы в судебных разбирательствах.                      |
    |                                                                       |
    |  [DE] Unbefugter Zugriff ist strengstens verboten und wird rund um    |
    |        die Uhr überwacht. Alle Sitzungen werden protokolliert und     |
    |        können vor Gericht verwendet werden.                           |
    |                                                                       |
    |  [FR] L'accès non autorisé est strictement interdit et surveillé 24h. |
    |        Toutes les sessions sont enregistrées et peuvent être utilisées|
    |        devant les tribunaux.                                          |
    |                                                                       |
    |  [ES] El acceso no autorizado está estrictamente prohibido y es       |
    |        monitoreado 24/7. Todas las sesiones son registradas y pueden  |
    |        utilizarse en procesos judiciales.                             |
    |                                                                       |
    |  [IT] L'accesso non autorizzato è severamente vietato e monitorato    |
    |        24/7. Tutte le sessioni vengono registrate e possono essere    |
    |        utilizzate in sede giudiziaria.                                |
    |                                                                       |
    |  [AR] الوصول غير المصرح به ممنوع منعاً باتاً ويتم مراقبته على مدار      |
    | الساعة. يتم تسجيل جميع الجلسات وقد تستخدم في الإجراءات القانونية  .    |
    |                                                                       |
    |  [ZH] 未经授权的访问被严格禁止，并受到全天候监控。                           |
    |        所有会话都会被记录，并可能用于法律程序。                              |
    |                                                                       |
    |  [TR] Yetkisiz erişim kesinlikle yasaktır ve 7/24 izlenmektedir.      |
    |        Tüm oturumlar kaydedilir ve yasal işlemlerde kullanılabilir.   |
    |                                                                       |
    |  [HI] अनधिकृत पहुंच सख्त वर्जित है और 24/7 निगरानी की जाती है।                      |
    |         सभी सत्र रिकॉर्ड किए जाते हैं और कानूनी कार्यवाही में उपयोग                      |
    |         किए जा सकते हैं।                                                  |
    |                                                                       |
    |  [HE] גישה לא מורשית אסורה בהחלט ומנוטרת 24/7. כל הפגישות מתועדות     |
    |         ועשויות לשמש בהליכים משפטיים.                                 |
    |                                                                       |
    |  [TH] การเข้าถึงโดยไม่ได้รับอนุญาตเป็นสิ่งต้องห้ามอย่างเคร่งครัดและ                           |
    |         มีการตรวจสอบตลอด 24 ชั่วโมง ทุกเซสชันจะถูกบันทึกและอาจใช้                      |
    |         ในกระบวนการทางกฎหมาย                                              |
    |                                                                       |
    |  [VI] Truy cập trái phép bị nghiêm cấm và được giám sát 24/7. Tất cả  |
    |         các phiên đều được ghi lại và có thể được sử dụng trong các   |
    |         thủ tục pháp lý.                                              |
    |                                                                       |
    +=======================================================================+
    |  Hostname: Darkflake                 |  Kernel: Linux  (Hardened)     |
    |  Sistema: NixOS 26.05 (Darkflake)   |  Todos os IPs são registrados   |
    +=======================================================================+
    |  ⚡  ATENÇÃO: Qualquer tentativa de invasão será relatada às          |
    |       autoridades competentes. Você está sendo monitorado.            |
    |       A atividade criminosa NÃO será tolerada.                        |
    +=======================================================================+
  '';

  # --- MENSAGEM ANTES DO LOGIN (TTY GREETING) ---
  services.getty.greetingLine = ''\n \O (\s \m \r) -  Darkflake   –  Acesso restrito.  '';
}
