import 'dart:convert';

class BusinessSector {
  final int id;
  final String name;
  final String? nameKn;

  BusinessSector({
    required this.id,
    required this.name,
    this.nameKn,
  });

  factory BusinessSector.fromJson(Map<String, dynamic> json) {
    return BusinessSector(
      id: json['id'],
      name: json['name'],
      nameKn: json['name_kn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_kn': nameKn,
    };
  }
}

class DSPRegistration {
  final int id;
  final int applicationId;
  final String companyName;
  final String tin;
  final DateTime registrationDate;
  final int provinceId;
  final int districtId;
  final int sectorId;
  final int cellId;
  final int villageId;
  final String companyPhone;
  final String companyEmail;
  final String numberOfEmployees;
  final String? website;
  final String? companyDescription;
  final String representativeName;
  final String representativeEmail;
  final String representativePhone;
  final String representativePosition;
  final String representativeGender;
  final String representativePhysicalDisability;

  DSPRegistration({
    required this.id,
    required this.applicationId,
    required this.companyName,
    required this.tin,
    required this.registrationDate,
    required this.provinceId,
    required this.districtId,
    required this.sectorId,
    required this.cellId,
    required this.villageId,
    required this.companyPhone,
    required this.companyEmail,
    required this.numberOfEmployees,
    this.website,
    this.companyDescription,
    required this.representativeName,
    required this.representativeEmail,
    required this.representativePhone,
    required this.representativePosition,
    required this.representativeGender,
    required this.representativePhysicalDisability,
  });

  factory DSPRegistration.fromJson(Map<String, dynamic> json) {
    return DSPRegistration(
      id: json['id'],
      applicationId: json['application_id'],
      companyName: json['company_name'],
      tin: json['TIN'],
      registrationDate: DateTime.parse(json['registration_date']),
      provinceId: json['province_id'],
      districtId: json['district_id'],
      sectorId: json['sector_id'],
      cellId: json['cell_id'],
      villageId: json['village_id'],
      companyPhone: json['company_phone'],
      companyEmail: json['company_email'],
      numberOfEmployees: json['number_of_employees'],
      website: json['website'],
      companyDescription: json['company_description'],
      representativeName: json['representative_name'],
      representativeEmail: json['representative_email'],
      representativePhone: json['representative_phone'],
      representativePosition: json['representative_position'],
      representativeGender: json['representative_gender'],
      representativePhysicalDisability: json['representative_physical_disability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_id': applicationId,
      'company_name': companyName,
      'TIN': tin,
      'registration_date': registrationDate.toIso8601String(),
      'province_id': provinceId,
      'district_id': districtId,
      'sector_id': sectorId,
      'cell_id': cellId,
      'village_id': villageId,
      'company_phone': companyPhone,
      'company_email': companyEmail,
      'number_of_employees': numberOfEmployees,
      'website': website,
      'company_description': companyDescription,
      'representative_name': representativeName,
      'representative_email': representativeEmail,
      'representative_phone': representativePhone,
      'representative_position': representativePosition,
      'representative_gender': representativeGender,
      'representative_physical_disability': representativePhysicalDisability,
    };
  }
}

class Application {
  final int id;
  final int clientId;
  final String status;
  final int currentStep;
  final String bio;
  final bool verificationRequested;
  final List<BusinessSector> businessSectors;
  final DSPRegistration dspRegistration;

  Application({
    required this.id,
    required this.clientId,
    required this.status,
    required this.currentStep,
    required this.bio,
    required this.verificationRequested,
    required this.businessSectors,
    required this.dspRegistration,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    var businessSectorList = json['business_sectors'] as List;
    List<BusinessSector> businessSectors = businessSectorList.map((i) => BusinessSector.fromJson(i)).toList();

    return Application(
      id: json['id'],
      clientId: json['client_id'],
      status: json['status'],
      currentStep: json['current_step'],
      bio: json['bio'],
      verificationRequested: json['verification_requested'],
      businessSectors: businessSectors,
      dspRegistration: DSPRegistration.fromJson(json['dsp_registration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'status': status,
      'current_step': currentStep,
      'bio': bio,
      'verification_requested': verificationRequested,
      'business_sectors': businessSectors.map((e) => e.toJson()).toList(),
      'dsp_registration': dspRegistration.toJson(),
    };
  }
}

class BusinessDirectoriesModel {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;
  final String? verifiedAt;
  final String phone;
  final String otp;
  final int registrationTypeId;
  final String? profilePhoto;
  final String nameSlug;
  final String? documentVectors;
  final bool allowNotificationSound;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String expiresAt;
  final String? memberId;
  final String status;
  final int ratingsCount;
  final String? ratingsSumRating;
  final String profilePhotoUrl;
  final String defaultPhotoUrl;
  final String typeName;
  final String clientName;
  final Application application;
  final RegistrationType registrationType;

  BusinessDirectoriesModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
    required this.phone,
    required this.otp,
    required this.registrationTypeId,
    this.profilePhoto,
    required this.nameSlug,
    this.documentVectors,
    required this.allowNotificationSound,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.expiresAt,
    this.memberId,
    required this.status,
    required this.ratingsCount,
    this.ratingsSumRating,
    required this.profilePhotoUrl,
    required this.defaultPhotoUrl,
    required this.typeName,
    required this.clientName,
    required this.application,
    required this.registrationType,
  });

  factory BusinessDirectoriesModel.fromJson(Map<String, dynamic> json) {
    return BusinessDirectoriesModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      verifiedAt: json['verified_at'],
      phone: json['phone'],
      otp: json['otp'],
      registrationTypeId: json['registration_type_id'],
      profilePhoto: json['profile_photo'],
      nameSlug: json['name_slug'],
      documentVectors: json['document_vectors'],
      allowNotificationSound: json['allow_notification_sound'],
      isActive: json['is_active'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      expiresAt: json['expires_at'],
      memberId: json['member_id'],
      status: json['status'],
      ratingsCount: json['ratings_count'],
      ratingsSumRating: json['ratings_sum_rating'],
      profilePhotoUrl: json['profile_photo_url'],
      defaultPhotoUrl: json['defaultPhotoUrl'],
      typeName: json['typeName'],
      clientName: json['clientName'],
      application: Application.fromJson(json['application']),
      registrationType: RegistrationType.fromJson(json['registration_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'verified_at': verifiedAt,
      'phone': phone,
      'otp': otp,
      'registration_type_id': registrationTypeId,
      'profile_photo': profilePhoto,
      'name_slug': nameSlug,
      'document_vectors': documentVectors,
      'allow_notification_sound': allowNotificationSound,
      'is_active': isActive,
      'first_name': firstName,
      'last_name': lastName,
      'expires_at': expiresAt,
      'member_id': memberId,
      'status': status,
      'ratings_count': ratingsCount,
      'ratings_sum_rating': ratingsSumRating,
      'profile_photo_url': profilePhotoUrl,
      'defaultPhotoUrl': defaultPhotoUrl,
      'typeName': typeName,
      'clientName': clientName,
      'application': application.toJson(),
      'registration_type': registrationType.toJson(),
    };
  }
}

class RegistrationType {
  final int id;
  final String name;

  RegistrationType({
    required this.id,
    required this.name,
  });

  factory RegistrationType.fromJson(Map<String, dynamic> json) {
    return RegistrationType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

