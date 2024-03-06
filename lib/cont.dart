import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController inquiryForController = TextEditingController();

  Future<void> _submitForm() async {
    const url = 'https://alakhcar.com/frontend/web/api/resources/contact';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'company': companyController.text,
        'telephone': telephoneController.text,
        'message': messageController.text,
        'Inquiry_for': inquiryForController.text,
        'form_id': '992a930268b633d9a2213f9149ad413b',
        '_csrf-frontend':
            'jojY75m35RdmQP_Mp5pQRALRsWvQ4EXNiiGwFUsp7Eb6pYHW-NWMeC8yvIb3yQQyeKfmUrXTcprsddEhOR-9cg==',
        'form_type': 'form-twig',
      },
    );
    if (response.statusCode == 200) {
      // Form submitted successfully
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
      // Clear form fields
      nameController.clear();
      emailController.clear();
      companyController.clear();
      telephoneController.clear();
      messageController.clear();
      inquiryForController.clear();
    } else {
      // Form submission failed
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Form submission failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              TextFormField(
                controller: telephoneController,
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
              TextFormField(
                controller: inquiryForController,
                decoration: const InputDecoration(labelText: 'Inquiry For'),
              ),
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your message.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
