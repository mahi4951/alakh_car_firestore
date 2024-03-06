class ContactFormResponse {
  final String id;
  final String formId;
  final String name;
  final String email;
  final String company;
  final String telephone;
  final String message;
  final String inquiryFor;
  final String formType;

  ContactFormResponse({
    required this.id,
    required this.formId,
    required this.name,
    required this.email,
    required this.company,
    required this.telephone,
    required this.message,
    required this.inquiryFor,
    required this.formType,
  });

  factory ContactFormResponse.fromJson(Map<String, dynamic> json) {
    return ContactFormResponse(
      id: json['id'],
      formId: json['form_id'],
      name: json['data'][0]['param_val'],
      email: json['data'][1]['param_val'],
      company: json['data'][2]['param_val'],
      telephone: json['data'][3]['param_val'],
      message: json['data'][4]['param_val'],
      inquiryFor: json['data'][5]['param_val'],
      formType: json['data'][8]['param_val'],
    );
  }
}
