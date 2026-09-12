// ============================================================================
// SIH26129 — Government Digital Platform Integration (Government of Maharashtra)
// Unified Government Services Portal / Government Interoperability Hub Data Store
// ============================================================================

const PORTAL_DATA = {
  // 1. Citizen Profile (Seeded from UIDAI Aadhaar + MahaBhumi + Municipal Registry)
  citizen: {
    id: "MH-CIT-2024-8921",
    fullName: "Krisha Rajesh Patel",
    aadhaarMasked: "XXXX-XXXX-4819",
    panMasked: "ABCDE****F",
    dob: "1992-08-14",
    age: 33,
    gender: "Female",
    mobile: "+91 98201 44819",
    email: "krisha.patel@gov.in",
    addressLine: "Flat 402, Shiv Shrushti Heights, Senapati Bapat Marg",
    city: "Pune",
    district: "Pune",
    state: "Maharashtra",
    pincode: "411016",
    incomeBracket: "₹2,50,000 - ₹5,00,000",
    annualIncomeNumber: 380000,
    category: "General / EWS",
    landOwnershipFlag: true,
    landDetails: {
      surveyNumber: "142/3A",
      taluka: "Baramati",
      district: "Pune",
      areaHectares: 2.4,
      holdingType: "Single Owner (Self-Cultivating)",
      cropType: "Sugarcane & Pulses",
      khataNumber: "KH-88219"
    },
    domicileDurationYears: 18,
    profileCompletionPct: 85,
    digilockerId: "DL-MH-99201",
    rationCardNumber: "MH-RC-091129",
    voterId: "MH/12/048/991201"
  },

  // 2. Connected Government Departments (Generic Schema)
  departments: [
    {
      id: "DEPT_PMC",
      code: "PMC",
      name: "Pune Municipal Corporation",
      stateName: "Government of Maharashtra",
      sector: "Civic & Urban Development",
      description: "Property tax, birth/death registry, water pipeline permissions, trade licenses, and ward planning.",
      logo: "🏛️",
      contactEmail: "commissioner@punecorporation.org",
      contactNumber: "+91 20 2550 1000",
      status: "ACTIVE",
      apiHealth: "99.94%",
      latencyMs: 38,
      lastSync: "2 mins ago",
      endpoint: "https://api.pmc.gov.in/v2/interop/bridge",
      recordsCount: 1420500,
      badgeColor: "#0284C7"
    },
    {
      id: "DEPT_REV",
      code: "REV",
      name: "Revenue & Forest Department",
      stateName: "Government of Maharashtra",
      sector: "Revenue & Land Administration",
      description: "Caste, Income, Domicile, Non-Creamy Layer certificates, solvency certification, and taluk administration.",
      logo: "📜",
      contactEmail: "secretary.revenue@maharashtra.gov.in",
      contactNumber: "+91 22 2202 5221",
      status: "ACTIVE",
      apiHealth: "99.88%",
      latencyMs: 44,
      lastSync: "1 min ago",
      endpoint: "https://mahasetu.maharashtra.gov.in/revenue/v1",
      recordsCount: 3890200,
      badgeColor: "#F58220"
    },
    {
      id: "DEPT_LAND",
      code: "LAND",
      name: "Land Records Department (MahaBhumi)",
      stateName: "Government of Maharashtra",
      sector: "Land Records & Cadastral",
      description: "Digital 7/12 Extract (Saat Bara Utara), 8A Property Ledger, Ferfar mutation, and GIS parcel boundaries.",
      logo: "🗺️",
      contactEmail: "dlr.pune@maharashtra.gov.in",
      contactNumber: "+91 20 2605 8291",
      status: "ACTIVE",
      apiHealth: "99.91%",
      latencyMs: 35,
      lastSync: "Just now",
      endpoint: "https://bhulekh.mahabhumi.gov.in/api/interop",
      recordsCount: 2950100,
      badgeColor: "#0D9488"
    },
    {
      id: "DEPT_BANK",
      code: "BANK",
      name: "State Banking Partner & DBT Cell",
      stateName: "Reserve Bank / State Level Bankers Committee",
      sector: "Banking & Financial Inclusion",
      description: "Aadhaar Payment Bridge (APBS), Direct Benefit Transfer (DBT) verification, and Kisan Credit accounts.",
      logo: "🏦",
      contactEmail: "dbt.nodal@slbconline.com",
      contactNumber: "+91 22 2282 4500",
      status: "ACTIVE",
      apiHealth: "99.98%",
      latencyMs: 29,
      lastSync: "4 mins ago",
      endpoint: "https://dbt.gov.in/api/apbs/v3/auth",
      recordsCount: 5410900,
      badgeColor: "#4F46E5"
    },
    {
      id: "DEPT_AGRI",
      code: "AGRI",
      name: "Department of Agriculture",
      stateName: "Government of Maharashtra",
      sector: "Agriculture & Rural Empowerment",
      description: "PM-KISAN, Magel Tyala Solar Krishi Pump, drip irrigation subsidy, and crop damage relief claims.",
      logo: "🌾",
      contactEmail: "commagri.mh@gov.in",
      contactNumber: "+91 20 2612 7074",
      status: "ACTIVE",
      apiHealth: "99.72%",
      latencyMs: 52,
      lastSync: "3 mins ago",
      endpoint: "https://krishi.maharashtra.gov.in/api/v1/bridge",
      recordsCount: 2180400,
      badgeColor: "#16A34A"
    }
  ],

  // 3. Government Service Catalog (Dynamic Generic Metadata)
  services: [
    {
      id: "SRV-REV-001",
      departmentId: "DEPT_REV",
      departmentName: "Revenue & Forest Department",
      name: "Domicile & Nationality Certificate",
      category: "Certificates",
      sector: "Revenue & Administration",
      description: "Statutory state domicile proof certifying minimum 15 years legal residence in the State of Maharashtra for higher education & public employment.",
      processingDays: 7,
      fee: 50,
      applicationType: "Full Scrutiny with Digital Signing",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)",
        "Proof of Residence (Electricity Bill / Property Tax)",
        "School Leaving Certificate (Birth / Domicile proof)"
      ],
      eligibilityRules: [
        { field: "domicileDurationYears", operator: ">=", value: 15, label: "Maharashtra Resident >= 15 Years" },
        { field: "age", operator: ">=", value: 18, label: "Applicant Minimum Age >= 18 Years" }
      ]
    },
    {
      id: "SRV-AGRI-002",
      departmentId: "DEPT_AGRI",
      departmentName: "Department of Agriculture",
      name: "Mukhyamantri Solar Krishi Pump Subsidy",
      category: "Agriculture",
      sector: "Renewable Energy & Farming",
      description: "Provides up to 90% state subsidy for off-grid 3HP/5HP DC solar water pumping sets for farmland irrigation without conventional power lines.",
      processingDays: 14,
      fee: 0,
      applicationType: "Cross-Department Interoperability Fast-Track",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)",
        "7/12 Land Record Extract (MahaBhumi)",
        "Bank Passbook with Aadhaar Linkage"
      ],
      eligibilityRules: [
        { field: "landOwnershipFlag", operator: "==", value: true, label: "Agricultural Land Ownership Verified" },
        { field: "areaHectares", operator: ">=", value: 1.0, label: "Farmland Area Minimum 1.0 Hectare" },
        { field: "annualIncomeNumber", operator: "<=", value: 800000, label: "Annual Household Income <= ₹8,00,000" }
      ]
    },
    {
      id: "SRV-REV-003",
      departmentId: "DEPT_REV",
      departmentName: "Revenue & Forest Department",
      name: "Income Certificate (Tahsildar Issue)",
      category: "Certificates",
      sector: "Social Welfare",
      description: "Official income assessment issued by Sub-Divisional Magistrate / Tahsildar for scholarship and EWS quota eligibility.",
      processingDays: 5,
      fee: 35,
      applicationType: "Self-Certification with Spot Verification",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)",
        "Salary Certificate / ITR / Form 16 / Talaathi Panchanama",
        "Ration Card Copy"
      ],
      eligibilityRules: [
        { field: "state", operator: "==", value: "Maharashtra", label: "State of Maharashtra Resident" }
      ]
    },
    {
      id: "SRV-LAND-004",
      departmentId: "DEPT_LAND",
      departmentName: "Land Records Department (MahaBhumi)",
      name: "Digitally Signed 7/12 Land Record Extract",
      category: "Land Records",
      sector: "Land Administration",
      description: "Certified legal land title document featuring QR code verification and cryptographic signature from MahaBhumi land register.",
      processingDays: 1,
      fee: 15,
      applicationType: "Instant Automated Digital Delivery",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)"
      ],
      eligibilityRules: [
        { field: "landOwnershipFlag", operator: "==", value: true, label: "Registered Land Holder in Maharashtra Cadastre" }
      ]
    },
    {
      id: "SRV-PMC-005",
      departmentId: "DEPT_PMC",
      departmentName: "Pune Municipal Corporation",
      name: "Property Tax Assessment & NOC Clearance",
      category: "Banking",
      sector: "Civic Services",
      description: "Verification of municipal property tax clearance and issuance of No-Dues Certificate for sale deed or building sanction.",
      processingDays: 3,
      fee: 0,
      applicationType: "Automated Municipal Cross-Check",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)",
        "Municipal Property Index II / Ward Number"
      ],
      eligibilityRules: [
        { field: "city", operator: "==", value: "Pune", label: "Property Situated within PMC Ward Jurisdiction" }
      ]
    },
    {
      id: "SRV-BANK-006",
      departmentId: "DEPT_BANK",
      departmentName: "State Banking Partner & DBT Cell",
      name: "Aadhaar-Seeded DBT Bank Account Validation",
      category: "Banking",
      sector: "Direct Benefit Transfer",
      description: "Live verification of NPCI mapper status and Aadhaar linkage with commercial bank account for public subsidy credits.",
      processingDays: 2,
      fee: 0,
      applicationType: "Instant Automated Interoperability Query",
      status: "ACTIVE",
      requiredDocuments: [
        "Aadhaar Card (UIDAI)",
        "Bank Passbook Front Page"
      ],
      eligibilityRules: [
        { field: "aadhaarMasked", operator: "!=", value: "", label: "Valid 12-Digit UIDAI Aadhaar Number" }
      ]
    }
  ],

  // 4. Dynamic Service Fields Configuration (Metadata Form Builder)
  serviceFields: {
    "SRV-AGRI-002": [
      {
        name: "citizenId",
        label: "Citizen Unique ID",
        type: "text",
        source: "PROFILE",
        required: true,
        order: 1,
        helpText: "Auto-populated from MahaSetu Citizen Dossier (Locked for integrity)."
      },
      {
        name: "fullName",
        label: "Applicant Full Name",
        type: "text",
        source: "PROFILE",
        required: true,
        order: 2,
        helpText: "Verified UIDAI Aadhaar Name."
      },
      {
        name: "surveyNumber",
        label: "Land Parcel Survey No.",
        type: "text",
        source: "DEPARTMENT_LAND",
        required: true,
        order: 3,
        helpText: "Pulled live from MahaBhumi Cadastral Registry via API."
      },
      {
        name: "areaHectares",
        label: "Cultivable Area (in Hectares)",
        type: "number",
        source: "DEPARTMENT_LAND",
        required: true,
        order: 4,
        helpText: "Verified from Digital 7/12 Extract."
      },
      {
        name: "bankAccountNumber",
        label: "Bank Account for DBT Subsidy",
        type: "text",
        source: "DEPARTMENT_BANK",
        required: true,
        order: 5,
        helpText: "Active Aadhaar-seeded account in State Level Bankers Committee."
      },
      {
        name: "pumpCapacityHp",
        label: "Requested Pump Capacity (HP)",
        type: "dropdown",
        options: ["3 HP DC Submersible", "5 HP DC Submersible", "7.5 HP AC Surface"],
        source: "USER_INPUT",
        required: true,
        order: 6,
        helpText: "Select pump specifications based on water table depth."
      },
      {
        name: "waterSourceType",
        label: "Existing Agricultural Water Source",
        type: "dropdown",
        options: ["Borewell (> 200 ft)", "Open Farm Well", "Canal / Perennial Stream", "Farm Pond (Shet-Tale)"],
        source: "USER_INPUT",
        required: true,
        order: 7,
        helpText: "Specify the water body to be connected to the solar pump."
      },
      {
        name: "agreeToTerms",
        label: "I agree to grant the Agriculture Dept access to live power generation telemetry.",
        type: "checkbox",
        source: "USER_INPUT",
        required: true,
        order: 8,
        helpText: "Mandatory under National Solar Mission guidelines."
      }
    ]
  },

  // 5. Citizen Documents Vault (DigiLocker Reusable Assets)
  documents: [
    {
      id: "DOC-AADHAAR-01",
      type: "Aadhaar Demographic Card",
      documentNumber: "XXXX-XXXX-4819",
      issuingDepartment: "UIDAI / Govt. of India",
      uploadedDate: "2024-01-12",
      expiryDate: "Life Time",
      status: "VERIFIED",
      fileSize: "1.2 MB",
      format: "PDF (DigiLocker Verified)",
      reusableCount: 8,
      verifiedBy: "UIDAI Bridge Engine (Automated)",
      previewText: "Aadhaar Card • Krisha Rajesh Patel • DOB: 14/08/1992 • Female • Maharashtra"
    },
    {
      id: "DOC-712-02",
      type: "Digital 7/12 Land Record Extract",
      documentNumber: "MH-BMT-142-3A",
      issuingDepartment: "Land Records Department (MahaBhumi)",
      uploadedDate: "2025-11-04",
      expiryDate: "2026-11-03",
      status: "VERIFIED",
      fileSize: "2.4 MB",
      format: "PDF (Digital Signature Valid)",
      reusableCount: 4,
      verifiedBy: "Tahsildar Baramati",
      previewText: "Village: Malegaon, Taluka: Baramati, Dist: Pune • Survey: 142/3A • Area: 2.40 Hectares"
    },
    {
      id: "DOC-INC-03",
      type: "Tahsildar Annual Income Certificate",
      documentNumber: "INC/MH/PN/2025/99812",
      issuingDepartment: "Revenue & Forest Department",
      uploadedDate: "2025-06-15",
      expiryDate: "2026-03-31",
      status: "VERIFIED",
      fileSize: "840 KB",
      format: "PDF (e-Seva Certified)",
      reusableCount: 6,
      verifiedBy: "Sub-Divisional Officer Pune",
      previewText: "Certified Gross Annual Household Income: ₹3,80,000 (Rupees Three Lakh Eighty Thousand)"
    },
    {
      id: "DOC-TAX-04",
      type: "Municipal Property Tax No-Dues Receipt",
      documentNumber: "PMC-PTAX-2025-8812",
      issuingDepartment: "Pune Municipal Corporation",
      uploadedDate: "2025-10-18",
      expiryDate: "2026-03-31",
      status: "VERIFIED",
      fileSize: "620 KB",
      format: "PDF (PMC Payment Portal)",
      reusableCount: 2,
      verifiedBy: "PMC Tax Assessment Ward 14",
      previewText: "Property No: PMC/W14/004921 • Assessment Year: 2025-26 • Dues Cleared: YES"
    },
    {
      id: "DOC-BANK-05",
      type: "Bank Passbook Front Page (Aadhaar Seeded)",
      documentNumber: "SBIN0001429-881249",
      issuingDepartment: "State Bank of India (DBT Verified)",
      uploadedDate: "2026-01-08",
      expiryDate: "N/A",
      status: "PENDING",
      fileSize: "1.8 MB",
      format: "PDF (Under Verification)",
      reusableCount: 1,
      verifiedBy: "Automated APBS Queue",
      previewText: "Account: 39182901482 • IFSC: SBIN0001429 • Branch: Pune Main • APBS Status: Active"
    }
  ],

  // 6. Citizen Applications Master Ledger
  applications: [
    {
      id: "MH-REV-2024-00892",
      serviceId: "SRV-REV-001",
      serviceName: "Domicile & Nationality Certificate",
      departmentId: "DEPT_REV",
      departmentName: "Revenue & Forest Department",
      sector: "Revenue & Administration",
      submittedDate: "2026-01-10T10:30:00Z",
      updatedDate: "2026-01-11T16:30:00Z",
      status: "APPROVED",
      estimatedDeliveryDate: "2026-01-17",
      officerName: "Priya Desai, Revenue Sub-Divisional Officer",
      officerRemarks: "Statutory residency verified through Municipal Ward records & 18-year voter ledger. Digital certificate issued.",
      timeline: [
        { stage: "Submitted", timestamp: "10 Jan 2026, 10:30 AM", detail: "Citizen submitted e-Application with DigiLocker verified enclosures.", role: "Citizen" },
        { stage: "Under Review", timestamp: "11 Jan 2026, 02:15 PM", detail: "Scrutiny Clerk validated domicile residency affidavits.", role: "Officer" },
        { stage: "Cross-Dept Verification", timestamp: "11 Jan 2026, 04:30 PM", detail: "Interoperability query to Pune Municipal Corporation returned Match (18 years resident).", role: "MahaSetu Hub" },
        { stage: "Approved", timestamp: "12 Jan 2026, 11:00 AM", detail: "Application sanctioned by SDO. Cryptographic seal affixed.", role: "Department Admin" }
      ],
      certificateUrl: "#view-certificate",
      submittedData: {
        birthPlace: "Pune, Maharashtra",
        residencePeriodYears: "18 Years",
        reasonForCertificate: "Higher Education & Professional Licensure",
        aadhaarVerified: true
      }
    },
    {
      id: "MH-AGRI-2026-01442",
      serviceId: "SRV-AGRI-002",
      serviceName: "Mukhyamantri Solar Krishi Pump Subsidy",
      departmentId: "DEPT_AGRI",
      departmentName: "Department of Agriculture",
      sector: "Agriculture & Rural",
      submittedDate: "2026-01-12T09:15:00Z",
      updatedDate: "2026-01-12T14:45:00Z",
      status: "UNDER_REVIEW",
      estimatedDeliveryDate: "2026-01-26",
      officerName: "Rajesh Shinde, Taluka Agriculture Officer",
      officerRemarks: "Application received via Setu Interoperability Hub. Land ownership and 7/12 extract verified against MahaBhumi.",
      timeline: [
        { stage: "Submitted", timestamp: "12 Jan 2026, 09:15 AM", detail: "Citizen submitted dynamic subsidy form with zero paper uploads.", role: "Citizen" },
        { stage: "Simulated Department API", timestamp: "12 Jan 2026, 09:16 AM", detail: "Data transmitted to Mahavitaran & Agriculture State Core API Bridge.", role: "MahaSetu Hub" },
        { stage: "Under Review", timestamp: "12 Jan 2026, 02:45 PM", detail: "Officer reviewing pump horsepower feasibility and borewell report.", role: "Department Admin" }
      ],
      certificateUrl: null,
      submittedData: {
        surveyNumber: "142/3A",
        taluka: "Baramati",
        areaHectares: 2.4,
        pumpCapacityHp: "5 HP DC Submersible",
        waterSourceType: "Borewell (> 200 ft)"
      }
    },
    {
      id: "MH-PMC-2025-00491",
      serviceId: "SRV-PMC-005",
      serviceName: "Property Tax Assessment & NOC Clearance",
      departmentId: "DEPT_PMC",
      departmentName: "Pune Municipal Corporation",
      sector: "Civic Services",
      submittedDate: "2025-11-14T11:20:00Z",
      updatedDate: "2025-11-17T15:10:00Z",
      status: "COMPLETED",
      estimatedDeliveryDate: "2025-11-17",
      officerName: "Sanjay Kulkarni, Ward Officer Ward 14",
      officerRemarks: "All municipal dues cleared up to FY 2025-26. NOC issued to citizen vault.",
      timeline: [
        { stage: "Submitted", timestamp: "14 Nov 2025, 11:20 AM", detail: "Citizen initiated property tax verification.", role: "Citizen" },
        { stage: "Approved", timestamp: "17 Nov 2025, 03:10 PM", detail: "NOC Clearance Certificate issued.", role: "Officer" }
      ],
      certificateUrl: "#view-noc",
      submittedData: {
        propertyIndex: "PMC/W14/004921",
        assessmentYear: "2025-26"
      }
    }
  ],

  // 7. DPDP Act 2023 Consent Management Registry
  consents: [
    {
      id: "CNS-PMC-01",
      departmentId: "DEPT_PMC",
      departmentName: "Pune Municipal Corporation",
      purpose: "Cross-departmental civic domicile assessment, municipal property tax verification & water connection validation.",
      requestedFields: ["Full Name", "Aadhaar Demographics", "Current Domicile Address", "Ward Number", "Property Index"],
      grantedDate: "2026-01-10",
      expiryDate: "2027-01-09",
      status: "ALLOWED",
      lastAccessTime: "2 hours ago",
      legalBasis: "Digital Personal Data Protection Act 2023, Section 6(1)"
    },
    {
      id: "CNS-LAND-02",
      departmentId: "DEPT_LAND",
      departmentName: "Land Records Department (MahaBhumi)",
      purpose: "Automated validation of 7/12 Land Title, Survey Parcel mapping and agricultural farmer status for state benefit schemes.",
      requestedFields: ["Citizen ID", "7/12 Extract Number", "Survey No", "Land Area (Ha)", "Holding Category"],
      grantedDate: "2026-01-10",
      expiryDate: "2027-01-09",
      status: "ALLOWED",
      lastAccessTime: "1 hour ago",
      legalBasis: "Digital Personal Data Protection Act 2023, Section 6(1)"
    },
    {
      id: "CNS-BANK-03",
      departmentId: "DEPT_BANK",
      departmentName: "State Banking Partner & DBT Cell",
      purpose: "Aadhaar Payment Bridge verification and secure direct credit of sanctioned agricultural & educational subsidies.",
      requestedFields: ["Bank Account No", "IFSC Code", "Aadhaar Seeded Status", "Annual Income Bracket"],
      grantedDate: "2026-01-10",
      expiryDate: "2027-01-09",
      status: "ALLOWED",
      lastAccessTime: "4 hours ago",
      legalBasis: "Aadhaar Act 2016 & DPDP Act 2023"
    },
    {
      id: "CNS-AGRI-04",
      departmentId: "DEPT_AGRI",
      departmentName: "Department of Agriculture",
      purpose: "Sanction of solar pump equipment, crop damage compensation audits and live pump telemetry monitoring.",
      requestedFields: ["Land Holding Details", "Crop Pattern", "Kisan Credit Card ID", "Mobile Number"],
      grantedDate: null,
      expiryDate: null,
      status: "PENDING_REQUEST",
      lastAccessTime: "Awaiting Citizen Approval",
      legalBasis: "DPDP Act 2023, Consent Notice Issued"
    }
  ],

  // 8. Live Cross-Department Synchronization Ledger
  syncEvents: [
    {
      id: "SYNC-89210",
      timestamp: "2026-01-12 14:45:12",
      citizenId: "MH-CIT-2024-8921",
      sourceDept: "Citizen Portal",
      targetDept: "Pune Municipal Corporation",
      service: "Profile Address Synchronization",
      fieldChanged: "Address Line 1",
      oldValue: "Flat 201, Shiv Shrushti, Senapati Bapat Marg",
      newValue: "Flat 402, Shiv Shrushti Heights, Senapati Bapat Marg",
      status: "SUCCESS",
      performedBy: "Krisha Patel (Citizen Authenticated)",
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    },
    {
      id: "SYNC-89209",
      timestamp: "2026-01-12 14:45:14",
      citizenId: "MH-CIT-2024-8921",
      sourceDept: "Pune Municipal Corporation",
      targetDept: "Land Records (MahaBhumi)",
      service: "Interoperability Ward Verification",
      fieldChanged: "Ward Residence Status",
      oldValue: "Unverified",
      newValue: "Verified Resident (Ward 14 Cleared)",
      status: "SUCCESS",
      performedBy: "PMC Bridge Worker #04",
      sha256Hash: "8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4"
    },
    {
      id: "SYNC-89208",
      timestamp: "2026-01-12 09:16:02",
      citizenId: "MH-CIT-2024-8921",
      sourceDept: "Land Records (MahaBhumi)",
      targetDept: "Department of Agriculture",
      service: "Mukhyamantri Solar Pump Scheme",
      fieldChanged: "Agricultural Land Area",
      oldValue: "Pending Ingestion",
      newValue: "2.40 Hectares (Baramati 142/3A)",
      status: "SUCCESS",
      performedBy: "MahaSetu Interop Engine",
      sha256Hash: "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"
    },
    {
      id: "SYNC-89207",
      timestamp: "2026-01-11 16:30:19",
      citizenId: "MH-CIT-2024-8921",
      sourceDept: "Revenue & Forest Department",
      targetDept: "DigiLocker Central Vault",
      service: "Domicile Certificate Issuance",
      fieldChanged: "Certificate Issuance State",
      oldValue: "UNDER_SCRUTINY",
      newValue: "ISSUED (MH-DOM-2026-88192)",
      status: "SUCCESS",
      performedBy: "Priya Desai (SDO Digital Sign)",
      sha256Hash: "2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae"
    }
  ],

  // 9. Citizen Notifications Center
  notifications: [
    {
      id: "NOTIF-01",
      type: "CONSENT_REQUEST",
      title: "Data Consent Requested: Department of Agriculture",
      message: "Agriculture & Farmers Welfare requested read access to your 7/12 Land Records (Baramati 142/3A) for the Mukhyamantri Solar Krishi Pump Scheme.",
      departmentName: "Department of Agriculture",
      timestamp: "10 mins ago",
      read: false,
      actions: [
        { label: "Allow Access", actionId: "ALLOW_AGRI_CONSENT", variant: "primary" },
        { label: "Deny", actionId: "DENY_AGRI_CONSENT", variant: "outline" }
      ]
    },
    {
      id: "NOTIF-02",
      type: "APPLICATION_STATUS",
      title: "Application Approved: Domicile Certificate",
      message: "Application MH-REV-2024-00892 has been Approved by Revenue Sub-Divisional Officer. Your digitally signed e-Certificate is now available in your Documents Vault.",
      departmentName: "Revenue & Forest Department",
      timestamp: "2 hours ago",
      read: false,
      actions: [
        { label: "View Certificate", actionId: "VIEW_CERTIFICATE", variant: "primary" }
      ]
    },
    {
      id: "NOTIF-03",
      type: "SYNC_CONFIRMATION",
      title: "Cross-Department Synchronization Completed",
      message: "Updated residential address synchronized across Pune Municipal Corporation and MahaBhumi Land Registry.",
      departmentName: "MahaSetu Hub",
      timestamp: "1 day ago",
      read: true,
      actions: [
        { label: "View Audit Log", actionId: "VIEW_AUDIT", variant: "outline" }
      ]
    }
  ],

  // 10. Department Admin Workstation State (Revenue / Agriculture)
  departmentAdmin: {
    officerId: "OFF-MH-REV-042",
    fullName: "Priya Subhash Desai",
    designation: "Sub-Divisional Officer & Scrutiny Magistrate",
    departmentId: "DEPT_REV",
    departmentName: "Revenue & Forest Department",
    jurisdiction: "Pune Sub-Division (Haveli & Baramati)",
    stats: {
      incomingToday: 142,
      underReview: 38,
      documentsRequired: 12,
      approvedToday: 88,
      rejectedToday: 4,
      avgTurnaroundDays: 3.2,
      slaTargetDays: 7.0,
      slaComplianceRate: "94.8%"
    }
  },

  // 11. System Admin State
  systemAdmin: {
    adminId: "SYS-ADMIN-001",
    fullName: "Dr. Arvind Chitre, IAS",
    designation: "Principal Secretary (Information Technology & Interoperability)",
    stats: {
      totalCitizensRegistered: "1,42,85,910",
      connectedDepartments: 5,
      liveEndpoints: 24,
      dailySyncTransactions: "1,84,200",
      apiGatewayUptime: "99.96%",
      activeDPDPConsents: "1,28,40,110"
    }
  }
};
