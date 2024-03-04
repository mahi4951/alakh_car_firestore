class AboutDetails {
  String? aboutUsTitle;
  String? aboutImagePhoto;
  String? aboutDescription;
  String? myContactEmail;
  String? myContactPhoneChandubhai;
  String? myContactPhoneVijaybhai;
  String? myContactPhonePareshbhai;
  String? myContactPhoneNitinbhai;
  String? myContactAddress;
  String? myFacebookUrl;
  String? myInstagramUrl;
  String? myYoutubeUrl;

  AboutDetails(
      {this.aboutUsTitle,
      this.aboutImagePhoto,
      this.aboutDescription,
      this.myContactEmail,
      this.myContactPhoneChandubhai,
      this.myContactPhoneVijaybhai,
      this.myContactPhonePareshbhai,
      this.myContactPhoneNitinbhai,
      this.myContactAddress,
      this.myFacebookUrl,
      this.myInstagramUrl,
      this.myYoutubeUrl});

  AboutDetails.fromJson(Map<String, dynamic> json) {
    aboutUsTitle = json['about_us_title'];
    aboutImagePhoto = json['about_image_photo'];
    aboutDescription = json['about_description'];
    myContactEmail = json['my_contact_email'];
    myContactPhoneChandubhai = json['my_contact_phone_chandubhai'];
    myContactPhoneVijaybhai = json['my_contact_phone_vijaybhai'];
    myContactPhonePareshbhai = json['my_contact_phone_pareshbhai'];
    myContactPhoneNitinbhai = json['my_contact_phone_nitinbhai'];
    myContactAddress = json['my_contact_address'];
    myFacebookUrl = json['my_facebook_url'];
    myInstagramUrl = json['my_instagram_url'];
    myYoutubeUrl = json['my_youtube_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about_us_title'] = aboutUsTitle;
    data['about_image_photo'] = aboutImagePhoto;
    data['about_description'] = aboutDescription;
    data['my_contact_email'] = myContactEmail;
    data['my_contact_phone_chandubhai'] = myContactPhoneChandubhai;
    data['my_contact_phone_vijaybhai'] = myContactPhoneVijaybhai;
    data['my_contact_phone_pareshbhai'] = myContactPhonePareshbhai;
    data['my_contact_phone_nitinbhai'] = myContactPhoneNitinbhai;
    data['my_contact_address'] = myContactAddress;
    data['my_facebook_url'] = myFacebookUrl;
    data['my_instagram_url'] = myInstagramUrl;
    data['my_youtube_url'] = myYoutubeUrl;
    return data;
  }
}
