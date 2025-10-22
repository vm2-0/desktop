String getFaviconUrl(String? domain) {
  if (domain == null || domain.isEmpty) return '';
  final cleanDomain = domain.replaceAll(RegExp(r'^(https?:\/\/)?(www\.)?'), '');
  final encodedDomain = Uri.encodeComponent(cleanDomain);
  return 'https://www.google.com/s2/favicons?domain=$encodedDomain&sz=32';
}
