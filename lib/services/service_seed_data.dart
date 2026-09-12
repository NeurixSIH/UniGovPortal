import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';
import '../models/service_model.dart';
import 'department_service.dart';
import 'service_service.dart';

class ServiceSeedData {
  /// All 6 recommended departments
  static List<DepartmentModel> getDepartments() {
    final now = Timestamp.now();
    return [
      DepartmentModel(
        departmentId: 'DEPT_REVENUE',
        departmentName: 'Revenue Department',
        description:
            'Handles citizen identification certificates, domicile verification, income records, and land revenue administration.',
        logo: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=150',
        contactEmail: 'revenue@unigov.gov.in',
        contactNumber: '+917923250001',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      DepartmentModel(
        departmentId: 'DEPT_TRANSPORT',
        departmentName: 'Transport Department',
        description:
            'Manages motor vehicle regulations, driving licenses, learner permits, and road safety enforcement.',
        logo: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=150',
        contactEmail: 'transport@unigov.gov.in',
        contactNumber: '+917923250002',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      DepartmentModel(
        departmentId: 'DEPT_MUNICIPAL',
        departmentName: 'Municipal Corporation',
        description:
            'Urban local governance responsible for vital statistics registration (birth/death) and civic property taxes.',
        logo: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=150',
        contactEmail: 'municipal@unigov.gov.in',
        contactNumber: '+917923250003',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      DepartmentModel(
        departmentId: 'DEPT_LAND_RECORDS',
        departmentName: 'Land Records Department',
        description:
            'Administers land ownership registries, 7/12 extract documentation, survey numbers, and property cards.',
        logo: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=150',
        contactEmail: 'landrecords@unigov.gov.in',
        contactNumber: '+917923250004',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      DepartmentModel(
        departmentId: 'DEPT_AGRICULTURE',
        departmentName: 'Agriculture Department',
        description:
            'Empowers farmers with agricultural schemes, crop insurance, modern equipment subsidies, and rural support.',
        logo: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=150',
        contactEmail: 'agriculture@unigov.gov.in',
        contactNumber: '+917923250005',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      DepartmentModel(
        departmentId: 'DEPT_SOCIAL_WELFARE',
        departmentName: 'Social Welfare Department',
        description:
            'Promotes educational scholarships, disability support, pension schemes, and inclusive social security.',
        logo: 'https://images.unsplash.com/photo-1532619675605-1ede6c2ed2b0?w=150',
        contactEmail: 'welfare@unigov.gov.in',
        contactNumber: '+917923250006',
        status: DepartmentModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
    ];
  }

  /// All 14 recommended services across the 6 departments
  static List<ServiceModel> getServices() {
    final now = Timestamp.now();
    return [
      // 1. Revenue Department Services
      ServiceModel(
        serviceId: 'SRV_REVENUE_INCOME_CERT',
        departmentId: 'DEPT_REVENUE',
        serviceName: 'Income Certificate',
        description:
            'Official government certification of total annual household income for scholarships, fee concessions, and state welfare schemes.',
        category: 'Certificates & Revenue',
        requiredDocuments: [
          'Aadhaar Card',
          'Salary Slip / IT Return / Income Affidavit',
          'Ration Card',
          'Residential Proof (Electricity Bill / Rent Agreement)',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.mobileNumber',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'income.annualIncome',
          'income.sourceOfIncome',
          'category',
        ],
        eligibilityRules: [
          'Applicant must be a permanent resident of the state',
          'Valid proof of family income from competent authority or employer',
        ],
        processingTime: '7-10 Working Days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://digitalgujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_REVENUE_DOMICILE_CERT',
        departmentId: 'DEPT_REVENUE',
        serviceName: 'Domicile Certificate',
        description:
            'Proof of continuous residential status within the state for educational quotas, job reservations, and government benefits.',
        category: 'Certificates & Revenue',
        requiredDocuments: [
          'Aadhaar Card',
          'Continuous Residence Proof (10+ Years / School Leaving / Utility Bills)',
          'Voter ID Card',
          'Passport Size Photograph',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.dob',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'residentialYearsInState',
          'category',
        ],
        eligibilityRules: [
          'Minimum 10 consecutive years of residence in the state',
          'Valid residential address documents',
        ],
        processingTime: '7-10 Working Days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://digitalgujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_REVENUE_CASTE_CERT',
        departmentId: 'DEPT_REVENUE',
        serviceName: 'Caste Certificate',
        description:
            'Formal certificate validating SC, ST, SEBC/OBC, or EWS community background for statutory privileges and education.',
        category: 'Certificates & Revenue',
        requiredDocuments: [
          'Aadhaar Card',
          'School Leaving Certificate (indicating caste)',
          'Father or Relative Caste Certificate / Pedigree (Vanshavali)',
          'Ration Card',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.fatherName',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'category',
          'subCaste',
          'fatherCasteProofNumber',
        ],
        eligibilityRules: [
          'Caste/tribe must be listed under state or central reserved categories',
          'Genealogical evidence or father caste certificate is required',
        ],
        processingTime: '10-15 Working Days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://digitalgujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),

      // 2. Transport Department Services
      ServiceModel(
        serviceId: 'SRV_TRANSPORT_DRIVING_LICENCE',
        departmentId: 'DEPT_TRANSPORT',
        serviceName: 'Driving Licence Application',
        description:
            'Apply for a permanent motor vehicle driving licence (DL) after passing required biometric and driving test tracks.',
        category: 'Transport & Licensing',
        requiredDocuments: [
          'Valid Learner Licence',
          'Form 5 / Driving School Certificate (for Transport vehicles)',
          'Address Proof',
          'Medical Certificate (Form 1A if age > 40)',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.dob',
          'personalDetails.gender',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'age',
          'existingLearnerLicenceNumber',
          'vehicleClass',
        ],
        eligibilityRules: [
          'Must hold an active Learner Licence for at least 30 days and within 180 days',
          'Minimum age 18 for light motor vehicles (16 for gearless 50cc, 20 for commercial)',
        ],
        processingTime: '7-14 Working Days',
        fee: 300,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://parivahan.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_TRANSPORT_LEARNER_LICENCE',
        departmentId: 'DEPT_TRANSPORT',
        serviceName: 'Learner Licence',
        description:
            'Provisional 6-month driving license enabling learner driving practice under supervision upon passing the computer theory test.',
        category: 'Transport & Licensing',
        requiredDocuments: [
          'Aadhaar Card',
          'Age Proof (Birth Certificate / SSC Board Certificate / Passport)',
          'Address Proof',
          'Self Declaration Form 1',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.dob',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'age',
          'bloodGroup',
          'vehicleClass',
        ],
        eligibilityRules: [
          'Minimum age 16 for non-geared 50cc two-wheelers, 18 for light motor vehicles',
          'Passing of traffic signs & rules computer assessment',
        ],
        processingTime: '3-5 Working Days',
        fee: 150,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://parivahan.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_TRANSPORT_LICENCE_RENEWAL',
        departmentId: 'DEPT_TRANSPORT',
        serviceName: 'Licence Renewal',
        description:
            'Renewal application for expired or soon-to-expire driving licences to ensure legal road compliance.',
        category: 'Transport & Licensing',
        requiredDocuments: [
          'Original Expiring / Expired Driving Licence',
          'Medical Certificate Form 1A',
          'Aadhaar / Address Proof',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.dob',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'age',
          'existingLicenceNumber',
          'licenceExpiryDate',
        ],
        eligibilityRules: [
          'Driving Licence must be valid or within allowable renewal grace period',
          'Medical fitness certificate required if applicant is over 40 years old',
        ],
        processingTime: '5-7 Working Days',
        fee: 200,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://parivahan.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),

      // 3. Municipal Corporation Services
      ServiceModel(
        serviceId: 'SRV_MUNICIPAL_BIRTH_CERT',
        departmentId: 'DEPT_MUNICIPAL',
        serviceName: 'Birth Certificate',
        description:
            'Official civic registration and digital certificate issuance for newborns within municipal limits.',
        category: 'Civic & Vital Records',
        requiredDocuments: [
          'Hospital Discharge & Birth Report Slip',
          'Parents Aadhaar Cards',
          'Marriage Certificate of Parents',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'childName',
          'dateOfBirth',
          'gender',
          'placeOfBirthHospital',
          'fatherName',
          'motherName',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
        ],
        eligibilityRules: [
          'Birth must have occurred within municipal jurisdictional boundaries',
          'Registration within 21 days is free; delayed registration requires order',
        ],
        processingTime: '5-7 Working Days',
        fee: 30,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://crsorgi.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_MUNICIPAL_DEATH_CERT',
        departmentId: 'DEPT_MUNICIPAL',
        serviceName: 'Death Certificate',
        description:
            'Legal documentation recording the date, cause, and place of demise issued by the Municipal Registrar.',
        category: 'Civic & Vital Records',
        requiredDocuments: [
          'Medical Cause of Death Certificate from attending Doctor/Hospital',
          'Crematorium / Burial Ground Receipt',
          'Deceased Aadhaar / Identity Card',
          'Applicant Aadhaar / Relation Proof',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'deceasedFullName',
          'dateOfDeath',
          'placeOfDeath',
          'applicantRelationship',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
        ],
        eligibilityRules: [
          'Demise occurred within municipal municipal limits',
          'Applicant must be a legal heir or immediate family member',
        ],
        processingTime: '5-7 Working Days',
        fee: 30,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://crsorgi.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_MUNICIPAL_PROPERTY_TAX',
        departmentId: 'DEPT_MUNICIPAL',
        serviceName: 'Property Tax',
        description:
            'Assessment, bill retrieval, rebate calculation, and digital clearance of annual municipal property taxes.',
        category: 'Civic Taxes',
        requiredDocuments: [
          'Latest Municipal Property Tax Bill',
          'Property Ownership Document / Sale Deed / Index II',
          'Electricity Bill of Premise',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'personalDetails.mobileNumber',
          'propertyAssessmentNumber',
          'propertyType',
          'builtUpAreaSqFt',
          'address.line1',
          'address.city',
          'address.state',
          'address.pincode',
          'propertyData.tenementNo',
        ],
        eligibilityRules: [
          'Valid property assessment number registered in municipal records',
          'Clear property title or authorised occupier authorization',
        ],
        processingTime: '1-3 Working Days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://unigov.gov.in/municipal/property-tax',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),

      // 4. Land Records Department Services
      ServiceModel(
        serviceId: 'SRV_LAND_7_12_EXTRACT',
        departmentId: 'DEPT_LAND_RECORDS',
        serviceName: 'Land Record / 7/12 Extract',
        description:
            'Digitally certified RoR (Record of Rights) Form 7 and Form 12 displaying agricultural land ownership, survey numbers, crops, and loans.',
        category: 'Land & Revenue Records',
        requiredDocuments: [
          'Citizen Aadhaar / Identity Proof',
          'Previous Land Revenue Receipt or Mutation Entry Number',
        ],
        requiredFields: [
          'citizenId',
          'district',
          'taluka',
          'village',
          'surveyNumber',
          'khataNumber',
          'landOwnership',
          'propertyDetails',
        ],
        eligibilityRules: [
          'Survey number and Khata must exist in the digitised RoR database',
          'Applicant must provide matching land ownership or citizen ID',
        ],
        processingTime: '1-2 Working Days',
        fee: 25,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://anyror.gujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_LAND_PROPERTY_RECORD',
        departmentId: 'DEPT_LAND_RECORDS',
        serviceName: 'Property Record',
        description:
            'Official urban/rural property card (Form 8A / Property Card) detailing title deeds, encumbrances, and boundary ownership.',
        category: 'Land & Revenue Records',
        requiredDocuments: [
          'Citizen ID Card',
          'Registered Sale Deed / Title Certificate',
          'City Survey Map / Sanad Copy',
        ],
        requiredFields: [
          'citizenId',
          'citySurveyNumber',
          'wardNumber',
          'sheetNumber',
          'landOwnership',
          'propertyDetails.titleHolder',
          'propertyDetails.carpetArea',
        ],
        eligibilityRules: [
          'Property record registered with the Department of Land Records',
          'Valid citizen ID matching land title or power of attorney',
        ],
        processingTime: '2-5 Working Days',
        fee: 50,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://anyror.gujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),

      // 5. Agriculture Department Services
      ServiceModel(
        serviceId: 'SRV_AGRI_FARMER_SCHEME',
        departmentId: 'DEPT_AGRICULTURE',
        serviceName: 'Farmer Scheme Application',
        description:
            'Direct benefit transfer (DBT) income support and input assistance under central and state farmer schemes.',
        category: 'Agriculture & Schemes',
        requiredDocuments: [
          '7/12 & 8A Land Record Extract',
          'Aadhaar Card linked with Bank Account',
          'Bank Passbook / Cancelled Cheque',
          'Crop Sowing Affidavit / Talati Certificate',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'landOwnership.surveyNumber',
          'landOwnership.areaInHectares',
          'crop.sownSeason',
          'crop.cropType',
          'agriculturalArea',
          'bankAccountNumber',
          'ifscCode',
        ],
        eligibilityRules: [
          'Applicant must be a cultivating landholder farmer',
          'Bank account must be Aadhaar-seeded for DBT transactions',
        ],
        processingTime: '15-30 Working Days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://ikhedut.gujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_AGRI_SUBSIDY',
        departmentId: 'DEPT_AGRICULTURE',
        serviceName: 'Agriculture Subsidy',
        description:
            'Capital subsidies for modern micro-irrigation (drip/sprinkler), solar pump sets, tractors, and farm implements.',
        category: 'Agriculture & Schemes',
        requiredDocuments: [
          '7/12 Land Record Extract',
          'Authorised Equipment Dealer Quotation / Proforma Invoice',
          'Aadhaar Card',
          'Bank Passbook',
          'Electricity Connection Bill (for solar/irrigation)',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'landOwnership.khataNumber',
          'crop.principalCrop',
          'agriculturalArea',
          'equipmentType',
          'dealerQuotationAmount',
        ],
        eligibilityRules: [
          'Applicant farmer has not availed subsidy for same equipment in last 5 years',
          'Sufficient agricultural land area requirement per equipment guidelines',
        ],
        processingTime: '15-30 Working Days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://ikhedut.gujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),

      // 6. Social Welfare Department Services
      ServiceModel(
        serviceId: 'SRV_WELFARE_SCHOLARSHIP',
        departmentId: 'DEPT_SOCIAL_WELFARE',
        serviceName: 'Scholarship/Scheme Application',
        description:
            'Pre-matric and post-matric scholarship programs for meritorious students belonging to disadvantaged communities.',
        category: 'Social Welfare & Education',
        requiredDocuments: [
          'Caste Certificate',
          'Income Certificate',
          'Previous Academic Marksheet',
          'Fee Receipt / College Bonafide Certificate',
          'Student Aadhaar Card & Bank Passbook',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'category',
          'income.annualIncome',
          'age',
          'personalDetails.gender',
          'academic.institutionName',
          'academic.currentCourse',
          'academic.previousPercentage',
        ],
        eligibilityRules: [
          'Annual family income must be within the specified ceiling (e.g. <= ₹2,50,000)',
          'Applicant must maintain at least 50% passing marks in previous academic year',
        ],
        processingTime: '20-45 Working Days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://scholarships.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
      ServiceModel(
        serviceId: 'SRV_WELFARE_SCHEME',
        departmentId: 'DEPT_SOCIAL_WELFARE',
        serviceName: 'Welfare Scheme',
        description:
            'Financial support, elderly pension, widow assistance, and welfare allowances for vulnerable citizens.',
        category: 'Social Welfare & Schemes',
        requiredDocuments: [
          'Aadhaar Card',
          'Age Proof Certificate',
          'Income Certificate / BPL Card',
          'Bank Passbook Copy',
          'Disability / Medical Certificate (if applicable)',
        ],
        requiredFields: [
          'personalDetails.fullName',
          'category',
          'income.annualIncome',
          'age',
          'personalDetails.gender',
          'schemeType',
          'pensionOrDisabilityStatus',
        ],
        eligibilityRules: [
          'Meets scheme-specific age criteria (e.g. 60+ for old age pension)',
          'Household income below designated poverty or economic line',
        ],
        processingTime: '15-30 Working Days',
        fee: 0,
        applicationType: ServiceModel.applicationTypeOnline,
        externalUrl: 'https://digitalgujarat.gov.in',
        status: ServiceModel.statusActive,
        createdAt: now,
        updatedAt: now,
        createdBy: 'SYSTEM_ADMIN',
      ),
    ];
  }

  /// Seeds all departments and services to Firestore using the services singletons
  static Future<void> seedToFirestore() async {
    final deptService = DepartmentService();
    final srvService = ServiceService();

    // 1. Seed Departments
    final depts = getDepartments();
    for (final dept in depts) {
      await deptService.addDepartment(dept);
    }

    // 2. Seed Services
    final services = getServices();
    for (final service in services) {
      await srvService.addService(service);
    }
  }
}
