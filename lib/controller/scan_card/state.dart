import 'package:get/get.dart';

class ScanCardState {
  final RxBool isLoading = false.obs;

  // Dial-code → ISO region map.
  // Ordered 3-digit → 2-digit → 1-digit so longer codes always win
  // (e.g. +880 matched before +8 would ever be tried).
  // Fallback regions tried in priority order when a number has no + prefix.
  // Only used for local/national numbers — international (+XX) numbers
  // skip this list and go directly to the detected region.
  static const List<String> fallbackRegions = [
    'IN', 'US', 'GB', 'AE', 'AU', 'CA',
    'SG', 'MY', 'NZ', 'ZA', 'PH', 'TH', 'ID', 'VN',
  ];

  static const List<String> businessTerms = [
    'address', 'street', 'road', 'city', 'state', 'zip',
    'phone', 'tel', 'fax', 'email', 'website', 'www', 'http',
    'pvt', 'ltd', 'inc', 'llc', 'corp', 'private', 'limited',
    'floor', 'building', 'office', 'tower', 'plaza', 'complex',
    'nagar', 'colony', 'sector', 'phase', 'block', 'survey',
    'services', 'solutions', 'mapping', 'civil', 'infra',
    'gis', 'remote', 'sensing', 'drone', 'lidar', 'dgps',
    'station', 'end-to-end', 'land', 'total',
    'technologies', 'technology', 'systems', 'system',
    'consulting', 'enterprises', 'industries', 'group',
    'company', 'works', 'agency', 'studio', 'labs', 'lab',
    'digital', 'media', 'creative', 'designs',
    'construction', 'builders', 'realty', 'properties', 'estates',
    'trading', 'exports', 'imports', 'logistics', 'transport',
    'motors', 'auto', 'electronics', 'electrical',
    'pharma', 'healthcare', 'medical', 'dental', 'clinic', 'hospital',
    'foods', 'beverages', 'textiles', 'garments',
    'jewellers', 'jewellery', 'furniture', 'interiors', 'interior',
    'exterior', 'architects', 'engineering',
    'manufacturers', 'distributors', 'retailers', 'wholesale',
    'designing', 'desinging', 'design', 'visualization', 'visualizations',
    '3d', 'planning', 'supervising', 'supervision', 'renovation',
    'decorat', 'modular', 'kitchen', 'wardrobe', 'cupboard',
    'false ceiling', 'painting', 'plumbing', 'carpentry',
    'flooring', 'tiling', 'contractor', 'contracting',
    'institute', 'institution', 'academy', 'school', 'college',
    'university', 'training', 'tally', 'online', 'coaching',
    'tuition', 'classes', 'centre', 'center',
  ];

  static const List<String> designations = [
    'manager', 'director', 'ceo', 'cto', 'cfo', 'coo',
    'president', 'vice president', 'vp',
    'head', 'lead', 'senior', 'junior',
    'executive', 'officer', 'engineer', 'developer', 'designer',
    'analyst', 'consultant', 'architect', 'specialist',
    'coordinator', 'administrator', 'assistant', 'associate',
    'supervisor', 'founder', 'co-founder', 'partner',
    'proprietor', 'owner', 'chairman', 'managing',
    'general', 'regional', 'national', 'global', 'chief', 'principal',
    'sales', 'marketing', 'finance', 'operations', 'technical',
    'software', 'hardware', 'business', 'product', 'project',
    'program', 'account', 'customer', 'client',
    'support', 'service', 'secretary', 'clerk',
    'trainee', 'intern', 'member', 'team',
  ];

  static const Map<String, String> dialCodeToRegion = {
    // 3-digit codes
    '+880': 'BD', '+886': 'TW', '+852': 'HK', '+853': 'MO',
    '+855': 'KH', '+856': 'LA', '+960': 'MV', '+961': 'LB',
    '+962': 'JO', '+963': 'SY', '+964': 'IQ', '+965': 'KW',
    '+966': 'SA', '+967': 'YE', '+968': 'OM', '+971': 'AE',
    '+972': 'IL', '+973': 'BH', '+974': 'QA', '+975': 'BT',
    '+976': 'MN', '+977': 'NP', '+992': 'TJ', '+993': 'TM',
    '+994': 'AZ', '+995': 'GE', '+996': 'KG', '+998': 'UZ',
    '+350': 'GI', '+351': 'PT', '+352': 'LU', '+353': 'IE',
    '+354': 'IS', '+355': 'AL', '+356': 'MT', '+357': 'CY',
    '+358': 'FI', '+359': 'BG', '+370': 'LT', '+371': 'LV',
    '+372': 'EE', '+373': 'MD', '+374': 'AM', '+375': 'BY',
    '+380': 'UA', '+381': 'RS', '+385': 'HR', '+386': 'SI',
    '+387': 'BA', '+420': 'CZ', '+421': 'SK',
    '+212': 'MA', '+213': 'DZ', '+216': 'TN', '+218': 'LY',
    '+233': 'GH', '+234': 'NG', '+254': 'KE', '+255': 'TZ',
    '+256': 'UG', '+260': 'ZM', '+263': 'ZW',
    '+501': 'BZ', '+502': 'GT', '+503': 'SV', '+504': 'HN',
    '+505': 'NI', '+506': 'CR', '+507': 'PA',
    '+591': 'BO', '+593': 'EC', '+595': 'PY', '+598': 'UY',
    // 2-digit codes
    '+20': 'EG', '+27': 'ZA',
    '+30': 'GR', '+31': 'NL', '+32': 'BE', '+33': 'FR',
    '+34': 'ES', '+36': 'HU', '+39': 'IT',
    '+40': 'RO', '+41': 'CH', '+43': 'AT', '+44': 'GB',
    '+45': 'DK', '+46': 'SE', '+47': 'NO', '+48': 'PL', '+49': 'DE',
    '+51': 'PE', '+52': 'MX', '+53': 'CU', '+54': 'AR',
    '+55': 'BR', '+56': 'CL', '+57': 'CO', '+58': 'VE',
    '+60': 'MY', '+61': 'AU', '+62': 'ID', '+63': 'PH',
    '+64': 'NZ', '+65': 'SG', '+66': 'TH',
    '+81': 'JP', '+82': 'KR', '+84': 'VN', '+86': 'CN',
    '+90': 'TR', '+91': 'IN', '+92': 'PK', '+93': 'AF',
    '+94': 'LK', '+95': 'MM', '+98': 'IR',
    '+7': 'RU',
    // 1-digit code (checked last)
    '+1': 'US',
  };
}
