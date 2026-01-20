// lib/core/constants/medical_constants.dart

/// Centralized constants for medical form lists (allergies, injuries, surgeries, blood groups).
class MedicalConstants {
  // Blood groups (used if you want to render chips from a single source)
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // Known allergies/options
  static const List<String> allergies = [
    'Lung conditions-including asthma',
    'Allergies to medication',
    'Eye/ear conditions',
    'Heart condition',
    'Recent hospitalization (last two years)',
    'Previous allergies',
    'Abdominal condition',
    'Kidney or urinary conditions',
    'Diabetic condition',
    'Convulsion due to fever',
    'Neurological conditions',
    'Skin conditions',
  ];

  // Past injuries
  static const List<String> pastInjuryTypes = [
    'Fracture',
    'Sprain',
    'Concussion',
    'Burn',
  ];

  // Surgeries
  static const List<String> surgeryTypes = [
    'Appendectomy',
    'Tonsillectomy',
    'Heart surgery',
  ];
}
