import 'package:quiz_app/models/question.dart';

const List<Question> physicsQuestions = [
  Question(
    question: 'What is the SI unit of force?',
    options: ['Joule', 'Newton', 'Pascal', 'Watt'],
    answer: 'Newton',
    note: 'The SI unit of force is Newton (N), named after Sir Isaac Newton.',
  ),
  Question(
    question: 'What is the speed of light in a vacuum?',
    options: [
      '3 × 10⁸ m/s',
      '3 × 10⁶ m/s',
      '3 × 10¹⁰ m/s',
      '3 × 10⁴ m/s',
    ],
    answer: '3 × 10⁸ m/s',
    note: 'The speed of light in vacuum is approximately 3 × 10⁸ m/s (299,792,458 m/s).',
  ),
  Question(
    question: 'Which law states that every action has an equal and opposite reaction?',
    options: [
      "Newton's First Law",
      "Newton's Second Law",
      "Newton's Third Law",
      "Hooke's Law",
    ],
    answer: "Newton's Third Law",
    note: "Newton's Third Law: every action has an equal and opposite reaction.",
  ),
  Question(
    question: 'What is the formula for kinetic energy?',
    options: ['½mv²', 'mv²', 'mgh', 'F×d'],
    answer: '½mv²',
    note: 'Kinetic Energy = ½mv², where m is mass and v is velocity.',
  ),
  Question(
    question: 'What is the unit of electrical resistance?',
    options: ['Ampere', 'Volt', 'Ohm', 'Coulomb'],
    answer: 'Ohm',
    note: 'The unit of electrical resistance is Ohm (Ω), named after Georg Ohm.',
  ),
  Question(
    question: 'What phenomenon causes a pencil to appear bent when placed in water?',
    options: ['Reflection', 'Refraction', 'Diffraction', 'Dispersion'],
    answer: 'Refraction',
    note: 'Refraction causes light to bend when it passes from one medium to another.',
  ),
  Question(
    question: 'What is the unit of frequency?',
    options: ['Watt', 'Hertz', 'Tesla', 'Kelvin'],
    answer: 'Hertz',
    note: 'The unit of frequency is Hertz (Hz), equal to one cycle per second.',
  ),
  Question(
    question: 'Which type of mirror is used in a car\'s rear-view mirror?',
    options: ['Concave', 'Convex', 'Plane', 'Parabolic'],
    answer: 'Convex',
    note: 'Convex mirrors are used in rear-view mirrors as they provide a wider field of view.',
  ),
  Question(
    question: 'What is the SI unit of pressure?',
    options: ['Newton', 'Pascal', 'Joule', 'Bar'],
    answer: 'Pascal',
    note: 'The SI unit of pressure is Pascal (Pa), equal to one Newton per square metre.',
  ),
  Question(
    question: 'What is absolute zero in Celsius?',
    options: ['-100°C', '-200°C', '-273.15°C', '-373.15°C'],
    answer: '-273.15°C',
    note: 'Absolute zero is -273.15°C (0 Kelvin), the lowest possible temperature.',
  ),
];
